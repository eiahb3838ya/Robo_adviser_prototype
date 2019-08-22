import numpy as np
import pandas as pd

import requests
from pandas_datareader import data as web
import datetime as dt
import yfinance as yf
from rpy2 import robjects
from rpy2.robjects import r, pandas2ri


yf.pdr_override()
def get_stock_list():
    payload = {}
    response = requests.post("http://www.xiqicapital.com/FUT/Api/Market/QryStocList2", params=payload)
    response_dic = response.json()
    stock_list_df = pd.DataFrame(response_dic['GridData'])
    stock_id = stock_list_df['STOCK_ID']
    return(stock_list_df,stock_id)

def get_history_data(target,startdate = "2015/01/01",enddate= dt.date.today().strftime("%Y/%m/%d")):
    readData_df = pd.DataFrame()
    startDownloadDate = "2015/01/01"
    todayDate = dt.date.today().strftime("%Y/%m/%d")
    try:
        readData_df = pd.read_pickle("./history_price.pkl")
    except Exception as e:
        print(str(e))
    lastBDate = pd.bdate_range(end=todayDate, periods=1, freq='B')[0]

    if len(readData_df) != 0:
        lastHDate = readData_df.index.max()
    else:
        print("there is no history_price.pkl")
        result_df = load_history_data_from_api('all', startDownloadDate, todayDate)
        result_df.to_pickle("./history_price.pkl")
        if target == 'all':
            return (result_df.loc[startdate:enddate])
        else:
            select_code_result = result_df.loc[result_df['STOCK_CODE'] == target[0:4]]
            select_date_result = select_code_result.loc[startdate:enddate]
            return (select_date_result)
    if False:#np.datetime64(lastHDate) < np.datetime64(lastBDate) - np.timedelta64(1, 'D'):
        print("history_price.pkl is not in latest update")
        print("lastHDate", lastHDate, "lastBDate", np.datetime64(lastBDate) - np.timedelta64(1, 'D'))
        result_df = load_history_data_from_api('all', startDownloadDate, todayDate)
        result_df.to_pickle("./history_price.pkl")
        if target == 'all':
            return (result_df.loc[startdate:enddate])
        else:
            select_code_result = result_df.loc[result_df['STOCK_CODE'] == target[0:4]]
            select_date_result = select_code_result.loc[startdate:enddate]
            return (select_date_result)
    else:
        print("history_price.pkl is in latest update")
        if target == 'all':
            return (readData_df.loc[startdate:enddate])
        else:
            select_code_result = readData_df.loc[readData_df['STOCK_CODE'] == target[0:4]]
            select_date_result = select_code_result.loc[startdate:enddate]
            return (select_date_result)

def load_history_data_from_api(target,startdate,enddate):
    if len(target) >= 4 :
        print(target)
        payload = {'STOCK_ID': target[0:4], 'KLINE_PERIOD': 'DAY', 'KLINE_DATETIME_S': startdate,
               'KLINE_DATETIME_E': enddate}

    elif target == 'all':
        # _,listsss=get_stock_list()
        # listsss=listsss[0:10].append('2330')
        # print(listsss)
        listsss=[]
        payload = {'KLINE_PERIOD': 'DAY', 'KLINE_DATETIME_S': startdate,
                   'KLINE_DATETIME_E': enddate}
    response = requests.post("http://www.xiqicapital.com/FUT/Api/Market/QryStockPrice2", params=payload)
    response_dic = response.json()
    result_df = pd.DataFrame.from_dict(response_dic['GridData'])
    result_df = result_df.set_index("KLINE_DATETIME")
    result_df = result_df.drop(axis=0, columns=["KLINE_PERIOD"])
    result_df.columns = ['Close', 'High', 'Low', 'Open', "STOCK_CODE", 'Volume']
    result_df = result_df[["STOCK_CODE", 'Close', 'High', 'Low', 'Open', 'Volume']]
    result_df[['Close', 'High', 'Low', 'Open', 'Volume']] = result_df[
        ['Close', 'High', 'Low', 'Open', 'Volume']].astype(float)
    result_df.index = pd.DatetimeIndex(result_df.index.rename("Date"))
    return(result_df)


def getCumRet_Drawdowns(strategyRet_df):
    print("get CumRet and Drawdowns")
    # close the warning
    r.options(warn=-1)
    pandas2ri.activate()
    # prepare data type for r code
    strategyRet_ri = pandas2ri.py2ri(strategyRet_df)
    strategyRet_DT = r('as.data.table')(strategyRet_ri)

    # call r file
    r("setwd('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0')")
    r("source('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0/source_server.R', local = TRUE)")

    # get the r functions
    getCumRet_DT = r['getCumRet_DT']
    getDrawdowns = r['getDrawdowns']

    # use r function
    strategyCumRet_DT = getCumRet_DT(strategyRet_DT)
    strategyDrawdowns_DT = getDrawdowns(strategyRet_DT)

    # transform to python object
    strategyCumRet = pandas2ri.ri2py_dataframe(strategyCumRet_DT)
    strategyDrawdowns = pandas2ri.ri2py_dataframe(strategyDrawdowns_DT)

    return(strategyCumRet,strategyDrawdowns)




def roical(buyprice, sellprice, winRate):
    roi = (float(sellprice)-float(buyprice))/float(buyprice)
    if roi>0:
        winRate +=1
    return(roi,winRate)


def winfactor(buyprice, sellprice, loss, win):
    payoff = float(sellprice)-float(buyprice)
    if payoff >=0:
        win +=payoff
    else:
        loss-=payoff
    return(loss,win)


if __name__ == "__main__":
    result_df = get_history_data("all")
    print(result_df.index[-1])


import numpy as np
import pandas as pd
import requests
from pandas_datareader import data as web
import datetime as dt
import yfinance as yf

yf.pdr_override()
def get_stock_list():
    payload = {}
    response = requests.post("http://www.xiqicapital.com/FUT/Api/Market/QryStocList2", params=payload)
    response_dic = response.json()
    stock_list_df = pd.DataFrame(response_dic['GridData'])
    stock_id = stock_list_df['STOCK_ID']
    return(stock_list_df,stock_id)

def get_history_data(target,startdate= dt.datetime(2015, 1, 1),enddate= dt.datetime(2020, 1, 1)):
    try:
        payload = {'STOCK_ID': target[:4], 'KLINE_PERIOD': 'DAY', 'KLINE_DATETIME_S': '2015/01/01 00:00:00',
                   'KLINE_DATETIME_E': '2020/01/01 12:00:00'}
        response = requests.post("http://www.xiqicapital.com/FUT/Api/Market/QryStockPrice2", params=payload)
        response_dic = response.json()
        result_df = pd.DataFrame.from_dict(response_dic['GridData'])
        result_df = result_df.set_index("KLINE_DATETIME")
        result_df = result_df.drop(axis=0, columns=["STOCK_ID", "KLINE_PERIOD"]).astype(float)
        result_df.columns = ['Close', 'High', 'Low', 'Open', 'Volume']
        result_df.index = pd.DatetimeIndex(result_df.index.rename("Date"))
    except:
        result_df = web.get_data_yahoo([target], startdate, enddate)
    return(result_df)


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
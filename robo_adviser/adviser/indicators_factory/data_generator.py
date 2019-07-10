import numpy as np
import pandas as pd
import requests
from pandas_datareader import data as web
import datetime as dt
import yfinance as yf

yf.pdr_override()

def get_history_data(target,startdate= dt.datetime(2015, 1, 1),enddate= dt.datetime(2020, 1, 1)):
    # 1476	儒鴻
    # 2317	鴻海
    # 2327	國巨
    # 2330	台積電
    # 2448	晶電
    # 2454	聯發科
    # 2455	全新
    # 2474	可成
    # 2492	華新科
    # 2498	宏達電
    # 3019	亞光
    # 3037	欣興
    # 3406	玉晶光
    # 3443	創意電子
    # 6153	嘉聯益
    print("get_history_data", target)
    can_call_api = ["1476", "2317", "2327", "2330", "2448", "2454", "2455", "2474", "2492",
                    "2498", "3019", "3037", "3406", "3443", "6153"]
    can_call_api = [codestr + ".TW" for codestr in can_call_api]
    if (target in can_call_api):
        payload = {'STOCK_ID': target[:4], 'KLINE_PERIOD': 'DAY', 'KLINE_DATETIME_S': '2019/05/08 09:10:00',
                   'KLINE_DATETIME_E': '2020/01/01 12:00:00'}
        response = requests.post("http://www.xiqicapital.com/FUT/Api/Market/QryStockPrice", params=payload)
        response_dic = response.json()
        result_df = pd.DataFrame.from_dict(response_dic['GridData'])
        result_df = result_df.set_index("KLINE_DATETIME")
        result_df = result_df.drop(axis=0, columns=["STOCK_ID", "KLINE_PERIOD"]).astype(float)
        result_df.columns = ['Close', 'High', 'Low', 'Open', 'Volume']
        result_df.index = pd.DatetimeIndex(result_df.index.rename("Date"))

        print("result_df", result_df)
    else:
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
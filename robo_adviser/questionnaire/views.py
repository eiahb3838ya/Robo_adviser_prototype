from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView
# Create your views here.
# from robo_adviser.adviser.indicators_factory.data_generator import get_history_data

from pandas_datareader import data as web
import datetime as dt
import yfinance as yf
import requests
import pandas as pd

yf.pdr_override()
# some how i cant do from robo_adviser.adviser.indicators_factory.data_generator import get_history_data
# to be solved
# https://stackoverflow.com/questions/46444135/how-to-import-models-from-one-app-to-another-app-in-django
def get_history_data(target,startdate= dt.datetime(2015, 1, 1),enddate= dt.datetime(2020, 1, 1)):
    print("get_history_data", target)
    can_call_api = ["1476", "2317", "2327", "2330", "2448", "2454", "2455", "2474", "2492",
                    "2498", "3019", "3037", "3406", "3443", "6153"]
    can_call_api = [codestr + ".TW" for codestr in can_call_api]
    if (target in can_call_api):
        print("call mark web api")
        payload = {'STOCK_ID': target[:4], 'KLINE_PERIOD': 'DAY', 'KLINE_DATETIME_S': '2019/05/08 09:10:00',
                   'KLINE_DATETIME_E': '2020/01/01 12:00:00'}
        response = requests.post("http://www.xiqicapital.com/FUT/Api/Market/QryStockPrice", params=payload)
        response_dic = response.json()
        result_df = pd.DataFrame.from_dict(response_dic['GridData'])
        result_df = result_df.set_index("KLINE_DATETIME")
        result_df = result_df.drop(axis=0, columns=["STOCK_ID", "KLINE_PERIOD"]).astype(float)
        result_df.columns = ['Close', 'High', 'Low', 'Open', 'Volume']
        result_df.index = pd.DatetimeIndex(result_df.index.rename("Date"))
    else:
        print("call yahoo finance")
        result_df = web.get_data_yahoo([target], startdate, enddate)
    return (result_df)



def start(request):
    return(render(request,'enter_questionnaire.html'))

def form1(request):
    stock_list=[ "1476","2317","2327","2330","2448","2454", "2455","2474","2492",
                 "2498","3019","3037","3406","3443","6153"]
    stock_list= [strr+".TW" for strr in stock_list]
    context={
        "stock_list":stock_list,
    }
    return(render(request, "form1.html",context))

def form2(request):
    return(render(request, "form2.html"))


class TargetChartData(APIView):
    def get(self, request, format = None):
        user_picked = request.GET['user_picked']
        df = get_history_data(user_picked)
        article_data=df.index
        article_labels=df.Close
        print("user_picked in web api:",user_picked)
        data={
            "article_data" : article_data,
            "article_labels" : article_labels
        }
        return(Response(data))
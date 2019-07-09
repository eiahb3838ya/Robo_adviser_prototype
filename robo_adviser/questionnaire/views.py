from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView
# Create your views here.
# from robo_adviser.adviser.indicators_factory import data_generator

from pandas_datareader import data as web
import datetime as dt
import yfinance as yf

yf.pdr_override()
def get_history_data(target,startdate= dt.datetime(2015, 1, 1),enddate= dt.datetime(2020, 1, 1)):
    result_df = web.get_data_yahoo([target], startdate, enddate)
    return(result_df)

def start(request):
    return(render(request,'enter_questionnaire.html'))

def form1(request):
    stock_list=["1216" ,"1229", "1233" ,"1434" ,"1455", "1463", "1522", "1722", "2027", "2330", "2347", "2356", "2382", "2441", "2474", "2489",
    "2498", "2888", "2912", "3481", "6115", "6189", "9933"]
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
        print(user_picked)
        data={
            "article_data" : article_data,
            "article_labels" : article_labels
        }
        return(Response(data))
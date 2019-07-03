from django.shortcuts import render,HttpResponse
from .indicators_factory import data_generator,SMAWMA,BBandMA
from rest_framework.response import Response
from rest_framework.views import APIView
# Create your views here.

def start(request):
    selected_stock = request.GET['stockpicker']
    stock_options=["2330.TW", "0050.TW", "2207.TW"]
    return(render(request,'enter_adviser.html',locals()))

def strategy_bbandma(request):
    try:
        user_picked = request.GET['stockpicker']
    except:
        print("rrrrrr")
    # get the history price with yahoo finance
    target_price_df = data_generator.get_history_data(user_picked)
    # call BBand
    df, count, acmroi, winnum, winfact = BBandMA.main(target_price_df)

    return (HttpResponse(df.to_html()))

def strategy_smawma(request):
    try:
        user_picked = request.GET['stockpicker']
    except:
        print("rrrrrr")
    str1=""
    count = 0
    acmroi = 0
    winrate = 0
    winvar = 0
    # get the history price with yahoo finance
    target_price_df = data_generator.get_history_data(user_picked)
    # call smawma
    df,count,acmroi,winnum,winvar=SMAWMA.main(target_price_df,count,acmroi,winrate,winvar)

    return(HttpResponse(df.to_html()))

def debuger_result1(request):
    values = request.GET.getlist(u'target_strategy')
    return (render(request, 'result1.html', locals()))


class TargetChartData(APIView):
    def get(self, request, format = None):
        user_picked = request.GET['user_picked']
        df = data_generator.get_history_data(user_picked)
        article_data=df.index
        article_labels=df.Close
        data={
            "article_data" : article_data,
            "article_labels" : article_labels
        }
        return(Response(data))

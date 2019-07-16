from django.shortcuts import render,HttpResponse
from .indicators_factory import data_generator,SMAWMA,BBandMA,strategy_from_r,MACD
from rest_framework.response import Response
from rest_framework.views import APIView
import json
# Create your views here.

def start(request):
    return(render(request,'enter_adviser.html',locals()))

def smawma_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("request.GET['stockpicker'] failed")
    context = {
        "selected_target": selected_target,
        "selected_strategy": "smawma",
    }
    return(render(request,"single_target_result_using_ajax.html", context))

def bbandma_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("request.GET['stockpicker'] failed")
    context = {
        "selected_target": selected_target,
        "selected_strategy": "bbandma",
    }
    return(render(request,"single_target_result_using_ajax.html", context))

def r_strategy_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("error")
    return (render(request, 'r_strategy_result.html', locals()))


def macd_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'macd'
    except:
        print("error")
    return (render(request, 'macd_result.html', locals()))


def debuger_result1(request):
    values = request.GET.getlist(u'target_strategy')
    return (render(request, 'result1.html', locals()))





class StrategyFromRReturnData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        print(selected_target)

        data_dict = strategy_from_r.main(selected_target)

        print("data_dict", data_dict)
        return( Response( data_dict ) )

class StrategyMACDReturnData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        data_dict = MACD.main(selected_target)
        # 還需要調整取出之後的東西，放進 macd_result
        print("data_dict", data_dict)
        return( Response( data_dict ) )

class StrategySMAWMATableData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        print(selected_target)
        str1 = ""
        count = 0
        acmroi = 0
        winrate = 0
        winvar = 0
        # get the history price with yahoo finance
        target_price_df = data_generator.get_history_data(selected_target)
        # call smawma
        df, count, acmroi, winnum, winvar = SMAWMA.main(target_price_df, count, acmroi, winrate, winvar)

        # some adjust for to_json properly
        df = df.reset_index()
        df_to_display = df.drop(axis=0, columns=['Open', 'High', 'Low'])
        dates = df_to_display.Date
        df_to_display['Date'] = dates.apply(lambda x: x.strftime('%Y-%m-%d'))
        df_to_display = df_to_display.fillna('')

        # prepare data for js
        selected_target = selected_target

        result_table_dict = df_to_display.to_dict(orient='records')
        result_table_json = df_to_display.to_json(orient='records')
        columns = [{'field': f, 'title': f} for f in df_to_display.columns]
        columns_json = json.dumps(columns)
        data = {
            "selected_target": selected_target,
            "selected_strategy": "smawma",
            "result_table_dict": result_table_dict,
            "result_table_json":result_table_json,
            "columns": columns,
        }
        return( Response( data ) )
class StrategyBBandMATableData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        # print(selected_target)

        # get the history price with yahoo finance
        target_price_df = data_generator.get_history_data(selected_target)
        # call BBand
        df, count, acmroi, winnum, winfact = BBandMA.main(target_price_df)

        # some adjust for to_json properly
        df = df.reset_index()
        df_to_display = df.drop(axis=0, columns=['Open', 'High', 'Low', 'BBupper', 'BBlower'])
        dates = df_to_display.Date
        df_to_display['Date'] = dates.apply(lambda x: x.strftime('%Y-%m-%d'))

        df_to_display = df_to_display.fillna('')

        # prepare data for js
        selected_target = selected_target
        result_table_dict = df_to_display.to_dict(orient='records')
        result_table_json = df_to_display.to_json(orient='records')
        columns = [{'field': f, 'title': f} for f in df_to_display.columns]
        columns_json = json.dumps(columns)
        data = {
            "selected_target": selected_target,
            "selected_strategy": "bbandma",
            "result_table_dict": result_table_dict,
            "result_table_json": result_table_json,
            "columns": columns,
            "columns_json": columns_json
        }
        return( Response( data ) )

from ..indicators_factory import data_generator,SMAWMA,BBandMA,MACD, RSI
from rest_framework.response import Response
from rest_framework.views import APIView
import json
import pandas as pd


# strategy from Azar's R code
class StrategyMACDTableData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        data_dict = MACD.main(selected_target)

        # some adjust for to_json properly
        df_to_display = data_dict['df']
        df_to_display = df_to_display.rename({'index': 'Date'}, axis=1)
        df_to_display = df_to_display.set_index('Date', drop=False)
        df_to_display.index = pd.DatetimeIndex(df_to_display.index)
        df_to_display = df_to_display.fillna('0')

        # prepare data for js
        result_table_dict = df_to_display.to_dict(orient='records')
        result_table_json = df_to_display.to_json(orient='records')

        columns_dict = [{'field': f, 'title': f} for f in df_to_display.columns]
        columns_json = json.dumps(columns_dict)

        data = {
            "selected_target": selected_target,
            "selected_strategy": "macd",
            "result_table_dict": result_table_dict,
            "result_table_json": result_table_json,
            "columns_dict": columns_dict,
            "columns_json": columns_json
        }
        return (Response(data))


class StrategyRSITableData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        data_dict = RSI.main(selected_target)

        # some adjust for to_json properly
        df_to_display = data_dict['df']
        df_to_display = df_to_display.rename({'index': 'Date'}, axis=1)
        df_to_display = df_to_display.set_index('Date', drop=False)
        df_to_display.index = pd.DatetimeIndex(df_to_display.index)
        df_to_display = df_to_display.fillna('0')

        # prepare data for js
        result_table_dict = df_to_display.to_dict(orient='records')
        result_table_json = df_to_display.to_json(orient='records')

        columns_dict = [{'field': f, 'title': f} for f in df_to_display.columns]
        columns_json = json.dumps(columns_dict)

        data = {
            "selected_target": selected_target,
            "selected_strategy": "macd",
            "result_table_dict": result_table_dict,
            "result_table_json": result_table_json,
            "columns_dict": columns_dict,
            "columns_json": columns_json
        }
        return (Response(data))

# self defined strategy from the book of Dr.Lin
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

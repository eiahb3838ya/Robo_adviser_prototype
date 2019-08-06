from ..indicators_factory import strategyR,data_generator
from ..indicators_factory.test import MACD,RSI
from rest_framework.response import Response
from rest_framework.views import APIView
import json
import pandas as pd
import numpy as np


# class StrategyFromRReturnData(APIView):
#     def get(self, request, format = None):
#         selected_target = request.GET["selected_target"]
#         print("we are now in StrategyFromRReturnData:", selected_target)
#
#         data_dict = strategy_from_r.main(selected_target)
#         return( Response( data_dict ) )
class StrategyMACDChartData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        print("we are now in StrategyMACDChartData:", selected_target)

        data_dict = MACD.main(selected_target)

        # get df_to_display and index for the df later
        df_to_display = data_dict['df']
        index = df_to_display['index']
        signal = df_to_display.iloc[:, 3]
        price=np.asarray(df_to_display.iloc[:, 1])

        # buy signal
        buy_signal_df = df_to_display.loc[signal == 1]
        buyDate=buy_signal_df.iloc[:, 0]
        buyPrice=buy_signal_df.iloc[:, 1]

        # sell signal
        sell_signal_df= df_to_display.loc[signal == -1]
        sellDate = sell_signal_df.iloc[:, 0]
        sellPrice = sell_signal_df.iloc[:, 1]


        # get other things
        targetRet = data_dict['targetRet']
        targetCumRet = data_dict['targetCumRet']

        strategyRet = data_dict['strategyRet']

        # prepare the df for R code
        strategyRet_df=pd.concat([index,strategyRet],axis=1)
        # call R function
        strategyCumRet, strategyDrawdowns = data_generator.getCumRet_Drawdowns(strategyRet_df)

        targetRet = targetRet.fillna('0')
        targetCumRet = targetCumRet.fillna('0')
        strategyRet = strategyRet.fillna('0')
        strategyCumRet = strategyCumRet.fillna('0')
        strategyDrawdowns = strategyDrawdowns.fillna('0')

        targetRet = targetRet.iloc[:, 1]
        targetCumRet = targetCumRet.iloc[:, 1]
        strategyCumRet = strategyCumRet.iloc[:, 1]
        strategyDrawdowns = strategyDrawdowns.iloc[:, 1]


        data = {
            "selected_target": selected_target,
            "selected_strategy": "macd",
            "Date": index,
            "targetRet": targetRet,
            "targetCumRet": targetCumRet,
            "strategyRet": strategyRet,
            "strategyDrawdowns": strategyDrawdowns,
            "strategyCumRet": strategyCumRet,

            "price":price,
            "buyDate":buyDate,
            "buyPrice":buyPrice,
            "sellDate":sellDate,
            "sellPrice":sellPrice,

        }

        return( Response( data ) )
    # def get

class StrategyRSIChartData(APIView):
    def get(self, request, format=None):
        selected_target = request.GET["selected_target"]
        print("we are now in StrategyRSIChartData:", selected_target)
        data_dict = RSI.main(selected_target)

        # get df_to_display and index for the df later
        df_to_display = data_dict['df']
        index = df_to_display['index']
        signal = df_to_display.iloc[:, 3]
        price = np.asarray(df_to_display.iloc[:, 1])

        # buy signal
        buy_signal_df = df_to_display.loc[signal == 1]
        buyDate = buy_signal_df.iloc[:, 0]
        buyPrice = buy_signal_df.iloc[:, 1]

        # sell signal
        sell_signal_df = df_to_display.loc[signal == -1]
        sellDate = sell_signal_df.iloc[:, 0]
        sellPrice = sell_signal_df.iloc[:, 1]

        # get other things
        targetRet = data_dict['targetRet']
        targetCumRet = data_dict['targetCumRet']

        strategyRet = data_dict['strategyRet']

        # prepare the df for R code
        strategyRet_df = pd.concat([index, strategyRet], axis=1)
        # call R function
        strategyCumRet, strategyDrawdowns = data_generator.getCumRet_Drawdowns(strategyRet_df)

        targetRet = targetRet.fillna('0')
        targetCumRet = targetCumRet.fillna('0')
        strategyRet = strategyRet.fillna('0')
        strategyCumRet = strategyCumRet.fillna('0')
        strategyDrawdowns = strategyDrawdowns.fillna('0')

        targetRet = targetRet.iloc[:, 1]
        targetCumRet = targetCumRet.iloc[:, 1]
        strategyCumRet = strategyCumRet.iloc[:, 1]
        strategyDrawdowns = strategyDrawdowns.iloc[:, 1]

        data = {
            "selected_target": selected_target,
            "selected_strategy": "rsi",
            "Date": index,
            "targetRet": targetRet,
            "targetCumRet": targetCumRet,
            "strategyRet": strategyRet,
            "strategyDrawdowns": strategyDrawdowns,
            "strategyCumRet": strategyCumRet,

            "price": price,
            "buyDate": buyDate,
            "buyPrice": buyPrice,
            "sellDate": sellDate,
            "sellPrice": sellPrice,

        }
        return (Response(data))

class StrategyMAChartData(APIView):
    def get(self, request, format=None):
        strategyName = "MA"
        selected_target = request.GET["selected_target"]
        print("we are now in Strategy{}ChartData:".format(strategyName), selected_target)
        data_dict = strategyR.main(selected_target, strategyName)

        # get df_to_display and index for the df later
        df_to_display = data_dict['df']
        index = df_to_display['index']
        signal = df_to_display.iloc[:, 3]
        price = np.asarray(df_to_display.iloc[:, 1])

        # buy signal
        buy_signal_df = df_to_display.loc[signal == 1]
        buyDate = buy_signal_df.iloc[:, 0]
        buyPrice = buy_signal_df.iloc[:, 1]

        # sell signal
        sell_signal_df = df_to_display.loc[signal == -1]
        sellDate = sell_signal_df.iloc[:, 0]
        sellPrice = sell_signal_df.iloc[:, 1]

        # get other things
        targetRet = data_dict['targetRet']
        targetCumRet = data_dict['targetCumRet']

        strategyRet = data_dict['strategyRet']

        # prepare the df for R code
        strategyRet_df = pd.concat([index, strategyRet], axis=1)
        # call R function
        strategyCumRet, strategyDrawdowns = data_generator.getCumRet_Drawdowns(strategyRet_df)

        targetRet = targetRet.fillna('0')
        targetCumRet = targetCumRet.fillna('0')
        strategyRet = strategyRet.fillna('0')
        strategyCumRet = strategyCumRet.fillna('0')
        strategyDrawdowns = strategyDrawdowns.fillna('0')

        targetRet = targetRet.iloc[:, 1]
        targetCumRet = targetCumRet.iloc[:, 1]
        strategyCumRet = strategyCumRet.iloc[:, 1]
        strategyDrawdowns = strategyDrawdowns.iloc[:, 1]

        data = {
            "selected_target": selected_target,
            "selected_strategy": "rsi",
            "Date": index,
            "targetRet": targetRet,
            "targetCumRet": targetCumRet,
            "strategyRet": strategyRet,
            "strategyDrawdowns": strategyDrawdowns,
            "strategyCumRet": strategyCumRet,

            "price": price,
            "buyDate": buyDate,
            "buyPrice": buyPrice,
            "sellDate": sellDate,
            "sellPrice": sellPrice,

        }
        return (Response(data))

class StrategyBBChartData(APIView):
    def get(self, request, format=None):
        strategyName = "BB"
        selected_target = request.GET["selected_target"]
        print("we are now in Strategy{}ChartData:".format(strategyName), selected_target)
        data_dict = strategyR.main(selected_target, strategyName)

        # get df_to_display and index for the df later
        df_to_display = data_dict['df']
        index = df_to_display['index']
        signal = df_to_display.iloc[:, 3]
        price = np.asarray(df_to_display.iloc[:, 1])

        # buy signal
        buy_signal_df = df_to_display.loc[signal == 1]
        buyDate = buy_signal_df.iloc[:, 0]
        buyPrice = buy_signal_df.iloc[:, 1]

        # sell signal
        sell_signal_df = df_to_display.loc[signal == -1]
        sellDate = sell_signal_df.iloc[:, 0]
        sellPrice = sell_signal_df.iloc[:, 1]

        # get other things
        targetRet = data_dict['targetRet']
        targetCumRet = data_dict['targetCumRet']

        strategyRet = data_dict['strategyRet']

        # prepare the df for R code
        strategyRet_df = pd.concat([index, strategyRet], axis=1)
        # call R function
        strategyCumRet, strategyDrawdowns = data_generator.getCumRet_Drawdowns(strategyRet_df)

        targetRet = targetRet.fillna('0')
        targetCumRet = targetCumRet.fillna('0')
        strategyRet = strategyRet.fillna('0')
        strategyCumRet = strategyCumRet.fillna('0')
        strategyDrawdowns = strategyDrawdowns.fillna('0')

        targetRet = targetRet.iloc[:, 1]
        targetCumRet = targetCumRet.iloc[:, 1]
        strategyCumRet = strategyCumRet.iloc[:, 1]
        strategyDrawdowns = strategyDrawdowns.iloc[:, 1]

        data = {
            "selected_target": selected_target,
            "selected_strategy": "rsi",
            "Date": index,
            "targetRet": targetRet,
            "targetCumRet": targetCumRet,
            "strategyRet": strategyRet,
            "strategyDrawdowns": strategyDrawdowns,
            "strategyCumRet": strategyCumRet,

            "price": price,
            "buyDate": buyDate,
            "buyPrice": buyPrice,
            "sellDate": sellDate,
            "sellPrice": sellPrice,

        }
        return (Response(data))
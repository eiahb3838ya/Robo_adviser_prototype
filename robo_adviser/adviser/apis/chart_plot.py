from ..indicators_factory import strategy_from_r,MACD,data_generator
from rest_framework.response import Response
from rest_framework.views import APIView
import json
import pandas as pd



class StrategyMACDChartPlot(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        print("we are now in StrategyMACDChartPlot:", selected_target)
        data_dict = MACD.main(selected_target)

        # get df_to_display and index for the df later
        df_to_display = data_dict['df']
        index = df_to_display['index']
        # get other things
        targetRet = data_dict['targetRet']
        targetCumRet = data_dict['targetCumRet']
        strategyRet = data_dict['strategyRet']

        # prepare the df for R code
        strategyRet_df=pd.concat([index,strategyRet],axis=1)
        # call R function
        strategyCumRet, strategyDrawdowns = data_generator.getCumRet_Drawdowns(strategyRet_df)

        # fill na
        targetRet = targetRet.fillna('0')
        targetCumRet = targetCumRet.fillna('0')
        strategyRet = strategyRet.fillna('0')
        strategyCumRet = strategyCumRet.fillna('0')
        strategyDrawdowns = strategyDrawdowns.fillna('0')

        # get the Series
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


        }

        return( Response( data ) )
from ..indicators_factory import strategy_from_r
from rest_framework.response import Response
from rest_framework.views import APIView
import json
import pandas as pd


class StrategyFromRReturnData(APIView):
    def get(self, request, format = None):
        selected_target = request.GET["selected_target"]
        print(selected_target)

        data_dict = strategy_from_r.main(selected_target)

        print("data_dict", data_dict)
        return( Response( data_dict ) )
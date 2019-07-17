from django.urls import path,include
from . import views
from .apis import table_data,chart_data
from django.contrib.auth import views as auth_views

app_name = 'adviser'
urlpatterns = [
    path('', views.start, name='start'),
    path('bbandma_result/', views.bbandma_result, name='bbandma_result'),
    path('smawma_result/', views.smawma_result, name='smawma_result'),
    path('r_strategy_result/', views.r_strategy_result,name='r_strategy_result'),
    path('macd_result/', views.macd_result,name='macd_result'),
    path('rsi_result/', views.rsi_result,name='rsi_result'),

    path('debuger_result1/', views.debuger_result1,name='debuger_result1'),


    path('api/chart/from_r/return', chart_data.StrategyFromRReturnData.as_view(),name="api_chart_return_data"),

    path('api/macd/table/all', table_data.StrategyMACDTableData.as_view(),name="api_macd_table_data"),
    path('api/rsi/table/all', table_data.StrategyRSITableData.as_view(),name="api_rsi_table_data"),
    path('api/smawma/table/all', table_data.StrategySMAWMATableData.as_view(),name="api_smawma_table_data"),
    path('api/bbandma/table/all', table_data.StrategyBBandMATableData.as_view(),name="api_bbandma_table_data"),

]
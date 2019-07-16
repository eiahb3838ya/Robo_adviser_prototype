from django.urls import path,include
from . import views
from django.contrib.auth import views as auth_views

app_name = 'adviser'
urlpatterns = [
    path('', views.start, name='start'),
    path('bbandma_result/', views.bbandma_result, name='bbandma_result'),
    path('smawma_result/', views.smawma_result, name='smawma_result'),
    path('r_strategy_result/', views.r_strategy_result,name='r_strategy_result'),
    path('macd_result/', views.macd_result,name='macd_result'),

    path('debuger_result1/', views.debuger_result1,name='debuger_result1'),


    path('api/from_r/chart/return',views.StrategyFromRReturnData.as_view(),name="api_chart_return_data"),
    path('api/macd/chart/return',views.StrategyMACDReturnData.as_view(),name="api_macd_chart_return"),

    path('api/smawma/table/all',views.StrategySMAWMATableData.as_view(),name="api_smawma_table_data"),
    path('api/bbandma/table/all',views.StrategyBBandMATableData.as_view(),name="api_bbandma_table_data"),

]
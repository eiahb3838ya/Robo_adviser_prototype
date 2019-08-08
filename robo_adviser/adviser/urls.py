from django.urls import path,include
from . import views
from .apis import table_data,chart_data
from django.contrib.auth import views as auth_views

app_name = 'adviser'
urlpatterns = [
    path('', views.start, name='start'),

    # ROUTER
    path('plot_result/', views.go_to_plot_result, name='go_to_plot_result'),
    path('table_result/',views.go_to_table_result, name='go_to_table_result'),

    # DEBUG FOR FORM2
    path('debuger_result1/', views.debuger_result1, name='debuger_result1'),

    # SHOW TABLE RESULT
    path('macd_table_result/', views.macd_table_result, name='macd_table_result'),
    path('rsi_table_result/', views.rsi_table_result, name='rsi_table_result'),
    path('ma_table_result/', views.ma_table_result, name='ma_table_result'),
    path('bb_table_result/', views.bb_table_result, name='bb_table_result'),

    path('bbandma_table_result/', views.bbandma_table_result, name='bbandma_table_result'),
    path('smawma_table_result/', views.smawma_table_result, name='smawma_table_result'),
    # path('r_strategy_result/', views.r_strategy_result, name='r_strategy_result'),

    # SHOW PLOT RESULT
    path('macd_plot_result/', views.macd_plot_result, name='macd_plot_result'),
    path('rsi_plot_result/', views.rsi_plot_result, name='rsi_plot_result'),
    path('ma_plot_result/', views.ma_plot_result, name='ma_plot_result'),
    path('bb_plot_result/', views.bb_plot_result, name='bb_plot_result'),

    # API CHART DATA
    # path('api/chart/from_r/return', chart_data.StrategyFromRReturnData.as_view(), name="api_chart_return_data"),
    path('api/macd/chart/all', chart_data.StrategyMACDChartData.as_view(), name="api_macd_chart_data"),
    path('api/rsi/chart/all', chart_data.StrategyRSIChartData.as_view(), name="api_rsi_chart_data"),
    path('api/bb/chart/all', chart_data.StrategyBBChartData.as_view(), name="api_bb_chart_data"),
    path('api/ma/chart/all', chart_data.StrategyMAChartData.as_view(), name="api_ma_chart_data"),

    # API TABLE DATA
    # path('api/macd/chart/plot', chart_plot.StrategyMACDChartPlot.as_view(), name="api_macd_chart_plot"),
    path('api/macd/table/all', table_data.StrategyMACDTableData.as_view(), name="api_macd_table_data"),
    path('api/rsi/table/all', table_data.StrategyRSITableData.as_view(), name="api_rsi_table_data"),
    path('api/bb/table/all', table_data.StrategyBBTableData.as_view(), name="api_bb_table_data"),
    path('api/ma/table/all', table_data.StrategyMATableData.as_view(), name="api_ma_table_data"),

    path('api/smawma/table/all', table_data.StrategySMAWMATableData.as_view(), name="api_smawma_table_data"),
    path('api/bbandma/table/all', table_data.StrategyBBandMATableData.as_view(), name="api_bbandma_table_data"),

]
from django.urls import path,include
from . import views
from django.contrib.auth import views as auth_views
app_name = 'adviser'
urlpatterns = [
    path('', views.start, name='start'),
    path('strategy_bbandma/', views.strategy_bbandma, name='strategy_bbandma'),
    path('smawma_result/', views.smawma_result, name='smawma_result'),
    path('r_strategy_result/', views.r_strategy_result,name='r_strategy_result'),

    path('debuger_result1/', views.debuger_result1,name='debuger_result1'),


    path('api/from_r/chart/return',views.SrategyFromRReturnData.as_view(),name="api_chart_return_data"),
    path('api/smawma/table/all',views.SrategySMAWMATableData.as_view(),name="api_smawma_table_data")
]
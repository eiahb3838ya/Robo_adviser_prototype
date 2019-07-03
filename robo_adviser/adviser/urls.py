from django.urls import path,include
from . import views
from django.contrib.auth import views as auth_views
app_name = 'adviser'
urlpatterns = [
    path('', views.start, name='start'),
    path('strategy_bbandma/', views.strategy_bbandma, name='strategy_bbandma'),
    path('strategy_smawma/', views.strategy_smawma, name='strategy_smawma'),
    path('debuger_result1/', views.debuger_result1,name='debuger_result1'),
    path('api/chart/data',views.TargetChartData.as_view(),name="api_target_chart_data")
]
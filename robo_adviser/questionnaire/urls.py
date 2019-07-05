from django.urls import path,include
from . import views
from django.contrib.auth import views as auth_views
app_name = 'questionnaire'
urlpatterns = [
    path('', views.start,name='start'),
    path("form1", views.form1, name="form1"),
    path("form2", views.form2, name="form2"),
    path('api/chart/data',views.TargetChartData.as_view(),name="api_target_chart_data"),
]
from django.urls import path,include
from . import views
from django.contrib.auth import views as auth_views
app_name = 'adviser'
urlpatterns = [
    path('', views.start, name='start'),
    path('strategy_bbandma/', views.strategy_bbandma, name='strategy_bbandma'),
    path('strategy_smawma/', views.strategy_smawma, name='strategy_smawma'),
]
# from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('', views.showHomePage,name='home'),
    path('goToRobot/',views.goToRobot,name='goToRobot')
]
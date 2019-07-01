from django.urls import path,include
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', views.start,name='start'),
    path("form1", views.form1, name="form1"),
]
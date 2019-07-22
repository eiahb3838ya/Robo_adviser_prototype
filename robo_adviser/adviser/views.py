from django.shortcuts import render,HttpResponse

from .indicators_factory import data_generator,SMAWMA,BBandMA,strategy_from_r,MACD, RSI
from rest_framework.response import Response
from rest_framework.views import APIView
import json
import pandas as pd
# Create your views here.

def start(request):
    return(render(request,'enter_adviser.html',locals()))

def smawma_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("request.GET['stockpicker'] failed")
    context = {
        "selected_target": selected_target,
        "selected_strategy": "smawma",
    }
    return(render(request,"single_target_result_using_ajax.html", context))

def bbandma_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("request.GET['stockpicker'] failed")
    context = {
        "selected_target": selected_target,
        "selected_strategy": "bbandma",
    }
    return(render(request,"single_target_result_using_ajax.html", context))

def r_strategy_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("error")
    return (render(request, 'r_strategy_result.html', locals()))


def macd_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'macd'
    except:
        print("error")
    return (render(request, 'macd_result.html', locals()))

def rsi_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'rsi'
    except:
        print("error")
    return (render(request, 'rsi_result.html', locals()))


def debuger_result1(request):
    values = request.GET.getlist(u'target_strategy')
    return (render(request, 'result1.html', locals()))


from django.shortcuts import render,HttpResponse
from django.shortcuts import redirect
from django.urls import reverse

from .indicators_factory import data_generator,SMAWMA,BBandMA,strategy_from_r,MACD, RSI
from rest_framework.response import Response
from rest_framework.views import APIView
import json
import pandas as pd
# Create your views here.

def start(request):
    return(render(request,'enter_adviser.html',locals()))

def go_to_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = request.GET['strategypicker']
    except Exception:
        print("request.GET['stockpicker'] failed")
    print("we are in go_to_plot_result:", selected_target)
    redirect_target = reverse('adviser:{}_plot_result'.format(selected_strategy))
    return redirect("{}?stockpicker={}".format(redirect_target,selected_target))

def go_to_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = request.GET['strategypicker']
    except Exception:
        print("request.GET['stockpicker'] failed")

    print("we are in go_to_table_result:", selected_target)
    redirect_target = reverse('adviser:{}_table_result'.format(selected_strategy))
    return redirect("{}?stockpicker={}".format(redirect_target,selected_target))



def smawma_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("request.GET['stockpicker'] failed")
    context = {
        "selected_target": selected_target,
        "selected_strategy": "smawma",
    }
    return(render(request,"single_target_result_using_ajax.html", context))

def bbandma_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
    except:
        print("request.GET['stockpicker'] failed")
    context = {
        "selected_target": selected_target,
        "selected_strategy": "bbandma",
    }
    return(render(request,"single_target_result_using_ajax.html", context))

# def r_strategy_result(request):
#     try:
#         selected_target = request.GET['stockpicker']
#     except:
#         print("error")
#     return (render(request, 'r_strategy_result.html', locals()))

def macd_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'macd'
    except:
        print("error")
    return (render(request, 'macd_table_result.html', locals()))

def rsi_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'rsi'
    except:
        print("error")
    return (render(request, 'rsi_table_result.html', locals()))


def debuger_result1(request):
    values = request.GET.getlist(u'target_strategy')
    return (render(request, 'result1.html', locals()))


def macd_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'macd'
    except:
        print("error")
    return (render(request, 'macd_plotjs_result.html', locals()))

def rsi_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'rsi'
    except:
        print("error")
    return (render(request, 'rsi_plotjs_result.html', locals()))

from django.shortcuts import render,HttpResponse
from django.shortcuts import redirect
from django.urls import reverse
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

# MACD
def macd_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'macd'
    except:
        print("error")
    return (render(request, 'macd_table_result.html', locals()))

def macd_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'macd'
    except:
        print("error")
    return (render(request, 'macd_plotjs_result.html', locals()))

# RSI
def rsi_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'rsi'
    except:
        print("error")
    return (render(request, 'rsi_table_result.html', locals()))

def rsi_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'rsi'
    except:
        print("error")
    return (render(request, 'rsi_plotjs_result.html', locals()))

def ma_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'ma'
    except:
        print("error")
    return (render(request, 'ma_table_result.html', locals()))

# MA
def ma_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'ma'
    except:
        print("error")
    return (render(request, 'ma_plotjs_result.html', locals()))

def bb_table_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'bb'
    except:
        print("error")
    return (render(request, 'bb_table_result.html', locals()))

# BB
def bb_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = 'bb'
    except:
        print("error")
    return (render(request, 'bb_plotjs_result.html', locals()))


def debuger_result1(request):
    values = request.GET.getlist('target_strategy')
    return (render(request, 'test/result1.html', locals()))

# def r_strategy_result(request):
#     try:
#         selected_target = request.GET['stockpicker']
#     except:
#         print("error")
#     return (render(request, 'r_strategy_result.html', locals()))

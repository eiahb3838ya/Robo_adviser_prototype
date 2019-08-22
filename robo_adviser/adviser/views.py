from django.shortcuts import render,HttpResponse, HttpResponseRedirect
from django.shortcuts import redirect
from django.urls import reverse

# self defined function for conveniency
def custom_redirect(url_name,  **kwargs):
    # from django.core.urlresolvers import reverse
    import urllib
    url = reverse(url_name)
    params = urllib.parse.urlencode(kwargs)
    return HttpResponseRedirect(url + "?%s" % params)

# start
def start(request):
    return(render(request,'enter_adviser.html',locals()))

# router
def go_to_plot_result(request):
    try:
        selected_target = request.GET['stockpicker']
        selected_strategy = request.GET['strategypicker']
    except Exception:
        print("request.GET['stockpicker'] failed")
    print("we are in go_to_plot_result:", selected_target, selected_target)
    # print("we are in go_to_plot_result:", selected_target)
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

# portfolio router
def go_to_multistrategy_result(request):
    selected_target = request.GET['stockpicker']
    selected_portfolio = request.GET['portfolio']
    selected_strategy = request.GET.getlist('strategypicker')
    return custom_redirect('adviser:portfolio_{}_result'.format(selected_portfolio.lower()), stockpicker = selected_target,strategypicker = selected_strategy)

# portfolio view
def portfolio_markowitz_result(request):
    import json
    selected_target = request.GET['stockpicker']
    selected_strategy_str = request.GET['strategypicker']
    selected_strategy_list = [aS.strip()[1:-1] for aS in selected_strategy_str[1:-1].split(',')]

    # 這裡這樣做是為了未來可以放進"多資產"的資產配置策略,目前只有單一資產多策略
    target_strategy = ["{}_{}".format(selected_target,aS) for aS in selected_strategy_list]
    context = {"selected_target": selected_target,
               "selected_strategy_str": selected_strategy_str,
               "target_strategy": json.dumps(target_strategy),
               "portfolio":"Markowitz",
               }
    return (render(request, "portfolio_markowitz_result.html",context=context))

def portfolio_riskparity_result(request):
    import json
    selected_target = request.GET['stockpicker']
    selected_strategy_str = request.GET['strategypicker']
    selected_strategy_list = [aS.strip()[1:-1] for aS in selected_strategy_str[1:-1].split(',')]

    # 這裡這樣做是為了未來可以放進"多資產"的資產配置策略,目前只有單一資產多策略
    target_strategy = ["{}_{}".format(selected_target,aS) for aS in selected_strategy_list]
    context = {"selected_target": selected_target,
               "selected_strategy_str": selected_strategy_str,
               "target_strategy": json.dumps(target_strategy),

               "portfolio": "RiskParity",
               }
    return (render(request, "portfolio_riskparity_result.html",context=context))

def portfolio_cvar_result(request):
    import json
    selected_target = request.GET['stockpicker']
    selected_strategy_str = request.GET['strategypicker']
    selected_strategy_list = [aS.strip()[1:-1] for aS in selected_strategy_str[1:-1].split(',')]

    # 這裡這樣做是為了未來可以放進"多資產"的資產配置策略,目前只有單一資產多策略
    target_strategy = ["{}_{}".format(selected_target,aS) for aS in selected_strategy_list]
    context = {"selected_target": selected_target,
               "selected_strategy_str": selected_strategy_str,
               "target_strategy": json.dumps(target_strategy),

               "portfolio": "CVaR",
               }
    return (render(request, "portfolio_cvar_result.html",context=context))

# single_target_result_using_ajax table view
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
    target_strategy = request.GET.getlist('target_strategy')
    pairs = [tuple(aPair.split("_")) for aPair in target_strategy]
    return (render(request, 'test/result1.html', locals()))


# def r_strategy_result(request):
#     try:
#         selected_target = request.GET['stockpicker']
#     except:
#         print("error")
#     return (render(request, 'r_strategy_result.html', locals()))

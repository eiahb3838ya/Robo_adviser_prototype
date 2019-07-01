from django.shortcuts import render,HttpResponse
from .indicators_factory import data_generator,SMAWMA
# Create your views here.

def start(request):
    try:
        user_picked=request.GET['mypicker']
    except:
        print("rrrrrr")
    str1=""
    count = 0
    acmroi = 0
    winrate = 0
    winvar = 0
    # get the history price with yahoo finance
    target_price_df = data_generator.get_history_data(user_picked)
    # call smawma
    df,count,acmroi,winrate,winvar=SMAWMA.main(target_price_df,count,acmroi,winrate,winvar)

    return(HttpResponse(df.to_html()))
    # return(render(request,'result1.html',locals()))

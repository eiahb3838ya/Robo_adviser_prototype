from rpy2 import robjects
from rpy2.robjects import r, pandas2ri
import numpy as np
import pandas as pd

def main(selected_target):
# make pandas dataframe and R dataframe availible to change to either one
    pandas2ri.activate()

    # close the warning
    r.options(warn=-1)


    # put in the chosen stock code in a naive (bad) way
    StockCode = selected_target[:4]
    print("we are in strategy macd and the StockCode is "+StockCode)
    robjects.r('''StockCode <- "{}" '''.format(StockCode))

    # call r file
    r("setwd('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/nice_oop_strategy')")
    r("source('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/nice_oop_strategy/strategy_macd.R', local = TRUE)")

    # get the result we wanted
    Select_DT = r['Select_DT']
    Ret_DT = r['Ret_DT']
    get_MACD_alldf = r['get_MACD_alldf']

    MACD_alldf=get_MACD_alldf(Select_DT,Ret_DT)


    print(MACD_alldf)


    # do something to output
    data_dict= {
        "MACD_alldf": pd.DataFrame(MACD_alldf),
    }
    return(data_dict)



# quick check by plotting

# plotly in R code
# plot_ly(Portfolio_CumRet_tb, x = ~Date,
#          y = ~MACD, name = 'MACD', type = 'scatter', mode = 'lines') %>%
#    add_trace(y = ~RSI, name = 'RSI', mode = 'lines') %>%
#    layout(title = paste0("Strategy Cumulative Return"))

# trace = go.Scatter(
#     x = np.array(betterDate),
#     y = RSI
# )
#
# data = [trace]
# plotly.plot(data, filename='basic-line')
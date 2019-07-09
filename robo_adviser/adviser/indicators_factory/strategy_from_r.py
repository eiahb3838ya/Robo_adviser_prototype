from rpy2 import robjects
from rpy2.robjects import r, pandas2ri
import plotly.plotly  as plotly
import plotly.graph_objs as go
import numpy as np
import pandas as pd

def main(selected_target):
    pandas2ri.activate()
    r.options(warn=-1)
    StockCode = selected_target[:4]
    print("we are in strategy from r and the StockCode is "+StockCode)
    robjects.r('''StockCode <- "{}" '''.format(StockCode))

    r("source('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/Trading_Azar_TO_Evan.R', local = TRUE)")
    Portfolio_CumRet_tb=r['Portfolio_CumRet_tb']

    # Date = np.asarray(Portfolio_CumRet_tb)[0]
    MACD = np.asarray(Portfolio_CumRet_tb)[1]
    RSI = np.asarray(Portfolio_CumRet_tb)[2]


    betterDate= r.format(Portfolio_CumRet_tb[0], "%Y-%m-%d")

    data_dict= {
        "Date": np.array(betterDate),
        "RSI": RSI,
        "MACD": MACD,
    }
    return(data_dict)
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
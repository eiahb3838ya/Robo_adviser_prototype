import rpy2
import rpy2.robjects as robjects
import plotly.plotly  as plotly
import plotly.graph_objs as go
import numpy as np


r = robjects.r

r("source('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/Trading_Azar_TO_Evan.R', local = TRUE)")
Portfolio_CumRet_tb=r['Portfolio_CumRet_tb']

Date=np.asarray(Portfolio_CumRet_tb)[0]
MACD=np.asarray(Portfolio_CumRet_tb)[1]
RSI=np.asarray(Portfolio_CumRet_tb)[2]

# plotly in R code
# plot_ly(Portfolio_CumRet_tb, x = ~Date,
#          y = ~MACD, name = 'MACD', type = 'scatter', mode = 'lines') %>%
#    add_trace(y = ~RSI, name = 'RSI', mode = 'lines') %>%
#    layout(title = paste0("Strategy Cumulative Return"))

data_dict= {
    "Date": Date,
    "RSI": RSI,
    "MACD": MACD,
}

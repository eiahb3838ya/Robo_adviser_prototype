from rpy2 import robjects
from rpy2.robjects import r, pandas2ri
import numpy as np
import pandas as pd

def main(selected_target):
    STRATEGY_NAME="MACD"

    # close the warning
    r.options(warn=-1)

    # put in the chosen stock code in a naive (bad) way
    StockCode = selected_target[:4]
    print("we are in strategy {} and the StockCode is {}".format(STRATEGY_NAME, StockCode))
    input = robjects.r('''list(listID="{}",period="{}",StartDate="{}",EndDate="{}")'''
                       .format(StockCode, "Quarter", "2007-01-02", "2019-06-28"))

    # call r file
    r("setwd('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/nice_oop_strategy')")
    r("source('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/nice_oop_strategy/strategy_macd.R', local = TRUE)")



    # get the result we wanted
    readDataFrame = r['readDataFrame']
    # get the functioin object in R
    get_SelectDT = r['get_SelectDT']
    getRet_DT = r['getRet_DT']
    getCumRet_DT = r['getCumRet_DT']
    get_alldf = r['get_alldf']

    Select_DT = get_SelectDT(readDataFrame,input)
    targetRet_DT = getRet_DT(Select_DT)
    targetRet = pandas2ri.ri2py_dataframe(targetRet_DT)

    targetCumRet_DT = getCumRet_DT(targetRet_DT)
    targetCumRet = pandas2ri.ri2py_dataframe(targetCumRet_DT)

    alldf = get_alldf(Select_DT, targetRet_DT)
    alldf = pandas2ri.ri2py_dataframe(alldf)

    # do something to output
    data_dict = {
        "df": alldf,
        "targetRet": targetRet,
        "targetCumRet": targetCumRet,
        "strategyRet": alldf['Equity'],


    }
    return( data_dict )

if __name__ == "__main__":
    main("2330.TW")

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
from rpy2 import robjects
from rpy2.robjects import r, pandas2ri
try:
    from .data_generator import get_history_data
except:
    pass

def main(selected_target):
    STRATEGY_NAME="RSI"
    pandas2ri.activate()
    # close the warning
    r.options(warn=-1)

    # put in the chosen stock code in a naive (bad) way
    StockCode = selected_target[:4]
    StartDate = ""
    EndDate = ""

    print("we are in strategy {} and the StockCode is {}".format(STRATEGY_NAME, StockCode))

    # call r file
    r("setwd('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0')")
    r("source('C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0/strategy_{}.R', local = TRUE)".format(STRATEGY_NAME.lower()))

    # "getting the history data"
    print("getting the history data")
    history_data_df = get_history_data(target='all')
    history_data_df['Date'] = history_data_df.index
    history_data_df = history_data_df[["STOCK_CODE", "Date", "Close", "High", "Low", "Open", "Volume"]]
    readDataFrame = pandas2ri.py2ri(history_data_df)

    # get the result we wanted
    getDT_FromSQL = r['getDT_FromSQL']
    getCol_DT = r['getCol_DT']
    getCode_DT = r['getCode_DT']
    getPeriod_DT = r['getPeriod_DT']
    getWin_DT = r['getWin_DT']
    getSelect_DT = r['getSelect_DT']
    getRet_DT = r['getRet_DT']
    getCumRet_DT = r['getCumRet_DT']
    get_alldf = r['get_alldf']

    DataTable = getDT_FromSQL(readDataFrame)
    SelectCol_DT = getCol_DT(DataTable, "Close")
    SelectCode_DT = getCode_DT(SelectCol_DT, StockCode)
    Period_DT = getPeriod_DT(SelectCode_DT)
    StartDate = Period_DT[0]
    EndDate = Period_DT[1]
    Win_DT = getWin_DT(SelectCode_DT, StartDate=StartDate, EndDate=EndDate)
    Select_DT = getSelect_DT(Win_DT, StockCode, StartDate=StartDate, EndDate=EndDate)
    targetRet_DT = getRet_DT(Select_DT)
    alldf = get_alldf(Select_DT, targetRet_DT)

    # CumRet for plot
    targetCumRet_DT = getCumRet_DT(targetRet_DT)

    # transform to python DataFrame
    alldf = pandas2ri.ri2py_dataframe(alldf)
    targetRet = pandas2ri.ri2py_dataframe(targetRet_DT)
    targetCumRet = pandas2ri.ri2py_dataframe(targetCumRet_DT)

    # do something to output
    data_dict= {
        "df": alldf,
        "targetRet": targetRet,
        "targetCumRet": targetCumRet,
        "strategyRet": alldf['Equity'],
    }
    return(data_dict)
#
if __name__ == "__main__":
    from data_generator import get_history_data
    print(main("2330.TW"))

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
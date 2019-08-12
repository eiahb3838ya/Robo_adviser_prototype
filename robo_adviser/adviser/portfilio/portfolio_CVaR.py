import pandas as pd
from rpy2.robjects import r, pandas2ri
import warnings


def main( equityList, Ret):
    # get the portfolio name with file name
    PORTFOLIO_NAME = __file__.split('_')[-1][:-3]
    print("we are in portfolio {}".format(PORTFOLIO_NAME))

    # init parameter
    WD = 'C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0'
    # activate rpy2 function
    pandas2ri.activate()
    # call r file
    r("setwd('{}')".format(WD))
    r("source('{}/{}.R', local = TRUE)".format(WD, "portfolio_"+PORTFOLIO_NAME))
    # close the warning
    r.options(warn=-1)
    warnings.simplefilter(action='ignore', category=FutureWarning)



    # prepare DT for R code
    Equity_All_df = pd.DataFrame({'index':equityList[0]['index']})
    # Equity_All_df = pd.concat([Equity_All_df, Ret])
    Equity_All_df = Equity_All_df.join(Ret.set_index('index'), on='index')
    for e in equityList:
        Equity_All_df = Equity_All_df.join(e.set_index('index'), on='index')
    Equity_All_df  = Equity_All_df.dropna(axis=0)
    Equity_All_DT = r['as.data.table'](Equity_All_df)

    get_portfolio_result = r['get_portfolio_result']
    returnAll = list(get_portfolio_result(Equity_All_DT))

    returnAll = [pandas2ri.ri2py_dataframe(df) for df in returnAll]
    RL_Corr = returnAll[0]
    RL_Wt = returnAll[1]
    RL_Ret = returnAll[2]

    data_dict = {
        "RL_Corr": RL_Corr,
        "RL_Wt": RL_Wt,
        "RL_Ret": RL_Ret
    }

    return(data_dict)

if __name__ == "__main__":
    import sys
    sys.path.extend(['C:\\Users\\Evan\\Desktop\\xiqi\\Robo_adviser_prototype\\robo_adviser'
                        , 'C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser'])
    from adviser.indicators_factory import strategyR
    # macd_Ret = strategyR.main("2330", "MACD")['strategyRet']
    rsi_Ret = strategyR.main("2330", "RSI")['strategyRet']
    ma_Ret = strategyR.main("2330", "MA")['strategyRet']
    Ret = strategyR.main("2330", "RSI")['targetRet']
    equityList = [rsi_Ret, ma_Ret]
    thisReturn = main(equityList, Ret)
    print(thisReturn)

from rpy2 import robjects
import time
import pandas as pd
from rpy2.robjects import r, pandas2ri
from django.conf import settings

def main( equityList, Ret):
    # init parameter
    BASE_DIR_str = str(settings.BASE_DIR).replace("\\", "/")

    WD = BASE_DIR_str + '/adviser/r_strategy/r_strategy2.0'
    # WD = 'C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0'

    # activate rpy2 function
    pandas2ri.activate()
    # call r file
    r("setwd('{}')".format(WD))

    r("source('{}/{}.R', local = TRUE)".format(WD, "portfolio_MVaR_CVaR"))
    # close the warning
    r.options(warn=-1)

    Equity_All_df = pd.DataFrame({'index':equityList[0]['index']})
    # Equity_All_df = pd.concat([Equity_All_df, Ret])
    Equity_All_df = Equity_All_df.join(Ret.set_index('index'), on='index')
    for e in equityList:
        Equity_All_df = Equity_All_df.join(e.set_index('index'), on='index')
    Equity_All_df  = Equity_All_df.dropna(axis=0)
    Equity_All_DT = r['as.data.table'](Equity_All_df)
    get_Portfolio_MVaR_CVaR = r['get_Portfolio_MVaR_CVaR']
    returnAll = list(get_Portfolio_MVaR_CVaR(Equity_All_DT))

    RC_Markowitz = returnAll[0]
    Wt_Markowitz = returnAll[1]
    MVaR_Markowitz = returnAll[2]
    CVaR_Markowitz = returnAll[3]

    RC_RiskParity = returnAll[4]
    Wt_RiskParity= returnAll[5]
    MVaR_RiskParity = returnAll[6]
    CVaR_RiskParity = returnAll[7]

    RC_CVaR = returnAll[8]
    Wt_CVaR = returnAll[9]
    MVaR_CVaR = returnAll[10]
    CVaR_CVaR = returnAll[11]

    Portfolio_EFrontier = returnAll[12]

    RC_Markowitz_df = pandas2ri.ri2py_dataframe(RC_Markowitz)
    Wt_Markowitz_df = pandas2ri.ri2py_dataframe(Wt_Markowitz)#returnAll[1]
    MVaR_Markowitz_df = pandas2ri.ri2py_dataframe(MVaR_Markowitz)#returnAll[2]
    CVaR_Markowitz_df = pandas2ri.ri2py_dataframe(CVaR_Markowitz)#returnAll[3]

    RC_RiskParity_df = pandas2ri.ri2py_dataframe(RC_RiskParity)#returnAll[4]
    Wt_RiskParity_df = pandas2ri.ri2py_dataframe(Wt_RiskParity)#returnAll[5]
    MVaR_RiskParity_df = pandas2ri.ri2py_dataframe(MVaR_RiskParity)#returnAll[6]
    CVaR_RiskParity_df = pandas2ri.ri2py_dataframe(CVaR_RiskParity)#returnAll[7]

    RC_CVaR_df = pandas2ri.ri2py_dataframe(RC_CVaR)#returnAll[8]
    Wt_CVaR_df = pandas2ri.ri2py_dataframe(Wt_CVaR)#returnAll[9]
    MVaR_CVaR_df = pandas2ri.ri2py_dataframe(MVaR_CVaR)#returnAll[10]
    CVaR_CVaR_df = pandas2ri.ri2py_dataframe(CVaR_CVaR)#returnAll[11]

    Portfolio_EFrontier_list = list(Portfolio_EFrontier)
    # Portfolio_EFrontier_list = [pandas2ri.ri2py_dataframe(df) for df in Portfolio_EFrontier_list]

    data_dict = {
        "RC_Markowitz_df": RC_Markowitz_df,
        "Wt_Markowitz_df": Wt_Markowitz_df,
        "MVaR_Markowitz_df": MVaR_Markowitz_df,
        "CVaR_Markowitz_df" :CVaR_Markowitz_df,

        "RC_RiskParity_df" :RC_RiskParity_df,
        "Wt_RiskParity_df" :Wt_RiskParity_df,
        "MVaR_RiskParity_df" :MVaR_RiskParity_df,
        "CVaR_RiskParity_df" :CVaR_RiskParity_df,

        "RC_CVaR_df": RC_CVaR_df,
        "Wt_CVaR_df": Wt_CVaR_df,
        "MVaR_CVaR_df" :MVaR_CVaR_df,
        "CVaR_CVaR_df" :CVaR_CVaR_df,

        "Portfolio_EFrontier": Portfolio_EFrontier_list,


    }
    return(data_dict)
    # print(enumerate(returnAll))
    # print("1.{} /n2.{} 3.{} 4.{} 5.{} 6.{} 7.{}".format(targetRisk, targetReturn, Sigma, Mu, Return, Risk, tgReturn))


if __name__ == "__main__":

    import sys,os
    sys.path.extend(['C:\\Users\\Evan\\Desktop\\xiqi\\Robo_adviser_prototype\\robo_adviser'
                        , 'C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser'])
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'robo_adviser.settings')
    from adviser.indicators_factory import strategyR
    # macd_Ret = strategyR.main("2330", "MACD")['strategyRet']
    rsi_Ret = strategyR.main("2330", "RSI")['strategyRet']
    ma_Ret = strategyR.main("2330", "MA")['strategyRet']
    Ret = strategyR.main("2330", "RSI")['targetRet']
    equityList = [rsi_Ret, ma_Ret]
    thisReturn = main(equityList, Ret)



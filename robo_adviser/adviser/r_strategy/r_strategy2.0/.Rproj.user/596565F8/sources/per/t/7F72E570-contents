suppressMessages(require(PerformanceAnalytics))
suppressMessages(require(quantmod))
suppressMessages(require(timeSeries))
suppressMessages(require(fUnitRoots))
suppressMessages(require(fPortfolio))
suppressMessages(require(CVXR))
suppressMessages(require(data.table))

pathis <- "C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0/"
files <- list.files(path = "Function/",pattern = "\\.R")
lapply(files, function(idx){
  source(paste0("Function/", idx))
})

# Equity_All = readRDS('tmp.RDS')


get_portfolio_result<-function(Equity_All){
  period <- "Month"
  RL_Period <- get_RL_Period(Equity_All, periodn =  period)
  RL_RiskParity <- get_RL_RiskParity(Equity_All, Startn = RL_Period$Startn, Endn = RL_Period$Endn, Next_n = RL_Period$Next_n)
  RL_RiskParity_Corr <- get_RL_Corr(RL_RiskParity, col_name = colnames(Equity_All)[-1])
  RL_RiskParity_Wt <- get_RL_RiskParity_Wt(RL_RiskParity, col_name = base::setdiff(colnames(Equity_All), "Ret")[-1])
  RL_RiskParity_Ret <- get_RL_RiskParity_Ret(RL_RiskParity)
  # print("RiskParity_Portfolio OK")
  return(list(RL_RiskParity_Corr, RL_RiskParity_Wt, RL_RiskParity_Ret))
}

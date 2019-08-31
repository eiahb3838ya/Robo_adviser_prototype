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




get_portfolio_result<-function(Equity_All){
  period <- "Month"
  RL_Period <- get_RL_Period(Equity_All, periodn =  period)
  RL_Markowitz <- get_RL_Markowitz(Equity_All, Startn = RL_Period$Startn, Endn = RL_Period$Endn, Next_n = RL_Period$Next_n)
  RL_Markowitz_Corr <- get_RL_Corr(RL_Markowitz, col_name = colnames(Equity_All)[-1])
  RL_Markowitz_Wt <- get_RL_Markowitz_Wt(RL_Markowitz, col_name = base::setdiff(colnames(Equity_All), "Ret")[-1])
  RL_Markowitz_Ret <- get_RL_Markowitz_Ret(RL_Markowitz)
  # print("Markowitz_Portfolio OK")
  return(list(RL_Markowitz_Corr, RL_Markowitz_Wt, RL_Markowitz_Ret))
}

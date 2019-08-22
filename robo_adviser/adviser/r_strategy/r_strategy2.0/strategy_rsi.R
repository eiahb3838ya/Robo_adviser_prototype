suppressMessages(require(PerformanceAnalytics))
suppressMessages(require(quantmod))
suppressMessages(require(timeSeries))
suppressMessages(require(fUnitRoots))
suppressMessages(require(fPortfolio))
suppressMessages(require(CVXR))
suppressMessages(require(data.table))

##### ........... =====
##### Input =====
# input is from python

##### ........... =====
##### Source =====

pathis <- "C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0/"
files <- list.files(path = "Function/",pattern = "\\.R")
lapply(files, function(idx){
  source(paste0("Function/", idx))
})




get_alldf<-function(Select_DT,Ret_DT){
  ##### RSI Strategy =====
  # nma = 5, maType = "SMA", > RSI_Up = 70 Short, < RSI_Down = 30 Long
  Select_DT <-as.data.table(Select_DT)
  RSI_Signal <- get_RSI_Signal(Select_DT)
  Equity_RSI <- getEquity_DT(Ret_DT, RSI_Signal)
  JG_Equity_DT_RSI <- get_Equity_All_DT(Select_DT, Ret_DT, RSI_Signal, Equity_RSI)
  return(JG_Equity_DT_RSI)
}


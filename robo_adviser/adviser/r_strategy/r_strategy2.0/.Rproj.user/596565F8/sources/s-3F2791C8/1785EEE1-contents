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

##### MACD Strategy =====
# MACD_Fast = 12, MACD_Slow = 26, MACD_Sig = 9
get_alldf<-function(Select_DT,Ret_DT){
  
  Select_DT <-as.data.table(Select_DT)
  
  Signal <- get_MA_Signal(Select_DT)
  Equity <- getEquity_DT(Ret_DT, Signal)
  JG_Equity_DT <- get_Equity_All_DT(Select_DT, Ret_DT, Signal, Equity)
  return(JG_Equity_DT)
}

##### MA Strategy =====
# MA_fast = 20, MA_slow = 60


## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getEquity_DT =====
getEquity_DT <- function(Ret_DT, Signal_DT){
  
  Ret_DT$index <- as.Date(Ret_DT$index)
  Ret_xts <- as.xts.data.table(Ret_DT)
  colnames(Ret_xts) <- "Equity"
  
  Signal_DT$index <- as.Date(Signal_DT$index)
  Signal_DT <- as.xts.data.table(Signal_DT)
  
  Equity_XTS <- Ret_xts*Signal_DT
  Equity_DT <- as.data.table(Equity_XTS)
  Equity_DT$index <- as.character(Equity_DT$index)
  
  return(Equity_DT)
}

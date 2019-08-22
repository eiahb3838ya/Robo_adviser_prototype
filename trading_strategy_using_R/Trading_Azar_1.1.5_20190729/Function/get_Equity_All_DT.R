## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

##### get_Equity_All_DT =====
get_Equity_All_DT <- function(Select_DT, Ret_DT, Signal_DT, Equity_DT){
  
  if (is.data.frame(Select_DT)) {
    
    Select_DT$index <- as.Date(Select_DT$index)
    Ret_DT$index <- as.Date(Ret_DT$index)
    Signal_DT$index <- as.Date(Signal_DT$index)
    Equity_DT$index <- as.Date(Equity_DT$index)
    
    Select_XTS <- as.xts.data.table(Select_DT)
    Ret_XTS <- as.xts.data.table(Ret_DT)
    Signal_XTS <- as.xts.data.table(Signal_DT)
    Equity_XTS <- as.xts.data.table(Equity_DT)
    
    DataTable_XTS <- merge(Select_XTS, Ret_XTS, Signal_XTS, Equity_XTS)
    DataTable_DT <- as.data.table(DataTable_XTS)
    colnames(DataTable_DT) <- c(colnames(DataTable_DT)[1], colnames(Select_XTS), colnames(DataTable_DT)[3:5])
    DataTable_DT$index <- as.character(DataTable_DT$index)
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(DataTable_DT)
}

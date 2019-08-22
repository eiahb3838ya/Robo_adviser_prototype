## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

##### getRet_DT =====
getRet_DT <- function(DataFrame, kperiods = 1){
  
  if (is.data.frame(DataFrame)) {
    DataFrame$index <- as.Date(DataFrame$index)
    
    DataFrame <- as.data.table(DataFrame)
    
    SelectXTS <- as.xts.data.table(DataFrame)
    
    if (is.xts(SelectXTS)) {
      Data_Ret_XTS <- Delt(SelectXTS, k = kperiods)
      colnames(Data_Ret_XTS) <- "Ret"
      Data_Ret_DT <- as.data.table(Data_Ret_XTS)
      Data_Ret_DT$index <- as.character(Data_Ret_DT$index)
    }
    else {
      stop("Price series must be a xts!")
    }
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(Data_Ret_DT)
}

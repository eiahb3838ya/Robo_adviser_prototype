## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getRet_DT =====
getRet_DT <- function(Select_DT, kperiods = 1){
  
  Select_DT$index <- as.Date(Select_DT$index)
  SelectXTS <- as.xts.data.table(Select_DT)
  
  if (is.xts(SelectXTS)) {
    Data_Ret_XTS <- Delt(SelectXTS, k = kperiods)
    colnames(Data_Ret_XTS) <- "Ret"
    Data_Ret_DT <- as.data.table(Data_Ret_XTS)
    Data_Ret_DT$index <- as.character(Data_Ret_DT$index)
    return(Data_Ret_DT)
  }
  else {
    stop("Price series must be a xts!")
  }
}

## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getCumRet_DT =====
getCumRet_DT <- function(Ret_DT, col_name = "CumRet"){
  Ret_DT$index <- as.Date(Ret_DT$index)
  Retxts <- as.xts.data.table(Ret_DT)
  # Retxts <- Ret_xts
  if (is.xts(Retxts)) {
    Ret_xts <- na.omit(Retxts)
    CumRet_xts <- cumprod(Ret_xts + 1)
    CumRet_tb <- as.data.table(CumRet_xts)
    colnames(CumRet_tb) <- c(colnames(CumRet_tb)[1], col_name)
    CumRet_tb$index <- as.character(CumRet_tb$index)
    
    return(CumRet_tb)
  }
  else {
    stop("Price series must be a xts!")
  }
}

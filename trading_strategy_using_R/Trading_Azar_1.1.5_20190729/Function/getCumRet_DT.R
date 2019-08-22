## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

##### getCumRet_DT =====
getCumRet_DT <- function(DataFrame, col_name = "CumRet"){
  
  if (is.data.frame(DataFrame)) {
    
    DataFrame$index <- as.Date(DataFrame$index)
    Retxts <- as.xts.data.table(DataFrame)

    if (is.xts(Retxts)) {
      Ret_xts <- na.omit(Retxts)
      CumRet_xts <- cumprod(Ret_xts + 1)
      CumRet_tb <- as.data.table(CumRet_xts)
      colnames(CumRet_tb) <- c(colnames(CumRet_tb)[1], col_name)
      CumRet_tb$index <- as.character(CumRet_tb$index)
      
    }
    else {
      stop("Price series must be a xts!")
    }
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(CumRet_tb)
}

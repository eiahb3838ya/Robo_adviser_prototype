## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

##### getDrawdowns =====
getDrawdowns <- function(Select_DT, col_name = "Drawdown") {
  
  if (is.data.frame(Select_DT)) {
    Select_DT$index <- as.Date(Select_DT$index)
    SelectXTS <- as.xts.data.table(Select_DT)
    
    # Retxts <- Ret_xts
    if (is.xts(SelectXTS)) {
      DD <- Drawdowns(SelectXTS)
      DD_DT <- as.data.table(DD)
      colnames(DD_DT) <- c(colnames(DD_DT)[1], col_name)
      DD_DT$index <- as.character(DD_DT$index)
    }
    else {
      stop("Price series must be a xts!")
    }
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(DD_DT)
}

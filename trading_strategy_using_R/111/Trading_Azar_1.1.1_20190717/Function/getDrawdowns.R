## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getDrawdowns =====
getDrawdowns <- function(Select_DT, col_name = "Drawdown") {
  
  Select_DT$index <- as.Date(Select_DT$index)
  SelectXTS <- as.xts.data.table(Select_DT)
  
  # Retxts <- Ret_xts
  if (is.xts(SelectXTS)) {
    DD <- Drawdowns(SelectXTS)
    DD_DT <- as.data.table(DD)
    colnames(DD_DT) <- c(colnames(DD_DT)[1], col_name)
    DD_DT$index <- as.character(DD_DT$index)
    return(DD_DT)
  }
  else {
    stop("Price series must be a xts!")
  }
  
}

## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getSelect_DT =====
getSelect_DT <- function(WinDT , StockCode = "2330"){
  ## Select_Code
  WinDT$index <- as.Date(WinDT$index)
  WinDT_XTS <- as.xts.data.table(WinDT)
  Select_XTS <- WinDT_XTS[ , StockCode, with = F ]
  Select_DT <- as.data.table(Select_XTS)
  Select_DT$index <- as.character(Select_DT$index)
  
  return(Select_DT)
}



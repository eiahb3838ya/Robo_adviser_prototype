## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

##### getSelect_DT =====
getSelect_DT <- function(DataFrame , StockCode = "2330", StartDate, EndDate){
  
  if (is.data.frame(DataFrame)) {
    
    DataFrame$index <- as.Date(DataFrame$index)
    Price_XTS <- as.xts.data.table(DataFrame)
    
    FirstDate <- time(Price_XTS)[1]
    LastDate <- time(Price_XTS)[NROW(Price_XTS)]
    
    if (StartDate >= FirstDate && EndDate <= LastDate) {
      
      SelectWin_XTS <- window(Price_XTS, start = StartDate, end = EndDate)
      SelectWin_XTS <- na.locf(SelectWin_XTS, na.rm = FALSE)
      SelectWin_XTS[is.na(SelectWin_XTS)] <- 0
      
    } else {
      stop("Date is wrong !")
    }
    
    Select_DT <- SelectWin_XTS[ , StockCode]
    
    Select_DT <- as.data.table(Select_DT)
    Select_DT$index <- as.character(Select_DT$index)
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(Select_DT)
}



## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### getCode_DT =====
getCode_DT <- function(DataFrame, StockCode = "2330"){
  # DataFrame <- SelectCol_DT
  # StockCode <- input$listID
  
  if (is.data.frame(DataFrame)) {
    
    DataFrame$index <- as.Date(DataFrame$index)
    Price_XTS <- as.xts.data.table(DataFrame)
    
    SelectPrice_XTS <- Price_XTS[,StockCode]
    PeriodDate <- SelectPrice_XTS[!is.na(SelectPrice_XTS)]
    FirstDate <- time(PeriodDate)[1]
    LastDate <- time(PeriodDate)[NROW(PeriodDate)]
    
    SelectCode_XTS <- window(Price_XTS, start = FirstDate, end = LastDate)
    
    SelectCode_DT <- as.data.table(SelectCode_XTS)
    SelectCode_DT$index <- as.character(SelectCode_DT$index)
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(SelectCode_DT)
}


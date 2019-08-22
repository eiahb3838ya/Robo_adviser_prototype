## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### getWin_DT =====
getWin_DT <- function(DataFrame, StartDate, EndDate){
  # DataFrame <- SelectCode_DT$DataTable
  # StartDate <- input$StartDate
  # EndDate <- input$EndDate
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
    
    SelectWin_DT <- as.data.table(SelectWin_XTS)
    SelectWin_DT$index <- as.character(SelectWin_DT$index)
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(SelectWin_DT)
}


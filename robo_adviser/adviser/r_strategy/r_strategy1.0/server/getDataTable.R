## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R 

##### getDataTable =====
getDataTable <- function(DataFrame) {
  if (is.data.frame(DataFrame)) {
    colnames(DataFrame) <- c("Stock_Code", "Date", "Open", "High", "Low", "Close","Vol")
    DataFrame$Date <- as.Date(as.character(DataFrame$Date),format = "%Y%m%d")
    DataFrame$Stock_Code <- as.character(DataFrame$Stock_Code)
    DataTable <- as.data.table(DataFrame)
  } else {
    stop("Data is not a DataFrame !")
  }
  return(DataTable)
}

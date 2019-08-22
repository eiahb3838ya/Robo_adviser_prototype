## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### getDT_FromSQL =====
getDT_FromSQL <- function(DataFrame ){
  # DataFrame <- readDataFrame
  if (is.data.frame(DataFrame)) {
    colnames(DataFrame) <- c("Stock_Code", "index", "Open", "High", "Low", "Close","Vol")
    DataFrame$index <- as.character(DataFrame$index)
    DataFrame$Stock_Code <- as.character(DataFrame$Stock_Code)
    DataTable <- as.data.table(DataFrame)
   
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(DataTable)
}

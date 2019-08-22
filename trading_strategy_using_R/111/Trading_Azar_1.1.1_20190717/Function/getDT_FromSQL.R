## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### getDT_FromSQL =====
getDT_FromSQL <- function(DataFrame){
  DataTable <- getDataTable(DataFrame)
  DataTable <- DataTable[DataTable$Stock_Code != "50",]
  return(DataTable)
}
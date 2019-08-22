## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getPloty =====
getPloty <- function(Select_DT){
  Select_DT$index <- as.Date(Select_DT$index)
  return(Select_DT)
}

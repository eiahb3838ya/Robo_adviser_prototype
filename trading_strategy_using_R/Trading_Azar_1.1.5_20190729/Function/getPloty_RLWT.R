## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getPloty_RLWT =====
getPloty_RLWT <- function(Select_DT){
  
  Select_DT$Period <- seq_len(NROW(Select_DT$index))
  Select_DT$index <- as.Date(Select_DT$index)
  return(Select_DT)
}

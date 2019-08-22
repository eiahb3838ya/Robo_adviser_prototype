## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### getPloty_RLWT =====
getPloty_H_WT <- function(Select_DT){
  
  # Select_DT <- Trading_Portfolio$Markowitz_Wt
  Select_H_DT <- as.data.table(t(Select_DT[NROW(Select_DT),-1]))
  Select_H_DT <- cbind(Select_H_DT, colnames(Select_DT[NROW(Select_DT),-1]))
  colnames(Select_H_DT) <- c("Wt", "Strategy")
  
  return(Select_H_DT)
}

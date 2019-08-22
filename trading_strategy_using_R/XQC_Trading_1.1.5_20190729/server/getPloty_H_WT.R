## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### getPloty_RLWT =====
getPloty_H_WT <- function(Select_DT){

  # Select_DT <- Trading_Portfolio$Markowitz_Wt
  Select_round <- round(Select_DT[NROW(Select_DT), -1], digits = 4)
  Select_Tp <- as.data.table(t(Select_round))
  Select_H_DT <- cbind(Select_Tp, colnames(Select_round))
  colnames(Select_H_DT) <- c("Wt", "Strategy")

  return(Select_H_DT)
}

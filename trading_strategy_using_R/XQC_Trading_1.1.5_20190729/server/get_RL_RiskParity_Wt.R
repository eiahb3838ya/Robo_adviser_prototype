## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_RiskParity_Wt =====
get_RL_RiskParity_Wt <- function(RL_List, col_name){

  ##### RL_Riskparity_Date =====
  RL_Riskparity_Date <- lapply(RL_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_Riskparity_Date_All <- do.call(rbind, RL_Riskparity_Date)
  
  ##### RL_Riskparity_Wt =====
  RL_Riskparity_Wt <- lapply(RL_List, function(idx){
    data <- idx[["RL_Wt_Riskparity"]]
  })
  RL_Riskparity_Wt_All <- do.call(rbind, RL_Riskparity_Wt)
  
  ##### Weight =====
  Wt <- data.table(RL_Riskparity_Date_All, RL_Riskparity_Wt_All)
  colnames(Wt) <- c("index", col_name)

  return(Wt)
}

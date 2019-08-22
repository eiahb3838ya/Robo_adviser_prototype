## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_CVaR_Wt =====
get_RL_CVaR_Wt <- function(RL_List, col_name){

  ##### RL_CVaR_Date =====
  RL_CVaR_Date <- lapply(RL_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_CVaR_Date_All <- do.call(rbind, RL_CVaR_Date)
  
  ##### RL_Markowitz_Wt =====
  RL_CVaR_Wt <- lapply(RL_List, function(idx){
    data <- idx[["RL_Wt_CVaR"]]
  })
  RL_CVaR_Wt_All <- do.call(rbind, RL_CVaR_Wt)
  print("RL_CVaR_Wt")
  
  ##### Weight =====
  Wt <- data.table(RL_CVaR_Date_All, RL_CVaR_Wt_All)
  colnames(Wt) <- c("index", col_name)
  
  return(Wt)
}

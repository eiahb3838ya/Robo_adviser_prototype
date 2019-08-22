## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_CVaR_Ret =====
get_RL_CVaR_Ret <- function(RL_List){
  
  ##### RL_CVaR_Date =====
  RL_CVaR_Date <- lapply(RL_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_CVaR_Date_All <- do.call(rbind, RL_CVaR_Date)
  
  ##### RL_CVaR_Ret =====
  RL_CVaR_Ret <- lapply(RL_List, function(idx){
    data <- idx[["RL_Ret_CVaR"]]
  })
  RL_CVaR_Ret_All <- do.call(rbind,RL_CVaR_Ret)
  
  ##### Return =====
  Ret <- data.table(RL_CVaR_Date_All, RL_CVaR_Ret_All)
  colnames(Ret) <- c("index", "Ret")

  return(Ret)
}

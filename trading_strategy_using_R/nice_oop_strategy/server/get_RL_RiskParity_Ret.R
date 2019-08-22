## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_RiskParity_Ret =====
get_RL_RiskParity_Ret <- function(RL_List){

  ##### RL_Riskparity_Date =====
  RL_Riskparity_Date <- lapply(RL_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_Riskparity_Date_All <- do.call(rbind, RL_Riskparity_Date)

  ##### RL_Riskparity_Ret =====
  RL_Riskparity_Ret <- lapply(RL_List, function(idx){
    data <- idx[["RL_Ret_Riskparity"]]
  })
  RL_Riskparity_Ret_All <- do.call(rbind,RL_Riskparity_Ret)
  
  ##### Return =====
  Ret <- data.table(RL_Riskparity_Date_All, RL_Riskparity_Ret_All)
  colnames(Ret) <- c("index", "Ret")
  
  return(Ret)
}

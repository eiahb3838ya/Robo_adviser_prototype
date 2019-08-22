## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_Markowitz_Ret =====
get_RL_Markowitz_Ret <- function(RL_List){
  
  # RL_List <- RL_Markowitz
  # col_name = colnames(Portfolio_All$Equity_All)[-1]
  ##### RL_Markowitz_Date =====
  RL_Markowitz_Date <- lapply(RL_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_Markowitz_Date_All <- do.call(rbind, RL_Markowitz_Date)
  
  ##### RL_Markowitz_Ret =====
  RL_Markowitz_Ret <- lapply(RL_List, function(idx){
    data <- idx[["RL_Ret_Markowitz"]]
  })
  RL_Markowitz_Ret_All <- do.call(rbind,RL_Markowitz_Ret)

  ##### Return =====
  Ret <- data.table(RL_Markowitz_Date_All, RL_Markowitz_Ret_All)
  colnames(Ret) <- c("index", "Ret")
  
  return(Ret)
}

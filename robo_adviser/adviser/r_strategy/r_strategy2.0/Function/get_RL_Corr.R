## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_Corr =====
get_RL_Corr <- function(RL_List, col_name){
  
  # RL_List <- RL_Markowitz
  # col_name = colnames(Portfolio_All$Equity_All)[-1]
  ##### RL_Markowitz_Date =====
  RL_Date <- lapply(RL_List, function(idx){
    # idx <- RL_Markowitz_List[[1]]
    data <- idx[["Date"]]
  })
  RL_Date_All <- do.call(rbind, RL_Date)
  
  ##### RL_Markowitz_Corr =====
  RL_Corr <- lapply(RL_List, function(idx){
    data <- idx[["RL_Corr"]]
  })
  RL_Corr_All <- do.call(rbind, RL_Corr)

  ##### Correlation =====
  Cor <- data.table(RL_Date_All, RL_Corr_All)
  colnames(Cor) <- c("index", col_name)
  
  return(Cor)
}

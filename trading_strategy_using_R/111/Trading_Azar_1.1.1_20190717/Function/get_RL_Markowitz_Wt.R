## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_Markowitz_Wt =====
get_RL_Markowitz_Wt <- function(RL_List, col_name){
  
  # RL_List <- RL_Markowitz
  # col_name = base::setdiff(colnames(Portfolio_All$Equity_All), "Index")[-1]
  ##### RL_Markowitz_Date =====
  RL_Markowitz_Date <- lapply(RL_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_Markowitz_Date_All <- do.call(rbind, RL_Markowitz_Date)
  
  ##### RL_Markowitz_Wt =====
  RL_Markowitz_Wt <- lapply(RL_List, function(idx){
    data <- idx[["RL_Wt_Markowitz"]]
  })
  RL_Markowitz_Wt_All <- do.call(rbind, RL_Markowitz_Wt)

  ##### Weight =====
  Wt <- data.table(RL_Markowitz_Date_All, RL_Markowitz_Wt_All)
  colnames(Wt) <- c("index", col_name)
 
  return(Wt)
}

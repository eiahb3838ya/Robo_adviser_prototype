## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_Markowitz =====
get_RL_Markowitz <- function(RL_Data, Startn, Endn, Next_n){
  # RL_Data <- Portfolio_All$Equity_All

  RL_Data$index <- as.Date(RL_Data$index)
  RL_Data <- as.xts.data.table(RL_Data)
  
  startTime <- Sys.time()
  RL_Markowitz_List <- lapply(seq_len(length(Startn)), function(idx){
    
    # idx <- 1
    print(paste0("Markowitz Rolling: ", idx))
    Select_Ret <- base::subset(RL_Data, time(RL_Data) > Startn[idx] & time(RL_Data) < Endn[idx])
    Next_Ret <- RL_Data[Next_n[idx],-1]
    Next_Date <- as.character(Next_n[idx])
    # RL_Times <- paste0("Start: ", Startn[idx], ", End: ", Endn[idx], ", Next: ", Next_n[idx])
    
    RL_Corr <- t(cor(Select_Ret)[1,])
    Select_mu <- base::colMeans(Select_Ret[,-1])
    Select_Sigma <- stats::cov(Select_Ret[,-1])
    # design portfolio
    RL_Wt_Markowitz <- Fun_Markowitz(Select_mu, Select_Sigma, 2)
    RL_Ret_Markowitz <- Next_Ret %*% RL_Wt_Markowitz
    
    return(list(Date = Next_Date,
                RL_Corr = RL_Corr,
                RL_Wt_Markowitz = RL_Wt_Markowitz,
                RL_Ret_Markowitz = RL_Ret_Markowitz
    ))
  })
  EndTime <- Sys.time()
  print(paste0("Markowitz Rolling Time:", startTime," : ", EndTime))
  
  return(RL_Markowitz_List)
  
  
}

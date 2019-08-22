## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### get_RL_CVaR =====
get_RL_CVaR <- function(RL_Data, Startn, Endn, Next_n){
  # RL_Data <- Portfolio_All$Equity_All
  RL_Data$index <- as.Date(RL_Data$index)
  RL_Data <- as.xts.data.table(RL_Data)
  
  startTime <- Sys.time()
  RL_CVaR_List <- lapply(seq_len(length(Startn)), function(idx){
    
    # idx <- 1
    print(paste0("CVaR Rolling: ", idx))
    Select_Ret <- base::subset(RL_Data, time(RL_Data) > Startn[idx] & time(RL_Data) < Endn[idx])
    Next_Ret <- RL_Data[Next_n[idx],-1]
    Next_Date <- as.character(Next_n[idx])
    
    RL_Corr <- t(cor(Select_Ret)[1,])
    RL_Wt_CVaR <- Fun_CVaR(Select_Ret[,-1], lmd = 0.5, alpha = 0.95)
    RL_Ret_CVaR <- Next_Ret %*% RL_Wt_CVaR
    
    return(list(Date = Next_Date,
                RL_Corr = RL_Corr,
                RL_Wt_CVaR = RL_Wt_CVaR,
                RL_Ret_CVaR = RL_Ret_CVaR
    ))
  })
  EndTime <- Sys.time()
  print(paste0("CVaR Rolling Time:", startTime," : ", EndTime))
  
  return(RL_CVaR_List)
  
  
}

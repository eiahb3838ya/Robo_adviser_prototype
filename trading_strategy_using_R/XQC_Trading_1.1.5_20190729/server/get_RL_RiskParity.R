## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### get_RL_Riskparity =====
get_RL_RiskParity <- function(RL_Data, Startn, Endn, Next_n) {
  
  if (is.data.frame(RL_Data)) {
    
    # RL_Data <- Portfolio_All$Equity_All
    RL_Data$index <- as.Date(RL_Data$index)
    RL_Data <- as.xts.data.table(RL_Data)
    
    startTime <- Sys.time()
    RL_Riskparity_List <- lapply(seq_len(length(Startn)), function(idx){
      
      # idx <- 1
      print(paste0("Riskparity Rolling: ", idx))
      Select_Ret <- base::subset(RL_Data, time(RL_Data) > Startn[idx] & time(RL_Data) < Endn[idx])
      Period_Ret <- base::subset(RL_Data, time(RL_Data) > Endn[idx] & time(RL_Data) <= Next_n[idx])
      
      RL_Corr <- t(cor(Select_Ret)[1,])
      Select_Sigma <- stats::cov(Select_Ret[,-1])
      # design portfolio
      RL_Wt_Riskparity <- Fun_RiskParity(Select_Sigma, N = NCOL(Select_Sigma))
      
      Next_Ret <- cumprod(Period_Ret[,-1] + 1)[NROW(Period_Ret)]
      Next_Date <- as.character(time(Next_Ret))
      
      RL_Ret_Riskparity <- (Next_Ret %*% RL_Wt_Riskparity) - 1
      
      return(list(Date = Next_Date,
                  RL_Corr = RL_Corr,
                  RL_Wt_Riskparity = RL_Wt_Riskparity,
                  RL_Ret_Riskparity = RL_Ret_Riskparity
      ))
    })
    EndTime <- Sys.time()
    print(paste0("Riskparity Rolling Time:",startTime," : ", EndTime))
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(RL_Riskparity_List)
}

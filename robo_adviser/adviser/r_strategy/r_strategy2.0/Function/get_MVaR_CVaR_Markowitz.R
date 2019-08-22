## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### get_MVaR_CVaR_Markowitz =====
get_MVaR_CVaR_Markowitz <- function(Ret_Data){
  # Ret_Data <- Portfolio_All$Equity_All
  if (is.data.frame(Ret_Data)) {
    
    Ret_Data$index <- as.Date(Ret_Data$index)
    Ret_xts <- as.xts.data.table(Ret_Data)
    
    if (is.xts(Ret_xts)) {
      
      Select_mu <- base::colMeans(Ret_xts[,-1])
      Select_COV_MT <- stats::cov(Ret_xts[,-1])
      
      ## Weight
      Wt_Markowitz <- Fun_Markowitz(Select_mu, Select_COV_MT, 2)
      Wt_Markowitz_DT <- cbind(Wt_Markowitz, colnames(Ret_xts)[-1])
      Wt_Markowitz_DT <- as.data.table(Wt_Markowitz_DT)
      colnames(Wt_Markowitz_DT) <- c("Wt", "Strategy")
      Wt_Markowitz_DT$Wt <- as.numeric(Wt_Markowitz_DT$Wt)
      
      ## Return Contribution
      RC_Markowitz <- Select_mu * Wt_Markowitz_DT$Wt
      RC_Markowitz_DT <- as.data.table(cbind(RC_Markowitz, colnames(Ret_xts)[-1]))
      colnames(RC_Markowitz_DT) <- c("RetContri", "Strategy")
      RC_Markowitz_DT$RetContri <- as.numeric(RC_Markowitz_DT$RetContri)
      
      ## Volatility
      Vol_Markowitz <- sqrt(t(Wt_Markowitz) %*% Select_COV_MT %*% Wt_Markowitz)
      MVaR_Markowitz <- qnorm(0.95) * (Select_COV_MT %*% Wt_Markowitz)/as.numeric(Vol_Markowitz)
      CVaR_Markowitz <- MVaR_Markowitz * Wt_Markowitz
      
      MVaR_Markowitz_DT <- as.data.table(MVaR_Markowitz)
      MVaR_Markowitz_DT <- cbind(MVaR_Markowitz_DT, colnames(Ret_xts)[-1])
      colnames(MVaR_Markowitz_DT) <- c("MVaR", "Strategy")
      
      CVaR_Markowitz_DT <- as.data.table(CVaR_Markowitz)
      CVaR_Markowitz_DT <- cbind(CVaR_Markowitz_DT, colnames(Ret_xts)[-1])
      colnames(CVaR_Markowitz_DT) <- c("CVaR", "Strategy")
      
    } else {
      stop("Data is not a xts !")
    }
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(list(RC = RC_Markowitz_DT, Wt = Wt_Markowitz_DT, MVaR = MVaR_Markowitz_DT, CVaR = CVaR_Markowitz_DT))
}

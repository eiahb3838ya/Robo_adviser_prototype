## Azar Lin
## 20190717
## OOP
## XQC_Trading_Fun2.R

##### get_MVaR_CVaR_CVaR =====
get_MVaR_CVaR_CVaR <- function(Ret_Data){
  # Ret_Data <- Portfolio_All$Equity_All
  
  Ret_Data$index <- as.Date(Ret_Data$index)
  Ret_Data <- as.xts.data.table(Ret_Data)
  
  Select_mu <- base::colMeans(Ret_Data[,-1])
  Select_COV_MT <- stats::cov(Ret_Data[,-1])
  ## Weight
  Wt_CVaR <- Fun_CVaR(Ret_Data[,-1], lmd = 0.5, alpha = 0.95)
  Wt_CVaR_DT <- cbind(round(Wt_CVaR, digits = 4), colnames(Ret_Data)[-1])
  Wt_CVaR_DT <- as.data.table(Wt_CVaR_DT)
  colnames(Wt_CVaR_DT) <- c("Wt", "Strategy")
  Wt_CVaR_DT$Wt <- as.numeric(Wt_CVaR_DT$Wt)
  
  ## Return Contribution
  RC_CVaR <- Select_mu * Wt_CVaR_DT$Wt
  RC_CVaR_DT <- as.data.table(cbind(RC_CVaR, colnames(Ret_Data)[-1]))
  colnames(RC_CVaR_DT) <- c("RetContri", "Strategy")
  RC_CVaR_DT$RetContri <- as.numeric(RC_CVaR_DT$RetContri)
  
  ## Volatility
  Vol_CVaR <- sqrt(t(Wt_CVaR) %*% Select_COV_MT %*% Wt_CVaR)
  MVaR_CVaR <- qnorm(0.95) * (Select_COV_MT %*% Wt_CVaR)/as.numeric(Vol_CVaR)
  CVaR_CVaR <- MVaR_CVaR * Wt_CVaR
  
  MVaR_CVaR_DT <- as.data.table(MVaR_CVaR)
  MVaR_CVaR_DT <- cbind(MVaR_CVaR_DT, colnames(Ret_Data)[-1])
  colnames(MVaR_CVaR_DT) <- c("MVaR", "Strategy")
  
  CVaR_CVaR_DT <- as.data.table(CVaR_CVaR)
  CVaR_CVaR_DT <- cbind(CVaR_CVaR_DT, colnames(Ret_Data)[-1])
  CVaR_CVaR_DT <- as.data.table(CVaR_CVaR_DT)
  colnames(CVaR_CVaR_DT) <- c("CVaR", "Strategy")
  
  return(list(RC = RC_CVaR_DT, Wt = Wt_CVaR_DT, MVaR = MVaR_CVaR_DT, CVaR = CVaR_CVaR_DT))
  
}

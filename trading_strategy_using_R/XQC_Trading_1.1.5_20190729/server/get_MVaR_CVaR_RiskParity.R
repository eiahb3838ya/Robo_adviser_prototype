## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### get_MVaR_CVaR_RiskParity =====
get_MVaR_CVaR_RiskParity <- function(Ret_Data){
  # Ret_Data <- Portfolio_All$Equity_All
  if (is.data.frame(Ret_Data)) {
    
    Ret_Data$index <- as.Date(Ret_Data$index)
    Ret_xts <- as.xts.data.table(Ret_Data)
    
    if (is.xts(Ret_xts)) {
      
      Select_mu <- base::colMeans(Ret_xts[,-1])
      Select_COV_MT <- stats::cov(Ret_xts[,-1])
      
      ## Weight
      Wt_RiskParity <- Fun_RiskParity(Select_COV_MT, N = NCOL(Select_COV_MT))
      Wt_RiskParity_DT <- as.data.table(Wt_RiskParity)
      Wt_RiskParity_DT <- cbind(Wt_RiskParity_DT, colnames(Ret_xts)[-1])
      Wt_RiskParity_DT <- as.data.table(Wt_RiskParity_DT)
      colnames(Wt_RiskParity_DT) <- c("Wt", "Strategy")
      Wt_RiskParity_DT$Wt <- as.numeric(Wt_RiskParity_DT$Wt)
      
      ## Return Contribution
      RC_RiskParity <- Select_mu * Wt_RiskParity_DT$Wt
      RC_RiskParity_DT <- as.data.table(cbind(RC_RiskParity, colnames(Ret_xts)[-1]))
      colnames(RC_RiskParity_DT) <- c("RetContri", "Strategy")
      RC_RiskParity_DT$RetContri <- as.numeric(RC_RiskParity_DT$RetContri)
      
      ## Volatility
      Vol_Riskparity <- sqrt(t(Wt_RiskParity) %*% Select_COV_MT %*% Wt_RiskParity)
      MVaR_Riskparity <- qnorm(0.95) * (Select_COV_MT %*% Wt_RiskParity)/as.numeric(Vol_Riskparity)
      CVaR_Riskparity <- MVaR_Riskparity * Wt_RiskParity
      
      MVaR_Riskparity_DT <- as.data.table(MVaR_Riskparity)
      MVaR_Riskparity_DT <- cbind(MVaR_Riskparity_DT, colnames(Ret_xts)[-1])
      colnames(MVaR_Riskparity_DT) <- c("MVaR", "Strategy")
      
      CVaR_Riskparity_DT <- as.data.table(CVaR_Riskparity)
      CVaR_Riskparity_DT <- cbind(CVaR_Riskparity_DT, colnames(Ret_xts)[-1])
      colnames(CVaR_Riskparity_DT) <- c("CVaR", "Strategy")
      
    } else {
      stop("Data is not a xts !")
    }
  }  else {
    stop("Data is not a DataFrame !")
  }
  
  return(list(RC = RC_RiskParity_DT, Wt = Wt_RiskParity_DT, MVaR = MVaR_Riskparity_DT, CVaR = CVaR_Riskparity_DT))
}

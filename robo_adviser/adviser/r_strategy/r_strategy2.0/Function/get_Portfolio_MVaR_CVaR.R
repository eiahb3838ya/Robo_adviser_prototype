
get_Portfolio_MVaR_CVaR<-function(Equity_All){
  Portfolio_EFrontier <- get_EfficientFrontier(Equity_All)

  ##### MVaR_CVaR_Markowitz =====
  MVaR_CVaR_Markowitz <- get_MVaR_CVaR_Markowitz(Equity_All)
  ##### MVaR_CVaR_Riskparity =====
  MVaR_CVaR_RiskParity <- get_MVaR_CVaR_RiskParity(Equity_All)
  ##### MVaR_CVaR_CVaR =====
  MVaR_CVaR_CVaR <- get_MVaR_CVaR_CVaR(Equity_All)
  Portfolio_MVaR_CVaR <- list(RC_Markowitz = MVaR_CVaR_Markowitz$RC,
                              Wt_Markowitz = MVaR_CVaR_Markowitz$Wt,
                              MVaR_Markowitz = MVaR_CVaR_Markowitz$MVaR,
                              CVaR_Markowitz = MVaR_CVaR_Markowitz$CVaR,
                              
                              RC_RiskParity = MVaR_CVaR_RiskParity$RC,
                              Wt_RiskParity = MVaR_CVaR_RiskParity$Wt,
                              MVaR_RiskParity = MVaR_CVaR_RiskParity$MVaR,
                              CVaR_RiskParity = MVaR_CVaR_RiskParity$CVaR,
                              
                              RC_CVaR = MVaR_CVaR_CVaR$RC,
                              Wt_CVaR = MVaR_CVaR_CVaR$Wt,
                              MVaR_CVaR = MVaR_CVaR_CVaR$MVaR,
                              CVaR_CVaR = MVaR_CVaR_CVaR$CVaR)

}
## Azar Lin
## 20190717
## OOP
## XQC_Trading_Fun2.R

##### get_EfficientFrontier =====
get_EfficientFrontier <- function(Ret_Data, RF = 0){
  # Ret_Data <- Portfolio_All$Equity_All
  if (is.data.frame(Ret_Data)) {
    
    Ret_Data$index <- as.Date(Ret_Data$index)
    Ret_xts <- as.xts.data.table(Ret_Data)
    
    if (is.xts(Ret_xts)) {
      
      Ret_xts <- Ret_xts[,-1]
      Ret_ts <- as.timeSeries(Ret_xts)
      
      if (is.timeSeries(Ret_ts)) {
        EffFrontier <- portfolioFrontier(Ret_ts, constraints = "LongOnly")
        # tailoredFrontierPlot(EffFrontier)
        
        tgPortfolio <- tangencyPortfolio(Ret_ts,  constraints = "LongOnly")
        
        tgAssets <- frontierPoints(tgPortfolio, auto = FALSE)
        # slope <- (tgAssets[2] - RF)/tgAssets[1]
        
        targetReturn <- as.data.table(EffFrontier@portfolio@portfolio$targetReturn)[,2]
        targetRisk <- as.data.table(EffFrontier@portfolio@portfolio$targetRisk)
        Mu <- as.data.table(t(EffFrontier@data@statistics$mu))
        Sigma <- data.table(t(sqrt(diag(cov(Ret_xts)))))
        Return <- EffFrontier@portfolio@portfolio$minriskPortfolio@portfolio@portfolio$targetReturn
        Risk <- EffFrontier@portfolio@portfolio$minriskPortfolio@portfolio@portfolio$targetRisk
        
      } else {
        stop("Data is not a timeSeries !")
      }
    } else {
      stop("Data is not a xts !")
    }
    
  } else {
    stop("Data is not a DataFrame !")
  }
    
  return(list(targetRisk = targetRisk, targetReturn = targetReturn,
              Sigma = Sigma, Mu = Mu,
              Return = Return, Risk = Risk,
              tgReturn = tgAssets[[2]],
              tgRisk = tgAssets[[1]]))
}

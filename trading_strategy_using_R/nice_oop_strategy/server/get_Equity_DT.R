## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### get_Equity_DT =====
get_Equity_DT <- function(Equity_MACD, Equity_RSI, Equity_MA, Equity_BB, Equity_Dist, Equity_Corr) {
  
  Equity_MACD$index <- as.Date(Equity_MACD$index)
  Equity_RSI$index <- as.Date(Equity_RSI$index)
  Equity_MA$index <- as.Date(Equity_MA$index)
  Equity_BB$index <- as.Date(Equity_BB$index)
  Equity_Dist$index <- as.Date(Equity_Dist$index)
  Equity_Corr$index <- as.Date(Equity_Corr$index)
  
  Equity_MACD_XTS <- as.xts.data.table(Equity_MACD)
  Equity_RSI_XTS <- as.xts.data.table(Equity_RSI)
  Equity_MA_XTS <- as.xts.data.table(Equity_MA)
  Equity_BB_XTS <- as.xts.data.table(Equity_BB)
  Equity_Dist_XTS <- as.xts.data.table(Equity_Dist)
  Equity_Corr_XTS <- as.xts.data.table(Equity_Corr)
  
  Equity_XTS <- merge(Equity_MACD_XTS,
                      Equity_RSI_XTS,
                      Equity_MA_XTS,
                      Equity_BB_XTS,
                      Equity_Dist_XTS,
                      Equity_Corr_XTS
                      # Trading_Ret_Coin
                      )
  
  colnames(Equity_XTS) <- c("MACD", 
                            "RSI", 
                            "MA",
                            "BB",
                            "Dist",
                            "Corr"
                            # "Coin"
                            )
  Equity_All <- na.omit(Equity_XTS)
  
  Equity_All_DT <- as.data.table(Equity_All)
  Equity_All_DT$index <- as.character(Equity_All_DT$index)
  
  return(Equity_All_DT)

}




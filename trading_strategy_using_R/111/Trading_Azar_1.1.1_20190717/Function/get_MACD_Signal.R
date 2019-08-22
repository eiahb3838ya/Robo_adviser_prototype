## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

## SelectData
## Lag_periods = 1
## MACD_Fast = 12
## MACD_Slow = 26 
## MACD_Sig = 9

##### get_MACD_Signal =====
get_MACD_Signal <- function(Select_DT, Lag_periods = 1, MACD_Fast = 12, MACD_Slow = 26, MACD_Sig = 9, MACD_maType = "SMA", MACD_percent = FALSE){
  
  Select_DT$index <- as.Date(Select_DT$index)
  SelectXTS <- as.xts.data.table(Select_DT)
  
  if (is.xts(SelectXTS)) {
    
    macd <- MACD(SelectXTS, nFast = MACD_Fast, nSlow = MACD_Slow, nSig = MACD_Sig, maType = MACD_maType, percent = MACD_percent)
    
    signal_macd <- rep(NA, NROW(macd))
    signal_macd <- ifelse((macd$signal > macd$macd), 1, ifelse((macd$signal < macd$macd), -1, 0))
    
    lag1_signal_macd <- stats::lag(signal_macd, k = Lag_periods, na.pad = TRUE)
    colnames(lag1_signal_macd) <- "MACD_signal"
    
    lag1_signal_macd_DT <- as.data.table(lag1_signal_macd)
    lag1_signal_macd_DT$index <- as.character(lag1_signal_macd_DT$index)
    
    return(lag1_signal_macd_DT)
  }
  else {
    stop("Price series must be a xts!")
  }
}

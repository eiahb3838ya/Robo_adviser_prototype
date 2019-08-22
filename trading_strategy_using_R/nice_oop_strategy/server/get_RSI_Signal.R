## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

## SelectData
## Lag_periods = 1
## RSI_ma = 5
## RSI_maType = "SMA"
## RSI_Up = 70
## RSI_Down = 30

##### get_RSI_Signal =====
get_RSI_Signal <- function(Select_DT, Lag_periods = 1, RSI_ma = 5, RSI_maType = "SMA", RSI_Up = 70, RSI_Down = 30){
  
  Select_DT$index <- as.Date(Select_DT$index)
  SelectXTS <- as.xts.data.table(Select_DT)
  
  if (is.xts(SelectXTS)) {
    
    RSI <- RSI(SelectXTS, n = RSI_ma, maType = RSI_maType)
    
    signal_rsi <- rep(NA, NROW(RSI))
    signal_rsi <- ifelse((RSI$rsi > RSI_Up), -1, ifelse((RSI$rsi < RSI_Down), 1, 0))
    
    lag1_signal_rsi <- stats::lag(signal_rsi, k = Lag_periods, na.pad = TRUE)
    colnames(lag1_signal_rsi) <- "RSI_signal"
    
    lag1_signal_rsi_DT <- as.data.table(lag1_signal_rsi)
    lag1_signal_rsi_DT$index <- as.character(lag1_signal_rsi_DT$index)
    
    return(lag1_signal_rsi_DT)
  }
  else {
    stop("Price series must be a xts!")
  }
}

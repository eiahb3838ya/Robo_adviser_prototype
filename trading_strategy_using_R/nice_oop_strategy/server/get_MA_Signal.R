## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

## SelectData
## Lag_periods = 1
## MA_fast = 10
## MA_slow = 20

##### get_MA_Signal =====
get_MA_Signal <- function(Select_DT, Lag_periods = 1, MA_fast = 10, MA_slow = 20){
  
  Select_DT$index <- as.Date(Select_DT$index)
  SelectXTS <- as.xts.data.table(Select_DT)
  
  if (is.xts(SelectXTS)) {
    
    mafast <- SMA(SelectXTS, MA_fast)
    maslow <- SMA(SelectXTS, MA_slow)
    signal_ma <- rep(NA, NROW(mafast))
    signal_ma <- ifelse((mafast > maslow), 1, ifelse((mafast < maslow), -1, 0))
    
    lag1_signal_ma <- stats::lag(signal_ma, k = Lag_periods, na.pad = TRUE)
    colnames(lag1_signal_ma) <- "MA_signal"
    
    lag1_signal_ma_DT <- as.data.table(lag1_signal_ma)
    lag1_signal_ma_DT$index <- as.character(lag1_signal_ma_DT$index)
    
    
    return(lag1_signal_ma_DT)
  }
  else {
    stop("Price series must be a xts!")
  }
}

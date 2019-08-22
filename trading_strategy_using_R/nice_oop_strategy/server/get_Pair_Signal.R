## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

## SelectData
## Lag_periods = 1
## Dist_Pair
## Dist_size = 20
## Dist_k = 1

##### get_Pair_Signal =====
get_Pair_Signal <- function(Win_DT, Lag_periods = 1, Dist_Pair, SignalName, Pair_size = 20, Pair_k = 1) {

  Win_DT$index <- as.Date(Win_DT$index)
  Win_XTS <- as.xts.data.table(Win_DT)
  
  if (is.xts(Win_XTS)) {
    
    stock_x <- Win_XTS[,Dist_Pair$stock1]
    stock_y <- Win_XTS[,Dist_Pair$stock2]
    
    hedge_ratio <- stock_y/stock_x
    roll_mu <- runMean(hedge_ratio, Pair_size)
    roll_std <- runSD(hedge_ratio, Pair_size)
    
    roll_ub <- roll_mu + Pair_k * roll_std
    roll_lb <- roll_mu - Pair_k * roll_std
    
    signal_dist <- matrix(NA, nrow = NROW(hedge_ratio), ncol = NCOL(hedge_ratio))
    signal_dist <- ifelse(hedge_ratio > roll_ub,-1, ifelse(hedge_ratio < roll_lb,1, 0))
    
    lag1_signal <- stats::lag(signal_dist, k = Lag_periods, na.pad = TRUE)
    colnames(lag1_signal) <- SignalName
    
    lag1_signal_DT <- as.data.table(lag1_signal)
    lag1_signal_DT$index <- as.character(lag1_signal_DT$index)
    
    return(lag1_signal_DT)
  }
  else {
    stop("Price series must be a xts!")
  }
  
}

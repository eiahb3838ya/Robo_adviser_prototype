## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

## SelectData
## Lag_periods = 1
## BB_size = 20 
## BB_k = 1

##### get_BB_Signal =====
get_BB_Signal <- function(Select_DT, Lag_periods = 1, BB_size = 20, BB_k = 1){
  
  Select_DT$index <- as.Date(Select_DT$index)
  SelectXTS <- as.xts.data.table(Select_DT)
  
  if (is.xts(SelectXTS)) {
    
    roll_mu_BB <- runMean(SelectXTS, BB_size)
    roll_std_BB <- runSD(SelectXTS, BB_size)
    roll_ub_BB <- roll_mu_BB + BB_k * roll_std_BB
    roll_lb_BB <- roll_mu_BB - BB_k * roll_std_BB
    
    signal_BB <- matrix(NA, nrow = NROW(SelectXTS), ncol = NCOL(SelectXTS))
    signal_BB <- ifelse(SelectXTS > roll_ub_BB,-1, ifelse(SelectXTS < roll_lb_BB,1, 0))
    
    lag1_signal_BB <- stats::lag(signal_BB, k = Lag_periods, na.pad = FALSE)
    colnames(lag1_signal_BB) <- "BB_signal"
    
    lag1_signal_BB_DT <- as.data.table(lag1_signal_BB)
    lag1_signal_BB_DT$index <- as.character(lag1_signal_BB_DT$index)
    
    return(lag1_signal_BB_DT)
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### XQ_MACD_Ret =====
## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### XQ_MACD_Ret =====
XQ_MACD_Ret <- function(SPD, MACD_Fast = 12, MACD_Slow = 26, MACD_Sig = 9, MACD_maType = "SMA", MACD_percent = FALSE){
  
  if (is.xts(SPD)) {
    # SPD <- SelectXTS
    macd <- MACD(SPD, nFast = MACD_Fast, nSlow = MACD_Slow, nSig = MACD_Sig, maType = MACD_maType, percent = MACD_percent)
    
    signal_macd <- rep(NA, NROW(macd))
    signal_macd <- ifelse((macd$signal > macd$macd), 1, ifelse((macd$signal < macd$macd), -1, 0))
    # signal_macd[is.na(signal_macd)] <- 0
    
    lag1_signal_macd <- stats::lag(signal_macd, k = 1, na.pad = TRUE)
    lag2_signal_macd <- stats::lag(signal_macd, k = 2, na.pad = TRUE)
    # lag3_signal_macd <- stats::lag(signal_macd, k = 3, na.pad = TRUE)
    
    Rt_MACD <- Delt(SPD)
    
    cost_macd <- matrix(NA, nrow = NROW(lag1_signal_macd), ncol = NCOL(lag1_signal_macd))
    cost_macd <- abs(lag1_signal_macd*(ifelse(lag1_signal_macd == lag2_signal_macd,0,0.006)))
    cost_macd[is.na(cost_macd)] <- 0
    
    return(list(Trading_Ret_MACD = Rt_MACD*lag1_signal_macd, 
                Trading_Ret_MACD_Cost = Rt_MACD*lag1_signal_macd - cost_macd,
                Sig_MACD = lag1_signal_macd,
                Ret_MACD = Rt_MACD))
  }
  else {
    stop("Price series must be a xts!")
  }
}

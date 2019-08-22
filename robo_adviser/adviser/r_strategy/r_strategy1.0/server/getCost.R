## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

## SelectData
## Lag_periods = 1
## MACD_Fast = 12
## MACD_Slow = 26 
## MACD_Sig = 9

##### getMACDCost =====
getCost <- function(signal, Lag_periods = 1){
  lag1_signal <- signal
  lag2_signal <- stats::lag(signal, k = Lag_periods, na.pad = TRUE)
  cost_Trading <- matrix(NA, nrow = NROW(lag1_signal), ncol = NCOL(lag1_signal))
  cost_Trading <- abs(lag1_signal*(ifelse(lag1_signal == lag2_signal,0,0.006)))
  cost_Trading[is.na(cost_Trading)] <- 0
}
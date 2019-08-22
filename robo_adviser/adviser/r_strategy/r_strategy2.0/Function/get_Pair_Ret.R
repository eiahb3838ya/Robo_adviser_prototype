## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

##### get_Pair_Ret =====
get_Pair_Ret <- function(Win_DT, Dist_Pair, kperiods = 1){
  
  if (is.data.frame(Win_DT)) {
    
    Win_DT$index <- as.Date(Win_DT$index)
    Win_XTS <- as.xts.data.table(Win_DT)
    
    if (is.xts(Win_XTS)) {
      
      stock_x <- Win_XTS[,Dist_Pair$stock1]
      stock_y <- Win_XTS[,Dist_Pair$stock2]
      
      Rt_X <- Delt(stock_x, k = kperiods)
      Rt_Y <- Delt(stock_y, k = kperiods)
      Spread_Rt <- Rt_Y - Rt_X
      colnames(Spread_Rt) <- "Ret"
      
      Spread_Rt_DT <- as.data.table(Spread_Rt)
      Spread_Rt_DT$index <- as.character(Spread_Rt_DT$index)
      
    }
    else {
      stop("Price series must be a xts!")
    }
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(Spread_Rt_DT)
}

## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### getPeriod_DT =====
getPeriod_DT <- function(DataFrame){
  
  if (is.data.frame(DataFrame)) {
    
    FirstDate <- DataFrame[,"index"][1]
    LastDate <- DataFrame[,"index"][NROW(DataFrame)]
    Period_DT <- data.table(FirstDate, LastDate)
    colnames(Period_DT) <- c("FirstDate", "LastDate")
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(Period_DT)
}


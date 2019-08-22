## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun2.R

##### getDT_FromSQL =====
getCol_DT <- function(DataFrame, SelectCol = "Close"){
  
  if (is.data.frame(DataFrame)) {
    
    Price_DT <- DataFrame[,c("index",SelectCol,"Stock_Code"), with = F]
    Price_DT$index <- as.Date(Price_DT$index)
    
    Price_xts_list <- lapply(unique(Price_DT$Stock_Code), function(idx){
      # idx <- unique(Price_DT$Stock_Code)[1]
      Select_DT <- Price_DT[which(Price_DT$Stock_Code %chin% idx), c("index", SelectCol), with = F]
      price_XTS <- as.xts.data.table(Select_DT)
      colnames(price_XTS) <- idx
      return(price_XTS)
    })
    
    Price_XTS <- do.call(merge, Price_xts_list)
    colnames(Price_XTS) <- paste(unique(Price_DT$Stock_Code))
    
    Price_DT <- as.data.table(Price_XTS)
    Price_DT$index <- as.character(Price_DT$index)
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(Price_DT)
}

## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

## SelectData
## StockCode = "2330"

##### get_Corr_Pair =====
get_Corr_Pair <- function(Select_DT, StockCode = "2330") {
  
  Select_DT$index <- as.Date(Select_DT$index)
  SelectXTS <- as.xts.data.table(Select_DT)
  
  if (is.xts(SelectXTS)) {

    Price_xts_corr <- as.data.table(cor(SelectXTS))
    
    Normalized_Select_corr <- Price_xts_corr[, StockCode, with = F]
    Normalized_Select_corr$Code <- colnames(SelectXTS)
    
    Normalized_Order_corr <- Normalized_Select_corr[order(-rank(Normalized_Select_corr[,1]))]
    stock1_corr <- StockCode
    stock2_corr <- Normalized_Order_corr[2,2]
    Corr_Pair <- cbind(stock1_corr, stock2_corr)
    colnames(Corr_Pair) <- c("stock1", "stock2")
    
    return(Corr_Pair)
  }
  else {
    stop("Price series must be a xts!")
  }
  
}

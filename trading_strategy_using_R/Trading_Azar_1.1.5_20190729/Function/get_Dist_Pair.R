## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

## SelectData
## StockCode = "2330"

##### get_Dist_Pair =====
get_Dist_Pair <- function(Select_DT, StockCode = "2330") {
  
  if (is.data.frame(Select_DT)) {
    
    Select_DT$index <- as.Date(Select_DT$index)
    SelectXTS <- as.xts.data.table(Select_DT)
    
    if (is.xts(SelectXTS)) {
      ncl <- NCOL(SelectXTS)
      Normalized_dist_list <- lapply(SelectXTS, function(idx){
        div <- idx/idx[[1]]
        return(div)
      })
      Normalized_dist <- do.call(cbind, Normalized_dist_list)
      colnames(Normalized_dist) <- colnames(SelectXTS)
      
      Normalized_Mx_dist <- matrix(NA, nrow = ncl, ncol = ncl)
      colnames(Normalized_Mx_dist) <- colnames(SelectXTS)
      
      for (i in seq_len(ncl)) {
        for (j in seq_len(ncl)) {
          if (i == j) {
            Normalized_Mx_dist[i,j] <- 0
          } else{
            diff_dist <- sqrt((as.numeric(Normalized_dist[,i] - Normalized_dist[,j]))^2)
            Normalized_Mx_dist[i,j] <- base::sum(diff_dist)
          }
        }
      }
      Normalized_Select_dist <- as.data.table(Normalized_Mx_dist[,StockCode])
      colnames(Normalized_Select_dist) <- StockCode
      Normalized_Select_dist$Code <- colnames(SelectXTS)
      
      Normalized_Order_dist <- Normalized_Select_dist[order(rank(Normalized_Select_dist[,1]))]
      stock1_dist <- StockCode
      stock2_dist <- Normalized_Order_dist[2,2]
      Dist_Pair <- cbind(stock1_dist, stock2_dist)
      colnames(Dist_Pair) <- c("stock1", "stock2")
      
    }
    else {
      stop("Price series must be a xts!")
    }
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(Dist_Pair)
}

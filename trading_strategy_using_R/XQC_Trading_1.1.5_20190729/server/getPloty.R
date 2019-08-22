## Azar Lin
## 20190727
## OOP
## XQC_Trading_Fun1.R

##### getPloty =====
getPloty <- function(DataFrame){
  
  if (is.data.frame(DataFrame)) {
    
    DataFrame$index <- as.Date(DataFrame$index)
    
  } else {
    stop("Data is not a DataFrame !")
  }
  
  return(DataFrame)
}

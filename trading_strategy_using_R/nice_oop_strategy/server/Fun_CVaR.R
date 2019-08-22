## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### Fun_CVaR =====
Fun_CVaR <- function(x, lmd = 0.5, alpha = 0.95){
  # x <- Select_Ret
  nr <- NROW(x)
  nc <- NCOL(x)
  x <- as.matrix(x)
  mu <- base::colMeans(x)
  w <- Variable(nc)
  z <- Variable(nr)
  zeta <- Variable(1)
  # problem
  prob <- Problem(Maximize( t(w) %*% mu - lmd*zeta - (lmd/(nr*(1 - alpha))) * sum(z) ),
                  constraints = list( z >= 0, z >= -x %*% w - zeta, w >= 0, sum(w) == 1)
  )
  result <- solve(prob)
  return(as.vector(result$getValue(w)))
}

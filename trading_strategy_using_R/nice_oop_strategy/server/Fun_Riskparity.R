## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### Fun_Riskparity =====
Fun_Riskparity <- function(Sigma, N){
  # initial point
  x0 <- rep(1/N, N)  
  fn_convex <- function(x, Sigma) {
    N <- nrow(Sigma)
    0.5 * t(x) %*% Sigma %*% x - (1/N)*sum(log(x))
  }
  # general solver
  result <- optim(par = x0, fn = fn_convex, Sigma = Sigma, method = "BFGS")
  x_convex <- result$par
  w_convex <- x_convex/sum(x_convex)
  return(w_convex)
}

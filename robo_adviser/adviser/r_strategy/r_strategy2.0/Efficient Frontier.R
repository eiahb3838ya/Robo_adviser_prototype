library(quadprog)

mean.R <- base::colMeans(Portfolio_All$Equity_All[,-c(1,2)])
cov.R <- stats::cov(Portfolio_All$Equity_All[,-c(1,2)])

Amat <- cbind(rep(1, NCOL(mean.R)), mean.R)
mu.P <- seq(min(mean.R), max(mean.R), length = 1000)
sigma.P <- mu.P

Wt_Markowitz <- Fun_Markowitz(mean.R, cov.R, 0.5)

Ret_Markowitz <- mean.R %*% Wt_Markowitz
SD_Markowitz <- sqrt(Wt_Markowitz %*% cov.R %*% Wt_Markowitz)

for (i in 1:length(mu.P)) {
  # i <- 1
  bvec = c(1, mu.P[i])  ## constraint vector
  result = solve.QP(Dmat = as.matrix(cov.R), 
                    dvec = rep(0, length(mean.R)), 
                    Amat = Amat, 
                    bvec = bvec, meq = 2)
  sigma.P[i] = sqrt(result$value)
}
options(scipen = 999)
ef <- data.table(sigma.P, mu.P)

plot_ly(ef, type = 'scatter', x = ~sigma.P, y = ~mu.P, mode = 'lines') %>% 
  layout(title = paste0("Strategy Return"),
         xaxis = list(title = 'Sigma',range = c(0 , max(sigma.P) * 1.1)),
         yaxis = list(title = 'Return',range = c(min(mean.R) * 0.5, max(mean.R) * 1.1)))



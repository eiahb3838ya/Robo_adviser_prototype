##### Server XQC_Trading_Fun2.R =====
## Azar Lin
## 20190706
## Server
## XQC_Trading_Fun2.R

##### ........... =====
##### Markowitz =====
XQC_Markowitz <- function(mu, Sigma, lmd = 0.5) {
  w <- Variable(nrow(Sigma))
  prob <- Problem(Maximize(t(mu) %*% w - lmd*quad_form(w, Sigma)),
                  constraints = list(w >= 0, sum(w) == 1))
  result <- solve(prob)
  return(as.vector(result$getValue(w)))
}
##### ........... =====
##### Markowitz_Portfolio =====
XQC_Markowitz_Portfolio <- function(RL_Data, periodn = "Month"){
  # RL_Data = Portfolio_All$PortfolioAll
  # lookback = 250
  print("XQC Markowitz Portfolio")
  ## XQC_Markowitz
  # periodn = "Day"
  # periodn = "Week"
  # periodn = "Month"
  # periodn = "Quarter"
  # periodn = "Year"
  Allday <- time(RL_Data)
  
  switch(periodn,
         Day = {
           nperiod <- Allday[endpoints(Allday, on = "days")]
           Startn <- nperiod[1:(length(nperiod) - 251)]
           Endn <- nperiod[251:(length(nperiod) - 1)] 
           Next_n <- nperiod[252:length(nperiod)]
           
           },
         Week = {
           nperiod <- Allday[endpoints(Allday, on = "weeks")]
           Startn <- nperiod[1:(length(nperiod) - 53)] 
           Endn <- nperiod[53:(length(nperiod) - 1)] 
           Next_n <- nperiod[54:length(nperiod)]
         },
         Month = {
           nperiod <- Allday[endpoints(Allday, on = "months")]
           Startn <- nperiod[1:(length(nperiod) - 13)]
           Endn <- nperiod[13:(length(nperiod) - 1)] 
           Next_n <- nperiod[14:length(nperiod)]
         },
         Quarter = {
           nperiod <- Allday[endpoints(Allday, on = "quarters")]
           Startn <- nperiod[1:(length(nperiod) - 5)] 
           Endn <- nperiod[5:(length(nperiod) - 1)] 
           Next_n <- nperiod[6:length(nperiod)]
         },
         Year = {
           nperiod <- Allday[endpoints(Allday, on = "years")]
           Startn <- as.Date(c(Allday[1],nperiod[1:(length(nperiod) - 2)]))
           Endn <- nperiod[1:(length(nperiod) - 1)] 
           Next_n <- nperiod[2:length(nperiod)]
         })
  
  ##### RL_Markowitz_List =====
  startTime <- Sys.time()
  RL_Markowitz_List <- lapply(seq_len(length(Startn)), function(idx){

    # idx <- 46
    print(paste0("Markowitz Rolling: ", idx))
    Select_Ret <- base::subset(RL_Data, time(RL_Data) > Startn[idx] & time(RL_Data) < Endn[idx])
    Next_Ret <- RL_Data[Next_n[idx]]
    Next_Date <- as.character(Next_n[idx])
    RL_Times <- paste0("Start: ", Startn[idx], ", End: ", Endn[idx], ", Next: ", Next_n[idx])

    RL_Corr <- t(cor(Select_Ret)[1,])
    Select_mu <- base::colMeans(Select_Ret)
    Select_Sigma <- stats::cov(Select_Ret)
    # design portfolio
    RL_Wt_Markowitz <- XQC_Markowitz(Select_mu, Select_Sigma, 2)
    RL_Ret_Markowitz <- Next_Ret %*% RL_Wt_Markowitz

    return(list(Date = Next_Date,
                Times = RL_Times,
                RL_Corr = RL_Corr,
                RL_Wt_Markowitz = RL_Wt_Markowitz,
                RL_Ret_Markowitz = RL_Ret_Markowitz
    ))
  })
  EndTime <- Sys.time()
  
  ##### RL_Markowitz_Date =====
  RL_Markowitz_Date <- lapply(RL_Markowitz_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_Markowitz_Date_All <- do.call(rbind, RL_Markowitz_Date)
  
  ##### RL_Markowitz_Corr =====
  RL_Markowitz_Corr <- lapply(RL_Markowitz_List, function(idx){
    data <- idx[["RL_Corr"]]
  })
  RL_Markowitz_Corr_All <- do.call(rbind, RL_Markowitz_Corr)
  print("RL_Markowitz_Corr")
  
  ##### RL_Markowitz_Wt =====
  RL_Markowitz_Wt <- lapply(RL_Markowitz_List, function(idx){
    data <- idx[["RL_Wt_Markowitz"]]
  })
  RL_Markowitz_Wt_All <- do.call(rbind, RL_Markowitz_Wt)
  print("RL_Markowitz_Wt")

  ##### RL_Markowitz_Ret =====
  RL_Markowitz_Ret <- lapply(RL_Markowitz_List, function(idx){
    data <- idx[["RL_Ret_Markowitz"]]
  })
  RL_Markowitz_Ret_All <- do.call(rbind,RL_Markowitz_Ret)
  print("RL_Markowitz_Ret")
  
  ##### Correlation =====
  Cor <- data.table(RL_Markowitz_Date_All, RL_Markowitz_Corr_All)
  colnames(Cor) <- c("Date", colnames(RL_Data))
  Cor$Date <- as.Date(Cor$Date)
  Cor_xts <- as.xts.data.table(Cor)
  print("Markowitz Correlation")
  
  ##### Weight =====
  Wt <- data.table(RL_Markowitz_Date_All, RL_Markowitz_Wt_All)
  colnames(Wt) <- c("Date", colnames(RL_Data))
  Wt$Date <- as.Date(Wt$Date)
  Wt_xts <- as.xts.data.table(Wt)
  print("Markowitz Weight")
  
  ##### Return =====
  Ret <- data.table(RL_Markowitz_Date_All, RL_Markowitz_Ret_All)
  colnames(Ret) <- c("Date", "Ret")
  Ret$Date <- as.Date(Ret$Date)
  Ret_xts <- as.xts.data.table(Ret)
  print("Markowitz Return")
  
  return(list(Cor = Cor,
              Cor_xts = Cor_xts,
              Wt = Wt, 
              Wt_xts = Wt_xts,
              Ret = Ret,
              Ret_xts = Ret_xts,
              RollingTime = paste0("Markowitz Rolling Time:", startTime," : ", EndTime)
              )
         )
  
}
##### ........... =====
##### Riskparity =====
XQC_Riskparity <- function(Sigma, N){
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
##### ........... =====
##### Riskparity_Portfolio =====
XQC_Riskparity_Portfolio <- function(RL_Data, periodn = "Month"){
  # PortfolioAll = PortfolioAll
  # lookback = 250
  # periodn = "Day"
  # periodn = "Week"
  # periodn = "Month"
  # periodn = "Quarter"
  # periodn = "Year"
  print("XQC Riskparity Portfolio")
  ## XQC_Riskparity
  
  Allday <- time(RL_Data)
  switch(periodn,
         Day = {
           nperiod <- Allday[endpoints(Allday, on = "days")]
           Startn <- nperiod[1:(length(nperiod) - 251)]
           Endn <- nperiod[251:(length(nperiod) - 1)] 
           Next_n <- nperiod[252:length(nperiod)]
           
         },
         Week = {
           nperiod <- Allday[endpoints(Allday, on = "weeks")]
           Startn <- nperiod[1:(length(nperiod) - 53)]
           Endn <- nperiod[53:(length(nperiod) - 1)] 
           Next_n <- nperiod[54:length(nperiod)]
         },
         Month = {
           nperiod <- Allday[endpoints(Allday, on = "months")]
           Startn <- nperiod[1:(length(nperiod) - 13)]
           Endn <- nperiod[13:(length(nperiod) - 1)] 
           Next_n <- nperiod[14:length(nperiod)]
         },
         Quarter = {
           nperiod <- Allday[endpoints(Allday, on = "quarters")]
           Startn <- nperiod[1:(length(nperiod) - 5)]
           Endn <- nperiod[5:(length(nperiod) - 1)]
           Next_n <- nperiod[6:length(nperiod)]
         },
         Year = {
           nperiod <- Allday[endpoints(Allday, on = "years")]
           Startn <- as.Date(c(Allday[1],nperiod[1:(length(nperiod) - 2)]))
           Endn <- nperiod[1:(length(nperiod) - 1)] 
           Next_n <- nperiod[2:length(nperiod)]
         })
  
  ##### RL_Riskparity_List =====
  startTime <- Sys.time()
  RL_Riskparity_List <- lapply(seq_len(length(Startn)), function(idx){
    # idx <- 1
    print(paste0("Riskparity Rolling: ", idx))
    
    Select_Ret <- base::subset(RL_Data, time(RL_Data) > Startn[idx] & time(RL_Data) < Endn[idx])
    Next_Ret <- RL_Data[Next_n[idx]]
    Next_Date <- as.character(Next_n[idx])
    RL_Times <- paste0("Start: ", Startn[idx], ", End: ", Endn[idx], ", Next: ", Next_n[idx])

    RL_Corr <- t(cor(Select_Ret)[1,])
    Select_Sigma <- stats::cov(Select_Ret)
    # design portfolio
    RL_Wt_Riskparity <- XQC_Riskparity(Select_Sigma, N = dim(Select_Ret)[2])
    RL_Ret_Riskparity <- Next_Ret %*% RL_Wt_Riskparity

    return(list(Date = Next_Date,
                Times = RL_Times,
                RL_Corr = RL_Corr,
                RL_Wt_Riskparity = RL_Wt_Riskparity,
                RL_Ret_Riskparity = RL_Ret_Riskparity
    ))
  })
  EndTime <- Sys.time()
  
  ##### RL_Riskparity_Date =====
  RL_Riskparity_Date <- lapply(RL_Riskparity_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_Riskparity_Date_All <- do.call(rbind, RL_Riskparity_Date)
  
  ##### RL_Riskparity_Corr =====
  RL_Riskparity_Corr <- lapply(RL_Riskparity_List, function(idx){
    data <- idx[["RL_Corr"]]
  })
  RL_Riskparity_Corr_All <- do.call(rbind, RL_Riskparity_Corr)
  print("RL_Riskparity_Corr")
  
  ##### RL_Riskparity_Wt =====
  RL_Riskparity_Wt <- lapply(RL_Riskparity_List, function(idx){
    data <- idx[["RL_Wt_Riskparity"]]
  })
  RL_Riskparity_Wt_All <- do.call(rbind, RL_Riskparity_Wt)
  print("RL_Riskparity_Wt")
  
  ##### RL_Riskparity_Ret =====
  RL_Riskparity_Ret <- lapply(RL_Riskparity_List, function(idx){
    data <- idx[["RL_Ret_Riskparity"]]
  })
  RL_Riskparity_Ret_All <- do.call(rbind,RL_Riskparity_Ret)
  print("RL_Riskparity_Ret")
  
  ##### Correlation =====
  Cor <- data.table(RL_Riskparity_Date_All, RL_Riskparity_Corr_All)
  colnames(Cor) <- c("Date", colnames(RL_Data))
  Cor$Date <- as.Date(Cor$Date)
  Cor_xts <- as.xts.data.table(Cor)
  print("Riskparity Correlation")
  
  ##### Weight =====
  Wt <- data.table(RL_Riskparity_Date_All, RL_Riskparity_Wt_All)
  colnames(Wt) <- c("Date", colnames(RL_Data))
  Wt$Date <- as.Date(Wt$Date)
  Wt_xts <- as.xts.data.table(Wt)
  print("Riskparity Weight")
  
  ##### Return =====
  Ret <- data.table(RL_Riskparity_Date_All, RL_Riskparity_Ret_All)
  colnames(Ret) <- c("Date", "Ret")
  Ret$Date <- as.Date(Ret$Date)
  Ret_xts <- as.xts.data.table(Ret)
  print("Riskparity Return")
  
  return(list(Cor = Cor,
              Cor_xts = Cor_xts,
              Wt = Wt, 
              Wt_xts = Wt_xts,
              Ret = Ret,
              Ret_xts = Ret_xts,
              RollingTime = print(paste0("Riskparity Rolling Time:",startTime," : ", EndTime))
              )
         )
}
##### ........... =====
##### CVaR =====
XQC_CVaR <- function(x, lmd = 0.5, alpha = 0.95){
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
##### ........... =====
##### XQC_CVaR_Portfolio =====
XQC_CVaR_Portfolio <- function(RL_Data, periodn = "Month"){
  # RL_Data = Portfolio_All$PortfolioAll
  # lookback = 250
  print("XQC CVaR Portfolio")
  ## XQC_CVaR
  # periodn = "Day"
  # periodn = "Week"
  # periodn = "Month"
  # periodn = "Quarter"
  # periodn = "Year"
  Allday <- time(RL_Data)
  # nperiod <- Allday[endpoints(Allday, on = periodn)]
  
  switch(periodn,
         Day = {
           nperiod <- Allday[endpoints(Allday, on = "days")]
           Startn <- nperiod[1:(length(nperiod) - 251)]
           Endn <- nperiod[251:(length(nperiod) - 1)] 
           Next_n <- nperiod[252:length(nperiod)]
           
         },
         Week = {
           nperiod <- Allday[endpoints(Allday, on = "weeks")]
           Startn <- nperiod[1:(length(nperiod) - 53)] 
           Endn <- nperiod[53:(length(nperiod) - 1)] 
           Next_n <- nperiod[54:length(nperiod)]
         },
         Month = {
           nperiod <- Allday[endpoints(Allday, on = "months")]
           Startn <- nperiod[1:(length(nperiod) - 13)]
           Endn <- nperiod[13:(length(nperiod) - 1)] 
           Next_n <- nperiod[14:length(nperiod)]
         },
         Quarter = {
           nperiod <- Allday[endpoints(Allday, on = "quarters")]
           Startn <- nperiod[1:(length(nperiod) - 5)] 
           Endn <- nperiod[5:(length(nperiod) - 1)] 
           Next_n <- nperiod[6:length(nperiod)]
         },
         Year = {
           nperiod <- Allday[endpoints(Allday, on = "years")]
           Startn <- as.Date(c(Allday[1],nperiod[1:(length(nperiod) - 2)]))
           Endn <- nperiod[1:(length(nperiod) - 1)] 
           Next_n <- nperiod[2:length(nperiod)]
         })
  # Select_Ret1 <- RL_Data[paste0(Startn[1],"::",Endn[1]),]
  
  ##### RL_CVaR_List =====
  startTime <- Sys.time()
  RL_CVaR_List <- lapply(seq_len(length(Startn)), function(idx){
    
    # idx <- 1
    print(paste0("CVaR Rolling: ", idx))
    Select_Ret <- base::subset(RL_Data, time(RL_Data) > Startn[idx] & time(RL_Data) < Endn[idx])
    Next_Ret <- RL_Data[Next_n[idx]]
    Next_Date <- as.character(Next_n[idx])
    RL_Times <- paste0("Start: ", Startn[idx], ", End: ", Endn[idx], ", Next: ", Next_n[idx])
    
    RL_Corr <- t(cor(Select_Ret)[1,])
    # Select_mu <- base::colMeans(Select_Ret)
    # Select_Sigma <- stats::cov(Select_Ret)
    # design portfolio
    RL_Wt_CVaR <- XQC_CVaR(Select_Ret, lmd = 0.5, alpha = 0.95)
    RL_Ret_CVaR <- Next_Ret %*% RL_Wt_CVaR
    
    return(list(Date = Next_Date,
                Times = RL_Times,
                RL_Corr = RL_Corr,
                RL_Wt_CVaR = RL_Wt_CVaR,
                RL_Ret_CVaR = RL_Ret_CVaR
    ))
  })
  EndTime <- Sys.time()

  ##### RL_CVaR_Date =====
  RL_CVaR_Date <- lapply(RL_CVaR_List, function(idx){
    data <- idx[["Date"]]
  })
  RL_CVaR_Date_All <- do.call(rbind, RL_CVaR_Date)
  
  ##### RL_CVaR_Corr =====
  RL_CVaR_Corr <- lapply(RL_CVaR_List, function(idx){
    data <- idx[["RL_Corr"]]
  })
  RL_CVaR_Corr_All <- do.call(rbind, RL_CVaR_Corr)
  print("RL_CVaR_Corr")
  
  ##### RL_Markowitz_Wt =====
  RL_CVaR_Wt <- lapply(RL_CVaR_List, function(idx){
    data <- idx[["RL_Wt_CVaR"]]
  })
  RL_CVaR_Wt_All <- do.call(rbind, RL_CVaR_Wt)
  print("RL_CVaR_Wt")
  
  ##### RL_Markowitz_Ret =====
  RL_CVaR_Ret <- lapply(RL_CVaR_List, function(idx){
    data <- idx[["RL_Ret_CVaR"]]
  })
  RL_CVaR_Ret_All <- do.call(rbind,RL_CVaR_Ret)
  print("RL_CVaR_Ret")
  
  ##### Correlation =====
  Cor <- data.table(RL_CVaR_Date_All, RL_CVaR_Corr_All)
  colnames(Cor) <- c("Date", colnames(RL_Data))
  Cor$Date <- as.Date(Cor$Date)
  Cor_xts <- as.xts.data.table(Cor)
  print("CVaR Correlation")
  
  ##### Weight =====
  Wt <- data.table(RL_CVaR_Date_All, RL_CVaR_Wt_All)
  colnames(Wt) <- c("Date", colnames(RL_Data))
  Wt$Date <- as.Date(Wt$Date)
  Wt_xts <- as.xts.data.table(Wt)
  print("CVaR Weight")
  
  ##### Return =====
  Ret <- data.table(RL_CVaR_Date_All, RL_CVaR_Ret_All)
  colnames(Ret) <- c("Date", "Ret")
  Ret$Date <- as.Date(Ret$Date)
  Ret_xts <- as.xts.data.table(Ret)
  print("CVaR Return")
  
  return(list(Cor = Cor,
              Cor_xts = Cor_xts,
              Wt = Wt, 
              Wt_xts = Wt_xts,
              Ret = Ret,
              Ret_xts = Ret_xts,
              RollingTime = paste0("CVaR Rolling Time:", startTime," : ", EndTime)
  )
  )
}



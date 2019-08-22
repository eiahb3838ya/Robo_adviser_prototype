##### XQC_Trading_Fun1.R =====
## Azar Lin
## 20190706
## XQC_Trading_Fun1.R

##### getXtsData =====
# getXtsData <- function(DataTb , StockCode = "2330", SelectCol = "Close") {
#   # DataTb <- DataTable
#   # StockCode = "2330"
#   # SelectCol = "Close"
#   # posStart <- min(which(as.Date(Pricedata$Date,format = "%Y-%m-%d") >= as.Date(StartDate,format = "%Y-%m-%d")))
#   # posEnd <- max(which(as.Date(Pricedata$Date,format = "%Y-%m-%d") <= as.Date(EndDate,format = "%Y-%m-%d")))
#   
#   ## Price_xts
#   Price_tb <- DataTb[,c("Date",SelectCol,"Stock_Code"), with = F]
#   Price_xts_list <- lapply(unique(Price_tb$Stock_Code), function(idx){
#     # idx <- unique(Price_tb$Stock_Code)[1]
#     price_dt <- Price_tb[which(Price_tb$Stock_Code %chin% idx), c("Date","Close")]
#     price_dt <- na.omit(price_dt)
#     price_xts <- as.xts.data.table(price_dt)
#     colnames(price_xts) <- idx
#     price_xts
#   })
#   Price_xts <- do.call(cbind,Price_xts_list)
#   colnames(Price_xts) <- paste(unique(DataTb$Stock_Code))
#   Price_xts <- na.omit(Price_xts)
#   
#   ## Select_Code
#   Select_xts <- Price_xts[ , StockCode, with = F ]
#   
#   Date_Period <- time(Price_xts)
#   posStart <- Date_Period[1]
#   posEnd <- Date_Period[length(Date_Period)]
#   
#   if (posStart >= posEnd) {
#     stop("Date is wrong !")
#   }
#   
#   if (posStart < posEnd) {
#     PriceWin_xts <- window(Price_xts, start = posStart, end = posEnd)
#     SelectWin_xts <- window(Select_xts, start = posStart, end = posEnd)
#   }
#   # getXtsData <- list(Select_xts = SelectWin_xts, Price_xts = PriceWin_xts)
#   return(list(Select_xts = SelectWin_xts, Price_xts = PriceWin_xts))
# }

##### XQ_MACD_Ret =====
XQ_MACD_Ret <- function(SPD, MACD_Fast = 12, MACD_Slow = 26, MACD_Sig = 9, MACD_maType = "SMA", MACD_percent = FALSE){
  
  if (is.xts(SPD)) {
    # SPD <- SelectXTS
    macd <- MACD(SPD, nFast = MACD_Fast, nSlow = MACD_Slow, nSig = MACD_Sig, maType = MACD_maType, percent = MACD_percent)
    
    signal_macd <- rep(NA, NROW(macd))
    signal_macd <- ifelse((macd$signal > macd$macd), 1, ifelse((macd$signal < macd$macd), -1, 0))
    # signal_macd[is.na(signal_macd)] <- 0
    
    lag1_signal_macd <- stats::lag(signal_macd, k = 1, na.pad = TRUE)
    lag2_signal_macd <- stats::lag(signal_macd, k = 2, na.pad = TRUE)
    # lag3_signal_macd <- stats::lag(signal_macd, k = 3, na.pad = TRUE)
    
    Rt_MACD <- Delt(SPD)
    
    cost_macd <- matrix(NA, nrow = NROW(lag1_signal_macd), ncol = NCOL(lag1_signal_macd))
    cost_macd <- abs(lag1_signal_macd*(ifelse(lag1_signal_macd == lag2_signal_macd,0,0.006)))
    cost_macd[is.na(cost_macd)] <- 0
    
    return(list(Trading_Ret_MACD = Rt_MACD*lag1_signal_macd, 
                Trading_Ret_MACD_Cost = Rt_MACD*lag1_signal_macd - cost_macd,
                Sig_MACD = lag1_signal_macd,
                Ret_MACD = Rt_MACD))
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### XQ_RSI_Ret =====
XQ_RSI_Ret <- function(SPD, RSI_ma = 5, RSI_maType = "SMA", RSI_Up = 70, RSI_Down = 30){
  # SPD <- SelectXTS
  if (is.xts(SPD)) {
    RSI <- RSI(SPD, n = RSI_ma, maType = RSI_maType)
    signal_rsi <- rep(NA, NROW(RSI))
    signal_rsi <- ifelse((RSI$rsi > RSI_Up), -1, ifelse((RSI$rsi < RSI_Down), 1, 0))
    
    lag1_signal_rsi <- stats::lag(signal_rsi, k = 1, na.pad = TRUE)
    lag2_signal_rsi <- stats::lag(signal_rsi, k = 2, na.pad = TRUE)
    # lag3_signal_rsi <- stats::lag(signal_rsi, k = 3, na.pad = TRUE)
    
    Rt_RSI <- Delt(SPD)
    
    cost_rsi <- matrix(NA, nrow = NROW(lag1_signal_rsi), ncol = NCOL(lag1_signal_rsi))
    cost_rsi <- abs(lag1_signal_rsi*(ifelse(lag1_signal_rsi == lag2_signal_rsi,0,0.006)))
    cost_rsi[is.na(cost_rsi)] <- 0
    
    return(list(Trading_Ret_RSI = Rt_RSI*lag1_signal_rsi,
                Trading_Ret_RSI_Cost = Rt_RSI*lag1_signal_rsi - cost_rsi,
                Sig_RSI = lag1_signal_rsi,
                Ret_RSI = Rt_RSI))
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### XQ_MA_Ret =====
XQ_MA_Ret <- function(SPD, MA_fast = 10, MA_slow = 20){
  if (is.xts(SPD)) {
    # SPD = SelectXTS
    # nfast = 1
    # nslow = 5
    mafast <- SMA(SPD, MA_fast)
    maslow <- SMA(SPD, MA_slow)
    signal_ma <- rep(NA, NROW(mafast))
    signal_ma <- ifelse((mafast > maslow), 1, ifelse((mafast < maslow), -1, 0))
    # signal_ma[is.na(signal_ma)] <- 0
    
    lag1_signal_ma <- stats::lag(signal_ma, k = 1, na.pad = TRUE)
    lag2_signal_ma <- stats::lag(signal_ma, k = 2, na.pad = TRUE)
    # lag3_signal_ma <- stats::lag(signal_ma, k = 3, na.pad = TRUE)
    
    Rt_MA <- Delt(SPD)
    
    cost_ma <- matrix(NA, nrow = NROW(lag1_signal_ma), ncol = NCOL(lag1_signal_ma))
    cost_ma <- abs(lag1_signal_ma*(ifelse(lag1_signal_ma == lag2_signal_ma,0,0.006)))
    cost_ma[is.na(cost_ma)] <- 0
    
    return(list(Trading_Ret_MA = Rt_MA*lag1_signal_ma, 
                Trading_Ret_MA_Cost = Rt_MA*lag1_signal_ma - cost_ma,
                Sig_MA = lag1_signal_ma,
                Ret_MA = Rt_MA))
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### XQ_BB_Ret =====
XQ_BB_Ret <- function(SPD, BB_size = 20, BB_k = 1){
  # SPD = SelectXTS
  # size_BB <- 20
  # k_BB <- 1
  if (is.xts(SPD)) {
    # SPD = XtsData$RetXTS
    roll_mu_BB <- runMean(SPD, BB_size)
    roll_std_BB <- runSD(SPD, BB_size)
    roll_ub_BB <- roll_mu_BB + BB_k * roll_std_BB
    roll_lb_BB <- roll_mu_BB - BB_k * roll_std_BB
    
    signal_BB <- matrix(NA, nrow = NROW(SPD), ncol = NCOL(SPD))
    signal_BB <- ifelse(SPD > roll_ub_BB,-1, ifelse(SPD < roll_lb_BB,1, 0))
    
    lag1_signal_BB <- stats::lag(signal_BB, k = 1, na.pad = FALSE)
    lag2_signal_BB <- stats::lag(signal_BB, k = 2, na.pad = TRUE)
    # lag3_signal_BB <- stats::lag(signal_BB, k = 3, na.pad = TRUE)
    
    Rt_BB <- Delt(SPD)
    
    cost_BB <- matrix(NA, nrow = NROW(lag1_signal_BB), ncol = NCOL(lag1_signal_BB))
    cost_BB <- abs(lag1_signal_BB*(ifelse(lag1_signal_BB == lag2_signal_BB,0,0.006)))
    cost_BB[is.na(cost_BB)] <- 0
    return(list(Trading_Ret_BB = Rt_BB*lag1_signal_BB, 
                Trading_Ret_BB_Cost = Rt_BB*lag1_signal_BB - cost_BB,
                Sig_BB = lag1_signal_BB,
                Ret_BB = Rt_BB
    ))
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### XQ_Dist_Ret =====
XQ_Dist_Ret <- function(SPD, Dist_size = 20, Dist_k = 1, StockCode = "2330"){
  # SPD <- PriceXTS
  # Dist_size <- 20
  # Dist_k <- 1
  # StockCode <- "2330"
  # SelectCol <-  "Close"
  
  # lag period 2
  if (is.xts(SPD)) {
    ncl <- NCOL(SPD)
    # nrl <- NROW(SPD)
    
    Normalized_dist_list <- lapply(SPD, function(idx){
      div <- idx/idx[[1]]
      return(div)
    })
    Normalized_dist <- do.call(cbind,Normalized_dist_list)
    colnames(Normalized_dist) <- colnames(SPD)
    
    Normalized_Mx_dist <- matrix(NA, nrow = ncl, ncol = ncl)
    colnames(Normalized_Mx_dist) <- colnames(SPD)
    for (i in seq_len(ncl)) {
      for (j in seq_len(ncl)) {
        if (i == j) {
          Normalized_Mx_dist[i,j] <- 0
        } else{
          # i = 1
          diff_dist <- sqrt((as.numeric(Normalized_dist[,i] - Normalized_dist[,j]))^2)
          Normalized_Mx_dist[i,j] <- base::sum(diff_dist)
        }
      }
    }
    
    Normalized_Select_dist <- as.data.table(Normalized_Mx_dist[,StockCode])
    colnames(Normalized_Select_dist) <- StockCode
    Normalized_Select_dist$Code <- colnames(SPD)
    
    Normalized_Order_dist <- Normalized_Select_dist[order(rank(Normalized_Select_dist[,1]))]
    stock1_dist <- StockCode
    stock2_dist <- Normalized_Order_dist[2,2]
    
    stock_x_dist <- SPD[,stock1_dist]
    stock_y_dist <- SPD[,stock2_dist$Code]
    
    hedge_ratio_dist <- stock_y_dist/stock_x_dist
    
    roll_mu_dist <- runMean(hedge_ratio_dist, Dist_size)
    roll_std_dist <- runSD(hedge_ratio_dist, Dist_size)
    
    roll_ub_dist <- roll_mu_dist + Dist_k * roll_std_dist
    roll_lb_dist <- roll_mu_dist - Dist_k * roll_std_dist
    
    signal_dist <- matrix(NA, nrow = NROW(hedge_ratio_dist), ncol = NCOL(hedge_ratio_dist))
    signal_dist <- ifelse(hedge_ratio_dist > roll_ub_dist,-1, ifelse(hedge_ratio_dist < roll_lb_dist,1, 0))
    
    lag1_signal_dist <- stats::lag(signal_dist, k = 1, na.pad = TRUE)
    lag2_signal_dist <- stats::lag(signal_dist, k = 2, na.pad = TRUE)
    # lag3_signal_dist <- stats::lag(signal_dist, k = 3, na.pad = TRUE)
    
    RtX_dist <- Delt(stock_x_dist)
    RtY_dist <- Delt(stock_y_dist)
    
    Spread_Rt_Dist <- RtY_dist - RtX_dist
    
    ## Log1 and 2
    cost_dist <- matrix(NA, nrow = NROW(lag1_signal_dist), ncol = NCOL(lag1_signal_dist))
    cost_dist <- abs(lag1_signal_dist*(ifelse(lag1_signal_dist == lag2_signal_dist,0,0.006)))
    cost_dist[is.na(cost_dist)] <- 0
    
    return(list(Trading_Ret_Dist = Spread_Rt_Dist*lag1_signal_dist, 
                Trading_Ret_Dist_Cost = Spread_Rt_Dist*lag1_signal_dist - cost_dist,
                Sig_Dist = lag1_signal_dist,
                Spreads_Rt_Dist = Spread_Rt_Dist,
                Stock_X = stock_x_dist,
                Stock_Y = stock_y_dist,
                Stock_X_name = StockCode,
                Stock_Y_name = stock2_dist$Code
    ))
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### XQ_Corr_Ret =====
XQ_Corr_Ret <- function(SPD, Corr_size = 20, Corr_k = 1, StockCode = "2330"){
  
  # SPD <- PriceXTS
  # Corr_size <- 20
  # Corr_k <- 1
  # StockCode <- "2330"
  # SelectCol <-  "Close"
  
  if (is.xts(SPD)) {
    ncl <- NCOL(SPD)
    # nrl <- NROW(SPD)
    Price_xts_corr <- as.data.table(cor(SPD))
    
    Normalized_Select_corr <- Price_xts_corr[, StockCode, with = F]
    Normalized_Select_corr$Code <- colnames(SPD)
    
    Normalized_Order_corr <- Normalized_Select_corr[order(-rank(Normalized_Select_corr[,1]))]
    stock1_corr <- StockCode
    stock2_corr <- Normalized_Order_corr[2,2]
    
    stock_x_corr <- SPD[,stock1_corr]
    stock_y_corr <- SPD[,stock2_corr$Code]
    
    hedge_ratio_corr <- stock_y_corr/stock_x_corr
    
    roll_mu_corr <- runMean(hedge_ratio_corr, Corr_size)
    roll_std_corr <- runSD(hedge_ratio_corr, Corr_size)
    
    roll_ub_corr <- roll_mu_corr + Corr_k * roll_std_corr
    roll_lb_corr <- roll_mu_corr - Corr_k * roll_std_corr
    
    signal_corr <- matrix(NA, nrow = NROW(hedge_ratio_corr), ncol = NCOL(hedge_ratio_corr))
    signal_corr <- ifelse(hedge_ratio_corr > roll_ub_corr, -1, ifelse(hedge_ratio_corr < roll_lb_corr,1,0))
    
    lag1_signal_corr <- stats::lag(signal_corr, k = 1, na.pad = TRUE)
    lag2_signal_corr <- stats::lag(signal_corr, k = 2, na.pad = TRUE)
    # lag3_signal_corr <- stats::lag(signal_corr, k = 3, na.pad = TRUE)
    
    RtX_corr <- Delt(stock_x_corr)
    RtY_corr <- Delt(stock_y_corr)
    Spread_Rt_Corr <- RtY_corr - RtX_corr
    
    cost_corr <- matrix(NA, nrow = NROW(lag1_signal_corr), ncol = NCOL(lag1_signal_corr))
    cost_corr <- abs(lag1_signal_corr*(ifelse(lag1_signal_corr == lag2_signal_corr,0,0.006)))
    cost_corr[is.na(cost_corr)] <- 0
    
    return(list(Trading_Ret_Corr = Spread_Rt_Corr*lag1_signal_corr,
                Trading_Ret_Corr_Cost = Spread_Rt_Corr*lag1_signal_corr - cost_corr,
                Sig_Corr = lag1_signal_corr,
                Spreads_Rt_Corr = Spread_Rt_Corr,
                Stock_X = stock_x_corr,
                Stock_Y = stock_y_corr,
                Stock_X_name = StockCode,
                Stock_Y_name = stock2_corr$Code))
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### XQ_Coin_Ret =====
XQ_Coin_Ret <- function(SPD, Coin_alpha = 0.01, Coin_size = 20, Coin_k = 1, StockCode = "2330"){
  
  # SPD <- PriceXTS
  # Coin_size <- 20
  # Coin_k <- 1
  # Coin_alpha <-  0.01
  # StockCode <- "2330"
  # SelectCol <-  "Close"
  
  if (is.xts(SPD)) {
    ncl <- NCOL(SPD)
    
    regression_Coin <- 'c' 
    maxlag_Coin = floor(12*(100/nrow(SPD))^(1/4))
    
    #使用 unitrootTest 檢定資料是否為 nonstationary
    nonStationary_Coin <- Find_Integration_unitrootTest(SPD, maxlag_Coin, regression_Coin, Coin_alpha)
    # length(nonStationary_Coin)
    SPD_MTX <- as.matrix(SPD)
    i <- 0
    while (length(nonStationary_Coin) > 0) {
      #將資料做一次差分，檢定資料是否為 stationary
      SPD_MTX = diff(SPD_MTX)
      SPD_MTX_diff = na.omit(as.data.frame(SPD_MTX))
      nonStationary_Coin = Find_Integration_unitrootTest(SPD_MTX_diff, maxlag_Coin, regression_Coin, Coin_alpha)
      print(paste("Diff: ",i + 1, " times."))
      i <-  i + 1
    }
    
    #確認後並沒有原始資料為 nonstationary
    cointegrated_pairs = Find_Cointegrated_Pairs_unitrootTest(SPD, maxlag_Coin, regression_Coin, Coin_alpha)
    print("Data is stationary")
    #採用 unitrootTest 方法所計算出的數值
    # pairs_Coin = cointegrated_pairs$pairs
    pvalues_Coin <- cointegrated_pairs$pvalues
    # betas_Coin = cointegrated_pairs$betas
    colnames(pvalues_Coin) <- colnames(SPD)
    # rownames(pvalues_Coin) = colnames(SPD)
    
    Normalized_Select_Coin <- as.data.table(pvalues_Coin[,StockCode])
    colnames(Normalized_Select_Coin) <- StockCode
    Normalized_Select_Coin$Code <- colnames(SPD)
    
    Normalized_Order_Coin <- Normalized_Select_Coin[order(rank(Normalized_Select_Coin[,1]))]
    stock1_Coin <- StockCode
    stock2_Coin <- Normalized_Order_Coin[1,2]
    
    stock_x_Coin <- SPD[,stock1_Coin]
    stock_y_Coin <- SPD[,stock2_Coin$Code]
    
    hedge_ratio_Coin <- stock_y_Coin/stock_x_Coin
    
    roll_mu_Coin <- runMean(hedge_ratio_Coin, Coin_size)
    roll_std_Coin <- runSD(hedge_ratio_Coin, Coin_size)
    
    roll_ub_Coin <- roll_mu_Coin + Coin_k * roll_std_Coin
    roll_lb_Coin <- roll_mu_Coin - Coin_k * roll_std_Coin
    
    signal_Coin <- matrix(NA, nrow = NROW(hedge_ratio_Coin), ncol = NCOL(hedge_ratio_Coin))
    signal_Coin <- ifelse(hedge_ratio_Coin > roll_ub_Coin,-1,ifelse(hedge_ratio_Coin < roll_lb_Coin,1,0))
    
    lag1_signal_Coin <- stats::lag(signal_Coin, k = 1, na.pad = TRUE)
    lag2_signal_Coin <- stats::lag(signal_Coin, k = 2, na.pad = TRUE)
    # lag3_signal_Coin <- stats::lag(signal_Coin, k = 3, na.pad = TRUE)
    
    RtX_Coin <- Delt(stock_x_Coin)
    RtY_Coin <- Delt(stock_y_Coin)
    Spread_Rt_Coin <- RtY_Coin - RtX_Coin
    
    cost_Coin <- matrix(NA, nrow = NROW(lag1_signal_Coin), ncol = NCOL(lag1_signal_Coin))
    cost_Coin <- abs(lag1_signal_Coin*(ifelse(lag1_signal_Coin == lag2_signal_Coin,0,0.006)))
    cost_Coin[is.na(cost_Coin)] <- 0
    
    return(list(Trading_Ret_Coin = Spread_Rt_Coin*lag1_signal_Coin, 
                Trading_Ret_Coin_Cost = Spread_Rt_Coin*lag1_signal_Coin - cost_Coin,
                Sig_Coin = lag1_signal_Coin,
                Spreads_Rt_Coin = Spread_Rt_Coin,
                Stock_X = stock_x_Coin,
                Stock_Y = stock_y_Coin,
                Stock_X_name = stock1_Coin,
                Stock_Y_name = stock2_Coin$Code))
  }
  else {
    stop("Price series must be a xts!")
  }
}

##### Find Integration UnitrootTest =====
Find_Integration_unitrootTest = function(dataframe, maxlag, regression, alpha) {
  
  # dataframe <- Price_xts
  # maxlag <- maxlag_Coi
  # regression <- regression_Coi
  # alpha <- alpha_Coi
  
  #dataframe = prices_df
  n = ncol(dataframe) 
  keys = colnames(dataframe) 
  
  nonstationary = c()
  for (i in seq(2,n)) {
    lag = maxlag    # starting from the largest lag number to check 
    stock = as.matrix(dataframe[,keys[i]]) 
    repeat {
      adf = unitrootTest(stock, lags = lag, type = regression, title = NULL, description = NULL) 
      if (adf@test$p.value[[1]] <= alpha) { # using p-value for checking stationary 
        break
      } else {
        lag = lag - 1
      }
      if (lag == -1) { # stop repeat when lag=-1 
        break
      }   
    }
    pvalue = adf@test$p.value[[1]]      
    Num_lags = adf@test$parameter[[1]] 
    
    if (pvalue > alpha) {
      nonstationary = append(nonstationary, list(c(keys[i], pvalue, Num_lags))) 
    }      
  }
  return(nonstationary)
}

##### Find Cointegrated Pairs UnitrootTest function =====
Find_Cointegrated_Pairs_unitrootTest = function(dataframe, maxlag, regression, alpha) {
  
  # dataframe <- Price_xts
  # maxlag <- maxlag_Coi
  # regression <- regression_Coi
  # alpha <- alpha_Coi
  
  n = ncol(dataframe)
  keys = colnames(dataframe)
  
  # 檢查 y_t - beta*x_t 是否為stationary
  pairs = c()
  pvalues <- matrix(NA,nrow = n, ncol = n)
  betas <- matrix(NA,nrow = n, ncol = n)
  for (i in seq_len(n)) {
    for (j in seq_len(n)) {
      if (i != j) {
        y = as.matrix(dataframe[,keys[i]])
        x = as.matrix(dataframe[,keys[j]])
        
        result = lm(y ~ x)    # regression
        beta = result$coefficients[[2]]    # [[2]]the parameter of slope（含截距項的迴歸）
        resid = y - beta*x
        
        lag = maxlag
        repeat {
          adf = unitrootTest(resid, lags = lag, type = regression, title = NULL, description = NULL)
          if (adf@test$p.value[[1]] <= alpha) { # using p-value to check the stationary
            break
          } else {
            lag = lag - 1
          }
          if (lag == -1) {
            break
          }
        }
        pvalue = adf@test$p.value[[1]]
        pvalues[i,j] = pvalue
        betas[i,j] = beta
        if (pvalue <= alpha) { # be a pair when its stationary
          pairs = append(pairs, list(c(keys[i], keys[j], pvalue, beta)))
        }    
      } 
    } 
  }
  outcome = list(pairs = pairs, pvalues = pvalues, betas = betas)
  return(outcome)
}

##### Z-score function =====
zscore <- function(s){
  z <- (s - mean(s))/sd(s)
  return(z)  
}


##### XQC_Trading_Fun1.R Fun =====
## Azar Lin
## 20190706
## XQC_Trading_Fun1.R

##### getXtsData =====
getXtsData <- function(DataTb , StockCode = "2330", SelectCol = "Close") {
  # DataTb <- DataTable
  # StockCode = "2330"
  # SelectCol = "Close"
  # posStart <- min(which(as.Date(Pricedata$Date,format = "%Y-%m-%d") >= as.Date(StartDate,format = "%Y-%m-%d")))
  # posEnd <- max(which(as.Date(Pricedata$Date,format = "%Y-%m-%d") <= as.Date(EndDate,format = "%Y-%m-%d")))
  
  ## Price_xts
  Price_tb <- DataTb[,c("Date",SelectCol,"Stock_Code"), with = F]
  Price_xts_list <- lapply(unique(Price_tb$Stock_Code), function(idx){
    # idx <- unique(Price_tb$Stock_Code)[1]
    price_dt <- Price_tb[which(Price_tb$Stock_Code %chin% idx), c("Date","Close")]
    price_dt <- na.omit(price_dt)
    price_xts <- as.xts.data.table(price_dt)
    colnames(price_xts) <- idx
    price_xts
  })
  Price_xts <- do.call(cbind,Price_xts_list)
  colnames(Price_xts) <- paste(unique(DataTb$Stock_Code))
  Price_xts <- na.omit(Price_xts)
  
  ## Select_Code
  Select_xts <- Price_xts[ , StockCode, with = F ]
  
  Date_Period <- time(Price_xts)
  posStart <- Date_Period[1]
  posEnd <- Date_Period[length(Date_Period)]
  
  if (posStart >= posEnd) {
    stop("Date is wrong !")
  }
  
  if (posStart < posEnd) {
    PriceWin_xts <- window(Price_xts, start = posStart, end = posEnd)
    SelectWin_xts <- window(Select_xts, start = posStart, end = posEnd)
  }
  # getXtsData <- list(Select_xts = SelectWin_xts, Price_xts = PriceWin_xts)
  return(list(Select_xts = SelectWin_xts, Price_xts = PriceWin_xts))
}

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



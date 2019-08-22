##### getXtsData =====
## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getXtsData =====
getXtsData <- function(DataTable , StockCode = "2330", SelectCol = "Close", StartDate = "2007-01-02", EndDate = "2019-06-28") {
  # DataTable <- datatp$DataTable
  # StockCode = "2330"
  # SelectCol = "Close"
  # StartDate = "2007-01-02"
  # EndDate = "2019-06-28"
  ## Price_xts
  Price_tb <- DataTable[,c("Date",SelectCol,"Stock_Code"), with = F]
  posStart <- Price_tb[min(which(Price_tb$Date >= as.Date(StartDate,format = "%Y-%m-%d"))),"Date"]
  posEnd <- Price_tb[max(which(Price_tb$Date <= as.Date(EndDate,format = "%Y-%m-%d"))), "Date"]
  if (posStart < posEnd) {
    Price_xts_list <- lapply(unique(Price_tb$Stock_Code), function(idx){
      # idx <- unique(Price_tb$Stock_Code)[1]
      price_dt <- Price_tb[which(Price_tb$Stock_Code %chin% idx), c("Date","Close")]
      price_dt <- na.omit(price_dt)
      price_xts <- as.xts.data.table(price_dt)
      colnames(price_xts) <- idx
      return(price_xts)
    })
    Price_xts <- do.call(cbind,Price_xts_list)
    colnames(Price_xts) <- paste(unique(DataTable$Stock_Code))
    Price_xts <- na.omit(Price_xts)

    PriceWin_xts <- window(Price_xts, start = posStart$Date, end = posEnd$Date)
    PriceWin_tb <- as.data.table(PriceWin_xts)
  } else {
    stop("Date is wrong !")
  }
  # getXtsData <- PriceWin_xts
  return(PriceWin_tb)
}
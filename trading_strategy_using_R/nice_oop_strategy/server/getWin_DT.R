##### getXtsData =====
## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun1.R

##### getWin_DT =====
getWin_DT <- function(DataTable , StockCode = "2330", SelectCol = "Close", StartDate = "2007-01-02", EndDate = "2019-06-28") {
  # DataTable <- datatp$DataTable
  # StockCode = "2330"
  # SelectCol = "Close"
  # StartDate = "2007-01-02"
  # EndDate = "2019-06-28"
  ## Price_xts
  Price_DT <- DataTable[,c("Date",SelectCol,"Stock_Code"), with = F]
  posStart <- Price_DT[min(which(Price_DT$Date >= as.Date(StartDate,format = "%Y-%m-%d"))),"Date"]
  posEnd <- Price_DT[max(which(Price_DT$Date <= as.Date(EndDate,format = "%Y-%m-%d"))), "Date"]
  if (posStart < posEnd) {
    Price_xts_list <- lapply(unique(Price_DT$Stock_Code), function(idx){
      # idx <- unique(Price_tb$Stock_Code)[1]
      Select_DT <- Price_DT[which(Price_DT$Stock_Code %chin% idx), c("Date","Close")]
      Select_DT <- na.omit(Select_DT)
      price_XTS <- as.xts.data.table(Select_DT)
      colnames(price_XTS) <- idx
      return(price_XTS)
    })
    Price_XTS <- do.call(cbind,Price_xts_list)
    colnames(Price_XTS) <- paste(unique(DataTable$Stock_Code))
    Price_XTS <- na.omit(Price_XTS)
    
    PriceWin_XTS <- window(Price_XTS, start = posStart$Date, end = posEnd$Date)
    PriceWin_DT <- as.data.table(PriceWin_XTS)
    PriceWin_DT$index <- as.character(PriceWin_DT$index)
    
  } else {
    stop("Date is wrong !")
  }
  # getXtsData <- PriceWin_xts
  return(PriceWin_DT)
}

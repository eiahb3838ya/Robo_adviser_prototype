## XiQi Trading Code 
## D:\Azar\2019Main\XQC_Trading\XQC_Trading_1.0.3_20190703
## Azar Lin
## 20190625,20190701,20190706
#list.of.packages <- c("PerformanceAnalytics", "quantmod","timeSeries","fUnitRoots","fPortfolio",
#                      "CVXR","tidyverse","tidyquant","plotly","data.table","RODBC")
#new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
#if(length(new.packages)) install.packages(new.packages)

library(PerformanceAnalytics)
library(quantmod)
library(timeSeries)
library(fUnitRoots)
library(fPortfolio)
library(CVXR)
library(tidyverse)
library(tidyquant)
library(plotly)
library(data.table)
library(RODBC)

setwd("C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/test_r_strategy/")
##### Source =====
source("XQC_Trading_Fun1.R", local = TRUE)

##### SQL Server =====
DataTable <- readRDS("SQLDB_TW_20190705.RDS")

##### getXtsData =====
#StockCode = "2330"
SelectCol = "Close"
Data_Xts <- getXtsData(DataTable, StockCode)

##### Info =====
SelectXTS <- Data_Xts$Select_xts

Ret_xts <- Delt(SelectXTS)
colnames(Ret_xts) <- "Ret"
Ret_xts <- na.omit(Ret_xts)
CumRet_xts <- cumprod(Ret_xts$Ret + 1)
CumRet_tb <- as_tibble(as.data.table(CumRet_xts))
colnames(CumRet_tb) <- c("Date", "CumRet")

# END
# plot_ly(CumRet_tb, x = ~Date, y = ~CumRet, type = 'scatter', mode = 'lines') %>% 
#   layout(title = paste0(StockCode," Cumulative Return"))

##### PortfolioAlls =====
SelectXTS <- Data_Xts$Select_xts
StockCode <- colnames(SelectXTS)
PriceXTS <- Data_Xts$Price_xts

##### MACD Strategy =====
MACD_list <- lapply(SelectXTS, function(idx){
  MACD_ret <- XQ_MACD_Ret(idx)
})

Ret_MACD_list <- lapply(MACD_list, function(idx){
  data <- idx[["Trading_Ret_MACD"]]
})
Trading_Ret_MACD <- do.call(cbind,Ret_MACD_list)
colnames(Trading_Ret_MACD) <- paste0(StockCode,"_MACD_Ret")

##### RSI Strategy =====
# RSI_ma = 20, maType = "SMA", > RSI_Up = 70 Short, < RSI_Down = 30 Long
RSI_list <- lapply(SelectXTS, function(idx){
  RSI_ret <- XQ_RSI_Ret(idx)
})

Ret_RSI_list <- lapply(RSI_list, function(idx){
  data <- idx[["Trading_Ret_RSI"]]
})
Trading_Ret_RSI <- do.call(cbind,Ret_RSI_list)
colnames(Trading_Ret_RSI) <- paste0(StockCode,"_RSI_Ret")

##### ALL =====
Trading_Ret_cb <- merge(Trading_Ret_MACD, Trading_Ret_RSI)

colnames(Trading_Ret_cb) <- c("MACD", "RSI")

Trading_Ret_All <- Trading_Ret_cb[complete.cases(Trading_Ret_cb)]
Portfolio_Alls <- list(PortfolioAll = Trading_Ret_All,
                       MACD = Trading_Ret_All[,"MACD"],
                       RSI = Trading_Ret_All[,"RSI"])

##### Portfolio_CumRet_tb =====
Portfolio_CumRet_xts <- cumprod(Portfolio_Alls$PortfolioAll + 1)
Portfolio_CumRet_tb <- as_tibble(as.data.table(Portfolio_CumRet_xts))
colnames(Portfolio_CumRet_tb) <- c("Date", colnames(Portfolio_Alls$PortfolioAll))

plot_ly(Portfolio_CumRet_tb, x = ~Date, 
         y = ~MACD, name = 'MACD', type = 'scatter', mode = 'lines') %>% 
   add_trace(y = ~RSI, name = 'RSI', mode = 'lines') %>%
   layout(title = paste0("Strategy Cumulative Return")) 


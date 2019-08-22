suppressMessages(library(PerformanceAnalytics))
suppressMessages(library(quantmod))
suppressMessages(library(timeSeries))
suppressMessages(library(fUnitRoots))
suppressMessages(library(fPortfolio))
suppressMessages(library(CVXR))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(plotly))

##### ........... =====
##### Input =====
# input is from python

##### ........... =====
##### Source =====

pathis <- "C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy1.0/"
files <- list.files(path = paste0(pathis,"server/"),pattern = "\\.R")
lapply(files, function(idx){
  cat(paste0("server/", idx))
  source(paste0("server/", idx))
})

##### ........... =====
##### DataTable =====
# should be provided by python later
RDS <- "SQLDB_TW_20190711.RDS"
readDataFrame <- readRDS(file = paste0(pathis,RDS))


get_SelectDT<-function(readDataFrame,input){
  DataTable <- getDT_FromSQL(readDataFrame)
  Win_DT <- getWin_DT(DataTable, SelectCol = "Close", StartDate = input$StartDate, EndDate = input$EndDate)
  Select_DT <- getSelect_DT(Win_DT, input$listID)
  return(Select_DT)
}

# Ret_DT <- getRet_DT(Select_DT)
# CumRet_DT <- getCumRet_DT(Ret_DT)

get_alldf<-function(Select_DT,Ret_DT){
  ##### RSI Strategy =====
  # nma = 5, maType = "SMA", > RSI_Up = 70 Short, < RSI_Down = 30 Long
  RSI_Signal <- get_RSI_Signal(Select_DT)
  Equity_RSI <- getEquity_DT(Ret_DT, RSI_Signal)
  JG_Equity_DT_RSI <- get_Equity_All_DT(Select_DT, Ret_DT, RSI_Signal, Equity_RSI)
  return(JG_Equity_DT_RSI)
}



## CumRet_Plotly
# CumRet_Plotly <- getPloty(CumRet_DT)

# plot_ly(CumRet_Plotly, x = ~index, y = ~CumRet, 
#         type = 'scatter', mode = 'lines'
#         ,hoverinfo = 'text',
#         text = ~paste('CumRet : ', CumRet,
#                       '<br /> Date: ', index)
# ) %>% 
#   layout(title = paste0(input$listID," Cumulative Return"),
#          xaxis = list(title = ''),
#          yaxis = list(title = 'Cumulative Return')
#   )

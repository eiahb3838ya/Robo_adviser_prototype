suppressMessages(library(PerformanceAnalytics))
suppressMessages(library(quantmod))
suppressMessages(library(timeSeries))
suppressMessages(library(fUnitRoots))
suppressMessages(library(fPortfolio))
suppressMessages(library(CVXR))
suppressMessages(library(data.table))

##### ........... =====
##### Input =====
# input is from python
# input <- list()
# 
# 
#  input$listID <- "2330"
# 
# 
# # periodn = "Day"
# # periodn = "Week"
# # periodn = "Month"
# # periodn = "Quarter"
# # periodn = "Year"
# input$period <- "Quarter"
# input$StartDate <-  "2007-01-02"
# input$EndDate <-  "2019-06-28"
##### ........... =====
##### Source =====

pathis <- "C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/nice_oop_strategy/"
files <- list.files(path = paste0(pathis,"server/"),pattern = "\\.R")
lapply(files, function(idx){
  cat(paste0("server/", idx))
  source(paste0("server/", idx))
})

##### ........... =====
##### DataTable =====
# should be provided by python later
# RDS <- "SQLDB_TW_20190711.RDS"
# readDataFrame <- readRDS(file = paste0(pathis,RDS))
##### MACD Strategy =====
# MACD_Fast = 12, MACD_Slow = 26, MACD_Sig = 9
get_alldf<-function(Select_DT,Ret_DT){
  Signal <- get_MACD_Signal(Select_DT)
  Equity <- getEquity_DT(Ret_DT, Signal)
  JG_Equity_DT <- get_Equity_All_DT(Select_DT, Ret_DT, Signal, Equity)
  return(JG_Equity_DT)
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

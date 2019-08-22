suppressMessages(require(PerformanceAnalytics))
suppressMessages(require(quantmod))
suppressMessages(require(timeSeries))
suppressMessages(require(fUnitRoots))
suppressMessages(require(fPortfolio))
suppressMessages(require(CVXR))
suppressMessages(require(data.table))
suppressMessages(require(tidyverse))
suppressMessages(require(plotly))

##### Source =====

pathis <- "C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/r_strategy2.0/"
files <- list.files(path = "Function/",pattern = "\\.R")
lapply(files, function(idx){
  source(paste0("Function/", idx))
})

suppressMessages(library(PerformanceAnalytics))
suppressMessages(library(quantmod))
suppressMessages(library(timeSeries))
suppressMessages(library(fUnitRoots))
suppressMessages(library(fPortfolio))
suppressMessages(library(CVXR))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(plotly))

##### Source =====

pathis <- "C:/Users/Evan/Desktop/xiqi/Robo_adviser_prototype/robo_adviser/adviser/r_strategy/nice_oop_strategy/"
files <- list.files(path = paste0(pathis,"server/"),pattern = "\\.R")
lapply(files, function(idx){
  cat(paste0("server/", idx))
  source(paste0("server/", idx))
})

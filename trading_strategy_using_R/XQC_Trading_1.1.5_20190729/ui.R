##### XiQi Captial =====
## Azar Lin
## 20190708
## Home Page UI

## Library =====
lib <- c("shiny","PerformanceAnalytics","quantmod","timeSeries","fUnitRoots",
         "fPortfolio","CVXR","data.table","plotly")
lapply(lib, library, character.only = TRUE)

shinyUI(
  ui = tagList(
    navbarPage("Xi Qi Capital",
               ##### Page 1 =====
               tabPanel("Summary",source("ui/TabPannel1.R", local = TRUE,  encoding = 'UTF-8')$value ),
               ##### Page 2 =====
               tabPanel("Risk",source("ui/TabPannel2.R", local = TRUE,  encoding = 'UTF-8')$value ),
               ##### Page 3 =====
               tabPanel("Portfolio", source("ui/TabPannel3.R", local = TRUE,  encoding = 'UTF-8')$value)
                 
      )
    )
  )


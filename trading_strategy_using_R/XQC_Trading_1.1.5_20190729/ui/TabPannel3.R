## Azar Lin
## 20190605
## TabPannel3.R

##### tabPanel 2 =====
fluidPage(
  headerPanel("Portfolio"),
  mainPanel( tabsetPanel(
    ## OVERVIEW
    tabPanel("Markowitz", fluidRow(br(),
                                   plotlyOutput("Markowitz_Rolling_Corr", height = 300),
                                   plotlyOutput("Markowitz_Rolling_Wt", height = 300),
                                   plotlyOutput("Markowitz_Rolling_Ret", height = 300),
                                   plotlyOutput("Markowitz_Rolling_CumRet", height = 300),
                                   plotlyOutput("Markowitz_Rolling_DD", height = 300))),
    
    tabPanel("RiskParity", fluidRow(br(),
                                    plotlyOutput("RiskParity_Rolling_Corr", height = 300),
                                    plotlyOutput("RiskParity_Rolling_Wt", height = 300),
                                    plotlyOutput("RiskParity_Rolling_Ret", height = 300),
                                    plotlyOutput("RiskParity_Rolling_CumRet", height = 300),
                                    plotlyOutput("RiskParity_Rolling_DD", height = 300))),
    
    tabPanel("CVaR", fluidRow(br(),
                              plotlyOutput("CVaR_Rolling_Corr", height = 300),
                              plotlyOutput("CVaR_Rolling_Wt", height = 300),
                              plotlyOutput("CVaR_Rolling_Ret", height = 300),
                              plotlyOutput("CVaR_Rolling_CumRet", height = 300),
                              plotlyOutput("CVaR_Rolling_DD", height = 300)))
    )
  )
  ## fluidPage end
)

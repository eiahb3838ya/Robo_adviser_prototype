## Azar Lin
## 20190717
## TabPannel2.R

##### tabPanel 2 =====
fluidPage(
  headerPanel("Risk contribution"),
  mainPanel( tabsetPanel(
    ## OVERVIEW
    tabPanel("Markowitz", fluidRow(br(),
                                   plotlyOutput("EFrontier_plotly_MK", height = 300),
                                   br(),
                                   plotlyOutput("RC_Markowitz", height = 300),
                                   br(),
                                   plotlyOutput("Wt_Markowitz", height = 300),
                                   br(),
                                   plotlyOutput("MVaR_Markowitz", height = 300),
                                   br(),
                                   plotlyOutput("CVaR_Markowitz", height = 300))),
    
    tabPanel("RiskParity", fluidRow(br(),
                                    plotlyOutput("EFrontier_plotly_VaR", height = 300),
                                    br(),
                                    plotlyOutput("RC_RiskParity", height = 300),
                                    br(),
                                    plotlyOutput("Wt_RiskParity", height = 300),
                                    br(),
                                    plotlyOutput("MVaR_RiskParity", height = 300),
                                    br(),
                                    plotlyOutput("CVaR_RiskParity", height = 300))),
    
    tabPanel("CVaR", fluidRow(br(),
                              plotlyOutput("EFrontier_plotly_CVaR", height = 300),
                              br(),
                              plotlyOutput("RC_CVaR", height = 300),
                              br(),
                              plotlyOutput("Wt_CVaR", height = 300),
                              br(),
                              plotlyOutput("MVaR_CVaR", height = 300),
                              br(),
                              plotlyOutput("CVaR_CVaR", height = 300)))
    )
  )
  ## fluidPage end
)

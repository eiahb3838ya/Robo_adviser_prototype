## Azar Lin
## 20190605
## TabPannel1.R

fluidPage(
  headerPanel("Basic Info"),
  sidebarPanel( selectInput("assetClass", 
                            "Asset Class:", 
                            choices = c("TW","DOJ30","SP500","ETFS","ENK225")),
                
                selectInput("listID", "Select IDX:", ""),
                
                selectInput("period", "Rolling Period:",
                            choices = c("Day","Week","Month","Quarter","Year")),
                
                # selectInput("startDate", "Start:", choices = theDates),
                # selectInput("endDate", "End:", choices = theDates, selected = theDates[length(theDates)]),
                actionButton("Execute", "Execute")),
  mainPanel( tabsetPanel(
    ## OVERVIEW
    tabPanel("Overview",
             br(),
             plotlyOutput("Info"),
             plotlyOutput("Portfolio_Ret_Plotly"),
             plotlyOutput("Portfolio_CumRet_Plotly"),
             plotlyOutput("Portfolio_DD_Plotly"),
             tableOutput("PairTradingReport")
             )
   
    ## mainPanel end
    )
  ## fluidPage end
  )
)
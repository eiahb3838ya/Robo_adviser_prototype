##### XiQi Captial =====
## Azar Lin
## 20190705
## Server

##### ........... =====
###### packages =====
# packages_list <- list(
#   "PerformanceAnalytics",
#   "quantmod",
#   "timeSeries",
#   "fUnitRoots",
#   "fPortfolio",
#   "CVXR",
#   "data.table",
#   "plotly"
# )
# 
# lapply(packages_list, function(idx){
#   install.packages(idx)
# })
##### ........... =====
## Library =====
lib <- c("shiny","PerformanceAnalytics","quantmod","timeSeries","fUnitRoots",
         "fPortfolio","CVXR","data.table","plotly")
lapply(lib, library, character.only = TRUE)

##### ........... =====
##### Source =====
files <- list.files(path = "server/",pattern = "\\.R")
lapply(files, function(idx){
  source(paste0("server/", idx))
})

##### ........... =====
##### shinyServer =====
shinyServer(function(input, output, session) {
  # source("server/TP1Server.R", local = TRUE)
  ##### ........... =====
  ##### tabPanel 1 =====
  ##### ........... =====
  ##### DataTable =====
  DataTable <- reactive({
    ### data_TW
    if (input$assetClass == "TW") {
      RDS <- "SQLDB_TW_20190729.RDS"
    } 
    ### data_DOJ30
    if (input$assetClass == "DOJ30") {
      RDS <- "Dt_DOJ30_Azar_20190603.RDS"
    }
    ### data_SP500 
    if (input$assetClass == "SP500") {
      RDS <- "Dt_SP500_Azar_20190603.RDS"
    }
    ### data_ETFS  
    if (input$assetClass == "ETFS") {
      RDS <- "Dt_ETFS_Azar_20190603.RDS"
    }
    ### data_NK225 
    if (input$assetClass == "ENK225") {
      RDS <- "Dt_ENK225_Azar_20190603.RDS"
    }
    readDataFrame <- readRDS(file = paste0("Data/",RDS))
    ##### getDT_FromSQL =====
    DataTable <- getDT_FromSQL(readDataFrame)
    
    return(DataTable)
  })

  ##### ........... =====
  ##### listID =====
  listID <- reactive({
    DataTable <- DataTable()
    idx <- sort(unique(DataTable$Stock_Code))
    return(idx)
  })
  ##### ........... =====
  ###### observe ListID =====
  observe({
    updateSelectInput(session, "listID",
                      choices = listID()
    )})
  ##### ........... =====
  ##### WinDT =====
  Win_DT <- reactive({
    
    # input <- list()
    # input$SelectCol <- "Close"
    # input$listID <- "00660"
    # periodn = "Day"
    # periodn = "Week"
    # periodn = "Month"
    # periodn = "Quarter"
    # periodn = "Year"
    # input$period <- "Month"
    # input$StartDate <-  "2007-01-02"
    # input$EndDate <-  "2019-06-28"
    # input$SelectCol <- "Close"
    
    DataTable <- DataTable()
    ##### getCol_DT =====
    SelectCol_DT <- getCol_DT(DataTable, "Close")
    
    ##### getCode_DT =====
    SelectCode_DT <- getCode_DT(SelectCol_DT, input$listID)
    
    ##### getPeriod_DT =====
    Period_DT <- getPeriod_DT(SelectCode_DT)
    
    ##### getWin_DT =====
    # input$StartDate <-  Period_DT[[1]] # 2007-01-02
    # input$EndDate <-  Period_DT[[2]] # 2019-06-28
    Win_DT <- getWin_DT(SelectCode_DT, Period_DT[[1]], Period_DT[[2]])
    
    return(Win_DT)
  })
  
  ##### ........... =====
  ##### Select_DT =====
  Select_DT <- reactive({
    Win_DT <- Win_DT()
    # input <- list(listID = "2330")
    # input$StartDate <-  Period_DT[[1]] # 2007-01-02
    # input$EndDate <-  Period_DT[[2]] # 2019-06-28
    Period_DT <- getPeriod_DT(Win_DT)
    Select_DT <- getSelect_DT(Win_DT, input$listID, Period_DT[[1]], Period_DT[[2]])
    
    return(Select_DT)
  })
  
  ##### ........... =====
  ##### Info =====
  output$Info <- renderPlotly({
    
    Select_DT <- Select_DT()
    Ret_DT <- getRet_DT(Select_DT)
    CumRet_DT <- getCumRet_DT(Ret_DT)
    
    ## CumRet_Plotly
    CumRet_Plotly <- getPloty(CumRet_DT)
    ##
    plot_ly(CumRet_Plotly, x = ~index, y = ~CumRet, 
            type = 'scatter', mode = 'lines'
            ,hoverinfo = 'text',
            text = ~paste('Equity : ', CumRet,
                          '<br /> Date: ', index)
            ) %>% 
      layout(title = paste0(input$listID," Equity Curve"),
             xaxis = list(title = ''),
             yaxis = list(title = '')
             )
    
  })
  ##### ........... =====
  ##### Portfolio_All =====
  Portfolio_All <- reactive({
    # SelectXTS <- SelectDataXts
    # PriceXTS <- DataXts
    Select_DT <- Select_DT()
    Win_DT <- Win_DT()
    
    Ret_DT <- getRet_DT(Select_DT)
    
    ##### MACD Strategy =====
    # MACD_Fast = 12, MACD_Slow = 26, MACD_Sig = 9
    MACD_Signal <- get_MACD_Signal(Select_DT)
    Equity_MACD <- getEquity_DT(Ret_DT, MACD_Signal)
    JG_Equity_DT_MACD <- get_Equity_All_DT(Select_DT, Ret_DT, MACD_Signal, Equity_MACD)
    
    ##### RSI Strategy =====
    # nma = 5, maType = "SMA", > RSI_Up = 80 Short, < RSI_Down = 20 Long
    RSI_Signal <- get_RSI_Signal(Select_DT)
    Equity_RSI <- getEquity_DT(Ret_DT, RSI_Signal)
    JG_Equity_DT_RSI <- get_Equity_All_DT(Select_DT, Ret_DT, RSI_Signal, Equity_RSI)
    
    ##### MA Strategy =====
    # MA_fast = 20, MA_slow = 60
    MA_Signal <- get_MA_Signal(Select_DT)
    Equity_MA <- getEquity_DT(Ret_DT, MA_Signal)
    JG_Equity_DT_MA <- get_Equity_All_DT(Select_DT, Ret_DT, MA_Signal, Equity_MA)
    
    ##### BB Strategy =====
    # BB_size = 20, BB_k = 1
    BB_Signal <- get_BB_Signal(Select_DT)
    Equity_BB <- getEquity_DT(Ret_DT, BB_Signal)
    JG_Equity_DT_BB <- get_Equity_All_DT(Select_DT, Ret_DT, BB_Signal, Equity_BB)
    
    #### Distance Based Pair Trading Strategy =====
    # StockCode = "2330", Dist_size = 20, Dist_k = 1
    Dist_Pair <- get_Dist_Pair(Win_DT, StockCode = input$listID)
    Dist_Signal <- get_Pair_Signal(Win_DT, Dist_Pair = Dist_Pair, SignalName = "Dist")
    Dist_Ret <- get_Pair_Ret(Win_DT, Dist_Pair = Dist_Pair)
    Equity_Dist <- getEquity_DT(Dist_Ret, Dist_Signal)
    
    JG_Equity_DT_Dist <- get_Equity_All_DT(Select_DT, Dist_Ret, Dist_Signal, Equity_Dist)
    
    JG_Dist_Report <- data.frame("Dist",Dist_Pair$stock1, Dist_Pair$stock2)
    colnames(JG_Dist_Report) <- c("Pair Trading", "Stock X", "Stock Y")
    
    ##### ........... =====
    ##### Equity_All =====
    Equity_All <- get_Equity_DT(Ret_DT, Equity_MACD, Equity_RSI, Equity_MA, Equity_BB, Equity_Dist)
    PT_Report <- JG_Dist_Report
    # Portfolio_All <- list(Equity_All = Equity_All, PT_Report = PT_Report )
    return(list(Equity_All = Equity_All, PT_Report = PT_Report ))
  })
  ##### ........... =====
  ##### Portfolio Plotly =====
  ##### Portfolio_Ret_Plotly =====
  output$Portfolio_Ret_Plotly <- renderPlotly({
    # Portfolio_All <- Portfolio_All
    
    Portfolio_All <- Portfolio_All()
    Portfolio_Ret_Plotly <- getPloty(Portfolio_All$Equity_All)
    
    plot_ly(Portfolio_Ret_Plotly, x = ~index, y = ~MACD,
            name = 'MACD', type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('MACD Ret : ', MACD,'<br /> Date: ', index)) %>% 
      add_trace(y = ~RSI, name = 'RSI', mode = 'lines',hoverinfo = 'text',
                text = ~paste('RSI Ret : ', RSI,'<br /> Date: ', index)) %>%
      add_trace(y = ~MA, name = 'MA', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MA Ret : ', MA,'<br /> Date: ', index)) %>% 
      add_trace(y = ~BB, name = 'BB', mode = 'lines',hoverinfo = 'text',
                text = ~paste('BB Ret : ', BB,'<br /> Date: ', index)) %>% 
      add_trace(y = ~Dist, name = 'Dist', mode = 'lines',hoverinfo = 'text',
                text = ~paste('Dist Ret : ', Dist,'<br /> Date: ', index)) %>% 
      layout(title = paste0("Strategy Returns"),
             xaxis = list(title = ''),
             yaxis = list(title = 'Return'))
  })
  
  ##### Portfolio_CumRet_Plotly =====
  output$Portfolio_CumRet_Plotly <- renderPlotly({
    
    Portfolio_All <- Portfolio_All()
    Portfolio_CumRet_DT <- getCumRet_DT(Portfolio_All$Equity_All, colnames(Portfolio_All$Equity_All)[-1])
    Portfolio_CumRet_Plotly <- getPloty(Portfolio_CumRet_DT)
    
    plot_ly(Portfolio_CumRet_Plotly, x = ~index, y = ~MACD, 
            name = 'MACD', type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('MACD CumRet : ', MACD, '<br /> Date: ', index)) %>% 
      add_trace(y = ~RSI, name = 'RSI', mode = 'lines',hoverinfo = 'text',
                text = ~paste('RSI CumRet : ', RSI,'<br /> Date: ', index)) %>%
      add_trace(y = ~MA, name = 'MA', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MA CumRet : ', MA,'<br /> Date: ', index)) %>% 
      add_trace(y = ~BB, name = 'BB', mode = 'lines',hoverinfo = 'text',
                text = ~paste('BB CumRet : ', BB,'<br /> Date: ', index)) %>% 
      add_trace(y = ~Dist, name = 'Dist', mode = 'lines',hoverinfo = 'text',
                text = ~paste('Dist CumRet : ', Dist,'<br /> Date: ', index)) %>% 
      layout(title = paste0("Strategy Equity Curve"),
             xaxis = list(title = ''),
             yaxis = list(title = 'Equity'))
  })
  
  ##### Portfolio_DD_Plotly =====
  output$Portfolio_DD_Plotly <- renderPlotly({
    
    Portfolio_All <- Portfolio_All()
    Portfolio_DD_DT <- getDrawdowns(Portfolio_All$Equity_All, col_name =  colnames(Portfolio_All$Equity_All)[-1])
    Portfolio_DD_Plotly <- getPloty(Portfolio_DD_DT)
    
    plot_ly(Portfolio_DD_Plotly, x = ~index, y = ~MACD,
            name = 'MACD', type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('MACD DD : ', MACD,'<br /> Date: ', index)) %>% 
      add_trace(y = ~RSI, name = 'RSI', mode = 'lines',hoverinfo = 'text',
                text = ~paste('RSI DD : ', RSI,'<br /> Date: ', index)) %>%
      add_trace(y = ~MA, name = 'MA', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MA DD : ', MA,'<br /> Date: ', index)) %>% 
      add_trace(y = ~BB, name = 'BB', mode = 'lines',hoverinfo = 'text',
                text = ~paste('BB DD : ', BB,'<br /> Date: ', index)) %>% 
      add_trace(y = ~Dist, name = 'Dist', mode = 'lines',hoverinfo = 'text',
                text = ~paste('Dist DD : ', Dist,'<br /> Date: ', index)) %>% 
      layout(title = paste0("Strategy Drawdowns"),
             xaxis = list(title = ''),
             yaxis = list(title = 'Drawdowns'))
  })
  
  ##### PairTradingReport =====
  output$PairTradingReport <- renderTable({
    # Portfolio_Alls <- PortfolioAlls
    Portfolio_All <- Portfolio_All()
    Portfolio_All$PT_Report
  })
  ##### ........... =====
  ##### tabPanel 2 =====
  ##### ........... =====
  ##### Efficient Frontier =====
  Portfolio_EFrontier <- reactive({
    Portfolio_All <- Portfolio_All()
    EfficientFrontier <- get_EfficientFrontier(Portfolio_All$Equity_All)
    # Portfolio_EFrontier <- EfficientFrontier
    return(EfficientFrontier)
    # tailoredFrontierPlot(EffFrontier,risk = "Sigma",mText = "MV Portfolio - LongOnly Constraints")
  })
  ##### ........... =====
  ##### Portfolio_MVaR_CVaR =====
  Portfolio_MVaR_CVaR <- reactive({
    Portfolio_All <- Portfolio_All()
    
    ##### MVaR_CVaR_Markowitz =====
    MVaR_CVaR_Markowitz <- get_MVaR_CVaR_Markowitz(Portfolio_All$Equity_All)

    ##### MVaR_CVaR_Riskparity =====
    MVaR_CVaR_RiskParity <- get_MVaR_CVaR_RiskParity(Portfolio_All$Equity_All)
    
    ##### MVaR_CVaR_CVaR =====
    MVaR_CVaR_CVaR <- get_MVaR_CVaR_CVaR(Portfolio_All$Equity_All)
    
    # Portfolio_MVaR_CVaR <- list(RC_Markowitz = MVaR_CVaR_Markowitz$RC,
    #                             Wt_Markowitz = MVaR_CVaR_Markowitz$Wt,
    #                             MVaR_Markowitz = MVaR_CVaR_Markowitz$MVaR,
    #                             CVaR_Markowitz = MVaR_CVaR_Markowitz$CVaR,
    #                             
    #                             RC_RiskParity = MVaR_CVaR_RiskParity$RC,
    #                             Wt_RiskParity = MVaR_CVaR_RiskParity$Wt,
    #                             MVaR_RiskParity = MVaR_CVaR_RiskParity$MVaR,
    #                             CVaR_RiskParity = MVaR_CVaR_RiskParity$CVaR,
    #                             
    #                             RC_CVaR = MVaR_CVaR_CVaR$RC,
    #                             Wt_CVaR = MVaR_CVaR_CVaR$Wt,
    #                             MVaR_CVaR = MVaR_CVaR_CVaR$MVaR,
    #                             CVaR_CVaR = MVaR_CVaR_CVaR$CVaR)
    
    return(list(RC_Markowitz = MVaR_CVaR_Markowitz$RC,
                Wt_Markowitz = MVaR_CVaR_Markowitz$Wt,
                MVaR_Markowitz = MVaR_CVaR_Markowitz$MVaR,
                CVaR_Markowitz = MVaR_CVaR_Markowitz$CVaR,
                
                RC_RiskParity = MVaR_CVaR_RiskParity$RC,
                Wt_RiskParity = MVaR_CVaR_RiskParity$Wt,
                MVaR_RiskParity = MVaR_CVaR_RiskParity$MVaR,
                CVaR_RiskParity = MVaR_CVaR_RiskParity$CVaR,
                
                RC_CVaR = MVaR_CVaR_CVaR$RC,
                Wt_CVaR = MVaR_CVaR_CVaR$Wt,
                MVaR_CVaR = MVaR_CVaR_CVaR$MVaR,
                CVaR_CVaR = MVaR_CVaR_CVaR$CVaR)
           )
  })
  ##### ........... =====
  ##### Efficient Frontier Plotly=====
  ##### EFrontier_plotly_MK =====
  output$EFrontier_plotly_MK <- renderPlotly({
    Portfolio_EFrontier <- Portfolio_EFrontier()
    plot_ly(x = Portfolio_EFrontier$targetRisk$Cov, y = Portfolio_EFrontier$targetReturn$mu, mode = "lines", name = "Efficient Frontier", type = "scatter") %>%
      add_trace(x = Portfolio_EFrontier$Sigma$MACD, y = Portfolio_EFrontier$Mu$MACD, mode = "markers", name = "MACD", type = "scatter",
                hoverinfo = 'text', text = ~paste('MACD : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$MACD, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$MACD)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$RSI, y = Portfolio_EFrontier$Mu$RSI, mode = "markers", name = "RSI", type = "scatter",
                hoverinfo = 'text', text = ~paste('RSI : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$RSI, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$RSI)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$MA, y = Portfolio_EFrontier$Mu$MA, mode = "markers", name = "MA", type = "scatter",
                hoverinfo = 'text', text = ~paste('MA : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$MA, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$MA)) %>%
      add_trace( x = Portfolio_EFrontier$Sigma$BB, y = Portfolio_EFrontier$Mu$BB, mode = "markers", name = "BB", type = "scatter",
                hoverinfo = 'text', text = ~paste('BB : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$BB, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$BB)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$Dist, y = Portfolio_EFrontier$Mu$Dist, mode = "markers", name = "Dist", type = "scatter",
                hoverinfo = 'text', text = ~paste('Dist : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$Dist, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$Dist)) %>%
      add_trace(x = Portfolio_EFrontier$Risk[[2]], y = Portfolio_EFrontier$Return[[2]], mode = "markers", name = "MinSigma", type = "scatter",
                hoverinfo = 'text', text = ~paste('Min Sigma : ', '<br /> Mean: ', Portfolio_EFrontier$Return[[2]], '<br /> Sigma: ', Portfolio_EFrontier$Risk[[2]])) %>%
      add_trace(x = Portfolio_EFrontier$tgRisk, y = Portfolio_EFrontier$tgReturn, mode = "markers", name = "Portfolio", type = "scatter",
                hoverinfo = 'text', text = ~paste('Portfolio : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$Dist, '<br /> Sigma: ', Portfolio_EFrontier$tgRisk)) %>%
      layout(title = "Efficient Frontier", xaxis = list(title = "Sigma"), yaxis = list(title = "Mean"))
  })
  ##### EFrontier_plotly_VaR =====
  output$EFrontier_plotly_VaR <- renderPlotly({
    Portfolio_EFrontier <- Portfolio_EFrontier()
    plot_ly(x = Portfolio_EFrontier$targetRisk$Cov, y = Portfolio_EFrontier$targetReturn$mu, mode = "lines", name = "Efficient Frontier", type = "scatter") %>%
      add_trace(x = Portfolio_EFrontier$Sigma$MACD, y = Portfolio_EFrontier$Mu$MACD, mode = "markers", name = "MACD", type = "scatter",
                hoverinfo = 'text', text = ~paste('MACD : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$MACD, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$MACD)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$RSI, y = Portfolio_EFrontier$Mu$RSI, mode = "markers", name = "RSI", type = "scatter",
                hoverinfo = 'text', text = ~paste('RSI : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$RSI, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$RSI)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$MA, y = Portfolio_EFrontier$Mu$MA, mode = "markers", name = "MA", type = "scatter",
                hoverinfo = 'text', text = ~paste('MA : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$MA, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$MA)) %>%
      add_trace( x = Portfolio_EFrontier$Sigma$BB, y = Portfolio_EFrontier$Mu$BB, mode = "markers", name = "BB", type = "scatter",
                 hoverinfo = 'text', text = ~paste('BB : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$BB, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$BB)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$Dist, y = Portfolio_EFrontier$Mu$Dist, mode = "markers", name = "Dist", type = "scatter",
                hoverinfo = 'text', text = ~paste('Dist : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$Dist, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$Dist)) %>%
      add_trace(x = Portfolio_EFrontier$Risk[[2]], y = Portfolio_EFrontier$Return[[2]], mode = "markers", name = "MinSigma", type = "scatter",
                hoverinfo = 'text', text = ~paste('Min Sigma : ', '<br /> Mean: ', Portfolio_EFrontier$Return[[2]], '<br /> Sigma: ', Portfolio_EFrontier$Risk[[2]])) %>%
      add_trace(x = Portfolio_EFrontier$tgRisk, y = Portfolio_EFrontier$tgReturn, mode = "markers", name = "Portfolio", type = "scatter",
                hoverinfo = 'text', text = ~paste('Portfolio : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$Dist, '<br /> Sigma: ', Portfolio_EFrontier$tgRisk)) %>%
      layout(title = "Efficient Frontier", xaxis = list(title = "Sigma"), yaxis = list(title = "Mean"))
  })
  ##### EFrontier_plotly_CVaR =====
  output$EFrontier_plotly_CVaR <- renderPlotly({
    Portfolio_EFrontier <- Portfolio_EFrontier()
    plot_ly(x = Portfolio_EFrontier$targetRisk$Cov, y = Portfolio_EFrontier$targetReturn$mu, mode = "lines", name = "Efficient Frontier", type = "scatter") %>%
      add_trace(x = Portfolio_EFrontier$Sigma$MACD, y = Portfolio_EFrontier$Mu$MACD, mode = "markers", name = "MACD", type = "scatter",
                hoverinfo = 'text', text = ~paste('MACD : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$MACD, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$MACD)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$RSI, y = Portfolio_EFrontier$Mu$RSI, mode = "markers", name = "RSI", type = "scatter",
                hoverinfo = 'text', text = ~paste('RSI : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$RSI, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$RSI)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$MA, y = Portfolio_EFrontier$Mu$MA, mode = "markers", name = "MA", type = "scatter",
                hoverinfo = 'text', text = ~paste('MA : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$MA, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$MA)) %>%
      add_trace( x = Portfolio_EFrontier$Sigma$BB, y = Portfolio_EFrontier$Mu$BB, mode = "markers", name = "BB", type = "scatter",
                 hoverinfo = 'text', text = ~paste('BB : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$BB, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$BB)) %>%
      add_trace(x = Portfolio_EFrontier$Sigma$Dist, y = Portfolio_EFrontier$Mu$Dist, mode = "markers", name = "Dist", type = "scatter",
                hoverinfo = 'text', text = ~paste('Dist : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$Dist, '<br /> Sigma: ', Portfolio_EFrontier$Sigma$Dist)) %>%
      add_trace(x = Portfolio_EFrontier$Risk[[2]], y = Portfolio_EFrontier$Return[[2]], mode = "markers", name = "MinSigma", type = "scatter",
                hoverinfo = 'text', text = ~paste('Min Sigma : ', '<br /> Mean: ', Portfolio_EFrontier$Return[[2]], '<br /> Sigma: ', Portfolio_EFrontier$Risk[[2]])) %>%
      add_trace(x = Portfolio_EFrontier$tgRisk, y = Portfolio_EFrontier$tgReturn, mode = "markers", name = "Portfolio", type = "scatter",
                hoverinfo = 'text', text = ~paste('Portfolio : ', '<br /> Mean: ', Portfolio_EFrontier$Mu$Dist, '<br /> Sigma: ', Portfolio_EFrontier$tgRisk)) %>%
      layout(title = "Efficient Frontier", xaxis = list(title = "Sigma"), yaxis = list(title = "Mean"))
  })
  
  ##### ........... =====
  ##### Return Contribution Plotly =====
  ##### RC_Markowitz =====
  output$RC_Markowitz <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    plot_ly(Portfolio_MVaR_CVaR$RC_Markowitz, x = ~RetContri, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('RetContri: ', RetContri)) %>% 
      layout( title = "The Return Contribution of Markowitz Portfolio", 
              xaxis = list(title = 'Return Contribution'),
              yaxis = list(title = ' '))
  })
  ##### RC_RiskParity =====
  output$RC_RiskParity <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    plot_ly(Portfolio_MVaR_CVaR$RC_RiskParity, x = ~RetContri, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('RetContri: ', RetContri)) %>% 
      layout( title = "The Return Contribution of Risk Parity Portfolio", 
              xaxis = list(title = 'Return Contribution'),
              yaxis = list(title = ' '))
  })
  ##### RC_CVaR =====
  output$RC_CVaR <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    plot_ly(Portfolio_MVaR_CVaR$RC_CVaR, x = ~RetContri, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('RetContri: ', RetContri)) %>% 
      layout( title = "The Return Contribution of CVaR Portfolio", 
              xaxis = list(title = 'Return Contribution'),
              yaxis = list(title = ' '))
  })
  ##### ........... =====
  ##### MVaR_CVaR Plotly =====
  ##### ........... =====
  ##### Wt_Markowitz =====
  output$Wt_Markowitz <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$Wt_Markowitz, x = ~Wt, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('Wt: ', Wt)
    ) %>% 
      layout( title = "The Weight of Markowitz Portfolio", 
              xaxis = list(title = 'Weight'),
              yaxis = list(title = ' '))
  })
  
  ##### MVaR_Markowitz =====
  output$MVaR_Markowitz <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$MVaR_Markowitz, x = ~MVaR, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('MVaR: ', MVaR)
    ) %>% 
      layout( title = "The Marginal VaR of Markowitz Portfolio", 
              xaxis = list(title = 'MVaR'),
              yaxis = list(title = ' '))
  })
  
  ##### CVaR_Markowitz =====
  output$CVaR_Markowitz <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$CVaR_Markowitz, x = ~CVaR, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('CVaR: ', CVaR)
    ) %>% 
      layout( title = "The Component VaR of Markowitz Portfolio", 
              xaxis = list(title = 'CVaR'),
              yaxis = list(title = ' '))
  })
  
  ##### ........... =====
  ##### Wt_RiskParity =====
  output$Wt_RiskParity <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$Wt_RiskParity, x = ~Wt, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('Wt: ', Wt)
    ) %>% 
      layout( title = "The Weight of Risk Parity Portfolio", 
              xaxis = list(title = 'Weight'),
              yaxis = list(title = ' '))
  })
  
  ##### MVaR_RiskParity =====
  output$MVaR_RiskParity <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$MVaR_RiskParity, x = ~MVaR, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('MVaR: ', MVaR)
    ) %>% 
      layout( title = "The Marginal VaR of Risk Parity Portfolio", 
              xaxis = list(title = 'MVaR'),
              yaxis = list(title = ' '))
  })
  
  ##### CVaR_RiskParity =====
  output$CVaR_RiskParity <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$CVaR_RiskParity, x = ~CVaR, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('CVaR: ', CVaR)
    ) %>% 
      layout( title = "The Component VaR of Risk Parity Portfolio", 
              xaxis = list(title = 'CVaR'),
              yaxis = list(title = ' '))
  })
  
  ##### ........... =====
  ##### Wt_CVaR =====
  output$Wt_CVaR <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$Wt_CVaR, x = ~Wt, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('Wt: ', Wt)
    ) %>% 
      layout( title = "The Weight of Conditional VaR Portfolio", 
              xaxis = list(title = 'Weight'),
              yaxis = list(title = ' '))
  })
  
  ##### MVaR_CVaR =====
  output$MVaR_CVaR <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$MVaR_CVaR, x = ~MVaR, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('MVaR: ', MVaR)
    ) %>% 
      layout( title = "The Marginal VaR of Conditional VaR Portfolio", 
              xaxis = list(title = 'MVaR'),
              yaxis = list(title = ' '))
  })
  
  ##### CVaR_CVaR =====
  output$CVaR_CVaR <- renderPlotly({
    Portfolio_MVaR_CVaR <- Portfolio_MVaR_CVaR()
    
    plot_ly(Portfolio_MVaR_CVaR$CVaR_CVaR, x = ~CVaR, y = ~Strategy, 
            type = 'bar', orientation = 'h', 
            hoverinfo = 'text', text = ~paste('CVaR: ', CVaR)
    ) %>% 
      layout( title = "The Component VaR of Conditional VaR Portfolio", 
              xaxis = list(title = 'CVaR'),
              yaxis = list(title = ' '))
  })
  
  ##### ........... =====
  ##### tabPanel 3 =====
  ##### ........... =====
  ##### Trading_Portfolio =====
  Trading_Portfolio <- eventReactive(input$Execute,{
    print("Executing")
    # Portfolio_Alls <- PortfolioAlls
    Portfolio_All <- Portfolio_All()
    # periodn = "Day"
    # periodn = "Week"
    # periodn = "Month"
    # periodn = "Quarter"
    # periodn = "Year"
    # input <- list(period = "Quarter")
    ## Markowitz_Portfolio
    RL_Period <- get_RL_Period(Portfolio_All$Equity_All, periodn =  input$period)
    RL_Markowitz <- get_RL_Markowitz(Portfolio_All$Equity_All, Startn = RL_Period$Startn, Endn = RL_Period$Endn, Next_n = RL_Period$Next_n)
    RL_Markowitz_Corr <- get_RL_Corr(RL_Markowitz, col_name = colnames(Portfolio_All$Equity_All)[-1])
    RL_Markowitz_Wt <- get_RL_Markowitz_Wt(RL_Markowitz, col_name = base::setdiff(colnames(Portfolio_All$Equity_All), "Benchmark")[-1])
    RL_Markowitz_Ret <- get_RL_Markowitz_Ret(RL_Markowitz)
    print("Markowitz_Portfolio OK")
    
    ## RiskParity_Portfolio
    RL_RiskParity <- get_RL_RiskParity(Portfolio_All$Equity_All, Startn = RL_Period$Startn, Endn = RL_Period$Endn, Next_n = RL_Period$Next_n)
    RL_RiskParity_Corr <- get_RL_Corr(RL_RiskParity, col_name = colnames(Portfolio_All$Equity_All)[-1])
    RL_RiskParity_Wt <- get_RL_RiskParity_Wt(RL_RiskParity, col_name = base::setdiff(colnames(Portfolio_All$Equity_All), "Benchmark")[-1])
    RL_RiskParity_Ret <- get_RL_RiskParity_Ret(RL_RiskParity)
    print("RiskParity_Portfolio OK")
    
    ## CVaR_Portfolio
    RL_CVaR <- get_RL_CVaR(Portfolio_All$Equity_All, Startn = RL_Period$Startn, Endn = RL_Period$Endn, Next_n = RL_Period$Next_n)
    RL_CVaR_Corr <- get_RL_Corr(RL_CVaR, col_name = colnames(Portfolio_All$Equity_All)[-1])
    RL_CVaR_Wt <- get_RL_CVaR_Wt(RL_CVaR, col_name = base::setdiff(colnames(Portfolio_All$Equity_All), "Benchmark")[-1])
    RL_CVaR_Ret <- get_RL_CVaR_Ret(RL_CVaR)
    print("CVaR_Portfolio OK")
    
    # Trading_Portfolio <- list(Markowitz_Cor = RL_Markowitz_Corr,
    #                          Markowitz_Wt = RL_Markowitz_Wt,
    #                          Markowitz_Ret = RL_Markowitz_Ret,
    #                          RiskParity_Cor = RL_RiskParity_Corr,
    #                          RiskParity_Wt = RL_RiskParity_Wt,
    #                          RiskParity_Ret = RL_RiskParity_Ret,
    #                          CVaR_Cor = RL_CVaR_Corr,
    #                          CVaR_Wt = RL_CVaR_Wt,
    #                          CVaR_Ret = RL_CVaR_Ret)
    return(list(Markowitz_Cor = RL_Markowitz_Corr,
                Markowitz_Wt = RL_Markowitz_Wt,
                Markowitz_Ret = RL_Markowitz_Ret,
                RiskParity_Cor = RL_RiskParity_Corr,
                RiskParity_Wt = RL_RiskParity_Wt,
                RiskParity_Ret = RL_RiskParity_Ret,
                CVaR_Cor = RL_CVaR_Corr,
                CVaR_Wt = RL_CVaR_Wt,
                CVaR_Ret = RL_CVaR_Ret)
           )
  })
  ##### ........... =====
  ##### Markowitz Plotly =====
  ##### Markowitz_Rolling_Corr =====
  output$Markowitz_Rolling_Corr <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    MarkowitzCor_Plotly <- getPloty(Trading_Portfolio$Markowitz_Cor)

    plot_ly(MarkowitzCor_Plotly, type = 'scatter', x = ~index,  
            y = ~Benchmark, name = input$listID,  mode = 'lines',hoverinfo = 'text',
            text = ~paste(paste0(input$listID,' Corr : '), Benchmark, '<br /> Date: ', index)) %>%
      add_trace(y = ~MACD, name = 'MACD', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MACD Corr : ', MACD, '<br /> Date: ', index)) %>%
      add_trace(y = ~RSI, name = 'RSI', mode = 'lines',hoverinfo = 'text',
                text = ~paste('RSI Corr : ', RSI, '<br /> Date: ', index)) %>%
      add_trace(y = ~MA, name = 'MA', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MA Corr : ', MA, '<br /> Date: ', index)) %>% 
      add_trace(y = ~BB, name = 'BB', mode = 'lines',hoverinfo = 'text',
                text = ~paste('BB Corr : ', BB, '<br /> Date: ', index)) %>% 
      add_trace(y = ~Dist, name = 'Dist', mode = 'lines',hoverinfo = 'text',
                text = ~paste('Dist Corr : ', Dist, '<br /> Date: ', index)) %>% 
      layout(title = "Strategy Correlation",
             xaxis = list(title = ''),
             yaxis = list(title = 'Correlation'))
    
  })
  
  ##### Markowitz_Rolling_Wt =====
  output$Markowitz_Rolling_Wt <- renderPlotly({
    # Trading_Portfolio <- TradingPortfolio
    Trading_Portfolio <- Trading_Portfolio()
    MarkowitzWt <- getPloty_RLWT(Trading_Portfolio$Markowitz_Wt)
    plot_ly(MarkowitzWt, x = ~Period, y = ~MACD, 
            name = 'MACD', type = "bar",hoverinfo = 'text',
            text = ~paste('MACD Wt : ', MACD, '<br /> Date: ', index)) %>%
      add_bars(y = ~RSI, name = 'RSI',hoverinfo = 'text',
               text = ~paste('RSI Wt : ', RSI, '<br /> Date: ', index)) %>%
      add_bars(y = ~MA, name = 'MA',hoverinfo = 'text',
               text = ~paste('MA Wt : ', MA, '<br /> Date: ', index)) %>% 
      add_bars(y = ~BB, name = 'BB',hoverinfo = 'text',
               text = ~paste('BB Wt : ', BB, '<br /> Date: ', index)) %>% 
      add_bars(y = ~Dist, name = 'Dist',hoverinfo = 'text',
               text = ~paste('Dist Wt : ', Dist, '<br /> Date: ', index)) %>% 
      layout(barmode = "stack", title = "Markowitz Portfolio Rolling Weight",
             xaxis = list(title = ''),
             yaxis = list(title = 'Weight'))
    
  })
  
  ##### Markowitz_Rolling_Ret =====
  output$Markowitz_Rolling_Ret <- renderPlotly({
    # Trading_Portfolio <- TradingPortfolio
    Trading_Portfolio <- Trading_Portfolio()
    MarkowitzRet_Plotly <- getPloty(Trading_Portfolio$Markowitz_Ret)
    
    plot_ly(MarkowitzRet_Plotly, x = ~index, y = ~Ret, name = 'Ret',
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('Ret : ', Ret, '<br /> Date: ', index)) %>% 
      layout(title = "Markowitz Portfolio Rolling Return",
             xaxis = list(title = ''),
             yaxis = list(title = 'Return'))
    
  })
  
  ##### Markowitz_Rolling_CumRet =====
  output$Markowitz_Rolling_CumRet <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    MarkowitzCumRet <- getCumRet_DT(Trading_Portfolio$Markowitz_Ret, "CumRet")
    MarkowitzCumRet_Plotly <- getPloty(MarkowitzCumRet)
    
    plot_ly(MarkowitzCumRet_Plotly, x = ~index, y = ~CumRet, name = 'Ret', 
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('Equity : ', CumRet, '<br /> Date: ', index)) %>% 
      layout(title = "Markowitz Portfolio Rolling Equity Curve",
             xaxis = list(title = ''),
             yaxis = list(title = 'Equity'))
    
  })
  
  ##### Markowitz_Rolling_DD =====
  output$Markowitz_Rolling_DD <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    MarkowitzDD <- getDrawdowns(Trading_Portfolio$Markowitz_Ret, col_name =  "DrawDowns")
    MarkowitzDD_Plotly <- getPloty(MarkowitzDD)
    
    plot_ly(MarkowitzDD_Plotly, x = ~index, y = ~DrawDowns, name = 'Ret', 
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('DrawDowns : ', DrawDowns, '<br /> Date: ', index)) %>% 
      layout(title = "Markowitz Portfolio Rolling DrawDowns",
             xaxis = list(title = ''),
             yaxis = list(title = 'DrawDowns'))
    
  })
  ##### ........... =====
  ##### RiskParity Plotly =====
  ##### RiskParity_Rolling_Corr =====
  output$RiskParity_Rolling_Corr <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    RiskParityCor_Plotly <- getPloty(Trading_Portfolio$RiskParity_Cor)
    
    plot_ly(RiskParityCor_Plotly, type = 'scatter', x = ~index, 
            y = ~Benchmark, name = input$listID, mode = 'lines',hoverinfo = 'text',
            text = ~paste(paste0(input$listID,' Corr : '), Benchmark, '<br /> Date: ', index)) %>%
      add_trace(y = ~MACD, name = 'MACD', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MACD Corr : ', MACD, '<br /> Date: ', index)) %>%
      add_trace(y = ~RSI, name = 'RSI', mode = 'lines',hoverinfo = 'text',
                text = ~paste('RSI Corr : ', RSI, '<br /> Date: ', index)) %>%
      add_trace(y = ~MA, name = 'MA', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MA Corr : ', MA, '<br /> Date: ', index)) %>% 
      add_trace(y = ~BB, name = 'BB', mode = 'lines',hoverinfo = 'text',
                text = ~paste('BB Corr : ', BB, '<br /> Date: ', index)) %>% 
      add_trace(y = ~Dist, name = 'Dist', mode = 'lines',hoverinfo = 'text',
                text = ~paste('Dist Corr : ', Dist, '<br /> Date: ', index)) %>% 
      layout(title = "Strategy Correlation",
             xaxis = list(title = ''),
             yaxis = list(title = 'Correlation'))
    
  })
  
  ##### RiskParity_Rolling_Wt =====
  output$RiskParity_Rolling_Wt <- renderPlotly({
    # Trading_Portfolio <- TradingPortfolio

    Trading_Portfolio <- Trading_Portfolio()
    RiskParityWt_Plotly <- getPloty_RLWT(Trading_Portfolio$RiskParity_Wt)
    
    plot_ly(RiskParityWt_Plotly, x = ~Period, y = ~MACD,
            name = 'MACD', type = "bar",hoverinfo = 'text',
            text = ~paste('MACD Wt : ', MACD, '<br /> Date: ', index)) %>%
      add_bars(y = ~RSI, name = 'RSI',hoverinfo = 'text',
               text = ~paste('RSI Wt : ', RSI, '<br /> Date: ', index)) %>%
      add_bars(y = ~MA, name = 'MA',hoverinfo = 'text',
               text = ~paste('MA Wt : ', MA, '<br /> Date: ', index)) %>% 
      add_bars(y = ~BB, name = 'BB',hoverinfo = 'text',
               text = ~paste('BB Wt : ', BB, '<br /> Date: ', index)) %>% 
      add_bars(y = ~Dist, name = 'Dist',hoverinfo = 'text',
               text = ~paste('Dist Wt : ', Dist, '<br /> Date: ', index)) %>% 
      layout(barmode = "stack", title = "RiskParity Portfolio Rolling Weight",
             xaxis = list(title = ''),
             yaxis = list(title = 'Weight'))
    
  })
  
  ##### RiskParity_Rolling_Ret =====
  output$RiskParity_Rolling_Ret <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    RiskParityRet_Plotly <- getPloty(Trading_Portfolio$RiskParity_Ret)
    
    plot_ly(RiskParityRet_Plotly, x = ~index, y = ~Ret, name = 'Ret', 
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('Ret : ', Ret, '<br /> Date: ', index)) %>% 
      layout(title = "Risk Parity Portfolio Rolling Return",
             xaxis = list(title = ''),
             yaxis = list(title = 'Return'))
    
  })
  
  ##### RiskParity_Rolling_CumRet =====
  output$RiskParity_Rolling_CumRet <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    RiskParityCumRet <- getCumRet_DT(Trading_Portfolio$RiskParity_Ret, "CumRet")
    RiskParityCumRet_Plotly <- getPloty(RiskParityCumRet)
    
    plot_ly(RiskParityCumRet_Plotly, x = ~index, y = ~CumRet, name = 'Ret',
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('Equity : ', CumRet, '<br /> Date: ', index)) %>% 
      layout(title = "Risk Parity Portfolio Rolling Equity Curve",
             xaxis = list(title = ''),
             yaxis = list(title = 'Equity'))
    
  })
  
  ##### RiskParity_Rolling_DD =====
  output$RiskParity_Rolling_DD <- renderPlotly({
    # Trading_Portfolio <- TradingPortfolio
    
    Trading_Portfolio <- Trading_Portfolio()
    RiskParityDD <- getDrawdowns(Trading_Portfolio$RiskParity_Ret, col_name =  "DrawDowns")
    RiskParityDD_Plotly <- getPloty(RiskParityDD)
    
    plot_ly(RiskParityDD_Plotly, x = ~index, y = ~DrawDowns, name = 'Ret', 
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('DrawDowns : ', DrawDowns, '<br /> Date: ', index)) %>% 
      layout(title = "Risk Parity Portfolio Rolling DrawDowns",
             xaxis = list(title = ''),
             yaxis = list(title = 'DrawDowns'))
    
  })
  
  ##### ........... =====
  ##### CVaR Plotly =====
  ##### CVaR_Rolling_Corr =====
  output$CVaR_Rolling_Corr <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    CVaRCor_Plotly <- getPloty(Trading_Portfolio$CVaR_Cor)
    
    plot_ly(CVaRCor_Plotly, x = ~index, type = 'scatter',
            y = ~Benchmark, name = input$listID, mode = 'lines',hoverinfo = 'text',
            text = ~paste(paste0(input$listID,' Corr : '), Benchmark, '<br /> Date: ', index)) %>%
      add_trace(y = ~MACD, name = 'MACD', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MACD Corr : ', MACD, '<br /> Date: ', index)) %>%
      add_trace(y = ~RSI, name = 'RSI', mode = 'lines',hoverinfo = 'text',
                text = ~paste('RSI Corr : ', RSI, '<br /> Date: ', index)) %>%
      add_trace(y = ~MA, name = 'MA', mode = 'lines',hoverinfo = 'text',
                text = ~paste('MA Corr : ', MA, '<br /> Date: ', index)) %>% 
      add_trace(y = ~BB, name = 'BB', mode = 'lines',hoverinfo = 'text',
                text = ~paste('BB Corr : ', BB, '<br /> Date: ', index)) %>% 
      add_trace(y = ~Dist, name = 'Dist', mode = 'lines',hoverinfo = 'text',
                text = ~paste('Dist Corr : ', Dist, '<br /> Date: ', index)) %>% 
      layout(title = "Strategy Correlation",
             xaxis = list(title = ''),
             yaxis = list(title = 'Correlation'))
    
  })
  
  ##### CVaR_Rolling_Wt =====
  output$CVaR_Rolling_Wt <- renderPlotly({

    Trading_Portfolio <- Trading_Portfolio()
    CVaRWt <- getPloty_RLWT(Trading_Portfolio$CVaR_Wt)
    
    plot_ly(CVaRWt, x = ~Period, y = ~MACD,
            name = 'MACD', type = "bar",hoverinfo = 'text',
            text = ~paste('MACD Wt : ', MACD, '<br /> Date: ', index)) %>%
      add_bars(y = ~RSI, name = 'RSI',hoverinfo = 'text',
               text = ~paste('RSI Wt : ', RSI, '<br /> Date: ', index)) %>%
      add_bars(y = ~MA, name = 'MA',hoverinfo = 'text',
               text = ~paste('MA Wt : ', MA, '<br /> Date: ', index)) %>% 
      add_bars(y = ~BB, name = 'BB',hoverinfo = 'text',
               text = ~paste('BB Wt : ', BB, '<br /> Date: ', index)) %>% 
      add_bars(y = ~Dist, name = 'Dist',hoverinfo = 'text',
               text = ~paste('Dist Wt : ', Dist, '<br /> Date: ', index)) %>% 
      layout(barmode = "stack", title = "CVaR Portfolio Rolling Weight",
             xaxis = list(title = ''),
             yaxis = list(title = 'Weight'))
    
  })
  
  ##### CVaR_Rolling_Ret =====
  output$CVaR_Rolling_Ret <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    CVaRRet_Plotly <- getPloty(Trading_Portfolio$CVaR_Ret)
    
    plot_ly(CVaRRet_Plotly, x = ~index, y = ~Ret, name = 'Ret', 
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('Ret : ', Ret, '<br /> Date: ', index)) %>% 
      layout(title = "CVaR Portfolio Rolling Return",
             xaxis = list(title = ''),
             yaxis = list(title = 'Return'))
    
  })
  
  ##### CVaR_Rolling_CumRet =====
  output$CVaR_Rolling_CumRet <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    CVaRCumRet <- getCumRet_DT(Trading_Portfolio$CVaR_Ret, "CumRet")
    CVaRCumRet_Plotly <- getPloty(CVaRCumRet)
    
    plot_ly(CVaRCumRet_Plotly, x = ~index, y = ~CumRet, name = 'Ret',
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('Equity : ', CumRet, '<br /> Date: ', index)) %>% 
      layout(title = "CVaR Portfolio Rolling Equity Curve",
             xaxis = list(title = ''),
             yaxis = list(title = 'Equity'))
    
  })
  
  ##### CVaR_Rolling_DD =====
  output$CVaR_Rolling_DD <- renderPlotly({
    
    Trading_Portfolio <- Trading_Portfolio()
    CVaRDD <- getDrawdowns(Trading_Portfolio$CVaR_Ret, col_name =  "DrawDowns")
    CVaRDD_Plotly <- getPloty(CVaRDD)
    
    plot_ly(CVaRDD_Plotly, x = ~index, y = ~DrawDowns, name = 'Ret', 
            type = 'scatter', mode = 'lines',hoverinfo = 'text',
            text = ~paste('DrawDowns : ', DrawDowns, '<br /> Date: ', index)) %>% 
      layout(title = "CVaR Portfolio Rolling DrawDowns",
             xaxis = list(title = ''),
             yaxis = list(title = 'DrawDowns'))
    
  })
}) 


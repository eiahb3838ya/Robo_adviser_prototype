
library(DT)
library(tidyverse)
library(xts)
library(base)
library(gplots)
library(cluster)
library(quantmod)
library(PerformanceAnalytics)
library(dplyr)
library(purrr)
library(tibble)
library("SIT")
# df <- get(getSymbols(tickers_tw))
# tickers_tw = c("^TWII","1101.TW","1102.TW","1216.TW","1301.TW","1303.TW","1326.TW","1402.TW","2002.TW","2105.TW","2227.TW","2301.TW","2303.TW","2308.TW","2317.TW","2327.TW","2330.TW","2352.TW","2354.TW","2357.TW","2382.TW","2395.TW","2408.TW","2409.TW","2412.TW","2454.TW","2474.TW","2492.TW","2609.TW","2610.TW","2801.TW","2823.TW","2880.TW","2881.TW","2882.TW","2883.TW","2884.TW","2885.TW","2886.TW","2887.TW","2890.TW","2891.TW","2892.TW","2912.TW","3008.TW","3045.TW","3481.TW","3711.TW","4904.TW","4938.TW","5880.TW","6505.TW","9904.TW")
# tickers_tw <- sort(tickers_tw)
# globalenv()
# saveRDS(globalenv(), "global.rds")
# data_TW <- lapply(tickers_tw[-1], function(idx){
#   # getSymbols(idx, src = 'yahoo', from = "2000-01-01",auto.assign = F)
#   get(getSymbols(idx, src = 'yahoo', from = "2000-01-01"))
# })

tickers_DOJ30 <- c("^DJI","AAPL","AXP","BA","CAT","CSCO","CVX","DD","DIS","GE","GS","HD","IBM","INTC","JNJ","JPM","KO","MCD","MMM","MRK","MSFT","NKE","PFE","PG","TRV","UNH","UTX","V","VZ","WMT","XOM")
tickers_DOJ30 <- sort(tickers_DOJ30)

tickers_SP500 <- c("^GSPC","MMM","ABT","ABBV","ABMD","ACN","ATVI","ADBE","AMD","AAP","AES","AMG","AFL","A","APD","AKAM","ALK","ALB","ARE","ALXN","ALGN","ALLE","AGN","ADS","LNT","ALL","GOOGL","GOOG","MO","AMZN","AEE","AAL","AEP","AXP","AIG","AMT","AWK","AMP","ABC","AME","AMGN","APH","APC","ADI","ANSS","ANTM","AON","AOS","APA","AIV","AAPL","AMAT","APTV","ADM","ARNC","ANET","AJG","AIZ","T","ADSK","ADP","AZO","AVB","AVY","BHGE","BLL","BAC","BK","BAX","BBT","BDX","BBY","BIIB","BLK","HRB","BA","BKNG","BWA","BXP","BSX","BHF","BMY","AVGO","BR","CHRW","COG","CDNS","CPB","COF","CAH","KMX","CCL","CAT","CBOE","CBRE","CBS","CELG","CNC","CNP","CTL","CERN","CF","SCHW","CHTR","CVX","CMG","CB","CHD","CI","XEC","CINF","CTAS","CSCO","C","CFG","CTXS","CLX","CME","CMS","KO","CTSH","CL","CMCSA","CMA","CAG","CXO","COP","ED","STZ","COO","CPRT","GLW","COST","COTY","CCI","CSX","CMI","CVS","DHI","DHR","DRI","DVA","DE","DAL","XRAY","DVN","DLR","DFS","DISCA","DISCK","DISH","DG","DLTR","D","DOV","DWDP","DTE","DRE","DUK","DXC","ETFC","EMN","ETN","EBAY","ECL","EIX","EW","EA","EMR","ETR","EOG","EQT","EFX","EQIX","EQR","ESS","EL","ES","RE","EXC","EXPE","EXPD","EXR","XOM","FFIV","FB","FAST","FRT","FDX","FIS","FITB","FE","FISV","FLT","FLIR","FLS","FLR","FMC","FL","F","FTNT","FTV","FBHS","BEN","FCX","GPS","GRMN","IT","GD","GE","GIS","GM","GPC","GILD","GPN","GS","GT","GWW","HAL","HBI","HOG","HRS","HIG","HAS","HCA","HCP","HP","HSIC","HSY","HES","HPE","HLT","HFC","HOLX","HD","HON","HRL","HST","HPQ","HUM","HBAN","HII","IDXX","INFO","ITW","ILMN","IR","INTC","ICE","IBM","INCY","IP","IPG","IFF","INTU","ISRG","IVZ","IPGP","IQV","IRM","JEC","JBHT","SJM","JNJ","JCI","JPM","JNPR","KSU","K","KEY","KMB","KIM","KMI","KLAC","KSS","KHC","KR","LB","LLL","LH","LRCX","LEG","LEN","LLY","LNC","LKQ","LMT","L","LOW","LYB","MTB","MAC","M","MRO","MPC","MAR","MMC","MLM","MAS","MA","MAT","MKC","MCD","MCK","MDT","MRK","MET","MTD","MGM","MCHP","MU","MSFT","MAA","MHK","TAP","MDLZ","MNST","MCO","MS","MOS","MSI","MSCI","MYL","NDAQ","NOV","NKTR","NTAP","NFLX","NWL","NEM","NWSA","NWS","NEE","NLSN","NKE","NI","NBL","JWN","NSC","NTRS","NOC","NCLH","NRG","NUE","NVDA","ORLY","OXY","OMC","OKE","ORCL","PCAR","PKG","PH","PAYX","PYPL","PNR","PBCT","PEP","PKI","PRGO","PFE","PCG","PM","PSX","PNW","PXD","PNC","RL","PPL","PFG","PG","PGR","PLD","PRU","PEG","PSA","PHM","PVH","QRVO","PWR","QCOM","DGX","RJF","RTN","O","RHT","REG","REGN","RF","RSG","RMD","RHI","ROK","ROL","ROP","ROST","RCL","CRM","SBAC","SLB","STX","SEE","SRE","SHW","SPG","SWKS","SLG","SNA","SO","LUV","SPGI","SWK","SBUX","STT","SRCL","SYK","STI","SIVB","SYMC","SYF","SNPS","SYY","TROW","TTWO","TPR","TGT","TEL","FTI","TXN","TXT","TMO","TIF","TWTR","TJX","TMK","TSS","TSCO","TDG","TRV","TRIP","FOXA","FOX","TSN","UDR","ULTA","USB","UAA","UA","UNP","UAL","UNH","UPS","URI","UTX","UHS","UNM","VFC","VLO","VAR","VTR","VRSN","VRSK","VZ","VRTX","VIAB","V","VNO","VMC","WMT","WBA","DIS","WM","WAT","WEC","WCG","WFC","WELL","WDC","WU","WRK","WY","WHR","WMB","WLTW","WYNN","XEL","XRX","XLNX","XYL","YUM","ZBH","ZION","ZTS")
# "AET","CA","ESRX","KORS","NFX","PX","COL","SCG",
tickers_SP500 <- sort(tickers_SP500)

tickers_ETFS = c("^GSPC","SPY","DIA","QQQ","IWM","EFA","EEM","EWJ","IEV","TIP","SHV","SHY","IEF","TLT","AGG","LQD","IYR","RWX","IXC","GLD","SLV","GSG","DBV")
tickers_ETFS <- sort(tickers_ETFS)

tickers_NK225 = c("^N225","1332.T","1333.T","1605.T","1721.T","1801.T","1802.T","1803.T","1808.T","1812.T","1925.T","1928.T","1963.T","2002.T","2269.T","2282.T","2432.T","2501.T","2502.T","2503.T","2531.T","2768.T","2801.T","2802.T","2871.T","2914.T","3086.T","3099.T","3101.T","3103.T","3105.T","3289.T","3382.T","3401.T","3402.T","3405.T","3407.T","3436.T","3861.T","3863.T","4004.T","4005.T","4021.T","4042.T","4043.T","4061.T","4063.T","4151.T","4183.T","4188.T","4208.T","4272.T","4324.T","4452.T","4502.T","4503.T","4506.T","4507.T","4519.T","4523.T","4543.T","4568.T","4578.T","4631.T","4689.T","4704.T","4751.T","4755.T","4901.T","4902.T","4911.T","5020.T","5101.T","5108.T","5201.T","5202.T","5214.T","5232.T","5233.T","5301.T","5332.T","5333.T","5401.T","5406.T","5411.T","5541.T","5631.T","5703.T","5706.T","5707.T","5711.T","5713.T","5714.T","5801.T","5802.T","5803.T","5901.T","6098.T","6103.T","6113.T","6178.T","6301.T","6302.T","6305.T","6326.T","6361.T","6366.T","6367.T","6471.T","6472.T","6473.T","6479.T","6501.T","6503.T","6504.T","6506.T","6674.T","6701.T","6702.T","6703.T","6724.T","6752.T","6758.T","6762.T","6770.T","6841.T","6857.T","6902.T","6952.T","6954.T","6971.T","6976.T","6988.T","7003.T","7004.T","7011.T","7012.T","7013.T","7186.T","7201.T","7202.T","7203.T","7205.T","7211.T","7261.T","7267.T","7269.T","7270.T","7272.T","7731.T","7733.T","7735.T","7751.T","7752.T","7762.T","7911.T","7912.T","7951.T","8001.T","8002.T","8015.T","8028.T","8031.T","8035.T","8053.T","8058.T","8233.T","8252.T","8253.T","8267.T","8303.T","8304.T","8306.T","8308.T","8309.T","8316.T","8331.T","8354.T","8355.T","8411.T","8601.T","8604.T","8628.T","8630.T","8725.T","8729.T","8750.T","8766.T","8795.T","8801.T","8802.T","8804.T","8830.T","9001.T","9005.T","9007.T","9008.T","9009.T","9020.T","9021.T","9022.T","9062.T","9064.T","9101.T","9104.T","9107.T","9202.T","9301.T","9412.T","9432.T","9433.T","9437.T","9501.T","9502.T","9503.T","9531.T","9532.T","9602.T","9613.T","9681.T","9735.T","9766.T","9983.T","9984.T")
# "5002.T","6773.T",
tickers_NK225 <- sort(tickers_NK225)

###### data_TW =====
data_TW <- lapply(tickers_tw[-1], function(idx){
  getSymbols(idx, src = 'yahoo', from = "2000-01-01",auto.assign = F)
})
names(data_TW) <- tickers_tw[-1]
saveRDS(data_TW,file = "D:/Azar/Data/Dt_TW_Azar_20190603.RDS")


##### data_DOJ30 =====
data_DOJ30 <- lapply(tickers_DOJ30[-1], function(idx){
  # idx <- "AXP"
  getSymbols(idx, src = 'yahoo', from = "2000-01-01",auto.assign = F)
})
names(data_DOJ30) <- tickers_DOJ30[-1]
saveRDS(data_DOJ30,file = "D:/Azar/Data/Dt_DOJ30_Azar_20190603.RDS")

##### data_SP500 =====
data_SP500 <- lapply(tickers_SP500[-1], function(idx){
  # idx <- "AXP"
  getSymbols(idx, src = 'yahoo', from = "2000-01-01",auto.assign = F)
})
names(data_SP500) <- tickers_SP500[-1]
saveRDS(data_SP500,file = "D:/Azar/Data/Dt_SP500_Azar_20190603.RDS")

##### data_ETFS =====
data_ETFS <- lapply(tickers_ETFS[-1], function(idx){
  # idx <- "AXP"
  getSymbols(idx, src = 'yahoo', from = "2000-01-01",auto.assign = F)
})
names(data_ETFS) <- tickers_ETFS[-1]
saveRDS(data_ETFS,file = "D:/Azar/Data/Dt_ETFS_Azar_20190603.RDS")

##### data_NK225 =====
data_NK225 <- lapply(tickers_NK225[-1], function(idx){
  # idx <- "AXP"
  getSymbols(idx, src = 'yahoo', from = "2000-01-01",auto.assign = F)
})
names(data_NK225) <- tickers_NK225[-1]
saveRDS(data_NK225,file = "D:/Azar/Data/Dt_ENK225_Azar_20190603.RDS")


data_TW <- readRDS(file = "D:/Azar/Data/Dt_TW_Azar_20190603.RDS")
data_DOJ30 <- readRDS(file = "D:/Azar/Data/Dt_DOJ30_Azar_20190603.RDS")
data_SP500 <- readRDS(file = "D:/Azar/Data/Dt_SP500_Azar_20190603.RDS")
data_ETFS <- readRDS(file = "D:/Azar/Data/Dt_ETFS_Azar_20190603.RDS")
data_NK225 <- readRDS(file = "D:/Azar/Data/Dt_ENK225_Azar_20190603.RDS")
##### Others =====
# tickers_tw = spl('^TWII,1101.TW,1102.TW,1216.TW,1301.TW,1303.TW,1326.TW,1402.TW,2002.TW,2105.TW,2227.TW,2301.TW,2303.TW,2308.TW,2317.TW,2327.TW,2330.TW,2352.TW,2354.TW,2357.TW,2382.TW,2395.TW,2408.TW,2409.TW,2412.TW,2454.TW,2474.TW,2492.TW,2609.TW,2610.TW,2801.TW,2823.TW,2880.TW,2881.TW,2882.TW,2883.TW,2884.TW,2885.TW,2886.TW,2887.TW,2890.TW,2891.TW,2892.TW,2912.TW,3008.TW,3045.TW,3481.TW,3711.TW,4904.TW,4938.TW,5880.TW,6505.TW,9904.TW')
# tickers_DOJ30 = spl('^DJI,AAPL,AXP,BA,CAT,CSCO,CVX,DIS,DWDP,GS,HD,IBM,INTC,JNJ,JPM,KO,MCD,MMM,MRK,MSFT,NKE,PFE,PG,TRV,UNH,UTX,V,VZ,WBA,WMT,XOM')
# tickers_DOJ30 = spl(c("^DJI","AAPL","AXP","BA","CAT","CSCO","CVX","DIS","DWDP","GS","HD","IBM","INTC","JNJ","JPM","KO","MCD","MMM","MRK","MSFT","NKE","PFE","PG","TRV","UNH","UTX","V","VZ","WBA","WMT","XOM"))
# tickers_SP500 = spl(c("^GSPC","MMM","ABT","ABBV","ABMD","ACN","ATVI","ADBE","AMD","AAP","AES","AET","AMG","AFL","A","APD","AKAM","ALK","ALB","ARE","ALXN","ALGN","ALLE","AGN","ADS","LNT","ALL","GOOGL","GOOG","MO","AMZN","AEE","AAL","AEP","AXP","AIG","AMT","AWK","AMP","ABC","AME","AMGN","APH","APC","ADI","ANSS","ANTM","AON","AOS","APA","AIV","AAPL","AMAT","APTV","ADM","ARNC","ANET","AJG","AIZ","T","ADSK","ADP","AZO","AVB","AVY","BHGE","BLL","BAC","BK","BAX","BBT","BDX","BBY","BIIB","BLK","HRB","BA","BKNG","BWA","BXP","BSX","BHF","BMY","AVGO","BR","CHRW","CA","COG","CDNS","CPB","COF","CAH","KMX","CCL","CAT","CBOE","CBRE","CBS","CELG","CNC","CNP","CTL","CERN","CF","SCHW","CHTR","CVX","CMG","CB","CHD","CI","XEC","CINF","CTAS","CSCO","C","CFG","CTXS","CLX","CME","CMS","KO","CTSH","CL","CMCSA","CMA","CAG","CXO","COP","ED","STZ","COO","CPRT","GLW","COST","COTY","CCI","CSX","CMI","CVS","DHI","DHR","DRI","DVA","DE","DAL","XRAY","DVN","DLR","DFS","DISCA","DISCK","DISH","DG","DLTR","D","DOV","DWDP","DTE","DRE","DUK","DXC","ETFC","EMN","ETN","EBAY","ECL","EIX","EW","EA","EMR","ETR","EOG","EQT","EFX","EQIX","EQR","ESS","EL","ES","RE","EXC","EXPE","EXPD","ESRX","EXR","XOM","FFIV","FB","FAST","FRT","FDX","FIS","FITB","FE","FISV","FLT","FLIR","FLS","FLR","FMC","FL","F","FTNT","FTV","FBHS","BEN","FCX","GPS","GRMN","IT","GD","GE","GIS","GM","GPC","GILD","GPN","GS","GT","GWW","HAL","HBI","HOG","HRS","HIG","HAS","HCA","HCP","HP","HSIC","HSY","HES","HPE","HLT","HFC","HOLX","HD","HON","HRL","HST","HPQ","HUM","HBAN","HII","IDXX","INFO","ITW","ILMN","IR","INTC","ICE","IBM","INCY","IP","IPG","IFF","INTU","ISRG","IVZ","IPGP","IQV","IRM","JEC","JBHT","SJM","JNJ","JCI","JPM","JNPR","KSU","K","KEY","KMB","KIM","KMI","KLAC","KSS","KHC","KR","LB","LLL","LH","LRCX","LEG","LEN","LLY","LNC","LKQ","LMT","L","LOW","LYB","MTB","MAC","M","MRO","MPC","MAR","MMC","MLM","MAS","MA","MAT","MKC","MCD","MCK","MDT","MRK","MET","MTD","MGM","KORS","MCHP","MU","MSFT","MAA","MHK","TAP","MDLZ","MNST","MCO","MS","MOS","MSI","MSCI","MYL","NDAQ","NOV","NKTR","NTAP","NFLX","NWL","NFX","NEM","NWSA","NWS","NEE","NLSN","NKE","NI","NBL","JWN","NSC","NTRS","NOC","NCLH","NRG","NUE","NVDA","ORLY","OXY","OMC","OKE","ORCL","PCAR","PKG","PH","PAYX","PYPL","PNR","PBCT","PEP","PKI","PRGO","PFE","PCG","PM","PSX","PNW","PXD","PNC","RL","PPL","PX","PFG","PG","PGR","PLD","PRU","PEG","PSA","PHM","PVH","QRVO","PWR","QCOM","DGX","RJF","RTN","O","RHT","REG","REGN","RF","RSG","RMD","RHI","ROK","COL","ROL","ROP","ROST","RCL","CRM","SBAC","SCG","SLB","STX","SEE","SRE","SHW","SPG","SWKS","SLG","SNA","SO","LUV","SPGI","SWK","SBUX","STT","SRCL","SYK","STI","SIVB","SYMC","SYF","SNPS","SYY","TROW","TTWO","TPR","TGT","TEL","FTI","TXN","TXT","TMO","TIF","TWTR","TJX","TMK","TSS","TSCO","TDG","TRV","TRIP","FOXA","FOX","TSN","UDR","ULTA","USB","UAA","UA","UNP","UAL","UNH","UPS","URI","UTX","UHS","UNM","VFC","VLO","VAR","VTR","VRSN","VRSK","VZ","VRTX","VIAB","V","VNO","VMC","WMT","WBA","DIS","WM","WAT","WEC","WCG","WFC","WELL","WDC","WU","WRK","WY","WHR","WMB","WLTW","WYNN","XEL","XRX","XLNX","XYL","YUM","ZBH","ZION","ZTS"))
# tickers_ETFS = spl(c("^GSPC","SPY","DIA","QQQ","IWM","EFA","EEM","EWJ","IEV","TIP","SHV","SHY","IEF","TLT","AGG","LQD","IYR","RWX","IXC","GLD","SLV","GSG","DBV"))
# tickers_NK225 = spl(c('^N225,1332.T,1333.T,1605.T,1721.T,1801.T,1802.T,1803.T,1808.T,1812.T,1925.T,1928.T,1963.T,2002.T,2269.T,2282.T,2432.T,2501.T,2502.T,2503.T,2531.T,2768.T,2801.T,2802.T,2871.T,2914.T,3086.T,3099.T,3101.T,3103.T,3105.T,3289.T,3382.T,3401.T,3402.T,3405.T,3407.T,3436.T,3861.T,3863.T,4004.T,4005.T,4021.T,4042.T,4043.T,4061.T,4063.T,4151.T,4183.T,4188.T,4208.T,4272.T,4324.T,4452.T,4502.T,4503.T,4506.T,4507.T,4519.T,4523.T,4543.T,4568.T,4578.T,4631.T,4689.T,4704.T,4751.T,4755.T,4901.T,4902.T,4911.T,5002.T,5020.T,5101.T,5108.T,5201.T,5202.T,5214.T,5232.T,5233.T,5301.T,5332.T,5333.T,5401.T,5406.T,5411.T,5541.T,5631.T,5703.T,5706.T,5707.T,5711.T,5713.T,5714.T,5801.T,5802.T,5803.T,5901.T,6098.T,6103.T,6113.T,6178.T,6301.T,6302.T,6305.T,6326.T,6361.T,6366.T,6367.T,6471.T,6472.T,6473.T,6479.T,6501.T,6503.T,6504.T,6506.T,6674.T,6701.T,6702.T,6703.T,6724.T,6752.T,6758.T,6762.T,6770.T,6773.T,6841.T,6857.T,6902.T,6952.T,6954.T,6971.T,6976.T,6988.T,7003.T,7004.T,7011.T,7012.T,7013.T,7186.T,7201.T,7202.T,7203.T,7205.T,7211.T,7261.T,7267.T,7269.T,7270.T,7272.T,7731.T,7733.T,7735.T,7751.T,7752.T,7762.T,7911.T,7912.T,7951.T,8001.T,8002.T,8015.T,8028.T,8031.T,8035.T,8053.T,8058.T,8233.T,8252.T,8253.T,8267.T,8303.T,8304.T,8306.T,8308.T,8309.T,8316.T,8331.T,8354.T,8355.T,8411.T,8601.T,8604.T,8628.T,8630.T,8725.T,8729.T,8750.T,8766.T,8795.T,8801.T,8802.T,8804.T,8830.T,9001.T,9005.T,9007.T,9008.T,9009.T,9020.T,9021.T,9022.T,9062.T,9064.T,9101.T,9104.T,9107.T,9202.T,9301.T,9412.T,9432.T,9433.T,9437.T,9501.T,9502.T,9503.T,9531.T,9532.T,9602.T,9613.T,9681.T,9735.T,9766.T,9983.T,9984.T'))

# 
# dt_tw <- new.env()
# getSymbols(tickers_tw[-1], src = 'yahoo', from = "2000-01-01", to = "2019-05-31", env = dt_tw, auto.assign = T)
# saveRDS(dt_tw,file = "D:/Azar/Data/Dt_TW_Azar_20190603.RDS")
# dt_tw1 <- readRDS(file = "D:/Azar/Data/Dt_TW_Azar_20190603.RDS")
# 
# data_DOJ30 <- new.env()
# data_DOJ30 <- getSymbols(tickers_DOJ30[-1], src = 'yahoo', from = "2000-01-01", to = "2019-05-31", env = data_DOJ30, auto.assign = T)
# saveRDS(data_DOJ30,file = "D:/Azar/Data/Dt_DOJ30_Azar_20190603.RDS")
# data_DOJ301 <- readRDS(file = "D:/Azar/Data/Dt_DOJ30_Azar_20190603.RDS")
# 
# data_SP500 <- new.env()
# data_SP500 <- getSymbols(tickers_SP500[-1], src = 'yahoo', from = "2000-01-01", to = "2019-05-31", env = data_SP500, auto.assign = T)
# saveRDS(data_SP500,file = "D:/Azar/Data/Dt_SP500_Azar_20190603.RDS")
# data_SP5001 <- readRDS(file = "D:/Azar/Data/Dt_SP500_Azar_20190603.RDS")
# 
# data_ETFS <- new.env()
# data_ETFS <- getSymbols(tickers_ETFS[-1], src = 'yahoo', from = "2000-01-01", to = "2019-05-31", env = data_ETFS, auto.assign = T)
# saveRDS(data_ETFS,file = "D:/Azar/Data/Dt_ETFS_Azar_20190603.RDS")
# data_DOJ301 <- readRDS(file = "D:/Azar/Data/Dt_ETFS_Azar_20190603.RDS")
# 
# data_NK225 <- new.env()
# data_NK225 <- getSymbols(tickers_NK225[-1], src = 'yahoo', from = "2000-01-01", to = "2019-05-31", env = data_NK225, auto.assign = T)
# saveRDS(data_NK225,file = "D:/Azar/Data/Dt_NK225_Azar_20190603.RDS")
# data_NK2251 <- readRDS(file = "D:/Azar/Data/Dt_NK225_Azar_20190603.RDS")
# 


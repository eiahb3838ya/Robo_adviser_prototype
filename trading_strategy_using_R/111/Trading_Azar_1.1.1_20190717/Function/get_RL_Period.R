## Azar Lin
## 20190714
## OOP
## XQC_Trading_Fun2.R

##### selectData =====
get_RL_Period <- function(RL_Data, periodn = "Month"){
  
  ## XQC_Markowitz
  # periodn = "Day"
  # periodn = "Week"
  # periodn = "Month"
  # periodn = "Quarter"
  # periodn = "Year"
  # RL_Data <- Portfolio_All$Equity_All
  RL_Data$index <- as.Date(RL_Data$index)
  RL_Data <- as.xts.data.table(RL_Data)
  Allday <- time(RL_Data)
  
  switch(periodn,
         Day = {
           nperiod <- Allday[endpoints(Allday, on = "days")]
           Startn <- nperiod[1:(length(nperiod) - 251)]
           Endn <- nperiod[251:(length(nperiod) - 1)] 
           Next_n <- nperiod[252:length(nperiod)]
           
         },
         Week = {
           nperiod <- Allday[endpoints(Allday, on = "weeks")]
           Startn <- nperiod[1:(length(nperiod) - 53)] 
           Endn <- nperiod[53:(length(nperiod) - 1)] 
           Next_n <- nperiod[54:length(nperiod)]
         },
         Month = {
           nperiod <- Allday[endpoints(Allday, on = "months")]
           Startn <- nperiod[1:(length(nperiod) - 13)]
           Endn <- nperiod[13:(length(nperiod) - 1)] 
           Next_n <- nperiod[14:length(nperiod)]
         },
         Quarter = {
           nperiod <- Allday[endpoints(Allday, on = "quarters")]
           Startn <- nperiod[1:(length(nperiod) - 5)] 
           Endn <- nperiod[5:(length(nperiod) - 1)] 
           Next_n <- nperiod[6:length(nperiod)]
         },
         Year = {
           nperiod <- Allday[endpoints(Allday, on = "years")]
           Startn <- as.Date(c(Allday[1],nperiod[1:(length(nperiod) - 2)]))
           Endn <- nperiod[1:(length(nperiod) - 1)] 
           Next_n <- nperiod[2:length(nperiod)]
         })
  
  return(list(Startn = Startn, Endn = Endn, Next_n = Next_n))
}



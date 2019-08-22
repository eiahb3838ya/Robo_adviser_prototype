## R Connect SQL Server Test
## Azar
## 20190723
## From Trading_Azar_1.0.8_20190710.R

library(RODBC)
#### SQL Server =====
conn <- odbcDriverConnect(
  'Driver={SQL Server};
  Server=219.91.66.201;
  Database=MSBT;
  Uid=sa;
  Pwd=q1q1Q!Q!;'
)

DataFrame <- sqlQuery(
  conn,
  paste(
    "SELECT STOCK_CODE, DATE_PRICE, OPEN_PRICE, HIGH_PRICE, LOW_PRICE, CLOSE_PRICE, VOLUME",
    "FROM MSBT.dbo.STOT102 M",
    "where M.STOCK_TYPE = 'LIST'
         AND LEN(M.STOCK_CODE) = 4
         AND M.DATE_PRICE >= '20070101'
         AND M.DATE_PRICE <= '20190630'
         AND M.KLINE_PERIOD = 'day'
         and M.STOCK_CODE in (0050, 1101, 1102, 1104, 1210, 1215, 1216, 1217, 1227, 1229,
                                          1231, 1233, 1301, 1303, 1304, 1305, 1312, 1314, 1319, 1326,
                                          1402, 1409, 1434, 1444, 1452, 1455, 1460, 1463, 1504, 1512,
                                          1522, 1524, 1605, 1609, 1710, 1717, 1718, 1722, 1733, 1802,
                                          1907, 1909, 2002, 2015, 2027, 2104, 2105, 2106, 2201, 2204,
                                          2207, 2308, 2313, 2324, 2330, 2344, 2345, 2347, 2353, 2354,
                                          2355, 2356, 2360, 2376, 2377, 2382, 2385, 2395, 2405, 2409,
                                          2441, 2448, 2449, 2451, 2454, 2474, 2481, 2489, 2498, 2515,
                                          2603, 2801, 2823, 2834, 2880, 2881, 2882, 2883, 2884, 2885,
                                          2886, 2888, 2889, 2890, 2891, 2892, 2903, 2912, 3019, 3030,
                                          3042, 3044, 3189, 3231, 3406, 3481, 5471, 6115, 6176, 6189,
                                          6202, 6216, 6239, 6269, 6285, 6505, 9904, 9907, 9917, 9930,
                                          9933, 9940)")
  )
odbcClose(conn)

## DataTable
# colnames(DataTable) <- c("Stock_Code", "Date", "Open", "High", "Low", "Close","Vol")
# DataTable$Date <- as.Date(as.character(DataTable$Date),format = "%Y%m%d")
# DataTable$Stock_Code <- as.character(DataTable$Stock_Code)
# DataTable <- as.data.table(DataTable)
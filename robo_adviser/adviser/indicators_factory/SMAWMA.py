import pandas as pd
import numpy as np
import datetime as dt
import talib
from .data_generator import roical,winfactor




def main(df, count, acmroi, winrate, winvar):
    dayToCount=5
    close = np.array(df['Close'],dtype=float)
    SMA=talib.SMA(close,dayToCount)
    WMA=talib.WMA(close,dayToCount)
    df['SMA']=SMA
    df['WMA']=WMA
    df["change"]=WMA/SMA
    print(df)
    # set default

    df['XBuy'] = False
    df['YBuy'] = np.zeros(len(df['XBuy']), dtype=float)
    df['XSell'] = False
    df['YSell'] = np.zeros(len(df['XSell']), dtype=float)

    ROW = len(df)
    flag=False
    # change = 0
    buyprice= 0
    sellprice = 0
    win=0
    loss=0
    winrate=0

    roi=0
    for i in range(ROW):
        this_change = df['change'][i]
        if (not flag) and this_change >= 1.01:
            print("BUYY", ",change*100: ", this_change, ",close[i]: ", close[i])
            df.XBuy[df.index[i]] = True
            df.YBuy[i] = close[i]
            buyprice = close[i]
            flag = True
        if flag and this_change < 0.99:
            print("SELL", ",change*100: ", this_change, ",close[i]: ", close[i])
            df.XSell[df.index[i]] = True
            df.YSell[i] = close[i]
            count += 1
            flag = False
            # calculate roi
            roi, winrate = roical(buyprice, sellprice, winrate)
            acmroi += roi
            loss, win = winfactor(buyprice, sellprice, loss, win)

        if flag and i == (ROW - 1):
            print("SELL", ",change*100: ", this_change, ",close[i]: ", close[i])
            df.XSell[df.index[i]] = True
            df.YSell[i] = close[i]
            count += 1
            flag = False
            # calculate roi
            roi, winrate = roical(buyprice, sellprice, winrate)
            acmroi += roi
    if loss == 0 and win == 0:
        winvar = 0
    elif loss == win:
        loss = win
        winvar = win / loss
    else:
        winvar = win / loss
    return(df,count,acmroi,winrate,winvar)









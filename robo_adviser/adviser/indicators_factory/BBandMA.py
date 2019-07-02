import numpy as np
import datetime as dt
import talib
from talib import MA_Type
from .data_generator import roical,winfactor


def main(df):
    df['BBXBuy'] = False
    df['BBYBuy'] = np.zeros(len(df['BBXBuy']), dtype=float)
    df['BBXSell'] = False
    df['BBYSell'] = np.zeros(len(df['BBXBuy']), dtype=float)
    close = np.array(df['Close'], dtype=float)
    upper , middle, lower = talib.BBANDS(close,timeperiod=20, nbdevup=0.0001, nbdevdn=0.0001, matype=MA_Type.T3)
    df['BBupper'] = upper
    df['BBlower'] = lower
    vol = df['Volume'].values.astype("float64")
    df['volMA'] = talib.SMA(vol, timeperiod=20)
    flag=False
    win=0
    loss=0
    roi=0
    acmroi=0
    count=0
    winnum = 0
    buyprice=0
    sellprice=0
    for i in range(len(df)):
        if not flag and df['High'][i] > df['BBupper'][i] and df['Volume'][i]> (df['volMA'][i]*2):
            # print("BUYY", ",change*100: ", this_change, ",close[i]: ", close[i])
            df.BBXBuy[df.index[i]] = True
            df.BBYBuy[i] = close[i]
            buyprice = close[i]
            flag = True
        elif flag and df['Low'][i] > df['BBlower'][i] and df['Volume'][i]> (df['volMA'][i]*2):
            # print("SELL", ",change*100: ", this_change, ",close[i]: ", close[i])
            df.BBXSell[df.index[i]] = True
            df.BBYSell[i] = close[i]
            count += 1
            flag = False
            # calculate roi
            roi, winnum = roical(buyprice, sellprice, winnum)
            acmroi += roi
    if win == 0 and loss == 0:
        winvar=0
    if loss==0:
        loss=1
        winvar = win/loss
    else:
        winvar = win/loss
    if count == 0:
        count = 0.001
    return(df, count, acmroi, winnum, winvar)



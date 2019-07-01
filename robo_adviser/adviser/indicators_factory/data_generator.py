import numpy as np
import pandas as pd
from pandas_datareader import data as web
import datetime as dt
import yfinance as yf

yf.pdr_override()

def get_history_data(target,startdate= dt.datetime(2015, 1, 1),enddate= dt.datetime(2020, 1, 1)):
    result_df = web.get_data_yahoo([target], startdate, enddate)
    return(result_df)
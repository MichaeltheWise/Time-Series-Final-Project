#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 12 14:12:53 2018

@author: MichaelLin
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf
import statsmodels.api as sm
from statsmodels.tsa import seasonal
from statsmodels.tsa.stattools import adfuller
import seaborn as sns

from datetime import datetdef stationary_test(timeseries):
    # Perform Dickey-Fuller test
    summary=adfuller(timeseries)
    print('Results of Augmented Dickey-Fuller Test:')
    print('Augmented Dickey-Fuller Statistic:%4.f'%summary[0])
    print('p-value:%f'%summary[1])
    print('Crititcal Values:')
    for key,value in summary[4].items():
        print('\t%s:%.4f' % (key, value))ime

def stationary_test(timeseries):
    # Perform Dickey-Fuller test
    summary=adfuller(timeseries)
    print('Results of Augmented Dickey-Fuller Test:')
    print('Augmented Dickey-Fuller Statistic:%4.f'%summary[0])
    print('p-value:%f'%summary[1])
    print('Crititcal Values:')
    for key,value in summary[4].items():
        print('\t%s:%.4f' % (key, value))

## Detrend with time
data = pd.read_excel("inflation.xlsx")
data.columns = ['Inflation_Data']
data['Time_t'] = data.index
data = data.sort_values('Time_t')
data['Time'] = pd.factorize(data['Time_t'])[0] + 1
mapping = dict(zip(data['Time'], data['Time_t'].dt.date))
fig = plt.figure(figsize = (10,5))
sns.regplot(x = 'Time',y = 'Inflation_Data',data = data)
ax = plt.gca()
labels = pd.Series(ax.get_xticks()).map(mapping).fillna('')
ax.set_xticklabels(labels)

fig1 = plt.figure(figsize = (10,5))
sns.residplot(x = 'Time', y = 'Inflation_Data', data = data, lowess = True)

## Detrend using previous year data
data['Inflation_PY_Data'] = data['Inflation_Data'].shift(1)
data.dropna()
fig2 = plt.figure(figsize = (10,5))
model1 = smf.ols('Inflation_Data ~ Inflation_PY_Data', data = data).fit()
sns.regplot(x = 'Inflation_PY_Data',y = 'Inflation_Data', data = data)

fig3 = plt.figure(figsize = (10,5))
sns.residplot(x = 'Inflation_PY_Data', y = 'Inflation_Data', data = data, lowess = True)



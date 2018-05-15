# Time_Series_Final_Project

This project is for FRE6351 Econometrics and Time Series course. In this project, inflation data (CPI YOY index) is analyzed, using various time series models. 

Python code final_project.py detrends and removes seasonality from the inflation data, then uses Dickey-Fuller test (written by Kuan-Wei Chen) to ensure stationality. The code then outputs an excel for further process from R which has various time series algorithms and models packages built-in. 

R code FRE6351_Final_Project.r extracts the processed data from Excel file, then fits it to four ARMA models: ARMA(1,q), ARMA(p,q), pure MA and pure AR. Manual model selection is done through nested for loop to search for the lowest AIC values (written by Yun-Feng Lee). In each model, various algorithms (Burg, Yule-Walker, etc) are used to estimate the respective coefficients. 

The last portion includes forecasting and Fourier Transform. Forecasting is done using the built-in package forecast. The four selected models mentioned above are forecasted using the default setting which is exponential smoothing; by default, since there is no seasonality, ets forecasts quickly converge to zero. Considering past volatility in inflation data, it is unsatisfactory to have such forecasts. Therefore, original data with trend and seasonality is fitted and forecasted using arima model. 

Fast Fourier Transform function in R is adapted from catatrophic-failure's code in Stack Overflow Forum: Perform Fourier Analysis to Time Series in R. 

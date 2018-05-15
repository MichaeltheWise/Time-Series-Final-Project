## R script for FRE6351 Final Project
## Written by Po-Hsuan (Michael) Lin
## Edited by Yun-Feng Lee
## Date: 05/13/2018
setwd("/Users/MichaelLin/Documents/R")

## Import the processed data from Python
library('openxlsx')
python_data <- read.xlsx("Data_for_R.xlsx")
# plot(data$Detrend_Data)
data <- python_data$Detrend_Data

## Data instantiation
truncated_data <- data[-(1:35)]
train_data <- truncated_data[1:150]
test_data <- truncated_data[151:200]

### MODEL 1: ARMA(1,q) Model ###
compare_model_1 <- matrix(c(1:11),1,11)
for(i in c(1:11)){
  fit_model_1 <- arima(train_data,order = c(1,0,i-1))
  compare_model_1[1,i] <- fit_model_1$aic
}
minimum_model_1 <- min(abs(compare_model_1))
# MODEL 1 yields ARMA(1,2)

# Coefficients of model
library(itsmr)
ML_model_1 <- arima(train_data,order = c(1,0,2))
ML_model_1_phi <- ML_model_1$model$phi
ML_model_1_theta <- ML_model_1$model$theta
ML_model_1_aic <- ML_model_1$aic
ML_model_1_sigma <- ML_model_1$sigma2

HR_model_1 <- hannan(train_data,1,2)
HR_model_1_phi <- HR_model_1$phi
HR_model_1_theta <- HR_model_1$theta
HR_model_1_aicc <- HR_model_1$aicc
HR_model_1_sigma <- HR_model_1$sigma2

IA_model_1 <- ia(train_data,3,17)
IA_model_1_theta <- IA_model_1$theta
IA_model_1_aicc <- IA_model_1$aicc
IA_model_1_sigma <- IA_model_1$sigma2

### MODEL 2: ARMA(1,q) Model ###
# Calculate ACF and PACF
autocorrelation <- acf(train_data,lag.max = 50,plot = TRUE,'correlation')
partial_autocorrelation <- pacf(train_data,lag.max = 50,plot = TRUE)

# Try using the ARMA autofit function
arma_autofit = autofit(train_data,p = 0:5,q = 0:5)
# Yields ARMA(2,5)

# Coefficients of model
opt_model_2_phi <- arma_autofit$phi
opt_model_2_theta <- arma_autofit$theta
opt_model_2_aicc <- arma_autofit$aicc
opt_model_2_sigma <- arma_autofit$sigma2

HR_model_2 <- hannan(train_data,2,5)
HR_model_2_phi <- HR_model_2$phi
HR_model_2_theta <- HR_model_2$theta
HR_model_2_aicc <- HR_model_2$aicc
HR_model_2_sigma <- HR_model_2$sigma2

### MODEL 3: Pure MA Model ###
compare_model_3 <- matrix(c(1:66),6,11)
for(i in c(1:6)){
  for(j in c(1:11)){
    compare_model_3[i,j] <- (arima(train_data, order=c(i-1,0,j-1)))$aic 
  }
}
compare_model_3 <- round(compare_model_3,2)
minimum_model_3 <- min(abs(compare_model_3))
# MODEL 3 Yields ARMA(0,2)

# Coefficients of model
ML_model_3 <- arima(train_data,order = c(0,0,2))
ML_model_3_theta <- ML_model_3$model$theta
ML_model_3_aic <- ML_model_3$aic
ML_model_3_sigma <- ML_model_3$sigma2

IA_model_3 <- ia(train_data,2,17)
IA_model_3_theta <- IA_model_3$theta
IA_model_3_aicc <- IA_model_3$aicc
IA_model_3_sigma <- IA_model_3$sigma2

### MODEL 4: Pure AR Model ###
compare_model_4 <- matrix(c(1:11),1,11)
for(j in c(1:11)){
  fit_model_4 <- arima(train_data,order = c(j-1,0,0))
  compare_model_4[1,j] <- fit_model_4$aic
}
minimum_model_4 <- min(abs(compare_model_4))
# MODEL 4 yields ARMA(6,0)

# Coefficients of model
ML_model_4 <- arima(train_data,order = c(6,0,0))
ML_model_4_phi <- ML_model_4$model$phi
ML_model_4_aic <- ML_model_4$aic
ML_model_4_sigma <- ML_model_4$sigma2

YW_model_4 <- yw(train_data,6)
YW_model_4_phi <- YW_model_4$phi
YW_model_4_aic <- YW_model_4$aicc
YW_model_4_sigma <- YW_model_4$sigma2

B_model_4 <- burg(train_data,6)
B_model_4_phi <- B_model_4$phi
B_model_4_aic <- B_model_4$aicc
B_model_4_sigma <- B_model_4$sigma2

## Data forecasting
library(forecast)

## Model 1: ARMA(1,2)
model_1_data <- train_data
fit <- arima(model_1_data, order = c(1, 0, 2))
forecast_data_1 <- forecast(fit,50)$mean
model_1_data <- append(model_1_data,forecast_data_1)

# Plot the test with forecasts
plot(truncated_data,type = 'l',main = "Test Data versus Forecast Data", col = "red")
par(new = TRUE)
plot(model_1_data,type = 'l',ann = FALSE,axes = FALSE, col = "blue")

## Model 2: ARMA(2,5)
model_2_data <- train_data
fit <- arima(model_2_data, order = c(2, 0, 5))
forecast_data_2 <- forecast(fit,50)$mean
model_2_data <- append(model_2_data,forecast_data_2)

# Plot the test with forecasts
plot(truncated_data,type = 'l',main = "Test Data versus Forecast Data", col = "red")
par(new = TRUE)
plot(model_2_data,type = 'l',ann = FALSE,axes = FALSE, col = "blue")

## Model 3: MA(0,2)
model_3_data <- train_data
fit <- arima(model_3_data, order = c(0, 0, 2))
forecast_data_3 <- forecast(fit,50)$mean
model_3_data <- append(model_3_data,forecast_data_3)

# Plot the test with forecasts
plot(truncated_data,type = 'l',main = "Test Data versus Forecast Data", col = "red")
par(new = TRUE)
plot(model_3_data,type = 'l',ann = FALSE,axes = FALSE, col = "blue")

## Model 4: AR(6,0)
model_4_data <- train_data
fit <- arima(model_4_data, order = c(6, 0, 0))
forecast_data_4 <- forecast(fit,50)$mean
model_4_data <- append(model_4_data,forecast_data_4)

# Plot the test with forecasts
plot(truncated_data,type = 'l',main = "Test Data versus Forecast Data", col = "red")
par(new = TRUE)
plot(model_4_data,type = 'l',ann = FALSE,axes = FALSE, col = "blue")

### Forecasting with seasonality
data_seasonality = python_data$Inflation_Data
fit <- auto.arima(data_seasonality,seasonal = TRUE)
forecast_data_seasonality <- forecast(fit,model = Arima)

# Plot forecasts
plot(forecast_data_seasonality,type = 'l',main = "Forecast Data", col = "red")

### Fast Fourier Transform
nff = function(x = NULL, n = NULL, up = 10L, plot = TRUE, add = FALSE, main = NULL, ...){
  #The direct transformation
  #The first frequency is DC, the rest are duplicated
  dff = fft(x)
  #The time
  t = seq(from = 1, to = length(x))
  #Upsampled time
  nt = seq(from = 1, to = length(x)+1-1/up, by = 1/up)
  #New spectrum
  ndff = array(data = 0, dim = c(length(nt), 1L))
  ndff[1] = dff[1] #Always, it's the DC component
  if(n != 0){
    ndff[2:(n+1)] = dff[2:(n+1)] #The positive frequencies always come first
    #The negative ones are trickier
    ndff[length(ndff):(length(ndff) - n + 1)] = dff[length(x):(length(x) - n + 1)]
  }
  #The inverses
  indff = fft(ndff/235, inverse = TRUE)
  idff = fft(dff/235, inverse = TRUE)
  if(plot){
    if(!add){
      plot(x = t, y = x, pch = 16L, xlab = "Time", ylab = "Measurement",
           main = ifelse(is.null(main), paste(n, "harmonics"), main))
      lines(y = Re(idff), x = t, col = adjustcolor(1L, alpha = 0.5))
    }
    lines(y = Re(indff), x = nt, ...)
  }
  ret = data.frame(time = nt, y = Mod(indff))
  return(ret)
}

res = nff(x = data_seasonality, n = 25L, add = FALSE, up = 100L, col = 2L)
colors = rainbow(18L, alpha = 0.3)
nff(x = data_seasonality, n = 18L, up = 100L, col = colors[1])
for(i in 1:18){
  ad = ifelse(i == 1, FALSE, TRUE)
  nff(x = data_seasonality, n = i, up = 100L, col = colors[i], add = ad, main = "All waves up to 18th harmonic")
}

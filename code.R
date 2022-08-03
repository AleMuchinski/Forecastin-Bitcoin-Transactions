#loading packages
library(ggplot2)
library(dplyr)
library(zoo)
library(xts)
library(tidyverse)
library(tibble)
library(tseries)
library(DescTools)
library(forecast)
library(astsa)
library(LSTS)
library(car)

#library(sarima)
#reading CSV
df <- read.csv('C:/Users/alexa/Danmarks Tekniske Universitet/DTU - Projects - Documents/Time Series Analysis/Assignments/Assignment 3/A3_BitcoinTransactions.csv') 
class(df)
df$Date <- as.Date(df$Date)



#transforming full dataset in TS
df_ts_full <- xts(df$BitcoinTransactions,df$Date)
df_ts_full
#splitting only 2017
data_train <- df[(df$Date >= '2017-01-01' & df$Date < '2021-08-13'),]
data_test <- df[(df$Date >= '2021-08-13'),]

#data train to TS
df_train <- xts(data_train$BitcoinTransactions, data_train$Date)
#test data to TS
df_test <-xts(data_test$BitcoinTransactions, data_test$Date)



#plotting test and train data
ts <- autoplot.zoo(cbind(df_train, df_test), facets = NULL) + xlab('Date') + 
  ylab('Bitcoin Transaction') +
  ggtitle('Bitcoin Transactions with Test and Train Data') + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  scale_color_grey()
ts + theme(legend.position="bottom")



#plotting test data for zooming
plot.zoo(df_test,
         main="Test Data",
         xlab = 'Date',
         ylab = 'Bitcoin Transactions')



#plotting just 2017
ggplot(data=df %>% filter(df$Date >= as.Date("2017-01-01")), aes(x=Date, y=BitcoinTransactions, group=1)) +
  ggtitle('Bitcoin Transactions After 2017') +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line()



#difference the whole dataset
ts_diff <- na.omit(diff(df_ts_full))
#difference for train dataset in TS
ts_train_diff <-na.omit(diff(df_train))



#difference plot for full dataset in TS
plot.zoo(ts_diff, xlab = 'Date', ylab = 'Bitcoin Transactions') +
  title('Bitcoin Transactions with 1 Difference')



#difference plot for dataset from 2017 to 2021
plot.zoo(ts_train_diff, xlab = 'Date', ylab = 'Bitcoin Transactions') +
  title('Bitcoin Transactions with 1 Difference 2017-2021')



#ACF train dataset
acf_train_df_1<- acf(df_train, plot = FALSE)
plot(acf_train_df_1, main = 'ACF for Bitcoin Transactions Without Difference 2017-2021')  
#PACF train dataset
pacf_train_df_1 <- pacf(df_train, plot=FALSE)
plot(pacf_train_df_1, main = 'PACF for Bitcoin Transactions Without Difference 2017-2021') 
#ADF Test train dataset
adf.test(df_train)
#general Plot
df_train %>% ggtsdisplay(main = 'ACF, PACF and distribution of Train set 2017-2021')



#ACF traindataset with difference
acf_train_df_2<- acf(ts_train_diff, plot = FALSE)
plot(acf_train_df_2, main = 'ACF for Bitcoin Transactions With Difference 2017-2021')  
#PACF traindataset with difference
pacf_train_df_2<- pacf(ts_train_diff, plot = FALSE)
plot(pacf_train_df_2, main = 'PACF for Bitcoin Transactions With Difference 2017-2021') 
#ADF test with train data with difference
adf.test(ts_train_diff)
#general Plot
df_train %>% diff %>% ggtsdisplay(main = 'ACF, PACF and distribution of Train set with Diff 2017-2021')



#Plotting with 2 differences
df_train %>% diff %>% diff  %>% ggtsdisplay(main = 'ACF, PACF and distribution of Train set with Diff 2017-2021')

#ARIMA Model 1
model_1 <- df_train %>% sarima(p = 1, q = 1, d = 1, P = 1, Q = 1, D = 1, S = 7)
model_1$fit


#ACF model 1
acf_model_1 <- acf(model_1$fit$residuals, plot = FALSE)
plot(acf_model_1, main ='Residual ACF for model (1,1,1)(1,1,1)7') 


#PACF  model 1
pacf_model_1 <- pacf(model_1$fit$residuals, plot = FALSE)
plot(pacf_model_1, main ='Residual ACF for model (1,1,1)(1,1,1)7') 

#ljung box plot model 1
Box.Ljung.Test(model_1$fit$residuals, lag = 20, main = 'Ljung Box  for model (1,1,1)(1,1,1)7')


#distribution model 1
hist(model_1$fit$residuals, main = 'Residuals Distribution for model (1,1,1)(1,1,1)7')


#qqplot model 1

qqPlot(model_1$fit$residuals, main = 'QQ Plot for model (1,1,1)(1,1,1)7')

#AIC model comparision
model_3 <- df_train %>% sarima(p = 2, q = 1, d = 1, P = 1, Q = 1, D = 1, S = 7)
model_3$fit

model_4 <- df_train %>% sarima(p = 2, q = 1, d = 1, P = 1, Q = 1, D = 1, S = 7)
model_4$fit

model_5 <- df_train %>% sarima(p = 3, q = 1, d = 1, P = 1, Q = 1, D = 1, S = 7)
model_5$fit

model_6 <- df_train %>% sarima(p = 2, q = 2, d = 1, P = 1, Q = 1, D = 1, S = 7)
model_6$fit

model_7 <- df_train %>% sarima(p = 3, q = 2, d = 1, P = 1, Q = 1, D = 1, S = 7)
model_7$fit

model_8 <- df_train %>% sarima(p = 3, q = 3, d = 1, P = 1, Q = 1, D = 1, S = 7)
model_8$fit


#ARIMA Ideal Model
model_2 <- df_train %>% sarima(p = 3, q = 3, d = 0, P = 1, Q = 1, D = 1, S = 7)

#ACF Ideal model
acf_model_2 <- acf(model_2$fit$residuals, plot =FALSE)
plot(acf_model_2, main = 'Residual ACF for model (3,0,3)(1,1,1)7')

#PACF Ideal Model
pacf_model_2 <- pacf(model_2$fit$residuals, plot = FALSE)
plot(pacf_model_2, main ='Residual PACF for for model (3,0,3)(1,1,1)7')

#ljung box IDeal Model
Box.Ljung.Test(model_2$fit$residuals, lag = 20, main = 'Ljung Box for model (3,0,3)(1,1,1)7')

#hist ideal model
hist(model_2$fit$residuals, main = 'Residual Distribution for  model (3,0,3)(1,1,1)7')

#qqplot ideal model
qqPlot(model_2$fit$residuals, main = 'QQ Plot for model (3,0,3)(1,1,1)7')


#forecast
fore <- sarima.for(df_train, n.ahead = 62, p  = 3, d =0 , q = 3, P = 1, D = 1, Q = 1, S = 7)
low <- fore$pred-1.96*fore$se
high <- fore$pred+1.96*fore$se
low_ts <-xts(low, order.by = as.Date(index(df_test), "%Y-%m-%d"))
up_ts <-xts(high, order.by = as.Date(index(df_test), "%Y-%m-%d"))

#plotting forecast data
train_test_plot <- df_train[which(index(df_train) > '2021-06-18')]
data_pred <- xts(fore$pred, order.by = as.Date(index(df_test),"%Y-%m-%d" ))
plot.pred <- cbind(train_test_plot, df_test, data_pred, low_ts,up_ts)
names(plot.pred) <- c('Train_Data', 'Test_Data', 'Prediction', 'lower 95% CI', 'upper 95% CI')
autoplot.zoo(plot.pred, facets = NULL, main = 'Bitcoin Transactions Forecasting SARIMA (3,0,3) (1,1,1)7')
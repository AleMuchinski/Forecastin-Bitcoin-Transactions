# **Forecasting-Bitcoin-Transations-using-SARIMA**

# Use Case

- Use Case Summary
- Objective Statement: 
  * Understand how Bitcoin sales cycles work.
  * Trying to predict the volume of bitcoin transactions using data prediction models (ARIMA).
  * Perform extensive residual analysis and testing to understand the best parameters for predicting transactions.

- Challenges:
  * Bitcoin and blockchain have become phenomena after 2017, so one of the biggest challenges is that the volume of transactions has increased exponentially, making it difficult to optimally choose a data prediction model.
  * Since cryptocurrency trading has no rules like traditional exchanges, such as [circuit break](https://www.investopedia.com/terms/c/circuitbreaker.asp), it makes capital flights much greater and frequent for this type of asset.

- Methodology / Analytic Technique:
  * Descriptive Anaysis
  * ARIMA Forecasting
  * Residual Analysis

- Business Benefit:
  * With a clear visualization of the forecast of bitcoin transactions, it is possible to determine when the prices may vary too much due to some reason of capital flight and thus act in advance.

- Expected Outcome:
  * Knowing how many transactions are made daily.
  * Determining a predictive model that follows the test trend.
 
 # Business Understanding
 
 - Bitcoin transactions have gained popularity over the years, basically through complex computations blocks of calculations are validated and thus a prize is provided to those individuals who have contributed to it. - [reference](https://www.investopedia.com/terms/b/blockchain.asp)
 - Transaction volume over the years (2014 - 2021).
 - Determination of the Lag of Autocorrelation and partial autocorrelation.
 - Perform the Dickey-Fuller test to analyze the stationarity.

# Data Understanding

- Data extracted using the NASDAQ bitcoin volume transaction. [link](https://data.nasdaq.com/data/BCHAIN/NTRAN-bitcoin-number-of-transactions)
- The dataset contains daily transactions from January 2013 to October 2021 13th.
- In order to make a proper prediction the last two months of the dataset will be reserved as a test data
- Data Dictionary:
- Date: period of the transaction being confirmed.
- Value: Amount of transactions made.


# Data Preparation

- Code Used:
- R version 4.2.1
- Packages: ggplot2, dplyr, zoo, xts, tidyverse, tibble, tseries, DescTools, forecast, astsa, LSTS, car

# Data Cleansing

- Since the data provided by Nasdaq is pretty clean, the main work in this section was to separate the last two months for testing and the rest as training.

# Exploratory Data Analysis

- What is the volume of bitcoin transactions? ![bitcoin-transactions](https://i.imgur.com/GgRq4iE.png)

We can see that over the years the volume of transactions has changed a lot, just by visualization it is possible to tell that the stationarity of the data becomes unproven, so it is necessary to apply logarithm, cut the data, and apply difference.

- **Model evaluation part 1:**

To begin modeling forecasting data using ARIMA, certain steps should be followed

![bitcoin-transactions](https://i.imgur.com/eabstk3.png)

As the data is very fluctuating, and in order to predict future transactions, I decided to cut the data from 2017 onwards, where it follows a similar volume of transactions.

![bitcoin_transactions_2017](https://i.imgur.com/LJXKpJb.png)

However, we are not done with the modeling yet. For this we need to test with autocorrelation and partial autocorrelation tests where certain patterns should appear, for example exponential decay.

![acf_bitcoin](https://i.imgur.com/F1nCvlh.png)

Notice that the ACF plot doens't go to 0, therefore we need to apply one difference on the data in order to stablish the start of the parameters from our model and then iterate using Dickey-Fuller Test as benchmark to prove stationarity of the data.

![adf](https://i.imgur.com/NGdD4Uo.png)

According to the test the data without any transformation are stationary, however, due to the autocorrelation plot, the exponential decay is non-existent, so I will apply a differencing and perform the same tests to see if it is possible to optimize this process.


- **Model evaluation part 2:**

![difference](https://i.imgur.com/LeA4mPP.png)

As we can notice in the ACF plot we notice a seasonality in 7 out of 7 lags, so we soon understand that the next step in our transaction forecasting model should be to use SARIMA because we should inform that there is such a pattern in the data.


# Prediction

Following the parameters shown by the model and following the procedure for forecast modeling using ARIMA, we end up using the optimal model of **(3,0,3),(1,1,1)7**. Being, lag 3 for the autoregressive part (ACF), 0 in the differences (because it is already stationary), lag 3 in the moving average part (PACF), with a degree of 7 showing that every 7 lags there is a seasonality

![prediction](https://i.imgur.com/iqLpb91.png)


# Conclusion
The results are very satisfactory, following the forecast data we can see that our model follows the seasonality of the data and the trend of the forecast.

# Model Improvements
Even though the current model is good for predicting bitcoin transactions, there are
some points for improvement, such as trying to better understand unusual periods in the
time series (such as bubbles) to cut the data more accurately than just by visual comparison
(in this case January 2017), but for this other data would be needed to make the model more
accurate, such as analyzing the value of bitcoin in parallel over time and even in another
scenario, such as the number of tweets mentioning bitcoin to understand moments of panic
in the market.







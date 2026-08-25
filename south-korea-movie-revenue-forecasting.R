# South Korea Movie Revenue Time Series Forecasting

library(readxl)
library(forecast)
library(seastests)
library(tseries)
library(astsa)

# Load the dataset
datasett <- read_excel("data/experiment1.xlsx")

# Create the monthly time series
time <- ts(
  datasett$turnover,
  start = c(2004, 1),
  end = c(2017, 12),
  frequency = 12
)

plot(time, ylab = "", xlab = "", col = 4)
title(ylab = "Turnover", cex.lab = 1.4)
title(xlab = "Time", cex.lab = 1.4)

summary(time)

# Check the ACF to assess stationarity
acf(time)

# Test for seasonality
seas.time <- kw(time)
seas.time

# Log transformation to stabilize the variance
log_time <- log(time)

# Split the data into training and testing sets
train <- head(log_time, round(length(log_time) * 0.80))

h <- length(log_time) - length(train)
h

test <- tail(log_time, h)

plot(
  train,
  type = "l",
  xlab = "",
  ylab = "",
  col = 4,
  lwd = 1
)

title(ylab = "Turnover", cex.lab = 1.4)
title(xlab = "Time", cex.lab = 1.4)

lines(test, col = 3, lwd = 1)

legend(
  "topleft",
  col = c(4, 3),
  legend = c("Training set", "Testing set"),
  lty = 0.9,
  cex = 1
)

# First-order differencing to remove the trend
# Seasonal differencing to remove seasonality
# These differences are used to assess stationarity
# and determine the model orders
lag <- diff(train, 1)
lag2 <- diff(lag, 12)

plot(
  lag2,
  type = "l",
  xlab = "",
  ylab = "",
  col = 4
)

title(ylab = "Differenced Turnover", cex.lab = 1.4)
title(xlab = "Time", cex.lab = 1.4)

# Augmented Dickey-Fuller test for stationarity
adf.test(lag2)

# ACF and PACF for model identification
acf(
  lag2,
  lag.max = 48,
  xlab = "",
  ylab = "",
  main = ""
)

title(ylab = "ACF", cex.lab = 1.4)
title(xlab = "Lag", cex.lab = 1.4)

pacf(
  lag2,
  xlab = "",
  ylab = "",
  main = ""
)

title(ylab = "PACF", cex.lab = 1.4)
title(xlab = "Lag", cex.lab = 1.4)

# Initial SARIMA model
fit1 <- arima(
  x = train,
  order = c(0, 1, 2),
  seasonal = list(
    order = c(0, 1, 1),
    period = 12
  )
)

summary(fit1)

# Search for the best SARIMA model based on AIC
D <- 1
d <- 1
s <- 12

results <- data.frame(
  Model = character(),
  AIC = numeric(),
  stringsAsFactors = FALSE
)

for (p in 0:3) {
  for (q in 0:3) {
    for (P in 0:3) {
      for (Q in 0:3) {
        
        fit <- try(
          Arima(
            train,
            order = c(p, d, q),
            seasonal = list(
              order = c(P, D, Q),
              period = s
            )
          ),
          silent = TRUE
        )
        
        if (!inherits(fit, "try-error")) {
          
          results <- rbind(
            results,
            data.frame(
              Model = paste0(
                "SARIMA(",
                p, ",", d, ",", q,
                ")x(",
                P, ",", D, ",", Q,
                ")_",
                s
              ),
              AIC = AIC(fit)
            )
          )
        }
      }
    }
  }
}

results <- results[order(results$AIC), ]

print(results)

# Best model from the model comparison
best_fit <- arima(
  train,
  order = c(0, 1, 3),
  seasonal = list(
    order = c(2, 1, 2),
    period = 12
  )
)

# Best model: SARIMA(0,1,3)x(2,1,2)_12
# AIC = 195.8512
best_fit

# Automatic SARIMA model
fit_auto <- auto.arima(
  train,
  seasonal = TRUE,
  D = 1
)

fit_auto

# Initial model for comparison
ARIMA2 <- arima(
  train,
  order = c(0, 1, 2),
  seasonal = list(
    order = c(0, 1, 1),
    period = 12
  )
)

ARIMA2

# Fit the selected model to the testing period
fv <- Arima(
  test,
  model = best_fit
)

plot(
  test,
  xlab = "",
  ylab = "",
  col = 4,
  main = ""
)

lines(
  fv$fitted,
  col = 3
)

title(ylab = "Turnover", cex.lab = 1.4)
title(xlab = "Time", cex.lab = 1.4)

legend(
  "topleft",
  col = c(4, 3),
  legend = c("Testing", "Fitted values"),
  lty = 1,
  cex = 0.9
)

# Calculate MSE for the selected model
error1 <- best_fit$residuals
mse1 <- mean(error1^2)
mse1

# Calculate MSE for the automatic model
error2 <- fit_auto$residuals
mse2 <- mean(error2^2)
mse2

# Calculate MSE for the initial model
error3 <- ARIMA2$residuals
mse3 <- mean(error3^2)
mse3

# Model Diagnostics

# Check for potential outliers
error4 <- fv$residuals

MSE <- mean(error4^2)
MSE

MAX <- max(error4)
MAX

MIN <- min(error4)
MIN

dMAX <- MAX / sqrt(MSE)
dMAX

dMIN <- MIN / sqrt(MSE)
dMIN

# Check whether standardized residuals exceed the outlier limits
# No outliers were identified based on the selected limits

# Check residual normality
qqnorm(
  error4,
  xlab = "",
  ylab = "",
  main = "",
  col = 4
)

qqline(
  error4,
  col = 3
)

title(
  ylab = "Sample Quantiles",
  cex.lab = 1.4
)

title(
  xlab = "Theoretical Quantiles",
  cex.lab = 1.4
)

ks.test(
  error4,
  "pnorm"
)

# Check standardized residual normality
ress_std <- residuals(best_fit) / sqrt(best_fit$sigma2)

ks.test(
  ress_std,
  "pnorm"
)

# Check constant variance using residual plots
fit <- fv$fitted

plot(
  fit,
  error4,
  xlab = "",
  ylab = "",
  col = 4
)

abline(
  h = 0,
  col = 3
)

title(
  ylab = "Residuals",
  cex.lab = 1.4
)

title(
  xlab = "Fitted Values",
  cex.lab = 1.4
)

plot(
  as.numeric(fit),
  as.numeric(error4),
  xlab = "",
  ylab = "",
  col = 4,
  pch = 16,
  type = "p",
  cex = 0.7
)

abline(
  h = 0,
  col = 3
)

title(
  ylab = "Residuals",
  cex.lab = 1.4
)

title(
  xlab = "Fitted Values",
  cex.lab = 1.4
)

# The residuals are distributed with approximately equal variance

# Forecast the next five years
fv_full <- Arima(
  time,
  model = best_fit
)

summary(fv_full)

future <- forecast(
  fv_full,
  h = 12 * 5
)

# Transform the forecast back to the original scale
forecast_original_scale <- exp(future$mean)

forecast_original_scale

# Plot the 60-month forecast
plot(
  future,
  col = 2,
  xlab = "Year",
  ylab = "Turnover",
  main = "60-Month Forecast: SARIMA(0,1,3)(2,1,2)[12]",
  type = "l"
)

legend(
  "topleft",
  col = c(2, 4),
  legend = c("Original Data", "Forecasted Values"),
  lty = 1,
  cex = 0.9
)
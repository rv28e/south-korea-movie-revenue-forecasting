# South Korea Movie Revenue Time Series Forecasting

## Project Overview
This project applies time series analysis and forecasting techniques to study monthly movie revenues in South Korea from January 2004 to December 2017.
The analysis focuses on identifying trend and seasonal patterns, assessing stationarity, developing SARIMA models, comparing candidate models, and forecasting future movie revenues.

## Objective
The main objective of this project is to analyze the historical pattern of monthly movie revenues and develop an appropriate SARIMA model for forecasting future revenues.

## The Challenge
The time series contains trend and seasonal patterns, which require appropriate transformations and differencing before fitting a forecasting model.
The project therefore investigates:

- Trend and seasonality
- Stationarity
- Appropriate differencing
- SARIMA model selection
- Model performance
- Residual diagnostics
- Future revenue forecasting

## Methodology
The analysis was conducted in R using the following steps:

1. Created a monthly time series covering 2004–2017.
2. Examined the time series and its autocorrelation structure.
3. Tested for seasonality using the Kruskal-Wallis test.
4. Applied a logarithmic transformation to stabilize the variance.
5. Split the data into training and testing sets using an 80/20 split.
6. Applied first-order and seasonal differencing.
7. Used the Augmented Dickey-Fuller test to assess stationarity.
8. Examined ACF and PACF plots to support model identification.
9. Compared multiple SARIMA models using AIC.
10. Compared the selected model with alternative models using MSE.
11. Conducted residual diagnostics.
12. Generated a 60-month forecast.

## Seasonality
The Kruskal-Wallis test indicated significant seasonality in the monthly revenue data.
The reported p-value was:
`1.088858e-07`
Since the p-value is below 0.05, the null hypothesis of no seasonal effect was rejected.

## Stationarity
The original time series showed non-stationary behavior.
After applying first-order and seasonal differencing, the Augmented Dickey-Fuller test produced a p-value of:
`0.01`
This provided evidence that the differenced series was stationary.

## Model Selection
Several SARIMA models were evaluated using Akaike Information Criterion (AIC).
The selected model was:
**SARIMA(0,1,3)(2,1,2)[12]**
The selected model had:
- **AIC:** 195.8512
- **MSE:** 0.1889559
The selected model was also compared with an automatically selected ARIMA model and an initial SARIMA model.

## Model Diagnostics
Residual diagnostics were performed to assess the adequacy of the selected model.
The analysis included:
- Outlier assessment
- Q-Q plot
- Kolmogorov-Smirnov normality test
- Standardized residual analysis
- Residuals versus fitted values

The residual analysis indicated no identified outliers based on the selected standardized residual limits.
The normality assessment showed that the unstandardized residuals did not fully satisfy the normality assumption, while the standardized residual analysis provided a different result.

## Forecasting
The selected model was used to generate forecasts for the next **60 months (5 years)**.
The forecasts were transformed back to the original revenue scale after modeling the logarithmically transformed series.

## Tools
- R
- RStudio
- `readxl`
- `forecast`
- `seastests`
- `tseries`
- `astsa`

## Project Structure
```text
south-korea-movie-revenue-forecasting/
│
├── south-korea-movie-revenue-forecasting.R
│
├── data/
│   └── experiment1.xlsx
│
└── README.md
```
## Files
- `south-korea-movie-revenue-forecasting.R` — R code used for the statistical analysis.
- `data/experiment1.xlsx` — Dataset used in the analysis.

## Author
**Roaa Alharbi**

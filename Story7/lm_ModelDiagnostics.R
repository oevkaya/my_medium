# Classical lm function usage

# Data set from the package ISLR2 
# install.packages("MASS")
# install.packages("ISLR2")
library(MASS)
library(ISLR2)

# First insight about data set
data(Boston)
head(Boston)
summary(Boston)

# To understand the relationship between two variables
plot(Boston[, c("lstat", "medv")])

# The correlation coefficient
cor(Boston[, c("lstat", "medv")])

# Fit a regression line to describe medv by lstat

set.seed(123) # for reproducible results
sample.size <- floor(0.80 * nrow(Boston)) # %80 for training, %20 for testing
train.index <- sample(seq_len(nrow(Boston)), size = sample.size)
train <- Boston[train.index, ]
test <- Boston[-train.index, ]

# Simple linear regression 
lm.fit = lm(medv ~ lstat, data = train) 
summary(lm.fit) 

par(mfrow = c(2,2))
plot(lm.fit)
par()

# Look at cooks distances in detail
plot(lm.fit, 4)
plot(lm.fit_mult, 4)

# Residuals vs Leverage
plot(lm.fit_mult, 5)

# performance -------------------------------------------------------------


# Other packages for model diagnostics
library(performance)
# To create the plots, see needs to be installed.
# install.packages(see)
library(see)


# checking model assumptions
check_model(lm.fit)

# For multiple regression 
lm.fit_mult = lm(medv ~ ., data = train)
check_model(lm.fit_mult)

# Compare simple and multiple regression models 
# Separately
model_performance(lm.fit)
model_performance(lm.fit_mult)
# Together
compare_performance(lm.fit, lm.fit_mult)

# For further reading about performance
# https://easystats.github.io/performance/


# modelr ------------------------------------------------------------------


# Use of modelr package
library(tidyverse)
library(modelr)

# Look at model performance metrics on testing data
# For lm.fit
data.frame(
  R2 = rsquare(lm.fit, data = test),
  MSE = mse(lm.fit, data = test), 
  RMSE = rmse(lm.fit, data = test),
  MAE = mae(lm.fit, data = test)
)

# For lm.fit_mult
data.frame(
  R2 = rsquare(lm.fit_mult, data = test),
  MSE = mse(lm.fit_mult, data = test), 
  RMSE = rmse(lm.fit_mult, data = test),
  MAE = mae(lm.fit_mult, data = test)
)

# For further reading about modelr
# https://modelr.tidyverse.org/index.html


# leaps -------------------------------------------------------------------

library(leaps)

# Regression subset selection including exhaustive search. 
# This is only for linear regression. With exhaustive default method
# You can try method=c("exhaustive", "backward", "forward", "seqrep")
regsubsets.out <-regsubsets(medv ~ . , data = Boston, )
regsubsets.out

# Best model at each variable number
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)

# Graphical table of best subsets (plot.regsubsets)
## Adjusted R2
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2")

# For further reading
# https://rstudio-pubs-static.s3.amazonaws.com/2897_9220b21cfc0c43a396ff9abf122bb351.html

# Fit another model with best subset
lm.fit_mult2 = lm(medv ~ crim + zn + chas +nox + rm + dis + ptratio + lstat, data = train)

summary(lm.fit_mult2)

check_model(lm.fit_mult2)
model_performance(lm.fit_mult2)

model_lm.fit2 <- data.frame(
  R2 = rsquare(lm.fit_mult2, data = test),
  MSE = mse(lm.fit_mult2, data = test), 
  RMSE = rmse(lm.fit_mult2, data = test),
  MAE = mae(lm.fit_mult2, data = test)
)


# gglm --------------------------------------------------------------------
install.packages("gglm")
library(gglm)

# Plot the four main diagnostic plots at the same time

gglm(lm.fit_mult2)

# For further reading
# https://github.com/graysonwhite/gglm



# lindia ------------------------------------------------------------------
library(lindia)

# visualize diagnostic plots with all
# The output is not practical !
gg_diagnose(lm.fit_mult2)

# customize which diagnostic plot is included
plots <- gg_diagnose(lm.fit_mult2, plot.all = FALSE)
names(plots)     # get name of the plots

exclude_plots <- plots[-c(2:9) ]    #exclude certain diagnostics plots
# make use of plot_all() 
plot_all(exclude_plots)    

# Alternatives for model diagnostics

# Boxcox graph
gg_boxcox(lm.fit_mult2)

# Generate residual plot of residuals against predictors
gg_resX(lm.fit_mult2)

# For further reading
# https://github.com/yeukyul/lindia
# https://cran.r-project.org/web/packages/lindia/lindia.pdf

# Final model with 7 predictors only
# Fit another model with best subset
lm.fit_mult3 = lm(medv ~ crim + zn + nox + rm + dis + ptratio + lstat, data = train)

summary(lm.fit_mult3)

check_model(lm.fit_mult3)
model_performance(lm.fit_mult3)

model_lm.fit3 <- data.frame(
  R2 = rsquare(lm.fit_mult3, data = test),
  MSE = mse(lm.fit_mult3, data = test), 
  RMSE = rmse(lm.fit_mult3, data = test),
  MAE = mae(lm.fit_mult3, data = test)
)

# To compare
model_lm.fit2
model_lm.fit3



# Testing Assumptions -----------------------------------------------------


# Testing for the multiple linear regression model
# library(car) is necessary for functions

# Assessing Outliers
# Bonferonni p-value for most extreme obs
outlierTest(lm.fit_mult3) 
# examine the model’s df.betas in order to see which observations exert 
# the most influence on the model’s regression coefficients
plotdb<-dfbetaPlots(lm.fit_mult3, id.n=3)

# leverage plots
leveragePlots(lm.fit_mult3)

# Influential Observations
# added variable plots
avPlots(lm.fit_mult3)


# Influence Plot
influencePlot(lm.fit_mult3, id.method="identify", 
              main="Influence Plot", 
              sub="Circle size is proportial to Cook's Distance" )


# Evaluate homoscedasticity
# non-constant error variance test
ncvTest(lm.fit_mult3)

# plot studentized residuals vs. fitted values
spreadLevelPlot(lm.fit_mult3)

# Evaluate Collinearity
# variance inflation factors
vif(lm.fit_mult3)
sqrt(vif(lm.fit_mult3)) > 2

# Evaluate Nonlinearity
# component + residual plot
crPlots(lm.fit_mult3)

# Test for Autocorrelated Errors
durbinWatsonTest(lm.fit_mult3)


# Tests with performance package

check_heteroscedasticity(lm.fit_mult3)
check_autocorrelation(lm.fit_mult3)
check_collinearity(lm.fit_mult3)
check_normality(lm.fit_mult3)

check_outliers(lm.fit_mult3, method = "cook", threshold = NULL)
check_outliers(lm.fit_mult3, method = "pareto", threshold = NULL)

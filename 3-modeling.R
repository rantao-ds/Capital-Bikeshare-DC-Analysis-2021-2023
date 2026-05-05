# aggregating daily trip counts with weather conditions and weekend status for modeling
lm_model_tripcount <- eda_final %>%
group_by(started_date, temp, precip, windspeed, cloudcover,weekend) %>%
summarise(total_trip = n(), .groups = "drop")

lm_model_tripcount$started_date <- as.Date(lm_model_tripcount$started_date)

# running multiple linear regression
lr <- lm(total_trip ~ temp + precip + windspeed + cloudcover+weekend, 
         data = lm_model_tripcount)
summary(lr)

# running vif to to check multicollinearity
library(faraway)
vif(lr)

# preparing train/test split (70/30) for regularization modeling
library(glmnet)

x <- as.matrix(lm_model_tripcount[,c("temp","precip","windspeed","cloudcover","weekend")])
y <- lm_model_tripcount$total_trip

set.seed(123)
train_rows <- sample(1:nrow(x), 0.7 * nrow(x))
test_rows <- setdiff(1:nrow(x), train_rows)
trainx <- x[train_rows, ]
trainy <- y[train_rows]
testx <- x[test_rows, ]
testy <- y[test_rows]

# running LM 
lm_fit <- lm(trainy ~ trainx)
yhat_lm <- cbind(1, testx) %*% coef(lm_fit)
mse_lm <- mean((testy - yhat_lm)^2)
mse_lm

# runnig Lasso 
lambda_seq <- 10^seq(7, -2, length=100)
lasso_mod <- glmnet(trainx, trainy, alpha=1, lambda=lambda_seq)
cv_lasso <- cv.glmnet(trainx, trainy, alpha=1, lambda=lambda_seq)
best_lambda_lasso <- cv_lasso$lambda.min
yhat_lasso <- predict(lasso_mod, s=best_lambda_lasso, newx=testx)
mse_lasso <- mean((testy - yhat_lasso)^2)
mse_lasso

# running Ridge 
ridge_mod <- glmnet(trainx, trainy, alpha=0, lambda=lambda_seq)
cv_ridge <- cv.glmnet(trainx, trainy, alpha=0, lambda=lambda_seq)
best_lambda_ridge <- cv_ridge$lambda.min
yhat_ridge <- predict(ridge_mod, s=best_lambda_ridge, newx=testx)
mse_ridge <- mean((testy - yhat_ridge)^2)
mse_ridge

# running ElasticNet
enet_mod <- glmnet(trainx, trainy, alpha=0.5, lambda=lambda_seq)
cv_enet <- cv.glmnet(trainx, trainy, alpha=0.5, lambda=lambda_seq)
best_lambda_enet <- cv_enet$lambda.min
yhat_enet <- predict(enet_mod, s=best_lambda_enet, newx=testx)
mse_enet <- mean((testy - yhat_enet)^2)
mse_enet

# comparing MSEs across all models
mse_table <- c(LM=mse_lm, Lasso=mse_lasso, Ridge=mse_ridge, ElasticNet=mse_enet)
mse_table

# comparing coefficients across regularization models
coef(lasso_mod, s = best_lambda_lasso)
coef(ridge_mod, s = best_lambda_ridge)
coef(enet_mod, s = best_lambda_enet)

# plot the models 
par(mfrow=c(1,3))
plot(lasso_mod, xvar="lambda", main="Lasso Coefficients")
plot(ridge_mod, xvar="lambda", main="Ridge Coefficients")
plot(enet_mod, xvar="lambda", main="Elastic Net Coefficients")

# running quadratic model
lm_poly <- lm(total_trip ~ temp + I(temp^2) + precip + I(precip^2) +
              windspeed + I(windspeed^2)  + cloudcover + I(cloudcover^2) + 
              weekend, data =lm_model_tripcount)

summary(lm_poly)


# calculating the peak values using vertex formula: -β1/2β2
# temp peak: -635.869 / (2 × -12.382) = 25.677°C
# precip peak: 180.975 / (2 × 2.403) = 37.656mm
# cloud peak: -40.439 / (2 × -0.587) = 34.445%


# running interaction model
lm_poly1 <- lm(total_trip ~ temp + precip + windspeed + cloudcover +
              weekend + weekend*temp + weekend*precip, 
              data = lm_model_tripcount)

summary(lm_poly1)


# calculating the weekend slope for temperature
# slope(weekend) = β_temp + β_(temp×weekend) = 262.038 + 66.575 = 328.613

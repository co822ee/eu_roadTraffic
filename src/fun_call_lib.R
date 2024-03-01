# Call necessary packages
ipak <- function(pkg){
   
   new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
   if (length(new.pkg)) 
      install.packages(new.pkg)
   sapply(pkg, require, character.only = TRUE)
}
packages <- c("SpatialML", "ranger", "GWmodel", "car", "lme4", "performance",
              # "caret","splitstackshape","splitTools",
              "CAST", 'rgdal',
              'caret', 
              'doParallel','foreach',
              'data.table',
              "tidyr", "dplyr", "splitstackshape", # stratified() 
              "raster", "sf", 'sp',
              "ggplot2", "tmap", "viridis","gridExtra"
              )
ipak(packages)
# install_github("mengluchu/APMtools") 
# library(APMtools)
error_matrix <- function (validation, prediction) 
{
   rmse <- function(test, pred) {
      sqrt(mean((pred - test)^2))
   }
   MAE = function(test, pred) {
      mean(abs(pred - test))
   }
   IQR <- function(test, pred) {
      a2 = summary(as.vector(pred - test))
      as.vector(a2[5] - a2[2])
   }
   rIQR <- function(test, pred) {
      a2 = summary(as.vector(pred - test))
      as.vector(a2[5] - a2[2])/median(test)
   }
   explained_variance <- function(test, pred) {
      1 - var(pred - test)/var(test)
   }
   Rsquared <- function(test, pred) {
      1 - mean((pred - test)^2)/var(test)
   }
   rrmse <- function(test, pred) {
      rmse = sqrt(mean((pred - test)^2))
      rmse/mean(test)
   }
   rMAE = function(test, pred) {
      mean(abs(pred - test))/mean(test)
   }
   rmse1 = rmse(validation, prediction)
   rrmse1 = rrmse(validation, prediction)
   MAE1 = MAE(validation, prediction)
   rMAE1 = rMAE(validation, prediction)
   IQR1 = IQR(validation, prediction)
   rIQR1 = rIQR(validation, prediction)
   rsqd1 = Rsquared(validation, prediction)
   expvar1 = explained_variance(validation, prediction)
   c(RMSE = rmse1, RRMSE = rrmse1, IQR = IQR1, rIQR = rIQR1, 
     MAE = MAE1, rMAE = rMAE1, rsq = rsqd1, explained_var = expvar1)
}

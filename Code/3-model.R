## (Title) R Script 3-model for Stats 506, F20 Final Project
##
## (Brief Description)
## This is the third part of code in this project, mainly focusing
## on variable selections and models.
##
## (Additional Details)
## Get the data from data1.RData
##
## Author(s): Tianshi Wang, wangts@umich.edu
## Updated: December 7, 2020 - Last modified date
#! Update the date every time you work on a script. 

#! Limit lines to 79 characters with rare exceptions. 
# 79: -------------------------------------------------------------------------

#! Use the following structure to label distinct code chunks that accomplish
#! a single or related set of tasks. 

#! Load libraries at the top of your script.
# libraries: ------------------------------------------------------------------
library(foreign)
library(tidyverse)
library(leaps)
library(MASS)
library(splines)

# directories: ----------------------------------------------------------------
path = "C:/Users/lenovo/Desktop/FinalProject"

#! you should generally read/load data in a single place near the start.
# data: -----------------------------------------------------------------------
file = sprintf('%s/data1.RData', path)
foo = load(file)

### base-line model: ------------------------------------------------------------
model.0a = lm(energy ~ pir, data = data1)
summary(model.0a)
model.0b = lm(log(energy) ~ pir, data = data1)
summary(model.0b)

### variable selection: ------------------------------------------------------
b = regsubsets(log(energy) ~ pir+age+gender+I(age^2)+I(age^3)+pregnancy+num_people_hd+num_people_fm, data = data1)
rs = summary(b)
rs
# According to the result, the first 5 important
# variables in this problem are pir, age, gender, 
# age^2, age^3.

### models : -----------------------------------------------------------------
# 1. basic linear regression model
model.1 = lm(energy ~ pir+age+gender+I(age^2)+I(age^3), data = data1)
model.1a = lm(energy ~ pir+age, data = data1)
model.1b = lm(energy ~ pir+age+I(age^2), data = data1)
model.1c = lm(energy ~ pir+age+I(age^2)+I(age^3), data = data1)
summary(model.1)

# 2. log regression model
model.2a = lm(log(energy) ~ pir+age+gender+I(age^2)+I(age^3), data = data1)
summary(model.2a)

# 3. Box-Cox Method  
model.3a = lm(energy ~ pir+age+I(age^2)+I(age^3), data = data1[data1$pir>0,])
boxcox(model.3a, plotit = T, lambda = seq(0, 1.5, 0.1))
boxcox(model.3a, plotit = T, lambda = seq(0, 0.5, 0.02))

transform = function(y, lambda){
  return((y^lambda-1)/lambda)
}
model.3b = lm(transform(energy, 0.18) ~ pir+age+gender+I(age^2)+I(age^3), data = data1)
summary(model.3b)

# 4. Non-Linear Gaussian with Gamma function
model.4a <- glm(log(energy) ~ pir+age+gender+I(age^2)+I(age^3),family=Gamma, data = data1)
summary(model.4a)
vs4 = regsubsets(model.4a)
vs4

# 5. Regression spline in considering the effect of age
age = data1$age
energy = data1$energy
knots = c(0, 0, 0, 0, 18, 30, 40, 50, 60, 80, 80, 80, 80)
summary(age)
bx = splineDesign(knots, age, outer.ok = T)
gs = lm(log(energy) ~ age, data = data1)
matplot(age, cbind(log(data1$energy),gs$fit), type = "pl")
model.5b = lm(log(energy)~poly(age, 4), data = data1)
matplot(age, cbind(log(data1$energy), model.5b$fit), type = "pl")

#! Keep this as a reference for code length at 
#! the top and bottom of your scripts. 
# 79: -------------------------------------------------------------------------

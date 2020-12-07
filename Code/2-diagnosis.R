## (Title) R Script 2-diagnosis for Stats 506, F20 Final Project
##
## (Brief Description)
## This is the second part of code in this project, mainly focusing
## on analyzing the abnormal observations or the distribustion of
## residuals.
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
# libraries: -----------------------------------------------------------------
library(foreign)
library(tidyverse)

#! store directories you read from or write to as objects here.
# directories: ----------------------------------------------------------------
path = "C:/Users/lenovo/Desktop/FinalProject"

#! you should generally read/load data in a single place near the start.
### data: ---------------------------------------------------------------------
file = sprintf('%s/data1.RData', path)
foo = load(file)

lm1 = lm(energy ~ pir+age+gender+I(age^2)+I(age^3)+pregnancy
         +num_people_hd+num_people_fm, data = data1)

### diagnosis: ----------------------------------------------------------------
## 1. analysis for residuals

plot(lm1$fitted, lm1$residuals, xlab = "fitted", ylab = "residuals")
abline(h=0, col = "red") # showed non-uniform in variance
  

## 2. checking normality
qqnorm(lm1$residuals)
qqline(lm1$residuals) # showed heavy tail on the right.

  # (1) Since the residual plots showed non-uniform in variance, we
  # may need to consider the non-linear model in our later analysis. 
  # (2) Since the qq-plot showed heavy tail, we may need to consider
  # non-Gaussian noise term.
  # Two indicators above suggest us to try a non-Gaussian GLM
  # model in our further analysis.



#! Keep this as a reference for code length at 
#! the top and bottom of your scripts. 
# 79: -------------------------------------------------------------------------

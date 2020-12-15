## (Title) R Script 3-model for Stats 506, F20 Final Project
##
## (Brief Description)
## This is the third part of code in this project, mainly focusing
## on demographic variables analysis.
##
## (Additional Details)
## Get the data from data1.RData
##
## Author(s): Tianshi Wang, wangts@umich.edu
## Updated: December 15, 2020 - Last modified date
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
library(faraway)
library(MASS)
library(splines)
library(survey)

# directories: ----------------------------------------------------------------
path = "C:/Users/lenovo/Desktop/FinalProject"

#! you should generally read/load data in a single place near the start.
# data: -----------------------------------------------------------------------
file = sprintf('%s/data1.RData', path)
foo = load(file)
data1$gender<-as.factor(data1$gender)
levels(data1$gender)<-c("Male", "Female") # factorize the gender

### Model 0: A start  --------------------------------------------------------
design0 <- svydesign(data=data1, id=~psu, strata=~strata,
                    weights=~w, nest=TRUE)
model0 <- svyglm(log(energy) ~ pir, family=Gamma,
                 data = data1, design = design0)
summary(model0)

### Model 1: GLM  ------------------------------------------------------------
# variable selection
design1 <- svydesign(data=data1, id=~psu, strata=~strata,
                    weights=~w, nest = TRUE)
model1_tempt1 <- svyglm(log(energy) ~ pir+gender+age+I(age^2)+I(age^3)
                        +pregnancy+num_people_hd+num_people_fm,
                    family=Gamma, data = data1, design = design1)
summary(model1_tempt1)
model1 <- svyglm(log(energy) ~ pir+age+gender+I(age^2)+I(age^3)+num_people_fm,
                    family=Gamma, data = data1, design = design1)
summary(model1)

  # According to the result, the first 6 important
  # variables in this problem are pir, age, gender, 
  # age^2, age^3, and num_people_fm.

# test for influential points
par(mfrow = c(2, 2), mar = c(2, 5, 3, 1), oma = c(0.5, 1, 1, 0.5))
plot(model1)
par(mfrow = c(1, 2), mar = c(3, 6, 3, 2), oma = c(0.5, 1, 1, 0.5))
remove = c(2580, 3837, 5417)

  # According to the result, there are three
  # influential points: 2580, 3837, 5417

# model
design2 <- svydesign(data=data1[-remove,], id=~psu, strata=~strata,
                    weights=~w, nest=TRUE)
model1a <- svyglm(log(energy) ~ pir+age+gender+I(age^2)
                  +I(age^3)+num_people_fm,
               family=Gamma, data = data1[-remove,], design = design2)

model1b <- svyglm(log(energy) ~ pir+age+gender-1+I(age^2)
                  +I(age^3)+num_people_fm,
               family=Gamma, data = data1[-remove,], design = design2)
summary(model1a)
summary(model1b)



### Factor analysis: gender --------------------------------------------------
# Pairwise comparison between male and female using one-way ANOVA & TukeyHSD
gender_aov = aov(energy ~ gender, weights = w, data1[-remove,])
TukeyHSD(gender_aov)
TukeyHSD(gender_aov)$gender
plot(TukeyHSD(gender_aov))


### Factor analysis: age -----------------------------------------------------
## factorize age into different groups
data1$age_group = data1$age
data1[(data1$age <= 10), 12] <- "A"
data1[(data1$age > 10) & (data1$age <= 18), 12] <- "B"
data1[(data1$age > 18) & (data1$age <= 60), 12] <- "C"
data1[(data1$age > 60), 12] <- "D"
unique(data1$age_group)
data1$age_group<-as.factor(data1$age_group)

# Pairwise comparisons between age groups using one-way ANOVA & TukeyHSD
age_aov = aov(energy ~ age_group, weights = w, data1[-remove,])
TukeyHSD(age_aov)
TukeyHSD(age_aov)$age
par(mar=c(5.1,4.1,4.1,2.1))
plot(TukeyHSD(age_aov))


# regression splines
knots = c(0, 0, 0, 0, 10, 18, 60, 80, 80, 80, 80)
bx = splineDesign(knots, data1$age, outer.ok = T)
gs1 = svyglm(log(energy) ~ age, data = data1[-remove],
            design = design2)
matplot(data1$age, cbind(log(data1$energy),gs1$fit), type = "pl")
gs2 = svyglm(log(energy) ~ poly(age, 4), data = data1,
                  design = design2)
# matplot(data1$age, cbind(log(data1$energy), gs2$fit), type = "pl")

knots2 = c(10, 18, 60)
fit_spline = svyglm(log(energy)~bs(age, knots = c(10, 18, 60), df = 3),
                    data = data1[-remove,], design = design2)
# matplot(data1$age, cbind(log(data1$energy), fit_spline$fit))
# matplot(data1$age, fit_spline$fit, type = "l")
length(data1$age)
length(fit_spline$fit)
plot(data1[-remove,]$age, log(data1[-remove,]$energy), xlab = "Age",
     ylab = "log(Energy)", main = "Regression Spline")
lines(data1[-remove,]$age, fitted(fit_spline),lwd = 3, col = 2)


#! Keep this as a reference for code length at 
#! the top and bottom of your scripts. 
# 79: -------------------------------------------------------------------------

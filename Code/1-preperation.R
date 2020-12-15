## (Title) R Script 1-preparation for Stats 506, F20 Final Project
##
## (Brief Description)
## This is the first part of code in this project, mainly focusing on
## preparing data for further analysis.
## 
##  
## (Additional Details)
## Data Source: https://wwwn.cdc.gov/nchs/nhanes/Default.aspx
##
##
## Author(s): Tianshi Wang, your email wangts@umich.edu
## Updated: December 15, 2020 - Last modified date
#! Update the date every time you work on a script. 


#! Limit lines to 79 characters with rare exceptions. 
# 79: -------------------------------------------------------------------------

#! Use the following structure to label distinct code chunks that accomplish
#! a single or related set of tasks. 

#! Load libraries at the top of your script.
# libraries: ------------------------------------------------------------------
library(tidyverse)
library(foreign)

#! store directories you read from or write to as objects here.
# directories: ----------------------------------------------------------------
path = "C:/Users/lenovo/Desktop/FinalProject"

#! you should generally read/load data in a single place near the start.
# data: -----------------------------------------------------------------------

# load the data
diet1 = read.xport(
  "C:/Users/lenovo/Desktop/FinalProject/DrinkWaterExample/DR1TOT_J.xpt")
demo = read.xport(
  "C:/Users/lenovo/Desktop/FinalProject/DrinkWaterExample/DEMO_J.xpt")

# merge
data_prep = demo %>%
  left_join(diet1, by = "SEQN") 

data1 = data_prep %>% 
  transmute(
    id = SEQN,
    energy = DR1TKCAL,
    pir = INDFMPIR,
    gender = RIAGENDR,
    age = RIDAGEYR,
    pregnancy = ifelse(!is.na(RIDEXPRG), ifelse(RIDEXPRG==1, 1, 0), 0),
    num_people_hd = DMDHHSIZ,
    num_people_fm = DMDFMSIZ,
    w = WTDRD1,
    psu = SDMVPSU,
    strata = SDMVSTRA
  ) %>% filter(log(energy) > 0) 


# remove NA
data1 = na.omit(data1)

# save the data 
file = sprintf('%s/data1.RData', path)
save(data_prep, data1, file = file)



#! Keep this as a reference for code length at 
#! the top and bottom of your scripts. 
# 79: -------------------------------------------------------------------------

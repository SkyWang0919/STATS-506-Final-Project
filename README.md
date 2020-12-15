# STATS-506-Final-Project

### Topic: 
#### Do people in the US from households with higher income consume more calories? 

### Introduction:
Diet energy intake has become a crucial factor when judging whether someone maintains a healthy lifestyle. Meanwhile, the amount of household income is one of the most important criteria of household economic status. It might be a pretty interesting topic to explore the relationship between income and diet energy intake. In this project, we are going to explore the correlation between income and energy intake using NHANE 2017-2018 diet data. Additionally, we will also take some other demographic variables like age, rurality, and gender into consideration.  By exploring the influence they play on our core relationship and the marginal effect might bring us some interesting findings.

### Data:
[NHANES 2017-2018 Dietary Data](https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=Dietary&CycleBeginYear=2017) <br>
[NHANES 2017-2018 Demographics Data](https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=Demographics&CycleBeginYear=2017)


### Variables
Variable `Original Name` | Description
------------ | ------------------------------------------------------------
id `SEQN` | unique respondent sequence number
energy intake `DR1KTCAL` | energy intake of the investigated date (kcal)
poverty income ratio `INDFMPIR` | using as the criterion for household income 
gender `RIAGENDER` | respondent gender
age `RIDAGEYR` | respondent age
age_group | divide age into 'child', 'teenager', 'adult', and 'elder'
pregnancy `RIDEXPRG` | status of respondent's pregnancy
num_people_hd `DMDHHSIZ`| number of people in the household
num_people_fm `DMDFMSIZ`| number of people in the family
weight `WTDRD1` | using for sample weights
psu `SDMVPSU` | using for survey design (cluster)
strata `SDMVSTRA` | using for survey design (strata)

### Methods
The whole analysis contains 3 parts: 

*  Data cleaning: Merge the dataset, select variables we want, and remove the *NA* values from our data.
*  Model selection: Residual diagnosis & normality checking for model selection. 
*  Main analysis: 
We use the generalized linear model (GLM) with a Gamma link function to analyze the effect of `income` (our focus) and other interesting & influential factors like `gender` and `age`.
    * `income`: 
        +  Part1: Using `pir` as the only predictor. A 95% confidence level t-test is implemented to test the effect of income by using the model coefficient summary.
        +  Part2: Using all possible variables as predictors. Another 95% confidence level t-test is implemented to test the effect of income taking into consideration other factors.
    *  `gender`: A one-way ANOVA test is implemented. We use Tukey's Honest Significant Difference 95% confidence interval to test the difference between *male* and *female*.
    *  `age`: Here we divide age into 4 different groups. A one-way ANOVA test is implemented. For all pairwise comparisons between age groups, we use Tukey's Honest Significant Difference 95% confidence interval. Additionally, a regression spline analysis is implemented to describe the various pattern among different age groups.


### Software/Tools:
* R – tidyverse, survey, splines, ggplot2


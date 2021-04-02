library(tidyverse)
library(here)
library(broom)
library(QuantPsyc)
library(lmSupport)

ug_data <- read_csv(here("data", "undergrad_data.csv"))

### Create exam composite

ug_data <- ug_data %>%
  mutate(exam_total = ug_data %>%
           dplyr::select(contains("Exam")) %>%
           rowMeans())

### Model exam total and proj total

exam_model <- lm(exam_total ~ Metacog. + SelfEfficacy + IntGoalOrient + ExtGoalOrient, data = ug_data)
proj_model <- lm(PROJ_TOTAL ~ Metacog. + SelfEfficacy + IntGoalOrient + ExtGoalOrient, data = ug_data)

### Look at model diagnostics, compare



### Extract Coefficients and compare


### Compare standardized coefficients


### add predictors and compare models




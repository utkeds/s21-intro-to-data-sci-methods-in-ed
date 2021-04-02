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

exam_model <- lm(exam_total ~ Metacog. + SelfEfficacy + 
                   IntGoalOrient + ExtGoalOrient, data = ug_data)
proj_model <- lm(PROJ_TOTAL ~ Metacog. + SelfEfficacy + 
                   IntGoalOrient + ExtGoalOrient, data = ug_data)

summary(exam_model)
summary(proj_model)

### Look at model diagnostics, compare

glance(exam_model)
glance(proj_model)

rbind(glance(exam_model),
      glance(proj_model))

### Extract Coefficients and compare

te <- tidy(exam_model)
tp <- tidy(proj_model)

tibble(te$term, te$estimate, tp$estimate)

### Compare standardized coefficients

lm.beta(exam_model)
lm.beta(proj_model)

tibble(names(lm.beta(exam_model)), lm.beta(exam_model),
        lm.beta(proj_model))

### add predictors and compare models

exam_model2 <- lm(exam_total ~ Metacog. + SelfEfficacy + 
                   IntGoalOrient + ExtGoalOrient + extraversion + 
                    agreeableness + conscient. + stability + openness,
                  data = ug_data)

proj_model2 <- lm(PROJ_TOTAL ~ Metacog. + SelfEfficacy + 
                   IntGoalOrient + ExtGoalOrient + extraversion +
                  agreeableness + conscient. + stability + openness, 
                  data = ug_data)

exam_model <- lm(exam_total ~ Metacog. + SelfEfficacy + 
                   IntGoalOrient + ExtGoalOrient, data = model.frame(exam_model2$model))
proj_model <- lm(PROJ_TOTAL ~ Metacog. + SelfEfficacy + 
                   IntGoalOrient + ExtGoalOrient, data = model.frame(proj_model2$model))

modelCompare(exam_model, exam_model2)
modelCompare(proj_model, proj_model2)

library(dataedu)
library(corrr)
library(skimr)
library(visdat)
library(sjPlot)
library(psych)
library(ggplot2)
library(dplyr)

data(sci_mo_processed)

View(sci_mo_processed)

vis_dat(sci_mo_processed)

kable(skim(sci_mo_processed))

unique(sci_mo_processed$student_id)

describe(sci_mo_processed)


sci_mo_processed %>% select(starts_with("q")) %>%
  correlate() %>%
  rplot()


sci_mo_processed %>% select(starts_with("q")) %>%
    describe() %>%
      ggplot() +
        geom_col(aes(x= vars, y = sd))


fit <- lm(FinalGradeCEMS ~ TimeSpent + Gender + TimeSpent*Gender, data = sci_mo_processed)
summary(fit)

tab_model(fit)





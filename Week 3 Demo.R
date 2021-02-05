library(here)
library(dplyr)
library(readr)
library(magrittr)
library(stringr)
library(readr)
library(janitor)

data <- readr::read_csv(here("data", "answer_export.csv"))

colnames(data)
names(data)


data <- data %>%
  rename(ID_num = id,
         Response = content,
         Session_num = session_id,
         Question_num = question_id)

colnames(data)

table(data$Response)
tabyl(data$Response)



data_subset <- data %>%
  rename(ID_num = id,
         Response = content,
         Session_num = session_id,
         Question_num = question_id) %>%
  select(Response, Question_num)


data_grp <- data_subset %>%
  group_by(Question_num)


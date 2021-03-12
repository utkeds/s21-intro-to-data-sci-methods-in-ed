library(here)
library(dplyr)
library(readr)
library(magrittr)
library(tidyr)
library(stringr)

twilio_data <- read_csv(here("data", "twilio_data.csv"))
database_data <- read_csv(here("data", "database_data.csv"))

# Pivot database data wider

data <- database_data %>% select(question_id, content, assign, survey_id) %>% filter(!is.na(database_data$survey_id))

temp <- pivot_wider(data, names_from = question_id, values_from = content, names_prefix = "Question_", values_fn = first)

# repivot database data longer



# join data 

temp <- left_join(database_data, twilio_data, by = "session_id")

joined <- inner_join(database_data, twilio_data)

rbind()


# summary

joined %>% filter(content %in% c("1", "2", "3", "4", "5")) %>%
  mutate(content = as.numeric(content)) %>%
  group_by(question_id) %>%
  summarize(mean(content))


joined %>% group


# grouped operations




joined <- inner_join(database_data, twilio_data) %>% 
  select(assign, content, question_id, survey_id, From, SentDate) %>%
  filter(content %in% c("1", "2", "3", "4", "5")) %>%
  mutate(content = as.numeric(content)) %>%
  pivot_wider(id_cols = c(survey_id, assign, From), names_from = question_id, values_from = content, names_prefix = "Question_", values_fn = first) %>% 
  group_by(From) %>% summarize(Q1_mean = mean(Question_1), Q2_mean = mean(Question_2), Q3_mean = mean(Question_3), Q4_mean = mean(Question_4), Q5_mean = mean(Question_5))


joined <- inner_join(database_data, twilio_data) %>% 
  select(assign, content, question_id, survey_id, From, SentDate) %>%     
  filter(content %in% c("1", "2", "3", "4", "5")) %>%
  mutate(content = as.numeric(content)) %>%
  group_by(From, question_id) %>%
  summarize(mean(content))

# this gets rid of completely duplicated ones, and then just takes the first one where they responded differently both times
# not sure of the ordering, but could go back and try to figure out how to take first or last, but it probably doesn't 
# matter that much

clean <- group_by(cleaned, From, survey_id) %>%
  select(sid, assign, content, question_id, survey_id, From) %>%
  distinct() %>% 
  group_by(From, survey_id, question_id) %>% 
  slice(1)


#### Getting rid of multiple generated surveys in cosc 111

clean_grp <- clean %>% 
  group_by(assign, From, sid) %>% 
  tally() %>%
  unite(assign_from, assign, From, remove = FALSE) %>%
  arrange(desc(n)) %>%
  mutate(dupes = duplicated(assign_from)) %>% 
  ungroup() %>%
  left_join(clean, .) %>%
  filter(dupes == FALSE) %>%
  mutate(dupes = NULL, n = NULL, assign_from = NULL)

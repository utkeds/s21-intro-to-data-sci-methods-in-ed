library(here)
library(dplyr)
library(readr)
library(magrittr)
library(tidyr)
library(stringr)

twilio_data <- read_csv(here("data", "twilio_data.csv"))
database_data <- read_csv(here("data", "database_data.csv"))


# Pivot database data wider


# repivot database data longer



# join data 





# grouped operations








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

library(tidyverse)
library(readxl)
library(janitor)

ngss_adoption <- read_excel("data/ngss-adoption.xlsx")

ngss_adoption <- ngss_adoption %>% 
  janitor::clean_names()

ngss_adoption %>% 
  mutate(year = parse_number(dataset)) %>% 
  select(year, location, contains("category")) %>% 
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = reorder(location, category_yes), y = category_yes, fill = year)) +
  geom_col(position = "dodge") +
  coord_flip() +
  theme_minimal() +
  xlab(NULL) +
  scale_fill_brewer(NULL, type = "qual") +
  theme(text = element_text(size = 14)) +
  ylab("% of Respondents Indicating Their School is Teaching the NGSS")

ngss_adoption %>% 
  mutate(year = parse_number(dataset)) %>% 
  select(year, location, contains("category")) %>% 
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = reorder(location, category_yes), y = category_yes)) +
  geom_col() +
  facet_wrap(~year) +
  coord_flip() +
  theme_minimal() +
  xlab(NULL) +
  scale_fill_brewer(NULL, type = "qual") +
  theme(text = element_text(size = 14)) +
  ylab("% of Respondents Indicating Their School is Teaching the NGSS")

ngss_adoption %>% 
  mutate(year = parse_number(dataset)) %>% 
  select(year, location, contains("category")) %>% 
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(category_yes, x = year, group = location, color = location)) +
  geom_point() +
  geom_line() +
  #geom_col(~location) +
  # facet_wrap(~year) +
  theme_minimal() +
  xlab(NULL) +
  scale_fill_brewer(NULL, type = "qual") +
  theme(text = element_text(size = 14)) +
  ylab("% of Respondents Indicating Their School is Teaching the NGSS")

ngss_adoption %>% 
  mutate(year = parse_number(dataset)) %>% 
  select(year, location, contains("category")) %>% 
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(category_yes, x = year, group = location)) +
  geom_point() +
  geom_line() +
  facet_wrap(~location) +
  theme_minimal() +
  xlab(NULL) +
  scale_fill_brewer(NULL, type = "qual") +
  theme(text = element_text(size = 14)) +
  ylab("% of Respondents Indicating Their School is Teaching the NGSS") +
  theme(legend.position = "none")

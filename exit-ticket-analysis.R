# analysis of exit tickets

library(tidyverse)
library(googlesheets4)

s <- read_sheet("https://docs.google.com/spreadsheets/d/1mPvUnPlwzDbVyqjA6ymekH8hh0CVnCyA4q2FrikmTG8/edit#gid=0",
                skip = 1)

key <- read_sheet("https://docs.google.com/spreadsheets/d/1w5d7Rt7vNP8SFkNlyGqvXqSw9SXI5_NSB-y9EWPfH-E/edit#gid=0")


s <- s %>% 
  janitor::clean_names()

# by week

s %>% 
  select(-last_name) %>% 
  gather(key, val, -full_name) %>% 
  filter(!str_detect(key, "comments")) %>% 
  mutate(val = as.numeric(val)) %>% 
  filter(!is.na(full_name)) %>% 
  separate(key, into = c("var", "week")) %>% 
  mutate(week = rep(1:13, each = 19*3)) %>% 
  ggplot(aes(x = week, y = val, group = var, color = var)) +
  geom_smooth(se = TRUE) +
  theme_bw() +
  scale_color_brewer("", type = "qual") +
  ylab("Rating") +
  xlab("Week")

# by hw focus

s %>% 
  select(-last_name) %>% 
  gather(key, val, -full_name) %>% 
  filter(!str_detect(key, "comments")) %>% 
  mutate(val = as.numeric(val)) %>% 
  filter(!is.na(full_name))  %>% 
  separate(key, into = c("var", "week")) %>% 
  mutate(week = rep(1:13, each = 19*3)) %>% 
  filter(week != 10) %>% 
  ggplot(aes(x = week, y = val, group = var, color = var)) +
  geom_smooth(se = TRUE) +
  theme_bw() +
  scale_color_brewer("", type = "qual") +
  ylab("Rating") +
  xlab("Week") + 
  scale_x_continuous(breaks = 1:13, labels = key$Focus[c(1:9, 11:14)]) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# by student

s %>% 
  select(-last_name) %>% 
  gather(key, val, -full_name) %>% 
  filter(!str_detect(key, "comments")) %>% 
  mutate(val = as.numeric(val)) %>% 
  mutate(val = if_else(val >= 5, 5, val)) %>% 
  filter(!is.na(full_name)) %>% 
  separate(key, into = c("var", "week")) %>% 
  mutate(week = rep(1:13, each = 19*3)) %>% 
  ggplot(aes(x = week, y = val, group = var, color = var)) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x + I(x^2) + I(x^3), size = 1, se = FALSE) +
  facet_wrap(~full_name) +
  theme_bw() +
  scale_color_brewer("", type = "qual") +
  ylab("Rating") +
  xlab("Week")

s %>% 
  slice(20) %>% 
  gather(key, val) %>% 
  filter(!str_detect(key, "comments")) %>%
  slice(3:nrow(.)) %>% 
  mutate(val = as.numeric(val)) %>% 
  separate(key, into = c("var", "week")) %>% 
  mutate(week = rep(1:13, each = 3)) %>% 
  ggplot(aes(x = week, y = val, group = var, color = var)) +
  geom_point() +
  geom_line() +
  theme_bw()

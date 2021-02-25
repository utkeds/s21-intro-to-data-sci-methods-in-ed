##library(tidyverse)
library(tidyverse)
library(here)

database <- read_csv(here("data", "database_data.csv"))
twilio <- read_csv(here("data", "twilio_data.csv"))

# join select mutate without pivot
joined_long <- dplyr::inner_join(database, twilio) %>% 
  select(content, question_id, From, assign) %>%
  mutate(content = as.numeric(str_extract(content, "[12345]{1}")))


# basic plots, hist, plot, boxplot
hist(joined_long$content)
plot(joined_long$question_id, joined_long$content)
boxplot(content ~ question_id, data = joined_long)

# better versions with ggplot


# group by question id and summarize content
jdf <- joined_long %>% group_by(question_id) %>%
  summarize(content_mean = mean(content, na.rm = T))

# basic plot question means
plot(jdf$question_id, jdf$content_mean, ylim = c(1,5))

# better plot question means
ggplot(jdf) +
  geom_col(aes(x=question_id, y=content_mean)) +
  xlab() + 
  ylab() +
  ggtitle()

# join with pivot
joined <- dplyr::inner_join(database, twilio) %>% 
  dplyr::select(content, question_id, survey_id, From, assign) %>%
  dplyr::mutate(content = as.numeric(str_extract(content, "[12345]{1}"))) %>%
  tidyr::pivot_wider(id_cols = c(survey_id, From, assign), names_from = question_id, 
                     values_from = content, names_prefix = "Question_", values_fn = first)

# group and summarize by number            
summ_df <- joined %>% group_by(From) %>%
  summarize(assign = first(assign), Q1M = mean(Question_1), Q2M = mean(Question_2), Q3M = mean(Question_3), Q4M = mean(Question_4), Q5M = mean(Question_5))


# simple histogram
hist(joined$Question_3)

# histogram of means
hist(summ_df$Q3M)

# better histogram of means
ggplot(summ_df) + 
  geom_histogram(aes(x = Q3M), fill = "red", color = "blue", bins = 50) +
  xlab("Frustration Level 1-5") +
  ggtitle("Histogram: Frustration level")


# recode time points

joined$timepoint <- recode(joined$assign, `Lab 1a` = 1, `Lab 1b` = 3, `Lab 2a` = 4, `Lab 2b` = 6, `Lab 3a` = 8, `Lab 3b` = 10, 
                           `Lab 4a` = 11, `Lab 4b` = 13, `Lab 5a` = 15, `Lab 5b` = 16, `Lab 6` = 18, `Exam 1` = 2,`Exam 2` = 7,
                           `timed 1` = 5, `timed 2` = 9, `timed 3` = 12, `timed 4` = 14, `timed 5` = 17)


summ_df$timepoint <- recode(summ_df$assign, `Lab 1a` = 1, `Lab 1b` = 3, `Lab 2a` = 4, `Lab 2b` = 6, `Lab 3a` = 8, `Lab 3b` = 10, 
                            `Lab 4a` = 11, `Lab 4b` = 13, `Lab 5a` = 15, `Lab 5b` = 16, `Lab 6` = 18, `Exam 1` = 2,`Exam 2` = 7,
                            `timed 1` = 5, `timed 2` = 9, `timed 3` = 12, `timed 4` = 14, `timed 5` = 17)


# group and summarize by assignment
summ_df <- joined %>% group_by(assign) %>%
  summarize(Q1M = mean(Question_1, na.rm = T), Q2M = mean(Question_2), Q3M = mean(Question_3), Q4M = mean(Question_4), Q5M = mean(Question_5))

# plot assignment against timepoint
ggplot(summ_df) +
  geom_col(aes(timepoint, Q1M), fill = "blue") +
  ylab("Mean") +
  xlab("Survey Number") +
  ggtitle("I feel challenged")


# When a factor can be important

# try this first, explain why not right

joined %>% group_by(assign) %>%
ggplot() +
  geom_boxplot(aes(timepoint, Question_1))

library(forcats)

joined_new <- joined %>% 
  mutate(timepoint = as.factor(timepoint))

joined_new %>%
  group_by(assign) %>%
  ggplot() +
    geom_boxplot(aes(timepoint, Question_1)) 

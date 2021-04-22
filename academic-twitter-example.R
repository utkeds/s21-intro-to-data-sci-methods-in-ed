# devtools::install_github("cjbarrie/academictwitteR")
# install.packages("rtweet")

library(academictwitteR)
library(rtweet)
library(tidyverse)

all_aera_tweets <- c(str_c("#AERA", 14:21), str_c("AERA20", 14:21)) %>% 
  map(get_hashtag_tweets, "2010-01-01T00:00:00Z", "2021-04-17T00:00:00Z", bearer_token = Sys.getenv("bearer_token"), data_path = "twitter-data-aera/")

hashtags_to_search <- c(str_c("#AERA", 19:21), str_c("AERA20", 19:21)) %>% 
  paste0(collapse = " OR ")

get_hashtag_tweets(hashtags_to_search, "2010-01-01T00:00:00Z", "2021-04-17T00:00:00Z", bearer_token = Sys.getenv("bearer_token"), data_path = "twitter-data-aera-new/")

tweets %>% write_rds("data/aera-tweets-unproc.rds")

tweets_proc <- tidytags::lookup_many_tweets(tweets$id)

tweets_proc %>% write_rds("data/aera-tweets.csv")

library(quanteda)

d <- read_rds("~/s21-intro-to-data-sci-methods-in-ed/data/aera-tweets.rds")

# https://www.tidytextmining.com/sentiment.html
library(janeaustenr)
library(stringr)
library(tidytext)

austen_books()

tidy_books <- d %>% 
  select(created_at, text) %>% 
  unnest_tokens(word, text)

library(googlesheets4)
library(lubridate)

conf_dates <- read_sheet("https://docs.google.com/spreadsheets/d/1lBg1zMUtUYOwS2kWm1hAaW5dZ2iWc-R5013wTubjG_Q/edit#gid=0")

conf_dates <- janitor::clean_names(conf_dates)

my_interval <- interval(start = conf_dates$start_date - days(3),
         end = conf_dates$end_date + days(3))

my_interval

int_midpoint <- function(interval) {
  int_start(interval) + (int_end(interval) - int_start(interval))/2
}

tidy_books_f <- tidy_books %>% 
  filter(created_at %within% my_interval)

tidy_proc <- tidy_books_f %>%
  inner_join(get_sentiments("bing")) %>% 
  mutate(day = lubridate::round_date(created_at, "day")) %>% 
  count(day, sentiment)

tidy_proc

tidy_proc_tm <- tidy_proc %>% 
  mutate(day = lubridate::round_date(day, "day"),
         week = lubridate::round_date(day, "week"),
         month = lubridate::round_date(day, "month"),
         year = lubridate::year(day),
         yday = lubridate::yday(day))

mid_points <- int_midpoint(my_interval)

mid_points <- tibble(year = 2014:2021,
       mid_point = mid_points)

tidy_proc_tm %>% 
  ggplot(aes(x = yday, y = n, group = sentiment, color = sentiment)) +
  geom_line() +
  geom_point() +
  facet_wrap("year", scales = "free_x") +
  theme_minimal() +
  scale_color_brewer("Sentiment", type = "qual") +
  ylab("Number of Tweets") +
  xlab("Day of the Year")

ggsave("aera-sentiment-by-year.png", width = 10, height = 10)

d <- mutate(d, day = lubridate::round_date(created_at, "day"),
            week = lubridate::round_date(created_at, "week"),
            month = lubridate::round_date(created_at, "month"),
            year = lubridate::round_date(created_at, "year"),
            yday = lubridate::yday(created_at))

# quanteda

c <- corpus(d, text_field = "text")

toks_news <- tokens(c, remove_punct = TRUE)

# select only the "negative" and "positive" categories
data_dictionary_LSD2015_pos_neg <- data_dictionary_LSD2015[1:2]

data_dictionary_LSD2015_pos_neg

toks_gov_lsd <- tokens_lookup(toks_news, dictionary = data_dictionary_LSD2015_pos_neg)

# create a document document-feature matrix and group it by day
dfmat_gov_lsd <- dfm(toks_gov_lsd) %>% 
  dfm_group(groups = c("week"))

tp <- dfmat_gov_lsd %>% 
  as_tibble() %>% 
  mutate(ratio = negative/positive) %>% 
  mutate(date = lubridate::ymd(doc_id)) %>% 
  mutate(yday = lubridate::yday(date)) %>% 
  mutate(day = lubridate::day(date)) %>% 
  mutate(week = lubridate::week(date)) %>% 
  mutate(month = lubridate::month(date)) %>% 
  mutate(year = lubridate::year(date)) %>% 
  filter(month == 4,
         year > 2014)

tp

  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = day, y = ratio, color = year, group = year)) +
  geom_smooth(se = FALSE) +
  scale_color_brewer()

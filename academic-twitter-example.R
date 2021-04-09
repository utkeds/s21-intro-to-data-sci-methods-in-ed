# devtools::install_github("cjbarrie/academictwitteR")
# install.packages("rtweet")

library(academictwitteR)
library(rtweet)
library(tidyverse)

str_c("#AERA", 14:21) %>% 
  map(get_hashtag_tweets, "2010-01-01T00:00:00Z", "2021-04-05T00:00:00Z", bearer_token = Sys.getenv("bearer_token"), data_path = "twitter-data/")

get_hashtag_tweets("#AERA21", "2010-01-01T00:00:00Z", "2021-04-08T00:00:00Z", bearer_token = Sys.getenv("bearer_token"), data_path = "twitter-data/")

tweets_processed <- lookup_statuses(d$id)
tweets_processed

ds <- d[90000:nrow(d), ]

tweets_processed_s <- lookup_statuses(ds$id)

dd <- tweets_processed %>% 
  bind_rows(tweets_processed_s)

write_rds(dd, "data/aera-tweets.rds")

library(quanteda)

d <- readRDS("~/s21-intro-to-data-sci-methods-in-ed/data/aera-tweets.rds")
# tokenize corpus

d <- mutate(d, day = lubridate::round_date(created_at, "day"),
            week = lubridate::round_date(created_at, "week"),
            month = lubridate::round_date(created_at, "month"))

c <- corpus(d, text_field = "text")

toks_news <- tokens(c, remove_punct = TRUE)

# select only the "negative" and "positive" categories
data_dictionary_LSD2015_pos_neg <- data_dictionary_LSD2015[1:2]

toks_gov_lsd <- tokens_lookup(toks_news, dictionary = data_dictionary_LSD2015_pos_neg)

# create a document document-feature matrix and group it by day
dfmat_gov_lsd <- dfm(toks_gov_lsd) %>% 
  dfm_group(groups = "day")

dfmat_gov_lsd %>% 
  as_tibble() %>% 
  mutate(date = lubridate::ymd(doc_id)) %>% 
  ggplot(aes(x = date, y = negative)) +
  geom_point() +
  geom_smooth()
```
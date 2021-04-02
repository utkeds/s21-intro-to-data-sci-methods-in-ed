library(tidyverse)
library(readxl)
library(janitor)

ngss_adoption <- read_excel("data/ngss-adoption.xlsx")

ngss_adoption <- ngss_adoption %>% clean_names()

ngss_adoption <- ngss_adoption %>% 
  mutate(year = parse_number(dataset))

ngss_adoption

ngss_adoption %>% 
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = location, y = category_yes, fill = year)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = category_yes - (margin_of_error_yes / 2),
                    ymax = category_yes + margin_of_error_yes / 2),
                position = "dodge") +
  theme_minimal() +
  xlab(NULL) +
  theme(text = element_text(size = 14)) +
  ylab("% of Respondents Indicating Their School is Teaching the NGSS") +
  geom_hline(yintercept = 50, linetype = "dashed") +
  coord_flip() +
  scale_fill_brewer(type = "qual")



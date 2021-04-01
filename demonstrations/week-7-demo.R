library(tidyverse)
library(readxl)
library(janitor)

ngss_adoption <- read_excel("data/ngss-adoption.xlsx")
ngss_states <- read_excel("data/ngss-adoption-states.xlsx")

ngss_adoption
ngss_states

ngss_adoption$Location
ngss_states$location

ngss_data <- ngss_adoption %>% 
  rename(location = Location) %>% 
  left_join(ngss_states)

ngss_data

ngss_data <- ngss_data %>% 
  janitor::clean_names()

ngss_data <- ngss_data %>% 
  mutate(year = parse_number(dataset))

ngss_data <- ngss_data %>% 
  mutate(location_fct = fct_reorder(location, category_no))

ngss_data %>% 
  mutate(margin_of_error_yes)

ngss_data %>% 
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = location_fct, y = category_yes, fill = year)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = category_yes - (margin_of_error_yes / 2),
                    ymax = category_yes + margin_of_error_yes / 2),
                position = "dodge") +
  theme_minimal() +
  xlab(NULL) +
  theme(text = element_text(size = 14)) +
  ylab("% of Respondents Indicating Their School is Teaching the NGSS") +
  geom_hline(yintercept = 50, linetype = "dashed") +
  coord_flip()

ngss_data %>% 
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(category_yes, x = year, group = location_fct)) +
  geom_point() +
  geom_line() +
  facet_wrap(~location_fct) +
  theme_minimal() +
  xlab(NULL) +
  scale_fill_brewer(NULL, type = "qual") +
  theme(text = element_text(size = 14)) +
  ylab("% of Respondents Indicating Their School is Teaching the NGSS") +
  theme(legend.position = "none")

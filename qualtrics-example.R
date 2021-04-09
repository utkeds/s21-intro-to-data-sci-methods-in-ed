library(qualtRics)
library(tidyverse)

# qualtRics::all_surveys()

description <- c("effectiveness - communication",
                 "effectiveness - summer",
                 "end-of-day survey",
                 "post-summer survey",
                 "pre-summer survey",
                 "end-of-day survey",
                 "end-of-day survey",
                 "end-of-day survey",
                 "end-of-day survey",
                 "post-summer survey",
                 "effectiveness - summer",
                 "effectiveness - GIS",
                 "post-GIS survey",
                 "pre-GIS survey"
)

survey_id <- c("SV_3IP9R9vFxZ7qGUe",
               "SV_bJEe2AWjZdH4dcp",
               "SV_81baWN1LtwNzV9r",
               "SV_5jue08g3DvyGlmd",
               "SV_6s9qu47PyM0js8t",
               "SV_5iNHeOZns6zzxat",
               "SV_9uhuHORliSFZq6x",
               "SV_d0EQx7RXOZxasT3",
               "SV_a46oo0Kklrlnh0F",
               "SV_e2PwPb0wmRAWCcl",
               "SV_9Zz8bjbBUPw1K4t",
               "SV_cFRH5pgKwnYJRLT",
               "SV_8HVSt4wfW3Hj2pn",
               "SV_6AoaxSCPgUlfNUV"
)

my_surveys <- tibble(description = description,
                     survey_id = survey_id)

all_surveys <- my_surveys$survey_id %>% map(getSurvey)

my_surveys_end_of_day <- my_surveys %>% 
  filter(description == "end-of-day survey")

all_end_of_day_surveys <- my_surveys_end_of_day$survey_id %>% map_df(getSurvey)

# qualtRics::getSurveyQuestions("SV_3IP9R9vFxZ7qGUe")

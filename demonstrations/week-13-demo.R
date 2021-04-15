
library(tidyverse)
library(here)

## Option A

pfi <- read_csv(here("data", "COVID", "COVID-19_Vaccine_Distribution_Allocations_by_Jurisdiction_-_Pfizer.csv"))
mod <- read_csv(here("data", "COVID", "COVID-19_Vaccine_Distribution_Allocations_by_Jurisdiction_-_Moderna.csv"))
jan <- read_csv(here("data", "COVID", "COVID-19_Vaccine_Distribution_Allocations_by_Jurisdiction_-_Janssen.csv"))


## Option B

vaccines <- c("Pfizer", "Moderna", "Janssen")
file_base <- "/COVID-19_Vaccine_Distribution_Allocations_by_Jurisdiction_-_"
file_ext <- ".csv"

file_names <- str_c(here("data", "COVID"), file_base, vaccines, file_ext)

vax_files <- file_names %>% map(read_csv)
names(vax_files) <- vaccines

### it's 3 lines vs 6, but if I had 50 files it'd still be 6


### Rename

# write my rename function
rename_vaccine_data <- function(dat){
  dat <- dat %>% rename("State" = "Jurisdiction",
                 "Week" = "Week of Allocations",
                 "First Dose" = "1st Dose Allocations",
                 "Second Dose" = "2nd Dose Allocations")
  dat
}

# map it to every data set in the list
vax_files %>% map(rename_vaccine_data)


# but it doesn't work, need to account for differences 
rename_vaccine_data <- function(dat){
  if(ncol(dat) == 4){
    dat <- dat %>% rename("State" = "Jurisdiction",
                          "Week" = "Week of Allocations",
                          "First Dose" = "1st Dose Allocations",
                          "Second Dose" = "2nd Dose Allocations")
    dat
  } else {
    dat <- dat %>% rename("State" = "Jurisdiction",
                          "Week" = "Week of Allocations",
                          "First Dose" = "1st Dose Allocations")
    dat
  }

}

# but that's still not the best option, if I had different #s of columns, I might have to do things differently



library(mice)
library(visdat)
library(tidyverse)
library(here)

ug_data <- read_csv(here("data", "undergrad_data.csv"))

vis_dat(ug_data)


na.omit(ug_data)




library(magrittr)
library(dplyr)
library(tidyr)

ds_class <- read.csv("~/ds class list.csv", header = FALSE)
colnames(ds_class) <- "names"

sample(ds_class, size = 1)
split()

rand <- sample(ds_class$names)
num_groups = 6

sample_n(ds_class, 26) %>% 
  group_by((row_number()-1) %/% (n()/num_groups)) %>%
  nest %>% pull(data)


# [[1]]
#             
# 1 Anna Marie Jackson     
# 2 Timara Barker McCollum 
# 3 Jennifer Shearer Miller
# 4 Jeremiah Muhammad 
# 5 Esther Anne Michela    
# 
# [[2]]
#               
# 1 Radion Svynarenko     
# 2 Mason Douglas Boyd    
# 3 Patricia Jerilyn Aubel
# 4 Alan B Shorey         
# 
# [[3]]
#                         
# 1 George Thomas Fields          
# 2 Rachel Elaine Williams        
# 3 Kristen R Secora              
# 4 Sadie Virginia Counts  
# 
# [[4]]
#                  
# 1 Omiya Sultana    
# 2 Matt Hoover               
# 3 Anurag Shukla
# 4 Justin Allen Rose         
# 5 Marissa Bartmess          
# 
# [[5]]
#            
# 1 Emily Ann McDonald 
# 2 Michael James Mann
# 3 Ashley West       
# 4 Katherine Trubee  
# 
# [[6]]
#                    
# 1 Will Andershock     
# 2 Travis Crum         
# 3 Kristin Schrader       
# 4 Sarah Christine Narvaiz


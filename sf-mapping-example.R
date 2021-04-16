library(sf)
library(tidyverse)

points <- data.frame(lon = c(-65,-60, -55, -83.92, -84.55), lat = c(50, 45, 40, 35.96, 42.73))

points

points <- st_as_sf(points, coords = c("lon", "lat"))

points$name <- c("random_place_c", "random_place_b", "random_place_c", "knoxville", "lansing")

points

st_drop_geometry(points)

points %>% 
  filter(!str_detect(name, "random_place"))

library(USAboundaries)

USA <- us_boundaries()

USA # ntoe the type of output - same as what we get from our st_as_sf()

USA <- st_set_crs(USA, "4269")

points_within_USA <- st_within(points, USA)

points_within_USA

# USA[as.integer(points_within_USA), ] %>% 
#   filter(!is.na(name))
# 
# USA[as.integer(points_within_USA), "name"] %>% 
#   filter(!is.na(name))

ggplot() +
  geom_sf(data = filter(USA, name != "Hawaii" & name != "Alaska")) +
  geom_sf(data = points)

library(tidyverse)
library(janitor)

# 3.1 Writing function/program to process data from an external file

meteorites <- read_csv("data/meteorite_landings.csv")

meteorites <- meteorites %>% 
  clean_names() %>% 
  separate(geo_location, c("latitude", "longitude"), ",") %>% 
  mutate(latitude = str_remove(latitude, "\\("),
         longitude = str_remove(longitude, "\\)")) %>% 
  transform(latitude = as.numeric(latitude),
            longitude = as.numeric(longitude)) %>% 
  mutate(latitude = ifelse(is.na(latitude), 0, latitude),
         longitude = ifelse(is.na(longitude), 0, longitude)) %>% 
  filter(mass_g >= 1000) %>% 
  arrange(year)

write_csv(meteorites, "data/meteorites.csv")





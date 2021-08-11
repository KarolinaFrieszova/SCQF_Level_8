library(tidyverse)
library(janitor)
library(assertr)

# 3.1 Writing function/program to process data from an external file

meteorites <- read_csv("data/meteorite_landings.csv")

stopifnot(names(meteorites) == c("id", "name", "mass (g)", 
                                   "fall", "year", "GeoLocation"))

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


report_meteorites <- function(meteorites){
  
  meteorites %>% 
    verify(latitude >= - 90 & latitude <= 90) %>% 
    verify(longitude >= -180 & longitude <= 180)
  
  report <- meteorites %>% 
    summarise(max_latitude = max(latitude),
              min_latitude = min(latitude),
              max_longitude = max(longitude),
              min_longitude = min(longitude))
  return(report)
}
report_meteorites(meteorites)

write_csv(meteorites, "data/meteorites.csv")




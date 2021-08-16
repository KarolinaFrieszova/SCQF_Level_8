library(tidyverse)
library(janitor)
library(assertr)

# 3.1. Writing function/program to process data from an external file 
meteorites <- read_csv("data/meteorite_landings.csv")


stopifnot(names(meteorites) == c("id", "name", "mass (g)", 
                                   "fall", "year", "GeoLocation"))


# 3.3 Writing function/program to clean data
meteorites <- meteorites %>% 
  clean_names() %>% # change column names to follow naming standards
  separate(geo_location, c("latitude", "longitude"), ",") %>% # split column into two
  mutate(latitude = str_remove(latitude, "\\("), # remove special char - brackets
         longitude = str_remove(longitude, "\\)")) 


# 3.4. Writing function/program to wrangle data
meteorites <- meteorites %>% 
  transform(latitude = as.numeric(latitude), # convert columns to numeric
            longitude = as.numeric(longitude)) %>% 
  mutate(latitude = ifelse(is.na(latitude), 0, latitude), # replace missing values with zeros
         longitude = ifelse(is.na(longitude), 0, longitude)) %>% 
  filter(mass_g >= 1000) %>% # remove meteorites less than 1000g in weight from the data
  arrange(year) # order the data by the year of discovery



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

write_csv(meteorites, "data/meteorites_landings_clean.csv")




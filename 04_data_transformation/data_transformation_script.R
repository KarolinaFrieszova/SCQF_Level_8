library(tidyverse)
# --- 1 ---
toy_transactions <- read_csv("raw_data/toy_transactions.csv")

# create a column date from the day, month and year columns
toy_transactions$date<-as.Date(with(toy_transactions,paste(year,month,day,sep="-")),"%Y-%m-%d")

toy_transactions <- toy_transactions %>% 
  select(-c(year,month,day))

# --- 2 ---
# Convert the weight column to numeric
toys <- 
  read_csv("raw_data/toys.csv") %>% 
  mutate(weight = str_replace_all(weight, "[ g]", "")) %>% 
  mutate(weight = as.numeric(weight)) %>% 
  #Split the extra information from the product into a new column
  separate(product, c("product_name", "product_title"), " - ")

# --- 3 ---
# Remove the unnecessary information for each descriptor
quality <- 
  read_csv("raw_data/quality.csv") %>% 
  mutate(description = str_replace_all(description, "Quality: ", "")) %>% 
  # Replace the categories so ‘Awesome’ and ‘Very Awesome’ become ‘Good’ and ‘Very Good’. Do the same thing for ‘Awful’ replacing it with ‘Bad’
  mutate(description = case_when(
    description == "Very Awesome" ~ "Very Good",
    description == "Awesome" ~ "Good",
    description == "Very Awful" ~ "Very Bad",
    description == "Awful" ~ "Bad",
    TRUE ~ description
  ))

# --- 4 ---
# create a dataframe called customers which contains data on customers from all countries by reading in and binding all customer datasets in one pipeline

library(fs)

# store the location of the unzipped folder in data_dir
data_dir <- "raw_data"

#list the CSV files
fs::dir_ls(data_dir)

#limit directory listing to just the customers files
customers <- fs::dir_ls(data_dir, regexp = "\\customers.csv$")


customers <- customers %>% 
  purrr::map_dfr(read_csv) 

# --- 5 ---
# Impute missing values in numeric columns with the median value of customers with the same gender and country
customers <- customers %>% 
  group_by(customer_country, customer_gender) %>% 
  mutate_if(is.numeric,
            function(x) ifelse(is.na(x),
                               median(x, na.rm = TRUE),
                               x))

# --- 7 ---
# join your four cleaned datasets, keep all observations
toys_joined <- full_join(toy_transactions, customers, by = c("customer_id" = "id")) 

toys_joined <- full_join(toys_joined, toys, by = c("toy_id" = "id"))

toys_joined <- full_join(toys_joined, quality, by = c("quality" = "id"))

# --- 9 ---
# Remove any personally identifiable or sensitive information on customers
toys_joined <- toys_joined %>% 
  select(-c(first_name, last_name, customer_height_cm, customer_weight_kg)) %>% 
  rename(toy_weight_g = weight,
         quality_description = description,
         transaction_date = date,
         quality_id = quality)

# --- 10 ---
# Write new joined dataset to a csv file
write_csv(toys_joined, "clean_data/toys_joined.csv")
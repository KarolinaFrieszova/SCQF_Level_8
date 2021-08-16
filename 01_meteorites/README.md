
3.7 Writing documentation for function/program

# Meteorite landings

## Datasource

This report is using the open [dataset from nasa](https://www.kaggle.com/nasa/meteorite-landings). It is a subset of collected data on meteorites that have fallen to Earth and been found up to the year 2013.

## Overview

The purpose of this report is to clean and investigate the data using the R language.

### Project Stracture and General Code Summary

#### The data_cleaning.R file
Data cleaning consists of changing variable names to follow naming standards, manipulating string columns, converting data types, and dealing with missing values. 
The script also includes assertive programming to assure that the dataset has expected variable names and latitude and longitude columns store valid values.

#### The data_analysis.Rmd file

This analysis file contains a further investigation into the dataset. Including a function that takes two arguments (dataset and year) and returns a count of the meteorites in the selected year.

**Unit test** is included checking whether non-numeric inputs for the year argument return an error. Similarly, the second test is checking whether the objects give an expected answer/value. 
After unit testing, the function is enriched with additional stop functionality when logical or character value is the input, and not a numeric as we would expect.

## Packages Used

The packages used for data cleaning and analyses `tidyverse` and `janitor`. The package used to verify assumtions about data was `asserts`, and `testthat` for the unit testing.


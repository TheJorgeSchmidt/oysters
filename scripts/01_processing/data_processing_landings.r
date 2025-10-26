################################################################################
# DATA WRANGLING EVR 625 - OYSTERS
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 21 OCT 2025
#
# Process U.S. landings data
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(readxl)
library(dplyr)


## Load data -------------------------------------------------------------------
us_landings <- read_excel("data/raw/FOSS_landings.xlsx")

# PROCESSING ###################################################################

## A quick glimpse -------------------------------------------------------------------
glimpse(us_landings)

#Rows: 1,767
#Columns: 11
#$ Year              <dbl> 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024, …
#$ State             <chr> "ALABAMA", "CALIFORNIA", "DELAWARE", "FLORIDA-EAST", "FLORID…
#$ `NMFS Name`       <chr> "OYSTER, EASTERN", "OYSTER, PACIFIC", "OYSTER, EASTERN", "OY…
#$ Pounds            <dbl> 219637, NA, 90188, NA, 25439, 21335, 216778, NA, 6709876, 32…
#$ `Metric Tons`     <dbl> 100, NA, 41, NA, 12, 10, 98, NA, 3044, 148, 2, 491, 308, 14,…
#$ Dollars           <dbl> 4956341, NA, 515360, NA, 165814, 17000, 1302086, NA, 5080893…
#$$ Confidentiality  <chr> "Public", "Confidential", "Public", "Confidential", "Public"…
#$ Collection        <chr> "Commercial", "Commercial", "Commercial", "Commercial", "Com…
#$ `Scientific Name` <chr> "Crassostrea virginica", "Crassostrea gigas", "Crassostrea v…
#$ Tsn               <dbl> 79872, 79868, 79872, 79779, 79872, 79779, 79872, 79872, 7987…
#$ Source            <chr> "GULFFIN", "PACFIN", "ACCSP", "ACCSP", "ACCSP", "ACCSP", "AC…

us_landings
# A tibble: 1,767 × 11
#    Year State       `NMFS Name`  Pounds `Metric Tons` Dollars Confidentiality Collection
#   <dbl> <chr>       <chr>         <dbl>         <dbl>   <dbl> <chr>           <chr>
# 1  2024 ALABAMA     OYSTER, EA…  219637           100  4.96e6 Public          Commercial
# 2  2024 CALIFORNIA  OYSTER, PA…      NA            NA NA      Confidential    Commercial
# 3  2024 DELAWARE    OYSTER, EA…   90188            41  5.15e5 Public          Commercial
# 4  2024 FLORIDA-EA… OYSTER, AT…      NA            NA NA      Confidential    Commercial
# 5  2024 FLORIDA-EA… OYSTER, EA…   25439            12  1.66e5 Public          Commercial
# 6  2024 FLORIDA-WE… OYSTER, AT…   21335            10  1.7 e4 Public          Commercial
# 7  2024 FLORIDA-WE… OYSTER, EA…  216778            98  1.30e6 Public          Commercial
# 8  2024 GEORGIA     OYSTER, EA…      NA            NA NA      Confidential    Commercial
# 9  2024 LOUISIANA   OYSTER, EA… 6709876          3044  5.08e7 Public          Commercial
#10  2024 MAINE       OYSTER, EA…  327034           148  1.56e7 Public          Commercial
# ℹ 1,757 more rows
# ℹ 3 more variables: `Scientific Name` <chr>, Tsn <dbl>, Source <chr>


# The data contain 1,767 yearly observations (rows) and 11 columns (year + 10 variables).
# Some of the data is redundant (common and scientific names, and tsn), adds imprecision
# (metric tons and lbs), or is irrelevant (collection, confidentiality, source).
# I will now build a pipeline that cleans up the column names and excludes unwanted
# variables, and rows with missing weights and prices.

us_landings_clean <- us_landings |>
  clean_names() # fixes column names

us_landings_clean <- us_landings_clean |>
      rename(species = nmfs_name)

us_landings_clean <- us_landings_clean[,c(1:4, 6)] # selects relevant columns

us_landings_clean <- na.omit(us_landings_clean) # omits rows with missing observations

us_landings_clean

# Summarize production by year, ignoring state
production_by_year <- us_landings_clean |>
  group_by(year, species) |>
  summarise(
    total_pounds = sum(pounds, na.rm = TRUE),
    total_dollars = sum(dollars, na.rm = TRUE)
  )

# select only rows with observations for eastern and pacific oysters
production_by_year_ep <- production_by_year |>
  filter(grepl(c("EASTERN|PACIFIC"), species))

production_by_year_ep
# A tibble: 150 × 4
# Groups:   year [75]
#    year species         total_pounds total_dollars
#   <dbl> <chr>                  <dbl>         <dbl>
# 1  1950 OYSTER, EASTERN     68192100      27391974
# 2  1950 OYSTER, PACIFIC      8079700       2001417
# 3  1951 OYSTER, EASTERN     64305000      27104744
# 4  1951 OYSTER, PACIFIC      8597000       1840170
# 5  1952 OYSTER, EASTERN     72164600      30337289
# 6  1952 OYSTER, PACIFIC      9957500       1864639
# 7  1953 OYSTER, EASTERN     69318500      27301859
# 8  1953 OYSTER, PACIFIC     10282700       1582829
# 9  1954 OYSTER, EASTERN     70969600      30949289
# 10  1954 OYSTER, PACIFIC     10855400       1700529
# ℹ 140 more rows


# Export the file(s)------------------------------------------------------------
write_rds(x = production_by_year_ep,
          file = "data/processed/production_by_year_ep.rds")

################################################################################
# DATA WRANGLING EVR 625 - OYSTERS
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 21 OCT 2025
#
# Process U.S. imports data
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(readxl)
library(dplyr)


## Load data -------------------------------------------------------------------
us_imports <- read_excel("data/raw/ANNUAL TRADE-NO AGGREGATION_.xlsx")

# PROCESSING ###################################################################

## A quick glimpse -------------------------------------------------------------------
glimpse(us_imports)

us_imports
# A tibble: 5,729 × 13
#    Year Continent    `Country Name` `Product Name` `Edible code` `US Customs District`
#   <dbl> <chr>        <chr>          <chr>          <chr>         <chr>
# 1  2025 NORTH AMERI… CANADA         OYSTERS SEED   N             PORTLAND, ME
# 2  2025 ASIA         SOUTH KOREA    OYSTERS LIVE/… E             BALTIMORE, MD
# 3  2025 ASIA         SOUTH KOREA    OYSTERS LIVE/… E             HONOLULU, HI
# 4  2025 EUROPE       SPAIN          OYSTERS LIVE/… E             MIAMI, FL
# 5  2025 NORTH AMERI… CANADA         OYSTERS LIVE/… E             PORTLAND, ME
# 6  2025 NORTH AMERI… CANADA         OYSTERS LIVE/… E             LOS ANGELES, CA
# 7  2025 NORTH AMERI… CANADA         OYSTERS LIVE/… E             SAN FRANCISCO, CA
# 8  2025 NORTH AMERI… CANADA         OYSTERS LIVE/… E             SEATTLE, WA
# 9  2025 NORTH AMERI… CANADA         OYSTERS LIVE/… E             DETROIT, MI
#10  2025 NORTH AMERI… MEXICO         OYSTERS LIVE/… E             SAN DIEGO, CA
# ℹ 5,719 more rows
# ℹ 7 more variables: `Census Country Code` <dbl>, `Census District Code` <dbl>,
#   `FAO Country Code` <dbl>, `HTS Number` <dbl>, `Value (USD)` <dbl>,
#   `Volume (kg)` <dbl>, `Calculated Duty (USD)` <dbl>



# The data contain 1,767 yearly observations (rows) and 11 columns (year + 10 variables).
# Some of the data is redundant (common and scientific names, and tsn), adds imprecision
# (metric tons and lbs), or is irrelevant (collection, confidentiality, source).
# I will now build a pipeline that cleans up the column names and excludes unwanted
# variables, and rows with missing weights and prices.

us_imports_clean <- us_imports |>
  clean_names() # fixes column names

# us_landings_clean <- us_landings_clean |>
#      rename(species = nmfs_name)

us_imports_clean <- us_imports_clean[,c(1, 3:4, 6, 10:13)] # selects relevant columns

us_imports_clean <- na.omit(us_imports_clean) # omits rows with missing observations

us_imports_clean


# select only rows with observations for live oysters
# HTS code 307110060 OYSTERS LIVE/FRESH FARMED
# HTS code 307110080 OYSTERS LIVE/FRESH WILD
filtered_us_imports_clean <- us_imports_clean |>
  filter(grepl(c("307110060|307110080"), hts_number))

# make product_name easier to follow
# code to be written - make product_name either farmed or wild


# Summarize production by year, ignoring state
imports_by_year <- filtered_us_imports_clean |>
  group_by(year, hts_number) |>
  summarise(
    total_pounds = sum(volume_kg * 2.204, na.rm = TRUE),
    total_dollars = sum(value_usd, na.rm = TRUE)
  )


imports_by_year
# A tibble: 28 × 4
# Groups:   year [14]
#    year hts_number total_pounds total_dollars
#   <dbl>      <dbl>        <dbl>         <dbl>
# 1  2012  307110060     7459383.      17871139
# 2  2012  307110080      430964.       1019249
# 3  2013  307110060     6520261.      18766401
# 4  2013  307110080     1274353.       3281567
# 5  2014  307110060     8081100.      21770034
# 6  2014  307110080      961890.       2800816
# 7  2015  307110060     8729076.      22533535
# 8  2015  307110080     1172830.       3224369
# 9  2016  307110060     8842433.      25223496
# 10  2016  307110080     1005524.       2787435
# ℹ 18 more rows

imports_by_year <- dplyr::mutate(imports_by_year,
                                 source = ifelse(hts_number == 307110060,
                                                 "farmed", "wild"))

imports_by_year <- imports_by_year[,c(1, 3:5)] # selects relevant columns

# Export the file(s)------------------------------------------------------------
write_rds(x = imports_by_year,
          file = "data/processed/imports_by_year.rds")

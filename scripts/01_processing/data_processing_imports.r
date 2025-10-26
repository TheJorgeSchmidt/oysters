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
imports <- read_excel("data/raw/ANNUAL TRADE-NO AGGREGATION_.xlsx")

# PROCESSING ###################################################################



# The data contain 5,729  observations (rows) and 13 columns (year + 12 variables).
# Some of the data is redundant (HTS code and Product Name), or is irrelevant
# (Continent, Edible, US Customs Districts, FAO Country Code).
# I will now build a pipeline that cleans up the column names and excludes unwanted
# variables, and rows with missing weights and prices.

imports_clean <- imports |>
  clean_names() # fixes column names

imports_clean <- imports_clean[,c(1, 3:4, 6, 10:13)] # selects relevant columns

imports_clean <- na.omit(imports_clean) # omits rows with missing observations

# select only rows with observations for live oysters
# HTS code 307110060 OYSTERS LIVE/FRESH FARMED
# HTS code 307110080 OYSTERS LIVE/FRESH WILD
filtered_imports_clean <- imports_clean |>
  filter(grepl(c("307110060|307110080"), hts_number))


# Summarize production by year, ignoring state
imports_by_year <- filtered_imports_clean |>
  group_by(year) |>
  summarise(
    total_pounds = sum(volume_kg * 2.204, na.rm = TRUE),
    total_dollars = sum(value_usd, na.rm = TRUE)
  )

# Export the file(s)------------------------------------------------------------
write_rds(x = imports_by_year,
          file = "data/processed/imports_by_year.rds")

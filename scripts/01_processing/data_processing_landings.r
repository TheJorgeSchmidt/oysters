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
landings <- read_excel("data/raw/FOSS_landings.xlsx")

# PROCESSING ###################################################################
# The data contain 1,767 yearly observations (rows) and 11 columns (year + 10 variables).
# Some of the data is redundant (common and scientific names, and tsn), adds imprecision
# (metric tons and lbs), or is irrelevant (collection, confidentiality, source).
# I will now build a pipeline that cleans up the column names and excludes unwanted
# variables, and rows with missing weights and prices.

landings_clean <- landings |>
  clean_names() # fixes column names

landings_clean <- landings_clean |>
      rename(species = nmfs_name)

landings_clean <- landings_clean[,c(1:4, 6)] # selects relevant columns

landings_clean <- na.omit(landings_clean) # omits rows with missing observations

landings_clean

# Summarize production by year, ignoring state
landings_by_year <- landings_clean |>
  group_by(year) |>
  summarise(
    total_pounds = sum(pounds, na.rm = TRUE),
    total_dollars = sum(dollars, na.rm = TRUE)
  )

## Export -------------------------------------------------------------------
write_rds(x = landings_by_year,
          file = "data/processed/landings_by_year.rds")

###############################################################################
# DATA WRANGLING EVR 625 - OYSTERS
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 14 OCT 2025
#
# calculate inflation-adjusted yearly prices for Eastern and Pacific Oysters
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(dplyr)
library(readr)

cpi <-read_rds(file = "data/processed/cpi_1950_2024_by_yr.rds")
imports <- read_rds(file = "data/processed/imports_by_year.rds")

cpi_now <- 323.36 # from FRED

# left join with import data using year as the key
imports_by_year_cpi <- imports |>
  left_join(cpi,
            by = "year")

imports_by_year_cpi <- na.omit(imports_by_year_cpi) # omit any missing values

imports_oysters_inflation_adjusted <-
  mutate(imports_by_year_cpi,
         adj_dollars = ((total_dollars/total_pounds)*(cpi_now/avg_cpi)))

## Export the file(s) ----------------------------------------------------------
write_rds(x = imports_oysters_inflation_adjusted,
          file = "data/output/imports_inflation_adjusted.rds")


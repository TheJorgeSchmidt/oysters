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

cpi <-read_rds(file = "data/processed/cpi_1950_2024_by_yr.rds")
landings <- read_rds(file = "data/processed/production_by_year_ep.rds")

cpi_now <- 323.36 # from FRED

# left join with production data using year as the key
production_by_year_ep_cpi <- landings |>
  left_join(cpi,
            by = "year")

production_by_year_ep_cpi <- na.omit(production_by_year_ep_cpi) # omit any missing values

ep_oysters_inflation_adjusted <-
  mutate(production_by_year_ep_cpi,
         adj_dollars = ((total_dollars/total_pounds)*(cpi_now/avg_cpi)))

## Export the file(s) ----------------------------------------------------------
write_rds(x = ep_oysters_inflation_adjusted,
          file = "data/output/ep_oysters_inflation_adjusted.rds")


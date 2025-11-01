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

cpi <-read_rds(file = "data/processed/cpi_by_year.rds")
landings <- read_rds(file = "data/processed/landings_by_year.rds")

# group by year, calculate weighed average price per lb
landings_1950_2024 <- landings |>
  group_by(year) |>
  summarise(
    weighed_avg_price = mean(total_dollars/total_pounds),
    total_pounds = sum(total_pounds),
  )

cpi_now <- 323.36 # from FRED

# left join with production data using year as the key
production_by_year_cpi <- landings_1950_2024 |>
  left_join(cpi,
            by = "year")

production_by_year_cpi <- na.omit(production_by_year_cpi) # omit any missing values

landings_inflation_adjusted <-
  mutate(production_by_year_cpi,
         adj_dollars = ((weighed_avg_price)*(cpi_now/avg_cpi)))

# select relevant columns
landings_inflation_adjusted <- landings_inflation_adjusted[, c(1, 3, 5)]

## Export the file(s) ----------------------------------------------------------
write_rds(x = landings_inflation_adjusted,
          file = "data/output/landings_inflation_adjusted.rds")


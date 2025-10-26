###############################################################################
# DATA WRANGLING EVR 625 - OYSTERS
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 14 OCT 2025
#
# calculate inflation-adjusted yearly prices for imported fresh oysters
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(dplyr)
library(readr)

cpi <-read_rds(file = "data/processed/cpi_1950_2024_by_yr.rds")
imports <- read_rds(file = "data/processed/imports_by_year.rds")

imports_2012_2024 <- na.omit(imports) # omit any missing values

# group by year, calculate weighed average price per lb
imports_2012_2024_wa <- imports_2012_2024 |>
  group_by(year) |>
  summarise(
    weighed_avg_import = mean(total_dollars/total_pounds),
    total_pounds = sum(total_pounds),
  )

# calculate inflation-adjusted yearly price per pound
cpi_now <- 323.36 # from FRED

# left join with import data using year as the key
imports_by_year_cpi_wa <- imports_2012_2024_wa |>
  left_join(cpi,
            by = "year")

imports_oysters_wa_inflation_adjusted <-
  mutate(imports_by_year_cpi_wa,
         adj_dollars = (weighed_avg_import)*(cpi_now/avg_cpi))

imports_oysters_wa_inflation_adjusted <-
  na.omit(imports_oysters_wa_inflation_adjusted) # omit any missing values

imports_oysters_wa_inflation_adjusted <-
  imports_oysters_wa_inflation_adjusted[, c(1, 3, 5)]

## Export the file(s) ----------------------------------------------------------
write_rds(x = imports_oysters_wa_inflation_adjusted,
          file = "data/output/imports_oysters_inflation_adjusted.rds")



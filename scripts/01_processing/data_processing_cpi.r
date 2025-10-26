################################################################################
# DATA WRANGLING EVR 625 - OYSTERS
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 21 OCT 2025
#
# Calculate inflation-adjusted prices
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(readxl)
library(dplyr)


## Produce inflation-adjusted prices -------------------------------------------

# Let's examine the data
cpi_1950_2024 <- read_csv("data/raw/CPIAUCSL.csv")

cpi_1950_2024 # this data is reported monthly, we want yearly

cpi_1950_2024_by_yr <- cpi_1950_2024 |>
  mutate(year = lubridate::year(observation_date)) |>
  select(year, CPIAUCSL) |>
  group_by(year) |>
  summarise(
    avg_cpi = mean(CPIAUCSL, na.rm = TRUE),
  )

cpi_1950_2024_by_yr <- cpi_1950_2024_by_yr[1:75, ] # omit year 2025

## Export the file(s) ----------------------------------------------------------
write_rds(x = cpi_1950_2024_by_yr,
          file = "data/processed/cpi_1950_2024_by_yr.rds")


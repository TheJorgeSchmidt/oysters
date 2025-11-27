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
library(here)


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

landings_clean <- landings_clean[,c(1:2, 4, 6)] # selects relevant columns

landings_clean <- na.omit(landings_clean) # omits rows with missing observations

landings_clean <- landings_clean |>
  mutate(state = str_to_sentence(state)) # state names into sentence case

landings_clean # this will be exported


# Select top five producing states
top_states <- landings_clean |>
  summarise(total_pounds = sum(pounds, na.rm = TRUE), .by = state) |>
  arrange(desc(total_pounds)) |>
  mutate(rank = row_number(),
         state_group = ifelse(rank <= 5, state, "Other")) |>
  select(state, state_group) |>
  right_join(landings_clean, by = "state") |>
  mutate(state = state_group) |>
  summarise(pounds = sum(pounds),
            dollars = sum(dollars),
            .by = c(year, state)) |>
  arrange(year, desc(pounds))

top_states # this will be exported

top_states_decade <- top_states |>
  mutate(decade = 10 * (year %/% 10)) |>           # creates 1950, 1960, ..., 2020
  summarise(pounds  = sum(pounds),
            dollars = sum(dollars),
            .by = c(decade, state)) |>
  arrange(decade, desc(pounds))

top_states_decade


# Summarize production by year, ignoring state
landings_by_year <- landings_clean |>
  group_by(year) |>
  summarise(
    total_pounds = sum(pounds, na.rm = TRUE),
    total_dollars = sum(dollars, na.rm = TRUE)
  )

landings_by_year # this will be exported

## Export -------------------------------------------------------------------
write_rds(x = landings_clean,
          file = "data/processed/landings_clean.rds")

write_rds(x = top_states,
          file = "data/processed/top_states.rds")

write_rds(x = top_states_decade,
          file = "data/processed/top_states_decade.rds")

write_rds(x = landings_by_year,
          file = "data/processed/landings_by_year.rds")

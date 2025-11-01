#############################################################################
# DATA WRANGLING EVR 625 - OYSTERS
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 14 OCT 2025
#
# plot volumes, revenues, actual and inflation-adjusted yearly prices for
# U.S. landings and imports of fresh oysters
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(cowplot)
library(readr)
library(ggplot2)
library(dplyr)
library(ggridges)

# load data
landings <- read_rds("data/output/landings_inflation_adjusted.rds")
imports <- read_rds("data/output/imports_inflation_adjusted.rds")

# create data frame including landings and imports data
l_and_i <- landings |>
  left_join(imports,
            by = "year")

l_and_i_long <- l_and_i |>
  pivot_longer(
    cols = -year,
    names_to = c(".value", "group"),
    names_sep = "\\."
  ) |>
  mutate(group = if_else(is.na(group), "x", group))

#### [words] ---------------------------------------------------------------
ggplot(
  data = landings,
  mapping = aes(x = year,
                y = total_pounds/2204)
  ) +
  geom_point(alpha = 0.3) +
  labs(
   title = "Landings of oysters in the U.S. (1950 - 2024)",
   subtitle = "Expressed in weight of oyster meat (excluding shell weight)",
   x = "Year",
   y = "Metric tons") +
  scale_y_continuous(limits = c(0, max(landings$total_pounds/2204))) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = )


ggplot(
  data = imports,
  mapping = aes(x = year,
                y = total_pounds/2204)
  ) +
  geom_point(alpha = 0.3) +
  labs(
   title = "Imports of oysters in the U.S. (2012 - 2024)",
   subtitle = "Expressed in weight of oyster meat (excluding shell weight)",
   x = "Year",
   y = "Metric tons") +
  scale_y_continuous(limits = c(0, max(imports$total_pounds/2204))) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = )

##### first visualization

ggplot(
  data = l_and_i_long,
  mapping = aes(x = year,
                y = total_pounds/2204,
                color = group)
  ) +
  geom_point() +
  geom_line() +
  labs(
   title = "Landings and imports of fresh oysters in the U.S. (1950 - 2024)",
   subtitle = "Weight of oyster meat (excluding shell weight)",
   x = "Year",
   y = "Metric tons",
   caption = "Data from NOAA",
   color = "Provenance") +
  scale_y_continuous(limits = c(0, max(l_and_i_long$total_pounds/2204))) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("U.S. Landings", "Imports")) +
  theme_minimal()



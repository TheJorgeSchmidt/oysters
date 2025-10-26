#############################################################################
# DATA WRANGLING EVR 625 - OYSTERS
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 14 OCT 2025
#
# plot volumes, revenues, actual and inflation-adjusted yearly prices for
# U.S. landings and imports of fresh oysters including weighed-average prices
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(cowplot)
library(readr)
library(ggplot2)

# load data

pbye <- read_rds("data/processed/production_by_year_ep.rds")
pbyf <- read_rds("data/processed/production_by_year_fl.rds")
eoia <- read_rds("data/output/ep_oysters_inflation_adjusted.rds")
foia <- read_rds("data/output/fl_oysters_inflation_adjusted.rds")
iia <-read_rds("data/output/imports_inflation_adjusted.rds")
iiwa <-read_rds("data/output/imports_oysters_inflation_adjusted_wa.rds")

# first visualization - volume
p1 <- ggplot(
  data = pbye,
  mapping = aes(x = year,
                y = total_pounds/1000,
                color = species)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Landings of oysters in the U.S. (1950 - 2024)",
    subtitle = "Volumes in tons for Eastern and Pacific oysters",
    x = "Year",
    y = "Imperial Tons",
    color = "Species"
  ) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Eastern Oyster", "Pacific Oyster"))

# second visualization - revenue
p2 <- ggplot(
  data = pbye,
  mapping = aes(x = year,
                y = total_dollars/1000,
                color = species)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Revenues from oysters in the U.S. (1950 - 2024)",
    subtitle = "Total revenues for Eastern and Pacific oysters",
    x = "Year",
    y = "Thousands of dollars",
    color = "Species"
  ) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Eastern Oyster", "Pacific Oyster"))

# third visualization - revenue per pound (unadjusted)
p3 <- ggplot(
  data = pbye,
  mapping = aes(x = year,
                y = (total_dollars/total_pounds),
                color = species)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Price of oysters in the U.S. (1950 - 2024)",
    subtitle = "Revenue per pound for Eastern and Pacific oysters",
    x = "Year",
    y = "Dollars per lb",
    color = "Species"
  ) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Eastern Oyster", "Pacific Oyster"))


# fourth visualization - Florida volumes
p4 <- ggplot(
  data = pbyf,
  mapping = aes(x = year,
                y = total_pounds/1000,
                color = coast)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Landings of oysters in Florida (1950 - 2024)",
    subtitle = "Volumes in tons for West and East coasts",
    x = "Year",
    y = "Imperial Tons",
    color = "Coast"
  ) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("FL-East", "FL-West"))

# fifth visualization - revenue per pound FL
p5 <- ggplot(
  data = pbyf,
  mapping = aes(x = year,
                y = (total_dollars/total_pounds),
                color = coast)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Landings of oysters in Florida (1950 - 2024)",
    subtitle = "Revenue per pound for East and West coast oysters",
    x = "Year",
    y = "Dollars per lb",
    color = "Coast"
  ) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Fl - East", "FL - West"))

#  Inflation-adjusted price per pound for oysters in the U.S. ------------------
p6 <- ggplot(
  data = eoia,
  mapping = aes(x = year,
                y = adj_dollars,
                color = species)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Inflation-adjusted price for oysters in the U.S. (1950 - 2024)",
    subtitle = "Revenue per pound for Eastern and Pacific oysters",
    x = "Year",
    y = "Dollars per lb",
    color = "Species"
  ) +
  scale_y_continuous(limits = c(0, max(eoia$adj_dollars))) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Eastern Oyster", "Pacific Oyster"))

#  Inflation-adjusted price per pound for oysters in Florida -------------------
p7 <- ggplot(
  data = foia,
  mapping = aes(x = year,
                y = adj_dollars,
                color = coast)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Inflation-adjusted price per pound for oysters in Florida",
    subtitle = "Landings on East and West coasts (1950 - 2024)",
    x = "Year",
    y = "Dollars per lb",
    color = "Coast"
  ) +
   scale_y_continuous(limits = c(0, max(iiaa$weighted_avg_price))) +
  theme_minimal() +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("FL East", "FL West"))

p8 <- plot_grid(p3, p6, ncol = 1)


#  Inflation-adjusted price per pound for imported oysters  -------------------
iiaa <- iiwa %>%
  distinct(year, weighted_avg_price)

# Plot using ggplot2
ggplot(
  data = iiaa,
  mapping = aes(x = year,
                 y = weighted_avg_price)
  ) +
  geom_point(color = "#1e90ff") +
  geom_smooth(method = "lm", se = FALSE, color = "#ff6347") +
  labs(
    title = "Inflation-adjusted price per pound",
    subtitle = "Imports of fresh oysters (2012 - 2024)",
    x = "Year",
    y = "Dollars per lb",
    ) +
  scale_y_continuous(limits = c(0, max(iiaa$weighted_avg_price))) +
  theme_minimal()

# p10 <- plot_grid(p3, p6, ncol = 1) # Inflation-adjusted US landings vs Imports



# EXPORT #######################################################################
## Export the total volumes plots ----------------------------------------------
ggsave(plot = p1,
       filename = "results/img/landings_us.png",
       width = 8,
       height = 10)
## Export the total revenues plots ---------------------------------------------
ggsave(plot = p2,
       filename = "results/img/revenues_us.png",
       width = 7,
       height = 10)
## Export the revenue per lbs plots --------------------------------------------
ggsave(plot = p3,
       filename = "results/img/revenues_per_lb_us.png",
       width = 8,
       height = 10)
## Export the FL volumes plot --------------------------------------------------
ggsave(plot = p4,
       filename = "results/img/landings_fl.png",
       width = 7,
       height = 10)
## Export the FL revenues plot -------------------------------------------------
ggsave(plot = p5,
       filename = "results/img/revenues_per_lb_fl.png",
       width = 7,
       height = 10)
## Export Inflation-adjusted price per pound for oysters in the U.S plot -------
ggsave(plot = p6,
       filename = "results/img/adj_revenues_per_lb_us.png",
       width = 7,
       height = 10)
## Export Inflation-adjusted price per pound for oysters in the U.S plot -------
ggsave(plot = p7,
       filename = "results/img/adj_revenues_per_lb_fl.png",
       width = 7,
       height = 10)
## Export Inflation-adjusted price per pound for oysters in the U.S plot -------
ggsave(plot = p8,
       filename = "results/img/price_comparison.png",
       width = 7,
       height = 10)

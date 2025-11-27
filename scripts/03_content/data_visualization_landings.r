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
library(ggridges)
library(readr)
library(ggplot2)
library(dplyr)
library(ggimage)
library(magick)

## load data
landings <- read_rds("data/output/landings_inflation_adjusted.rds")
top_states <- read_rds("data/output/landings_by_top_state_inflation_adjusted ")


## define states as factors
top_states <- top_states |>
  mutate(state = factor(state,
                        levels = c("Other",        # bottom
                                   "Louisiana",
                                   "Maryland",
                                   "Virginia",
                                   "Washington",
                                   "Texas")))   # top


## oyster image
o_img <- image_read("data/raw/oyster.jpg")
resized <- image_resize(o_img, "25x25")  # width x height
image_write(resized, "data/processed/oyster_resized.png")


## create data frame combining landings and oyster imagea

landings$img <- rep("data/processed/oyster_resized.png", nrow(landings))

#### first visualization -------------------------------------------------------
# landings of fresh oysters by weight
p1 <- ggplot(
  data = landings,
  mapping = aes(x = year,
                y = total_pounds/2204)) +
  geom_image(aes(image = img), size = landings$total_pounds/1500000000) +
  labs(
  title = "Landings of fresh oysters in the U.S. (1950 - 2024)",
  subtitle = "Expressed in weight of oyster meat",
  x = "Year",
  y = "Metric tons",
  caption = "Data from NOAA") +
  scale_y_continuous(limits = c(0, max(landings$total_pounds/2204))) +
  theme(
  caption.justification = "right",
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Landings", "Imports")) +
  theme_minimal()

# landings of fresh oysters by inflation-adjusted price
p2 <- ggplot(
  data = landings,
  mapping = aes(x = year,
                y = adj_dollars)) +
  geom_image(aes(image = img), size = landings$adj_dollars/200) +
  labs(
  title = "Landings of fresh oysters in the U.S. (1950 - 2024)",
  subtitle = "In 2025 inflation-adjusted dollars per pound of oyster meat",
  x = "Year",
  y = "Dollars",
  caption = "Data from NOAA and FRED") +
  scale_y_continuous(limits = c(0, 13)) +
  theme(
  caption.justification = "right",
  legend.position = "bottom",
  legend.justification = "center") +
  theme_minimal()

## plots by top state
p3 <- ggplot(
  data = top_states,
  mapping = aes(x = year,
             y = state,
             height = adj_dollars / 1e6,
             fill = state)) +
  geom_density_ridges(stat = "identity",   # <-- key: uses actual values, not kernel density
                      scale = 0.95,
                      alpha = 0.99,
                      color = "white") +
  scale_fill_manual(values = c("gray25", "gray25", "gray25",
                               "gray25", "gray25", "gray25")) +
  labs(title = "Value of oyster production top five U.S. states (1950 - 2024)",
       subtitle = "In inflation-adjusted 2025 dollars",
       x = "Year",
       y = NULL,
       caption = "Data from NOAA and FRED") +
  theme_ridges(grid = FALSE,
               font_size = 13) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"))


# EXPORT #######################################################################
## Export the total volumes plots ----------------------------------------------
ggsave(plot = p1,
       filename = "results/img/landings_by_weight.png",
       width = 8,
       height = 6)

## Export the total value plot ---------------------------------------------
ggsave(plot = p2,
       filename = "results/img/landings_values.png",
       width = 7,
       height = 5)

# Export the top five states value plot ---------------------------------------------
ggsave(plot = p3,
       filename = "results/img/top_five_states_values.png",
       width = 7,
       height = 5)

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
library(ggimage)
library(magick)

# load data
landings <- read_rds("data/output/landings_inflation_adjusted.rds")
imports <- read_rds("data/output/imports_inflation_adjusted.rds")

# create data frame combining landings and imports data
l_and_i <- landings |>
  left_join(imports,
            by = "year")

l_and_i_long <- l_and_i |> # place imports and landings in separate rows
  pivot_longer(
    cols = -year,
    names_to = c(".value", "provenance"),
    names_sep = "\\."
  ) |>
  mutate(provenance = if_else(is.na(provenance), "x", provenance))

l_and_i_long$provenance <- factor(l_and_i_long$provenance,
                             levels = c("x", "y"),
                             labels = c("Landings", "Imports")) # makes provenance a factor

df <- l_and_i_long[125:150,]  # picks 2012-2024 years


## oyster image
o_img <- image_read("data/raw/oyster.jpg")
resized <- image_resize(o_img, "25x25")  # width x height
image_write(resized, "data/processed/oyster_resized.png")


df$img <- rep("data/processed/oyster_resized.png", nrow(df))
#### first visualization -------------------------------------------------------
# landings and imports of fresh oysters by weight
p1 <- ggplot(
  data = df,
  mapping = aes(x = year,
                y = total_pounds/2204)) +
  geom_image(aes(image = img), size = df$total_pounds/150000000) +
  facet_wrap(~provenance, ncol = 1) +
  labs(
  title = "Landings and imports of fresh oysters in the U.S. (2012 - 2024)",
  subtitle = "Expressed in weight of oyster meat (excluding shell weight)",
  x = "Year",
  y = "Metric tons",
  caption = "Data from NOAA") +
  scale_y_continuous(limits = c(0, max(df$total_pounds/2204))) +
  theme(
  caption.justification = "right",
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Landings", "Imports")) +
  theme_minimal()


p2 <- ggplot(
  data = df,
  mapping = aes(x = year,
                y = ((total_pounds * adj_dollars)/1000000),
                color = provenance)
  ) +
  geom_point(size = df$adj_dollars/1.5) +
  geom_text(aes(label = paste0("$", sprintf("%.2f", df$adj_dollars))),
          vjust = 2.8, size = 2.3, color = "black",
          position = position_jitter(width = 0.1, seed = 1)) +
  labs(
   title = "Value of landings and imports of fresh oysters in the U.S. (2012 - 2024)",
   subtitle = "Point size reflects inflation-adjusted price per pound",
   x = "Year",
   y = "Millions of dollars",
   caption = "Data from NOAA",
   color = "Provenance") +
  scale_y_continuous(limits = c(0, 427)) +
  theme(
  caption.justification = "right",
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Landings", "Imports")) +
  theme_minimal()


# EXPORT #######################################################################
## Export the total volumes plots ----------------------------------------------
ggsave(plot = p1,
       filename = "results/img/landings_and_imports_weight.png",
       width = 8,
       height = 6)

## Export the total value plot ---------------------------------------------
ggsave(plot = p2,
       filename = "results/img/landings_and_imports_values.png",
       width = 7,
       height = 5)

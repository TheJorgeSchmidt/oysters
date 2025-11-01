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
ggplot(
  data = df,
  mapping = aes(x = year,
                y = total_pounds/2204)) +
  geom_image(aes(image = img), size = df$total_pounds/220400010) +
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



df$provenance <- factor(df$group, levels = c("Landings", "Imports"))

ggplot(df, aes(x = year, y = total_pounds/2204, color = provenance)) +
  geom_image(aes(image = img), size = df$total_pounds/220400010) +
  facet_wrap(~ provenance, ncol = 1) +
  labs(title = "Landings and imports of fresh oysters in the U.S. (2012 - 2024)",
       subtitle = "Expressed in weight of oyster meat (excluding shell weight)",
       x = "Year", y = "Metric tons", caption = "Data from NOAA") +
  scale_y_continuous(limits = c(0, max(df$total_pounds/2204))) +
  scale_color_hue(labels = c("Landings", "Imports")) +
  theme_minimal() +
  theme(legend.position = "bottom",
        caption.position = "plot")




ggplot(
  data = df,
  mapping = aes(x = year,
                y = ((total_pounds * adj_dollars)/1000000),
                color = group)
  ) +
  geom_point(size = df$adj_dollars/1.5) +
  geom_text(aes(label = paste0("$", sprintf("%.2f", df$adj_dollars))),
          vjust = 2.8, size = 2.3, color = "black",mm,
          position = position_jitter(width = 0.1, seed = 1)) +
  labs(
   title = "Value of landings and imports of fresh oysters in the U.S. (2012 - 2024)",
   subtitle = "Point size is relative to inflation-adjusted price per pound",
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







df <- l_and_i_long %>%
  mutate(revenue = total_pounds * adj_dollars,
         group = factor(group, levels = c("x", "y")))

ggplot(df, aes(x = group, y = revenue)) +
  geom_violin(fill = "steelblue", alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2),
             size = 1.5, color = "gray40") +
  labs(title = "Yearly Revenue Distribution",
       x = NULL, y = "Revenue (pounds × $/lb)") +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal(base_size = 12)




ggplot(
  data = l_and_i_long[125:150,],     # picks 2012-2024 years
  mapping = aes(x = year,
                y = total_pounds*adj_dollars,
                color = group)
  ) +
  geom_point() +
  geom_line() +
  labs(
   title = "Landings and imports of fresh oysters in the U.S. (2012 - 2024)",
   subtitle = "Expressed in weight of oyster meat (excluding shell weight)",
   x = "Year",
   y = "Metric tons",
   caption = "Data from NOAA",
   color = "Provenance") +
  scale_y_continuous(limits = c(0, max(l_and_i_long$total_pounds*l_and_i_long$adj_dollars))) +
  theme(
  caption.justification = "right",
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Landings", "Imports")) +
  theme_minimal()










df <- l_and_i[63:75,] |>
  pivot_longer(-year, names_to = c(".value", "group"),
               names_pattern = "(.*)\\.(x|y)")

ggplot(df, aes(x = adj_dollars, y = group)) +
  geom_segment(aes(xend = adj_dollars, yend = group), x = 0) +
  geom_point(size = 3, color = "steelblue") +
  facet_wrap(~ "Price ($/lb)", scales = "free_x") +
  labs(x = "Price ($/lb)", y = NULL) +
  theme_minimal() +
  theme(strip.placement = "outside", strip.text = element_text(size = 12))



df_long <- l_and_i[63:75,] |>
  pivot_longer(-year, names_to = c(".value", "group"),
               names_pattern = "(.*)\\.(x|y)")

df_summary <- df_long |>
  group_by(group) |>
  summarise(min_price = min(adj_dollars),
            max_price = max(adj_dollars),
            mean_price = mean(adj_dollars))

ggplot(df_summary, aes(y = group)) +
  geom_segment(aes(x = min_price, xend = max_price, yend = group),
               color = "black", linewidth = 0.3) +
  geom_point(aes(x = mean_price), size = 3, color = "steelblue") +
  geom_point(data = df_long, aes(x = adj_dollars),
             size = 1.5, alpha = 0.6, color = "gray40") +
  labs(title = "Price range by provenance",
       x = "Price ($/lb) [Range with Mean]", y = NULL) +
  thqqeme_minimal(base_size = 12) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.05)))


df_long$group <- factor(df_long$group, levels = c("x", "y"))
df_summary$group <- factor(df_summary$group, levels = c("x", "y"))

ggplot(df_summary, aes(y = group)) +
  geom_segment(aes(x = min_price, xend = max_price, yend = group),
               color = "black", linewidth = 0.8) +
  geom_point(aes(x = mean_price), size = 3, color = "steelblue") +
  geom_point(data = df_long, aes(x = adj_dollars),
             size = 1.5, alpha = 0.6, color = "gray40") +
  labs(title = "Price range by group",
       x = "Price ($/lb) [Range with Mean]", y = NULL) +
  theme_minimal(base_size = 12) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.05))) +
  scale_y_discrete(limits = rev)














ggplot(l_and_i_long, aes(x =total_pounds, y = factor(year), fill = group)) +
  geom_density_ridges(alpha = 0.6) +
  theme_ridges() +
  labs(x = "Adjusted Dollars", y = "Year", fill = "Group")









# first visualization - volume
p1 <- ggplot(
  data = pby,
  mapping = aes(x = year,
                y = total_pounds/1000,
                color = species)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Landings of oysters in the U.S. (1950 - 2024)",
    subtitle = "Volumes in tons",
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


# fifth visualize fl production - volumes
ggplot(
  data = production_by_year_fl,
  mapping = aes(x = year,
                y = total_pounds/1000,
                color = state)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Landings of oysters in Florida. (1950 - 2024)",
    subtitle = "Volumes in tons for West and East coasts",
    x = "Year",
    y = "Imperial Tons",
    color = "Coast"
  ) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("FL-East", "FL-West"))

# sixth visualization - revenue per pound FL
ggplot(
  data = production_by_year_fl,
  mapping = aes(x = year,
                y = (total_dollars/total_pounds),
                color = state)
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


# second visualization - revenue
ggplot(
  data = production_by_year_ep,
  mapping = aes(x = year,
                y = total_dollars/1000,
                color = species)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Landings of oysters in the U.S. (1950 - 2024)",
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
ggplot(
  data = production_by_year_ep,
  mapping = aes(x = year,
                y = (total_dollars/total_pounds),
                color = species)
  ) +
  geom_point(alpha = 0.3) +
  labs(
    title = "Landings of oysters in the U.S. (1950 - 2024)",
    subtitle = "Revenue per pound for Eastern and Pacific oysters",
    x = "Year",
    y = "Dollars per lb",
    color = "Species"
  ) +
  theme(
  legend.position = "bottom",
  legend.justification = "center") +
  scale_color_hue(labels = c("Eastern Oyster", "Pacific Oyster"))




# first visualization - volume
ggplot(
  data = production_by_year_ep,
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



# fourth visualization - Florida volumes



# select only rows with observations for florida east and west coasts

production_by_year_by_state <- us_landings_clean |>
  group_by(year, state) |>
  summarise(
    total_pounds = sum(pounds, na.rm = TRUE),
    total_dollars = sum(dollars, na.rm = TRUE)
  )

production_by_year_fl <- production_by_year_by_state |>
  filter(grepl("FLORIDA", state))

production_by_year_fl

################################################################################
# US landings volume
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# 16 NOV 2025
#
# visualize oyster landings volume
#
################################################################################

library(readr)
library(tigris)
library(sf)
library(dplyr)
library(ggplot2)
library(scales)
library(RColorBrewer)
library(ggspatial)

### Load data
# Load aggregate production volume by state
landings_by_state <- read_rds(file = "data/processed/landings_by_state.rds")


#load us states data, filter Alaska and Hawaii
us_states <- states(cb = TRUE, resolution = "20m") |>
  filter(!STUSPS %in% c("AK", "HI", "PR")) |>
  st_transform(4326) # Reprojects to EPSG:4326

landings_map <- landings_by_state |>
  filter(state != "ALASKA") |>
  mutate(STUSPS = state.abb[match(toupper(state), toupper(state.name))])

us_states <- us_states |>
  left_join(landings_map, by = "STUSPS")


# plot

p1 <- ggplot(us_states) +
  geom_sf(aes(fill = total_pounds),
          color = "white") +
  scale_fill_gradientn(colors = RColorBrewer::brewer.pal(9, "Blues"),
                       labels = comma,
                       na.value = "gray90") +
  theme(
  caption.justification = "right",
  legend.position = "bottom",
  legend.justification = "center") +
  theme_bw() +
  # Add a north arrow from ggspatial
  annotation_north_arrow(location = "bl") +
  # Add a scalebar from ggspatial
  annotation_scale(location = "br") +
  # Trim whitespace
  labs(title = "Oyster Landings by State (1950-2024)",
       subtitle = "Expressed in weight of oyster meat (excluding shell weight)",
       caption = "Data from NOAA",
       fill = "Pounds")


# export plot
ggsave(plot = p1,
       filename = "results/img/oyster_landing_by_state.png",
       width = 8,
       height = 6)

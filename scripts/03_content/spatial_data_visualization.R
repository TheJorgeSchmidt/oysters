################################################################################
# Eleven countries exported fresh oysters to US
################################################################################
#
# Jorge Schmidt
# jorge.schmidt@miami.edu
# date
#
# visualize oyster import data 2012 - 2014
#
################################################################################

library(ggspatial)     # To add map elements to a ggplot
library(rnaturalearth) # To add country outlines
library(tidyverse)     # General data wrangling
library(sf)            # Working with vector data
library(terra)         # Working with raster data
library(tidyterra)     # Working with raster data in tidy approach
library(mapview)       # To quickly inspect data
library(maps)

### Load data
# Load aggregate production volume by state
landings_by_state <- read_rds(file = "data/processed/landings_by_state.rds")

# Load US coastline
coast <- ne_countries(country = "United States of America")

us_coast <- st_crop(coast, xmin = -180, ymin = 18, xmax = -66, ymax = 72)

##### plot

ggplot() +
   # Add gulf coast coastline
  geom_sf(data = us_coast,
          fill = "gray",
          color = "black")




library(sf)
library(dplyr)
library(ggplot2)
library(scales)

# State capitals
capitals <- tibble::tribble(
  ~state, ~lon, ~lat,
  "ALABAMA", -86.7911, 32.3770,
  "ALASKA", -134.4197, 58.3019,
  "CALIFORNIA", -121.4944, 38.5816,
  "CONNECTICUT", -72.6999, 41.7658,
  "DELAWARE", -75.5277, 39.1582,
  "FLORIDA", -84.2807, 30.4383,
  "GEORGIA", -84.3880, 33.7490,
  "LOUISIANA", -91.1871, 30.4515,
  "MAINE", -69.7795, 44.3106,
  "MARYLAND", -76.6413, 38.9784,
  "MASSACHUSETTS", -71.0589, 42.3601,
  "MISSISSIPPI", -90.1848, 32.2988,
  "NEW JERSEY", -74.7429, 40.2170,
  "NEW YORK", -73.7562, 42.6526,
  "NORTH CAROLINA", -78.6382, 35.7796,
  "OREGON", -123.0197, 44.9429,
  "RHODE ISLAND", -71.4128, 41.8239,
  "SOUTH CAROLINA", -81.0348, 34.0007,
  "TEXAS", -97.7431, 30.2672,
  "VIRGINIA", -77.4360, 37.5407,
  "WASHINGTON", -122.9007, 47.0379
)

# Join with landings
landings_cap <- capitals |>
  left_join(landings_by_state |> mutate(state = toupper(state)), by = "state") |>
  mutate(radius = sqrt(total_pounds / pi) / 1000)  # scale for visibility

# Plot
ggplot() +
  geom_sf(data = us_coast,
          fill = "gray95",
          color = "black") +
  geom_point(data = landings_cap,
             aes(x = lon,
                 y = lat,
                 size = total_pounds),
             color = "#1f78b4",
             alpha = 0.7) +
  scale_size_continuous(range = c(1, 20),
                        labels = comma,
                        name = "Pounds") +
  theme_void() +
  labs(title = "Oyster Landings by State Capital (Circle Size = Volume)")


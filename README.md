# U.S. Oyster Landings 1950-2024

By: Jorge Schmidt

# Overview

This repository contains data and code to build a dataset of landings of 
eastern and pacific oysters from 1950 to 2024, inclusive, and calculates 
inflation-adjusted prices. It also calculates volumes and inflation-adjusted 
prices for eastern oysters landed in Florida's east and west coasts. It is 
intended to support feasibility analyses for potential oyster farms on the U.S. 
mainland.

![U.S. inflation-adjusted prices]("/oysters/results/img/adj_revenues_per_lb_us.png")


The final data files ep_oysters_inflation_adjusted and fl_oysters_inflation_adjusted
combine information from the files FOSS_landings.xlsx and CPIAUCSL.csv.

## The analysis is meant to:
 - 1. describe historical trends (volume and pricing) in U.S. landings of fresh oysters (eastern and pacific);
 - 2. describe historical trends (volume and pricing) in Florida landings of fresh oysters on its east and west coasts; and
 - 3. analyze historical inflation-adjusted pricing.


# About the data
data/processed/production_by_year_ep contains 150 rows and 4 columns.

 - year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
 - species -       Character - indicates the species. The options are 
                "OYSTER, PACIFIC" and "OYSTER, EASTERN."
 - total_pounds -  Numeric - total landings in pounds for a given species in a 
                given year.
 - total_dollars - Numeric - total farmgate revenues of the landings for a given 
                species in a given year.
                

data/processed/production_by_year_fl contains 150 rows and 4 columns.

 - year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
 - coast -         Character - indicates the coast. The options are 
                "FLORIDA-EAST" and "FLORIDA-WEST."
 - total_pounds -  Numeric - total landings in pounds for a given species in a 
                given year.
 - total_dollars - Numeric - total farmgate revenues of the landings for a given 
                species in a given year.
                

data/processed/cpi_1940_2024_by_yr contains 75 rows and 2 columns.

 - year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
 - avg_cpi -       Numeric - the average consumer price index for a year.


data/output/ep_oysters_inflation_adjusted contains 150 rows and 6 columns.

 - year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
 - species -       Character - indicates the species. The options are 
                "OYSTER, PACIFIC" and "OYSTER, EASTERN."
 - total_pounds -  Numeric - total landings in pounds for a given species in a 
                given year.
 - total_dollars - Numeric - total farmgate revenues of the landings for a given 
                species in a given year.
 - avg_cpi -       Numeric - the average consumer price index for a year.
 - adj_dollars -   Numeric - the inflation-adjusted price per pound for landings of
                a given species in a given year.

data/output/fl_oysters_inflation_adjusted contains 150 rows and 6 columns.

 - year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
 - coast -         Character - indicates the coast. The options are 
                "FLORIDA-EAST" and "FLORIDA-WEST."
 - total_pounds -  Numeric - total landings in pounds for a given species in a 
                given year.
 - total_dollars - Numeric - total farmgate revenues of the landings for a given 
                species in a given year.
 - avg_cpi -       Numeric - the average consumer price index for a year.
 - adj_dollars -   Numeric - the inflation-adjusted price per pound for landings of
                a given species in a given year.

# The repository contains three main folders:

## data:
### data/raw contains:
 - The landings data [FOSS_landings.xlsx] was obtained from
 https://www.fisheries.noaa.gov/foss/f?p=215:200:7482903932446

 - The inflation data [CPIAUCSL.csv] was obtained from
https://fred.stlouisfed.org/series/CPIAUCSL

### data/processed contains:
 - three files that are the cleaned up and filtered version of the raw data.

### data/output contains:
 - two files that are the result of the analyses.


## scripts
 - scripts/01_processing contains a single script that reads the raw data, cleans it up, and exports processed data.

 - scripts/02_analyses contains two scripts: one calculates inflation-adjusted yearly prices for Eastern and Pacific Oysters, and the other calculates inflation-adjusted yearly prices for landings in Florida's east and west coasts.

 - scripts/03_contents contains a single script that builds seven figures.


## results
### results/img contains seven images displaying 
 - 1. total volume (U.S.); 
 - 2. total revenues (U.S.);
 - 3. revenues per lbs. (U.S.); 
 - 4. Florida volumes; 
 - 5. Florida revenues; 
 - 6. Inflation-adjusted prices (U.S.); and
 - 7. Inflation-adjusted prices (Florida).








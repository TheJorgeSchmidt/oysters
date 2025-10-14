# U.S Oyster Landings 1950-2024

By: Jorge Schmidt

# Overview

This repository contains data and code to build a dataset of landings of fresh 
eastern and pacific oysters from 1950 to 2024, inclusive, and calculates 
inflation-adjusted prices.It is intended to support feasibility analyses for 
potential oyster farms on the U.S. mainland.


The final data ep_oysters_inflation_adjusted combines information from the files 
FOSS_landings.xlsx and CPIAUCSL.csv.

The analysis is meant to:
1. describe historical trends (volume and pricing) in U.S. landings of fresh 
    oysters (eastern and pacific);
2. analyze historical inflation-adjusted pricing by species.

# About the data
data/processed/production_by_year_ep contains 150 rows and 4 columns.

year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
species -       Character - indicates the species. The options are 
                "OYSTER, PACIFC" and "OYSTER, EASTERN."
total_pounds -  Numeric - total landings in pounds for a given species in a 
                given year.
total_dollars - Numeric - total farmgate revenues of the landings for a given 
                species in a given year.


data/processed/cpi_1940_2024_by_yr contains 150 rows and 2 columns.

year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
avg_cpi -       Numeric - the average consumer price index for a year.


data/output/ep_oysters_inflation_adjusted contains 150 rows and 6 columns.

year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
species -       Character - indicates the species. The options are 
                "OYSTER, PACIFC" and "OYSTER, EASTERN."
total_pounds -  Numeric - total landings in pounds for a given species in a 
                given year.
total_dollars - Numeric - total farmgate revenues of the landings for a given 
                species in a given year.
avg_cpi -       Numeric - the average consumer price index for a year.
adj_dollars -   Numeric - the inflation-adjusted price per pound for landings of
                a given species in a given year.

The repository contains three main folders:

data:
data/raw contains:
The landings data [FOSS_landings.xlsx] was obtained from
https://www.fisheries.noaa.gov/foss/f?p=215:200:7482903932446

The inflation data [CPIAUCSL.csv] was obtained from
https://fred.stlouisfed.org/series/CPIAUCSL


data/processed contains the cleaned up and selected version of the raw data data


data/output contains the result of the analysis



scripts
scripts/01_processing contains a single script that reads the raw data, cleans it up, and exports processed data.
scripts/02_analyses
scripts/03_contents contains a single script that builds two figures, shown below
results contains a folder with images


results
results/img contains [n] images displaying 

Data sources:


Build a table of U.S. oysters landings
Select Eastern and Pacific oysters (other species not economically relevant)
Build a table of average yearly cpi (the data is reported monthly)
Join both tables using year as the key








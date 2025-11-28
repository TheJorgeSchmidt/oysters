# U.S. Oyster Landings 1950 - 2024

By: Jorge Schmidt

# Overview

This repository contains data and code to build a dataset of landings of fresh 
oysters from 1950 to 2024, inclusive, and calculates weighed-average 
inflation-adjusted prices for oyster meat during that timeframe. It is intended to support decision-making in the
oyster production and distribution sectors by displaying trends in volumes 
and prices. The report can be found here [https://htmlpreview.github.io/?https://github.com/TheJorgeSchmidt/oysters/blob/main/final_report.html
]

## The analysis is meant to:
 1. describe historical trends (volume and pricing) in U.S. landings of fresh oysters;
 2. analyze historical inflation-adjusted pricing; and
 3. highlight the leading oyster-producing states.


## About the data
data/processed/landings_by_year.rds contains 75 rows and 3 columns.

 - year -          Numeric - the year of the observation, from 1950 through 2024, 

 - total_pounds -  Numeric - total landings in pounds of meat for a 
                given year (excludes shells).
 - total_dollars - Numeric - total farmgate revenues of the landings for a given 
                 year.
                

data/processed/cpi_by_yr,rds contains 75 rows and 2 columns.

 - year -          Numeric - the year of the observation, from 1950 through 2024, 
                inclusive.
 - avg_cpi -       Numeric - the average consumer price index for a year.



# The repository contains three main folders:

## data:
### data/raw contains:
 - The landings data [FOSS_landings.xlsx] was obtained from
 https://www.fisheries.noaa.gov/foss/f?p=215:200:7482903932446

 - The inflation data [CPIAUCSL.csv] was obtained from
https://fred.stlouisfed.org/series/CPIAUCSL


### data/processed contains three files that are the cleaned up and filtered version of the raw data:
 - landings_by_year.rds contains the nationwide data for 1950 - 2024;
 - imports_by_year.rds contains the import data for 2012 - 2014; and
 - cpi_by_yr.rds contains the annualized cpi data from 1950 - 2024.

### data/output contains two files that are the result of the analyses:
 - landings_inflation_adjusted.rds contains the combined nationwide landings and cpi data necessary to calculate inflation-adjusted prices
 - imports_inflation_adjusted.rds contains the imports and cpi data necessary to calculate inflation-adjusted prices


## scripts
 - scripts/01_processing contains three scripts that read the raw data, cleans it up, and exports processed data.

 - scripts/02_analyses contains two scripts: one calculates inflation-adjusted yearly prices for oyster landings, and the other calculates inflation-adjusted yearly prices for oyster imports.

 - scripts/03_contents contains a single script that builds two figures.


## Results

![Volumes](results/img/landings_by_weight.png)



## Results
## Volumes for the past seventy years have steadliy declined:


## But the price per pound of oyster meat rose materially starting in 2013:

![Inflation-adjusted values](results/img/landings_values.png)


results/img contains multiple images displaying, for 1950 - 2024: 
 1. Landings of fresh oysters by weight of oyster meat;
 2. Price per pound in inflation-adjusted dollars of landings; and
 3. The value of production of the top five oyster-producing states. 

The final data files [data/processed/landings_by_year.rds,  
data/processed/imports_by_year.rds, and data/processed/cpi_by_year.rds] contain
information from the files FOSS_landings.xlsx, ANNUAL TRADE-NO AGGREGATION_.xlsx, 
and CPIAUCSL.csv.

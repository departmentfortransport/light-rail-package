# This file contains constants used in the tramlr functions

#
# column_names <- c("no_of_vehicles",
#                   "no_of_stops",
#                   "route_km",
#                   "km_operated",
#                   "total_boardings",
#                   "cons_boardings",
#                   "passenger_km",
#                   "passenger_receipts",
#                   "cons_eld_dis",
#                   "cons_young",
#                   "changes_to_fleet",
#                   "basis",
#                   "source_details",
#                   "description",
#                   "comments")

# Cell positions of values in excel survey form

cells <- list(no_of_vehicles_row = 10,
              no_of_stops_row = 12,
              route_km_row = 13,
              km_operated_row = 21,
              total_boardings_row = 28,
              cons_boardings_row = 29,
              passenger_km_row = 30,
              passenger_receipts_row = 33,
              cons_eld_dis_row = 38,
              cons_young_row = 39,
              changes_to_fleet_row = 16,
              basis_row = 24,
              source_details_row = 43,
              description_row = 49,
              comments_row = 53,
              last_year_col = 3,
              this_year_col = 5,
              text_col = 1)


# Vector of all tram systems

all_tram_systems <- c("Blackpool Tramway",
                      "Docklands Light Railway",
                      "Edinburgh Trams",
                      "Glasgow underground",
                      "London Tramlink",
                      "Manchester Metrolink",
                      "Midland Metro",
                      "Nottingham Express Transit",
                      "Sheffield Supertram",
                      "Tyne and Wear Metro")

# Vector of operators who offer concessionary tickets to young people
# Used in lrt_make_QA_tables

cons_young_operators <- c("Manchester Metrolink",
                          "Midland Metro",
                          "Sheffield Supertram",
                          "Tyne And Wear Metro")


# One hundred per cent

hundy_p <- 100


# Column in which there are numbers
# Used in lrt_make_QA_tables to convert the correct column to numbers
# (because column 1 and 2 are "name" and "year")

number_col <- 3


# Vector of tram systems in England
# Used in calculate_headline_figures

trams_in_england <- c("Blackpool Tramway",
                      "Docklands Light Railway",
                      "London Tramlink",
                      "Manchester Metrolink",
                      "Midland Metro",
                      "Nottingham Express Transit",
                      "Sheffield Supertram",
                      "Tyne And Wear Metro")


# Vector of tram systems in London
# Used in calculate_headline_figures

trams_in_london <- c("Docklands Light Railway",
                     "London Tramlink")


# Vector of tram systems in England outside London
# Used in calculate_headline_figures

trams_in_eol <- c("Blackpool Tramway",
                  "Manchester Metrolink",
                  "Midland Metro",
                  "Nottingham Express Transit",
                  "Sheffield Supertram",
                  "Tyne And Wear Metro")


# Indices for position of location (UK, England, London, England outside London) in
# headline_figures vector
# Used in QA_note.rmd

uk_index <- 1

england_index <- 2

london_index <- 3

eol_index <- 4


# First financial year in publication
# Used in read_gdp_deflator

first_fin_year <- "1983/84"


# Population spreadsheet tab needed for calculations
# Used in read_population_mye

population_mye_tab <- "MYE 5"


# Area codes
# Used in read_population_mye

area_codes <- list(c("E12000007", "Docklands Light Railway"),
                   c("E12000007", "London Tramlink"),
                   c("E06000018", "Nottingham Express Transit"),
                   c("E11000005", "Midland Metro"),
                   c("E11000003", "Sheffield Supertram"),
                   c("E11000007", "Tyne And Wear Metro"),
                   c("E11000001", "Manchester Metrolink"),
                   c("E06000009", "Blackpool Tramway"),
                   c("E12000007", "London"))


# One million
# Used in update_minimal_tidy_dataset

million = 1000000


library(magrittr)
library(dplyr)
library(readr)
library(ggplot2)
# Load wheat dataset
wheat <- readRDS("D:/R_programmer/Introduction to Writing Functions in R/nass.wheat.rds")
corn <- readRDS("D:/R_programmer/Introduction to Writing Functions in R/nass.corn.rds")
# There are 4840 square yards in an acre.
# There are 36 inches in a yard and one inch is 0.0254 meters.
# There are 10000 square meters in a hectare.
# Write a function to convert acres to sq. yards
###############################################################
acres_to_sq_yards <- function(acres) {
  acres * 4840
}
# Write a function to convert yards to meters
yards_to_meters <- function(yards) {
  yards * 0.9144
}
# Write a function to convert sq. meters to hectares
sq_meters_to_hectares <- function(sq_meters) {
  sq_meters * 0.0001
}
###############################################################
get_reciprocal <- function(x) {
  1 / x
}
# Write a function to convert sq. yards to sq. meters
sq_yards_to_sq_meters <- function(sq_yards) {
  sq_yards %>%
    # Take the square root
    sqrt() %>%
    # Convert yards to meters
    yards_to_meters() %>%
    # Square it
    raise_to_power(2)
}
# Write a function to convert acres to hectares
acres_to_hectares <- function(acres) {
  acres %>%
    # Convert acres to sq yards
    acres_to_sq_yards() %>%
    # Convert sq yards to sq meters
    sq_yards_to_sq_meters() %>%
    # Convert sq meters to hectares
    sq_meters_to_hectares()
}
# Define a harmonic acres to hectares function
harmonic_acres_to_hectares <- function(acres) {
  acres %>% 
    # Get the reciprocal
    get_reciprocal() %>%
    # Convert acres to hectares
    acres_to_hectares() %>% 
    # Get the reciprocal again
    get_reciprocal()
}
###############################################################
# Write a function to convert lb to kg
lbs_to_kgs <- function(lbs) {
  lbs * 0.45359237  
}
# Write a function to convert bushels to lbs
bushels_to_lbs <- function(bushels, crop) {
  # Define a lookup table of scale factors
  c(barley = 48, corn = 56, wheat = 60) %>%
    # Extract the value for the crop
    extract(crop) %>%
    # Multiply by the no. of bushels
    multiply_by(bushels)
}
# Write a function to convert bushels to kg
bushels_to_kgs <- function(bushels, crop) {
  bushels %>%
    # Convert bushels to lbs for this crop
    bushels_to_lbs(crop) %>%
    # Convert lbs to kgs
    lbs_to_kgs()
}
# Write a function to convert bushels/acre to kg/ha
bushels_per_acre_to_kgs_per_hectare <- function(bushels_per_acre, crop = c("barley", "corn", "wheat")) {
  # Match the crop argument
  crop <- match.arg(crop)
  bushels_per_acre %>%
    # Convert bushels to kgs for this crop
    bushels_to_kgs(crop) %>%
    # Convert harmonic acres to ha
    harmonic_acres_to_hectares()
}
###############################################################
# View the corn dataset
glimpse(corn)
corn %>%
  # Add some columns
  mutate(
    # Convert farmed area from acres to ha
    farmed_area_ha = acres_to_hectares(farmed_area_acres),
    # Convert yield from bushels/acre to kg/ha
    yield_kg_per_ha = bushels_per_acre_to_kgs_per_hectare(
      yield_bushels_per_acre,
      crop = "corn"
    )
  )
# Wrap this code into a function
fortify_with_metric_units <- function(data, crop) {
  return(data %>%
    mutate(
      farmed_area_ha = acres_to_hectares(farmed_area_acres),
      yield_kg_per_ha = bushels_per_acre_to_kgs_per_hectare(
        yield_bushels_per_acre, 
        crop = crop
      )
    ))
}
# Try it on the wheat dataset
wheat <- fortify_with_metric_units(wheat, "wheat")
###############################################################
# # Using corn, plot yield (kg/ha) vs. year
# ggplot(corn, aes(year, yield_kg_per_ha)) +
#   # Add a line layer, grouped by state
#   geom_line(aes(group = state)) +
#   # Add a smooth trend layer
#   geom_smooth()
# Wrap this plotting code into a function
plot_yield_vs_year <- function(data) {
  ggplot(data, aes(year, yield_kg_per_ha)) +
    geom_line(aes(group = state)) +
    geom_smooth()
}
# Test it on the wheat dataset
plot_yield_vs_year(wheat)
###############################################################
usa_census_regions =read_csv("https://raw.githubusercontent.com/cphalpert/census-regions/master/us%20census%20bureau%20regions%20and%20divisions.csv")
# head(usa_census_regions)
# Wrap this code into a function
fortify_with_census_region <- function(data) {
  data %>%
    inner_join(usa_census_regions, by = c("state"="State"))
}
# head(wheat)
# Try it on the wheat dataset
wheat <- fortify_with_census_region(wheat)
###############################################################
head(wheat)
# Wrap this code into a function
plot_yield_vs_year_by_region <- function(data) {
  plot_yield_vs_year(data) +
    facet_wrap(vars(Division))
}
# Try it on the wheat dataset
plot_yield_vs_year_by_region(wheat)
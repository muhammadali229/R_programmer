library(assertive)
library(dplyr)
library(broom)
library(zeallot)
snake_river_visits <- readRDS("D:/R_programmer/Introduction to Writing Functions in R/snake_river_visits.rds")
# From previous step
run_poisson_regression <- function(data, formula) {
  glm(formula, data, family = poisson)
}
# Re-run the Poisson regression, using your function
model <- snake_river_visits %>%
  run_poisson_regression(n_visits ~ gender + income + travel)
############################################################
is_leap_year <- function(year) {
  # If year is div. by 400 return TRUE
  if(year %% 400 == 0) {
    return(TRUE)
  }
  # If year is div. by 100 return FALSE
  if(year %% 100 == 0) {
    return(FALSE)
  }  
  # If year is div. by 4 return TRUE
  if(year %% 4 == 0) {
    return(TRUE)
  }
  # Otherwise return FALSE
  return(FALSE)
}
############################################################
# Using cars, draw a scatter plot of dist vs. speed
# plt_dist_vs_speed <- plot(dist ~ speed, data = cars)
# # Oh no! The plot object is NULL
# plt_dist_vs_speed
# # Define a pipeable plot fn with data and formula args
# pipeable_plot <- function(data, formula) {
#   # Call plot() with the formula interface
#   plot(formula, data)
#   # Invisibly return the input dataset
#   invisible(data)
# }
# # Draw the scatter plot of dist vs. speed again
# plt_dist_vs_speed <- cars %>% 
#   pipeable_plot(dist ~ speed)
# # Now the plot object has a value
# plt_dist_vs_speed
############################################################
# From previous step
groom_model <- function(model) {
  list(
    model = glance(model),
    coefficients = tidy(model),
    observations = augment(model)
  )
}
# Call groom_model on model, assigning to 3 variables
c(mdl, cff, obs) %<-% groom_model(model)
# See these individual variables
mdl; cff; obs
############################################################
pipeable_plot <- function(data, formula) {
  plot(formula, data)
  # Add a "formula" attribute to data
  attr(data, "formula") <- formula
  invisible(data)
}
# From previous exercise
plt_dist_vs_speed <- cars %>% 
  pipeable_plot(dist ~ speed)
# Examine the structure of the result
plt_dist_vs_speed
############################################################
# Add capitals, national_parks, & population to a named list
rsa_lst <- list(
  capitals = capitals,
  national_parks = national_parks,
  population = population
)
# List the structure of each element of rsa_lst
ls.str(rsa_lst) 
# Convert the list to an environment
rsa_env <- list2env(rsa_lst)
# List the structure of each variable
ls.str(rsa_env)
# Find the parent environment of rsa_env
parent <- parent.env(rsa_env)
# Print its name
environmentName(parent)
############################################################
# Compare the contents of the global environment and rsa_env
ls.str(globalenv())
ls.str(rsa_env)
# Does population exist in rsa_env?
exists("population", envir = rsa_env)
# Does population exist in rsa_env, ignoring inheritance?
exists("population", envir = rsa_env, inherits = FALSE)
############################################################
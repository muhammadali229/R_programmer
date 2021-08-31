library(dplyr)
snake_river_visits <- readRDS("D:/R_programmer/Introduction to Writing Functions in R/snake_river_visits.rds")
# # Look at the gold medals data
# gold_medals
# # Note the arguments to median()
# args(median)
# # Rewrite this function call, following best practices
# median(gold_medals, na.rm = TRUE)
# # Note the arguments to rank()
# args(rank)
# # Rewrite this function call, following best practices
# rank(-gold_medals, na.last = "keep", ties.method = "min")
###############################################################
# Your functions, from previous steps
toss_coin <- function() {
  coin_sides <- c("head", "tail")
  sample(coin_sides, 1)
}
# Call your function
toss_coin()
###############################################################
# Update the function to return n coin tosses
toss_coin <- function(n_flips) {
  coin_sides <- c("head", "tail")
  sample(coin_sides, size = n_flips, replace = TRUE)
}
# Generate 10 coin tosses
toss_coin(10)
###############################################################
# Update the function so heads have probability p_head
toss_coin <- function(n_flips, p_head) {
  coin_sides <- c("head", "tail")
  # Define a vector of weights
  weights <- c(p_head, 1 - p_head)
  # Modify the sampling to be weighted
  sample(coin_sides, n_flips, replace = TRUE, prob = weights)
}
# Generate 10 coin tosses
toss_coin(10, 0.8)
###############################################################
# From previous step
run_poisson_regression <- function(data, formula) {
  glm(formula, data, family = poisson)
}
# Re-run the Poisson regression, using your function
model <- snake_river_visits %>%
  run_poisson_regression(n_visits ~ gender + income + travel)
snake_river_explanatory <- snake_river_visits %>%
  select(gender, income, travel) %>%
  na.omit()
# Run this to see the predictions
snake_river_explanatory %>%
  mutate(predicted_n_visits = predict(model, ., type = "response"))%>%
  arrange(desc(predicted_n_visits))
###############################################################
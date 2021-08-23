# Load the data set
data(movies, package = "ggplot2movies") 
# Load the profvis package
library(profvis)
# Profile the following code with the profvis function
# profvis({
#   # Load and select data
#   comedies <- movies[movies$Comedy == 1, ]
#   # Plot data of interest
#   plot(comedies$year, comedies$rating)
#   # Loess regression line
#   model <- loess(rating ~ year, data = comedies)
#   j <- order(comedies$year)
#   # Add fitted line to the plot
#   lines(comedies$year[j], model$fitted[j], col = "red")
# })     ## Remember the closing brackets}!
#################################################################
# Load the microbenchmark package
library(microbenchmark)
# The previous data frame solution is defined
# d() Simulates 6 dices rolls
d <- function() {
  data.frame(
    d1 = sample(1:6, 3, replace = TRUE),
    d2 = sample(1:6, 3, replace = TRUE)
  )
}
# Complete the matrix solution
m <- function() {
  matrix(sample(1:6, 6, replace = TRUE), ncol = 2)
}
# Use microbenchmark to time m() and d()
microbenchmark(
  data.frame_solution = d(),
  matrix_solution     = m()
)
#################################################################
rolls <- function() {
  matrix(sample(1:6, 6, replace = TRUE), ncol = 2)
}
# Example data
rolls()
# Define the previous solution 
app <- function(x) {
  apply(x, 1, sum)
}
# Define the new solution
r_sum <- function(x) {
  rowSums(x)
}
# Compare the methods
microbenchmark(
  app_sol = app(rolls()),
  r_sum_sol = r_sum(rolls())
)
eg_mat <- matrix(1:6, ncol = 2)
eg_mat
rowSums(eg_mat)
apply(eg_mat, 1, sum)
apply(eg_mat, 2, sum)
#################################################################
# Example data
is_double <- c(FALSE, TRUE, TRUE)
class(is_double)
is_double
# Define the previous solution
move <- function(is_double) {
  if (is_double[1] & is_double[2] & is_double[3]) {
    current <- 11 # Go To Jail
  }
}
# Define the improved solution
improved_move <- function(is_double) {
  if (is_double[1] && is_double[2] && is_double[3]) {
    current <- 11 # Go To Jail
  }
}
# microbenchmark both solutions
# Very occassionally the improved solution is actually a little slower
# This is just random chance
microbenchmark(move, improved_move, times = 1e5)
#################################################################
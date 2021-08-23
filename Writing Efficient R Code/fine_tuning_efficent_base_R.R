# Load the microbenchmark package
library(microbenchmark)
n = 10
## Method 1
x_seq <- function(n) 1:n
## Method 2
x_vector <- function(n) {
  x <- vector("numeric"
            , n) # length n
  for(i in 1:n)
    x[i] <- i 
  }
## Method 3
x_null <- function(n) {
  x <- NULL # Length zero
  for(i in 1:n)
    x <- c(x, i)
  }
microbenchmark(
  x_seq(n),
  x_vector(n),
  x_null(n),
  times = 10
)
#################################################################
n <- 30000
# Slow code
growing <- function(n) {
  x <- NULL
  for(i in 1:n)
    x <- c(x, rnorm(1))
  x
}
# Use <- with system.time() to store the result as res_grow
# Using the system.time() function, find how long it takes to generate 
# n = 30000 random standard normal numbers using the growing() function
# Use the <- trick to store the result in a vector called res_grow
system.time(res_grow <- growing(n))
#################################################################
n <- 30000
# Fast code
pre_allocate <- function(n) {
  x <- numeric(n) # Pre-allocate to numeric type vector
  for(i in 1:n) 
    x[i] <- rnorm(1)
  x
}
# Use <- with system.time() to store the result as res_allocate
system.time(res_allocate <- pre_allocate(n))
#################################################################
x <- rnorm(10)
x2 <- numeric(length(x))
for(i in 1:10)
  x2[i] <- x[i] * x[i]
# Rewrite that code using a vectorized solution. Hints:
#   Your solution should be a single line of code.
# You should not use a for loop.
# The multiplication operator is vectorized!
# Store your answer as x2_imp
x2_imp <- x * x
#################################################################
# Initial code
n <- 100
total <- 0
x <- runif(n)
for(i in 1:n) 
  total <- total + log(x[i])
# Rewrite in a single line. Store the result in log_sum
log_sum <- sum(log(x))
#################################################################
c <- matrix(1:9, nrow = 3, byrow = TRUE)
c
c[, 1] # column 1
c[1, ] # row 1
# Using the microbenchmark() function, how long does it take to select 
# the first column from each of these object? In other words, which is 
# faster mat[, 1] or df[, 1]?
# Which is faster, mat[, 1] or df[, 1]? 
# microbenchmark(mat[, 1], df[, 1])
#################################################################
# Which is faster, mat[1, ] or df[1, ]? 
# microbenchmark(mat[1, ], df[1, ])
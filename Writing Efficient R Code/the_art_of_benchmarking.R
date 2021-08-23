# Load the microbenchmark package
library(microbenchmark)
# Load the benchmarkme package
library('benchmarkme')
# movies dataset path
movies <- "D:/R_programmer/Writing Efficient R Code/movies.rds"
###########################################################
# Print the R version details using version
print(version)

# Assign the variable major to the major component
major <- version$major

# Assign the variable minor to the minor component
minor <- version$minor

############################################################
system.time(sqrt(1:1e7))
# How long does it take to read movies from CSV?
# system.time(read.csv("movies.csv"))
# How long does it take to read movies from RDS?
system.time(readRDS(movies))
############################################################
# Compare the two functions
compare <- microbenchmark(#read.csv('movies.csv'), 
                          readRDS(movies), 
                          times = 10)
# Print compare
print(compare)
colon <- function(n) 1:n
seq_default <- function(n) seq(1, n)
seq_by <- function(n) seq(1, n, by = 1)
# compare seq function 
microbenchmark(
  colon(1e5),
  seq_default(1e5),
  seq_by(1e5),
  times = 10
)
############################################################
# Assign the variable ram to the amount of RAM on this machine
ram <- get_ram()
ram
# Assign the variable cpu to the cpu specs
cpu <- get_cpu()
cpu
############################################################
# Find the time it takes to read and write a 5 MB file.
res <- benchmark_io(runs = 1, size = 5)
# Plot the results
plot(res)
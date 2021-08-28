library(stringr)
library(stringi)
library(rebus)
catcidents <- readRDS("D:/R_programmer/String Manipulation with stringr in R/catcidents.rds")
earnest_file <- "D:/R_programmer/String Manipulation with stringr in R/importance-of-being-earnest.txt"
# Read play in using stri_read_lines()
earnest <- stri_read_lines(earnest_file)
# Read play in using stri_read_lines()
earnest <- stri_read_lines(earnest_file)
# Detect start and end lines
start <- str_which(earnest, "START OF THE PROJECT")
start
end <- str_which(earnest, "END OF THE PROJECT")
end
# Get rid of gutenberg intro text
earnest_sub  <- earnest[(start + 1):(end - 1)]
head(earnest_sub, 10)
# Detect first act
lines_start <- str_which(earnest_sub, "FIRST ACT")
# Set up index
intro_line_index <- 1:(lines_start - 1)
intro_line_index
# Split play into intro and play
intro_text <- earnest_sub[intro_line_index]
play_text <- earnest_sub[-intro_line_index]
# Take a look at the first 20 lines
writeLines(head(play_text, 20))
#################################################
# Get rid of empty strings
empty <- stri_isempty(play_text)
play_lines <- play_text[!empty]
play_lines[10:15]
#################################################
# Pattern for start, word then .
pattern_1 <- START %R% one_or_more(WRD) %R% DOT
# Test pattern_1
str_view(play_lines, pattern_1, match = TRUE) 
str_view(play_lines, pattern_1, match = FALSE)
# Pattern for start, capital, word then .
pattern_2 <- START %R% ascii_upper() %R% one_or_more(WRD) %R% DOT
# Test pattern_2
str_view(play_lines, pattern_2, match = TRUE)
str_view(play_lines, pattern_2, match = FALSE)
# Pattern from last step
pattern_2 <- START %R% ascii_upper() %R% one_or_more(WRD) %R% DOT
# Get subset of lines that match
lines <- str_subset(play_lines, pattern = pattern_2)
head(lines)
# Extract match from lines
who <- str_extract(lines, pattern = pattern_2)
head(who)
# Let's see what we have
unique(who)
#################################################
# Create vector of characters
characters <- c("Algernon", "Jack", "Lane", "Cecily", "Gwendolen", "Chasuble", 
                "Merriman", "Lady Bracknell", "Miss Prism")
# Match start, then character name, then .
pattern_3 <- START %R% or1(characters) %R% DOT
# View matches of pattern_3
str_view(play_lines, pattern = pattern_3, match = TRUE)
# View non-matches of pattern_3
str_view(play_lines, pattern = pattern_3, match = FALSE)
# Pull out matches
lines <- str_subset(play_lines, pattern_3)
# Extract match from lines
who <- str_extract(lines, pattern_3)
# Let's see what we have
unique(who)
# Count lines per character
table(who)
#################################################
# catcidents has been pre-defined
head(catcidents)
# Construct pattern of DOG in boundaries
whole_dog_pattern <- whole_word("DOG")
# See matches to word DOG
str_view(catcidents, pattern = whole_dog_pattern, match = TRUE)
# Transform catcidents to upper case
catcidents_upper <- str_to_upper(catcidents)
# View matches to word "DOG" again
str_view(catcidents_upper, whole_dog_pattern, match = TRUE)
# Which strings match?
has_dog <- str_detect(catcidents_upper, whole_dog_pattern)
# Pull out matching strings in original 
catcidents[has_dog]
#################################################
# View matches to "TRIP"
str_view(catcidents, pattern = "TRIP", match = TRUE)
# Construct case insensitive pattern
trip_pattern <- regex("TRIP", ignore_case = TRUE)
# View case insensitive matches to "TRIP"
str_view(catcidents, pattern = trip_pattern, match = TRUE)
# Get subset of matches
trip <- str_subset(catcidents, trip_pattern)
# Extract matches
str_extract(trip, trip_pattern)
#################################################
# Get first five catcidents
cat5 <- catcidents[1:5]
# Take a look at original
writeLines(cat5)
# Transform to title case
writeLines(str_to_title(cat5))
# Transform to title case with stringi
writeLines(stri_trans_totitle(cat5))
# Transform to sentence case with stringi
writeLines(stri_trans_totitle(cat5, type = "sentence"))
#################################################
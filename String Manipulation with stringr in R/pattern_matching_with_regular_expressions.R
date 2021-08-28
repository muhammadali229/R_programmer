library(stringr)
library(rebus)
# library(babynames)
babynames <- read_csv("D:/R_programmer/String Manipulation with stringr in R/babynames.csv")
boy_names <- filter(babynames, sex == "M")$name
boy_names
girl_names <- filter(babynames, sex == "F")$name
# boy_names <- babynames$name
# girl_names <- babynames$name
# head(boy_names)
# Some strings to practice with
x <- c("cat", "coat", "scotland", "tic toc")
# Print END
END
# Run me
str_view(x, pattern = START %R% "c")
# Match the strings that start with "co" 
str_view(x, pattern = START %R% "co")
# Match the strings that end with "at"
str_view(x, pattern = "at" %R% END)
# Match the string that is exactly "cat"
str_view(x, pattern = START %R% "cat" %R% END)
##############################################################
# It will only match 1 char between C and T so not coat
str_view(x, pattern = "c" %R% ANY_CHAR %R% "t")
# Match two characters, where the second is a "t"
str_view(x, pattern = ANY_CHAR %R% "t")
# Match a "t" followed by any character
str_view(x, pattern = "t" %R% ANY_CHAR)
# Match two characters
str_view(x, pattern = ANY_CHAR %R% ANY_CHAR)
# Match a string with exactly three characters
str_view(x, pattern = START %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% END)
##############################################################
pattern <- "t" %R% ANY_CHAR
# Find names that have the pattern
names_with_t <- str_subset(boy_names, pattern)
# How many names were there?
length(names_with_t)
# Find part of name that matches pattern
part_with_t <- str_extract(boy_names, pattern)
# Get a table of counts
table(part_with_t)
# Did any names have the pattern more than once?
count_of_t <- str_count(boy_names, pattern)
# Get a table of counts
table(count_of_t)
# Which babies got these names?
with_t <- str_detect(boy_names, pattern)
# What fraction of babies got these names?
mean(with_t)
##############################################################
# Match Jeffrey or Geoffrey
whole_names <- or("Jeffrey", "Geoffrey")
str_view(boy_names, pattern = whole_names, match = TRUE)
# Match Jeffrey or Geoffrey, another way
common_ending <- or("Je", "Geo") %R% "ffrey"
str_view(boy_names, pattern = common_ending, match = TRUE)
# Match with alternate endings
by_parts <- or("Je", "Geo") %R% "ff" %R% or("ry", "ery", "rey", "erey")
str_view(boy_names, pattern = by_parts, match = TRUE)
# Match names that start with Cath or Kath
ckath <- START %R% or("C", "K") %R% "ath"
str_view(girl_names, pattern = ckath, match = TRUE)
##############################################################
x <- c("grey sky", "gray elephant")
# Create character class containing vowels
vowels <- char_class("aeiouAEIOU")
# Print vowels
vowels
# See vowels in x with str_view()
str_view(x, pattern = vowels)
# See vowels in x with str_view_all()
str_view_all(x, pattern = vowels)
# Number of vowels in boy_names
num_vowels <- str_count(boy_names, pattern = vowels)
num_vowels
# Number of characters in boy_names
name_length <- str_length(boy_names)
name_length
# Calc mean number of vowels
mean(num_vowels)
# Calc mean fraction of vowels per name
mean(num_vowels / name_length)
##############################################################
# Vowels from last exercise
vowels <- char_class("aeiouAEIOU")
# See names with only vowels
str_view(boy_names, 
         pattern = exactly(
           one_or_more(vowels)
         ), 
         match = TRUE)
# Use `negated_char_class()` for everything but vowels
not_vowels <- negated_char_class("aeiouAEIOU")
# See names with no vowels
str_view(boy_names, 
         pattern = exactly(
           one_or_more(not_vowels)
         ), 
         match = TRUE)
##############################################################
contact <- c(
  "Call me at 555-555-0191",                 
  "123 Main St",                             
  "(555) 555 0191",                          
  "Phone: 555.555.0191 Mobile: 555.555.0192"
)
# Create a three digit pattern
three_digits <- DGT
# Test it
str_view_all(contact, pattern = three_digits)
# Create a separator pattern
separator <- SPC

# Test it
str_view_all(contact, pattern = separator)
# Use these components
three_digits <- DGT %R% DGT %R% DGT
four_digits <- three_digits %R% DGT
separator <- char_class("-.() ")
# Create phone pattern
phone_pattern <- optional(OPEN_PAREN) %R%
  three_digits %R%
  zero_or_more(separator) %R%
  three_digits %R% 
  zero_or_more(separator) %R%
  four_digits
# Test it           
str_view_all(contact, pattern = phone_pattern)
# Extract phone numbers
str_extract(contact, phone_pattern)
# Extract ALL phone numbers
str_extract_all(contact, phone_pattern)
##############################################################
narratives <- readRDS("D:/R_programmer/String Manipulation with stringr in R/narratives.rds")
# Use these patterns
age <- DGT %R% optional(DGT)
unit <- optional(SPC) %R% or("YO", "YR", "MO")
# Pattern to match gender
gender <- optional(SPC) %R% or("M", "F")
# Test pattern with age then units then gender
str_view(narratives, pattern = age %R% unit %R% gender)
# Extract age, unit, gender
str_extract(narratives, pattern = age %R% unit %R% gender)
##############################################################
age_gender <- age %R% gender
# age_gender, age, gender, unit are pre-defined
ls.str()
# Extract age and make numeric
as.numeric(str_extract(age_gender, age))
# Replace age and units with ""
genders <- str_remove(age_gender, age %R% unit)
# Replace extra spaces
str_remove_all(genders, one_or_more(SPC))
# Numeric ages, from previous step
ages_numeric <- as.numeric(str_extract(age_gender, age))
# Extract units 
time_units <- str_extract(age_gender, unit)
# Extract first word character
time_units_clean <- str_extract(time_units, WRD)
# Turn ages in months to years
ifelse(time_units_clean == "Y", ages_numeric, ages_numeric / 12)
##############################################################
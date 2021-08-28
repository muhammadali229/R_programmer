library(stringr)
library(rebus)
library(readr)
library(babynames)
boy_names <- babynames$name
adverbs <-read_csv("D:/R_programmer/String Manipulation with stringr in R/adverbs.rds")
hero_contacts <- c(
  "(wolverine@xmen.com)", "wonderwoman@justiceleague.org",
  "thor@avengers.com"            
)
# Capture parts between @ and . and after .
email <- capture(one_or_more(WRD)) %R% 
  "@" %R% capture(one_or_more(WRD)) %R% 
  DOT %R% capture(one_or_more(WRD))
# Check match hasn't changed
str_view(hero_contacts, pattern = email)
# Pull out match and captures
email_parts <- str_match(hero_contacts, pattern = email)
email_parts
# Save host
host <- email_parts[ ,3]
host
##############################################################
contact <- c(
  "Call me at 555-555-0191",                 
  "123 Main St",                             
  "(555) 555 0191",                          
  "Phone: 555.555.0191 Mobile: 555.555.0192"
)
# View text containing phone numbers
contact
three_digits <- DGT %R% DGT %R% DGT
four_digits <- three_digits %R% DGT
separator <- char_class("-.() ")
# Add capture() to get digit parts
phone_pattern <- capture(three_digits) %R% zero_or_more(separator) %R% 
  capture(three_digits) %R% zero_or_more(separator) %R%
  capture(four_digits)
# Pull out the parts with str_match()
phone_numbers <- str_match(
  contact,
  pattern = phone_pattern
)
phone_numbers
# Put them back together
str_c(
  "(",
  phone_numbers[ ,2],
  ")",
  " ",
  phone_numbers[ ,3],
  "-",
  phone_numbers[ ,4])
##############################################################
narratives <- readRDS("D:/R_programmer/String Manipulation with stringr in R/narratives.rds")
# narratives has been pre-defined
narratives
# Add capture() to get age, unit and sex
pattern <- capture(optional(DGT) %R% DGT) %R%  
  optional(SPC) %R% capture(or("YO", "YR", "MO")) %R%
  optional(SPC) %R% capture(or("M", "F"))
# Pull out from narratives
str_match(narratives, pattern)
# Edit to capture just Y and M in units
pattern2 <- capture(optional(DGT) %R% DGT) %R%  
  optional(SPC) %R% capture(or("Y", "M")) %R% optional(or("O","R")) %R%
  optional(SPC) %R% capture(or("M", "F"))
# Check pattern
str_view(narratives, pattern2)
# Pull out pieces
str_match(narratives, pattern2)
##############################################################
str_view(c("hello", "sweet", "kitten"), 
         pattern = capture(LOWER) %R% REF1)
# Names with three repeated letters
repeated_three_times <- capture(LOWER) %R% REF1 %R% REF1
# Test it
str_view(boy_names, pattern = repeated_three_times, match = TRUE)
# Names with a pair of repeated letters
pair_of_repeated <- capture(LOWER %R% LOWER) %R% REF1
# Test it
str_view(boy_names, pattern = pair_of_repeated, match = TRUE)
# Names with a pair that reverses
pair_that_reverses <- capture(
  LOWER) %R%
  capture(LOWER) %R% REF2 %R% REF1 
# Test it
str_view(boy_names, pattern = pair_that_reverses, match = TRUE)
# Four letter palindrome names
four_letter_palindrome <- exactly(
  capture(
    LOWER) %R%
    capture(LOWER) %R% REF2 %R% REF1 
)
# Test it
str_view(boy_names, pattern = four_letter_palindrome, match = TRUE)
##############################################################
# View text containing phone numbers
contact
# Replace digits with "X"
str_replace(contact, DGT, "X")
# Replace all digits with "X"
str_replace_all(contact, DGT, "X")
# Replace all digits with different symbol
str_replace_all(contact, DGT, c("X", ".", "*", "_"))
##############################################################
x <- c("hello", "sweet", "kitten")
str_replace(x, capture(ANY_CHAR), str_c(REF1, REF1))
# Build pattern to match words ending in "ING"
pattern <- one_or_more(WRD) %R% "ING"
str_view(narratives, pattern)
# Test replacement
str_replace(narratives, capture(pattern), 
            str_c("CARELESSLY", REF1, sep = " "))
# One adverb per narrative
adverbs_10 <- adverbs[sample(nrow(adverbs), 10, replace = FALSE, prob = NULL), ]
# Replace "***ing" with "adverb ***ly"
str_replace(narratives, 
            capture(pattern),
            str_c(adverbs_10, REF1, sep = " "))  
##############################################################
# Names with builtin accents
(tay_son_builtin <- c(
  "Nguy\u1ec5n Nh\u1ea1c", 
  "Nguy\u1ec5n Hu\u1ec7",
  "Nguy\u1ec5n Quang To\u1ea3n"
))
# Convert to separate accents
tay_son_separate <- stri_trans_nfd(tay_son_builtin)
# Verify that the string prints the same
tay_son_separate
# Match all accents
str_view_all(tay_son_separate, UP_DIACRITIC)
##############################################################
# tay_son_separate has been pre-defined
tay_son_separate
# View all the characters in tay_son_separate
str_view_all(tay_son_separate, ANY_CHAR)
# View all the graphemes in tay_son_separate
str_view_all(tay_son_separate, GRAPHEME)
# Combine the diacritics with their letters
tay_son_builtin <- stri_trans_nfc(tay_son_separate)
tay_son_builtin
# View all the graphemes in tay_son_builtin
str_view_all(tay_son_builtin, GRAPHEME)
##############################################################
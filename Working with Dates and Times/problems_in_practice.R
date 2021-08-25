library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)
library(microbenchmark)
library(fasttime)
akl_hourly_raw <- read_csv("D:/R_programmer/Working with Dates and Times/akl_weather_hourly_2016.csv")
# Use make_date() to combine year, month and mday 
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday))
# Parse datetime_string 
akl_hourly <- akl_hourly  %>% 
  mutate(
    datetime_string = paste(date, time, sep = "T"),
    datetime = ymd_hms(datetime_string)
  )
##############################################################
# Game2: CAN vs NZL in Edmonton
game2 <- mdy_hm("June 11 2015 19:00")
# Game3: CHN vs NZL in Winnipeg
game3 <- mdy_hm("June 15 2015 18:30")
# Set the timezone to "America/Edmonton"
game2_local <- force_tz(game2, tzone = "America/Edmonton")
game2_local
# Set the timezone to "America/Winnipeg"
game3_local <- force_tz(game3, tzone = "America/Winnipeg")
game3_local
# How long does the team have to rest?
as.period(game2_local %--% game3_local)
##############################################################
# What time is game2_local in NZ?
with_tz(game2_local, tzone = "Pacific/Auckland")
# What time is game2_local in Corvallis, Oregon?
with_tz(game2_local, tzone = "America/Los_Angeles")
# What time is game3_local in NZ?
with_tz(game3_local, tzone = "Pacific/Auckland")
##############################################################
# Examine structure of time column
str(akl_hourly$time)
# Examine head of time column
head(akl_hourly$time)
# A plot using just time
ggplot(akl_hourly, aes(x = time, y = temperature)) +
  geom_line(aes(group = make_date(year, month, mday)), alpha = 0.2)
##############################################################
dates <- akl_hourly$datetime
# Examine structure of dates
str(dates)
# Use fastPOSIXct() to parse dates
fastPOSIXct(dates) %>% str()
# Compare speed of fastPOSIXct() to ymd_hms()
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  times = 20)
##############################################################
# Head of dates
head(dates)
# Parse dates with fast_strptime
fast_strptime(dates, 
              format = "%Y-%m-%dT%H:%M:%SZ") %>% str()
# Comparse speed to ymd_hms() and fasttime
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  fast_strptime = fast_strptime(dates, 
                                format = "%Y-%m-%dT%H:%M:%SZ"),
  times = 20)
##############################################################
# Create a stamp based on "Saturday, Jan 1, 2000"
date_stamp <- stamp("Saturday, Jan 1, 2000")
# Print date_stamp
date_stamp
# Call date_stamp on today()
date_stamp(today())
# Create and call a stamp based on "12/31/1999"
stamp("12/31/1999")(today())
# Use string finished for stamp()
finished <- "I finished 'Dates and Times in R' on Thursday, September 4, 2017!"
stamp(finished)(today())
##############################################################
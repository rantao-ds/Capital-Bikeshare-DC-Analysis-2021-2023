# note: Please download the dataset from Kaggle and update the file path accordingly
# dataset: https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408/data

library(tidyverse)

# loading the datasets
ob <- read_csv("data/daily_rent_detail.csv")
weather <- read_csv("data/weather.csv")

# creating a new variable for trip duration (minutes)
ob <- ob %>%
mutate(
duration_min = as.numeric(difftime(ended_at, started_at, units = "mins")))

# removing variables not related to EDA analysis
ob <- ob %>%
select(-ride_id, -start_station_name,-end_station_name,-start_lat,-start_lng,-end_lat,-end_lng)

# separating started/ended datetime into date and time variables 
ob <- ob %>%
separate(started_at, c("started_date","started_time"),sep=" ")
ob <- ob %>%
separate(ended_at, c("ended_date","ended_time"),sep=" ")

# dropping ended time
ob <- ob %>%
select(-ended_time)

# creating pick-up time window variable: morning(7-12), afternoon(12-17), evening(17-21), night
library(lubridate)
ob <- ob %>% 
mutate(
started_hour = hour(hms(started_time)),
time_of_day = case_when(
started_hour >= 7 & started_hour < 12 ~ "Morning",
started_hour >= 12 & started_hour < 17 ~ "Afternoon",
started_hour >= 17 & started_hour < 21 ~ "Evening",
TRUE ~ "Night"
))


# creating return type variable: same-day or next-day 
ob <- ob %>%
mutate(
return = ifelse(started_date == ended_date, "same_day", "next_day")
)

# creating trip pattern variable: round-trip or one-way
ob <- ob %>%
mutate(
trip_pattern = if_else(
start_station_id == end_station_id,
"round_trip",
"one_way"))

# converting character variables to factors for modeling
ob$member_casual <- factor(
ob$member_casual,
levels = c("member","casual"))

ob$return <- factor(
ob$return,
levels = c("next_day","same_day"))

ob$trip_pattern <- factor(
ob$trip_pattern,
levels = c("one_way","round_trip")
)

ob$rideable_type <- factor(
ob$rideable_type,
levels = c("docked_bike","classic_bike","electric_bike"))

ob$started_date <- as.Date(ob$started_date)

#removing unnecessary variables and reordering columns
ob <- ob %>%
select(-started_time, -ended_date, -started_hour)

ob<- rename(ob, membership =member_casual)
ob <- rename(ob, pick_up= time_of_day)

ob <- ob %>%
relocate(pick_up,.after=rideable_type)

ob <- ob %>%
relocate(return,.after=pick_up)

ob <- ob %>%
relocate(duration_min,.after=rideable_type)

ob <- ob %>%
relocate(trip_pattern,.after=return)

ob <- ob %>%
relocate(membership,.after=trip_pattern)

# checking and removing invalid values
colSums(is.na(ob))
ob <- ob %>%
filter(
!is.na(start_station_id), 
!is.na(end_station_id),
!is.na(trip_pattern))

colSums(ob == 0)
ob <- ob %>%
filter(duration_min !=0)

# saving the cleaned dataset
saveRDS(ob,"bike_share.rds") 

# removing variables not related to analysis from weather dataset
wt <- weather %>%
select(-stations, -description,-moonphase,-sunset,-sunrise,-severerisk,-solarenergy,-solarradiation, -name,-icon, -conditions, -uvindex,-visibility,-sealevelpressure,-winddir,-windgust,-snowdepth,-snow,-preciptype,-precipprob,-dew,-feelslike,-feelslikemin,-feelslikemax,-tempmin,-tempmax,-humidity,-precipcover)

# checking invalid values
colSums(is.na(wt))
colSums(wt == 0)

# saving th dataset 
save(wc, file = "weather_clean.Rdata")

# joining weather and bikeshare datasets
bike_clean <- left_join(ob,wt, by=c("started_date" = "datetime"))


# double checking for invalid values and saving final dataset
colSums(is.na(bike_clean))
colSums(bike_clean == 0)

saveRDS(bike_clean,"bikeshare_clean.rds")


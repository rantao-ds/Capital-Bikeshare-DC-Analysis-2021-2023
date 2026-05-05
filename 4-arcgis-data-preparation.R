# note: Please download the dataset from Kaggle and update the file path accordingly
# dataset: https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408/data

library(tidyverse)

# loading the datasets
ob1 <- read_csv("data/daily_rent_detail.csv")

# creating a station geographical lookup dataset
station_start <- ob1 %>%
select(start_station_id, start_station_name,start_lat,start_lng)

# checking and removing invalid values
colSums(is.na(station_start))
colSums(station_start == 0)

station_start <- station_start %>%
filter(!is.na(start_station_id),
!is.na(start_station_name),
!is.na(start_lat),
!is.na(start_lng)) %>%
distinct(start_station_id, .keep_all = TRUE)


# renaming as station_lookup for ArcGIS spatial analysis
station_lookup <- station_start


# aggregating total trips by station for member users
gis_member <- eda_final %>%
filter(membership == "member") %>%
group_by(start_station_id) %>%
summarise(total_trips = n(), .groups = "drop")

# joining with station lookup to get latitude and longitude
gis_member_station <- left_join(gis_member,station_lookup,by = "start_station_id")

# exporting to CSV for ArcGIS spatial analysis
write.csv(gis_casual_station, "gis_casual_station.csv", row.names = FALSE)


# the same process for casual users
gis_causal <- eda_final %>%
filter(membership == "casual") %>%
group_by(start_station_id) %>%
summarise(total_trips = n(), .groups = "drop")

gis_casual_station <- left_join(gis_causal, station_lookup ,by = "start_station_id") 
write.csv(gis_casual_station, "gis_casual_station.csv", row.names = FALSE)


# the same process for weekday rides
gis_weekday <- eda_final %>%
filter(weekend == FALSE) %>%
group_by(start_station_id) %>%
summarise(total_trips = n(),.groups = "drop")

gis_weekday_station <- left_join(gis_weekday,station_lookup, by = "start_station_id")
write.csv(gis_weekday_station,"gis_weekday_station.csv",row.names = FALSE)

# the same process for weekend rides
gis_weekend <- eda_final %>%
filter(weekend == TRUE) %>%
group_by(start_station_id) %>%
summarise(total_trips = n(),.groups = "drop")

gis_weekend_station <- left_join(gis_weekend,station_lookup, by = "start_station_id")
write.csv(gis_weekend_station,"gis_weekend_station.csv",row.names = FALSE)

# the same process for morning rides
gis_morning <- eda_final %>%
filter(pick_up == "Morning") %>%
group_by(start_station_id) %>%
summarise(total_trips = n(),.groups = "drop")

gis_morning_station <- left_join(gis_morning,station_lookup, by = "start_station_id")
write.csv(gis_morning_station,"gis_morning_station.csv",row.names = FALSE)

# the same process for afternoon rides
gis_afternoon <- eda_final %>%
filter(pick_up == "Afternoon") %>%
group_by(start_station_id) %>%
summarise(total_trips = n(),.groups = "drop")

gis_afternoon_station <- left_join(gis_afternoon,station_lookup, by = "start_station_id")
write.csv(gis_afternoon_station,"gis_afternoon_station.csv",row.names = FALSE)

# the same process for evening rides
gis_evening <- eda_final %>%
filter(pick_up == "Evening") %>%
group_by(start_station_id) %>%
summarise(total_trips = n(),.groups = "drop")

gis_evening_station <- left_join(gis_evening,station_lookup, by = "start_station_id")
write.csv(gis_evening_station,"gis_evening_station.csv",row.names = FALSE)



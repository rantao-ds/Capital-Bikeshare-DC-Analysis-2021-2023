# final dataset adjustments for EDA analysis
# removing trips exceeding 24 hours per Capital Bikeshare's rental agreement
bike_eda <- bike_clean %>%
filter(between(duration_min,1,1440))

bike_eda %>%
summarise(
mean = mean(duration_min),
max = max(duration_min),
min = min(duration_min))

# removing dates outside 2021-2023 to ensure three complete years
range(bike_eda$started_date)

bike_eda <- bike_eda %>%
filter(year(started_date) %in% c(2021,2022,2023))

# adding month, year, and weekday columns
bike_eda <- bike_eda %>%
mutate(
year = year(started_date),
month = month(started_date, label=TRUE), 
weekday = wday(started_date, label=TRUE), 
weekend = ifelse(weekday %in% c("Sat", "Sun"), TRUE, FALSE))

# removing the outlier — only one docked bike trip recorded among member users
eda_final <- bike_eda %>%
filter(!(membership == "member" &
rideable_type == "docked_bike"))

# saving the cleaned dataset 
saveRDS(eda_final,"eda_final.rds")

1. WHO are the primary riders using the bike rental service?

# computing the overall proportion of user groups
user_prop<- eda_final %>%
count(membership) %>%
mutate(prop = n/sum(n))

# plot
custom_colors <- c("member" = "#E91E63", "casual" = "#1B3A6F")

ggplot(user_prop, aes(x = 2, y = prop, fill = membership)) +
geom_bar(stat = "identity", color = "white", linewidth = 1.5) +
coord_polar(theta = "y", start = 0) +
scale_fill_manual(values = custom_colors) +
geom_text(aes(label = scales::percent(prop, accuracy = 0.1)),
            position = position_stack(vjust = 0.5),
            color = "white",
            size = 7.5,
            fontface = "bold") +
xlim(0.5, 2.5) +
theme_void() +
labs(title = "Capital Bikeshare DC: Rider Membership",
       subtitle = "Aggregate Data (2021 - 2023)",
       fill = "Rider Membership") +
theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 18, margin = margin(t = 15, b = 2)),
    plot.subtitle = element_text(hjust = 0.5, size = 14, color = "gray30", margin = margin(b = 5)),
    legend.position = "right",
    legend.title = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 11)
  )

# saving the plot image
ggsave("RIDER_MEMBERSHIP.png",
width = 11,
height = 6,
dpi = 300)
	

2. WHEN is the most demanding time for the bike rental service?

# computing the proportion of daily pick-up time windows
pickup_window<- eda_final %>%
group_by(membership) %>%
count(pick_up) %>%
mutate(prop = n / sum(n)) %>%
ungroup() %>%
mutate(pick_up = factor(pick_up, levels = rev(c("Morning", "Afternoon", "Evening", "Night"))))

# plot
time_colors <- c(
	  "Morning"   = "#26A69A",
	  "Afternoon" = "#0288D1", 
	  "Evening"   = "#7B1FA2",
	  "Night"     = "#37474F" )

ggplot(pickup_window, aes(x = prop, y = pick_up, fill = pick_up)) +
geom_col(width = 0.75, show.legend = FALSE) +
geom_text(aes(label = scales::percent(prop, accuracy = 0.1)), 
	            hjust = -0.2, 
	            fontface = "bold", 
	            size = 4.5) +
facet_wrap(~membership) +
scale_fill_manual(values = time_colors) +
scale_x_continuous(labels = scales::percent_format(), limits = c(0, 0.45)) +
labs(
	title = "Trip Distribution by Time of Day",
	x = "Proportion of Total Trips",
	y = NULL
	) +
    theme_minimal() +
	theme(
	    plot.title = element_text(face = "bold", size = 18, margin = margin(t = 25, b = 20), hjust = 0),   
	    strip.text = element_text(face = "bold", size = 14),
	    strip.background = element_rect(fill = "gray96", color = NA),
	    axis.text.y = element_text(face = "bold", size = 12, color = "black"),
	    axis.text.x = element_text(color = "gray50"),
	    panel.grid.minor = element_blank(),
	    panel.grid.major.y = element_blank(), 
	    panel.spacing = unit(2, "lines")      
  )

# saving the plot image
ggsave("time_of_day.png",
width = 11,
height = 6,
dpi = 300)
	
	
# computing the proportion of pick-ups between weekday and weekend
tripcount_week <- eda_final %>%
group_by(year) %>%
count(weekend) %>%
mutate(
proportion = n / sum(n),
percentage = scales::percent(proportion, accuracy = 0.1))

# plot
ggplot(tripcount_week, aes(x = factor(year), y = proportion, fill = weekend)) +
geom_col(width = 0.6) + 
geom_text(aes(label = percentage), 
	      position = position_stack(vjust = 0.5), 
	      color = "white", 
	      fontface = "bold") +
scale_y_continuous(labels = scales::percent) +
scale_fill_manual(values = c("FALSE" = "#61646FFF", "TRUE" = "#E74C3C"), 
	                    labels = c("Weekday", "Weekend")) +
labs(title = "Overall Trip Proportion: Weekday vs. Weekend (2021-2023)",
	       x = "Year",
	       y = "Proportion of Total Trips", 
	       fill = "Day Type") +
theme_minimal() +
	  theme(
	    # Year labels at the bottom: Plain text (not italicized or bold)
	    axis.text.x = element_text(face = "plain", color = "black"),
	    axis.text.y = element_text(face = "plain", color = "black"),
	    plot.title = element_text(face = "bold", size = 16)
	  )

#saving the plot image
ggsave("trip_weekend_weekday.png",
width = 11,
height = 6,
dpi = 300)

	
# computing the proportion of weekday vs. weekend trips for member users
tripcount_week_member <- eda_final %>%
filter(membership == "member") %>%
group_by(year) %>%
count(weekend) %>%
mutate(proportion = n / sum(n))


# computing the proportion of weekday vs. weekend trips for casual users
tripcount_week_casual <- eda_final %>%
filter(membership == "casual") %>%
group_by(year) %>%
count(weekend) %>%
mutate(proportion = n / sum(n))


# computing monthly trip count by year
tripcount_month <- eda_final %>%
group_by(year) %>%
count(month) 

# plot
ggplot(tripcount_month,
aes(x = month,
	y = n,
	group = year,
	color = factor(year))) +
    geom_line(size = 1) +
	geom_point(size = 2) +
	scale_y_continuous(labels = scales::comma) +
	scale_color_manual(values = c("darkorange", "goldenrod", "dimgrey")) +
	labs(title = "Capital Bikeshare DC: Monthly Trip Count by Year(2021-2023)",
	x = "Month",
	y = "Trip Count",
	color = "Year") +  
theme_minimal()

#saving the plot image
ggsave("monthly_trip_count.png",
width = 11,
height = 6,
dpi = 300)


# computing monthly trip count by user groups
tripcount_month_membership <- eda_final %>%
count(year, month, membership)


# plot
ggplot(tripcount_month_membership,
	   aes(x = month,
	       y = n,
	       group = year,
	       color = factor(year))) + 
geom_line(size = 1) +
geom_point(size = 2) +
facet_wrap(~ membership) + 
scale_y_continuous(labels = scales::comma) +
scale_color_manual(values = c("darkorange", "goldenrod", "dimgrey")) +
labs(title = "Capital Bikeshare DC: Monthly Trip Count by Year and Rider Membership (2021-2023)",
	     x = "Month",
	     y = "Trip Count",
	     color = "Year") +
theme_minimal() +
		theme(
	        strip.background = element_rect(fill = "gray90", color = NA),
	        strip.text = element_text(face = "bold", size = 12),
	        axis.text.x = element_text(face = "plain", color = "black"),
	        axis.text.y = element_text(face = "plain", color = "black")
	    )

#saving the plot image
ggsave("monthly_trip_count_membership.png",
width = 11,
height = 6,
dpi = 300)


	
3. WHAT rental services do riders prefer?

# computing the proportion of bike rental service types by year
rideable_year_prop <- eda_final %>%
group_by(year) %>%
count(rideable_type) %>%
mutate(prop = n / sum(n))

# plot
ggplot(rideable_year_prop, 
aes(x = factor(year), y = prop, fill = rideable_type)) +
	       geom_col(width = 0.75) +
geom_text(aes(label = scales::percent(prop, accuracy = 0.1)),
	              position = position_stack(vjust = 0.5),
	              color = "white",
	              size = 5,
	              fontface = "bold") +
	    scale_fill_manual(values = c(
	      "classic_bike" = "#D32F2F",
	      "electric_bike" = "#8E44AD",
	      "docked_bike" = "#1976D2"),
	      labels = c("classic_bike" = "Classic", 
	                 "electric_bike" = "Electric", 
	                 "docked_bike" = "Docked")) +
scale_y_continuous(labels = scales::percent_format()) +
	    labs(x = "Year",
	         y = "Proportion of Total Trips",  
	         fill = "Rideable Type",         
	         title = "Rideable Type Composition by Year (2021-2023)") +
	    theme_minimal(base_size = 14) +
	    theme(
	        plot.title = element_text(face = "bold"),
	        legend.position = "top",
	        axis.text.x = element_text(face = "plain", color = "black")
	    )

#saving the plot image
ggsave("bike_type_composition by year.png",
width = 11,
height = 6,
dpi = 300)
	

# computing the proportion of bike rental service types by year and user groups
ride_type_prop <- eda_final %>%
count(year, membership, rideable_type) %>%
group_by(year, membership) %>%
mutate(prop = n / sum(n)) %>%
ungroup()

# plot
ggplot(ride_type_prop, 
	       aes(x = factor(year), 
	           y = prop, 
	           fill = rideable_type)) +
geom_col() +
geom_text(aes(label = scales::percent(prop, accuracy = 0.1)),
	              position = position_stack(vjust = 0.5),
	              size = 3.5,
	              fontface = "bold",
	              color = "white") +
facet_wrap(~ membership) +
	    scale_fill_manual(values = c(
	      "classic_bike" = "#D32F2F",
	      "electric_bike" = "#8E44AD",
	      "docked_bike" = "#1976D2"),
	      # Clean up the names in the legend
	      labels = c("classic_bike" = "Classic", "electric_bike" = "Electric", "docked_bike" = "Docked")) +
	    scale_y_continuous(labels = scales::percent_format()) +
	    labs(
	      title = "Rideable Type Share by Year (2021-2023): Annual Comparison by Rider Membership",
	      x = "Year",
	      y = "Proportion of Total Trips", # Corrected term
	      fill = "Rideable Type"           # Corrected term
	    ) +
	    theme_minimal() +
	    theme(
	      legend.position = "bottom",
	      plot.title = element_text(face = "bold", size = 16),
	      strip.background = element_rect(fill = "gray90", color = NA),
	      strip.text = element_text(face = "bold", size = 12),
	      axis.text.x = element_text(face = "plain", color = "black")
	    )

# saving the plot image
ggsave("ride_composition_by_year_membership.png",
width = 11,
height = 6,
dpi = 300)
	


4. WHERE are the most in-demand bike stations?

# loading the station dataset for geographical lookup
station <- read_csv("data/station.csv")

# note: Please download the dataset from Kaggle and update the file path accordingly
# dataset: https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408/data
	
	
# identifying the highest demand stations and their top drop-off stations by user groups
eda_final %>%
filter(membership == "member") %>%
count(start_station_id) %>%
slice_max(order_by = n, n =3)

station %>%
filter(station_id %in% c(31229,31201,31623))	

eda_final %>%
filter(membership == "member",
start_station_id %in% c(31229,31201,31623)) %>%
group_by(start_station_id) %>%
count(end_station_id) %>%
slice_max(order_by = n, n=3) 

station %>%
filter(station_id %in% c(31229,31125,31214,31201,31324,31631,31615,31652))	

eda_final %>%
filter(membership == "casual") %>%
count(start_station_id) %>%
slice_max(order_by = n, n=3)

station %>%
filter(station_id %in% c(31247,31258,31289))	

eda_final %>%
filter(membership == "casual",
start_station_id %in% c(31247,31258,31289)) %>%
group_by(start_station_id) %>%
count(end_station_id) %>%
slice_max(order_by = n, n=3) 

station %>%
filter(station_id %in% c(31247,31258,31289,31249, 31248))	
	
# identifying the top 3 highest demand stations by rideable type and user groups
top_stations_both <- eda_final %>%
count(membership, rideable_type, start_station_id) %>%
group_by(membership, rideable_type) %>%
slice_max(order_by = n, n = 3, with_ties = FALSE) %>%
ungroup() %>%
left_join(station, by = c("start_station_id" = "station_id")) %>%
mutate(station_name = gsub("Smithsonian-National Mall / |Columbus Circle / ", "", station_name)) %>%
mutate(unique_name = paste(station_name, rideable_type, membership)) %>%
mutate(unique_name = forcats::fct_reorder(unique_name, n))

# plot
bike_colors <- c("classic_bike" = "#D32F2F", "electric_bike" = "#8E44AD", "docked_bike" = "#1976D2")
custom_labels <- as_labeller(c("member"="Member", "casual"="Casual", "classic_bike"="Classic", "electric_bike"="Electric", "docked_bike"="Docked"))
	
ggplot(top_stations_both, aes(x = n, y = unique_name, color = rideable_type)) +
geom_segment(aes(x = 0, xend = n, y = unique_name, yend = unique_name), linewidth = 1.5, alpha = 0.5) +
geom_point(size = 4) +
geom_text(aes(label = scales::comma(n)), hjust = -0.3, fontface = "bold", size = 3.5, color = "black") +
facet_grid(rideable_type ~ membership, 
	             scales = "free_y", 
	             space = "free_y", 
	             labeller = custom_labels) +
scale_color_manual(values = bike_colors) +
scale_x_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.3))) +
scale_y_discrete(labels = function(x) gsub(" classic_bike.*| electric_bike.*| docked_bike.*", "", x)) +
labs(title = "Top 3 Pick-Up Stations: Rider Membership vs. Rideable Type",
               x = "Total Trip Count",
	      	   y = NULL) +
theme_minimal() +
		theme(
	    plot.title = element_text(face = "bold", size = 16),
	    strip.background = element_rect(fill = "gray90", color = NA),
	    strip.text = element_text(face = "bold", size = 13),
	    axis.text.y = element_text(face = "bold", size = 10, color = "black"),
	    axis.text.x = element_text(face = "plain", color = "black"),
	    legend.position = "none" 
	  )

# saving the plot image				 
ggsave("top3_pickup_location.png",
width = 11,
height = 6,
dpi = 300)
				 

# identifying the top 3 highest demand stations by weekday vs. weekend status and year
top_stations_day <- eda_final %>%
mutate(day_type = ifelse(weekend == TRUE, "Weekend", "Weekday")) %>%
count(day_type, year, start_station_id) %>%
group_by(day_type, year) %>%
slice_max(order_by = n, n = 3, with_ties = FALSE) %>%
ungroup() %>%
left_join(station, by = c("start_station_id" = "station_id")) %>%
mutate(station_name = gsub("Columbus Circle / |Smithsonian-National Mall / ", "", station_name)) %>%
mutate(unique_name = paste(station_name, day_type, year)) %>%
mutate(unique_name = forcats::fct_reorder(unique_name, n))

#plot 				 
day_colors <- c("Weekday" = "#61646FFF", "Weekend" = "#E74C3C")
				 
ggplot(top_stations_day, aes(x = n, y = unique_name, color = day_type)) +
	geom_segment(aes(x = 0, xend = n, y = unique_name, yend = unique_name), linewidth = 1.5, alpha = 0.5) +
	geom_point(size = 4) +
	geom_text(aes(label = scales::comma(n)), hjust = -0.3, fontface = "bold", size = 3.5, color = "black") +
	facet_grid(year ~ day_type, scales = "free_y", space = "free_y") +
	scale_color_manual(values = day_colors) +
	scale_x_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.4))) +
	scale_y_discrete(labels = function(x) gsub(" Weekday.*| Weekend.*", "", x)) +
	labs(title = "Top 3 Pick-Up Stations by Year: Weekday vs. Weekend",
	        	 x = "Total Trip Count",
	        	 y = NULL) +
theme_minimal() +
	    theme(
	     plot.title = element_text(face = "bold", size = 16),
	        strip.background = element_rect(fill = "gray90", color = NA),
	        strip.text = element_text(face = "bold", size = 13),
	        axis.text.y = element_text(face = "bold", size = 10, color = "black"),
	        axis.text.x = element_text(face = "plain", color = "black"),
	        legend.position = "none",
	        panel.grid.minor = element_blank()
	    )

# saving the plot image					 
ggsave("weekend_weekday_top3_pickup_location.png",
width = 11,
height = 6,
dpi = 300)

					 
5. HOW do riders use the bike rental service?

# computing the median trip duration by user groups
duration_users <- eda_final %>%
group_by(membership,rideable_type,pick_up) %>%
summarise('50th' = median(duration_min), .groups = "drop")

duration_users <- duration_users %>%
mutate(duration_users = factor(pick_up, levels = c("Morning", "Afternoon", "Evening", "Night")))

# plot
ggplot(duration_users, aes(x = pick_up, y = `50th`, color = rideable_type, group = rideable_type)) +
geom_linerange(aes(ymin = 0, ymax = `50th`), 
               position = position_dodge(width = 0.6), 
               linewidth = 1.2, 
               show.legend = FALSE) +
  geom_point(position = position_dodge(width = 0.6), size = 4) +
  geom_text(aes(label = paste0(round(`50th`, 1), "m")), 
            position = position_dodge(width = 0.6), 
            vjust = -1.5, 
            fontface = "bold", 
            size = 3.5, 
            show.legend = FALSE) +
facet_wrap(~membership, scales = "free_y") +
scale_color_manual(
    values = c(
      "classic_bike" = "#D32F2F", 
      "electric_bike" = "#8E44AD", 
      "docked_bike" = "#1976D2" ),
    labels = c(
      "classic_bike" = "Classic", 
      "electric_bike" = "Electric", 
      "docked_bike" = "Docked"
    ) ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
  labs(
    title = "Median Trip Duration: Rider Membership Across Pick-Up Time and Rideable Type",
    x = NULL,
    y = "Median Trip Duration (Minutes)", 
    color = "Rideable Type") +
theme_minimal() +
theme(
    plot.title = element_text(face = "bold", size = 15, margin = margin(b = 15)),
    strip.background = element_rect(fill = "gray90", color = NA),
    strip.text = element_text(face = "bold", size = 13),
    axis.text.x = element_text(face = "plain", color = "black"),
    axis.text.y = element_text(face = "plain", color = "black"),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )
					 
# saving the plot image					 
ggsave("median_trip_duration_pickup_bike_type.png",
width = 11,
height = 6,
dpi = 300)

					 
# computing the proportion of trip patterns (one-way vs. round-trip) by user groups
pattern_users <- eda_final %>%
group_by(membership) %>%
count(trip_pattern) %>%
mutate(prop = n / sum(n))

# plot
ggplot(pattern_users, aes(x = 2, y = prop, fill = trip_pattern)) +
geom_bar(stat = "identity", color = "white", linewidth = 1) +
coord_polar(theta = "y", start = 0) +
xlim(0.5, 2.5) + # Creates the donut hole
facet_wrap(~ membership) +
geom_text(aes(label = ifelse(prop > 0.01, scales::percent(prop, accuracy = 0.1), "")), 
	              position = position_stack(vjust = 0.5), 
	              color = "white", fontface = "bold", size = 4.5) +
scale_fill_manual(values = c("one_way" = "#365d9dff", "round_trip" = "#9A2865ff"),
	              labels = c("one_way" = "One-Way", "round_trip" = "Round-Trip")) +
labs(title = "Trip Pattern: One-Way vs. Round-Trip",
	         fill = "Trip Pattern") +
	    theme_void() +
	    theme(
	        plot.title = element_text(face = "bold", size = 16, hjust = 0.5, margin = margin(b = 5)),
	        plot.subtitle = element_text(hjust = 0.5, color = "gray30", margin = margin(b = 15)),
	        strip.background = element_rect(fill = "gray90", color = NA),
	        strip.text = element_text(face = "bold", size = 14, margin = margin(t = 5, b = 5)),
	        legend.position = "bottom",
	        legend.title = element_text(face = "bold")
	    )

# saving the plot image					 
ggsave("trip_pattern_membership.png",
width = 11,
height = 6,
dpi = 300)

					 
# computing the proportion of return patterns (same-day vs. next-day) by user groups
return_users <- eda_final %>%
group_by(membership) %>%
count(return) %>%
mutate(prop = n / sum(n))

					 
# plot					 
ggplot(return_users, aes(x = 2, y = prop, fill = return)) +
geom_bar(stat = "identity", color = "white", linewidth = 1) +
coord_polar(theta = "y", start = 0) +
xlim(0.5, 2.5) +
facet_wrap(~ membership) +
geom_text(aes(label = ifelse(prop > 0.01, scales::percent(prop, accuracy = 0.1), "")), 
	position = position_stack(vjust = 0.5), 
color = "white", fontface = "bold", size = 4.5) +
	    labs(title = "Trip Return Time: Same Day vs. Next Day",
	         fill = "Return Time") +
scale_fill_manual(
	        breaks = c("same_day", "next_day"), # <--- THIS CONTROLS THE LEGEND ORDER
	        values = c("same_day" = "#6dc863", "next_day" = "#D84C3E"),
	        labels = c("same_day" = "Same Day", "next_day" = "Next Day") ) +
theme_void() +
theme(
	        plot.title = element_text(face = "bold", size = 16, hjust = 0.5, margin = margin(b = 5)),
	        plot.subtitle = element_text(hjust = 0.5, color = "gray30", margin = margin(b = 15)),
	        strip.background = element_rect(fill = "gray90", color = NA),
	        strip.text = element_text(face = "bold", size = 14, margin = margin(t = 5, b = 5)),
	        legend.position = "bottom",
	        legend.title = element_text(face = "bold")
    )					 

# saving the plot image
ggsave("trip_return_membership.png",
width = 11,
height = 6,
dpi = 300)



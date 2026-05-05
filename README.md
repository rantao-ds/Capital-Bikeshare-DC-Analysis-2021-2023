# Capital-Bikeshare-DC-Analysis(2021-2023)
Exploratory and spatial analysis of Capital Bikeshare ridership patterns in Washington D.C. (2021–2023) using R and ArcGIS.

## Why This Project 
DC is honestly my favorite U.S. city. I've visited two years in a row for the Annual Cherry Blossom Festival, and what struck me every time wasn't just the scenery. Having lived in the U.S. for a decade, it was my first time being able to take the metro directly to my hotel with suitcases and explore the city and even the neighborhoods beyond without ever calling an Uber. I was also impressed by how the transportation system creates strong economic circulation connecting Virginia (Silver, Yellow & Orange Lines) and Maryland (Red & Green Lines) with the capital. So my first project looked at Capital Bikeshare, a service I noticed but never got to try during my visits to DC.

## Data
The dataset is sourced from Kaggle:[Capital Bikeshare Dataset 2020/05~2024/08](https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408/data), consisting of four separate datasets: 

  - Daily_Rent_Detail
  - Station_List
  - Usage_Frequency
  - Weather

The primary dataset used in this analysis is **Daily_Rent_Detail**, which originally contained 16,086,672 observations covering May 2020 to August 2024. After removing invalid trips, including zero values, missing data, and trips exceeding 24 hours (per Capital Bikeshare's rental agreement), and filtering to three complete years from 2021 to 2023, the cleaned dataset retained 9,451,314 observations for exploratory data analysis.

For EDA and modeling purposes, I combined the weather dataset with selected variables, including temperature, precipitation, wind speed, and cloud cover. I also created the following additional variables: duration (min), pick-up time (morning, afternoon, evening, night), return type (same-day, next-day), trip pattern (one-way, round-trip), month(Jan, Feb, etc.), weekday (Mon, Tue, etc.), weekend (True/False), and year (2021, 2022, 2023).

## Exploratory Data Analysis (EDA)
The EDA centers on answering the following questions:

**WHO** are the primary riders using the bike rental service?

**WHEN** is the most demanding time for the bike rental service?

**WHAT** rental services do riders prefer?

**WHERE** are the most in-demand bike stations?

**HOW** do riders use the bike rental service?


### Who
Based on aggregated data from 2021 to 2023, the primary bike rental users are Capital Bikeshare members (60.5%), with a comparatively smaller portion from casual users (39.5%). Over the three years, the proportion between member and casual users remained relatively stable at approximately 60:40.

According to Capital Bikeshare, the annual membership costs $120 per year and provides unlimited free bike unlocks with the first 45 minutes of classic bike rental at no charge. Given the annual commitment, members are likely local residents or frequent commuters who rely on Capital Bikeshare as part of their daily routine, rather than occasional visitors. The higher ridership among members also suggests that Capital Bikeshare functions as an essential transportation tool that complements other public transit options for short distance travel among local residents and commuters.

<img width="530" alt="RIDER_MEMBERSHIP" src="https://github.com/user-attachments/assets/7c91fbcc-c415-43b2-b69a-d67437e59690" />


### What
Over the three years, the classic bike was consistently the most preferred service among all users. However, there were some notable shifts in docked and electric bike (e-bike) usage. From 2021 to 2023, docked bike usage gradually decreased from 8.2% to 2.9%. In contrast, e-bike usage nearly doubled over the three years, increasing from 9.7% in 2021 to 20.8% in 2023.

For member users, docked bike recorded only one transaction in 2021 which was removed as an outlier, while e-bike usage grew steadily by approximately 10%. For casual users, docked bike usage declined as e-bike usage increased over the three years, which reflects the gradual replacement of docked bike service by e-bikes.

As of March 2026, Capital Bikeshare no longer lists docked bike as a rental service option. Comparing the cost of classic bikes and e-bikes, e-bikes are significantly more expensive for both member and casual users. For members, the annual membership includes the first 45 minutes of classic bike rental at no cost, while e-bike rides are charged at $0.15 per minute. For casual users, single rides cost $1 to unlock plus $0.15 per minute for classic bikes and $0.35 per minute for e-bikes. With a day pass ($10/day), casual users enjoy the same benefits as annual members: free unlocks, 45 minutes of free classic bike rental, and $0.15 per minute for e-bikes. Overall, the preference for classic bikes among both user types is likely to remain stable given the lower cost.


<img width="530" alt="bike_type_composition by year" src="https://github.com/user-attachments/assets/efe5c75d-8b80-42ae-9a4b-b7ada05b75e4" />

<img width="530" alt="ride_composition_by_year_membership" src="https://github.com/user-attachments/assets/6b6c089b-f124-4173-9d82-ab6901078bfd" />



### When 


- **Pick-up time**
  
  In terms of peak pick-up window, member and casual users share some similarities. Both user groups are less likely to pick up bikes at night (9pm-       7am), with more than 85% of daily pick-ups occurring during daytime hours.
  
  For casual users, it is unsurprising that ridership peaks during the afternoon, accounting for 37.7% of total daily usage. Interestingly, the            expectation of higher morning ridership among member users does not hold true in this case. Morning pick-ups only contribute 26.6% of daily volume,      while afternoon (12pm-5pm) and evening (5pm-9pm) pick-ups account for 30.4% and 30.6% respectively. This suggests that members may not primarily use     Capital Bikeshare for morning commutes, but rather as a flexible transportation option for daily movement throughout the day.

<img width="600" alt="time_of_day" src="https://github.com/user-attachments/assets/c4afd050-da37-4206-b9f6-b80ad36b89a9" />



- **Weekday vs. Weekend**
  
  Overall, the majority of trips occurred during weekdays, with a steady increase from 67% in 2021 to 71.6% in 2023. This growth may be partially driven   by the post-pandemic return-to-office trend, which likely increased demand for bike rental service during weekdays. Indeed, annual ridership saw a       significant increase over the three years, growing from 2,424,755 trips in 2021 to 3,812,138 trips in 2023, representing approximately 57.2% growth.     However, while member users experienced a modest 3% increase in weekday usage over the three years, casual users saw a 6% increase, nearly doubling      the growth rate of member users. This suggests that the rapid increase in bike rental usage on weekdays may not solely be attributed to the return-to-   office trend. The recovery of tourism and business travel to DC likely contributed as well, which reflects a broader post-pandemic economic recovery     in the capital.


<img width="530" alt="trip_weekend_weekday" src="https://github.com/user-attachments/assets/72741d4a-30c4-468a-be48-2eab3552ed72" />



- **Month**
  
  As a visitor attending the National Cherry Blossom Festival in late March and early April, I noticed many people biking around the National Mall and     the Tidal Basin. Surprisingly, peak ridership does not occur during the blooming period, but instead during the summer and early fall.

  In 2023, July, August, and October recorded the highest ridership of the year, each exceeding 400,000 trips per month. In 2022, peak ridership           occurred between June and September, with each month surpassing 350,000 trips. In 2021, October was the only month to reach peak ridership, with over    300,000 trips. Across all three years, July stands out as the busiest month overall, which indicates a stable seasonal peak in mid-summer.

  For member users, September and October were the busiest months, likely associated with DC’s active fall professional and conference season. For         casual users, July was consistently the busiest month, with ridership peaking across all three years, likely reflecting the increase in visitors         for Independence Day celebrations.



<img width="460" alt="monthly_trip_count" src="https://github.com/user-attachments/assets/e49d1c01-3469-4ab1-8000-eb4dc8f66f30" />



<img width="530" alt="monthly_trip_count_membership" src="https://github.com/user-attachments/assets/97cace5d-924e-4d68-a973-039253fd7226" />




### Where


- **Member**
  
  Combining all rideable types, the top 3 pick-up stations for member users were ***"New Hampshire Ave & T St NW"***, ***"15th & P St NW"***, and          ***"Columbus Circle / Union Station"***, each averaging around 70,000 pick-ups over the three years.
  
  Here are the top 3 drop-off stations regardless of rideable type with over 1,000 trips for each high demand starting station:

  - ***New Hampshire Ave & T St NW*** 

    According to the DC official zoning map, "New Hampshire Ave & T St NW" is located in the RA-4 district, zoned for residential apartments and             surrounded by other RA-coded districts. Here are the top drop-off stations with over 1,000 drop-offs from "New Hampshire Ave & T St NW" by pick-up       time window:
    
    Morning: 17th & K St NW / 18th & New Hampshire Ave NW
    
    Afternoon: 15th & P St NW 
    
    Evening: 15th & P St NW / 17th & Corcoran St NW

    For morning riders, the trip purpose is likely work-related. All morning top drop-off stations are located close to major employment centers and         transit hubs. The K Street corridor is known for its concentration of firms and offices, within walking distance of Farragut Square Metro station.       "18th Street NW" is a mixed-use district located with office buildings and embassies, also just a few blocks away from Dupont Circle.

    During afternoon and evening hours, the trip purpose appears to shift from commuting to leisure and errands. "17th & Corcoran St NW" is located in a     mixed-use zone with grocery stores including Whole Foods and numerous restaurants. "15th & P St NW" is situated in the ARTS-3 Special Purpose Zone       designed to promote arts, entertainment, and retail uses with an emphasis on 18-hour pedestrian activity, according to DC zoning regulations.
    

  - ***15th & P St NW***

    As mentioned above, "15th & P St NW" is located in the ARTS-3 Special Purpose Zone, adjacent to a large RA-coded residential neighborhood and a          mixed-use district. The ARTS-3 zone is specifically designed to promote pedestrian-friendly development, which naturally discourages car ownership       among residents. In other words, the surrounding area has a high concentration of residents who are likely to rely on bikes and public transit for       both leisure and daily commuting purposes. Here are the top stations with over 1,000 drop-offs from "15th & P St NW" by pick-up time window:

    Morning: Massachusetts Ave & Dupont Circle
    
    Afternoon: New Hampshire Ave & T St NW
    
    Evening: New Hampshire Ave & T St NW / 15th & W St NW

    As expected, morning riders appear to bike to work, as "Massachusetts Ave & Dupont Circle NW" is located in a dense office area within walking           distance of Dupont Circle Metro station. For afternoon and evening riders, it is interesting to note that "New Hampshire Ave & T St NW", previously      identified as a residential zone and the top pick-up station for member users, now appears as a top drop-off station, which suggests that the riders     may be heading home after work or running errands. Additionally, "15th & W St NW", a high drop-off station during evening hours, is located on the       edge of Downtown DC, which suggests the riders may be heading there for dining and nightlife purposes.


  - ***Columbus Circle / Union Station***
  
    "Columbus Circle / Union Station" is distinct from "New Hampshire Ave & T St NW" and "15th & P St NW", which are zoned for residential and mixed-use     districts. As one of DC's largest transit hubs serving Amtrak, Metro, and bus routes, its high ridership is naturally expected.
    
    Here are the top stations over 1,000 drop-offs from "Columbus Circle/Union Station" by pick-up time window:

    Morning: 4th & M St SE / 3rd & M st SE
    
    Afternoon: 8th & F St NE / 6th & H St NE
    
    Evening: 6th & H St NE / 8th & F St NE / Maryland Ave & E St NE 

    Interestingly, the top morning drop-off destinations are concentrated in the Navy Yard and Southeast Federal Center (SEFC) zones, a high-density         mixed-use waterfront district, which suggests that morning riders are likely federal employees or government contractors commuting to nearby             offices. For afternoon and evening riders, drop-off stations shift to RF (Residential Flat) and Neighborhood Mixed-Use zones, with a portion of          evening rides ending at the National Arboretum, which indicates that riders may be heading home or enjoying outdoor leisure activities after work.


- **Casual**
  
  For casual users, unsurprisingly, the highest demand stations are located along the National Mall: ***"Lincoln Memorial"***, ***"Jefferson Dr & 14th     St SW"***, and ***"Henry Bacon Dr & Lincoln Memorial Circle NW"***, each recording over 60,000 pick-ups over the three years.


  Here are the top 3 drop-off stations regardless of rideable type with over 1,000 trips for each high demand starting station:

  - ***Lincoln Memorial***

    Morning: Jefferson Dr & 14th St SW / Lincoln Memorial 

    Afternoon: Jefferson Dr & 14th St SW/ Lincoln Memorial / 4th St & Madison Dr NW 

    Evening: Jefferson Dr & 14th St SW / Lincoln Memorial 

    Night: Jefferson Dr & 14th St SW

  
  - ***Jefferson Dr & 14th St SW***

    Morning: Lincoln Memorial/ Jefferson Memorial / Jefferson Dr & 14th St SW 

    Afternoon: Lincoln Memorial / Jefferson Memorial / Jefferson Dr & 14th St SW 

    Evening: Lincoln Memorial / Jefferson Memorial / Jefferson Dr & 14th St SW 


  - ***Henry Bacon Dr & Lincoln Memorial Circle NW*** 

    Afternoon: Henry Bacon Dr & Lincoln Memorial Circle NW / Jefferson Dr & 14th St SW / Smithsonian-National Mall - Jefferson Dr & 12th St SW

    Evening: Henry Bacon Dr & Lincoln Memorial Circle NW

    Night: Henry Bacon Dr & Lincoln Memorial Circle NW


    Unlike member users who demonstrate diverse destinations for both work and leisure, casual users appear to bike exclusively for                          sightseeing, consistently riding in a loop pattern between the same or nearby stations around the National Mall.


<img width="600" alt="top3_pickup_location" src="https://github.com/user-attachments/assets/00bb6527-6545-4cd6-8094-cb754e201cc8" />




- **Weekday vs. Weekend**
  
Overall, trips at the top three pick-up stations on weekdays have steadily increased over the three years, while weekend trips have remained relatively stable. For weekday trips, the top pick-up stations align with the highest demand stations for member users, which confirms that the primary weekday riders are members and supports the return-to-office trend discussed above. For weekend trips, the highest demand stations shifted from visitor-oriented locations around the National Mall in 2021-2022 to a mix of tourism sites and R-coded residential neighborhoods by 2023. This suggests a potential increase in weekend bike rental demand among member users over time.



<img width="600" alt="weekend_weekday_top3_pickup_location" src="https://github.com/user-attachments/assets/6b2bfdb0-cb0e-4e76-b51f-729d2392de1f" />




## How

- **Trip Duration(minutes)**

  In terms of trip duration, member and casual users exhibit different usage patterns. Member users tend to keep trips around 10 minutes. Specifically,    classic bike trips typically last under 10 minutes, while e-bike trips are slightly longer, with median durations exceeding 10 minutes during the        afternoon and evening.

  In contrast, casual users spend more time on bikes, with median trip durations exceeding 10 minutes across all rideable types. Docked bikes recorded     the longest median durations, ranging from 23 to 33 minutes, likely because they must be returned to a designated station. Meanwhile, casual users’      classic bike trips range from 13 to 18 minutes, while e-bike trips range from 11 to 13 minutes, both longer than the typical member user trip


<img width="600" alt="median_trip_duration_pickup_bike_type" src="https://github.com/user-attachments/assets/8637d582-2e87-4d4d-b5be-da1a793ddf35" />


  

 - **Trip Pattern**

   As all trips in this analysis are valid and do not exceed the 24-hour rental limit, 99% of bikes were returned on the same day for both user groups.     However, casual users are more likely to make round-trips, with 9% of trips ending at the same station where the bike was picked up. Member users, by    contrast, are far less likely to return to the pick-up station, with only 2.3% of trips being round-trips. These trip patterns reinforce the earlier     finding that member users primarily take point-to-point trips, while casual users tend to make loop-based trips for sightseeing purposes



<img width="500" alt="trip_return_membership" src="https://github.com/user-attachments/assets/f99b0f40-1185-4281-8874-e849a3849a25" />


<img width="500" alt="trip_pattern_membership" src="https://github.com/user-attachments/assets/a2111666-5e6c-4ab6-8325-c2c87609cda7" />




## Modeling 

### Objective

For modeling purposes, this section aims to answer the following question: is bike rental usage affected by weather conditions and weekends? If so, is the relationship linear or non-linear, and how do these variables individually impact ridership? To address this, both linear and non-linear approaches were applied. Specifically, multiple linear regression was used to test linear relationships, while quadratic regression was used to examine non-linear patterns. For modeling purposes, the dataset was aggregated into a new dataset with daily trip counts grouped by date, weather conditions, and weekend status. The final modeling dataset consists of 1,095 observations (365 days × 3 years), aggregated from the 9,451,314 observations used in the EDA.

### Varibles 

- **Dependent Variable:** total_trip

- **Independent Variables:** temp, precip, windspeed, cloudcover, weekend

### Methodology 

**1. Mutiple Linear Regression** 

The first step was to run a multiple linear regression using the prepared dataset, with total_trips as the dependent variable, to examine how the independent variables impact daily ridership, whether these effects are statistically significant, and how well the selected independent variables explain the variation in trip counts.

**2.VIF**

The second step was to test for multicollinearity using VIF (Variance Inflation Factor). Multicollinearity is a common concern in multiple linear regression, particularly when independent variables are closely related. Since the four selected weather variables: temperature, precipitation, wind speed, and cloud cover, measure different aspects of weather conditions, there was a risk that some variables might be capturing similar information. The VIF test was applied to ensure that each variable contributes independently to the model.

**3. Regularization**

Although the modeling dataset contains only 1,095 observations, it was aggregated from 9,451,314 observations representing three complete years of ridership data. To ensure model stability and test for potential overfitting, the dataset was split into 70% training and 30% testing sets, with regularization applied including Ridge, Lasso, and Elastic Net.

**4. Non-Liner Regression**

The final step was to test for non-linear relationships. While the linear regression model provides a useful baseline, weather variables such as temperature may not have a strictly linear relationship with ridership. Additionally, the effect of weather conditions may differ between weekdays and weekends, potentially creating non-linear impacts on ridership. 

Quadratic and interaction regression models were therefore applied to capture these patterns. Specifically, the quadratic model squares all weather variables to identify potential peak points along the curve and to assess how ridership changes at these maximum or minimum points. The interaction model examines how temperature and precipitation vary with weekend status to estimate differences in slope, which reflects how ridership changes for each unit increase or decrease in temperature and precipitation on weekdays versus weekends.


### Results

**1. Mutiple Linear Regression** 


<img width="350" alt="LM" src="https://github.com/user-attachments/assets/6b6eab43-748d-4ff8-879c-c4e86085cfb9" />



The multiple linear regression model explains 58.1% of the variation in daily trip counts (R² = 0.581, Adjusted R² = 0.579, n = 1,095), with all five independent variables statistically significant at the 1% level (p < 0.01). Among the weather variables, temperature has the strongest positive effect, with each one-degree increase associated with approximately 282 additional daily trips. Precipitation (-115), wind speed (-36), and cloud cover (-27) all negatively impact ridership. Weekends also have a substantial effect on ridership, with roughly 840 more trips compared to weekdays.


**2.VIF**


<img width="1300" alt="Screenshot 2026-03-23 at 7 18 49 PM" src="https://github.com/user-attachments/assets/cd14966b-dafd-4af7-86a5-53dfb3a8f4d9" />



The VIF test confirms no multicollinearity issues, with all values close to 1 (range: 1.003 to 1.162). This indicates that each independent variable contributes unique information to the model, and the regression coefficients are reliable.


**3. Regularization**

  - ***Comparison of Regularization Models***



<img width="660" alt="regulation_model" src="https://github.com/user-attachments/assets/72095920-ca45-4688-9db8-cde36c2ae1ef" />



I applied Ridge, Lasso, and Elastic Net Regularization models to test model stability. The plots show that no coefficients were shrunk to zero, and all variables remains stable with no major changes across the three regularization models. This confirms that all five independent variables contribute meaningfully to the model.


  - ***Comparison of MSEs***



<img width="1300" alt="MSEs Comparison" src="https://github.com/user-attachments/assets/84d75057-f638-46eb-b374-6ac5cf622e78" />



The comparison of MSEs shows that all models perform very similarly, with values ranging from 5,973,497 to 5,976,964. This confirms that the baseline linear regression model is stable and not overfitting, and that regularization does not substantially improve prediction.


**4. Non-Liner Regression**


  - ***Quadratic***


<img width="350" alt="quatric" src="https://github.com/user-attachments/assets/3890b249-ec96-44e6-8d00-7e998c571313" />


<img width="330" alt="Peak" src="https://github.com/user-attachments/assets/382943b1-8c91-4593-ae0b-edaa29daaed9" />



The quadratic regression model explains 65.1% of the variation in daily trip counts (R² = 0.651), whic is an improvement compared the baseline linear regression (R² = 0.581). Among the squared weather variables, temperature, precipitation, and cloud cover are statistically significant at the 1% level (p < 0.01), while windspeed is not significant.

Ridership increases with temperature up to a maximum of 25.677°C and decreases beyond this point, indicating that extreme heat likely reduces trips. Precipitation reduces ridership as rainfall rises. At approximately 37.656 mm, ridership reaches a minimum and rises slightly beyond this level, possibly reflecting the few riders who travel despite heavy rain. Cloud cover slightly increases ridership up to a peak at 34.445%, after that, ridership declines. The overall effect of cloud cover on trips remains minimal.

Weekend remains a strong positive factor in this model, with approximately 840 more trips compared to weekdays.


  - ***Interaction***



<img width="350" alt="interaction" src="https://github.com/user-attachments/assets/5cb5bbdd-d875-4479-83ef-40b16bd2e978" />



<img width="460" alt="slope" src="https://github.com/user-attachments/assets/3f26dfd9-604e-42ab-a3f2-190e3e12557f" />



The interaction regression model explains 58.7% of the variation in daily trip counts (R² = 0.587), a minimal improvement over the baseline linear regression (R² = 0.581). Interestingly, the weekend variable and the Weekend × Precipitation interaction term are not statistically significant in this model, even though the weekend variable was consistently significant in previous models. The remaining variables are statistically significant at the 1% level (p < 0.01).

The Temp coefficient of 262.038 indicates that ridership increases by approximately 262 trips for every one-degree increase in temperature on weekdays. The Weekend × Temp interaction term shows that the slope for weekends is higher, with ridership increasing by about 328 trips per one-degree increase. This demonstrates that temperature has a stronger positive effect on ridership during weekends compared with weekdays.

Since the interaction term Weekend × Precipitation is not statistically significant, which indicates that the effect of precipitation on ridership does not differ between weekdays and weekends. Therefore, no separate slope interpretation is necessary for this interaction


### Summary 

Overall, the modeling analysis confirms that weather conditions, especially temperature, and weekend status are significant predictors of daily Capital Bikeshare ridership. Both the multiple linear and interaction regression models indicate that temperature and weekend status, individually and in combination, have a positive impact on ridership. The quadratic model further reveals that extreme heat beyond 25.677°C reduces ridership, while precipitation reaches its minimum impact at approximately 37.656mm, after which ridership increases slightly. 

With the quadratic model achieving a higher R² (0.651) compared to the baseline linear regression (0.581), the relationship between weather conditions, weekend status, and daily trip counts appears to be non-linear. Nevertheless, the VIF diagnostics and regularization models confirm that the baseline linear regression remains stable, with no multicollinearity or overfitting detected.



## Spatial Analysis (ArcGIS)


The spatial analysis explores the geographic distribution of Capital Bikeshare ridership across Washington D.C. to identify spatial patterns across different membership types, times of day, and days of the week. The analysis is visualized through heatmaps generated in ArcGIS, where yellow dots indicate the highest demand stations by trip count.

All spatial visualizations were completed using ArcGIS Online, with aggregated station-level data including latitude and longitude coordinates imported from the EDA dataset. Multiple layers were added to each map to provide geographic context, including metro lines, metro stations, and the Washington D.C. administrative boundary.

**Member vs. Casual**


<img width="600" alt="Member" src="https://github.com/user-attachments/assets/d2750fdb-9926-4f3f-a74f-4ba16c4bfde8" />



The map above shows the geographic distribution of the highest demand stations among member users. The heatmap indicates that the majority of member trips originated in residential and commercial districts in northern DC, above Massachusetts Ave and the K Street corridor. Specifically, the most intense ridership is concentrated between Connecticut Ave NW and 7th Street NW, shown in yellow on the map. Smaller hotspots are also visible around Union Station, Eastern Market, and Navy Yard. Overall, member trip start locations are distributed across DC but concentrated in the northern part of the city, reflecting a combination of employment centers and R-coded residential districts.



<img width="600" alt="casual" src="https://github.com/user-attachments/assets/3af8785e-8426-458d-87b1-5856befa5efe" />




The map above presents the geographic distribution of the most preferred pick-up stations among casual users. Unlike member users, the heatmap shows a completely reversed distribution, with most intense hotspots concentrated within the National Mall, reflecting the tourism-based loop trip pattern identified in the EDA. The most intense demand is visually concentrated around the Lincoln Memorial, located at the western end of the National Mall. Strong hotspots are also found in the middle of the National Mall around the Washington Monument and Smithsonian Metro Station, which typically serve as the starting point for National Mall tours. Another hotspot is located at the eastern end of the National Mall, between Capitol Hill and the National Gallery of Art.

**Weekday vs. Weekend**


<img width="600" alt="weekday" src="https://github.com/user-attachments/assets/8feec465-fdc9-4a50-b4e8-770277031aa7" />


The map above presents the geographic distribution of the highest demand start stations during weekdays. The heatmap shows that hotspots are spread across DC, reflecting the combined ridership patterns of both member and casual users. Unlike the membership-specific maps, the weekday heatmap does not show a strong concentration in any single district, which indicates that both user groups actively use Capital Bikeshare throughout the week across different parts of the city. However, stronger hotspots are visually concentrated around the residential districts in northern DC and major transit hubs such as Dupont Circle and Union Station.


<img width="600" alt="weekend" src="https://github.com/user-attachments/assets/db2dee0c-396e-4ccf-baf6-d2134f2e0419" />



The map above shows the geographic distribution of the most preferred pick-up stations during weekends. Compared to the weekday heatmap, the residential districts and transit hubs show lighter heat shades, suggesting a decline in commuting-based trips. In contrast, the hotspots around the National Mall intensify significantly on weekends, closely resembling the casual user heatmap, with strong concentration around the Lincoln Memorial, the Washington Monument, Smithsonian Metro Station, and the area between Capitol Hill and the National Gallery of Art. The weekend heatmap also confirms the EDA finding that weekend ridership is not purely tourism-based, as residential district hotspots remain visually noticeable, reflecting a mix of tourism and local leisure purposes.


**Morning vs. Afternoon vs. Evening**


<img width="600" alt="morning" src="https://github.com/user-attachments/assets/3effa30a-ff0b-4f65-bcff-b42d1f461ac5" />



<img width="600" alt="afternoon" src="https://github.com/user-attachments/assets/479360d8-6fe9-44a9-a9e6-5246d2375097" />



<img width="600" alt="evening" src="https://github.com/user-attachments/assets/2d7a970d-93b2-4a96-a2bc-a74b9dc5c6c4" />



Comparing the three major pick-up time windows, a clear shift is visible from commuting-oriented activity in the residential districts of northern DC during the morning to tourism-oriented activity around the National Mall during the afternoon. However, this does not mean that non-peak areas are inactive during off-peak hours. For example, the morning heatmap still shows light heat shades around the National Mall, and the afternoon heatmap confirms continued ride activity in northern DC. The night heatmap shows that overall bike activity gradually declines, but ridership remains visually noticeable around residential districts and metro stations.



## Conclusion

The three-year Capital Bikeshare analysis clearly indicates a post-COVID-19 economic recovery, as ridership for both commuting and tourism/business purposes increased steadily over the three years. While a behavioral gap between member and casual users remains in terms of when and where they ride, both the EDA and spatial analysis confirm that this gap is narrowing: weekend ridership among member users is growing, and casual users are increasingly active on weekdays. However, this analysis raises further questions from both business and urban planning perspectives.

From a business perspective, how can Capital Bikeshare maximize revenue from the growing e-bike ridership? While the discontinuation of docked bikes and the rise of e-bike usage present a potential revenue opportunity, given e-bikes carry a higher per-minute cost, the current data shows that classic bikes remain the dominant choice for both user groups. Therefore, adjustments to pricing strategies or collaboration with public transit agencies may be worth considering to encourage e-bike adoption among riders.

From an urban planning perspective, incorporating bikeshare station expansion into pedestrian-friendly and mixed-use zoning districts could further encourage ridership. As bikeshare stations require permits and coordination with local transportation authorities, strategic placement in high-density residential and commercial zones, particularly in underserved areas, could help bridge the existing ridership gap across the city and possibly expand the bike-friendly zone.

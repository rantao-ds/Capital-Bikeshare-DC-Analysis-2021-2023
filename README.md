# Capital Bikeshare Ridership Analysis(2021-2023)
An exploratory, spatial, and statistical analysis of Capital Bikeshare ridership patterns in Washington, D.C., using R and ArcGIS.

## Why This Project 
Washington, D.C., is honestly my favorite U.S. city. I visited the city for the National Cherry Blossom Festival two years in a row, and what impressed me was not only the scenery but also its transit accessibility. After living in the United States for a decade, D.C. was the first city where I could take the Metro directly to my hotel with my luggage and explore the city and surrounding neighborhoods without relying on Uber.

I was also impressed by how the transportation system connects Virginia through the Silver, Yellow, and Orange Lines and Maryland through the Red and Green Lines, supporting travel and economic activity across the region. For my first portfolio project, I chose to analyze Capital Bikeshare, a service I noticed but never had the chance to try during my visits to D.C.

## Data
The data were sourced from Kaggle: [Capital Bikeshare Dataset 2020/05~2024/08](https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408/data). The source contains four datasets:

  - Daily_Rent_Detail
  - Station_List
  - Usage_Frequency
  - Weather

The primary dataset used in this analysis was **Daily_Rent_Detail**, which originally contained 16,086,672 trip records from May 2020 through August 2024. After removing invalid trips, including records with zero or missing values and trips lasting more than 24 hours based on Capital Bikeshare’s rental agreement, the data were restricted to the three complete years from 2021 to 2023. The final cleaned dataset contained 9,451,314 trips for exploratory data analysis.

For EDA and modeling, the cleaned trip data were merged with the Weather dataset, incorporating variables including temperature, precipitation, wind speed, and cloud cover. The following variables were also created:
- Trip duration in minutes
- Pickup period: morning, afternoon, evening, or night
- Return type: same-day or next-day
- Trip pattern: one-way or round-trip
- Month
- Day of the week
- Weekend status
- Year: 2021, 2022, or 2023

## Exploratory Data Analysis (EDA)
The EDA focuses on answering the following questions:

**WHO** are the primary users of Capital Bikeshare?

**WHEN** does Capital Bikeshare experience the highest demand?

**WHAT** types of trips and rental patterns do riders prefer?

**WHERE** are the most frequently used bikeshare stations?

**HOW** do riders use the bikeshare service?


### Who
Based on aggregated trip data from 2021 to 2023, Capital Bikeshare members accounted for the majority of rides (60.5%), while casual riders accounted for 39.5%. This distribution remained relatively stable across the three years at approximately 60:40.

Given the annual membership commitment, members are likely local residents or frequent commuters who rely on Capital Bikeshare as part of their daily routine rather than occasional visitors. The higher ridership among members also suggests that Capital Bikeshare functions as a regular transportation option that complements other public transit services for short-distance travel among local residents and commuters.

<img width="530" alt="RIDER_MEMBERSHIP" src="https://github.com/user-attachments/assets/7c91fbcc-c415-43b2-b69a-d67437e59690" />


### What
Over the three years, the classic bike was consistently the most preferred service among all users. However, there were some notable shifts in docked and electric bike (e-bike) usage. From 2021 to 2023, docked bike usage gradually decreased from 8.2% to 2.9%. In contrast, e-bike usage more than doubled over the three years, increasing from 9.7% in 2021 to 20.8% in 2023.

For member users, docked bikes recorded only one transaction in 2021, which was removed as an outlier, while e-bike usage grew steadily by approximately 10%. For casual users, docked bike usage declined as e-bike usage increased over the three years, which reflects the gradual replacement of docked bike service by e-bikes.

As of March 2026, Capital Bikeshare no longer lists docked bikes as a rental service option. Comparing the cost of classic bikes and e-bikes, e-bikes are significantly more expensive for both member and casual users. For members, the annual membership includes the first 45 minutes of classic bike rental at no cost, while e-bike rides are charged at $0.15 per minute. For casual users, single rides cost $1 to unlock plus $0.15 per minute for classic bikes and $0.35 per minute for e-bikes. With a day pass ($10/day), casual users enjoy the same benefits as annual members: free unlocks, 45 minutes of free classic bike rental, and $0.15 per minute for e-bikes. Overall, the preference for classic bikes among both user types is likely to remain stable given the lower cost.


<img width="530" alt="bike_type_composition by year" src="https://github.com/user-attachments/assets/efe5c75d-8b80-42ae-9a4b-b7ada05b75e4" />

<img width="530" alt="ride_composition_by_year_membership" src="https://github.com/user-attachments/assets/6b6c089b-f124-4173-9d82-ab6901078bfd" />



### When 


- **Pick-up time**
  
  In terms of peak pick-up windows, member and casual users share some similarities. Both user groups are less likely to pick up bikes at night (9pm-7am), with more than 85% of daily pick-ups occurring during daytime hours.
  
  For casual users, it is unsurprising that ridership peaks during the afternoon, accounting for 37.7% of total daily usage. For members, ridership is spread much more evenly across the day. While morning pick-ups (26.6%) are slightly lower than afternoon (30.4%) and evening (30.6%), the difference isn't huge. This suggests that members don't just rely on Capital Bikeshare for morning commutes, but use it as a flexible transportation option to get around the city all day long.

<img width="600" alt="time_of_day" src="https://github.com/user-attachments/assets/c4afd050-da37-4206-b9f6-b80ad36b89a9" />



- **Weekday vs. Weekend**
  
  Overall, the majority of trips occurred during weekdays, with a steady increase from 67% in 2021 to 71.6% in 2023. This growth may be partially driven by the post-pandemic return-to-office trend, which likely increased demand for bike rentals during weekdays. Indeed, annual ridership saw a significant increase over the three years, growing from 2,424,755 trips in 2021 to 3,812,138 trips in 2023, representing approximately 57.2% growth. However, while member users experienced a modest 3% increase in weekday usage over the three years, casual users saw a 6% increase, nearly doubling the growth rate of member users. This suggests that the rapid increase in bike rental usage on weekdays may not solely be attributed to the return-to-office trend. The recovery of tourism and business travel to D.C. likely contributed as well, which reflects a broader post-pandemic economic recovery in the capital.


<img width="530" alt="trip_weekend_weekday" src="https://github.com/user-attachments/assets/72741d4a-30c4-468a-be48-2eab3552ed72" />



- **Month**
  
  As a visitor attending the National Cherry Blossom Festival in late March and early April, I noticed many people biking around the National Mall and the Tidal Basin. Surprisingly, peak ridership does not occur during the blooming period, but instead during the summer and early fall.

  In 2023, July, August, and October recorded the highest ridership of the year, each exceeding 400,000 trips per month. In 2022, peak ridership occurred between June and September, with each month surpassing 350,000 trips. In 2021, October was the only month to reach peak ridership, with over 300,000 trips. Across all three years, July stands out as the busiest month overall, which indicates a stable seasonal peak in mid-summer.

  For member users, September and October were the busiest months, likely associated with D.C.’s active fall professional and conference season. For casual users, July was consistently the busiest month, with ridership peaking across all three years, likely reflecting the increase in visitors for Independence Day celebrations.



<img width="460" alt="monthly_trip_count" src="https://github.com/user-attachments/assets/e49d1c01-3469-4ab1-8000-eb4dc8f66f30" />



<img width="530" alt="monthly_trip_count_membership" src="https://github.com/user-attachments/assets/97cace5d-924e-4d68-a973-039253fd7226" />




### Where


- **Member**
  
  Combining all rideable types, the top 3 pick-up stations for member users were ***"New Hampshire Ave & T St NW"***, ***"15th & P St NW"***, and ***"Columbus Circle / Union Station"***, each averaging around 70,000 pick-ups over the three years.
  
  Here are the top 3 drop-off stations regardless of rideable type with over 1,000 trips for each high-demand starting station:

  - ***New Hampshire Ave & T St NW*** 

    According to the DC official zoning map, "New Hampshire Ave & T St NW" is located in the RA-4 district, zoned for residential apartments and surrounded by other RA-coded districts. Here are the top drop-off stations with over 1,000 drop-offs from "New Hampshire Ave & T St NW" by pick-up time window:
    
    Morning: 17th & K St NW / 18th & New Hampshire Ave NW
    
    Afternoon: 15th & P St NW 
    
    Evening: 15th & P St NW / 17th & Corcoran St NW

    For morning riders, the trip purpose is likely work-related. All morning top drop-off stations are located close to major employment centers and transit hubs. The K Street corridor is known for its concentration of firms and offices, within walking distance of Farragut Square Metro station. "18th Street NW" is a mixed-use district with office buildings and embassies, also just a few blocks away from Dupont Circle.

    During afternoon and evening hours, the trip purpose appears to shift from commuting to leisure and errands. "17th & Corcoran St NW" is located in a mixed-use zone with grocery stores including Whole Foods and numerous restaurants. "15th & P St NW" is situated in the ARTS-3 Special Purpose Zone designed to promote arts, entertainment, and retail uses with an emphasis on 18-hour pedestrian activity, according to D.C. zoning regulations.
    

  - ***15th & P St NW***

    As mentioned above, "15th & P St NW" is located in the ARTS-3 Special Purpose Zone, adjacent to a large RA-coded residential neighborhood and a mixed-use district. The ARTS-3 zone is specifically designed to promote pedestrian-friendly development, which naturally discourages car ownership among residents. In other words, the surrounding area has a high concentration of residents who are likely to rely on bikes and public transit for both leisure and daily commuting purposes. Here are the top stations with over 1,000 drop-offs from "15th & P St NW" by pick-up time window:

    Morning: Massachusetts Ave & Dupont Circle
    
    Afternoon: New Hampshire Ave & T St NW
    
    Evening: New Hampshire Ave & T St NW / 15th & W St NW

    As expected, morning riders appear to bike to work, as "Massachusetts Ave & Dupont Circle NW" is located in a dense office area within walking distance of Dupont Circle Metro station. For afternoon and evening riders, it is interesting to note that "New Hampshire Ave & T St NW", previously identified as a residential zone and the top pick-up station for member users, now appears as a top drop-off station, which suggests that the riders may be heading home after work or running errands. Additionally, "15th & W St NW", a high drop-off station during evening hours, is located on the edge of Downtown D.C., which suggests the riders may be heading there for dining and nightlife purposes.


  - ***Columbus Circle / Union Station***
  
    "Columbus Circle / Union Station" is distinct from "New Hampshire Ave & T St NW" and "15th & P St NW", which are zoned for residential and mixed-use districts. As one of D.C.'s largest transit hubs serving Amtrak, Metro, and bus routes, its high ridership is naturally expected.
    
    Here are the top stations with over 1,000 drop-offs from "Columbus Circle / Union Station" by pick-up time window:

    Morning: 4th & M St SE / 3rd & M St SE
    
    Afternoon: 8th & F St NE / 6th & H St NE
    
    Evening: 6th & H St NE / 8th & F St NE / Maryland Ave & E St NE 

    Interestingly, the top morning drop-off destinations are concentrated in the Navy Yard and Southeast Federal Center (SEFC) zones, a high-density mixed-use waterfront district, which suggests that morning riders are likely federal employees or government contractors commuting to nearby offices. For afternoon and evening riders, drop-off stations shift to RF (Residential Flat) and Neighborhood Mixed-Use zones, with a portion of evening rides ending at the National Arboretum, which indicates that riders may be heading home or enjoying outdoor leisure activities after work.


- **Casual**
  
  For casual users, unsurprisingly, the highest demand stations are located along the National Mall: ***"Lincoln Memorial"***, ***"Jefferson Dr & 14th St SW"***, and ***"Henry Bacon Dr & Lincoln Memorial Circle NW"***, each recording over 60,000 pick-ups over the three years.


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


    Unlike member users who demonstrate diverse destinations for both work and leisure, casual users appear to bike exclusively for sightseeing, consistently riding in a loop pattern between the same or nearby stations around the National Mall.


<img width="600" alt="top3_pickup_location" src="https://github.com/user-attachments/assets/00bb6527-6545-4cd6-8094-cb754e201cc8" />




- **Weekday vs. Weekend**
  
Overall, trips at the top three pick-up stations on weekdays have steadily increased over the three years, while weekend trips have remained relatively stable. For weekday trips, the top pick-up stations align with the highest-demand stations for member users, which confirms that the primary weekday riders are members and supports the return-to-office trend discussed above. For weekend trips, the highest-demand stations shifted from visitor-oriented locations around the National Mall in 2021-2022 to a mix of tourism sites and R-coded residential neighborhoods by 2023. This suggests a potential increase in weekend bike rental demand among member users over time.



<img width="600" alt="weekend_weekday_top3_pickup_location" src="https://github.com/user-attachments/assets/6b2bfdb0-cb0e-4e76-b51f-729d2392de1f" />




### How

- **Trip Duration (minutes)**

  In terms of trip duration, member and casual users exhibit different usage patterns. Member users tend to keep trips around 10 minutes. Specifically, classic bike trips typically last under 10 minutes, while e-bike trips are slightly longer, with median durations exceeding 10 minutes during the afternoon and evening.

  In contrast, casual users spend more time on bikes, with median trip durations exceeding 10 minutes across all rideable types. Docked bikes recorded the longest median durations, ranging from 23 to 33 minutes, likely because they must be returned to a designated station. Meanwhile, casual users’ classic bike trips range from 13 to 18 minutes, while e-bike trips range from 11 to 13 minutes, both longer than the typical member user trip.


<img width="600" alt="median_trip_duration_pickup_bike_type" src="https://github.com/user-attachments/assets/8637d582-2e87-4d4d-b5be-da1a793ddf35" />


  

 - **Trip Pattern**

   As all trips in this analysis are valid and do not exceed the 24-hour rental limit, 99% of bikes were returned on the same day for both user groups. However, casual users are more likely to make round-trips, with 9% of trips ending at the same station where the bike was picked up. Member users, by contrast, are far less likely to return to the pick-up station, with only 2.3% of trips being round-trips. These trip patterns reinforce the earlier finding that member users primarily take point-to-point trips, while casual users tend to make loop-based trips for sightseeing purposes.



<img width="500" alt="trip_return_membership" src="https://github.com/user-attachments/assets/f99b0f40-1185-4281-8874-e849a3849a25" />


<img width="500" alt="trip_pattern_membership" src="https://github.com/user-attachments/assets/a2111666-5e6c-4ab6-8325-c2c87609cda7" />




## Modeling 

### Objective

For modeling, this section examines whether daily bikeshare ridership is associated with weather conditions and weekend status, whether weather relationships are linear or curved, and whether these effects differ between weekdays and weekends. Multiple linear regression was used as the baseline model, quadratic terms were added to examine curved patterns, and interaction terms tested whether the effects of temperature and precipitation varied by weekend status. The trip-level data were aggregated into 1,095 daily observations (365 days × 3 years) from the 9,451,314 trips used in the EDA.

### Variables 

- **Dependent Variable:** total_trips

- **Independent Variables:** temp, precip, windspeed, cloudcover, weekend

### Methodology 

**1. Multiple Linear Regression** 

The first step was to estimate a multiple linear regression model using daily trip counts (total_trips) as the dependent variable. The model examined how temperature, precipitation, wind speed, cloud cover, and weekend status were associated with daily ridership, whether these relationships were statistically significant, and how much variation in trip counts was explained by the selected predictors.

**2. Variance Inflation Factor (VIF)**

The second step was to assess multicollinearity using the Variance Inflation Factor (VIF). Multicollinearity can occur when independent variables are strongly related, making individual coefficient estimates unstable or difficult to interpret.

Because temperature, precipitation, wind speed, and cloud cover may contain overlapping information about weather conditions, VIF values were examined to determine whether multicollinearity was a concern in the model.

**3. Regularization**

The modeling dataset contains 1,095 daily observations, aggregated from 9,451,314 trip-level records covering three complete years. The dataset was divided into 70% training and 30% testing sets.

Ridge, Lasso, and Elastic Net regularization were applied to evaluate coefficient stability, reduce potential overfitting, and compare out-of-sample predictive performance.

**4. Quadratic and Interaction Effects**

The final step extended the baseline linear model by examining curved relationships and interaction effects. Weather variables such as temperature may not have a strictly linear relationship with ridership. For example, ridership may increase as temperatures become warmer but decline once temperatures become excessively high.

Quadratic terms were added for the weather variables to capture potential curvature and identify possible maximum or minimum points in their relationships with ridership. Any estimated turning point was interpreted only when it fell within the observed range of the data.

Interaction terms between weekend status and both temperature and precipitation were also included. These interactions tested whether the effects of temperature and precipitation differed between weekdays and weekends by estimating separate changes in slope for the two groups.


### Results

**1. Multiple Linear Regression** 


<img width="350" alt="LM" src="https://github.com/user-attachments/assets/6b6eab43-748d-4ff8-879c-c4e86085cfb9" />


The multiple linear regression model explains 58.1% of the variation in daily trip counts (R² = 0.581; adjusted R² = 0.579; n = 1,095). All five predictors are statistically significant at the 1% level (p < 0.01). Among the weather variables, temperature has the strongest positive association with ridership, with each one-degree increase associated with approximately 282 additional daily trips. In contrast, precipitation, wind speed, and cloud cover are associated with approximately 115, 36, and 27 fewer daily trips, respectively. Weekend days are associated with roughly 840 more trips than weekdays.


**2. Variance Inflation Factor (VIF)**


<img width="1300" alt="Screenshot 2026-03-23 at 7 18 49 PM" src="https://github.com/user-attachments/assets/cd14966b-dafd-4af7-86a5-53dfb3a8f4d9" />


The VIF results indicate no multicollinearity concerns, with all values close to 1 and ranging from 1.003 to 1.162. This suggests that the predictors provide largely distinct information and that the coefficient estimates are not substantially affected by multicollinearity.


**3. Regularization**

  - ***Comparison of Regularization Models***


<img width="660" alt="regulation_model" src="https://github.com/user-attachments/assets/72095920-ca45-4688-9db8-cde36c2ae1ef" />


Ridge, Lasso, and Elastic Net regularization were applied to assess coefficient stability. Across the three approaches, the coefficient paths followed similar directions and converged toward comparable values as the penalty weakened, suggesting that the relationships were generally stable across the models.


  - ***Comparison of MSEs***


<img width="1300" alt="MSEs Comparison" src="https://github.com/user-attachments/assets/84d75057-f638-46eb-b374-6ac5cf622e78" />


The models produced nearly identical MSE values, ranging from 5,973,497 to 5,976,964. This indicates that regularization did not meaningfully improve predictive performance over the baseline linear regression model and provides additional evidence of model stability.


**4. Quadratic and Interaction Effects**


  - ***Quadratic Model***


<img width="350" alt="quatric" src="https://github.com/user-attachments/assets/3890b249-ec96-44e6-8d00-7e998c571313" />


<img width="330" alt="Peak" src="https://github.com/user-attachments/assets/382943b1-8c91-4593-ae0b-edaa29daaed9" />


The quadratic regression model explains 65.1% of the variation in daily trip counts (R² = 0.651; adjusted R² = 0.648), improving upon the baseline linear regression model (R² = 0.581). The linear and squared terms for temperature, precipitation, and cloud cover are statistically significant at the 1% level (p < 0.01), while the wind-speed terms are not significant.

Predicted ridership increases with temperature until reaching a maximum at approximately 25.7°C, after which it declines. Ridership decreases as precipitation increases until reaching a predicted minimum at approximately 37.7 mm. The slight upward curve beyond this point is likely due to limited data on extreme rain days rather than actual ridership growth. Cloud cover is associated with a small increase in predicted ridership until approximately 34.4%, followed by a decline.

Weekend days are associated with approximately 896 additional daily trips compared with weekdays, holding the weather variables constant.


  - ***Interaction Model***


<img width="350" alt="interaction" src="https://github.com/user-attachments/assets/5cb5bbdd-d875-4479-83ef-40b16bd2e978" />



<img width="460" alt="slope" src="https://github.com/user-attachments/assets/3f26dfd9-604e-42ab-a3f2-190e3e12557f" />


The interaction model explains 58.7% of the variation in daily trip counts (R² = 0.587; adjusted R² = 0.584), representing only a small improvement over the baseline model.

On weekdays, each 1°C increase in temperature is associated with approximately 262 additional trips. The Weekend × Temperature coefficient adds approximately 67 trips per degree, producing an estimated weekend slope of approximately 329 additional trips per degree.

The Weekend × Precipitation interaction is not statistically significant, indicating insufficient evidence that precipitation affects ridership differently on weekends and weekdays.



### Summary 

Overall, the modeling analysis indicates that weather conditions, particularly temperature and weekend status, are important predictors of daily Capital Bikeshare ridership. The baseline linear model shows positive associations between temperature, weekend status, and ridership, while the interaction model suggests that temperature has a stronger positive association with ridership on weekends than on weekdays.

The quadratic model reveals curved relationships between several weather variables and ridership. Predicted ridership peaks at approximately 25.7°C and declines beyond this point. For precipitation, predicted ridership reaches a minimum at approximately 37.7 mm. While the curve bends slightly back up after this point, that is mainly due to the small number of extreme rain days rather than actual ridership growth during storms.

The quadratic model explains more variation than the baseline linear model (R² = 0.651 versus 0.581), suggesting that some weather–ridership relationships are not strictly linear. VIF diagnostics show no multicollinearity concerns, while the similar test MSE values across the baseline and regularized models provide evidence that the baseline model is relatively stable and that regularization offers little improvement in predictive performance.



## Spatial Analysis (ArcGIS)


The spatial analysis explores the geographic distribution of Capital Bikeshare ridership across Washington, D.C., to identify spatial patterns across different membership types, times of day, and days of the week. The analysis is visualized through heatmaps generated in ArcGIS, where yellow dots indicate the highest-demand stations by trip count.

All spatial visualizations were completed using ArcGIS Online, with aggregated station-level data including latitude and longitude coordinates imported from the EDA dataset. Multiple layers were added to each map to provide geographic context, including Metro lines, Metro stations, and the Washington, D.C. administrative boundary.

**Member vs. Casual**


<img width="600" alt="Member" src="https://github.com/user-attachments/assets/d2750fdb-9926-4f3f-a74f-4ba16c4bfde8" />



The map above shows the geographic distribution of the highest-demand stations among member users. The heatmap indicates that the majority of member trips originated in residential and commercial districts in northern D.C., above Massachusetts Ave and the K Street corridor. Specifically, the most intense ridership is concentrated between Connecticut Ave NW and 7th Street NW, shown in yellow on the map. Smaller hotspots are also visible around Union Station, Eastern Market, and Navy Yard. Overall, member trip start locations are distributed across D.C. but concentrated in the northern part of the city, reflecting a combination of employment centers and R-coded residential districts.



<img width="600" alt="casual" src="https://github.com/user-attachments/assets/3af8785e-8426-458d-87b1-5856befa5efe" />




The map above presents the geographic distribution of the most preferred pick-up stations among casual users. Unlike member users, the heatmap shows a completely reversed distribution, with the most intense hotspots concentrated within the National Mall, reflecting the tourism-based loop trip pattern identified in the EDA. The most intense demand is visually concentrated around the Lincoln Memorial, located at the western end of the National Mall. Strong hotspots are also found in the middle of the National Mall around the Washington Monument and Smithsonian Metro Station, which typically serve as the starting point for National Mall tours. Another hotspot is located at the eastern end of the National Mall, between Capitol Hill and the National Gallery of Art.


**Weekday vs. Weekend**


<img width="600" alt="weekday" src="https://github.com/user-attachments/assets/8feec465-fdc9-4a50-b4e8-770277031aa7" />


The map above presents the geographic distribution of the highest-demand start stations during weekdays. The heatmap shows that hotspots are spread across D.C., reflecting the combined ridership patterns of both member and casual users. Unlike the membership-specific maps, the weekday heatmap does not show a strong concentration in any single district, which indicates that both user groups actively use Capital Bikeshare throughout the week across different parts of the city. However, stronger hotspots are visually concentrated around the residential districts in northern D.C. and major transit hubs such as Dupont Circle and Union Station.


<img width="600" alt="weekend" src="https://github.com/user-attachments/assets/db2dee0c-396e-4ccf-baf6-d2134f2e0419" />



The map above shows the geographic distribution of the most preferred pick-up stations during weekends. Compared to the weekday heatmap, the residential districts and transit hubs show lighter heat shades, suggesting a decline in commuting-based trips. In contrast, the hotspots around the National Mall intensify significantly on weekends, closely resembling the casual user heatmap, with a strong concentration around the Lincoln Memorial, the Washington Monument, Smithsonian Metro Station, and the area between Capitol Hill and the National Gallery of Art. The weekend heatmap also confirms the EDA finding that weekend ridership is not purely tourism-based, as residential district hotspots remain visually noticeable, reflecting a mix of tourism and local leisure purposes.


**Morning vs. Afternoon vs. Evening**


<img width="600" alt="morning" src="https://github.com/user-attachments/assets/3effa30a-ff0b-4f65-bcff-b42d1f461ac5" />



<img width="600" alt="afternoon" src="https://github.com/user-attachments/assets/479360d8-6fe9-44a9-a9e6-5246d2375097" />



<img width="600" alt="evening" src="https://github.com/user-attachments/assets/2d7a970d-93b2-4a96-a2bc-a74b9dc5c6c4" />



Comparing the three major pick-up time windows, a clear shift is visible from commuting-oriented activity in the residential districts of northern D.C. during the morning to tourism-oriented activity around the National Mall during the afternoon. However, this does not mean that non-peak areas are inactive during off-peak hours. For example, the morning heatmap still shows light heat shades around the National Mall, and the afternoon heatmap confirms continued ride activity in northern D.C. The night heatmap shows that overall bike activity gradually declines, but ridership remains visually noticeable around residential districts and Metro stations.



## Conclusion

The three-year Capital Bikeshare analysis clearly indicates a post-COVID-19 economic recovery, as ridership for both commuting and tourism/business purposes increased steadily over the three years. While a behavioral gap between member and casual users remains in terms of when and where they ride, both the EDA and spatial analysis confirm that this gap is narrowing: weekend ridership among member users is growing, and casual users are increasingly active on weekdays. However, this analysis raises further questions from both business and urban planning perspectives.

From a business perspective, how can Capital Bikeshare maximize revenue from the growing e-bike ridership? While the discontinuation of docked bikes and the rise of e-bike usage present a potential revenue opportunity given their higher per-minute cost, the current data shows that classic bikes remain the dominant choice for both user groups. Therefore, adjustments to pricing strategies or collaboration with public transit agencies may be worth considering to encourage e-bike adoption among riders.

From an urban planning perspective, incorporating bikeshare station expansion into pedestrian-friendly and mixed-use zoning districts could further encourage ridership. As bikeshare stations require permits and coordination with local transportation authorities, strategic placement in high-density residential and commercial zones, particularly in underserved areas, could help bridge the existing ridership gap across the city and possibly expand the bike-friendly zone.

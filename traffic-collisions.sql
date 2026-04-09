-- =========================
-- Traffic Collision Analysis
-- =========================
--Dataset: Traffic Collision Data from 2010 to Present
--Source: https://data.lacity.org/Public-Safety/Traffic-Collision-Data-from-2010-to-Present/d5tf-ez2w/about_data
--Author: Joey Lee

--Data Overview
SELECT * 
FROM traffic_final
LIMIT 5;

--How have annual total traffic collisions changed over the time spanned by the dataset?
SELECT 
year_occurred AS year,
COUNT(*) as total_collisions
FROM traffic_final
GROUP BY year_occurred
ORDER BY year_occurred

--What months have the most traffic collisions?
SELECT 
month_occurred AS month,
COUNT(*) as total_collisions
FROM traffic_final
GROUP BY month_occurred
ORDER BY month_occurred DESC

--What hours of the day have the most traffic collisions?
SELECT 
hour_occurred AS hour,
COUNT(*) as total_collisions
FROM traffic_final
GROUP BY hour_occurred
ORDER BY hour_occurred DESC

--What days of the week have the most traffic collisions?
SELECT 
weekday_occurred AS weekday,
COUNT(*) as total_collisions
FROM traffic_final
GROUP BY weekday_occurred
ORDER BY weekday_occurred DESC

--What are the top 5 most dangerous hours of the day for collisions (i.e. most fatal)?
SELECT 
hour_occurred AS hour,
COUNT(*) as fatal_collisions
FROM traffic_final
WHERE is_fatal = 'TRUE'
GROUP BY hour_occurred
ORDER BY fatal_collisions DESC
LIMIT 5;


--What percent of fatal collisions occur during the early morning?
SELECT
period,
COUNT(*) as fatal_collisions,
ROUND(
  (COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100,
  2
	) AS percent
FROM traffic_final
WHERE is_fatal = 'TRUE'
GROUP BY period;

--What are the fatality rates of vehicle-pedestrian, vehicle-bicycle, and vehicle-vehicle collisions?
SELECT
    CASE
        WHEN veh_vs_ped = 'TRUE' THEN 'Vehicle-Pedestrian'
        WHEN veh_vs_bike = 'TRUE' THEN 'Vehicle-Bicycle'
        WHEN veh_vs_veh = 'TRUE' THEN 'Vehicle-Vehicle'
        ELSE 'Collision Type Unknown'
    END AS collision_type,

    COUNT(*) AS total_collisions,

    SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) AS fatal_collisions,

    ROUND(
        SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
        3
    ) AS fatality_rate

FROM traffic_final
GROUP BY collision_type
ORDER BY fatality_rate DESC;

--What are the fatality rates of holiday vs non-holiday collisions?
SELECT
    CASE
        WHEN is_holiday = 'TRUE' THEN 'Holiday'
        ELSE 'Non-Holiday'
    END AS holiday_status,

    COUNT(*) AS total_collisions,

    SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) AS fatal_collisions,

    ROUND(
        SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
        3
    ) AS fatality_rate

FROM traffic_final
GROUP BY holiday_status;

--What are the fatality rates of early-morning vs non-early morning collisions?
SELECT
    CASE
        WHEN is_early_morning = 'TRUE' THEN 'Early Morning'
        ELSE 'Non-Early Morning'
    END AS early_morning_status,

    COUNT(*) AS total_collisions,

    SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) AS fatal_collisions,

    ROUND(
        SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
        3
    ) AS fatality_rate

FROM traffic_final
GROUP BY early_morning_status;

--Is there interaction between early morning status and holiday status in total and fatal collisions?
SELECT
    is_early_morning,
    is_holiday,
    COUNT(*) AS total_collisions,
    SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) AS fatal_collisions,
    ROUND(
        SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
        3
    ) AS fatality_rate
FROM traffic_final
GROUP BY is_early_morning, is_holiday;

--How does fatality rate vary by hour of day?
SELECT
    hour_occurred AS hour,
    COUNT(*) AS total_collisions,
    SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) AS fatal_collisions,
    ROUND(
        SUM(CASE WHEN is_fatal = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS fatality_rate_percent
FROM traffic_final
GROUP BY hour_occurred
ORDER BY hour;

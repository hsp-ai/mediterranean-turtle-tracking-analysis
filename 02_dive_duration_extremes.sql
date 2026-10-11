--Question 02: What are the shortest and longest dive durations? 
SELECT
    MIN(DIVE_DUR) AS shortest_dive_seconds,
    ROUND(MIN(DIVE_DUR)/60.0,2) AS shortest_dive_minutes,
    MAX(DIVE_DUR) AS longest_dive_seconds,
    ROUND(MAX(DIVE_DUR)/60.0,2) AS longest_dive_minutes
FROM `mediterranean-turtles.mediterranean_turtles.dive_data`
WHERE DIVE_DUR IS NOT NULL;
--Question 03: What is the average dive duration?
--DIVE_DUR is measured in seconds.
SELECT  
    ROUND(AVG(DIVE_DUR),2) AS average_dive_seconds,
    ROUND(AVG(DIVE_DUR)/60.0,2) AS average_dive_minutes
FROM `mediterranean-turtles.mediterranean_turtles.dive_data`
WHERE DIVE_DUR IS NOT NULL;
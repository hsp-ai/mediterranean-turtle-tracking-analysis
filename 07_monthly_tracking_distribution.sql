--Question 07: How are turtle tracking records distributed by month?
--Tables: tracking_data + reference_data

SELECT
    DATE_TRUNC(DATE(t.timestamp),MONTH) AS tracking_month,
    COUNT(DISTINCT t.`event-id`) AS tracking_record_count,
    COUNT(DISTINCT r.`animal-id`) AS distinct_turtle_count
FROM 
    `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
JOIN
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
ON
    t.`tag-local-identifier`=r.`tag-id`
WHERE
    t.timestamp IS NOT NULL
GROUP BY
    tracking_month
ORDER BY 
    tracking_month ASC;
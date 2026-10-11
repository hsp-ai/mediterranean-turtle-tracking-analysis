
-- Question 09: How does satellite tracking data vary by turtle sex?
-- Tables: tracking_data + reference_data
SELECT
    r.`animal-sex` AS animal_sex,
    COUNT(DISTINCT t.`event-id`) AS tracking_record_count,
    COUNT(DISTINCT r.`animal-id`) AS distinct_turtle_count,
    ROUND(AVG(t.`argos:error-radius`),2) AS avg_error_radius
FROM
    `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
JOIN
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
ON
    t.`tag-local-identifier`=r.`tag-id`
WHERE
    r.`animal-sex` IS NOT NULL
    AND t.`event-id` IS NOT NULL
GROUP BY
    animal_sex
ORDER BY 
    tracking_record_count DESC;
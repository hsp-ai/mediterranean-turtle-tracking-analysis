
-- Question 10: How does Argos location class relate to tracking volume and location uncertainty?
-- Tables: tracking_data + reference_data
SELECT
    t.`argos:lc` AS argos_location_class,
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
    t.`argos:lc` IS NOT NULL
    AND t.`event-id` IS NOT NULL
GROUP BY
    argos_location_class
ORDER BY
    tracking_record_count DESC;

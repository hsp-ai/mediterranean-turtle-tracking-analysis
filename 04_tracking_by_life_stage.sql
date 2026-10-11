
-- Question 04: How does satellite tracking activity vary by turtle life stage?
-- Tables: tracking_data + reference_data
SELECT
    COALESCE(r.`animal-life-stage`,'Unknown') AS life_stage,
    COUNT(DISTINCT r.`animal-id`) AS distinct_turtle_count,
    COUNT(DISTINCT t.`event-id`) AS tracking_record_count
FROM
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
LEFT JOIN 
    `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
ON
    r.`tag-id`=t.`tag-local-identifier`
GROUP BY
    life_stage
ORDER BY
    tracking_record_count DESC;
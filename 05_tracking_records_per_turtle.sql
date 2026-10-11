--Question 05: How many tracking records does each turtle have?
--Tables: tracking_data + reference_data

SELECT
    r.`animal-id` AS turtle_id,
    r.`animal-sex` AS animal_sex,
    COUNT(DISTINCT t.`event-id`) AS tracking_record_count
FROM 
    `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
LEFT JOIN
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
ON
    t.`tag-local-identifier`=r.`tag-id`
GROUP BY
    turtle_id,
    animal_sex
ORDER BY 
    tracking_record_count DESC;
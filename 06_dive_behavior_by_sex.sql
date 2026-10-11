--Question 06: Does dive behavior differ by sex?
--Tables: dive_data + reference_data

SELECT
    r.`animal-sex` AS animal_sex,
    COUNT(*) AS dive_record_count,
    ROUND(AVG(d.DIVE_DUR)/60.0,2) AS avg_dive_duration_minutes,
    ROUND(AVG(d.MAX_DEP),2) AS avg_max_dive_depth
FROM 
    `mediterranean-turtles.mediterranean_turtles.dive_data` AS d
JOIN
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
ON
    d.REF=r.`deployment-id`
WHERE
    d.DIVE_DUR IS NOT NULL
    AND r.`animal-sex` IS NOT NULL
GROUP BY
    animal_sex
ORDER BY 
    avg_dive_duration_minutes DESC;

-- Question 08: Is tracking intensity related to dive behavior?
-- Tables: tracking_data +dive_data+ reference_data
WITH tracking_summary AS(
    SELECT
        r.`animal-id` AS turtle_id,
        COUNT(DISTINCT t.`event-id`) AS tracking_record_count
    FROM
        `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
    JOIN
        `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
    ON
        t.`tag-local-identifier`= r.`tag-id`
    WHERE
        r.`animal-id` IS NOT NULL
    GROUP BY
        turtle_id
),
dive_summary AS(
    SELECT
        r.`animal-id` AS turtle_id,
        COUNT(*) AS dive_record_count,
        ROUND(AVG(d.DIVE_DUR)/60.0,2) AS avg_dive_duration_minutes
    FROM
        `mediterranean-turtles.mediterranean_turtles.dive_data` AS d
    JOIN
        `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
    ON
        d.REF=r.`deployment-id`
    WHERE
        d.DIVE_DUR IS NOT NULL
        AND r.`animal-id` IS NOT NULL
    GROUP BY
        turtle_id
)
SELECT
    t.turtle_id,
    t.tracking_record_count,
    d.dive_record_count,
    d.avg_dive_duration_minutes
FROM
    tracking_summary AS t
JOIN
    dive_summary AS d
ON
    t.turtle_id=d.turtle_id
ORDER BY
    t.tracking_record_count DESC;
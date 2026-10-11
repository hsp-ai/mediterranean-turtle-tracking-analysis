--Question 01:  How many distinct turtles were tracked?
--Dataset: Movebank loggerhead turtle tracking study

SELECT
    COUNT(DISTINCT`animal-id`) AS distinct_animals
FROM `mediterranean-turtles.mediterranean_turtles.reference_data`;
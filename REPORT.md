Mediterranean Loggerhead Turtle Tracking Analysis — Research Report
1. Introduction

This report documents SQL analyses performed on satellite tracking and diving data of loggerhead sea turtles (Caretta caretta) in the Mediterranean Sea using Google BigQuery.

The study examines animal identifiers, tracking records, dive durations, maximum dive depths, sex information, life stages, and Argos location data. The analyses use the reference_data, tracking_data, and dive_data tables.

The primary objective is to summarize data using SQL, conduct descriptive comparisons between groups, and investigate the characteristics of tracking and diving records in a real-world wildlife dataset.

This report is based exclusively on the ten SQL queries executed in BigQuery and the outputs provided for those queries. All findings are interpreted within the scope of the corresponding queries.

2. Data Source and Tables
2.1. Data source

Hochscheid, S. (2020). Data from: Study "Satellite Tracking of Oceanic Loggerhead Turtles in the Mediterranean". Movebank Data Repository.

Dataset DOI: https://doi.org/10.5441/001/1.1f1h87r8

Related publication:

Chimienti, M., Blasi, M. F., & Hochscheid, S. (2020). Movement patterns of large juvenile loggerhead turtles in the Mediterranean Sea: ontogenetic space use in a small ocean basin. Ecology and Evolution, 10(14), 6978–6992.

Publication DOI: https://doi.org/10.1002/ece3.6370
2.2. BigQuery environment
Property	Value
Project ID	mediterranean-turtles
Dataset ID	mediterranean_turtles
2.3. Tables used
Table	Purpose
reference_data	Animal identifiers, sex, life stage, tag, and deployment metadata
tracking_data	Satellite tracking events, timestamps, and Argos location data
dive_data	Dive measurements, including dive duration and maximum dive depth

Depending on the analysis, the tables were joined using the relevant fields, including animal-id, tag-id, tag-local-identifier, deployment-id, and REF.

3. Research Questions and Analyses
3.1. Analysis 1 — How many distinct turtles were tracked?

Research question: How many distinct turtles were tracked?

SQL query:

SELECT
    COUNT(DISTINCT `animal-id`) AS distinct_animals
FROM `mediterranean-turtles.mediterranean_turtles.reference_data`;


BigQuery output:

distinct_animals
11

Findings and interpretation:

Counting distinct animal-id values in the reference_data table returned a result of 11.

This indicates that the reference table contains 11 distinct animal identifiers. However, the number of distinct identifiers does not, by itself, establish the number of biologically independent individuals that have been independently verified.

3.2. Analysis 2 — What are the shortest and longest dive durations?

Research question: What are the shortest and longest dive durations?

SQL query:

SELECT
    MIN(DIVE_DUR) AS shortest_dive_seconds,
    ROUND(MIN(DIVE_DUR)/60.0,2) AS shortest_dive_minutes,
    MAX(DIVE_DUR) AS longest_dive_seconds,
    ROUND(MAX(DIVE_DUR)/60.0,2) AS longest_dive_minutes
FROM `mediterranean-turtles.mediterranean_turtles.dive_data`
WHERE DIVE_DUR IS NOT NULL;


BigQuery output:

shortestdiveseconds	shortestdiveminutes	longestdiveseconds	longestdiveminutes
30	0.5	64800	1080.0

Findings and interpretation:

According to the query results, the shortest dive duration is 30 seconds, while the longest is 64,800 seconds. These values correspond to 0.5 minutes and 1,080 minutes, respectively.

The longest duration is equivalent to 18 hours. This is the maximum DIVE_DUR value returned by the query. The available output is insufficient to independently verify this record or explain why its duration is so long.

Records with NULL values in DIVE_DUR were excluded from the calculation.

3.3. Analysis 3 — What is the average dive duration?

Research question: What is the average dive duration?

SQL query:

SELECT
    ROUND(AVG(DIVE_DUR),2) AS average_dive_seconds,
    ROUND(AVG(DIVE_DUR)/60.0,2) AS average_dive_minutes
FROM `mediterranean-turtles.mediterranean_turtles.dive_data`
WHERE DIVE_DUR IS NOT NULL;


BigQuery output:

averagediveseconds	averagediveminutes
1345.54	22.43

Findings and interpretation:

The average of non-NULL DIVE_DUR values is 1,345.54 seconds, equivalent to 22.43 minutes.

This result represents the average duration of the dive records included in the calculation. Since records with NULL dive durations were excluded, the result should not be interpreted as the average duration of every possible dive in the dataset.

3.4. Analysis 4 — How does satellite tracking activity vary by turtle life stage?

Research question: How does satellite tracking activity vary by turtle life stage?

SQL query:

SELECT
    COALESCE(r.`animal-life-stage`, 'Unknown') AS life_stage,
    COUNT(DISTINCT r.`animal-id`) AS distinct_turtle_count,
    COUNT(DISTINCT t.`event-id`) AS tracking_record_count
FROM
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
LEFT JOIN
    `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
ON
    r.`tag-id` = t.`tag-local-identifier`
GROUP BY
    life_stage
ORDER BY
    tracking_record_count DESC;


BigQuery output:

life_stage	distinctturtlecount	trackingrecordcount
juvenile	11	10271

Findings and interpretation:

The query returned 11 distinct animals and 10,271 distinct tracking event identifiers for the juvenile life-stage category.

The query uses COALESCE() to assign the label Unknown to missing life-stage values. However, this category does not appear in the provided output.

Only the juvenile category appears in the results. Therefore, the output alone does not establish the distribution of every possible life stage in the dataset.

3.5. Analysis 5 — How many tracking records does each turtle have?

Research question: How many tracking records does each turtle have?

SQL query:

SELECT
    r.`animal-id` AS turtle_id,
    r.`animal-sex` AS animal_sex,
    COUNT(DISTINCT t.`event-id`) AS tracking_record_count
FROM
    `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
LEFT JOIN
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
ON
    t.`tag-local-identifier` = r.`tag-id`
GROUP BY
    turtle_id,
    animal_sex
ORDER BY
    tracking_record_count DESC;


BigQuery output:

turtle_id	animal_sex	trackingrecordcount
244	u	1896
242	f	1857
243	u	1456
SZN140	u	1080
245	u	964
S248	u	884
241	m	715
S247	u	492
S250	f	469
S249	u	328
S246	u	130

Findings and interpretation:

The query groups tracking events by animal identifier and sex, counting distinct event-id values for each group.

Among the reported records, turtle 244 has the highest tracking record count, at 1,896, while turtle S246 has the lowest, at 130.

This comparison shows that tracking record counts vary across animal identifiers. However, a higher record count does not, by itself, indicate that an animal moved more or used a larger geographical area.

Sex codes are retained in the format provided by the source data. The meaning of the u code has not been independently verified.

3.6. Analysis 6 — Does dive behavior differ by sex?

Research question: Does dive behavior differ by sex?

SQL query:

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
    d.REF = r.`deployment-id`
WHERE
    d.DIVE_DUR IS NOT NULL
    AND r.`animal-sex` IS NOT NULL
GROUP BY
    animal_sex
ORDER BY
    avg_dive_duration_minutes DESC;


BigQuery output:

animal_sex	diverecordcount	avgdiveduration_minutes	avgmaxdive_depth
m	135	38.60	20.11
u	2562	22.16	31.29
f	627	20.03	21.17

Findings and interpretation:

The average dive duration is 38.60 minutes for the m group, 22.16 minutes for the u group, and 20.03 minutes for the f group.

The corresponding average maximum dive depth values are 20.11, 31.29, and 21.17. Since the unit of the depth field is not specified in the provided output, no unit has been assumed.

The number of dive records also differs between groups: 135 for m, 2,562 for u, and 627 for f.

These results describe the observed group averages. Since no statistical significance test was performed, the differences cannot be described as statistically significant, nor can they establish that sex causes differences in dive behavior.

3.7. Analysis 7 — How are tracking records distributed by month?

Research question: How are turtle tracking records distributed by month?

SQL query:

SELECT
    DATE_TRUNC(DATE(t.timestamp), MONTH) AS tracking_month,
    COUNT(DISTINCT t.`event-id`) AS tracking_record_count,
    COUNT(DISTINCT r.`animal-id`) AS distinct_turtle_count
FROM
    `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
JOIN
    `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
ON
    t.`tag-local-identifier` = r.`tag-id`
WHERE
    t.timestamp IS NOT NULL
GROUP BY
    tracking_month
ORDER BY
    tracking_month ASC;


BigQuery output:

tracking_month	trackingrecordcount	distinctturtlecount
2016-10-01	224	1
2016-11-01	885	5
2016-12-01	1062	5
2017-01-01	787	5
2017-02-01	653	5
2017-03-01	722	5
2017-04-01	814	5
2017-05-01	762	3
2017-06-01	2108	7
2017-07-01	1174	6
2018-07-01	219	1
2018-08-01	287	1
2018-09-01	290	1
2018-10-01	282	1
2018-11-01	2	1

Findings and interpretation:

The highest monthly tracking record count in the provided results occurs in June 2017, with 2,108 records. Seven distinct animal identifiers are represented in the tracking records for that month.

The lowest monthly count occurs in November 2018, with two records. One distinct animal identifier is represented in that month's output.

The results show that tracking records are not evenly distributed across the reported months. However, differences in monthly record counts do not, by themselves, explain changes in animal movement intensity. Factors such as tracking duration, device data generation, and dataset coverage were not separately examined in this query.

The output also contains no rows for the months between July 2017 and July 2018. The query alone does not establish why these months are absent from the results.

3.8. Analysis 8 — Is tracking intensity related to dive behavior?

Research question: Is tracking intensity related to dive behavior?

SQL query:

WITH tracking_summary AS (
    SELECT
        r.`animal-id` AS turtle_id,
        COUNT(DISTINCT t.`event-id`) AS tracking_record_count
    FROM
        `mediterranean-turtles.mediterranean_turtles.tracking_data` AS t
    JOIN
        `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
    ON
        t.`tag-local-identifier` = r.`tag-id`
    WHERE
        r.`animal-id` IS NOT NULL
    GROUP BY
        turtle_id
),
dive_summary AS (
    SELECT
        r.`animal-id` AS turtle_id,
        COUNT(*) AS dive_record_count,
        ROUND(AVG(d.DIVE_DUR)/60.0,2) AS avg_dive_duration_minutes
    FROM
        `mediterranean-turtles.mediterranean_turtles.dive_data` AS d
    JOIN
        `mediterranean-turtles.mediterranean_turtles.reference_data` AS r
    ON
        d.REF = r.`deployment-id`
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
    t.turtle_id = d.turtle_id
ORDER BY
    t.tracking_record_count DESC;


BigQuery output:

turtle_id	trackingrecordcount	diverecordcount	avgdiveduration_minutes
244	1896	353	25.68
242	1857	494	22.97
243	1456	345	29.84
SZN140	1080	1088	17.81
245	964	228	52.48
S248	884	313	11.56
241	715	135	38.60
S247	492	145	9.04
S250	469	133	9.10
S249	328	72	12.94
S246	130	18	11.94

Findings and interpretation:

The query combines tracking and diving summaries by animal identifier. This makes it possible to examine each animal's tracking record count, dive record count, and average dive duration in the same row.

For example, turtle 244 has 1,896 tracking records and 353 dive records, while SZN140 has 1,080 tracking records and 1,088 dive records.

Turtle 245 has the highest average dive duration in the table, at 52.48 minutes. The lowest average duration is 9.04 minutes for turtle S247.

These results show variation in tracking counts, dive counts, and average dive durations across the listed animals. However, the query does not calculate a correlation coefficient, regression model, or another statistical measure of association. Therefore, it does not establish a statistically verified relationship between tracking intensity and dive behavior.

Tracking records and dive records also represent different types of events, so their counts should not be expected to match directly.

3.9. Analysis 9 — How does satellite tracking data vary by turtle sex?

Research question: How does satellite tracking data vary by turtle sex?

SQL query:

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
    t.`tag-local-identifier` = r.`tag-id`
WHERE
    r.`animal-sex` IS NOT NULL
    AND t.`event-id` IS NOT NULL
GROUP BY
    animal_sex
ORDER BY
    tracking_record_count DESC;


BigQuery output:

animal_sex	trackingrecordcount	distinctturtlecount	avgerrorradius
u	7230	8	1986.32
f	2326	2	2122.86
m	715	1	3225.53

Findings and interpretation:

The u group contains 7,230 tracking records and eight distinct animals. The f group contains 2,326 records and two distinct animals, while the m group contains 715 records and one distinct animal.

The average argos:error-radius values are 1,986.32, 2,122.86, and 3,225.53, respectively.

The average error radius reported for the m group is higher than those of the other two groups. However, the number of animals represented in each group differs. In particular, the average for a group containing only one animal may be influenced by that individual's records.

These results provide a descriptive comparison. They are insufficient to conclude that sex causes differences in location uncertainty.

3.10. Analysis 10 — How does Argos location class relate to tracking volume and location uncertainty?

Research question: How does Argos location class relate to tracking volume and location uncertainty?

SQL query:

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
    t.`tag-local-identifier` = r.`tag-id`
WHERE
    t.`argos:lc` IS NOT NULL
    AND t.`event-id` IS NOT NULL
GROUP BY
    argos_location_class
ORDER BY
    tracking_record_count DESC;


BigQuery output:

argoslocationclass	trackingrecordcount	distinctturtlecount	avgerrorradius
B	6238	11	2841.44
A	1368	11	1288.77
3	1000	11	183.34
2	703	11	353.85
1	627	11	861.50
0	334	11	3402.38
1	1	1	8520.00

Findings and interpretation:

The B location class has the highest tracking record count in the query output, with 6,238 records. Its average error radius is 2,841.44.

Among the main groups, class 0 has the highest average error radius, at 3,402.38. Class 3 has a reported average error radius of 183.34.

The output contains two separate rows with the same 1 location-class label. The first contains 627 tracking records and 11 distinct animals, while the second contains one tracking record, one distinct animal, and an average error radius of 8,520.00.

The provided query groups records directly by the argos:lc field. The available information does not explain why two rows with apparently identical labels were returned. This discrepancy should not be corrected or attributed to a specific cause without further inspection of the underlying values and data types.

The observed differences between Argos location classes and error-radius averages are descriptive. This report does not independently verify the class definitions or assume a measurement unit for the error-radius field.

4. Summary of Overall Findings

The results of the ten SQL queries can be summarized as follows:

The reference_data table contains 11 distinct animal-id values.
The dive-duration analysis reports a minimum of 30 seconds, a maximum of 64,800 seconds, and an average of 1,345.54 seconds.
The life-stage query returns 11 distinct animals and 10,271 tracking records for the juvenile category.
Individual tracking record counts range from 130 to 1,896.
The sex-based dive analysis reports different average dive durations and average maximum dive depths across the groups.
The highest monthly tracking record count occurs in June 2017, with 2,108 records.
The individual tracking and dive summaries show variation in tracking counts, dive counts, and average dive durations across animals.
In the sex-based tracking analysis, the u group has the highest number of tracking records.
In the Argos location-class analysis, class B has the highest tracking record count, while average error-radius values vary across the reported classes.

These statements are descriptive summaries of the query outputs. They do not establish statistical significance, causality, or broader biological explanations.

5. Methodological Considerations and Limitations
5.1. Data coverage

The results depend on the scope, completeness, and quality of the tables used. For example, dive-duration calculations are limited to records with non-NULL DIVE_DUR values.

5.2. Identifiers and table joins

Different queries use different join fields. Tracking tables are joined using tag-id and tag-local-identifier, while dive and reference tables are joined using REF and deployment-id.

Join conditions can affect which records are included in the results. Therefore, counts from different queries should not be compared directly under the assumption that they measure the same population or data scope.

5.3. Tracking records and dive records

Tracking events and dive records represent different types of data. A difference between an animal's tracking record count and dive record count does not, by itself, indicate a data error.

5.4. Descriptive statistics

This study uses summary measures such as averages, minimums, maximums, and record counts. The provided queries do not perform statistical significance tests or causal analyses.

Consequently, the observed differences should not be described as statistically significant or causally explained without further analysis.

5.5. Sex and life-stage information

Sex codes and life-stage values are retained in the format provided by the source data. The meaning of the u code has not been independently verified.

The fact that the life-stage query returns only the juvenile category does not, by itself, prove that other life stages are absent from the source dataset.

5.6. Location uncertainty

Average values were calculated using the argos:error-radius field. However, the unit of this field and the aspects of location accuracy it represents have not been independently verified from the provided queries and outputs.

The duplicate 1 label in the Argos location-class output also requires additional data validation.

5.7. Scope of geographic analysis

The ten queries provided do not include results that calculate geographic extremes, actual space-use areas, or spatial movement routes. Therefore, this report does not present verified findings about geographic distribution or individual home ranges.

6. Conclusion

This project applies ten SQL analyses to satellite tracking and diving data of loggerhead sea turtles in the Mediterranean Sea using Google BigQuery.

The queries cover distinct animal identifiers, dive-duration summaries, tracking records grouped by individual and month, sex-based comparisons of diving measurements, and an examination of Argos location data.

The results show that tracking and diving records vary across animals, time periods, and categories in the dataset. However, most analyses are descriptive. The available outputs do not, by themselves, establish the causes or statistical significance of the observed differences.

The primary contribution of this project is to document the application of SQL data filtering, aggregation, table joins, and result interpretation to a real-world sea turtle tracking dataset. The scope of this report is limited to the queries and BigQuery outputs provided.

7. References

Hochscheid, S. (2020). Data from: Study "Satellite Tracking of Oceanic Loggerhead Turtles in the Mediterranean". Movebank Data Repository. https://doi.org/10.5441/001/1.1f1h87r8

Chimienti, M., Blasi, M. F., & Hochscheid, S. (2020). Movement patterns of large juvenile loggerhead turtles in the Mediterranean Sea: ontogenetic space use in a small ocean basin. Ecology and Evolution, 10(14), 6978–6992. https://doi.org/10.1002/ece3.6370

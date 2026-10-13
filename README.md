Mediterranean Turtle Tracking Analysis

SQL data analysis of Mediterranean loggerhead turtle tracking and diving behavior using Google BigQuery.

Project Overview

This project explores satellite tracking records and diving behavior of loggerhead sea turtles (Caretta caretta) in the Mediterranean Sea using SQL and Google BigQuery.

The analysis focuses on animal metadata, tracking activity, dive duration, dive depth, temporal patterns, and Argos location data. It also demonstrates how multiple tables can be joined to investigate tracking and diving records by animal identifier, sex, and life stage.

The project was developed to practice SQL data analysis using a real-world wildlife dataset.

Objectives
Count distinct turtle identifiers in the reference data.
Analyze minimum, maximum, and average dive durations.
Compare tracking activity across turtle life stages and individual animals.
Examine dive duration and maximum dive depth by sex.
Investigate monthly tracking activity.
Compare tracking record counts with dive behavior at the individual-animal level.
Explore tracking records by sex and Argos location class.
Practice SQL aggregation, filtering, common table expressions (CTEs), and table joins in BigQuery.
Tools and Technologies
Google BigQuery — SQL query execution and data analysis
SQL — Filtering, aggregation, joins, and summary statistics
GitHub — Project version control and documentation
Data Source

Hochscheid, S. (2020). Data from: Study "Satellite Tracking of Oceanic Loggerhead Turtles in the Mediterranean". Movebank Data Repository.

Dataset DOI: https://doi.org/10.5441/001/1.1f1h87r8

Related publication:

Chimienti, M., Blasi, M. F., & Hochscheid, S. (2020). Movement patterns of large juvenile loggerhead turtles in the Mediterranean Sea: ontogenetic space use in a small ocean basin. Ecology and Evolution, 10(14), 6978–6992.

https://doi.org/10.1002/ece3.6370

The dataset is distributed under the Creative Commons Zero (CC0 1.0) license. Attribution to the original researchers and the Movebank Data Repository is retained here.

BigQuery Dataset
Property	Value
Project ID	mediterranean-turtles
Dataset ID	mediterranean_turtles
Tables Used
Table	Description
reference_data	Animal, tag, and deployment metadata
tracking_data	Satellite tracking and location records
dive_data	Dive duration, depth, and related dive records

The analyses join these tables using the identifiers present in the source data, including tag-id, tag-local-identifier, deployment-id, and REF.

Research Questions and Results

The following results were obtained from the SQL queries executed in BigQuery.

1. How many distinct turtles were tracked?

The reference table contains 11 distinct animal-id values.

This count represents distinct identifiers in the queried metadata and does not independently verify the biological identity of every animal.

2. What are the shortest and longest dive durations?
Metric	Seconds	Minutes
Shortest dive	30	0.50
Longest dive	64,800	1,080.00

The longest recorded duration in the query output is equivalent to 18 hours. The calculation excludes records where DIVE_DUR is NULL.

3. What is the average dive duration?

The average duration of records with a non-NULL DIVE_DUR value is:

1,345.54 seconds
22.43 minutes
4. How does satellite tracking activity vary by turtle life stage?
Life stage	Distinct turtles	Tracking records
juvenile	11	10,271

The query groups tracking records by life stage using a join between reference_data and tracking_data. The output contains one category: juvenile.

5. How many tracking records does each turtle have?
Turtle ID	Sex code	Tracking records
244	u	1,896
242	f	1,857
243	u	1,456
SZN140	u	1,080
245	u	964
S248	u	884
241	m	715
S247	u	492
S250	f	469
S249	u	328
S246	u	130

The counts are based on distinct tracking event identifiers after joining tracking records to reference metadata. Turtle IDs and sex codes are retained as returned by the query.

6. Does dive behavior differ by sex?
Sex code	Dive records	Average duration (minutes)	Average maximum dive depth
m	135	38.60	20.11
u	2,562	22.16	31.29
f	627	20.03	21.17

The query compares dive records by the animal-sex field. It excludes records with NULL dive duration and records with NULL sex metadata.

These values describe the returned group averages; they do not establish that sex causes differences in diving behavior.

7. How are turtle tracking records distributed by month?
Month	Tracking records	Distinct turtles
2016-10	224	1
2016-11	885	5
2016-12	1,062	5
2017-01	787	5
2017-02	653	5
2017-03	722	5
2017-04	814	5
2017-05	762	3
2017-06	2,108	7
2017-07	1,174	6
2018-07	219	1
2018-08	287	1
2018-09	290	1
2018-10	282	1
2018-11	2	1

June 2017 has the highest monthly tracking record count in the query output, with 2,108 records. The results also show that the returned records span October 2016 through November 2018, with no rows for the intervening months that have no matching records in this query.

8. Is tracking intensity related to dive behavior?

The query combines tracking and dive summaries by turtle identifier.

Turtle ID	Tracking records	Dive records	Average dive duration (minutes)
244	1,896	353	25.68
242	1,857	494	22.97
243	1,456	345	29.84
SZN140	1,080	1,088	17.81
245	964	228	52.48
S248	884	313	11.56
241	715	135	38.60
S247	492	145	9.04
S250	469	133	9.10
S249	328	72	12.94
S246	130	18	11.94

The results show variation in tracking record counts, dive record counts, and average dive durations across the 11 listed turtle identifiers.

This query provides a descriptive comparison. It does not calculate a statistical correlation or establish a relationship between tracking intensity and dive behavior.

9. How does satellite tracking data vary by turtle sex?
Sex code	Tracking records	Distinct turtles	Average error radius
u	7,230	8	1,986.32
f	2,326	2	2,122.86
m	715	1	3,225.53

The query groups tracking events by sex and calculates the average value of argos:error-radius. The number of distinct turtles represented in each group differs, so these results should be interpreted alongside the group sizes.

10. How does Argos location class relate to tracking volume and location uncertainty?
Argos location class	Tracking records	Distinct turtles	Average error radius
B	6,238	11	2,841.44
A	1,368	11	1,288.77
3	1,000	11	183.34
2	703	11	353.85
1	627	11	861.50
0	334	11	3,402.38
1	1	Not separately reported in the supplied output	8,520.00

Class B has the highest tracking record count in the returned output, at 6,238 records. Class 0 has the highest average error radius among the main groups listed, at 3,402.38.

The supplied query output also contains a separate row labeled 1 with one record and an average error radius of 8,520.00. This row is retained as returned; its distinction from the other 1 row has not been independently verified.

SQL Queries

SQL scripts are intended to be organized in the sql/ directory, with one script per research question.

Suggested filenames corresponding to the analyses documented above:

Filename	Analysis
01_distinct_animals.sql	Count distinct animal identifiers
02_dive_duration_extremes.sql	Minimum and maximum dive duration
03_average_dive_duration.sql	Average dive duration
04_tracking_by_life_stage.sql	Tracking activity by life stage
05_tracking_records_per_turtle.sql	Tracking counts by turtle
06_dive_behavior_by_sex.sql	Dive duration and depth by sex
07_tracking_by_month.sql	Monthly tracking activity
08_tracking_intensity_and_dive_behavior.sql	Tracking and dive summaries by turtle
09_tracking_by_sex.sql	Tracking activity and error radius by sex
10_tracking_by_argos_location_class.sql	Tracking activity by Argos location class

These filenames are a proposed organization for the documented analyses. They do not imply that files with these exact names have already been created.

Methodology

The analyses use the following SQL techniques:

COUNT(DISTINCT ...) to count distinct animals and tracking events.
MIN(), MAX(), and AVG() to summarize dive duration, depth, and location error radius.
ROUND() to format numerical results.
COALESCE() to provide a fallback category for missing life-stage values.
LEFT JOIN and JOIN to combine tracking, dive, and reference metadata.
GROUP BY and ORDER BY to aggregate and rank results.
Common table expressions (WITH) to summarize tracking and dive records separately before joining them.

The queries use different filters depending on the research question. For example, dive-duration calculations exclude NULL duration values, while tracking analyses generally count distinct event identifiers.

Limitations
Results depend on the coverage, completeness, and quality of the source dataset.
Distinct animal identifiers do not necessarily equal the number of independently verified animals.
Dive-duration averages describe records with non-NULL duration values and may not represent all possible dives.
Tracking record counts depend on the event identifiers and join conditions used in each query.
Tracking counts and dive counts are different measures and should not be treated as directly equivalent.
Group comparisons by sex are based on the records and identifiers returned by the queries. The u sex code is preserved as supplied; its precise meaning is not inferred here.
Average error radius is a descriptive measure from the argos:error-radius field. It is not independently validated as a complete measure of location accuracy.
Argos location-class results are reproduced as returned by BigQuery. The duplicate 1 labels in the supplied output require further validation before making class-specific conclusions.
The monthly query reports months with matching tracking records; absent months in the output do not independently explain why no records were returned.
The analyses are primarily descriptive. They do not establish causation, and the tracking-versus-diving comparison does not calculate a formal statistical association.
Geographic range, spatial distribution, and dive-depth extremes have not been documented here because corresponding query outputs were not included in the supplied analyses.
Acknowledgments

Thanks to the researchers who collected and published the loggerhead turtle tracking data, and to the Movebank Data Repository for making the dataset available.

License and Attribution

The source dataset is distributed under the Creative Commons Zero (CC0 1.0) license. The original data source and related scientific publication are cited above.

This repository documents SQL analyses performed on the dataset and retains attribution to the original researchers and repository.

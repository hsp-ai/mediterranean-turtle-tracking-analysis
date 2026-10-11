# mediterranean-turtle-tracking-analysis
SQL data analysis of Mediterranean loggerhead turtle tracking data using Google BigQuery.

Mediterranean Loggerhead Turtle Tracking Analysis
Project Overview

This project explores satellite tracking and diving behavior data of loggerhead sea turtles (Caretta caretta) in the Mediterranean Sea using SQL and Google BigQuery.

The project is designed to practice data analysis, data aggregation, filtering, data quality checks, table joins, and basic geographic analysis.

Objectives
Explore dive duration and depth patterns.
Identify the longest and deepest recorded dives.
Compare dive records across tracking codes and dates.
Explore the geographic distribution of tracking locations.
Practice SQL queries using a real-world wildlife dataset.
Tools and Technologies
Google BigQuery
SQL
GitHub
Data Source

Hochscheid, S. (2020). Data from: Study "Satellite Tracking of Oceanic Loggerhead Turtles in the Mediterranean". Movebank Data Repository.

Dataset DOI: https://doi.org/10.5441/001/1.1f1h87r8

Related publication:

Chimienti, M., Blasi, M. F., & Hochscheid, S. (2020). Movement patterns of large juvenile loggerhead turtles in the Mediterranean Sea: ontogenetic space use in a small ocean basin. Ecology and Evolution, 10(14), 6978–6992.

https://doi.org/10.1002/ece3.6370

The dataset is distributed under the Creative Commons Zero (CC0 1.0) license. Appropriate attribution to the data creators and repository is retained here.

BigQuery Dataset

Project ID: mediterranean-turtles

Dataset ID: mediterranean_turtles

Table	Description
dive_data	Dive durations, depths, dates, and approximate coordinates
tracking_data	Satellite tracking and location records
reference_data	Animal, tag, and deployment metadata
Research Questions
How many distinct animals are recorded?
What are the shortest and longest dive durations?
What is the average dive duration?
What are the ten deepest dives?
Which tracking codes have the most dive records?
How are dive records distributed across dates?
Is there an association between dive duration and depth?
What are the geographic extremes of recorded locations?
Can tracking records be joined with reference metadata?
How do the geographic ranges of tracked animals compare?
SQL Queries

SQL scripts are organized in the sql/ directory, with one script per research question.

The first query, 01_distinct_animals.sql, counts distinct animal identifiers in the reference table.

Additional queries and their findings will be added as the analysis progresses.

Results and Findings

Results will be documented after the queries have been executed and validated in BigQuery.

Limitations
Results depend on the coverage and quality of the source dataset.
The number of distinct identifiers may not always equal the number of independently verified animals.
Coordinate ranges do not directly measure the true geographic area used by an animal.
Associations between dive duration and depth do not establish causation.
Acknowledgments

Thanks to the researchers who collected and published the turtle tracking data through the Movebank Data Repository.

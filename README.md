# European Football Database Analysis

A SQL portfolio project using SQLite to explore European football
data across multiple leagues and seasons.

The analysis examines team results, home and away performance,
league scoring patterns, and changes in player ratings over time.

## Dataset

- Database: European Football Database
- Format: SQLite
- Main tables used: League, Match, Team, Player, Player_Attributes
- Original source: [Add the original dataset link]
- Coverage: [Add the leagues and seasons covered by the dataset]

The database is not included in this repository.
Download it from the original source before running the queries.

## Project Objectives

- Explore the structure and coverage of a relational football database.
- Translate analytical questions into SQL queries.
- Combine match, team, league and player data.
- Apply aggregations, joins, subqueries, CTEs and window functions.
- Summarise patterns in team performance and player ratings.

## Analysis Overview

The file `football_analysis.sql` contains 15 queries organised
into three sections.

### 1. Exploratory Analysis — Queries 1–5

- Data coverage by league and season.
- Team and player counts.
- Basic distributions and data quality checks.

### 2. Team and Match Performance — Queries 6–10

- Home and away performance.
- Seasonal team rankings.
- Goal patterns and match-level metrics.

### 3. Player Ratings and Trends Over Time — Queries 11–15

- Player attribute profiles by rating tier.
- Overall and monthly team performance.
- Changes in player ratings over time.
- League scoring patterns by season.

## SQL Techniques

- Joins
- GROUP BY and aggregate functions
- Subqueries
- Common Table Expressions (CTEs)
- Window functions

## Repository Contents

| File | Description |
|------|-------------|
| `football_analysis.sql` | The 15 analytical queries, with explanatory comments |

## How to Run

1. Download the SQLite database from the original dataset source.
2. Open the database in DB Browser for SQLite.
3. Open the `Execute SQL` tab.
4. Load `football_analysis.sql`, or copy an individual query into the editor.
5. Execute the queries individually and inspect the results.

The SQL script contains the analysis queries.
The dataset must be downloaded separately.

## Selected Findings

[Add 3–5 findings supported by the actual query results.]

For each finding, include:
- The relevant query number.
- The result, including the league, team or season where applicable.
- A brief explanation of what the result shows.

## Limitations

[Add limitations identified while working with the data.]

Consider discussing:
- Missing values or incomplete coverage.
- How team rankings were calculated.
-

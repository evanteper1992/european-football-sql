# European Football Database Analysis

A SQL portfolio project exploring a comprehensive European football database using SQLite. The analysis covers player performance, team results, league scoring patterns, and temporal trends across multiple seasons.

## Dataset

- **Database:** European Football (SQLite)
- **Main tables used:** League, Match, Team, Player, Player_Attributes
- **Scope:** Multiple European leagues and seasons with detailed match events and player attributes.

## Objectives

This project demonstrates the ability to:

- Translate business questions into efficient SQL queries.
- Use advanced SQL features: CTEs, window functions, aggregations, complex joins, and subqueries.
- Perform end-to-end data analysis: from raw tables to actionable insights.

## Structure of the Analysis

The script `football_analysis.sql` contains 15 analytical queries grouped into three thematic blocks:

### 1. Foundational Queries (1–5)

Basic exploratory analysis of leagues, seasons, teams, and players:
- Data coverage by league and season.
- Team and player counts.
- Basic distributions and data quality checks.

### 2. Team and Match Performance (6–10)

Analysis of match outcomes and team performance:
- Home vs away advantage.
- Seasonal team rankings.
- Goal patterns and match-level metrics.

### 3. Advanced Player and Temporal Analytics (11–15)

Deeper analytics on players and time-based trends:
- Player attribute profiles by rating tier.
- All-time and monthly team performance.
- Player rating evolution over time.
- League scoring patterns by season.

## Files in This Repository

- `football_analysis.sql`  
  All 15 queries with comments explaining the business question, main logic, and usefulness of each result.

- `european_football_analysis.sqbpro`  
  DB Browser for SQLite project file. Opening this file restores the database connection and query tabs.

## How to Run

1. Install [DB Browser for SQLite](https://sqlitebrowser.org/).
2. Open `european_football_analysis.sqbpro` in DB Browser.
3. Ensure the database file (`database.sqlite` or equivalent) is correctly linked.
4. Open `football_analysis.sql` in the SQL editor tab.
5. Run individual queries or the entire script as needed.

## Notes

- Player identifiers (`player_api_id`) are used instead of names to maintain anonymization.
- Queries include filters (e.g., minimum matches played) to ensure statistically meaningful results.
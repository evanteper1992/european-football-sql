# European Football Database Analysis

A SQL portfolio project using SQLite to explore European football
data across multiple leagues and seasons.

The analysis examines match outcomes, team performance, player
ratings and league scoring patterns through 15 analytical queries.

## Dataset

- Database: European Football Database
- Format: SQLite
- Tables used: Country, League, Match, Team, Player and Player_Attributes
- Source: [European Soccer Database — Hugo Mathien, Kaggle](https://www.kaggle.com/datasets/hugomathien/soccer)

The database is not included in this repository and must be
downloaded separately from the original source.

## Objectives

- Explore league and season coverage.
- Compare match outcomes and home-win percentages.
- Calculate team standings and performance metrics.
- Examine player ratings and attribute profiles.
- Compare scoring patterns across leagues and seasons.

## Tools and SQL Techniques

- SQLite
- DB Browser for SQLite
- Joins
- Aggregations and GROUP BY
- Conditional expressions with CASE
- Common Table Expressions (CTEs)
- ROW_NUMBER window function
- UNION ALL
- Date-based analysis with strftime

## Analysis Overview

### Queries 1–4: League Coverage and Match Outcomes

- Match counts by league and season.
- Total goals and average goals per match by league.
- Home-win percentages.
- Distribution of home wins, draws and away wins.

### Queries 5–8: Team Standings and Seasonal Performance

- Calculated Premier League standings for 2015/2016.
- Highest-ranked team by calculated points per league-season.
- Team-seasons with the highest total points.
- Leicester City's results across the available seasons.

### Queries 9–11: Player Ratings and Attribute Profiles

- Highest recorded player rating observations.
- Top 20 players by peak overall rating.
- Average player attributes by peak-rating tier,
  using one selected record per player.

### Queries 12–13: Overall and Monthly Team Performance

- Team performance across the available seasons.
- Monthly points, goals and points per match.

### Query 14: Changes in Recorded Player Ratings

- Comparison of each player's average overall rating in their
  first and last available calendar years.
- Players with records in only one year are excluded.

### Query 15: League Scoring Patterns

- Average goals per match by league and season.
- Results restricted to league-seasons with at least 50 matches.

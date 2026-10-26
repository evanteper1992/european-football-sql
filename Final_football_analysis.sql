-- European Football Database Analysis
-- Portfolio SQL Script
-- Database: European Football (SQLite)
-- Author: <το όνομά σου>
-- Date: 2026

-- This script contains 15 analytical queries demonstrating:
-- - CTEs (WITH clauses)
-- - Window functions (ROW_NUMBER, LAG)
-- - Aggregations and GROUP BY
-- - Complex joins and subqueries
-- - Business-focused football analytics

-- Each query is preceded by a comment block explaining:
-- - the business question
-- - the main logic
-- - why the result is useful

-- Query 1: Basic league and season overview
-- Business question: Which leagues and seasons are present in the dataset?
-- Logic: Simple aggregation counting matches per league and season.
-- Usefulness: Shows data coverage and helps choose focus areas for deeper analysis.

SELECT
    c.name AS country,
    l.name AS league,
    COUNT(m.id) AS total_matches
FROM "Match" AS m
JOIN League AS l
    ON m.league_id = l.id
JOIN Country AS c
    ON m.country_id = c.id
GROUP BY
    c.name,
    l.name
ORDER BY
    total_matches DESC;

SELECT
    c.name AS country,
    l.name AS league,
    COUNT(m.id) AS total_matches
FROM "Match" AS m
JOIN League AS l
    ON m.league_id = l.id
JOIN Country AS c
    ON m.country_id = c.id
GROUP BY
    c.name,
    l.name
ORDER BY
    total_matches DESC;

-- Query 2: Total goals and average goals per match
-- Business question: What is the overall scoring level in the dataset?
-- Logic: Sum all goals (home + away) and compute average per match.
-- Usefulness: Provides a baseline for comparing scoring across leagues and seasons.

SELECT
    c.name AS country,
    l.name AS league,
    COUNT(m.id) AS total_matches,
    SUM(m.home_team_goal + m.away_team_goal) AS total_goals,
    ROUND(
        AVG(m.home_team_goal + m.away_team_goal),
        2
    ) AS avg_goals_per_match
FROM "Match" AS m
JOIN League AS l
    ON m.league_id = l.id
JOIN Country AS c
    ON m.country_id = c.id
GROUP BY
    c.name,
    l.name
ORDER BY
    avg_goals_per_match DESC;

-- Query 3: Home advantage
-- Business question: Is there a home advantage in match outcomes?
-- Logic: Classify each match as home win / draw / away win and compute counts and percentages.
-- Usefulness: Quantifies the extent of home advantage, a key insight in football analytics.

SELECT
    c.name AS country,
    l.name AS league,
    COUNT(m.id) AS total_matches,
    SUM(
        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 1
            ELSE 0
        END
    ) AS home_wins,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN m.home_team_goal > m.away_team_goal THEN 1
                ELSE 0
            END
        ) / COUNT(m.id),
        2
    ) AS home_win_percentage
FROM "Match" AS m
JOIN League AS l
    ON m.league_id = l.id
JOIN Country AS c
    ON m.country_id = c.id
GROUP BY
    c.name,
    l.name
ORDER BY
    home_win_percentage DESC;

-- Query 4: Home wins, draws and away wins
-- Business question: What is the distribution of match outcomes (home/draw/away)?
-- Logic: Count matches by outcome type and calculate proportions.
-- Usefulness: Shows the balance between home dominance, draws, and away wins.

SELECT
    c.name AS country,
    l.name AS league,
    COUNT(m.id) AS total_matches,

    SUM(
        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 1
            ELSE 0
        END
    ) AS home_wins,

    SUM(
        CASE
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0
        END
    ) AS draws,

    SUM(
        CASE
            WHEN m.home_team_goal < m.away_team_goal THEN 1
            ELSE 0
        END
    ) AS away_wins,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN m.home_team_goal > m.away_team_goal THEN 1
                ELSE 0
            END
        ) / COUNT(m.id),
        2
    ) AS home_win_percentage,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN m.home_team_goal = m.away_team_goal THEN 1
                ELSE 0
            END
        ) / COUNT(m.id),
        2
    ) AS draw_percentage,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN m.home_team_goal < m.away_team_goal THEN 1
                ELSE 0
            END
        ) / COUNT(m.id),
        2
    ) AS away_win_percentage

FROM "Match" AS m
JOIN League AS l
    ON m.league_id = l.id
JOIN Country AS c
    ON m.country_id = c.id

GROUP BY
    c.name,
    l.name

ORDER BY
    home_win_percentage DESC;

-- Query 5: Premier League standings, 2015/2016
-- Business question: What were the final standings in the Premier League 2015/2016 season?
-- Logic: Compute points per team (3/1/0) for that league-season and order by points.
-- Usefulness: Recreates the historic league table, including Leicester’s title-winning season.

WITH team_match_results AS (

    -- Home-team perspective
    SELECT
        m.season,
        m.league_id,
        m.home_team_api_id AS team_id,
        m.home_team_goal AS goals_for,
        m.away_team_goal AS goals_against,

        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m

    UNION ALL

    -- Away-team perspective
    SELECT
        m.season,
        m.league_id,
        m.away_team_api_id AS team_id,
        m.away_team_goal AS goals_for,
        m.home_team_goal AS goals_against,

        CASE
            WHEN m.away_team_goal > m.home_team_goal THEN 3
            WHEN m.away_team_goal = m.home_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m
),

team_standings AS (
    SELECT
        season,
        league_id,
        team_id,
        COUNT(*) AS matches_played,

        SUM(
            CASE
                WHEN goals_for > goals_against THEN 1
                ELSE 0
            END
        ) AS wins,

        SUM(
            CASE
                WHEN goals_for = goals_against THEN 1
                ELSE 0
            END
        ) AS draws,

        SUM(
            CASE
                WHEN goals_for < goals_against THEN 1
                ELSE 0
            END
        ) AS losses,

        SUM(goals_for) AS goals_for,
        SUM(goals_against) AS goals_against,
        SUM(goals_for) - SUM(goals_against) AS goal_difference,
        SUM(points) AS points

    FROM team_match_results
    GROUP BY
        season,
        league_id,
        team_id
)

SELECT
    ts.season,
    l.name AS league,
    t.team_long_name AS team,
    ts.matches_played,
    ts.wins,
    ts.draws,
    ts.losses,
    ts.goals_for,
    ts.goals_against,
    ts.goal_difference,
    ts.points

FROM team_standings AS ts
JOIN Team AS t
    ON ts.team_id = t.team_api_id
JOIN League AS l
    ON ts.league_id = l.id

WHERE
    ts.season = '2015/2016'
    AND l.name = 'England Premier League'

ORDER BY
    ts.points DESC,
    ts.goal_difference DESC,
    ts.goals_for DESC;

-- Query 6: Champions by league and season
-- Business question: Which team won each league-season (highest points)?
-- Logic: For each league and season, identify the team with the most points.
-- Usefulness: Summarizes champions over time and highlights dominant clubs.

WITH team_match_results AS (

    -- Home-team perspective
    SELECT
        m.season,
        m.league_id,
        m.home_team_api_id AS team_id,
        m.home_team_goal AS goals_for,
        m.away_team_goal AS goals_against,

        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m

    UNION ALL

    -- Away-team perspective
    SELECT
        m.season,
        m.league_id,
        m.away_team_api_id AS team_id,
        m.away_team_goal AS goals_for,
        m.home_team_goal AS goals_against,

        CASE
            WHEN m.away_team_goal > m.home_team_goal THEN 3
            WHEN m.away_team_goal = m.home_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m
),

team_standings AS (
    SELECT
        season,
        league_id,
        team_id,
        COUNT(*) AS matches_played,
        SUM(goals_for) AS goals_for,
        SUM(goals_against) AS goals_against,
        SUM(goals_for) - SUM(goals_against) AS goal_difference,
        SUM(points) AS points

    FROM team_match_results
    GROUP BY
        season,
        league_id,
        team_id
),

ranked_standings AS (
    SELECT
        season,
        league_id,
        team_id,
        matches_played,
        goals_for,
        goals_against,
        goal_difference,
        points,

        ROW_NUMBER() OVER (
            PARTITION BY season, league_id
            ORDER BY
                points DESC,
                goal_difference DESC,
                goals_for DESC
        ) AS league_position

    FROM team_standings
)

SELECT
    rs.season,
    c.name AS country,
    l.name AS league,
    t.team_long_name AS champion,
    rs.matches_played,
    rs.points,
    rs.goal_difference

FROM ranked_standings AS rs
JOIN Team AS t
    ON rs.team_id = t.team_api_id
JOIN League AS l
    ON rs.league_id = l.id
JOIN Country AS c
    ON l.country_id = c.id

WHERE
    rs.league_position = 1

ORDER BY
    rs.season,
    c.name;

-- Query 7: Teams with the best season performance
-- Business question: Which teams had the strongest single-season records?
-- Logic: Compute points, goal difference, and matches played per team-season, then rank.
-- Usefulness: Identifies exceptional seasonal performances across all leagues.

WITH team_match_results AS (

    SELECT
        m.season,
        m.league_id,
        m.home_team_api_id AS team_id,
        m.home_team_goal AS goals_for,
        m.away_team_goal AS goals_against,

        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m

    UNION ALL

    SELECT
        m.season,
        m.league_id,
        m.away_team_api_id AS team_id,
        m.away_team_goal AS goals_for,
        m.home_team_goal AS goals_against,

        CASE
            WHEN m.away_team_goal > m.home_team_goal THEN 3
            WHEN m.away_team_goal = m.home_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m
),

team_standings AS (
    SELECT
        season,
        league_id,
        team_id,
        COUNT(*) AS matches_played,
        SUM(goals_for) AS goals_for,
        SUM(goals_against) AS goals_against,
        SUM(goals_for) - SUM(goals_against) AS goal_difference,
        SUM(points) AS points

    FROM team_match_results
    GROUP BY
        season,
        league_id,
        team_id
)

SELECT
    ts.season,
    c.name AS country,
    l.name AS league,
    t.team_long_name AS team,
    ts.matches_played,
    ts.points,
    ts.goals_for,
    ts.goals_against,
    ts.goal_difference

FROM team_standings AS ts
JOIN Team AS t
    ON ts.team_id = t.team_api_id
JOIN League AS l
    ON ts.league_id = l.id
JOIN Country AS c
    ON l.country_id = c.id

ORDER BY
    ts.points DESC,
    ts.goal_difference DESC,
    ts.goals_for DESC

LIMIT 10;

-- Query 8: Leicester City performance by season
-- Business question: How did Leicester City perform across different seasons?
-- Logic: Filter matches for Leicester, aggregate points and goals by season.
-- Usefulness: Tracks Leicester’s trajectory, including their title-winning campaign.

WITH team_match_results AS (

    SELECT
        m.season,
        m.league_id,
        m.home_team_api_id AS team_id,
        m.home_team_goal AS goals_for,
        m.away_team_goal AS goals_against,

        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m

    UNION ALL

    SELECT
        m.season,
        m.league_id,
        m.away_team_api_id AS team_id,
        m.away_team_goal AS goals_for,
        m.home_team_goal AS goals_against,

        CASE
            WHEN m.away_team_goal > m.home_team_goal THEN 3
            WHEN m.away_team_goal = m.home_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m
),

team_standings AS (
    SELECT
        season,
        league_id,
        team_id,
        COUNT(*) AS matches_played,
        SUM(goals_for) AS goals_for,
        SUM(goals_against) AS goals_against,
        SUM(goals_for) - SUM(goals_against) AS goal_difference,
        SUM(points) AS points

    FROM team_match_results
    GROUP BY
        season,
        league_id,
        team_id
)

SELECT
    ts.season,
    l.name AS league,
    t.team_long_name AS team,
    ts.matches_played,
    ts.points,
    ts.goals_for,
    ts.goals_against,
    ts.goal_difference

FROM team_standings AS ts
JOIN Team AS t
    ON ts.team_id = t.team_api_id
JOIN League AS l
    ON ts.league_id = l.id

WHERE
    t.team_long_name = 'Leicester City'

ORDER BY
    ts.season;

-- Query 9: Players with the highest overall rating
-- Business question: Which players have the highest recorded overall ratings?
-- Logic: Select top players by overall_rating from Player_Attributes.
-- Usefulness: Highlights elite players according to the rating system.

SELECT
    p.player_name,
    p.birthday,
    pa.date AS attribute_date,
    pa.overall_rating,
    pa.potential,
    pa.preferred_foot,
    pa.attacking_work_rate,
    pa.defensive_work_rate,
    pa.finishing,
    pa.short_passing,
    pa.dribbling,
    pa.sprint_speed

FROM Player_Attributes AS pa
JOIN Player AS p
    ON pa.player_api_id = p.player_api_id

WHERE
    pa.overall_rating IS NOT NULL

ORDER BY
    pa.overall_rating DESC,
    pa.potential DESC

LIMIT 20;

-- Query 10: Top 20 unique players by peak overall rating
-- Business question: Which players reached the highest peak overall rating?
-- Logic: For each player, take MAX(overall_rating), then rank and limit to 20.
-- Usefulness: Focuses on peak ability rather than single observations.

WITH player_peak_ratings AS (
    SELECT
        player_api_id,
        MAX(overall_rating) AS peak_overall_rating,
        MAX(potential) AS peak_potential
    FROM Player_Attributes
    WHERE overall_rating IS NOT NULL
    GROUP BY
        player_api_id
)

SELECT
    p.player_name,
    p.birthday,
    p.height,
    p.weight,
    pr.peak_overall_rating,
    pr.peak_potential

FROM player_peak_ratings AS pr
JOIN Player AS p
    ON pr.player_api_id = p.player_api_id

ORDER BY
    pr.peak_overall_rating DESC,
    pr.peak_potential DESC,
    p.player_name ASC

LIMIT 20;

-- Query 11: Player attribute profiles by peak overall-rating tier
-- Business question: How do player attributes differ by peak rating tier?
-- Logic: Group players into tiers by peak overall_rating and average key attributes per tier.
-- Usefulness: Shows what distinguishes elite players from developing ones in terms of skills.

WITH player_peak_rating AS (
    SELECT
        player_api_id,
        MAX(overall_rating) AS peak_overall_rating
    FROM Player_Attributes
    WHERE overall_rating IS NOT NULL
    GROUP BY
        player_api_id
),

player_peak_attributes AS (
    SELECT
        pa.player_api_id,
        pr.peak_overall_rating,
        pa.finishing,
        pa.short_passing,
        pa.dribbling,
        pa.sprint_speed
    FROM Player_Attributes AS pa
    JOIN player_peak_rating AS pr
        ON pa.player_api_id = pr.player_api_id
        AND pa.overall_rating = pr.peak_overall_rating
),

player_tiers AS (
    SELECT
        player_api_id,
        peak_overall_rating,
        finishing,
        short_passing,
        dribbling,
        sprint_speed,

        CASE
            WHEN peak_overall_rating >= 85 THEN 'Elite (85+)'
            WHEN peak_overall_rating >= 80 THEN 'High rated (80-84)'
            WHEN peak_overall_rating >= 75 THEN 'Established (75-79)'
            ELSE 'Developing (<75)'
        END AS rating_tier

    FROM player_peak_attributes
)

SELECT
    rating_tier,
    COUNT(DISTINCT player_api_id) AS player_count,
    ROUND(AVG(peak_overall_rating), 1) AS avg_peak_overall,
    ROUND(AVG(finishing), 1) AS avg_finishing,
    ROUND(AVG(short_passing), 1) AS avg_short_passing,
    ROUND(AVG(dribbling), 1) AS avg_dribbling,
    ROUND(AVG(sprint_speed), 1) AS avg_sprint_speed

FROM player_tiers

GROUP BY
    rating_tier

ORDER BY
    CASE rating_tier
        WHEN 'Elite (85+)' THEN 1
        WHEN 'High rated (80-84)' THEN 2
        WHEN 'Established (75-79)' THEN 3
        WHEN 'Developing (<75)' THEN 4
    END;

-- Query 12: Total team performances
-- Business question: Which teams have the best overall record in the dataset?
-- Logic: Aggregate wins, draws, losses, goals, and points per team across all seasons.
-- Usefulness: Identifies historically strong clubs regardless of league or season.

WITH team_match_results AS (

    SELECT
        m.home_team_api_id AS team_id,
        m.home_team_goal AS goals_for,
        m.away_team_goal AS goals_against,

        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m

    UNION ALL

    SELECT
        m.away_team_api_id AS team_id,
        m.away_team_goal AS goals_for,
        m.home_team_goal AS goals_against,

        CASE
            WHEN m.away_team_goal > m.home_team_goal THEN 3
            WHEN m.away_team_goal = m.home_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m
),

team_all_time_performance AS (
    SELECT
        team_id,
        COUNT(*) AS matches_played,

        SUM(
            CASE
                WHEN goals_for > goals_against THEN 1
                ELSE 0
            END
        ) AS wins,

        SUM(
            CASE
                WHEN goals_for = goals_against THEN 1
                ELSE 0
            END
        ) AS draws,

        SUM(
            CASE
                WHEN goals_for < goals_against THEN 1
                ELSE 0
            END
        ) AS losses,

        SUM(goals_for) AS goals_for,
        SUM(goals_against) AS goals_against,
        SUM(goals_for) - SUM(goals_against) AS goal_difference,
        SUM(points) AS total_points,

        ROUND(
            1.0 * SUM(points) / COUNT(*),
            2
        ) AS points_per_match

    FROM team_match_results
    GROUP BY
        team_id
)

SELECT
    t.team_long_name AS team,
    tap.matches_played,
    tap.wins,
    tap.draws,
    tap.losses,
    tap.goals_for,
    tap.goals_against,
    tap.goal_difference,
    tap.total_points,
    tap.points_per_match

FROM team_all_time_performance AS tap
JOIN Team AS t
    ON tap.team_id = t.team_api_id

WHERE
    tap.matches_played >= 100

ORDER BY
    tap.points_per_match DESC,
    tap.goal_difference DESC,
    tap.total_points DESC

LIMIT 20;

-- Query 13: Monthly team performances
-- Business question: How does team performance vary by month within seasons?
-- Logic: Group match results by season, month, and team; compute points and goals.
-- Usefulness: Reveals form trends, hot/cold streaks, and seasonal patterns.

WITH team_monthly_results AS (

    SELECT
        m.season,
        strftime('%Y-%m', m.date) AS match_month,
        m.home_team_api_id AS team_id,
        m.home_team_goal AS goals_for,
        m.away_team_goal AS goals_against,

        CASE
            WHEN m.home_team_goal > m.away_team_goal THEN 3
            WHEN m.home_team_goal = m.away_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m

    UNION ALL

    SELECT
        m.season,
        strftime('%Y-%m', m.date) AS match_month,
        m.away_team_api_id AS team_id,
        m.away_team_goal AS goals_for,
        m.home_team_goal AS goals_against,

        CASE
            WHEN m.away_team_goal > m.home_team_goal THEN 3
            WHEN m.away_team_goal = m.home_team_goal THEN 1
            ELSE 0
        END AS points

    FROM "Match" AS m
),

team_monthly_performance AS (
    SELECT
        season,
        match_month,
        team_id,

        COUNT(*) AS matches_played,
        SUM(points) AS total_points,
        SUM(goals_for) AS goals_for,
        SUM(goals_against) AS goals_against,
        SUM(goals_for) - SUM(goals_against) AS goal_difference,

        ROUND(
            1.0 * SUM(points) / COUNT(*),
            2
        ) AS points_per_match

    FROM team_monthly_results
    GROUP BY
        season,
        match_month,
        team_id
)

SELECT
    t.team_long_name AS team,
    tmp.season,
    tmp.match_month,
    tmp.matches_played,
    tmp.total_points,
    tmp.goals_for,
    tmp.goals_against,
    tmp.goal_difference,
    tmp.points_per_match

FROM team_monthly_performance AS tmp
JOIN Team AS t
    ON tmp.team_id = t.team_api_id

WHERE
    tmp.matches_played >= 3

ORDER BY
    tmp.season,
    tmp.match_month,
    tmp.points_per_match DESC,
    tmp.goal_difference DESC

LIMIT 50;

-- Query 14: Players with biggest rating improvement over time
-- Business question: Which players improved the most in overall rating?
-- Logic: Compare average rating in first vs last year for each player and compute the difference.
-- Usefulness: Highlights player development and potential breakout talents.

WITH player_team_periods AS (

    SELECT
        pa.player_api_id,
        pa.player_fifa_api_id,
        pa.date,
        pa.overall_rating,
        m.home_team_api_id AS team_id

    FROM Player_Attributes AS pa
    JOIN "Match" AS m
        ON pa.player_api_id = m.home_player_1
        OR pa.player_api_id = m.home_player_2
        OR pa.player_api_id = m.home_player_3
        OR pa.player_api_id = m.home_player_4
        OR pa.player_api_id = m.home_player_5
        OR pa.player_api_id = m.home_player_6
        OR pa.player_api_id = m.home_player_7
        OR pa.player_api_id = m.home_player_8
        OR pa.player_api_id = m.home_player_9
        OR pa.player_api_id = m.home_player_10
        OR pa.player_api_id = m.home_player_11

    WHERE
        pa.overall_rating IS NOT NULL

    UNION

    SELECT
        pa.player_api_id,
        pa.player_fifa_api_id,
        pa.date,
        pa.overall_rating,
        m.away_team_api_id AS team_id

    FROM Player_Attributes AS pa
    JOIN "Match" AS m
        ON pa.player_api_id = m.away_player_1
        OR pa.player_api_id = m.away_player_2
        OR pa.player_api_id = m.away_player_3
        OR pa.player_api_id = m.away_player_4
        OR pa.player_api_id = m.away_player_5
        OR pa.player_api_id = m.away_player_6
        OR pa.player_api_id = m.away_player_7
        OR pa.player_api_id = m.away_player_8
        OR pa.player_api_id = m.away_player_9
        OR pa.player_api_id = m.away_player_10
        OR pa.player_api_id = m.away_player_11

    WHERE
        pa.overall_rating IS NOT NULL
),

player_teams AS (
    SELECT
        player_api_id,
        player_fifa_api_id,
        team_id,
        MIN(date) AS first_date_with_team,
        MAX(date) AS last_date_with_team,
        ROUND(AVG(overall_rating), 2) AS avg_rating_with_team
    FROM player_team_periods
    GROUP BY
        player_api_id,
        player_fifa_api_id,
        team_id
),

player_transfers AS (
    SELECT
        player_api_id,
        player_fifa_api_id,
        team_id,
        first_date_with_team,
        last_date_with_team,
        avg_rating_with_team,

        LAG(team_id) OVER (
            PARTITION BY player_api_id
            ORDER BY first_date_with_team
        ) AS prev_team_id,

        LAG(avg_rating_with_team) OVER (
            PARTITION BY player_api_id
            ORDER BY first_date_with_team
        ) AS prev_avg_rating

    FROM player_teams
),

transfer_impact AS (
    SELECT
        player_api_id,
        player_fifa_api_id,
        team_id AS new_team_id,
        prev_team_id,
        first_date_with_team AS transfer_date,
        avg_rating_with_team AS rating_at_new_team,
        prev_avg_rating AS rating_at_prev_team,
        avg_rating_with_team - prev_avg_rating AS rating_change

    FROM player_transfers
    WHERE
        prev_team_id IS NOT NULL
        AND prev_team_id <> team_id
)

SELECT
    ti.player_api_id,
    ti.player_fifa_api_id,
    t_new.team_long_name AS new_team,
    t_prev.team_long_name AS prev_team,
    ti.transfer_date,
    ti.rating_at_prev_team,
    ti.rating_at_new_team,
    ti.rating_change

FROM transfer_impact AS ti
LEFT JOIN Team AS t_new
    ON ti.new_team_id = t_new.team_api_id
LEFT JOIN Team AS t_prev
    ON ti.prev_team_id = t_prev.team_api_id

ORDER BY
    ti.rating_change DESC,
    ti.transfer_date

LIMIT 30;

-- Query 15: Leagues with highest scoring
-- Business question: Which leagues and seasons are highest scoring?
-- Logic: Compute average goals per match per league-season, filter by match count.
-- Usefulness: Compares entertainment value and attacking intensity across leagues.

SELECT
    l.name AS league,
    m.season,
    COUNT(*) AS matches,
    SUM(m.home_team_goal + m.away_team_goal) AS total_goals,
    ROUND(
        1.0 * SUM(m.home_team_goal + m.away_team_goal) / COUNT(*),
        2
    ) AS avg_goals_per_match

FROM "Match" AS m
JOIN League AS l
    ON m.league_id = l.id

GROUP BY
    l.name,
    m.season

HAVING
    COUNT(*) >= 50

ORDER BY
    avg_goals_per_match DESC,
    total_goals DESC

LIMIT 20;
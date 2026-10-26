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
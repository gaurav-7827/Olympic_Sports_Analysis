-- Are there any sports or events that have a higher number of medalists from a specific region?
SELECT sport_name, region_name, total_medals
FROM (
    SELECT sport_name,
           region_name,
           SUM(CASE WHEN medal_name = 'NA' THEN 0 ELSE 1 END) AS total_medals
    FROM consolidated_fact
    GROUP BY sport_name, region_name
) t
ORDER BY total_medals DESC
LIMIT 10;

--  What are some notable instances of unexpected or surprising medal wins?

SELECT 
    region_name,
    sport_name,
    COUNT(*) AS medal_count
FROM consolidated_fact
WHERE medal_name <> 'NA'
  AND region_name NOT IN (
      SELECT region_name
      FROM consolidated_fact
      WHERE medal_name <> 'NA'
      GROUP BY region_name
      HAVING COUNT(*) > 1000
  )
GROUP BY region_name, sport_name
ORDER BY medal_count DESC;


-- Are there any regions that have experienced significant growth or decline in Olympic participation?

SELECT region_name, games_year,count(event_name) AS total_year
FROM consolidated_fact
GROUP BY 1, 2
ORDER BY 1 ASC, 2 ASC;


-- How do cultural or geographical factors influence the performance of regions in specific sports?
SELECT 
    region_name,
    sport_name,
    COUNT(CASE WHEN medal_name <> 'NA' THEN 1 END) AS total_medals
FROM consolidated_fact
GROUP BY region_name, sport_name
ORDER BY total_medals DESC;


-- Are there any regions that have had a notable impact on the overall medal tally?

SELECT region_name, SUM(medal_count) AS total_medals
FROM (
SELECT sport_name ,region_name,
CASE WHEN medal_name ='NA' THEN 0 ELSE 1 END AS medal_count
FROM consolidated_fact
)
GROUP BY 1
ORDER BY 2 DESC;


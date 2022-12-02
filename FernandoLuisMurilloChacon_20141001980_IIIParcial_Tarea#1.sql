--Ejercicio 1

SELECT
  sum(number) as Sumatoria
FROM `bigquery-public-data.usa_names.usa_1910_2013`
Group BY gender, name
Order by Sumatoria DESC;


--Ejercicio 2

SELECT
  state, 
  date,
  tests_total,
  cases_positive_total,
  Sum(tests_total) OVER 
  (PARTITION BY state) as suma_total
FROM `bigquery-public-data.covid19_covidtracking.summary`;

--Ejercicio 3

SELECT 
  channelGrouping,
  sum(totals.pageviews) as pageviews,
  CONCAT(ROUND(((sum(totals.pageviews)/ ((SELECT sum(totals.pageviews) FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`)))*100.00),2),'%') AS Porcentaje,
  AVG(sum(totals.pageviews)) over() as Promedio
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY channelGrouping
ORDER BY pageviews DESC;


--Ejercicio 4

/*testest.tastatst no pregunte por que le puse eso, simplemente no lo sabia que lo estaba poniendo*/
SELECT
  Region,
  Country,
  Round((Units_Sold * Unit_Price),2) AS total_Revenue,
  RANK() OVER(PARTITION BY Region ORDER BY total_Revenue desc) rank_Revenue
FROM `argon-system-370414.testest.tastatst`
ORDER BY Region asc, total_Revenue desc

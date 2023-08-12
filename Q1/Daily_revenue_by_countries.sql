/*
Query to extract daily total revenue for Canada, France, and United States
*/
WITH address_by_countries AS
(SELECT a.address_id
 FROM address a
 WHERE a.city_id IN
	(SELECT ci.city_id
	 FROM city ci
	 JOIN country co ON ci.country_id = co.country_id
	 WHERE co.country = 'Canada' OR co.country = 'United States' OR co.country = 'France')
),

revenue_by_countries AS 
(SELECT co.country AS country, EXTRACT(MONTH from p.payment_date) AS revenue_month, EXTRACT(DAY from p.payment_date) AS revenue_day, EXTRACT(YEAR from p.payment_date) AS revenue_year, SUM(p.amount)AS total_revenue
 FROM payment p
 JOIN customer c ON c.customer_id = p.customer_id
 JOIN address a ON a.address_id = c.address_id
 JOIN address_by_countries abc ON abc.address_id = c.address_id
 JOIN city ci ON ci.city_id = a.city_id
 JOIN country co ON co.country_id = ci.country_id
 GROUP BY co.country, revenue_month, revenue_day, revenue_year
 ORDER BY co.country ASC, revenue_month ASC
)

select country, revenue_month || '-' || revenue_day || '-' || revenue_year AS revenue_date, total_revenue from revenue_by_countries;

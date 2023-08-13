SELECT a.first_name || ' ' || a.last_name AS actor, SUM(p.amount)AS total_revenue
 FROM payment p
 JOIN rental r ON r.rental_id = p.rental_id
 JOIN inventory i ON i.inventory_id = r.inventory_id
 JOIN film f ON f.film_id = i.film_id
 JOIN film_actor fa ON fa.film_id = f.film_id
 JOIN actor a ON a.actor_id = fa.actor_id
 GROUP BY actor
 ORDER BY total_revenue DESC

USE sakila;

-- Write SQL queries to perform the following tasks using the Sakila database:
-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system

SELECT COUNT(inventory_id) AS available_copies
FROM inventory
WHERE film_id IN (SELECT film_id
					FROM film
                    WHERE title = 'Hunchback Impossible');
                    
-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length)
				FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name
FROM actor
WHERE ACTOR_ID IN (SELECT actor_id
					FROM film_actor
					WHERE film_id IN (SELECT film_id
										FROM film
										WHERE title = 'Alone Trip'));

-- 4. Identify all movies categorized as family films.
SELECT * FROM category;

SELECT title
FROM film
WHERE film_id IN (SELECT film_id 
				FROM film_category
				WHERE category_id IN (SELECT category_id
									FROM category
                                    WHERE name = 'Family'));
                                    
-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
WHERE address_id IN (SELECT address_id
					FROM address
                    JOIN city
                    USING(city_id)
                    JOIN country
                    USING(country_id)
                    WHERE country = 'Canada');

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
--    A prolific actor is defined as the ** actor who has acted in the most number of films **. COUNT(film_id) 
--    First, you will need to find the most prolific actor and then use that actor_id to find the different 
--    films that he or she starred in.

SELECT title
FROM film
WHERE film_id IN (SELECT film_id
					FROM film_actor
                    WHERE actor_id = (SELECT actor_id
										FROM film_actor
										GROUP BY actor_id
										ORDER BY count(film_id)
										LIMIT 1));

# joins not necessary
SELECT actor_id, COUNT(film_id) AS num_of_films
FROM film
RIGHT JOIN film_actor
USING(film_id)
RIGHT JOIN actor
USING(actor_id)
GROUP BY actor_id
ORDER BY num_of_films
LIMIT 1;

-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, 
-- i.e., the customer who has made the largest sum of payments

SELECT title
FROM film
WHERE film_id IN (SELECT film_id
					FROM inventory
					WHERE inventory_id IN (SELECT inventory_id
											FROM rental
											WHERE rental_id IN (SELECT rental_id
																FROM payment
                                                                WHERE customer_id = (SELECT customer_id
																					FROM payment
																					GROUP BY customer_id
																					ORDER BY sum(amount)
																					LIMIT 1))));
                                                                                    




-- 1a
SELECT first_name, last_name
FROM sakila.actor;

-- 1b
SELECT concat(first_name, ' ', last_name) AS 'Actor Name'
FROM sakila.actor;

-- 2a
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name = 'Joe';

-- 2b
SELECT first_name, last_name
FROM sakila.actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT first_name, last_name
FROM sakila.actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ASC;

-- 2d
SELECT country_id, country
FROM sakila.country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE sakila.actor
ADD description BLOB;

-- 3b
ALTER TABLE sakila.actor
DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(last_name) AS 'Number of Actors' 
FROM sakila.actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) AS 'Number of Actors' 
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c
UPDATE sakila.actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE sakila.actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a
SHOW CREATE TABLE sakila.address;

CREATE TABLE `address` 
	(`address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
	  `address` varchar(50) NOT NULL,
	  `address2` varchar(50) DEFAULT NULL,
	  `district` varchar(20) NOT NULL,
	  `city_id` smallint(5) unsigned NOT NULL,
	  `postal_code` varchar(10) DEFAULT NULL,
	  `phone` varchar(20) NOT NULL,
	  `location` geometry NOT NULL,
	  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	  PRIMARY KEY (`address_id`),
	  KEY `idx_fk_city_id` (`city_id`),
	  SPATIAL KEY `idx_location` (`location`),
	  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
	) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6a
SELECT first_name, last_name, address 
FROM sakila.staff s
JOIN sakila.address a 
ON a.address_id = s.address_id;

-- 6b
SELECT s.staff_id, first_name, last_name, SUM(amount) as 'Total Amount'
FROM sakila.staff s
JOIN sakila.payment p 
ON s.staff_id = p.staff_id
GROUP BY s.staff_id;

-- 6c
SELECT f.title, COUNT(fa.actor_id) as 'Number of Actors'
FROM sakila.film f
JOIN sakila.film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d
SELECT f.title, COUNT(i.inventory_id) as 'Copies'
FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
GROUP BY f.film_id
HAVING f.title = 'Hunchback Impossible';

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount) as 'Total Paid'
FROM sakila.customer c
JOIN sakila.payment p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name;

-- 7a
SELECT title 
FROM sakila.film
WHERE language_id IN
	(SELECT language_id FROM language
	WHERE name = 'English')
AND title LIKE 'K%' OR title LIKE 'Q%';

-- 7b
SELECT first_name, last_name 
FROM sakila.actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor
	WHERE film_id IN
		(SELECT film_id FROM film
		WHERE title = 'Alone Trip'));

-- 7c
SELECT c.first_name, c.last_name, c.email, co.country 
FROM sakila.customer c
JOIN sakila.address a
ON c.address_id = a.address_id
JOIN sakila.city ci
ON ci.city_id = a.city_id
JOIN sakila.country co
ON co.country_id = ci.country_id
WHERE country = 'Canada';

-- 7d
SELECT title
FROM sakila.film
WHERE film_id IN
	(SELECT film_id FROM film_category
	WHERE category_id IN
		(SELECT category_id FROM category
		WHERE name = 'Family'));
		
-- 7e
SELECT f.title , COUNT(r.rental_id) AS 'Number of Rentals' 
FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
JOIN sakila.rental r 
ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;

-- 7f
SELECT s.store_id, FORMAT(SUM(amount), 'C', 'en-us') AS 'Total Amount'
FROM sakila.store s
JOIN sakila.staff st
ON s.store_id = st.store_id
JOIN sakila.payment p
ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 7g
SELECT s.store_id, ci.city, co.country 
FROM sakila.store s
JOIN sakila.address a
ON s.address_id = a.address_id
JOIN sakila.city ci
ON a.city_id = ci.city_id
JOIN sakila.country co
ON ci.country_id = co.country_id;

-- 7h
SELECT c.name, SUM(p.amount) as 'Gross Revenue' 
FROM sakila.category c
JOIN sakila.film_category fc
ON c.category_id = fc.category_id
JOIN sakila.inventory i
ON fc.film_id = i.film_id
JOIN sakila.rental r
ON r.inventory_id = i.inventory_id
JOIN sakila.payment p
ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- 8a
CREATE VIEW top_5_by_genre AS
SELECT c.name, SUM(p.amount) as 'Gross Revenue' 
FROM sakila.category c
JOIN sakila.film_category fc
ON c.category_id = fc.category_id
JOIN sakila.inventory i
ON fc.film_id = i.film_id
JOIN sakila.rental r
ON r.inventory_id = i.inventory_id
JOIN sakila.payment p
ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- 8b
SELECT * 
FROM top_5_by_genre;

-- 8c
DROP VIEW top_5_by_genre;

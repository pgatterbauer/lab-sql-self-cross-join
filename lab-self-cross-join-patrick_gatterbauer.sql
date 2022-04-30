# LAB SQL SELF CROSS JOIN

# Instructions
# Get all pairs of actors that worked together.
# SELF JOIN
# TABLES:
	# actor 
    # film_actor
SELECT DISTINCT
	CONCAT(A.last_name, " ", A.first_name) AS actor_1,
    CONCAT(B.last_name, " ", B.first_name) AS actor_2
FROM
	film_actor F 
	INNER JOIN
		actor A
	ON
		F.actor_id = A.actor_id
	INNER JOIN
		actor B
	ON
		A.actor_id <> B.actor_id
ORDER BY
	actor_1 ASC,
    actor_2 ASC;

# Get all pairs of customers that have rented the same film more than 3 times.
# TABLE:
	# customer
    # rental
    # inventory
# FIRST: FINDING OUT WHICH MOVIES HAVE BEEN RENTED MORE THAN 3 TIMES
SELECT
	F.title,
    COUNT(R.rental_id) AS num_rentals
FROM
	film F
    INNER JOIN
		inventory I
	ON
		F.film_id = I.film_id
	INNER JOIN
		rental R
	ON
		I.inventory_id = R.inventory_id
GROUP BY
	F.title
HAVING
	num_rentals > 3;
	
# SECOND: GETTING THE CUSTOMER NAMES
SELECT
	F.title, 
    R.rental_id, 
    I.inventory_id,
    CONCAT(A.last_name, " ", A.first_name) AS customer_1,
    CONCAT(B.last_name, " ", B.first_name) AS customer_2,
    CONCAT(CONCAT(A.last_name, " ", A.first_name), " ", CONCAT(B.last_name, " ", B.first_name)) AS pair
FROM
	customer A
    INNER JOIN
		rental R
	ON
		A.customer_id = R.customer_id
	INNER JOIN
		customer B 
	ON
		A.customer_id <> B.customer_id        
	INNER JOIN
		inventory I
	ON
		I.inventory_id = R.inventory_id
	INNER JOIN
		film F
	ON
		F.film_id = I.film_id
ORDER BY
	F.title ASC;

# ONLY DISPLAYING THE PAIRS
SELECT
    CONCAT(CONCAT(A.last_name, " ", A.first_name), " AND ", CONCAT(B.last_name, " ", B.first_name)) AS pair
FROM
	customer A
    INNER JOIN
		rental R
	ON
		A.customer_id = R.customer_id
	INNER JOIN
		customer B 
	ON
		A.customer_id <> B.customer_id        
	INNER JOIN
		inventory I
	ON
		I.inventory_id = R.inventory_id
GROUP BY
	pair
HAVING
	COUNT(*) > 3
ORDER BY
	pair ASC;

# Get all possible pairs of actors and films.
    # interpretation 1: 2 actors (pair) <-> 1 film
SELECT
	F.title,
    CONCAT(A.last_name, " ", A.first_name) AS actor_1,
    CONCAT(B.last_name, " ", B.first_name) AS actor_2
FROM
	actor A
    INNER JOIN
		film_actor FA
	ON
		A.actor_id = FA.actor_id
	INNER JOIN
		actor B 
	ON
		A.actor_id <> B.actor_id        
	INNER JOIN
		film F
	ON
		F.film_id = FA.film_id
	ORDER BY
		F.title ASC, 
        actor_1 ASC, 
        actor_2 ASC;
        
	# interpretion 2: 1 actor <-> 1 film
SELECT DISTINCT
	CONCAT(A.last_name, " ", A.first_name) AS actor_name,
    F.title
FROM
	film F
INNER JOIN
	film_actor FA
ON
	F.film_id = FA.film_id
INNER JOIN
	actor A
ON
	FA.actor_id = A.actor_id
ORDER BY
	actor_name ASC,
	F.title ASC;

# USING CROSS JOIN
SELECT DISTINCT
	CONCAT(A.last_name, " ", A.first_name) AS actor_name,
    F.title
FROM
	actor A 
    CROSS JOIN 
		film_actor FA
	ON
		A.actor_id = FA.actor_id
	INNER JOIN
		film F
	ON
		FA.film_id = F.film_id
ORDER BY
	actor_name ASC,
    F.title ASC;
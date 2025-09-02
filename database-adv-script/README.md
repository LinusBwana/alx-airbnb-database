# SQL Joins Queries

This project demonstrates the use of different types of SQL joins with practical examples.

## Queries Included

1. **INNER JOIN**  
   Retrieves all bookings and the respective users who made those bookings.

   ```sql
   SELECT b.booking_id, b.property_id, b.user_id, b.status, u.first_name, u.last_name
   FROM bookings b
   INNER JOIN users u ON b.user_id = u.user_id;
   ```

2. **LEFT JOIN**  
   Retrieves all properties and their reviews, including properties that have no reviews.

   ```sql
   SELECT p.property_id, p.name AS property_name, r.review_id, r.rating, r.comment
   FROM properties p
   LEFT JOIN reviews r ON p.property_id = r.property_id;
   ```

3. **FULL OUTER JOIN**  
   Retrieves all users and all bookings, even if the user has no booking or a booking is not linked to a user.

   ```sql
   SELECT u.user_id, u.first_name, u.last_name, b.booking_id, b.status
   FROM users u
   FULL OUTER JOIN bookings b ON u.user_id = b.user_id;
   ```

## Usage

Run the queries in `joins_queries.sql` on your SQL database to explore how different join types behave.


# SQL Joins Queries

This project demonstrates the use of different types of SQL joins with practical examples.

## Queries Included

1. **INNER JOIN**  
   Retrieves all bookings and the respective users who made those bookings.

   ```sql
   SELECT b.booking_id, b.property_id, b.user_id, b.status, u.first_name, u.last_name
   FROM bookings b
   INNER JOIN users u ON b.user_id = u.user_id;
   ```

2. **LEFT JOIN**  
   Retrieves all properties and their reviews, including properties that have no reviews.

   ```sql
   SELECT p.property_id, p.name AS property_name, r.review_id, r.rating, r.comment
   FROM properties p
   LEFT JOIN reviews r ON p.property_id = r.property_id;
   ```

3. **FULL OUTER JOIN**  
   Retrieves all users and all bookings, even if the user has no booking or a booking is not linked to a user.

   ```sql
   SELECT u.user_id, u.first_name, u.last_name, b.booking_id, b.status
   FROM users u
   FULL OUTER JOIN bookings b ON u.user_id = b.user_id;
   ```

## Usage

Run the queries in `joins_queries.sql` on your SQL database to explore how different join types behave.

# SQL Aggregations and Window Functions

This project demonstrates the use of **aggregation functions** and **window functions** in SQL.

## Queries Included

1. **Aggregation with COUNT and GROUP BY**  
   Find the total number of bookings made by each user.

   ```sql
   SELECT u.user_id, u.first_name, u.last_name, COUNT(b.booking_id) AS total_bookings
   FROM users u
   LEFT JOIN bookings b ON u.user_id = b.user_id
   GROUP BY u.user_id, u.first_name, u.last_name;
   ```

2. **Window Function with RANK**  
   Rank properties based on the total number of bookings they have received.

   ```sql
   SELECT p.property_id, p.name AS property_name,
          COUNT(b.booking_id) AS total_bookings,
          RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS property_rank
   FROM properties p
   LEFT JOIN bookings b ON p.property_id = b.property_id
   GROUP BY p.property_id, p.name
   ORDER BY property_rank;
   ```

## Usage

Run the queries in `aggregations_and_window_functions.sql` on your SQL database to explore how aggregations and window functions work.
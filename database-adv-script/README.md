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

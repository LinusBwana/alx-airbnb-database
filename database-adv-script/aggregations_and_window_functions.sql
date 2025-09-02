-- aggregations_and_window_functions.sql

-- 1. Aggregation: Find the total number of bookings made by each user
SELECT u.user_id, u.first_name, u.last_name, COUNT(b.booking_id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name;

-- 2. Window Function: Rank properties based on the total number of bookings
SELECT 
    p.property_id, 
    p.name AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS property_rank
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY property_rank;
-- perfomance.sql

---------------------------------------------------------------
-- 1. Initial Complex Query (Unoptimized)
---------------------------------------------------------------
-- Retrieve all bookings along with user, property, and payment details
SELECT b.booking_id, b.booking_date, b.status,
       u.user_id, u.first_name, u.last_name, u.email,
       p.property_id, p.name AS property_name, p.location,
       pay.payment_id, pay.amount, pay.status AS payment_status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
JOIN payments pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed'
  AND pay.status = 'completed';

---------------------------------------------------------------
-- 2. Performance Analysis
---------------------------------------------------------------
-- Run EXPLAIN ANALYZE before optimization:
EXPLAIN ANALYZE
SELECT b.booking_id, b.booking_date, b.status,
       u.user_id, u.first_name, u.last_name, u.email,
       p.property_id, p.name AS property_name, p.location,
       pay.payment_id, pay.amount, pay.status AS payment_status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
JOIN payments pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed'
  AND pay.status = 'completed';

---------------------------------------------------------------
-- 3. Optimized Query (Refactored)
---------------------------------------------------------------
-- Improvements:
--   - Select only required fields (reduced payload)
--   - Filter early with WHERE and AND to reduce dataset
--   - Use proper indexes on user_id, property_id, booking_id, status
--   - Remove unnecessary columns to speed up retrieval

SELECT b.booking_id, b.booking_date,
       u.first_name, u.last_name,
       p.name AS property_name,
       pay.amount
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
JOIN payments pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed'
  AND pay.status = 'completed';
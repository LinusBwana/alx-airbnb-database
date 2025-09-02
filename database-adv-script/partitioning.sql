-- partitioning.sql

---------------------------------------------------------------
-- 1. Drop existing table if exists (for demo purposes only)
---------------------------------------------------------------
DROP TABLE IF EXISTS bookings CASCADE;

---------------------------------------------------------------
-- 2. Create Bookings Table Partitioned by start_date (RANGE)
---------------------------------------------------------------
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
) PARTITION BY RANGE (start_date);

---------------------------------------------------------------
-- 3. Create Partitions (by Year)
---------------------------------------------------------------
CREATE TABLE bookings_2023 PARTITION OF bookings
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_2024 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

---------------------------------------------------------------
-- 4. Example Query on Partitioned Table
---------------------------------------------------------------
EXPLAIN ANALYZE
SELECT booking_id, user_id, property_id, start_date, end_date
FROM bookings
WHERE start_date BETWEEN '2024-03-01' AND '2024-03-31'
  AND status = 'confirmed';

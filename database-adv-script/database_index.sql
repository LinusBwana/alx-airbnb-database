-- ==============================================
-- Database Index Optimization
-- ==============================================

-- Users table: often searched by email and joined by user_id
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_user_id ON users(user_id);

-- Bookings table: frequently filtered/joined by user_id and property_id
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_status ON bookings(status);

-- Properties table: frequently filtered/joined by host_id and property_id
CREATE INDEX idx_properties_property_id ON properties(property_id);
CREATE INDEX idx_properties_host_id ON properties(host_id);

-- Reviews table: filtered/joined by property_id
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- ==============================================
-- Performance Measurement (before/after indexes)
-- ==============================================

EXPLAIN ANALYZE
SELECT b.booking_id, u.first_name, u.last_name, p.name AS property_name
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.email = 'john@example.com';
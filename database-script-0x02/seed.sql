-- Normalized AirBnB Database Schema (3NF)

-- =====================================================
-- SAMPLE DATA FOR NORMALIZED SCHEMA
-- =====================================================

-- 1. Insert Users (1 admin, 2 hosts, 2 guests)
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role) VALUES
('John', 'Doe', 'john.doe@email.com', '$2b$10$abcd1234efgh5678ijkl9012mnop3456', '+1-555-0101', 'host'),
('Jane', 'Smith', 'jane.smith@email.com', '$2b$10$wxyz9876stuv5432nopq1098lmno7654', '+1-555-0102', 'host'),
('Alice', 'Johnson', 'alice.johnson@email.com', '$2b$10$pqrs4567tuvw8901xyza2345bcde6789', '+1-555-0103', 'guest'),
('Bob', 'Wilson', 'bob.wilson@email.com', '$2b$10$fghi3456jklm7890nopq1234rstu5678', '+1-555-0104', 'guest'),
('Carol', 'Brown', 'carol.brown@email.com', '$2b$10$abcd5678efgh9012ijkl3456mnop7890', '+254-722-123456', 'admin');

-- 2. Insert Locations (Eliminates redundancy)
INSERT INTO locations (city, state_province, country) VALUES
('New York', 'New York', 'United States'),
('Miami', 'Florida', 'United States'),
('Aspen', 'Colorado', 'United States'),
('Boston', 'Massachusetts', 'United States'),
('Chicago', 'Illinois', 'United States');

-- 3. Insert Properties (References locations instead of storing redundant data)
INSERT INTO properties (host_id, location_id, name, description, price_per_night) VALUES
((SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'New York'), 
 'Cozy Downtown Apartment', 
 'A beautiful 2-bedroom apartment in the heart of the city with modern amenities and great views.', 
 150.00),

((SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'Miami'), 
 'Beachfront Villa', 
 'Luxurious 4-bedroom villa with direct beach access, perfect for family vacations.', 
 350.00),

((SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'Aspen'), 
 'Mountain Cabin Retreat', 
 'Rustic 3-bedroom cabin in the mountains, ideal for hiking and nature lovers.', 
 200.00),

((SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'Boston'), 
 'Historic Townhouse', 
 'Charming 2-bedroom historic townhouse with original architecture and modern comforts.', 
 180.00),

((SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'Chicago'), 
 'Urban Loft Space', 
 'Modern industrial loft with high ceilings, exposed brick, and city skyline views.', 
 120.00);

-- 4. Insert Bookings (No calculated total_price field)
INSERT INTO bookings (property_id, user_id, start_date, end_date, status) VALUES
((SELECT property_id FROM properties WHERE name = 'Cozy Downtown Apartment'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 '2024-03-15', '2024-03-18', 'confirmed'),

((SELECT property_id FROM properties WHERE name = 'Beachfront Villa'), 
 (SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 '2024-04-10', '2024-04-15', 'confirmed'),

((SELECT property_id FROM properties WHERE name = 'Mountain Cabin Retreat'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 '2024-05-20', '2024-05-25', 'pending'),

((SELECT property_id FROM properties WHERE name = 'Historic Townhouse'), 
 (SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 '2024-06-01', '2024-06-03', 'confirmed'),

((SELECT property_id FROM properties WHERE name = 'Urban Loft Space'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 '2024-07-12', '2024-07-14', 'canceled');

-- 5. Insert Payments (for confirmed bookings only)
INSERT INTO payments (booking_id, amount, payment_method) VALUES
((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Cozy Downtown Apartment' AND b.status = 'confirmed'), 
 450.00, 'card'),

((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Beachfront Villa' AND b.status = 'confirmed'), 
 1750.00, 'mpesa'),

((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Historic Townhouse' AND b.status = 'confirmed'), 
 360.00, 'paypal');

-- 6. Insert Reviews (Links to bookings, ensuring business rule compliance)
INSERT INTO reviews (booking_id, rating, comment) VALUES
((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Cozy Downtown Apartment' AND b.status = 'confirmed'), 
 5, 'Amazing apartment! Perfect location and very clean. Host was very responsive.'),

((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Beachfront Villa' AND b.status = 'confirmed'), 
 4, 'Beautiful villa with great ocean views. Only minor issue was the WiFi was a bit slow.'),

((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Historic Townhouse' AND b.status = 'confirmed'), 
 5, 'Loved the historic charm and modern amenities. Great location for exploring Boston.');

-- 7. Insert Messages
INSERT INTO messages (sender_id, recipient_id, message_body) VALUES
((SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 (SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 'Hi! I''m interested in booking your downtown apartment. Is it available for March 15-18?'),

((SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 'Hello Alice! Yes, the apartment is available for those dates. I''ll send you the booking details.'),

((SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 (SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 'Quick question about the beachfront villa - is there parking available?'),

((SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 (SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 'Yes, there''s a private driveway that can accommodate 2 cars. Free parking included!'),

((SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 (SELECT user_id FROM users WHERE email = 'carol.brown@email.com'), 
 'Thank you for managing such a great platform! The booking process was seamless.');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Checking all tables have data
SELECT 'Users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'Locations', COUNT(*) FROM locations
UNION ALL
SELECT 'Properties', COUNT(*) FROM properties
UNION ALL
SELECT 'Bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'Messages', COUNT(*) FROM messages;

-- Test the views
SELECT 'Property Details View' as view_name, COUNT(*) as records FROM property_details
UNION ALL
SELECT 'Booking Details View', COUNT(*) FROM booking_details
UNION ALL
SELECT 'Review Details View', COUNT(*) FROM review_details;
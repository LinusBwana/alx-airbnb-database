# AirBnB Database - Sample Data INSERT Statements

## Overview

This document provides comprehensive INSERT statements to populate the normalized AirBnB database with realistic sample data. The data includes 5 records for each table with proper relationships and business logic consistency.

## Data Overview

- **Users**: 1 Admin, 2 Hosts, 2 Guests
- **Locations**: 5 US cities for property diversity
- **Properties**: 5 properties across different locations and hosts
- **Bookings**: 5 bookings with various statuses
- **Payments**: 3 payments for confirmed bookings + 2 additional transactions
- **Reviews**: 3 reviews from guests who completed stays
- **Messages**: 5 conversation messages between users

## Prerequisites

Ensure the database schema is created first (see Database Schema README). The tables must exist before running these INSERT statements.

---

## 1. Users Data

**Description**: Creates platform users with different roles

```sql
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role) VALUES
('John', 'Doe', 'john.doe@email.com', '$2b$10$abcd1234efgh5678ijkl9012mnop3456', '+1-555-0101', 'host'),
('Jane', 'Smith', 'jane.smith@email.com', '$2b$10$wxyz9876stuv5432nopq1098lmno7654', '+1-555-0102', 'host'),
('Alice', 'Johnson', 'alice.johnson@email.com', '$2b$10$pqrs4567tuvw8901xyza2345bcde6789', '+1-555-0103', 'guest'),
('Bob', 'Wilson', 'bob.wilson@email.com', '$2b$10$fghi3456jklm7890nopq1234rstu5678', '+1-555-0104', 'guest'),
('Carol', 'Brown', 'carol.brown@email.com', '$2b$10$abcd5678efgh9012ijkl3456mnop7890', '+254-722-123456', 'admin');
```

**Data Details**:
- **John Doe** & **Jane Smith**: Property hosts
- **Alice Johnson** & **Bob Wilson**: Guests who make bookings
- **Carol Brown**: Platform administrator (Kenya phone number)
- All passwords are bcrypt hashed (sample hashes)

---

## 2. Locations Data

**Description**: Normalized location data to eliminate redundancy

```sql
INSERT INTO locations (city, state_province, country) VALUES
('New York', 'New York', 'United States'),
('Miami', 'Florida', 'United States'),
('Aspen', 'Colorado', 'United States'),
('Boston', 'Massachusetts', 'United States'),
('Chicago', 'Illinois', 'United States');
```

**Data Details**:
- 5 major US cities across different states
- Diverse geographical locations for property variety
- Proper atomic location components (city, state, country)

---

## 3. Properties Data

**Description**: Property listings linked to hosts and locations

```sql
INSERT INTO properties (host_id, location_id, name, description, price_per_night) VALUES
-- John Doe's properties
((SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'New York'), 
 'Cozy Downtown Apartment', 
 'A beautiful 2-bedroom apartment in the heart of the city with modern amenities and great views.', 
 150.00),

((SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'Aspen'), 
 'Mountain Cabin Retreat', 
 'Rustic 3-bedroom cabin in the mountains, ideal for hiking and nature lovers.', 
 200.00),

-- Jane Smith's properties
((SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 (SELECT location_id FROM locations WHERE city = 'Miami'), 
 'Beachfront Villa', 
 'Luxurious 4-bedroom villa with direct beach access, perfect for family vacations.', 
 350.00),

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
```

**Data Details**:
- **John's Properties**: NYC apartment ($150/night), Aspen cabin ($200/night)
- **Jane's Properties**: Miami villa ($350/night), Boston townhouse ($180/night), Chicago loft ($120/night)
- Price range: $120-$350 per night
- Diverse property types: apartments, villa, cabin, townhouse, loft

---

## 4. Bookings Data

**Description**: Reservation records with various statuses

```sql
INSERT INTO bookings (property_id, user_id, start_date, end_date, status) VALUES
-- Alice's bookings
((SELECT property_id FROM properties WHERE name = 'Cozy Downtown Apartment'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 '2024-03-15', '2024-03-18', 'confirmed'),

((SELECT property_id FROM properties WHERE name = 'Mountain Cabin Retreat'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 '2024-05-20', '2024-05-25', 'pending'),

((SELECT property_id FROM properties WHERE name = 'Urban Loft Space'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 '2024-07-12', '2024-07-14', 'canceled'),

-- Bob's bookings
((SELECT property_id FROM properties WHERE name = 'Beachfront Villa'), 
 (SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 '2024-04-10', '2024-04-15', 'confirmed'),

((SELECT property_id FROM properties WHERE name = 'Historic Townhouse'), 
 (SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 '2024-06-01', '2024-06-03', 'confirmed');
```

**Data Details**:
- **Alice**: 3 bookings (1 confirmed, 1 pending, 1 canceled)
- **Bob**: 2 bookings (both confirmed)
- **Date Ranges**: Various seasons throughout 2024
- **Status Mix**: 3 confirmed, 1 pending, 1 canceled

**Calculated Totals** (for reference):
- Alice's NYC apartment: 3 nights × $150 = $450
- Bob's Miami villa: 5 nights × $350 = $1,750
- Bob's Boston townhouse: 2 nights × $180 = $360
- Alice's pending Aspen cabin: 5 nights × $200 = $1,000
- Alice's canceled Chicago loft: 2 nights × $120 = $240

---

## 5. Payments Data

**Description**: Payment transactions for confirmed bookings

```sql
INSERT INTO payments (booking_id, amount, payment_method) VALUES
-- Primary payments for confirmed bookings
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
 360.00, 'paypal'),

-- Additional payment transactions
((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Cozy Downtown Apartment' AND b.status = 'confirmed'), 
 50.00, 'card'), -- Security deposit refund

((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Beachfront Villa' AND b.status = 'confirmed'), 
 200.00, 'paypal'); -- Additional cleaning fee
```

**Data Details**:
- **Primary Payments**: Full booking amounts for 3 confirmed reservations
- **Payment Methods**: 
  - `card`: $450 + $50 (Alice's NYC stay + refund)
  - `mpesa`: $1,750 (Bob's Miami stay - East African payment method)
  - `paypal`: $360 + $200 (Bob's Boston stay + additional fee)
- **Transaction Types**: Main payments, refunds, additional charges

---

## 6. Reviews Data

**Description**: Property reviews linked to completed bookings

```sql
INSERT INTO reviews (booking_id, rating, comment) VALUES
-- Alice's review of NYC apartment
((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Cozy Downtown Apartment' AND b.status = 'confirmed'), 
 5, 'Amazing apartment! Perfect location and very clean. Host was very responsive.'),

-- Bob's review of Miami villa
((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Beachfront Villa' AND b.status = 'confirmed'), 
 4, 'Beautiful villa with great ocean views. Only minor issue was the WiFi was a bit slow.'),

-- Bob's review of Boston townhouse
((SELECT booking_id FROM bookings b 
  JOIN properties p ON b.property_id = p.property_id 
  WHERE p.name = 'Historic Townhouse' AND b.status = 'confirmed'), 
 5, 'Loved the historic charm and modern amenities. Great location for exploring Boston.');
```

**Data Details**:
- **Only confirmed bookings** have reviews (business rule enforcement)
- **Rating Distribution**: Two 5-star reviews, one 4-star review
- **Authentic Comments**: Detailed feedback with specific mentions
- **Linked to Bookings**: Ensures reviewers actually stayed at properties

---

## 7. Messages Data

**Description**: Communication between platform users

```sql
INSERT INTO messages (sender_id, recipient_id, message_body) VALUES
-- Alice inquiring about John's property
((SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 (SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 'Hi! I''m interested in booking your downtown apartment. Is it available for March 15-18?'),

-- John responding to Alice
((SELECT user_id FROM users WHERE email = 'john.doe@email.com'), 
 (SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 'Hello Alice! Yes, the apartment is available for those dates. I''ll send you the booking details.'),

-- Bob asking about Jane's villa
((SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 (SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 'Quick question about the beachfront villa - is there parking available?'),

-- Jane responding to Bob
((SELECT user_id FROM users WHERE email = 'jane.smith@email.com'), 
 (SELECT user_id FROM users WHERE email = 'bob.wilson@email.com'), 
 'Yes, there''s a private driveway that can accommodate 2 cars. Free parking included!'),

-- Alice thanking admin
((SELECT user_id FROM users WHERE email = 'alice.johnson@email.com'), 
 (SELECT user_id FROM users WHERE email = 'carol.brown@email.com'), 
 'Thank you for managing such a great platform! The booking process was seamless.');
```

**Data Details**:
- **Conversation Threads**: Inquiry-response patterns
- **Realistic Scenarios**: Property inquiries, amenity questions, platform feedback
- **User Interactions**: Guest-Host and Guest-Admin communications
- **Business Context**: Messages relate to actual bookings and properties

---

## Data Verification Queries

After inserting all data, run these queries to verify successful insertion:

### Record Counts
```sql
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
```

**Expected Results**:
```
table_name  | record_count
------------|-------------
Users       | 5
Locations   | 5
Properties  | 5
Bookings    | 5
Payments    | 5
Reviews     | 3
Messages    | 5
```

### View Verification
```sql
SELECT 'Property Details View' as view_name, COUNT(*) as records FROM property_details
UNION ALL
SELECT 'Booking Details View', COUNT(*) FROM booking_details
UNION ALL
SELECT 'Review Details View', COUNT(*) FROM review_details;
```

## Sample Queries Using the Data

### 1. Find all properties in a specific city
```sql
SELECT pd.name, pd.price_per_night, pd.host_name
FROM property_details pd
WHERE pd.city = 'New York';
```

### 2. Get booking details with calculated totals
```sql
SELECT guest_name, property_name, location, nights_stayed, total_price, status
FROM booking_details
ORDER BY created_at DESC;
```

### 3. View all reviews with property and user information
```sql
SELECT reviewer_name, property_name, location, rating, comment
FROM review_details
ORDER BY review_date DESC;
```

### 4. Find all messages between specific users
```sql
SELECT 
    CASE 
        WHEN sender.email = 'alice.johnson@email.com' THEN 'Alice → John'
        ELSE 'John → Alice'
    END as conversation,
    m.message_body,
    m.sent_at
FROM messages m
JOIN users sender ON m.sender_id = sender.user_id
JOIN users recipient ON m.recipient_id = recipient.user_id
WHERE (sender.email = 'alice.johnson@email.com' AND recipient.email = 'john.doe@email.com')
   OR (sender.email = 'john.doe@email.com' AND recipient.email = 'alice.johnson@email.com')
ORDER BY m.sent_at;
```

## Data Relationships Summary

- **John (Host)**: Owns 2 properties (NYC, Aspen)
- **Jane (Host)**: Owns 3 properties (Miami, Boston, Chicago)
- **Alice (Guest)**: Made 3 bookings, wrote 1 review
- **Bob (Guest)**: Made 2 bookings, wrote 2 reviews
- **Carol (Admin)**: Manages platform, receives feedback messages

## Notes

1. **Foreign Key Dependencies**: Data must be inserted in the correct order (users → locations → properties → bookings → payments/reviews/messages)

2. **Business Logic**: Reviews are only created for confirmed bookings, maintaining data integrity

3. **Realistic Scenarios**: The sample data represents realistic booking patterns and user interactions

4. **Geographic Diversity**: Properties span multiple US cities for testing location-based features

5. **Payment Variety**: Uses different payment methods including M-Pesa for international users
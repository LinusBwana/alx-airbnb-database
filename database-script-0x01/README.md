# AirBnB Database Schema - CREATE TABLE Statements

## Overview

This document provides the complete database schema for the AirBnB platform after normalization to achieve **Third Normal Form (3NF)**. The schema includes all necessary tables, constraints, indexes, and views to support a fully functional vacation rental platform.

## Database Design Features

- **Normalization**: Fully normalized to 3NF
- **UUID Primary Keys**: Using UUID v4 for all primary keys
- **Foreign Key Constraints**: Proper referential integrity with CASCADE options
- **Check Constraints**: Data validation at database level
- **Indexes**: Optimized for common query patterns
- **Views**: Convenient access to commonly needed data combinations
- **Triggers**: Automatic timestamp updates

## Prerequisites

```sql
-- Enable UUID extension for uuid_generate_v4()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

## Table Creation Order

**Important**: Tables must be created in this specific order due to foreign key dependencies:

1. `users` - Base user information
2. `locations` - Normalized location data
3. `properties` - Property listings
4. `bookings` - Reservation records
5. `payments` - Payment transactions
6. `reviews` - Property reviews
7. `messages` - User communications

---

## 1. Users Table

**Purpose**: Stores all platform users (guests, hosts, admins)

```sql
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(10) CHECK (role IN ('guest', 'host', 'admin')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

**Key Features**:
- UUID primary key for global uniqueness
- Email uniqueness constraint
- Role-based access control
- Indexed email for fast lookups

---

## 2. Locations Table

**Purpose**: Normalized location data to eliminate redundancy

```sql
CREATE TABLE locations (
    location_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Ensure unique combinations
    UNIQUE(city, state_province, country)
);

CREATE INDEX idx_locations_city ON locations(city);
CREATE INDEX idx_locations_country ON locations(country);
```

**Key Features**:
- Atomic location components (city, state, country)
- Unique constraint prevents duplicate locations
- Indexed for location-based searches
- Supports international locations

---

## 3. Properties Table

**Purpose**: Property listings with references to hosts and locations

```sql
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    location_id UUID NOT NULL REFERENCES locations(location_id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_location_id ON properties(location_id);
CREATE INDEX idx_properties_property_id ON properties(property_id);
```

**Auto-Update Trigger**:
```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_properties_updated_at 
    BEFORE UPDATE ON properties 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
```

**Key Features**:
- References normalized locations
- Automatic updated_at timestamp
- CASCADE delete when host deleted
- RESTRICT delete for locations (prevents orphaned properties)

---

## 4. Bookings Table

**Purpose**: Reservation records linking guests to properties

```sql
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Add constraint to ensure end_date > start_date
    CONSTRAINT chk_booking_dates CHECK (end_date > start_date)
);

CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);
CREATE INDEX idx_bookings_dates ON bookings(start_date, end_date);
```

**Key Features**:
- No calculated total_price field (computed on-demand)
- Date validation constraint
- Status tracking (pending/confirmed/canceled)
- Optimized indexes for date-based queries

---

## 5. Payments Table

**Purpose**: Payment transaction records

```sql
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) CHECK (payment_method IN ('card', 'paypal', 'mpesa')) NOT NULL
);

CREATE INDEX idx_payments_booking_id ON payments(booking_id);
```

**Key Features**:
- Multiple payment methods support
- Links to specific bookings
- Supports partial payments and refunds

---

## 6. Reviews Table

**Purpose**: Property reviews with business rule enforcement

```sql
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Ensure only one review per booking
    UNIQUE(booking_id)
);

CREATE INDEX idx_reviews_booking_id ON reviews(booking_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
```

**Key Features**:
- Links to bookings (ensures reviewer actually stayed)
- One review per booking constraint
- Rating validation (1-5 scale)
- Indexed for rating-based queries

---

## 7. Messages Table

**Purpose**: Communication between platform users

```sql
CREATE TABLE messages (
    message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Prevent self-messaging
    CONSTRAINT chk_different_users CHECK (sender_id != recipient_id)
);

CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);
CREATE INDEX idx_messages_sent_at ON messages(sent_at);
```

**Key Features**:
- Self-referential foreign keys to users
- Prevents self-messaging
- Optimized for message history queries

---

## Database Views

### Property Details View
```sql
CREATE VIEW property_details AS
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.price_per_night,
    CONCAT(l.city, ', ', l.state_province, ', ', l.country) as full_location,
    l.city,
    l.state_province,
    l.country,
    u.first_name || ' ' || u.last_name as host_name,
    u.email as host_email,
    p.created_at,
    p.updated_at
FROM properties p
JOIN locations l ON p.location_id = l.location_id
JOIN users u ON p.host_id = u.user_id;
```

### Booking Details View
```sql
CREATE VIEW booking_details AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    (b.end_date - b.start_date) as nights_stayed,
    p.price_per_night,
    (b.end_date - b.start_date) * p.price_per_night as total_price,
    b.status,
    u.first_name || ' ' || u.last_name as guest_name,
    p.name as property_name,
    CONCAT(l.city, ', ', l.state_province) as location,
    b.created_at
FROM bookings b
JOIN properties p ON b.property_id = p.property_id
JOIN locations l ON p.location_id = l.location_id
JOIN users u ON b.user_id = u.user_id;
```

### Review Details View
```sql
CREATE VIEW review_details AS
SELECT 
    r.review_id,
    r.rating,
    r.comment,
    r.created_at as review_date,
    u.first_name || ' ' || u.last_name as reviewer_name,
    p.name as property_name,
    CONCAT(l.city, ', ', l.state_province) as location,
    b.start_date,
    b.end_date
FROM reviews r
JOIN bookings b ON r.booking_id = b.booking_id
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
JOIN locations l ON p.location_id = l.location_id;
```

## Data Integrity Features

### Foreign Key Constraints
- **CASCADE DELETE**: When parent records are deleted, related child records are automatically removed
- **RESTRICT DELETE**: Prevents deletion if child records exist (for locations)

### Check Constraints
- User roles limited to: `guest`, `host`, `admin`
- Payment methods: `card`, `paypal`, `mpesa`
- Review ratings: 1-5 scale
- Booking dates: end_date must be after start_date
- Messages: sender and recipient must be different users

### Unique Constraints
- User email addresses
- Location combinations (city, state, country)
- One review per booking

## Performance Optimizations

### Strategic Indexing
- **Primary Keys**: Automatic UUID indexes
- **Foreign Keys**: Indexed for JOIN performance
- **Search Fields**: Email, city, country
- **Date Ranges**: Booking dates for availability queries
- **Ratings**: For property ranking queries

### Views for Complex Queries
- Pre-joined data for common use cases
- Calculated fields (total_price, full_location)
- Eliminates need for complex JOINs in application code

## Usage Notes

1. **Always enable the uuid-ossp extension first**
2. **Create tables in the specified order** to avoid foreign key errors
3. **Use views for read operations** to get enriched data
4. **Let triggers handle timestamp updates** automatically
5. **Respect the constraints** - they enforce business rules

## Migration from Original Schema

If migrating from the original non-normalized schema:

1. Create new normalized tables
2. Extract unique locations from existing properties
3. Update property records to reference location IDs
4. Migrate reviews to reference bookings instead of direct property/user pairs
5. Remove calculated fields and update application logic to use views
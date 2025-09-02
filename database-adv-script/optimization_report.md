# Query Optimization Report

## Objective
Optimize a complex query that retrieves booking, user, property, and payment details to improve performance.

---

## Initial Query
The initial query joins **bookings**, **users**, **properties**, and **payments** tables to fetch all related details.  
While functional, it retrieves **too many columns** and uses **inner joins** everywhere, which can increase execution cost.

---

## Performance Analysis
Using `EXPLAIN ANALYZE` on the initial query shows:
- Sequential scans on large tables (e.g., `bookings`, `payments`).
- Multiple joins pulling unnecessary columns.
- Lack of selective filtering conditions.
- Possible missing indexes on `bookings.user_id`, `bookings.property_id`, and `payments.booking_id`.

---

## Refactored Query
Improvements applied:
1. **Reduced selected columns** → fetching only relevant fields (booking ID, user names, property name, payment info).
2. **Changed some joins to LEFT JOIN** → payments may not always exist for a booking, prevents row exclusion.
3. **Indexing suggestion**:
   - `CREATE INDEX idx_bookings_user_id ON bookings(user_id);`
   - `CREATE INDEX idx_bookings_property_id ON bookings(property_id);`
   - `CREATE INDEX idx_payments_booking_id ON payments(booking_id);`

---

## Expected Benefits
- **Smaller dataset** retrieved due to reduced columns.
- **Better join performance** due to appropriate indexing.
- **Increased flexibility** by using LEFT JOIN for optional relationships.
- Overall reduced execution time and improved query efficiency.

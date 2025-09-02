```sql
EXPLAIN ANALYZE
SELECT b.booking_id, u.first_name, u.last_name
FROM bookings b
JOIN users u ON b.user_id = u.user_id
WHERE u.email = 'test@example.com';
```
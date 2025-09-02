# Partitioning Performance Report

## Objective
The `bookings` table was partitioned by **start_date** to improve query performance on large datasets.

## Steps Implemented
1. Dropped the existing `bookings` table and recreated it as a **partitioned table** using `PARTITION BY RANGE (start_date)`.
2. Created partitions for `2023`, `2024`, and `2025`.
3. Ran a test query with **date range filtering** using:
   ```sql
   EXPLAIN ANALYZE
   SELECT booking_id, user_id, property_id, start_date, end_date
   FROM bookings
   WHERE start_date BETWEEN '2024-03-01' AND '2024-03-31'
     AND status = 'confirmed';
   ```

## Observations
- **Before Partitioning**:  
  The database scanned the **entire bookings table**, even for a small date range.
- **After Partitioning**:  
  The query only scanned the relevant partition (`bookings_2024`), reducing the number of rows read.
- **Execution Time Improvement**:  
  Significant reduction in execution time for date-range queries, especially as data volume grows.

## Conclusion
Partitioning large tables by **date ranges** is effective in:
- Reducing query execution time.  
- Minimizing I/O by scanning only relevant partitions.  
- Improving scalability for time-series and booking data.

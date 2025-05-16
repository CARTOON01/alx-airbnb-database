-- 1. Total number of bookings made by each user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name;

-- 2. Rank properties
SELECT 
    property_id,
    property_name,
    total_bookings,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS total_bookings
    FROM properties p
    LEFT JOIN bookings b ON p.property_id = b.property_id
    GROUP BY p.property_id, p.name
) AS booking_counts;

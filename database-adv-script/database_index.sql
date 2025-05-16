EXPLAIN ANALYZE 
SELECT * FROM bookings 
WHERE email = 'brian@example.com';

CREATE INDEX idx_users_email ON users(email);

EXPLAIN ANALYZE 
SELECT * FROM bookings 
WHERE email = 'brian@example.com';

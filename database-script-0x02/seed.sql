CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

INSERT INTO "locations" (location_id, country, state, city, postal_code, lat, lng) VALUES
	(uuid_generate_v4(), 'Kenya', 'Nairobi', 'Nairobi', '00100', -1.2921, 36.8219),
	(uuid_generate_v4(), 'Nigeria', 'Lagos', 'Lagos', '100001', 6.5244, 3.3792);

INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
    (uuid_generate_v4(), 'Alice', 'Kariuki', 'alice.kariuki@example.com', 'hashed_password_1', '+254712345678', 'host'),
    (uuid_generate_v4(), 'Brian', 'Otieno', 'brian.otieno@example.com', 'hashed_password_2', '+254798765432', 'guest'),
    (uuid_generate_v4(), 'Chidinma', 'Okafor', 'chidinma.okafor@example.com', 'hashed_password_3', '+2348012345678', 'host'),
    (uuid_generate_v4(), 'Diana', 'Kamau', 'diana.kamau@example.com', 'hashed_password_4', '+254701112233', 'guest'),
    (uuid_generate_v4(), 'Elijah', 'Adams', 'elijah.adams@example.com', 'hashed_password_5', '+254720987654', 'admin');

INSERT INTO properties (property_id, host_id, name, description, location, pricepernight) VALUES
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Alice'), 
     'Garden View Apartment', 
     'Quiet and cozy apartment surrounded by greenery', 
     (SELECT location_id FROM locations WHERE city = 'Nairobi'), 
     6500.00),
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Chidinma'), 
     'Lagos City Flat', 
     'Chic apartment near Lekki Phase 1 with fast Wi-Fi', 
     (SELECT location_id FROM locations WHERE city = 'Lagos'), 
     12000.00),
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Alice'), 
     'Penthouse Retreat', 
     'Top-floor unit with stunning skyline views and a private jacuzzi', 
     (SELECT location_id FROM locations WHERE city = 'Nairobi'), 
     20000.00);

INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'Garden View Apartment'), 
     (SELECT user_id FROM users WHERE first_name = 'Brian'), 
     '2024-08-05', '2024-08-10', 32500.00, 'confirmed'),
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'Lagos City Flat'), 
     (SELECT user_id FROM users WHERE first_name = 'Diana'), 
     '2024-08-12', '2024-08-14', 24000.00, 'confirmed');

INSERT INTO payments (payment_id, booking_id, amount, payment_method) VALUES
    (uuid_generate_v4(), 
     (SELECT booking_id FROM bookings WHERE total_price = 32500.00), 
     32500.00, 'stripe'),
    (uuid_generate_v4(), 
     (SELECT booking_id FROM bookings WHERE total_price = 24000.00), 
     24000.00, 'credit_card');

INSERT INTO reviews (review_id, property_id, user_id, rating, comment) VALUES
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'Garden View Apartment'), 
     (SELECT user_id FROM users WHERE first_name = 'Brian'), 
     5, 'Peaceful place and super clean! Definitely coming back.'),
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'Lagos City Flat'), 
     (SELECT user_id FROM users WHERE first_name = 'Diana'), 
     4, 'Stylish flat with great amenities, but the water pressure was low.');

INSERT INTO messages (message_id, sender_id, recipient_id, message_body) VALUES
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Brian'), 
     (SELECT user_id FROM users WHERE first_name = 'Alice'), 
     'Hello, is early check-in possible?'),
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Elijah'), 
     (SELECT user_id FROM users WHERE first_name = 'Chidinma'), 
     'Please confirm if the Lagos property has 24/7 security.');

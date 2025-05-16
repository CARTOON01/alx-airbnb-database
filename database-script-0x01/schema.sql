-- Enum types
CREATE TYPE "role" AS ENUM (
  'guest',
  'host',
  'admin'
);

CREATE TYPE "booking_status" AS ENUM (
  'pending',
  'confirmed',
  'canceled'
);

CREATE TYPE "payment_method" AS ENUM (
  'credit_card',
  'paypal',
  'stripe'
);

CREATE TABLE IF NOT EXISTS "users" (
  "user_id" UUID PRIMARY KEY,
  "first_name" VARCHAR NOT NULL,
  "last_name" VARCHAR NOT NULL,
  "email" VARCHAR UNIQUE NOT NULL,
  "password_hash" VARCHAR NOT NULL,
  "phone_number" VARCHAR,
  "role" role NOT NULL,
  "created_at" TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "locations" (
  "location_id" UUID PRIMARY KEY,
  "country" VARCHAR NOT NULL,
  "state" VARCHAR,
  "city" VARCHAR,
  "postal_code" VARCHAR,
  "lat" NUMERIC NOT NULL,
  "lng" NUMERIC NOT NULL
);

CREATE TABLE IF NOT EXISTS "properties" (
  "property_id" UUID PRIMARY KEY,
  "host_id" UUID,
  "name" VARCHAR NOT NULL,
  "description" TEXT NOT NULL,
  "location_id" UUID,
  "price_per_night" NUMERIC NOT NULL,
  "created_at" TIMESTAMP DEFAULT now(),
  "updated_at" TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "bookings" (
  "booking_id" UUID PRIMARY KEY,
  "property_id" UUID,
  "user_id" UUID,
  "start_date" DATE NOT NULL,
  "end_date" DATE NOT NULL,
  "total_price" NUMERIC NOT NULL,
  "status" booking_status NOT NULL,
  "created_at" TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "payments" (
  "payment_id" UUID PRIMARY KEY,
  "booking_id" UUID,
  "amount" NUMERIC NOT NULL,
  "payment_date" TIMESTAMP DEFAULT now(),
  "payment_method" payment_method NOT NULL
);

CREATE TABLE IF NOT EXISTS "reviews" (
  "review_id" UUID PRIMARY KEY,
  "property_id" UUID,
  "user_id" UUID,
  "rating" INTEGER NOT NULL,
  "comment" TEXT NOT NULL,
  "created_at" TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "messages" (
  "message_id" UUID PRIMARY KEY,
  "sender_id" UUID,
  "recipient_id" UUID,
  "message_body" TEXT NOT NULL,
  "sent_at" TIMESTAMP DEFAULT now()
);

CREATE INDEX IF NOT EXISTS "idx_user_email" ON "users" ("email");
CREATE INDEX IF NOT EXISTS "idx_property_location" ON "properties" ("location_id");
CREATE INDEX IF NOT EXISTS "idx_property_host" ON "properties" ("host_id");
CREATE INDEX IF NOT EXISTS "idx_booking_guest" ON "bookings" ("user_id");
CREATE INDEX IF NOT EXISTS "idx_booking_property" ON "bookings" ("property_id");
CREATE INDEX IF NOT EXISTS "idx_payment_booking" ON "payments" ("booking_id");

COMMENT ON COLUMN "properties"."updated_at" IS 'Automatically set on update to current timestamp';
COMMENT ON COLUMN "reviews"."rating" IS 'Rating value must be between 1 and 5';

ALTER TABLE "properties"
  ADD FOREIGN KEY ("host_id") REFERENCES "users" ("user_id"),
  ADD FOREIGN KEY ("location_id") REFERENCES "locations" ("location_id");

ALTER TABLE "bookings"
  ADD FOREIGN KEY ("property_id") REFERENCES "properties" ("property_id"),
  ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "payments"
  ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("booking_id");

ALTER TABLE "reviews"
  ADD FOREIGN KEY ("property_id") REFERENCES "properties" ("property_id"),
  ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "messages"
  ADD FOREIGN KEY ("sender_id") REFERENCES "users" ("user_id"),
  ADD FOREIGN KEY ("recipient_id") REFERENCES "users" ("user_id");

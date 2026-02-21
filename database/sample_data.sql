-- ===============================
-- SAMPLE DATA
-- ===============================

-- Locations
INSERT INTO locations(location_name, address, capacity)
VALUES('Main Campus','123 College Rd',50);

INSERT INTO locations(location_name, address, capacity)
VALUES('North Lot','45 North St',30);

-- Parking Slots
INSERT INTO parking_slot(location_id, status) VALUES(1,'AVAILABLE');
INSERT INTO parking_slot(location_id, status) VALUES(1,'AVAILABLE');
INSERT INTO parking_slot(location_id, status) VALUES(2,'AVAILABLE');
INSERT INTO parking_slot(location_id, status) VALUES(2,'MAINTENANCE');

-- Users
INSERT INTO users(name, contact_no, email, password_hash)
VALUES('Alice','9999000001','alice@example.com','pwdhash1');

INSERT INTO users(name, contact_no, email, password_hash)
VALUES('Bob','9999000002','bob@example.com','pwdhash2');

-- Vehicles
INSERT INTO vehicles(vehicle_no, vehicle_type, user_id)
VALUES('MH12AB1234','Car',1);

INSERT INTO vehicles(vehicle_no, vehicle_type, user_id)
VALUES('MH12CD5678','Bike',2);

-- Pricing
INSERT INTO pricing(location_id, vehicle_type, rate_per_hour)
VALUES(1,'Car',20);

INSERT INTO pricing(location_id, vehicle_type, rate_per_hour)
VALUES(1,'Bike',10);

COMMIT;
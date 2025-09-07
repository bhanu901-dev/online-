CREATE DATABASE Air_Force2;
USE Air_Force2;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(20) UNIQUE,
    source VARCHAR(50),
    destination VARCHAR(50),
    departure_time DATETIME,
    arrival_time DATETIME,
    total_seats INT
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    flight_id INT,
    booking_date DATETIME,
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT,
    seat_number VARCHAR(10),
    is_booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    UNIQUE (flight_id, seat_number)
);

SELECT seat_number
FROM Seats
WHERE flight_id = 1 AND is_booked = FALSE;

SELECT flight_number, source, destination, departure_time, arrival_time
FROM Flights
WHERE source = 'Delhi' AND destination = 'Mumbai';

CREATE TRIGGER after_booking_insert
AFTER INSERT ON Bookings
FOR EACH ROW
UPDATE Seats
SET is_booked = TRUE
WHERE flight_id = NEW.flight_id
AND seat_id = (
    SELECT seat_id FROM Seats 
    WHERE flight_id = NEW.flight_id 
    AND is_booked = FALSE LIMIT 1
);

CREATE TRIGGER after_booking_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
   IF NEW.status = 'Cancelled' THEN
      UPDATE Seats
      SET is_booked = FALSE
      where flight_id=new.flight_id LIMIT 1;
      
      
      
      SELECT f.flight_number, COUNT(b.booking_id) AS total_bookings
FROM Flights f
JOIN Bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_number;

SELECT c.name, f.flight_number, b.booking_date, b.status
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
JOIN Flights f ON b.flight_id = f.flight_id
WHERE c.customer_id = 1;


      
 
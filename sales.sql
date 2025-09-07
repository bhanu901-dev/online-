CREATE DATABASE Online_Retail_Sales;
USE Online_Retail_Sales;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers (name, email, phone)
VALUES ('John Doe', 'john@example.com', '9876543210');

INSERT INTO Products (name, price, stock)
VALUES ('Laptop', 75000, 10),
       ('Phone', 25000, 20);

INSERT INTO Orders (customer_id, order_date)
VALUES (1, '2025-08-20');

INSERT INTO Order_Details (order_id, product_id, quantity)
VALUES (1, 1, 1), (1, 2, 2);

INSERT INTO Payments (order_id, payment_date, amount, payment_method)
VALUES (1, '2025-08-20', 125000, 'Amount');

SELECT c.name, SUM(p.amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.name;

SELECT pr.name, SUM(od.quantity) AS total_sold
FROM Products pr
JOIN Order_Details od ON pr.product_id = od.product_id
GROUP BY pr.name
ORDER BY total_sold DESC;

CREATE VIEW MonthlySales AS
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(p.amount) AS total_sales
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
GROUP BY month;
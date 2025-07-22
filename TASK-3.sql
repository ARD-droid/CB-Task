CREATE DATABASE RetailStore;
USE RetailStore ;

CREATE TABLE Coustomer_table(
Coustomer_id INT PRIMARY KEY,
first_name varchar(100),
last_name varchar(100),
email varchar(100),
phone varchar(20),
addres TEXT, 
Join_date date);

INSERT INTO Coustomer_table(Coustomer_id,first_name,last_name,email,phone,addres,Join_date)
VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '9876543210', '123 Main St', '2023-01-10'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '8765432109', '456 Elm St', '2023-02-12'),
(3, 'Alice', 'Johnson', 'alice.j@email.com', '9988776655', '789 Oak St', '2023-03-05'),
(4, 'Bob', 'Brown', 'bob.b@email.com', '8899776655', '321 Pine St', '2023-03-15'),
(5, 'Charlie', 'Miller', 'charlie.m@email.com', '7788996655', '654 Maple St', '2023-04-01'),
(6, 'Diana', 'Clark', 'diana.c@email.com', '6677889900', '987 Cedar St', '2023-04-15'),
(7, 'Eve', 'Wilson', 'eve.w@email.com', '5566778899', '222 Birch St', '2023-05-10'),
(8, 'Frank', 'Anderson', 'frank.a@email.com', '4455667788', '111 Cherry St', '2023-05-25'),
(9, 'Grace', 'Lee', 'grace.l@email.com', '3344556677', '333 Walnut St', '2023-06-05'),
(10, 'Henry', 'King', 'henry.k@email.com', '2233445566', '444 Spruce St', '2023-06-15');

CREATE TABLE Product_Table(
product_id INT PRIMARY KEY,
product_name varchar(100),
category varchar(50),
price Decimal(10,2),
stock_quantity Int 
);

INSERT INTO Product_Table(product_id,product_name,category,price,stock_quantity)
VALUES
(101, 'Laptop', 'Electronics', 55000.00, 10),
(102, 'Smartphone', 'Electronics', 20000.00, 25),
(103, 'Office Chair', 'Furniture', 5000.00, 15),
(104, 'Bluetooth Speaker', 'Electronics', 1500.00, 40),
(105, 'Desk Lamp', 'Furniture', 1200.00, 30);

CREATE TABLE Orders_Table(
order_id INT PRIMARY KEY,
Coustomer_id INT,
Order_Date DATE,
Total_Amount DECIMAL(10,2),
Order_Status Varchar(20),
FOREIGN KEY (Coustomer_id) REFERENCES Coustomer_table(Coustomer_id)
);


INSERT INTO Orders_table(order_id,Coustomer_id,Order_Date,Total_Amount,Order_Status)
VALUES
(201, 1, '2023-07-01', 55000.00, 'Completed'),
(202, 3, '2023-07-03', 1500.00, 'Completed'),
(203, 5, '2023-07-04', 6200.00, 'Pending'),
(204, 7, '2023-07-05', 20000.00, 'Completed'),
(205, 2, '2023-07-06', 1200.00, 'Cancelled');

UPDATE Orders_Table SET Order_Date = '2025-07-01' WHERE order_id = 201;
UPDATE Orders_Table SET Order_Date = '2025-07-05' WHERE order_id = 202;

UPDATE Orders_Table SET Order_Date = '2025-07-01' WHERE order_id = 203;
UPDATE Orders_Table SET Order_Date = '2025-07-05' WHERE order_id = 204;

CREATE TABLE Orders_Details(
order_detail_id INT PRIMARY KEY,
order_id INT,
product_id INT, 
Quantity INT,
unit_price DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES Orders_Table(order_id),
FOREIGN KEY(product_id) REFERENCES Product_Table(product_id)
);

INSERT INTO Orders_Details(order_detail_id,order_id,product_id,Quantity,unit_price)
VALUES
(301, 201, 101, 1, 55000.00),
(302, 202, 104, 1, 1500.00),
(303, 203, 103, 1, 5000.00),
(304, 203, 105, 1, 1200.00),
(305, 204, 102, 1, 20000.00),
(306, 205, 105, 1, 1200.00);

CREATE TABLE Payments_Table(
payment_id INT Primary key,
order_id INT,
payment_date DATE,
payment_amount DECIMAL(10,2),
payment_method VARCHAR(20),
Foreign key (order_id) References Orders_Table (order_id)
);

INSERT INTO Payments_Table(payment_id,order_id,payment_date,payment_amount,payment_method)
VALUES
(401, 201, '2023-07-01', 55000.00, 'Credit Card'),
(402, 202, '2023-07-03', 1500.00, 'UPI'),
(403, 204, '2023-07-05', 20000.00, 'Cash');

#----------------------------------------QUERIES-------------------------------------------

## Query-1--> Find the Total Number of Orders for Each Customer

SELECT Coustomer_id ,count(order_id) as total_orders
FROM Orders_Table
GROUP BY Coustomer_id ;

## Query-2-->Find the Total Sales Amount for Each Product (Revenue per Product)

Select product_id ,SUM(Quantity*unit_price)
FROM Orders_Details 
GROUP BY product_id;

## Query-3 --> Find the Most Expensive Product Sold

##---  if you just want one highest-priced product
SELECT product_name FROM Product_Table ORDER BY price DESC 
LIMIT 1;

## Use This Query if there might be multiple products with the same highest price.
SELECT product_name FROM Product_Table 
where price=(Select MAX(price) FROM Product_Table);

## Query-4 --> Get the List of Customers Who Have Placed Orders in the Last 30 Days

SELECT Coustomer_id
FROM Orders_Table
WHERE Order_Date >= CURRENT_DATE - INTERVAL 30 DAY;

## Query-5 --> Calculate the Total Amount Paid by Each Customer

SELECT Coustomer_id,SUM(Total_Amount)
FROM Orders_Table 
GROUP BY Coustomer_id;

## Query-6 --> Get the Number of Products Sold by Category

SELECT Product_Table.category,COUNT(Orders_Details.product_id)
FROM Product_Table
INNER JOIN Orders_Details
ON Product_Table.product_id = Orders_Details.product_id
GROUP BY Product_Table.category ;


## Query-7 --> List All Orders That Are Pending (i.e., Orders that haven't been shipped yet)

SELECT Order_id FROM Orders_Table 
WHERE Order_Status = 'Pending' ;

## Query-8 --> Find the Average Order Value (Total Order Amount / Number of Orders)

SELECT (SUM(Total_Amount)/COUNT(order_id)) 
FROM Orders_Table ;

## Query-9 --> List the Top 5 Customers Who Have Spent the Most Money

SELECT Coustomer_id, SUM(Total_Amount) AS Total_Spent
FROM Orders_Table
GROUP BY Coustomer_id
ORDER BY Total_Spent DESC
LIMIT 5;

## Query-10 --> Find the Products That Have Never Been Sold

SELECT product_id, product_name
FROM Product_Table
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM Orders_Details
);


CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Program Files\PostgreSQL\17\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Program Files\PostgreSQL\17\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Program Files\PostgreSQL\17\Orders.csv' 
CSV HEADER;
----------1-----
SELECT *
FROM Books
Where genre='Fiction';
-------2-------
SELECT *
FROM Books
Where published_year>1950;

--------3-------
SELECT * 
FROM Customers
Where country='Canada';
--------4-------
SELECT * 
FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

------5------
SELECT SUM(stock) AS total_stock
FROM Books

------6-------
SELECT *
FROM Books
ORDER BY price DESC
LIMIT 1
------7------
SELECT * FROM Orders
WHERE quantity>1;
-----8-------
SELECT * FROM Orders
WHERE total_amount>20;
------9-------
SELECT DISTINCT(genre) AS Avilable_genre
FROM Books;
-------10-------
SELECT * FROM Books
ORDER BY stock ASC
LIMIT 3;
-----11------
SELECT SUM(total_amount) AS revenue
FROM Orders;
----ADVANCE QUERIES
-----1-----
SELECT b.genre,SUM(o.quantity) AS Total_quantity_sold
FROM Orders o
Join Books b ON b.book_id=o.book_id
GROUP BY b.genre;
-----2-----
SELECT genre, AVG(price) AS avg_price FROM Books
WHERE genre='Fantasy'
GROUP BY genre;
-----3-----
SELECT c.name,o.customer_id,Count(o.order_id) AS Total_order
FROM Orders o
JOIN Customers c ON c.customer_id=o.customer_id
GROUP BY o.customer_id,c.name
HAVING Count(o.order_id)>=2;
-----4-----
SELECT o.book_id,b.title,COUNT(o.order_id)AS Total_Count
FROM Orders o
JOIN Books b ON b.book_id=o.book_id
GROUP BY o.book_id,b.title
ORDER BY Total_Count Desc 
LIMIT 1;
-----5-----
SELECT * FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC 
LIMIT 3;
-----6-----
SELECT b.author,SUM(o.quantity) AS Total_quantity
FROM Orders o JOIN Books b ON b.book_id=o.book_id
GROUP BY b.author;
-----7-----
SELECT DISTINCT(c.city),O.total_amount
FROM Customers c
JOIN Orders o ON c.customer_id=o.customer_id
WHERE o.total_amount>30;
-----8-----
SELECT c.customer_id,c.name,SUM(o.total_amount) AS Total_spent
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY Total_spent DESC
LIMIT 1;
-----9-----
SELECT b.book_id,b.title,b.stock,COALESCE(SUM(o.quantity),0)AS Order_Quantity,
b.stock-COALESCE(SUM(o.quantity),0)AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY  b.book_id ASC


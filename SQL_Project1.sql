-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
-- \c OnlineBookstore;
USE OnlineBookstore;
-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
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

-- 1) Retrieve all books in the "Fiction" genre:
SELECT *
FROM Books
WHERE Genre = "Fiction";

-- 2) Find books published after the year 1950:
SELECT *
FROM Books
WHERE Published_Year>"1950";

-- 3) List all customers from the Canada:
SELECT *
FROM Customers
WHERE Country="Canada";

-- 4) Show orders placed in November 2023:
SELECT *
FROM Orders
WHERE Order_Date BETWEEN "2023-11-01" AND "2023-11-30";

SELECT *
FROM Orders
WHERE YEAR(Order_Date) = 2023
AND MONTH(Order_Date) = 11;

SELECT *
FROM Orders
WHERE EXTRACT(YEAR FROM Order_Date) = 2023
AND EXTRACT(MONTH FROM Order_Date) = 11;

-- 5) Retrieve the total stock of books available:
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT *
FROM Books
WHERE Price = (SELECT MAX(Price)
			   FROM Books);
               
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT t1.Name,t1.Customer_ID
FROM Customers AS t1
INNER JOIN Orders AS t2
ON t1.Customer_Id=t2.Customer_ID
WHERE Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT *
FROM Orders
WHERE Total_Amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT Genre
FROM Books;

-- 10) Find the book with the lowest stock:
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;

SELECT *
FROM Books
WHERE Stock = (SELECT MIN(Stock)
			   FROM Books);

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS Revenue
FROM Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT t1.Genre,SUM(t2.Quantity) AS total_books_sold
FROM Books AS t1
INNER JOIN Orders AS t2
ON t1.Book_ID=t2.Book_ID
GROUP BY t1.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre="Fantasy";

-- 3) List customers who have placed at least 2 orders:
SELECT t1.Name,t1.Customer_ID,COUNT(t2.Order_ID) AS Order_Count
FROM Customers AS t1
INNER JOIN Orders AS t2
ON t1.Customer_Id = t2.Customer_ID
GROUP BY t1.Customer_ID,t1.Name
HAVING COUNT(t2.Order_ID)>=2;

-- 4) Find the most frequently ordered book:
SELECT t2.Book_ID,t1.Title,COUNT(t2.Book_ID) AS Total_Count
FROM Books AS t1
JOIN Orders AS t2
ON t1.Book_ID=t2.Book_ID
GROUP BY t2.Book_ID,t1.Title
ORDER BY COUNT(t2.Book_ID) DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT *
FROM Books
WHERE Genre = "Fantasy"
ORDER BY Price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT t1.Author,SUM(t2.Quantity) AS Total_Books_Sold
FROM Books AS t1
JOIN Orders AS t2
ON t1.Book_ID=t2.Book_ID
GROUP BY t1.Author;

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT t1.City,Total_Amount
FROM Customers AS t1
JOIN Orders AS t2
ON t1.Customer_ID=t2.Customer_ID
WHERE t2.Total_Amount>30;

-- 8) Find the customer who spent the most on orders:
SELECT t1.Customer_ID,t1.Name,SUM(t2.Total_Amount) AS Total_Spent
FROM Customers AS t1
JOIN Orders AS t2
ON t1.Customer_ID=t2.Customer_ID
GROUP BY t1.Customer_ID,t1.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT t1.Book_ID,t1.Title,t1.Stock,COALESCE(SUM(t2.Quantity),0) AS Total_Sold,
t1.Stock-COALESCE(SUM(t2.Quantity),0) AS Stock_Remaining
FROM Books AS t1
LEFT JOIN Orders AS t2
ON t1.Book_ID=t2.Book_ID
GROUP BY t1.Book_ID
ORDER BY t1.Book_id;






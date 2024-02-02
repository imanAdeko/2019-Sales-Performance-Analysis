USE Sale_2019;

SELECT * FROM Sales_January_2019;

SELECT * FROM Sales_February_2019;

--Check the data types of the columns in the January table
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Sales_January_2019';

--Check the data types of the columns in the February table
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Sales_February_2019';

--Format Order_ID for February table appropriately
UPDATE Sales_February_2019
SET Order_ID = RIGHT('0' + CAST(DATEPART(DAY, Order_ID) AS VARCHAR(2)), 2) +
				RIGHT('0' + CAST(DATEPART(MONTH, Order_ID) AS VARCHAR(2)), 2) +
				RIGHT(CAST(YEAR(Order_ID) AS VARCHAR(4)), 2);

--Change Order_ID in February from varchar to int
ALTER TABLE Sales_February_2019
ALTER COLUMN Order_ID int;

SELECT * FROM Sales_March_2019;
SELECT * FROM Sales_April_2019;
SELECT * FROM Sales_May_2019;
SELECT * FROM Sales_June_2019;
SELECT * FROM Sales_July_2019;
SELECT * FROM Sales_August_2019;
SELECT * FROM Sales_September_2019;
SELECT * FROM Sales_October_2019;
SELECT * FROM Sales_November_2019;
SELECT * FROM Sales_December_2019;

--Create an overall_sales table that will hold data from the other tables
CREATE TABLE overall_sales(
order_id int,
product varchar(50),
quantity_ordered tinyint,
price_each float,
order_date datetime2,
purchase_address varchar(50)
);

--Concatenate data from other tables into overall_sales
INSERT INTO overall_sales
SELECT * FROM Sales_January_2019
UNION ALL
SELECT * FROM Sales_February_2019
UNION ALL
SELECT * FROM Sales_March_2019
UNION ALL
SELECT * FROM Sales_April_2019
UNION ALL
SELECT * FROM Sales_May_2019
UNION ALL
SELECT * FROM Sales_June_2019
UNION ALL
SELECT * FROM Sales_July_2019
UNION ALL
SELECT * FROM Sales_August_2019
UNION ALL 
SELECT * FROM Sales_September_2019
UNION ALL
SELECT * FROM Sales_October_2019
UNION ALL
SELECT * FROM Sales_November_2019
UNION ALL
SELECT * FROM Sales_December_2019;


--Check for unique products
SELECT DISTINCT product 
FROM overall_sales
ORDER BY product;

--Delete data where product is null
DELETE FROM overall_sales
WHERE product IS NULL;

--Delete data where product is Product
DELETE FROM overall_sales
WHERE product = 'Product';

--Check data types for columns in overall_sales
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'overall_sales';

--Add a revenue column
ALTER TABLE overall_sales
ADD revenue float;

--Update revenue as quantity_ordered * price_each
--Rounded to 2 decimal places for better readability
UPDATE overall_sales
SET revenue = ROUND(quantity_ordered * price_each, 2);

--Add an order_hour column
ALTER TABLE overall_sales
ADD order_hour int;

--Update the order_hour as the hour part of order_date
UPDATE overall_sales
SET order_hour = DATEPART(HOUR, order_date);

--Convert order_date from datetime2 to date
ALTER TABLE overall_sales
ALTER COLUMN order_date date;

--Format order_date properly
UPDATE overall_sales
SET order_date = FORMAT(order_date, '20dd-MM-yy');

--Create new column for city
ALTER TABLE overall_sales
ADD city VARCHAR(50);

--Update city as city name extracted from purchase_address
UPDATE overall_sales
SET city = SUBSTRING(
				purchase_address,
				CHARINDEX(', ', purchase_address) + 2,								--Index of comma and space 
				(CHARINDEX(',', purchase_address, CHARINDEX(', ', purchase_address) + 2) - --To get length of substring,
				(CHARINDEX(', ', purchase_address) + 2))	--Subtract index of first comma from index of the second
				);


SELECT TOP 5 * FROM overall_sales;

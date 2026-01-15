--create and import the data
drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

-- Data explorataion
select count(*) from zepto;

-- finding all the data what is in it.
select * from zepto;

-- finding null values if there are they
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;


-- How manu products are there in our warehouse
select distinct category from zepto;



-- products stock
select  outOfStock , count(sku_id) from zepto group by outofstock;

--product names present multiple times
select name, count(sku_id) as  "No._of_products"
from zepto 
group by name 
having count(sku_id) > 1
order by count(sku_id) desc


--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;




-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
select name, mrp, discountpercent from zepto order by discountpercent DESC Limit 10;


--Q2.What are the Products with High MRP but Out of Stock
select distinct(name) , mrp , outOfStock from zepto where outOfStock='True'  and mrp>250 order by mrp desc;



--Q3.Calculate Estimated Revenue for each category
select distinct category , sum(discountedsellingprice *  availablequantity) as total_revenue
from zepto
group by category
order by total_revenue desc;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name , mrp , discountPercent
from zepto 
where mrp > 500 and discountPercent<10
order by mrp desc, discountPercent desc;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select distinct category, round(avg(discountPercent),2) as avg_discount 
from zepto 
group by category
order by avg_discount desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
with my_per_gm as(
select distinct name, round (discountedsellingprice/weightingms , 2)as price_per_gm
from zepto
where weightingms > 100 
)
select * from my_per_gm order by price_per_gm desc;

--Q7.Group the products into categories like Low, Medium, Bulk.


select distinct name , weightingms,
case when weightingms < 1000 then 'Low'
     when weightingms < 5000 then 'Medium'
	 else 'Bulk'
     end as weight_category
from zepto;

--Q8.What is the Total Inventory Weight Per Category 
select category, 
sum(availableQuantity*weightingms) as total_stock
from zepto 
group by category
order by total_stock desc;

-- project by dev charaya.. 

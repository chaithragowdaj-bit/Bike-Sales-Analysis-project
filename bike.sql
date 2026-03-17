--checking whether the table is loaded or not
select * from bikesales

--loaded successfully

-- Overall Sales Performance

-- What is the total revenue, total profit, and total cost for the dataset?
select sum(revenue) as total_revenue,
sum(profit) as total_profit,
sum(cost) as total_cost
from bikesales;

--total_revenue=363527
--total_profit = 164551
--total_cost =198976

-- What is our profit margin?
--profit margin formula
--(total_profit/total_revenue) * 100
SELECT 
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,
ROUND(((SUM(profit) / NULLIF(SUM(revenue),0)) * 100)::numeric, 2) AS profit_margin
FROM bikesales;

--profit_margin = 45.27%

-- Sales Trend

-- Which day generated the highest revenue?
select day, date, sum(revenue) as total_revenue
from bikesales
group by day, date
order by total_revenue desc
limit 1;

--day 19 means(19/12/2021) is highest revenue generated

-- Are there any patterns in bike sales?
SELECT 
TRIM(TO_CHAR(date,'Day')) AS day,
SUM(revenue) AS total_revenue
FROM bikesales
GROUP BY TRIM(TO_CHAR(date,'Day'))
ORDER BY total_revenue DESC;

--"Sunday"	114211
--"Wednesday"	51810
--"Monday"	50272
--"Saturday"	49190
--"Friday"	46094
--"Thursday"	28032
--"Tuesday"	23918

--Sunday is the peak sales day, with more revenue generated on Sunday. whereas Tuesday is the least with the least generated.
--again, Wednesday started to get more sales, and it went on quite well on the other days.

-- Customer Demographics

-- Which age group buys the most bikes?

select 
age_group, 
sum(revenue) as total_revenue,
count(*) as transactions
from bikesales
group by age_group
order by total_revenue desc;

--adult group(35-64) is the group of people who buy the most bikes compared to others age_group category.
--"Adults (35-64)"	208551	48
--"Young Adults (25-34)"	119646	31
--"Youth (<25)"	35330	10


-- Is there a difference in purchases between male and female customers?
select sum(revenue) as total_revenue, 
customer_gender,
count(*) as transactions
from bikesales
group by customer_gender
order by total_revenue desc;

--Yes, the most customer who buys the most bikes are 50, and male customers' purchases are less female(revenue=216049)
--let's see in the female gender which age_group category buys the most

select sum(revenue) as total_revenue,
age_group,
count(*) transactions
from bikesales
where customer_gender='F'
group by age_group
order by total_revenue desc
limit 1;

--most of female under adults age_group purchases the bike more
--

-- Geographic Insights

-- Which country and state have the highest sales?

--country wise
select country,
sum(revenue) as total_revenue
from bikesales
group by country
order by total_revenue desc;

--"UNITED STATES"	135784
--"AUSTRALIA"	111506
--"FRANCE"	46175


--state wise
select state,
sum(revenue) as total_revenue
from bikesales
group by state
order by total_revenue desc;
--"California"	75004
--"New South Wales"	43467
--"Queensland"	39140
--"Washington"	31190
--"Oregon"	29590


-- Order Behavior

-- What is the average order quantity per transaction?
select 
round(avg(order_quantity) :: numeric, 2) as avg_order_quantity
from bikesales

-- most people buy 1-2 quantities per transactions

-- Are there large bulk purchases affecting revenue?
select
order_quantity,
sum(revenue) as total_revenue,
count(*) as transactions
from bikesales
group by order_quantity
order by total_revenue desc;

--4	162648	21
--1	83066	42
--2	63084	16
--3	54729	10

-- Profitability Analysis

-- Which products have high revenue but low profit?
select product_description,
sum(revenue) as total_revenue,
sum(profit) as total_profit
from bikesales
group by product_description
order by total_revenue desc, total_profit asc;

--"Mountain-200 Black"	176715	80311
--"Mountain-200 Silver"	116000	52700
--"Mountain-100 Black"	33750	14770
--"Mountain-400-W Silver"	21532	9772

-- Are there any products where the cost is too high compared to the price?
select product_description,
product_category
from bikesales
where unit_cost > unit_price;
--no

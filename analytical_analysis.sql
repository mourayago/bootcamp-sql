--What is the total of revenue of 1997

select 
round(sum((od.unit_price* od.quantity)*(1-od.discount))::numeric,0) as revenue
from orders as o
left join order_details as od on od.order_id = o.order_id 
where extract(year from o.order_date) = '1997';

--Make an analysis of the monthly growth and the ytd mesaure

with monthly_sales as (
select 
	to_char(o.order_date , 'YYYY-MM') as year_month,
	round(sum((od.unit_price* od.quantity)*(1-od.discount))::numeric,2) as revenue
from orders o 
left join order_details as od on od.order_id = o.order_id 
group by 1
)
select 
year_month,
revenue as month_revenue,
(round(revenue/lag(revenue) over (order by year_month),4)-1)*100.00 "%_mom",
sum(revenue) over (order by year_month) ytd_revenue
from monthly_sales

-- Make an Anlysis comparing mtd values in the month and mtd of the last year 
WITH daily_sales AS (
    SELECT 
        order_date,
        ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))::numeric, 2) AS revenue
    FROM orders o
    LEFT JOIN order_details od ON o.order_id = od.order_id
    --WHERE o.order_date >= '1996-08-01'
    GROUP BY 1
    ORDER BY 1 ASC
),
aggregated_sales AS (
    SELECT 
        order_date,
        revenue,
        SUM(revenue) OVER (PARTITION BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date) ORDER BY order_date) AS mtd,
        SUM(revenue) OVER (PARTITION BY EXTRACT(YEAR FROM order_date) ORDER BY order_date) AS ytd
    FROM daily_sales
)
SELECT 
    ds.order_date,
    ds.revenue,
    ds.mtd,
    ds.ytd,
    COALESCE(lag_ds.mtd, 0) AS mtd_12, -- Month-to-date from the same month last year
    COALESCE(lag_ds.ytd, 0) AS ytd_1   -- Year-to-date from the same year last year
FROM aggregated_sales ds
LEFT JOIN aggregated_sales lag_ds
    ON EXTRACT(YEAR FROM ds.order_date) = EXTRACT(YEAR FROM lag_ds.order_date) + 1
   AND EXTRACT(MONTH FROM ds.order_date) = EXTRACT(MONTH FROM lag_ds.order_date)
   AND EXTRACT(DAY FROM ds.order_date) >= EXTRACT(DAY FROM lag_ds.order_date)
 where ds.order_date >= '1998-01-01'
ORDER BY ds.order_date;


-- clients in five revenue groups
SELECT 
customers.company_name, 
SUM(order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)) AS total,
NTILE(5) OVER (ORDER BY SUM(order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)) DESC) AS group_number
FROM 
    customers
INNER JOIN 
    orders ON customers.customer_id = orders.customer_id
INNER JOIN 
    order_details ON order_details.order_id = orders.order_id
GROUP BY 
    customers.company_name
ORDER BY 
    total DESC;
    
   --top 10 more selled products   
   select 
   p.product_name ,
   sum(od.quantity)as qtd_sales
   from order_details od 
   left join products p on p.product_id = od.product_id 
   group by 1
   order by 2 desc 
   limit 10
   
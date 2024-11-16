-- 1. Obter todas as colunas das tabelas Clientes, Pedidos e Fornecedores
SELECT 
*
FROM customers as c
LEFT JOIN orders as o on c.customer_id = o.customer_id 
LEFT JOIN order_details as od on od.order_id = o.order_id
LEFT JOIN products as p on p.product_id = od.product_id
LEFT JOIN suppliers as s on s.supplier_id = p.supplier_id


-- 2. Obter todos os Clientes em ordem alfabética por país e nome
SELECT
contact_name,
country,
* 
from customers as c
order by c.contact_name asc, country asc


-- 3. Obter os 5 pedidos mais antigos
select 
* 
from orders as o 
order by order_date asc
limit 5


-- 4. Obter a contagem de todos os Pedidos feitos durante 1997
select 
count(*)
from orders
where extract(YEAR  from order_date) = 1997

-- 5. Obter os nomes de todas as pessoas de contato onde a pessoa é um gerente, em ordem alfabética

select 
*
FROM EMPLOYEES

-- 6. Obter todos os pedidos feitos em 19 de maio de 1997

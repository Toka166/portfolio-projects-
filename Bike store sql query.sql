create table bikesales
(order_id int,
customers varchar(100),
city varchar(100),
state varchar(100),
order_date date,
total_units int,
Total_revenue float,
product_name varchar(100),
category_name varchar(100),
store_name varchar(100),
sales_rep varchar(100))
insert into bikesales
select 
    ord.order_id,
	CONCAT(cus.first_name ,' ' ,cus.last_name) AS 'customers',
	cus.city,
	cus.state,
	order_date,
	sum(quantity) as 'total_units',
	sum(quantity * ite.list_price) as 'Total_revenue',
	product_name,
	category_name,
	store_name,
	CONCAT(sta.first_name,' ', sta.last_name) as 'sales_rep'
from  Bikestores.sales.customers cus
join Bikestores.sales.orders  ord
on cus.customer_id = ord.customer_id
join Bikestores.sales.order_items ite
on ord.order_id = ite.order_id
join Bikestores.production.products pro
on ite.product_id = pro.product_id
join Bikestores.production.categories cat
on pro.category_id = cat.category_id
join Bikestores.sales.stores sto
on ord.store_id = sto.store_id
join Bikestores.sales.staffs sta
on ord.staff_id = sta.staff_id
group by 
    ord.order_id,
	CONCAT(cus.first_name ,' ' ,cus.last_name) ,
	cus.city,
	cus.state,
	order_date,
	product_name,
	category_name,
	store_name,
	CONCAT(sta.first_name,' ', sta.last_name)
order by 
     order_id

select * from bikesales
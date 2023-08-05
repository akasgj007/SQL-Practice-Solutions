-- Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped on time and "Late" if the order shipped late.Order by employee last_name, then by first_name, and then descending by number of orders.
select
e.first_name,e.last_name,
count(o.order_id) as num_orders,
(
  case
  	when o.shipped_date<o.required_date then 'On Time'
  	else 'Late' end
) as shipped 
from orders o 
join employees e 
on e.employee_id = o.employee_id
group by e.first_name,e.last_name,shipped
order by e.last_name,e.first_name,num_orders desc;

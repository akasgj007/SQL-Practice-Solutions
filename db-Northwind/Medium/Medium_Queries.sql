-- Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table
select 
product_name,company_name,category_name
from products p 
join suppliers s 
on p.supplier_id = s.supplier_id
join categories c 
on p.category_id = c.category_id;

-- Show the category_name and the average product unit price for each category rounded to 2 decimal places.
select category_name,
round(avg(unit_price),2) as avg_unit_price
from categories
join products
on categories.category_id = products.category_id
group by category_name;

-- Show the city, company_name, contact_name from the customers and suppliers table merged together.Create a column which contains 'customers' or 'suppliers' depending on the table it came from.
select
  city,
  company_name,
  contact_name,
  'Customers' as come_from
from customers
union all
select
  city,
  company_name,
  contact_name,
  'Suppliers' as come_from
from suppliers;






-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quatity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by total_quantity desc;


-- Determine the distribution of orders by hour of the day.

select hour(order_time), count(order_id) from orders
group by hour(order_time);


-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by pizza_types.category ;

-- Group the orders by date and calculate the average number of pizzas ordered per day.


select sum(order_details.quatity), orders.order_date
from orders join order_details
on order_details.order_id =	orders.order_id
group by orders.order_date;



-- Determine the top 3 most ordered pizza types based on revenue.

SELECT pizza_types.name,
SUM(order_details.quatity * pizzas.price) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC
LIMIT 3;




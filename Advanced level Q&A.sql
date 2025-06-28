-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.name AS pizza_type,
    ROUND(SUM(od.quatity * p.price), 2) AS type_revenue,
    ROUND(
        (SUM(od.quatity * p.price) / 
         (SELECT SUM(od2.quatity * p2.price)
          FROM order_details od2
          JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id)) * 100, 2
    ) AS revenue_percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue_percentage DESC;






-- Analyze the cumulative revenue generated over time.


SELECT 
    o.order_date,
    ROUND(SUM(od.quatity * p.price), 2) AS daily_revenue,
    ROUND(SUM(SUM(od.quatity * p.price)) OVER (ORDER BY o.order_date), 2) AS cumulative_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_date
ORDER BY o.order_date;





-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT 
    category,
    pizza_type,
    total_revenue
FROM (
    SELECT 
        pt.category,
        pt.name AS pizza_type,
        SUM(od.quatity * p.price) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY pt.category ORDER BY SUM(od.quatity * p.price) DESC) AS rn
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
) ranked
WHERE rn <= 3
ORDER BY category, total_revenue DESC ;



use operations;
--- Net Revenue by City
select r.city, 
       sum(order_amount - discount_amount) as net_revenue
from orders as o
join restaurants as r
on o.restaurant_id = r.restaurant_id
where order_status = 'Delivered'
group by r.city
order by net_revenue desc;

--- Cancellation Rate
select round(count(case when order_status = 'Cancelled' then 1 end) * 100.0 /count(*),2) as Cancellation_order_rate
from orders;

--- Top Cuisine by Order Volume & AOV
select r.cuisine ,
       count(o.order_id) as total_orders,
       avg(o.order_amount - o.discount_amount) as avg_ordervalue
from orders o
join restaurants r
on o.restaurant_id = r.restaurant_id
where o.order_status = 'Delivered'
group by r.cuisine
order by total_orders desc
limit 1;

--- Inactive Users
select u.user_id, 
       u.user_name, 
       u.city, 
       u.signup_date
from users u
left join orders o
on u.user_id = o.user_id
where o.order_id is null;

--- Peak Ordering Hours
select 
	case 
      when extract(hour from order_date) between 6 and 11 then 'Morining (6-11)'
      when extract(hour from order_date) between 12 and 16 then 'Afternoon (12-16)'
      when extract(hour from order_date) between 17 and 20 then 'Evening (17-20)'
      else 'night (21-24)'
    End as time_slot,
    count(order_id) as delivered_orders
from orders
where order_status = 'Delivered'
group by 1
order by order_status;

--- Late Delivery Rate
select round(count(case when d.actual_mins > d.estimated_mins then 1 end) * 100.0/ count(*),2) as late_delivered_rate
from deliveries d
join orders o
on d.order_id = o.order_id
where order_status = 'Delivered';

--- Rider Efficiency Ranking
select rider_id,
       count(delivery_id) as total_delivery,
	   round(avg(actual_mins - estimated_mins),2) as avg_delay_mins,
       dense_rank() over (order by avg(actual_mins - estimated_mins) asc) as efficiency_rank
from deliveries
group by rider_id
order by efficiency_rank;

--- Customer Order Frequency & Gap
select u.user_id, 
       u.user_name, 
       count(o.order_id) as total_orders,
       datediff (max(o.order_date) , min(o.order_date)) as day_between_first_and_last
from users u 
join orders o
on u.user_id = o.user_id
where o.order_status = 'Delivered'
group by u.user_id, u.user_name
having count(o.order_id) > 1
order by day_between_first_and_last desc;

--- Running Revenue Total
select order_id,
       order_date,
       (order_amount - discount_amount) As net_revenue,
       sum(order_amount - discount_amount) over (order by order_date asc 
       rows between unbounded preceding and current row) as running_total_revenue
from orders
where order_status = 'Delivered'
order by order_date asc;

--- Top Restaurant per City
with restaurant_revenue as(
select r.city,
       r.restaurant_name,
       sum(o.order_amount - o.discount_amount) as total_revenue,
       row_number() over(partition by r.city 
       order by sum(o.order_amount - o.discount_amount) desc) as city_rank
from orders o 
join restaurants r
on r.restaurant_id = o.restaurant_id
where o.order_status = 'Delivered'
group by r.city, r.restaurant_name
)
select city,
       restaurant_name,
	   total_revenue
from restaurant_revenue
where city_rank = 1;

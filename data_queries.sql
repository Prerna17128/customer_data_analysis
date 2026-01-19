-- Total revenue by age group
select age_group , 
sum(purchase_amount) from customer 
group by age_group
--
select subscription_status,
count(customer_id) as repeat_buyer
from customer 
where previous_purchases > 5
group by subscription_status
--what are top 3 most purchased item of each category
with item_count as(
select category ,
item_purchased,
COUNT(customer_id) as Total_ORDER,
ROW_NUMBER() OVER(PARTITION BY category order by COUNT(customer_id) DESC) as item_rank
from customer
group by category , item_purchased
)

select item_rank, category , item_purchased , Total_order
from item_count
where item_rank <= 3
-- are customers repeat buyers also likely to subscriber

with customer_type as(
select customer_id, previous_purchases,
CASE
     WHEN previous_purchases = 1 THEN 'New'
     WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
     ELSE 'Loyal'
     END as customer_segment
from customer
)
select customer_segment , count(*) as number_of_customer 
from customer_type group by customer_segment
--

select item_purchased , 
	round(100*sum(case WHEN discount_applied = 'Yes' THEN 1 else 0 END	)/100,2) as percentage_purchase
	from customer where discount_applied = 'Yes'
	group by item_purchased
	order by percentage_purchase desc limit 5

--




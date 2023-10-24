drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
VALUES (1,'2017-09-23'),
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date);

INSERT INTO users(userid,signup_date)
values(1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid integer, created_date date, product_id integer);

INSERT INTO sales(userid,created_date,product_id)
VALUES (1,'2017-04-19',2),
(3,'2020-07-20',3),
(2,'2019-10-23',2),
(1,'2019-10-23',1),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(1,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-11-03',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);

drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

select * from sales;
select * from users;
select * from goldusers_signup;
select * from product;

Here is the Zomato or Swiggy like Food delivery Company dataset created for learning experiecnce

1. Whats is the total amount each customer spent on Zomato? 

select a.userid,sum(b.price) tot_amt_spent from sales a inner join product b on a.product_id = b.product_id
group by a.userid;

2. How many days has each customer ordered?

select userid, count(distinct created_date) distinct_date from sales group by userid;

3. What was the first product purchased by each of the customer? 
select * from 
(select *, rank() over(partition by userid order by created_date) rnk from sales) a where rnk = 1;

4. What is the most purchased Item on the menu and how many times it was purchased by all customers? 

select product_id, count(product_id) from sales group by product_id order by count(product_id) desc;  

Product_id 2 is the most purchased item on the menu. So the company can give more importance for this product for example in inventory and marketing.
Lets count how many times the product_id 2 purchased by each user. 

select * from sales;

5. Which item was the most popular item for each of the customer ?
select * from 
(select *,rank() over(partition by userid order by cnt desc) rnk from
(select userid,product_id, count(product_id) from sales group by userid, product_id)a)b
where rnk = 1;

select * from sales;
select * from users;
select * from goldusers_signup;
select * from product;

6. Which item was purchased by the customer after they become a member? 

select * from 
(select c.*, rank() over(partition by userid order by created_date ) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join 
goldusers_signup b on a.userid=b.userid and created_date >= gold_signup_date) c)d where rnk=1;

7. Which item was purchased by the customer just before they become a member ?

select * from 
(select c.*, rank() over(partition by userid order by created_date desc ) rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join 
goldusers_signup b on a.userid=b.userid and created_date <= gold_signup_date) c)d where rnk=1;

8. What is the total orders and amount spent by each customer before they become a member ? 

select userid, count(created_date) tot_orders,sum(price) tot_amt_spent from
(select c.*, d.price from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join 
goldusers_signup b on a.userid=b.userid and created_date <= gold_signup_date)c inner join product d on c.product_id=d.product_id )e
group by userid;



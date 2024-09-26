
--- OBJECTIVE QUESTIONS 
--- Question 1 
select id, username, coalesce(created_at, 'Unknown') as created_at from users
select id, image_url, user_id, coalesce(created_dat, 'Unknown') as created_dat from photos
select id, comment_text, user_id, photo_id, coalesce(created_at, 'Unknown') as created_at from comments
select user_id, photo_id, coalesce(created_at, 'Unknown') as created_at from likes
select follower_id, followee_id, coalesce(created_at, 'Unknown') as created_at from follows
select id, tag_name, coalesce(created_at, 'Unknown') as created_at from tags
select coalesce(photo_id, 'Unknown') as photo_id, tag_id from photo_tags

 --- Question 2 
SELECT u.id, u.username, count(p.id) as no_of_posts, count(l.user_id) as no_of_likes, count(c.id) as no_of_comments
from Users u join Photos p 
on u.id = p.user_id
join Likes l 
on p.user_id = l.user_id 
join Comments c
on l.user_id = c.user_id
Group by u.id, u.username
order by no_of_posts desc, no_of_likes desc, no_of_comments desc

--- Question 3 
select round((select count(*) from photo_tags)/ (select count(*) from photos)) as avg_tag_per_post	

--- Question 4
with cte as (SELECT username, COUNT(*) AS total_likes
FROM users
INNER JOIN likes
ON users.id = likes.user_id
INNER JOIN comments
ON likes.user_id = comments.user_id
GROUP BY username)

select *, dense_rank() over(order by total_likes desc) as ranking
from cte 
order by ranking 

--- Question 5 
--- Followings Count Query
SELECT u.username, count(f.follower_id) AS following
FROM follows f 
INNER JOIN users u
ON f.follower_id = u.id 
GROUP BY u.username 
ORDER BY following DESC
limit 5

--- Follower Count Query
select followee_id, count(follower_id) as follower_count
from follows
group by followee_id
order by follower_count desc
limit 5

--- Question 6
--- Average likes per user 
SELECT AVG(likes_count) as avg_likes_per_user
FROM (
select user_id, count(*)  as likes_count from likes
group by user_id
order by likes_count desc) as user_likes;

--- Average comments per user
SELECT AVG(comments_count) as avg_comments_per_user
FROM (
select user_id, count(*)  as comments_count from comments
group by user_id
order by comments_count desc) as user_comments;

--- Question 7
SELECT u.username, count(l.user_id) AS count_of_likes
FROM Likes l
RIGHT JOIN Users u 
ON u.id = l.user_id
GROUP BY u.username
HAVING count_of_likes = 0;

--- Question 8
SELECT t.tag_name, Count(t.tag_name) AS "tags count"
FROM   tags t
INNER JOIN photo_tags pt
ON t.id = pt.tag_id
GROUP  BY t.tag_name
ORDER  BY Count(t.tag_name) DESC
LIMIT  5;

--- Question 9
--- Total no of likes query
select user_id, count(*) as total_no_likes
from likes
group by user_id
order by total_no_likes desc

---Total no of comments query
select user_id, count(*) as total_no_comments
from comments
group by user_id
order by total_no_comments desc

--- Total no of tags query
select photo_id, count(*) as total_no_tags
from photo_tags
group by photo_id
order by total_no_tags desc

---- Question 10 
with cte as (select user_id, count(*) as total_no_likes
from likes
group by user_id)

select *, row_number() over(order by total_no_likes desc) as ranking
from cte
order by ranking

--- Question 11
with avglikes as 
(select avg(l.photo_id) as avg_likes, pt.tag_id
from likes l
join photo_tags pt
on l.photo_id = pt.photo_id
group by pt.tag_id)

select c.avg_likes, t.tag_name
from avglikes c  
join tags t
on c.tag_id = t.id
order by avg_likes desc

--- Question 12
select f1.follower_id, f1.followee_id
from follows f1 
join follows f2 
on f2.followee_id = f1.follower_id 
and f1.followee_id = f2.follower_id

--- SUBJECTIVE QUESTIONS 
--- Question 1 
SELECT *
FROM users
ORDER BY created_at
LIMIT 5;

--- Question 2 
select username as inactive_users from Users 
left join Photos
on Users.id = Photos.user_id
where Photos.image_url IS NULL

--- Question 3 
SELECT t.tag_name, Count(t.tag_name) AS "tags count"
FROM   tags t
INNER JOIN photo_tags pt
ON t.id = pt.tag_id
GROUP  BY t.tag_name
ORDER BY Count(t.tag_name) DESC
LIMIT  5;

--- Question 4 
select dayname(created_at) as days_of_week, count(*) as num_of_users_resistered
from Users
group by dayname(created_at)
order by num_of_users_resistered desc; 

--- Question 5 
with cte as (select user_id, count(*) as total_no_likes
from likes
group by user_id) 

select u.id, u.username, c.total_no_likes
from users u
join cte c 
on u.id = c.user_id
having c.total_no_likes <> 257
order by total_no_likes desc
limit 5 

--- Question 6 
with cte as (select user_id, count(*) as total_no_comments
from comments
group by user_id) 

select u.id, u.username, c.total_no_comments
from users u
join cte c 
on u.id = c.user_id
having c.total_no_comments <> 257
order by total_no_comments desc
limit 5 

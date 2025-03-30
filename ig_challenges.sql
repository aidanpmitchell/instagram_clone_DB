
-- Challenge #1
-- We want to reward our users who have been around the longest.
-- Find the 5 oldest users.
SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;


-- Challenge #2
-- What day of the week do most users register on?
-- We need to figure out when to schedule an ad campaign.
SELECT 
	DayName,
    DayCount
FROM ( 
	SELECT 
		DAYNAME(created_at) AS DayName,
		COUNT(username) AS DayCount,
		RANK() OVER(ORDER BY COUNT(username) DESC) AS ranked
	FROM users
    GROUP BY DAYNAME(created_at)
) AS RankedDays
WHERE ranked = 1;


-- Challenge #3
-- We want to target our inactive users with an email campaign.
-- Find the users who have never posted a photo.
SELECT 
    username AS Inactive_Users
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    p.user_id IS NULL;
    

-- Challenge #4
-- We're running a new contest to see who can get the most likes on a single photo.
-- Who won??
SELECT
	Username,
    Like_Count
FROM (
	SELECT 
		u.username AS Username,
		p.id as Photo_ID,
		count(l.user_id) AS Like_Count,
		RANK() OVER(ORDER BY COUNT(l.user_id) DESC) as ranking
	FROM
		photos p
			LEFT JOIN
		likes l ON p.id = l.photo_id
			INNER JOIN
		users u on p.user_id = u.id
	GROUP BY p.id
) AS RankedUsers
WHERE ranking = 1;


-- Challenge #5
-- Our investors want to know...
-- How many times does the average user post?
SELECT 
    (SELECT 
            COUNT(*)
        FROM
            photos) / (SELECT 
            COUNT(*)
        FROM
            users) AS Avg_Num_Posts; 
            
            
-- Challenge #6
-- A brand wants to know which hashtags to use in a post
-- What are the top 5 most commonly used hashtags?
SELECT
	t.tag_name AS Hashtag,
    COUNT(*) AS Times_Used
FROM tags t
	JOIN photo_tags p
		ON t.id = p.tag_id
GROUP BY t.id
ORDER BY Times_Used DESC
LIMIT 5;


-- Challenge #7
-- We have a small problem with bots on our site...
-- Find users who have liked every single photo on the site
SELECT
	u.username AS Username,
    COUNT(l.photo_id) as Likes
FROM likes l
JOIN users u
ON u.id = l.user_id
GROUP BY l.user_id
HAVING Likes = (SELECT COUNT(*) FROM photos);

# Instagram Clone Database
## Project Overview
This project involves the creation of a clone of a basic Instagram database. The objective was to understand the underlying structure of a social media database and to utilize MySQL for database management and data querying. The project was divided into four main phases: designing the database schema, coding the database creation, populating the database with mock data, and answering business-related queries using MySQL.

## Technologies Used
- MySQL
- QuickDBD

## Phase 1: Database Design
Initially, a comprehensive database schema was designed to mimic Instagram's typical functionalities. This included tables for users, photos, comments, likes, follower relationships, unfollows, and hashtags. The schema was visualized using QuickDBD, and the design ensures efficient data retrieval.

### Schema Diagram
![IG_Scheme_Diagram](IG_Database.jpeg)

## Phase 2: Database Creation
The database was created using MySQL. Below are the SQL scripts used for the creation of each table:

```sql
CREATE TABLE users (
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photos (
	id INT PRIMARY KEY AUTO_INCREMENT,
    image_url VARCHAR(255) NOT NULL,
	user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE comments (
	id INT PRIMARY KEY AUTO_INCREMENT,
    comment_text VARCHAR(255) NOT NULL,
	photo_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE likes (
	user_id INT NOT NULL,
	photo_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(user_id) REFERENCES users(id),
    PRIMARY KEY(user_id, photo_id)
);

CREATE TABLE followers (
	follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);

CREATE TABLE unfollows (
	follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);

CREATE TABLE tags (
	id INT PRIMARY KEY AUTO_INCREMENT,
	tag_name VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photo_tags (
	photo_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(tag_id) REFERENCES tags(id),
    PRIMARY KEY(photo_id, tag_id)
);
```
[IG_Database.sql](IG_Database.sql)

## Phase 3: Populating the Database with Mock Data
Mock data was generated to populate the database, reflecting a realistic set of data for testing and analysis. The data insertion was performed via SQL scripts. \
Do to the large size of the inserts, scripts can be seen within the attached file: \
[Mock Data](ig_clone_data.sql)

## Phase 4: Business Questions and SQL Queries
Several business questions were posed to simulate real-world data analysis scenarios typical of a social media platform:

### Challenge #1
"We want to reward our users who have been around the longest. Find the 5 oldest users."
```sql
SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;
```

### Challenge #2
"What day of the week do most users register on? We need to figure out when to schedule an ad campaign."
```sql
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
```

### Challenge #3
"We want to target our inactive users with an email campaign. Find the users who have never posted a photo."
```sql
SELECT 
    username AS Inactive_Users
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    p.user_id IS NULL;
```

### Challenge #4
"We're running a new contest to see who can get the most likes on a single photo. Who won??"
```sql
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
```

### Challenge #5
"Our investors want to know... How many times does the average user post?"
```sql
SELECT 
    (SELECT 
            COUNT(*)
        FROM
            photos) / (SELECT 
            COUNT(*)
        FROM
            users) AS Avg_Num_Posts; 
```
            
### Challenge #6
"A brand wants to know which hashtags to use in a post. What are the top 5 most commonly used hashtags?"
```sql
SELECT
	t.tag_name AS Hashtag,
    COUNT(*) AS Times_Used
FROM tags t
	JOIN photo_tags p
		ON t.id = p.tag_id
GROUP BY t.id
ORDER BY Times_Used DESC
LIMIT 5;
```

### Challenge #7
"We have a small problem with bots on our site... Find users who have liked every single photo on the site."
```sql
SELECT
	u.username AS Username,
    COUNT(l.photo_id) as Likes
FROM likes l
JOIN users u
ON u.id = l.user_id
GROUP BY l.user_id
HAVING Likes = (SELECT COUNT(*) FROM photos);
```

# Conclusion
This project helped in understanding the complexities involved in designing and managing a database for a social media platform like Instagram. It also provided practical experience in executing SQL queries to extract meaningful insights from the data.

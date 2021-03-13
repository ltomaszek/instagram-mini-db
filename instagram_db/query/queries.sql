# 5 users that joined db first
SELECT 
    username
FROM users
ORDER BY created_at
limit 5;

# day of the week most users register on
SELECT 
    DAYNAME(created_at) AS week_day,
    COUNT(*) AS total
from users
GROUP BY week_day
ORDER BY total DESC, week_day
LIMIT 2;

# users who have never posted a photo
SELECT 
    username
FROM users
LEFT JOIN photos
    ON users.id = photos.user_id
WHERE photos.id IS NULL;

# person with the photo with the most likes
SELECT 
    users.username,
    photos.id,
    photos.image_url,
    COUNT(*) as num_likes
FROM likes
JOIN photos
    ON likes.photo_id = photos.id
JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY num_likes DESC
LIMIT 1;

# how many times does the average user post
SELECT ROUND(
    (SELECT COUNT(*) FROM photos) / 
    (SELECT COUNT(*) FROM users), 2) AS avg;
    
# OR
SELECT 
    ROUND( COUNT(photos.id) / COUNT(DISTINCT users.id), 2 )    # photos will be distinct by default
FROM users
LEFT JOIN photos
    ON users.id = photos.user_id;
    
# 5 most commonly used hashtags
SELECT
    tag_name,
    COUNT(*) AS num_likes
FROM tags
JOIN photo_tags
    ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY num_likes DESC
LIMIT 5;

# find Bots - users who have liked every single photo
SELECT 
    username, 
    COUNT(*) AS num_likes
FROM users
JOIN likes
    ON users.id = likes.user_id
GROUP BY users.id
HAVING num_likes = (SELECT COUNT(*) 
                    FROM photos);
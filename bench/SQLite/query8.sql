0
NULL
SELECT u.name
FROM users u
WHERE u.plays = (SELECT uu.plays FROM users uu ORDER BY uu.plays DESC LIMIT 1);
SELECT u.name
FROM users u JOIN usersongplays usp ON u.id = usp.userid
WHERE u.plays = (SELECT uu.plays FROM users uu ORDER BY uu.plays DESC LIMIT 1)

DELIMITER $$

CREATE TRIGGER capture_unfollow
	AFTER DELETE ON followers FOR EACH ROW
BEGIN
		INSERT INTO unfollows
        SET follower_id = OLD.follower_id,
			followee_id = OLD.followee_id;
END$$

DELIMITER ;
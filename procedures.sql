-- this script contains the procedures for the spotifydb database
-- write a procedure to insert data into album since it is the smallest table in the database.
USE spotifydb;
DELIMITER $$
DROP PROCEDURE IF exists insert_album $$
CREATE PROCEDURE insert_album (INOUT total_record INT, OUT record_upd INT)
BEGIN
	-- declaring a local variable
	DECLARE initial_record INT;
    -- Procedural statements here
    START TRANSACTION;
    SET initial_record = total_record;
    INSERT IGNORE INTO album (album_name, artist_id, album_rank, album_genre)
    VALUES ('Snacks', 54, 67, 'pop'),
    ('Purpose(deluxe)', 76, 67, 'pop'),
    ('In the Shape of a Dream', 59, 100, 'pop'),
    ('ALESSO MIXTAPE - PROGRESSO VOLUME 1', 58, 120, 'pop');
    SET total_record = 0 + (SELECT COUNT(album_id) FROM album);
    SET record_upd = total_record - initial_record ; 
    SELECT * FROM album;
    SELECT total_record, record_upd;
    COMMIT;
END;
$$
DELIMITER ;
-- setting the record_update variable to store the current number of records in the database.
SET @total_record := (SELECT COUNT(album_id) FROM album);
SET @record_upd := 0;
-- calling the stored procedure to insert values into the table
CALL insert_album(@total_record, @record_upd);

-- a procedure for updating the records to have a null aritst_id from song.
DELIMITER $$
DROP PROCEDURE IF EXISTS null_artist $$
CREATE PROCEDURE null_artist()
BEGIN
	START TRANSACTION;
    UPDATE song
    SET artist_id = null
    WHERE artist_id IN (27, 33);
    COMMIT;
END;
$$
DELIMITER ;
CALL null_artist;
-- a procedure for removing songs that have a null artist_id and returning the total number of songs and the number of records deleted.
DELIMITER $$
DROP PROCEDURE IF exists delete_song $$
CREATE PROCEDURE delete_song (INOUT total_songs INT, OUT deleted_songs INT)
BEGIN
	-- declaring a local variable
	DECLARE initial_songs INT;
    -- Procedural statements here
    START TRANSACTION;
    SET initial_songs = total_songs;
    SET SQL_SAFE_UPDATES = 0;
    DELETE FROM song
    WHERE artist_id IS NULL;
    SET SQL_SAFE_UPDATES = 1;
    SET total_songs = 0 + (SELECT COUNT(track_id) FROM song);
    SET deleted_songs = initial_songs - total_songs; 
    SELECT * FROM song;
    SELECT total_songs, deleted_songs;
    COMMIT;
END;
$$
DELIMITER ;
-- setting the record_update variable to store the current number of records in the database.
SET @total_songs := (SELECT COUNT(track_id) FROM song);
SET @songs_deleted:= 0;
-- calling the stored procedure to insert values into the table
CALL delete_song(@total_songs, @deleted_songs);
 
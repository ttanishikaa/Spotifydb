-- file of sql queries
USE spotifydb;
-- a simple query that return the track names starting with an alphabet less than C.
SELECT * FROM song
WHERE track_name < "C";
-- an inner join that links the table song with the table artist, tothe number of songs for each artist in artist table.
SELECT artist.artist_id, artist.artist_name, COUNT(song.track_name) AS song_count
FROM artist  INNER JOIN song ON artist.artist_id = song.artist_id
GROUP BY artist.artist_id, artist.artist_name
ORDER BY artist.artist_id ASC;
-- a query returning the list of charting artists, and their charting song by using a left outer join 
SELECT artist.artist_name, chart.track_name, chart.peak_rank, chart.weeks_on_chart
FROM chart LEFT OUTER JOIN artist ON artist.artist_name = chart.artist_name
WHERE artist.artist_name IS NOT NULL
ORDER BY artist.artist_name ASC;
-- a query that returns the name of artists of the songs in the table song that have a name with starting alphabet less than c and their average danceability
SELECT artist.artist_name, new_song.track_name, new_song.danceability, new_song.energy, AVG(new_song.danceability) as average_danceability
FROM ( SELECT * FROM song WHERE track_name < "C") new_song INNER JOIN artist  ON new_song.artist_id = artist.artist_id
GROUP BY artist.artist_name, new_song.track_name, new_song.danceability, new_song.energy
ORDER BY new_song.track_name ASC, artist.artist_name ASC;

-- creating a view for all the charting artists in the song table
CREATE VIEW charting_artist AS (
SELECT artist.artist_name, chart.track_name, chart.peak_rank, chart.weeks_on_chart, chart.danceability, chart.energy, chart.track_key, chart.track_mode
FROM chart INNER JOIN artist ON artist.artist_name = chart.artist_name
ORDER BY artist.artist_name ASC
);
-- a query that counts the number of charting song for each artist, and returns the average peak rang and average weeks on the chart for the artist
SELECT artist_name, COUNT(track_name), ROUND(AVG(peak_rank)) as average_peak_rank, ROUND(AVG(weeks_on_chart)) as avg_weeks_on_chart
FROM charting_artist
GROUP BY artist_name
order by artist_name;
-- a query that modifies chart by adding an index for track_name
ALTER TABLE chart
ADD INDEX track_index (track_name);
-- copying the same query from above to see the changes made to the view charting_artist after deleting records from chart
SELECT artist_name, COUNT(track_name), ROUND(AVG(peak_rank)) as average_peak_rank, ROUND(AVG(weeks_on_chart)) as avg_weeks_on_chart
FROM charting_artist
GROUP BY artist_name
order by artist_name;
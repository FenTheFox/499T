#!/usr/bin/ruby

def clean_str(str)
  str.gsub!("\'", "''")
  str.gsub!(/[\r\n]/, '')
  str.gsub!("\u{feff}", '')
end

# Find all albums with the name *
fh = File.new('query1.sql', 'w')
IO.foreach('csvs/albumnames.csv') do |row|
  clean_str(row)
  fh.syswrite("SELECT * FROM albums a WHERE a.name = '#{row}';\n")
end
fh.close

# Find all songs that have * as a prefix/include * in the title
fh = File.new('query2.sql', 'w')
fh2 = File.new('query2-1.sql', 'w')
IO.foreach('csvs/songnames.csv') do |row|
  clean_str(row)
  words = row.split
  fh.syswrite("SELECT * FROM songs s WHERE s.title like '#{words[0]}%';\n")
  fh2.syswrite("SELECT * FROM songs s WHERE s.title like '%#{words[1]}%';\n") unless words[1].nil?
end
fh.close
fh2.close

# Return the (number of) rows in each table
fh = File.new('query3.sql', 'w')
fh.syswrite("SELECT COUNT(*) FROM albums;\n")
fh.syswrite("SELECT COUNT(*) FROM artists;\n")
fh.syswrite("SELECT COUNT(*) FROM songs;\n")
fh.syswrite("SELECT COUNT(*) FROM tags;\n")
fh.syswrite("SELECT COUNT(*) FROM users;\n")
fh.syswrite("SELECT COUNT(*) FROM usersongplays;\n")
fh.syswrite("SELECT COUNT(*) FROM usersongratings;\n")
fh.syswrite("SELECT * FROM albums;\n")
fh.syswrite("SELECT * FROM artists;\n")
fh.syswrite("SELECT * FROM songs;\n")
fh.syswrite("SELECT * FROM tags;\n")
fh.syswrite("SELECT * FROM users;\n")
fh.syswrite("SELECT * FROM usersongplays;\n")
fh.syswrite("SELECT * FROM usersongratings;\n")
fh.close

# Return the titles of the ten loudest songs of the year *
fh = File.new('query4.sql', 'w')
IO.foreach('csvs/songyears.csv') do |row|
  clean_str(row)
  fh.syswrite("SELECT ss.title\nFROM (SELECT s.title, s.loudness FROM songs s WHERE s.year=#{row}) ss\nORDER BY ss.loudness DESC\nLIMIT 10;\n")
end
fh.close

# Show the number of user ratings for each rating value for the song with title *
fh = File.new('query5.sql', 'w')
fh2 = File.new('query5-1.sql', 'w')
IO.foreach('csvs/songnames.csv') do |row|
  clean_str(row)
  fh.syswrite("SELECT r.rating, COUNT(*)\nFROM usersongratings r, songs s\nWHERE r.songid = s.id and s.title='#{row}'\nGROUP BY r.rating ORDER BY r.rating ASC;\n")
  fh2.syswrite("SELECT r.rating, COUNT(*)\nFROM usersongratings r JOIN songs s ON r.songid = s.id\nWHERE s.title='#{row}'\nGROUP BY r.rating ORDER BY r.rating ASC;\n")
end
fh.close
fh2.close

# Show the title, album name, and artist name of all songs that are rated above 3 by *
fh = File.new('query6.sql', 'w')
fh2 = File.new('query6-1.sql', 'w')
IO.foreach('csvs/usernames.csv') do |row|
  clean_str(row)
  fh.syswrite("SELECT s.title, ab.name as albumname, ar.name as artistname\nFROM (\nSELECT ur.songid\nFROM usersongratings ur,\n( SELECT u.id\nFROM users u\nWHERE u.name='#{row}'\n) UserID\nWHERE ur.userid = UserID.id AND ur.rating > 3\n) OverThreeSongID, songs s, albums ab, artists ar\nWHERE OverThreeSongID.songid = s.id AND s.albumid = ab.id AND s.artistid = ar.id;\n")
  fh2.syswrite("\nSELECT s.title, ab.name as albumname, ar.name as artistname\nFROM (\nSELECT ur.songid\nFROM usersongratings ur\nJOIN (\nSELECT u.id\nFROM users u\nWHERE u.name='#{row}'\n) UserID ON ur.userid = UserID.id\nWHERE ur.rating > 3) OverThreeSongID\nJOIN songs s ON OverThreeSongID.songid = s.id\nJOIN albums ab ON s.albumid = ab.id\nJOIN artists ar ON s.artistid = ar.id;\n")
end
fh.close
fh2.close

# For each song that is rated (more then) * times, find the song id and the average age of the users who rate the song
fh = File.new('query7.sql', 'w')
fh2 = File.new('query7-1.sql', 'w')
IO.foreach('csvs/#songratings.csv') do |row|
  clean_str(row)
  fh.syswrite("SELECT s.id, AVG(u.age)\nFROM songs s, usersongratings usr, users u\nWHERE s.ratings > #{row} AND usr.songid = s.id AND usr.userid = u.id\nGROUP BY s.id;\n")
  fh.syswrite("SELECT s.id, AVG(u.age)\nFROM songs s, usersongratings usr, users u\nWHERE s.ratings = #{row} AND usr.songid = s.id AND usr.userid = u.id\nGROUP BY s.id;\n")
  fh2.syswrite("SELECT s.id, AVG(u.age)\nFROM songs s JOIN usersongratings usr ON s.id = usr.songid JOIN users u ON usr.userid = u.id\nWHERE s.ratings > #{row}\nGROUP BY s.id;\n")
  fh2.syswrite("SELECT s.id, AVG(u.age)\nFROM songs s JOIN usersongratings usr ON s.id = usr.songid JOIN users u ON usr.userid = u.id\nWHERE s.ratings = #{row}\nGROUP BY s.id;\n")
end
fh.close
fh2.close

# Select the user names that have played the largest number of songs, each number of songs
fh = File.new('query8.sql', 'w')
# fh2 = File.new('query8-1.sql', 'w')
fh.syswrite("SELECT u.name\nFROM users u\nWHERE u.plays = (SELECT uu.plays FROM users uu ORDER BY uu.plays DESC LIMIT 1);\n")
# fh2.syswrite("SELECT u.name\nFROM users u JOIN usersongplays usp ON u.id = usp.userid\nWHERE u.plays = (SELECT uu.plays FROM users uu ORDER BY uu.plays DESC LIMIT 1)\n")
IO.foreach('csvs/userplays.csv') do |row|
  clean_str(row)
  fh.syswrite("SELECT u.name\nFROM users u\nWHERE u.plays = #{row};\n")
end
fh.close
# fh2.close

# Find the songs that have been played each number of times
fh = File.new('query9.sql', 'w')
# fh2 = File.new('query9-1.sql', 'w')
IO.foreach('csvs/songplays.csv') do |row|
  clean_str(row)
  fh.syswrite("SELECT *\nFROM songs s\nWHERE s.plays = #{row};\n")
end
fh.close
# fh2.close

# Find super users. A super user is one who has rated at least 50 songs or played at least 50 songs
fh = File.new('query10.sql', 'w')
# fh2 = File.new('query10-1.sql', 'w')
50.times { |n| fh.syswrite("SELECT COUNT(*)\nFROM users u\nWHERE u.plays >= #{n} OR u.ratings >= #{n};\n") }
50.times { |n| fh.syswrite("SELECT *\nFROM users u\nWHERE u.plays >= #{n} OR u.ratings >= #{n};\n") }
fh.close
# fh2.close
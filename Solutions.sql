-- Advanced SQL Project-- Spotify Datasets--
create table Spotify(
Artist varchar(255),
Track  varchar(255),
Album  varchar(255),
Album_type varchar(50),
Danceability float,
Energy float,
Loudness float,
Speechiness float,
Acousticness float,
Instrumentalness float,
Liveness float,
Valence Float,
Tempo Float,
Duration_min Float,
Tittle varchar(255),
Channel varchar(255),
Views bigint,
Likes Float,
Comments bigint,
Licensed boolean,
Official_video boolean,
Stream bigint,
Energy_liveness float,
Most_played_on varchar(50)
);
select * from spotify;
alter table spotify alter column likes type float;
alter table spotify alter column comments type float;
alter table spotify alter column stream type float;

---EDA----
select count(*) from spotify;
Select count(distinct artist) from spotify;
select count(distinct album) from spotify;
select distinct album_type from spotify;
select max(duration_min) from spotify; 
select min(duration_min) from spotify;--- here we find zero duration songs, which is parctially no possiable
select *  from spotify where duration_min = 0; --here we saw that thing 
delete from spotify where duration_min =0; --- deleted here
select distinct(channel) from spotify;
select distinct (most_played_on) from spotify;

-------------------------------- Easy Problems--------------------------------------------------
 ---Retrive the names of all tracks that have more than 1 billion streams
 select track, stream from spotify where stream > 1000000000;

 ----List the all albums with respective artists---
 select distinct album , artist from spotify order by 1;

 ----get the total number of comments where licensed =true--

 select sum(comments )as total_comments from spotify where licensed=true ;

 ---- find the all tracks where album type is single----
 select track from spotify where album_type= 'single';
  -------count the total tracks for each artist----
  select   artist,count (*) as total_no_songs from spotify group by artist order by 2 asc;

  ------ Medium level problems----------
  -- calculate the average dancability of track in each album----

 select album , avg(danceability) from spotify group by album order by 2 desc;

 --- find the top 5 tracks with highest energy values----
 
  select track,max(energy) from spotify  group by 1 order by 2 desc limit 5;

  --- List all the tracks with thier views and likes where offical_video = true----
  select  track , views,likes from spotify where official_video= true;

  ----for each album calculate the total views of all associated tracks
  select album, track, sum(views) from spotify group by 1,2 order by 3 desc;

  ---retrive the track names that has been streamed on spotify more than youtube---
   select * from(select track , coalesce (sum(case when most_played_on ='Youtube' then stream end),0) as streamed_on_youtube,
                 coalesce (sum(case when most_played_on ='Spotify' then stream end),0) as streamed_on_Spotify from spotify group by 1) as y
				 where streamed_on_Spotify > streamed_on_youtube and streamed_on_youtube <>0;

---------Advanced level-----
 ---find the top -3 most viewd track for each artist by using windows function---
select * from(select artist, track, sum(views) as views, dense_rank() over(partition by artist order by sum(views) desc) as rank  from spotify group by 1,2) as v where rank <= 3;
                                    or
with artist_rank as (select artist, track, sum(views) as views, dense_rank() over(partition by artist order by sum(views) desc) as rank  from spotify group by 1,2 order by 1,3 desc)
select * from artist_rank where rank <=3;


---- find the tracks where the liveness score is above avg------
select track,liveness from spotify where liveness >(select avg(liveness) from spotify);

--Using the WITH CLAUSE calculate diffrence between highest and lowest energy values for tracks in each album

with cte as ( select album, max(energy) as highest_energy, min(energy) as lowest_energy
 from spotify group by 1) select album, highest_energy - lowest_energy as Energy_diffrence from cte ;

 ----- find the tracks where the energy to liveness ratio is greater than 1.2-------
 select track , energy/liveness as ratio from spotify where energy/liveness > 1.2;

 ----Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.-----
 select track,likes,sum(likes)over(order by views) as cumilative_sum from spotify  ;

 
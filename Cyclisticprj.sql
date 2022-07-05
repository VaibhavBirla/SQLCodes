select
* from
dbo.cyclist
order by started_date

--cleaning data
alter table
master.dbo.cyclist
drop column
Source#Name,ride_id


--adding extra columns for time adn date and dropping initial columns
alter table dbo.cyclist
add  start_time time;

alter table dbo.cyclist
add   started_date date;
alter table dbo.cyclist
add   ended_date date;


--seperating date and time
update dbo.cyclist 
set
start_time=CONVERT(TIME(0),started_at) ;

update dbo.cyclist
set
end_time=CONVERT(TIME(0),ended_at)

update dbo.cyclist
set
started_date=CONVERT(DATE,started_at);

update dbo.cyclist
set
ended_date=CONVERT(DATE,ended_at);


--dropping initial columns

alter table
master.dbo.cyclist
drop column
started_at,ended_at





--cleaned data
select
* from
dbo.cyclist
where
member_casual='casual'

--figuiring out ride preference for casual_members
select
distinct(rideable_type) ,
count(rideable_type) as ride_type_casual
from
dbo.cyclist
where
member_casual='casual'
group by rideable_type
order by 2 desc



--figuiring out ride preference for annual_members
select
distinct(rideable_type) ,
count(rideable_type) as ride_type_members
from
dbo.cyclist
where
member_casual='member'
group by rideable_type


--
select
start_time,end_time 
from
dbo.cyclist
where
start_time>end_time


--finding ride lengths

alter table dbo.cyclist
add ride_length float;
update 
dbo.cyclist
set
ride_length=datediff(second,start_time,end_time) % 3600 /60 


--Average ride length for members
select
avg(ride_length) as ride_length_members
from
dbo.cyclist
where
member_casual='member'
and 
ride_length>'0'

--Average ride length for casuals
select
avg(ride_length) as ride_length_casuals
from
dbo.cyclist
where
member_casual='casual'
and
ride_length>'0'


--finding out trends on weekends
alter table dbo.cyclist
add Weekends varchar(15);


--Finding out weekends
update dbo.cyclist
set
Weekends=DATEPART(DW,started_date)                      --1=Sunday, 2=Monday ,3=Tuesday ,4=Wednesdayand so on...


--Finding out average ride_length on weekends 
alter table dbo.cyclist
add ride_len_weekends float;


update dbo.cyclist
set ride_len_weekends=
(
select case 

         when 
                Weekends= '1'
         then  
                 ride_length
         when   Weekends= '7'
               
         then   

                 ride_length
end
)


--for casuals
select avg(ride_len_weekends) as ride_len_weekend_casual
from
dbo.cyclist
where
member_casual='casual' and
ride_len_weekends>0

--for members
select avg(ride_len_weekends) as ride_len_weekend_members
from
dbo.cyclist
where
member_casual='member' and
ride_len_weekends>0




--Finding out average ride_length on weekdays 
alter table dbo.cyclist
add ride_len_weekdays float;


update dbo.cyclist
set ride_len_weekdays=
(
select case 

         when 
                Weekends!= '1'
         then  
                 ride_length
         when   Weekends!= '7'
               
         then   

                 ride_length
end
)


--for casuals
select avg(ride_len_weekdays) as ride_len_weekdays_casual
from
dbo.cyclist
where
member_casual='casual' and
ride_len_weekdays>0

--for members
select avg(ride_len_weekdays) as ride_len_weekdays_members
from
dbo.cyclist
where
member_casual='member' and
ride_len_weekdays>0

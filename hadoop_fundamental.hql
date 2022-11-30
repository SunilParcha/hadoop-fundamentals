-- Create table before loading data into table.
CREATE TABLE IF NOT EXISTS students (
name STRING ,
id INT ,
subjects ARRAY < STRING >,
feeDetails MAP < STRING , FLOAT >,
phoneNumber STRUCT <areacode: INT , number : INT > )
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '#'
MAP KEYS TERMINATED BY '|'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

Show tables;
Desc students;

-- Syntax:
-- load data inpath 'add path to your file here' overwrite into table <table_Name>;
-- Query:
load data local inpath '/home/hadoop/student.dat' overwrite into table students;


-- To check the output
Select * FROM students;
Select explode(feedetails) FROM students;
Select upper(name) from students;
-- You can use aggrigates
-- count, sum, avg 

-- Add Jar do read Json file and load data into table.
add jar s3://elasticmapreduce/samples/hive-ads/libs/jsonserde.jar;

-- Table to load JSON files - users.json 
CREATE TABLE yelp_user_hdf (
user_id string,
name string,
review_count bigint,
yelping_since string,
friends array<string>,
useful_rating double,
Funny_rating double,
Cool_rating double,
Fans_rating double,
elite array<string>,
average_stars float
) ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' 
with serdeproperties ( 'paths' = '' );

-- loading data
load data local inpath '/home/hadoop/users.json' overwrite into table yelp_user_hdf;

-- To check the output
select count(*) as review_count from yelp_user_hdf;

-- You can use joins for joining 2 tables.
select * from yelp_user_hdf JOIN students 
ON yelp_user_hdf.user_id=students.user_id limit 10;

-- YELP partition
-- Creating a year column using substr function, will be used as partition key.
CREATE TABLE yelp_user_year (
user_id string,
name string,
review_count bigint,
yelping_since string,
friends array<string>,
useful_rating double,
Funny_rating double,
Cool_rating double,
Fans_rating double,
elite array<string>,
average_stars float,
yr string
);

-- Loading data with year column value
insert overwrite table yelp_user_year 
select user_id,name,review_count,yelping_since,friends,useful_rating,funny_rating,
cool_rating,fans_rating,elite,average_stars,substr(yelping_since,1,4)  from yelp_user_hdf;

select distinct(yr) from yelp_user_year;
select min(yr), max(yr) from yelp_user_year;

-- Set partition property , by default set to strict
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode = nonstrict;


-- Creating partition table partition by year.
create external table if not exists
yelp_user_hdf_partioned (
user_id string,
name string,
review_count bigint,
yelping_since string,
useful_rating double,
Funny_rating double,
Cool_rating double,
Fans_rating double,
average_stars float
)
partitioned by
(yr string);

-- loading data
insert overwrite table yelp_user_hdf_partioned partition (yr)
select user_id,
name, 
review_count, 
yelping_since, 
useful_rating, 
Funny_rating, 
Cool_rating, 
Fans_rating ,
average_stars,
yr
from yelp_user_year;

-- Displaying partitions created  
show partitions yelp_user_hdf_partioned;
-- partitioned vs non-partitioned


-- Hive BUCKETING vs Partitions
-- YELP BUCKETING
-- Buckets created using clustered by keyword. in this case we are creating 4 buckets.
create external table if not exists
yelp_user_hdf_partioned_yr_bucket (
user_id string,
name string,
review_count bigint,
yelping_since string,
useful_rating double,
Funny_rating double,
Cool_rating double,
Fans_rating double,
average_stars float
)
partitioned by (yr string)
clustered by (user_id) into 4 buckets;

-- Loading data into table 
insert overwrite table yelp_user_hdf_partioned_yr_bucket partition (yr)
select user_id,
name, 
review_count, 
yelping_since, 
useful_rating, 
Funny_rating, 
Cool_rating, 
Fans_rating ,
average_stars,
yr
from yelp_user_hdf_partioned;

-- How to see buckets
-- /users/hive/warehouse/buckets-name


-- The Optimized Row Columnar (ORC) file format provides 
-- a highly efficient way to store Hive data. It was designed 
-- to overcome limitations of the other Hive file formats.
-- Using ORC files improves performance when Hive is reading, 
-- writing, and processing data.

CREATE EXTERNAL TABLE yelp_user_hdfs_ORC (
user_id string,
name string,
review_count bigint,
yelping_since string,
friends array<string>,
useful_rating double,
Funny_rating double,
Cool_rating double,
Fans_rating double,
average_stars float
)
partitioned by (yr string)
clustered by (user_id) into 4 buckets;
STORED AS ORC 
LOCATION 's3//yelphivedemo01/users_orc'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- Loading data into table 
insert overwrite table yelp_user_hdf_ORC partition(yr)
select 
user_id,
name,
review_count,
yelping_since,
friends,
useful_rating,
Funny_rating,
Cool_rating,
Fans_rating,
average_stars,
yr
from yelp_user_year;

select * from yelp_user_hdf_ORC;











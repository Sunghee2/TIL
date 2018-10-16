# HIVE

### Example 1

```sql
CREATE TABLE IF NOT EXISTS ratings (
  userid INT,
  movieid INT,
  rating DOUBLE,
  ts INT
)
row format delimited fields terminated BY ',' lines terminated BY '\n'
tblproperties("skip.header.line.count"="1");

LOAD DATA INPATH '/user/maria_dev/ml-latest-small/ratings.csv' OVERWRITE INTO TABLE ratings;

SELECT * FROM ratings LIMIT 30;
```

![](./screenshot/hive_example1.png)

:memo: 한 번 실행하고 나면 원래 위치에서 파일 X

:memo: `row format` : 데이터의 형식을 지정하는 방법.



### Example 2

```sql
DROP TABLE ratings2;
CREATE EXTERNAL TABLE IF NOT EXISTS ratings2(
  userid INT,
  movieid INT,
  rating DOUBLE,
  ts INT
)
row format delimited fields terminated BY ',' lines terminated BY '\n'
LOCATION '/user/maria_dev/ml-latest-small'
tblproperties("skip.header.line.count"="1");

DROP TABLE movies2;
CREATE EXTERNAL TABLE IF NOT EXISTS movies2(
  movieid INT,
  title STRING,
  genre STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
LOCATION '/user/maria_dev/ml-latest-small'
tblproperties("skip.header.line.count"="1");

SELECT m.title, count(r.movieid) as count_rates
FROM movies2 m JOIN ratings2 r ON m.movieid = r.movieid
GROUP BY m.movieid, m.title
ORDER BY count_rates DESC
LIMIT 10;
```

![](./screenshot/hive_example2.png)

:bug: Location 뒤에는 파일이름이 아닌 데이터 파일이 들어가 있는 **폴더**임

:memo: `CREATE EXTERNAL TABLE` : Hive에서 새 external table을 만듦. external table은 테이블 정의만 Hive에 저장되고 데이터는 원래 위치에 그대로 유지됨.
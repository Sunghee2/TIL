# Pig

### example 1

1. 평균평점구하기
2. 평점이 100회 이상 이루어진 것만
3. 오름차순 정렬
4. 영화 이름으로 출력

```pig
ratings = LOAD '/user/maria_dev/ml-latest-small/ratings.csv' 
			USING org.apache.pig.piggybank.storage.CSVExcelStorage(',',
            	'NO_MULTILINE','NOCHANGE','SKIP_INPUT_HEADER')
            AS (userId:int, movieId:int, rating:float, timestamp:chararray);
movies = LOAD '/user/maria_dev/ml-latest-small/movies.csv'
			USING org.apache.pig.piggybank.storage.CSVExcelStorage(',',
            	'NO_MULTILINE','NOCHANGE','SKIP_INPUT_HEADER')
          	AS (movieId:int, title:chararray, genres:chararray);

grouped = GROUP ratings BY movieId;
count_ratings = FOREACH grouped GENERATE FlATTEN(group), ratings.rating AS ratings, COUNT(ratings.rating) AS (count_rating);
filter_ratings = FILTER count_ratings BY count_rating >= 100; 
avg_ratings = FOREACH filter_ratings GENERATE group, ROUND_TO(SUM(ratings.rating)/count_rating, 2) AS avg_rating;
joined = JOIN avg_ratings BY (group), movies BY (movieId);
sort_avg_ratings = ORDER joined BY avg_rating ASC;
result = FOREACH sort_avg_ratings GENERATE title, avg_rating;
DUMP result;
```

![result](./screenshot/pig_rating1_result.png)

:bug: Failed to generate logical plan. Nested exception: org.apache.pig.backend.executionengine.ExecException: ERROR 1070: Could not resolve sum using imports: [, java.lang., org.apache.pig.builtin., org.apache.pig.impl.builtin.] 

> -> sum을 대문자로 써야함.

:memo: round는 pig에서 자릿수x => round_to



### example 2

### example 3

```
ratings = LOAD '/user/maria_dev/ml-latest-small/ratings.csv' 
			USING org.apache.pig.piggybank.storage.CSVExcelStorage(',',
            	'NO_MULTILINE','NOCHANGE','SKIP_INPUT_HEADER')
            AS (userId:int, movieId:int, rating:float, timestamp:chararray);
movies = LOAD '/user/maria_dev/ml-latest-small/movies.csv'
			USING org.apache.pig.piggybank.storage.CSVExcelStorage(',',
            	'NO_MULTILINE','NOCHANGE','SKIP_INPUT_HEADER')
          	AS (movieId:int, title:chararray, genres:chararray);
     
strsplittobag_movies = FOREACH movies GENERATE movieId AS movieId, FLATTEN(STRSPLITTOBAG(genres, '\\|', 0)) AS genres;
movieId_ratings = FOREACH ratings GENERATE movieId, rating;
joined = JOIN strsplittobag_movies BY (movieId), movieId_ratings BY (movieId);
grouped = GROUP joined BY genres;
count_ratings = FOREACH grouped GENERATE FLATTEN(group), COUNT(joined) AS count_rating, ROUND_TO(SUM(joined.rating)/COUNT(joined), 2) AS avg_rating;
sort_count = ORDER count_ratings BY count_rating DESC;
limit_genres = LIMIT sort_count 1;
DUMP limit_genres;
```

:bug: strsplittobag -> unexpected

> '\\|' \가 2개임


# Spark2

:memo: 실행 : `$ spark-submit [file]`

평점이 가장 낮은 10개의 영화 찾기

### example 1

```python
from pyspark import SparkConf, SparkContext
from itertools import islice
import csv

def loadMovies():
        movies = {}
        with open("/home/maria_dev/ml-latest-small/movies.csv", "rb") as f:
                reader = csv.reader(f, delimiter=',')
                next(reader)
                for row in reader:
                        movies[int(row[0])] = row[1]
        return movies

def parseInput(line):
        fields = line.split(',')
        return (int(fields[1]), (float(fields[2]), 1.0))

if __name__ == "__main__":
        movies = loadMovies()
        path = "hdfs:///user/maria_dev/ml-latest-small/ratings.csv"

        conf = SparkConf().setAppName("WorstMovies")
        sc = SparkContext(conf = conf)

        lines = sc.textFile(path)

        lines = lines.mapPartitionsWithIndex(
                lambda idx, it: islice(it, 1, None) if idx == 0 else it
        )

        ratings = lines.map(parseInput)
        sumAndCounts = ratings.reduceByKey(lambda m1, m2: (m1[0]+m2[0], m1[1]+m2[0]))
        avgRatings = sumAndCounts.mapValues(lambda v: v[0]/v[1])
        sortedMovies = avgRatings.sortBy(lambda x: x[1])
        results = sortedMovies.take(10)
        for result in results:
                print(movies[result[0]], result[1])                                             
```

![example1_result](./screenshot/spark1.png)



### example 2

```python
from pyspark.sql import SparkSession

if __name__ == "__main__":
        spark = SparkSession.builder.appName("WorstMovies").getOrCreate()

        df1 = spark.read.load("hdfs:///user/maria_dev/ml-latest-small/ratings.csv",
                                format="csv", sep=",", inferSchema="true", header="true")
        df2 = spark.read.load("hdfs:///user/maria_dev/ml-latest-small/movies.csv",
                                format="csv", sep=",", inferSchema="true", header="true")

        df1.createOrReplaceTempView("ratings")
        df2.createOrReplaceTempView("movies")

        result = spark.sql("""
                SELECT title, score
                FROM movies JOIN (
                        SELECT movieId, avg(rating) as score
                        FROM ratings GROUP BY movieId
                ) r ON movies.movieId = r.movieId
                ORDER BY score LIMIT 10
                """)

        for row in result.collect():
                print(row.title, row.score)
```

![example2_result](./screenshot/spark2.png)



### example 3

- 평균 평점이 2.0이 안되는 영화 중 가장 평가를 많이 받았던 30개의 영화는 무엇인가?

- 결과: (영화제목, 평균평점, 총 평가횟수)

- 데이터: ml-latest 이용

```sql
SELECT title, score
FROM movies JOIN (
SELECT movieId, avg(rating) as score
FROM ratings GROUP BY movieId
) r ON movies.movieId = r.movieId
ORDER BY score LIMIT 10
```



## 1. 최악의 영화를 찾아라! (80점)

- 힌트: 실습 코드를 잘 활용해보세요.

## 2. 장르별 평가 점수를 찾아라! (20점)

- 가장 많은 평가를 받은 장르는 무엇인가?
- 결과: (장르이름, 총 평가 횟수, 평균 평점)
- 데이터: ml-latest 이용


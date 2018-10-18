# mapreduce_rating

:bug: *E33*: *No previous substitute regular expression*

> 저장할 때마다 아무 것도 고친 것이 없고 아무 것도 없는 파일이라도 계속 나옴..
>
> : 저장을 잘못 입력함.. `:w` 을 `:s`로

:bug: string으로 자리수 맞췄는데도 sort가 안됨

> local로 실행했기 때문 => hadoop에서(셔플).

:pencil:local input file 여러 개일 때 실행

> `python your_mr_job_sub_class.py log_01.gz log_02.bz2 log_03`
>
> 그냥 뒤에 붙여 쓰면 됨
>
> https://pythonhosted.org/mrjob/guides/runners.html

:memo:mapper(self, _, line)

> _는 key를 none으로 본다는 것(mapper에서 가능)

:bug: UnicodeEncodeError: 'ascii' codec can't encode character u'\xa0' in position 20: ordinal not in range(128)

> `a.encode('utf-8')`

### example 1

```python
from mrjob.job import MRJob
from mrjob.step import MRStep

class RatingCount(MRJob):
        def steps(self):
                return [
                        MRStep(mapper = self.map_rating_count,
                                reducer = self.reduce_rating_count)
                ]

        def map_rating_count(self, _, line):
                data = line.split(',')
                if data[0] != 'userId':  # 맨 처음에는 column 이름이 넘어오기 때문에 
                        yield data[2], 1

        def reduce_rating_count(self, key, values):
                yield key, sum(values)


if __name__ == '__main__':
        RatingCount.run()
```



|               result in local               |               result in hadoop               |
| :-----------------------------------------: | :------------------------------------------: |
| ![result_local](./screenshot/rating1-1.png) | ![result_hadoop](./screenshot/rating1-2.png) |

> 하둡에서 실행 시 (key)정렬됨을 알 수 있음.



### example 2

```python
from mrjob.job import MRJob
from mrjob.step import MRStep

class PopularMovie(MRJob):
        def steps(self):
                return [
                        MRStep(mapper = self.map_rating_count,
                                combiner = self.combine_rating_count,
                                reducer = self.reduce_rating_count),
                        MRStep(reducer = self.reduce_sort)
                ]

        def map_rating_count(self, _, line):
                data = line.split(',')
                if data[0] != 'userId':
                        yield data[1], 1

        def combine_rating_count(self, movie_id, count):
                yield movie_id, sum(count)

        def reduce_rating_count(self, movie_id, counts):
                yield str(sum(counts)).zfill(6), movie_id

        def reduce_sort(self, count, movie_ids):
                for movie in movie_ids:
                        yield movie, count

if __name__ == '__main__':
        PopularMovie.run()
```

|               result in local               |               result in hadoop               |
| :-----------------------------------------: | :------------------------------------------: |
| ![result_local](./screenshot/rating2-1.png) | ![result_hadoop](./screenshot/rating2-2.png) |



### Homework

```python
from mrjob.job import MRJob
from mrjob.step import MRStep
from collections import defaultdict
import csv

class Rating(MRJob):
        def steps(self):
                return [
                        MRStep(mapper = self.map_rating,
                                reducer = self.reduce_sum_rating),
                        MRStep(reducer = self.reduce_sort_rating)
                ]

        def map_rating(self, _, line):
                splits = csv.reader([line]).next()
                if splits[0] != 'userId' and splits[0] != 'movieId':
                        if len(splits) == 4:
                                yield splits[1], (float(splits[2]), 1) # movieId, (rating, count)
                        else:
                                yield splits[0], splits[1] # movieId, title

        def reduce_sum_rating(self, movie_id, values):
                dict_ratings = defaultdict(list)
                dict_title = defaultdict(str)
                for value in values:
                        if type(value) == list:
                                dict_ratings[movie_id].append(value)
                        else:
                                dict_title[movie_id] = value.encode('utf-8')
                for k,v in dict_ratings.iteritems():
                        sum_ratings = sum(int(i) for i,j in v)
                        sum_counts = sum(int(j) for i,j in v)
                        if sum_counts >= 100:
                                yield "%03.2f"%round(sum_ratings/(sum_counts*1.0),2), dict_title[k] 
                                
                                ## 
%08.6f_%08f"%(r_mean, r_cnt), title
                                
        def reduce_sort_rating(self, rating, title):
                for t in title:
                        yield t, float(rating)


if __name__ == '__main__':
        Rating.run()
```

- **문제 해결 전략**

  - **평균 평점 구하기**
    1. mapper : movieId를 key로 (rating, 1)을 value로 보낸다.
    2. reducer : value를 list로 갖는 dictionary를 만든다.
    3. movieId를 key값으로 하여 해당되는 value(rating, 1)들을 dictionary에 넣는다.
    4. dictionary의 각 key값마다 value들을 더한다.
    5. rating을 더한 값에서 count(1) 더한 값을 나눈다.
  - **평점이 100회 이상 이루어진 영화만 계산**
    1. reduce : 위의 4번 과정에서 count 더한 값이 100 이상인지 확인한다.
  - **평점 오름차순 정렬**
    1. reduce : 평균 평점을 구한 값을 문자열로 변환한다.
    2. 변환한 값을 key로 보낸다.
  - **id 대신 이름 출력**
    1. mapper : movies.csv의 title에 ,가 포함되어있어 csv를 이용하여 구분한다.
    2. 구분한 리스트의 크기가 4이면 ratings.csv로 movieId, (rating, count)를 보내고 그렇지 않으면 movieId와 title을 보낸다.
    3. reduce : value를 str으로 갖는 dictionary를 만든다.
    4. movieId를 key값으로 하여 해당되는 title을 dictionary에 넣는다.
    5. movieId를 출력하는 대신 dict[movieId]를 출력한다.

- **설명**

   Rating은 하나의 mapper와 두 개의 reducer로 구성되어 있다. 

   먼저, mapper인 map_rating은 key는 none, value로는 개행문자가 제거된 line을 받는다. 받은 line을 구분하고 input 파일이 여러 개이므로 구분된 line의 크기로 파일을 구분한다. ratings.csv 파일인 경우에는 key가 movieId이고 value가 (rating, 1) 을 보내게 되고 movies.csv 파일인 경우에는 key가 movieId이고 value가 title인 것을 보내게 된다.

   위 mapper에서 보낸 것을 reducer인 reduce_sum_rating 함수가 받게 된다. rating과 count를 넣고 title을 넣을 두 개의 dictionary(dict_ratings, dict_title)를 만든다. 그리고 mapper에게 받은 value의 type이 리스트인지 아닌지 구분한다. 리스트일 경우 그 리스트를 dict_ratings[movie_id]에 넣고 아닐 경우 dict_title[movie_id]에 value값을 넣는다. dict_ratings를 루프 돌려서 리스트의 첫 번째 값(rating)끼리 두 번째 값(count)끼리 더한다. count 더한 값이 100 이상이면 평균 평점을 계산하고 반올림하여 문자열로 변환한다. 이 값을 key로 보내고 value값으로는 해당 값의 영화 타이틀(dict_title[k])을 보낸다.

   두 번째 reducer인 reduce_sort_rating에서는 정렬된 평균 평점과 타이틀을 출력하게 된다.

- **실행 방법**

  `$ python hw2_rating.py -r hadoop --hadoop-streaming-jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar hdfs:///user/maria_dev/ml-latest-small/ratings.csv hdfs:///user/maria_dev/ml-latest-small/movies.csv`
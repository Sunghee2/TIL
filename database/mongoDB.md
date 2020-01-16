# MongoDB

- C++로 작성된 오픈소스 Document-Oriented적 Cross-platform 데이터 베이스

- Collection

  - Document의 그룹(RDMS의 table과 비슷한 개념)
  - 스키마를 가지고 있지 않음

- Document

  - key-value pair

    ```json
    {
    	"_id": ObjectId("5099803df3f4948bd2f98391"),
      "username": "Sunghee2",
      "birthday": { month: 6, day: 30 },
    }
    ```

  - _id

    - 12bytes의 hexadecimal값으로, 각 document의 unique value
    - 첫 4byte : timestamp, 3 byte : machine id, 2 byte : mongodb 서버의 process id, 3 bytes 순차번호

  - dynamic한 schema를 가지고 있음(서로 다른 key를 가지고 있을 수 있음)

## Modeling

- 객체들을 함께 사용하게 된다면 하나의 Document에 합쳐서 사용함

  > 읽을 때 join하는 것이 아니라 삽입할 때 join시켜서 넣음

## CRUD

### Create

```mongodb
db.users.save({}) 
```

### Read

```mongodb
db.users.find({
	
})
```

## Index

- 자주 조회되는 필드를 따로 저장하여 조최 및 정렬 시 속도 향상
- index를 걸면 해당 key를 가지고 document를 가리키는 포인터값으로 이루어진 B-Tree(Balanced Binary search Tree)생성
- 오름차순 1, 내림차순 -1 (정렬방향을 고려해야함)
- 쿼리 당 하나의 인덱스만 사용하므로 주의
- 입력, 수정, 삭제가 빈번한 필드는 가능하면 설정 X
- collection의 절반 이상을 반환하는 경우는 사용하지 않음

```
db.users.createIndex({ name: 1, age: -1 })
```

https://m.blog.naver.com/PostView.nhn?blogId=suresofttech&logNo=221096609752&proxyReferer=https%3A%2F%2Fwww.google.com%2F

> 만약 인덱스가 없는 상태에서의 테스트가 필요하다면 다음과 같이 `$natural` 옵션을 넣어서 테스트 할 수 있습니다.
>
> `db.people.find(   { name: "John Doe", zipcode: { $gt: "63000" } } ).hint({ $natural: 1 })`

- 인덱스 크기 확인

  ```
  db.students.totalIndexSize()
  ```

- 인덱스 최적화

  - 파이프라인 첫 부분에 발생하는 match

  - project, unwind, group이 앞에 오지 않는 sort

  - sort + group(함수 first만 사용) = 둘의 field 동일 할 때 sort order에 맞는 index 생성

    ```javascript
    db.foo.aggregate([
      {
        $sort:{ x : 1, y : 1 }
      },
      {
        $group: {
          _id: { x : "$x" },
          y: { $first : "$y" }
        }
      }
    ])
    ```

  - geoNear 사용할 때? 이건 안 쓸 것 같아서 자세히 적진 X -> 나중에 document에서 확인하길(https://docs.mongodb.com/manual/core/aggregation-pipeline/#aggregation-pipeline-operators-and-performance)

## 샤딩

https://www.youtube.com/watch?v=_SVS4qn8HuY&list=PL9mhQYIlKEheyXIEL8RQts4zV_uMwdWFj&index=10&t=0s

## 최적화

- eval()

  - 로컬 mongoDB 콘솔에서 수정 명령어를 입력하면 원격 mongodb에서 데이터를 로컬로 불러와서 처리한 뒤 다시 원격지에 저장함

  - eval 명령어를 사용하면 원격지에서 바로 명령어를 실행한 뒤 결과를 받는 것 가능

    > 명령어를 로컬에서 실행하면 모든 100,000개의 전화번호 데이터를 각각 로컬로 읽고 처리하면서 하나씩 다시 원격 서버에 저장하게 됨. 이 경우 eval 명령어를 사용하면 효율을 높일 수 있음
    >
    > ```
    > db.eval(update_area);
    > db.eval("distinctDigits(db.phones.findOne({''}))")
    > ```

- https://github.com/KWSStudy/Mongodb/wiki/인덱싱과-쿼리-최적화
  - scanAndOrder를 피한다. 즉, 쿼리가 정렬을 포함하고 있으면 인덱스를 사용한 정렬을 시도한다.
  - 유용한 인덱스 제한 조건으로 모든 필드를 만족시킨다. 즉, 쿼리 실렉터에 지정된 필드에 대한 인덱스를 사용하도록 노력한다.
  - 쿼리가 범위를 내포하거나 정렬을 포함하면 마지막 키에 대해 범위나 정렬에 도움이 되는 인덱스를 선택하라
  - hint는 쿼리 옵티마이저로 하여금 강제로 특정 인덱스를 사용하도록 만드는 것이다. 특정 인덱스를 선택하지 않은 경우가 명확하지 않을 경우 사용하면 된다.
- https://m.blog.naver.com/PostView.nhn?blogId=suresofttech&logNo=221234725078&proxyReferer=https%3A%2F%2Fwww.google.com%2F

> 모니터링 도구 : robomongo, munin, mms, mongoVue, pandora FMS, Meteor
>
> 쿼리도구 explain 활용(쿼리수행결과 통계 정보를 통한 성능개선점 찾기)
>
> - **executionStats 모드**
>   - 인덱스 사용 여부
>   - 스캔한 문서들의 수
>   - 쿼리의 수행 시간
> - **allPlansExecution 모드**
>   - 쿼리 계획을 선택하는데 필요한 부분적인 실행 통계
>   - 쿼리 계획을 선택하게 된 이유

## OLAP 구현

http://slidegur.com/doc/3402173/슬라이드-1



https://m.blog.naver.com/PostView.nhn?blogId=humongousdb&logNo=220090948183&targetKeyword=&targetRecommendationCode=1

### Aggregate

- aggregate pipeline은 RAM 100메가의 제약사항을 가지고 있음

  - `allowDiskUse` option을 사용하면 disk에 swap파일을 생성하여 연산 => 속도 느려짐

- 최적화

  - https://docs.mongodb.com/manual/core/aggregation-pipeline-optimization/
  - https://docs.mongodb.com/manual/reference/operator/aggregation/group/#group-pipeline-optimization
  - 나중에 정리^^;;;
  - 특정 집합을 취할 때 보다 많이 걸러내기!

  1. Projection

     - sort + match => 당연히 match 먼저 와서 걸러낸 후에 정렬하는 것이 좋음

       ```
       { $match: { status: 'A' } },
       { $sort: { age : -1 } }
       ```

     - Skip + limit : skip할 때 몇 개의 document에서 skip할 지 성능 영향

       > 100만 개 중에 5개를 skip - 10개 중에 5개 skip 다름

       ```
       { $skip: 10 },
       { $limit: 5 }
       
       <최적화>
       { $limit: 15 },
       { $skip: 10 }
       ```

- find와의 차이점
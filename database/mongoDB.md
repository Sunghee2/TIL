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
    - 첫 4byte : timestamp, 3 byte : machine id(보통 드라이버따라 다르지만 mac address + ip address), 2 byte : mongodb 서버의 process id, 3 bytes 순차번호(랜덤 번호에서 auto increment)

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

- Scale up / Scale out

  - 한 서버에서 처리하지 못할 정도의 부하가 발생했을 때 해결책
  - `Scale up` : 머신 자체의 성능을 올리는 것 (비용 큼) (= vertical scaling)
  - `Scale out` : 새로운 머신 추가 (= horizontal scaling)
  - `sharding` :  `scale out` 의 일종으로 데이터를 여러 서버에 나눠서 저장하는 방식
  - `shard` : 데이터가 저장된 서버
  - `sharded cluster` : `shard` 를 포함한 몽고디비 호

- 목적

  - 데이터의 분산 저장

    - 단 한 대의 서버에 빅데이터 저장하는 것 불가능
      - 문제점 : 서비스 성능 저하, 하드웨어 한계
    - 데이터를 분산하여 순차적으로 저장한다면 한 대 이상에서 트래픽을 감당하기 때문에 부하를 분산하는 효과가 있음

  - 백업, 복구 전략

    - 서버의 데이터가 유실된다면 그 데이터 양은 상상 초월할 것이고 시스템 복구에 엄청난 시간, 비용 소요

    -> 미리 데이터를 분산하여 저장하면 리스크 낮아짐

  - 빠른 성능
    - 여러 대의 독립된 프로세스가 병렬로 작업을 동시에 수행

- 특징

  - 성능보장을 위해 3대 이상의 서버를 샤드로 활용하는 것 추천

- 장점

  - 시스템의 성능 향상
  - 데이터 유실 가능성으로부터 보호

- 단점

  - 메모리 20%~30% 추가 사용

    > 샤드 시스템 구축 시 사용하는 라우팅서버인 mongos와 OpLog, Balancer 프로세스가 추가로 메모리를 사용하기 때문.

- 시스템 구조

  ![img](https://static.packt-cdn.com/products/9781783982608/graphics/3eec5c1b-ecab-4131-9a67-a4e277c1737a.png)

  - `mongos` : router 역할

    - 하나 이상의 프로세스를 사용함
    - 빅데이터를 샤드키를 중심으로 샤드 서버로 분산해주는 프로세스임 
    - 데이터를 쓰고 읽는 작업 가능

  - `replica set` : 샤드 안에서 데이터 분실 가능성 방지 위해 mongod를 이용해서 replica set 만듦

  - `config servers` : 메타 데이터 저장/관리(어떤 데이터가 어디에 저장되어있는지)

    - 샤드 서버와 별도의 서버에 구축이 기본

      > 분산해서 처리할 때 장애가 발생해도 신속하게 대응 가능

    - 샤드 서버에 비해 저사양 서버 사용 가능(단순히 메타 데이터라서)

- 샤딩 시스템 계층

  ![img](http://mongodb.citsoft.net/wp-content/uploads/pic4-2.png)

  - 중계자 계층(`mongos`)
    - 샤드 메타 정보를 저장해서 응용 계층으로부터 전달된 쿼리를 분석하여 적절한 샤드에 명령을 수행시킨 뒤 그 결과를 응용 계층으로 다시 전달해줌
  - `application` : 우리가 사용하는 어플리케이션

- shard key 구성

  - 여러 개의 샤드 서버로 분할될 기준 필드(partition, load balancing 기준) -> 데이터 저장 성능에 절대적인 영향

  - cardinality를 보고 선택

    > 데이터 분포가 넓으면 낮음
    >
    > ex) 사원번호는 고유한 값으로 구성되면 높은 cardinality, 성별로 나누면 낮음

  - chunk migration의 횟수와 빈도를 결정

    > chunk : 데이터 분할 단위 (기본적으로 64MB)
    >
    > migration : 데이터의 이동, 서버에 균등하게 데이터를 재조정하는 과정

    - 기본 설정 단위보다 빈번하게 chunk migration이 발생 -> chunk 단위 크게
    - 하나의 서버에 데이터가 집중되고 골고루 데이터가 분산되지 않음 -> chunk 단위 작게 

- MongoDB 샤딩 한계

  - 한 chunk에 저장될 수 있는 BSON 객체 개수 25만 개

  - mongos 밑의 여러 대 서버 중 하나가 장애가 발생했을 때, mongos는 이 서버가 여전히 살아있다고 생각하고 데이터를 계속 그 쪽으로 보내면 데이터가 유실됨.

    > 정말 중요한 데이터는 RDBMS에 저장
    >
    > MongoDB에는 대량으로 발생하고 일부 데이터가 유실되더라도 문제가 없는 종류의 데이터 처리

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
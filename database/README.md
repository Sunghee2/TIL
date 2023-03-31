# Database

- Database : 관련성을 가지며 중복이 없는 데이터들의 집합

- DBMS : 데이터베이스를 관리하는 시스템

- NoSQL vs. SQL

  |           SQL            |                 NoSQL                  |
  | :----------------------: | :------------------------------------: |
  | 규칙에 맞는 데이터 입력  |    자유로운 데이터 입력(컬럼 정의x)    |
  |        JOIN 지원         |               JOIN 안 됨               |
  |      트랜잭션 지원       |  트랜잭션 미지원(데이터 일관성 문제)   |
  |      안정성, 일관성      | 확장성, 가용성(빠르고, 쉽게 서버 분산) |
  | 용어(테이블, 로우, 컬럼) |      용어(컬렉션, 다큐먼트, 필드)      |

  > 트랜잭션 : 여러 쿼리가 모두 정상적으로 수행되거나 아예 하나도 수행되지 않음을 보장하는 기능

- NoSQL 장점

  - schema-less

  - 각 객체 구조 뚜렷

  - 복잡한 join 없음

  - Deep query ability (문서지향적 query language를 사용하여 SQL만큼 강력한 query 성능 제공)


## OLTP / OLAP 

- OLTP (On-line transaction processing)
  - 실시간 비즈니스 트랜잭션의 원활한 처리를 최우선
- OLAP (On-line analytical processing)
  - 의사결정에 도움되는 데이터 분석

## Data warehouse

오랜기간동안 기업의 업무 과정을 통해 수집된 데이터를 대규모의 통합 DB로 구축해놓은 것
# Node.js

*Node.js는 크롬 V8 자바스크립트 엔진으로 빌드된 자바스크립트 런타임*

*Node.js는 이벤트 기반, 논블로킹 I/O 모델을 사용해 가볍고 효율적임* 

> 런타임 : 특정 언어로 만든 프로그램들을 실행할 수 있는 환경
>
> => Node.js는 자바스크립트 프로그램을 컴퓨터에서 실행할 수 있게 해줌

> 이벤트 기반 : 이벤트가 발생할 때 미리 지정해둔 작업을 수행하는 방식(ex. 클릭, 네트워크 요청 등)
>
> 논블로킹 I/O : 이전 작업이 완료될 때까지 멈추지 않고 다음 작업을 수행(node가 single thread라서)
>
> ​		javascript가 single thread 특성을 띠고 있어 노드는 프로세스 자체를 복사해 여러 작업을 동시에 처리하는 멀티 프로세싱 방식

- 장점

  - multi thread 방식에 비해 컴퓨터 자원을 적게 사용
  -  I/O 많은 작업에 적합
  - 웹 서버 내장
  - JSON 형식과 호환 쉬움(JSON이 자바스크립트 형식)

- 단점

  - CPU core를 하나 밖에 사용 못함(CPU 부하 큰 작업에 적합하지 않음)

  - 에러를 제대로 처리하지 못하면 서버 전체가 멈춤

  - 서버 규모가 커졌을 때 서버를 관리하기 어려움

  - 어중간한 성능

    > Go, nginx보다 속도 느림

- 서버

  - Node.js 추천

    - 개수는 많지만 크기는 작은 데이터를 실시간으로 주고 받는 데 적합(ex. 실시간 채팅, 주식 차트, json 데이터를 제공하는 api서버 등)

  - Node.js 비추천

    - 이미지, 비디오 처리, 대규모 데이터 처리 같이 CPU를 많이 사용하는 작업을 위한 서버

    > 노드로 CPU를 많이 사용하는 작업은 AWS Lambda, Google cloud functions 사용

- 서버 외의 노드

  - 노드 기반으로 돌아가는 대표적인 웹 프레임워크 : React, Angular, Vue 등

<br/>

- 서버와 클라이언트

  - 서버 : 네트워크를 통해 클라이언트에 정보나 서비스를 제공하는 컴퓨터
  - 클라이언트 : 요청을 보내는 주체 (ex. 브라우저, 앱 등)

  > www.github.com 입력 --> 브라우저는 그 주소에 해당하는 컴퓨터 위치를 파악. 그 컴퓨터에서 웹 사이트 페이지를 받아와 브라우저(클라이언트)에 띄워줌

  > HTTP 상태 코드
  >
  > - 2xx : 성공을 알리는 상태코드 (ex. 200: 성공, 201: 작성됨)
  > - 3xx : 리다이렉션을 알리는 상태 코드 (ex. 301: 영구 이동, 302: 임시 이동)
  > - 4xx : 요청 오류 (ex. 401: 권한 없음, 403 : 금지됨, 404 : 찾을 수 없음)
  > - 5xx : 서버 오류. 요청은 제대로 왔지만 서버에 오류가 생겼을 때 (ex. 500 : 내부 서버 오류, 502 : 불량 게이트웨이, 503 : 서비스를 사용할 수 없음)

  > HTTP method
  >
  > - get : 서버 자원을 가져오고자 할 때 사용. 
  > - post : 서버에 자원을 새로 등록하고자 할 때 사용
  > - put : 서버의 자원을 요청에 들어 있는 자원으로 치환하고자 할 때 사용
  > - patch : 서버 자원의 일부만 수정하고자 할 때 사용.
  > - delete : 서버의 자원을 삭제하고자 할 때 사용

- 쿠키와 세션
  - 쿠키	
    - 서버는 요청에 대한 응답을 할 때 쿠키라는 것을 같이 보냄. 쿠키는 name=sunghee와 같이 단순한 'key-value' 쌍임. 서버로부터 쿠키가 오면 웹 브라우저는 쿠키를 저장해두었다가 요청할 때마다 쿠키를 동봉해서 보냄. 
    - request, response의 header에 저장됨

- Rest API

  - 서버의 자원을 정의하고, 자원에 대한 주소를 지정하는 방법
  - Rest API를 따르는 서버를 RESTful하다고 표현

- Https / Http2

  - https : 웹 서버에 SSL 암호화를 추가

    > GET이나 POST 요청 시 오고 가는 데이터를 암호화해서 중간에 다른 사람이 가로채더라도 내용을 확인할 수 없게 해줌.

  - http2

    - 한 connection으로 동시에 여러 메시지 주고 받기 가능
    - 응답은 순서에 상관없이 stream으로 주고 받음

    > http1
    >
    > - connection 당 하나의 요청 처리
    >
    > - 동시 전송 불가능
    > - 요청과 응답이 순차적
    > - 단점
    >   - 요청할 리소스 개수에 비례해서 대기 시간 길어짐
    >   - 매 요청 별로 connection을 만들고 3-way handshake가 반복적으로 일어나 성능 저하
    >   - 매 요청마다 중복된 header값 전송

    ![](http://blog.restcase.com/content/images/2018/01/http1-vs-http2-multiplexing.png)

- cluster

  - single thread인 노드가 CPU core을 모두 사용할 수 있게 해주는 모듈

    > core가 8개인 서버가 있을 때, 노드는 보통 core를 1개만 활용함. 하지만 cluster모듈을 설정하여 core 하나 당 노드 프로세스 하나가 돌아가게 할 수 있음.

  - 단점 : 세션을 공유하지 못함 -> Redis 서버를 도입하여 해결할 수 있음

- CORS(Access-Control-Allow-Origin)

  - 보안 상의 이유로 브라우저들이 다른 도메인에게 XHR 요청을 보내는 것 제한
  - 서버에서 해결해야함

### Express

> npm : node package manager 
> express : 웹 서버 프레임 워크. 

- Express 구조

  - bin/www : http 모듈에 express 모듈을 연결하고, 포트를 지정하는 부분

- 미들웨어 : 요청과 응답을 조작하여 기능을 추가함

  - morgan : 요청에 대한 정보를 콘솔에 기록

  - body-parser : 요청의 본문을 해석해주는 미들웨어. 보통 폼 데이터나 ajax 요청의 데이터를 처리 

  - cookie-parser : 요청과 함께 온 쿠키를 해석

    - `app.use(cookieParrser('secret_code'))` : 이 문자열로 쿠키가 서명 됨. 서명된 쿠키는 클라이언트에서 수정했을 때 에러가 발생하므로 클라이언트에서 쿠키로 위험한 행동을 하는 것을 방지

  - static : 정적인 파일 제공

  - express-session : 세션 관리용 미들웨어

    ```javascript
    app.use(session({
      // 요청이 왔을 때 세션에 수정사항이 생기지 않더라도 세션을 다시 저장할지
      resave: false,
      // 세션에 저장할 내역이 없더라도 세션을 저장할지(보통 방문자 추적에 사용)
      saveUninitialized: false,
      // 세션 관리시 클라이언트에 쿠키(세션 쿠키)를 보냄. 안전하게 쿠키를 전송하려면 쿠키에 서명을 추가해야하고 쿠키에 서명하기 위해 이 secret 필요
      // cookie-parser의 secret과 같게 설정
      secret: 'secret_code',
      // 세션 쿠키에 대한 설정
      cookie: {
        // 클라이언트에서 쿠키를 확인하지 못함
        httpOnly: true,
        // https가 아닌 환경에서도 사용 가능
        secure: false,
      }
    }))
    ```



### Sequelize

- ORM : 자바스크립트 객체와 데이터베이스의 relation을 매핑해주는 도구
- 쓰는 이유 : 자바스크립트 구문을 알아서 SQL로 바꿔줌

### 토큰 기반 인증

- 토큰을 사용하여 사용자들의 인증 처리
- 선택 이유
  - stateless 서버 : 서버는 상태 정보를 저장하지 않아 클라이언트 측에서 오는 요청으로만 작업을 처리함(확장성 높아짐)
  - 모바일 어플리케이션 적합
  - 인증 정보를 다른 어플리케이션에 전달 ex. OAuth
  - 보안
- 과정
  1. 사용자가 로그인
  2. 서버에서 해당 정보 검증
  3. 정보가 맞다면, 서버가 사용자에게 토큰 발급
  4. 클라이언트 측에서 전달 받은 토큰을 저장하고, 서버에 요청할 때마다 해당 토큰을 함께 서버에 전달
  5. 서버는 토큰을 검증하고, 요청에 응답
- 서버 기반 인증
  - 서버 측에서 유저 정보 기억
  - 단점
    - session : 사용자가 인증할 때, 서버는 이 기록을 서버에 저장해야되는데 사용자 수가 늘어나면 과부화
    - 확장성 : 세션을 사용하면서 분산된 시스템 설계 어려움
    - CORS : 세션관리 시 쿠키는 단일 도메인 또는 서브 도메인에서만 작동하도록 설계됨. 따라서 쿠키를 여러 도메인에서 관리하는 것 번거로움

<br/>

![그림](https://d2.naver.com/content/images/2019/01/helloworld-201811-apollo_04.jpg)

### 개발과 운영도구

> https://d2.naver.com/helloworld/4994500

### 보일러플레이트

프로젝트를 처음부터 완전히 새로 작성하는 것보다는 일종의 프로젝트 템플릿인 [보일러플레이트](https://en.wikipedia.org/wiki/Boilerplate_code)를 활용하는 것이 훨씬 효율적이다. JavaScript에는 [Yeoman](http://yeoman.io/generators)이라는 보일러플레이트 생성 도구가 있다. 다양한 생성기가 있으니 인기도가 높은 것을 선택해 사용한다.

### 빌드 도구

프로젝트를 빌드하는 도구로는 [webpack](https://webpack.github.io/), [gulp](http://gulpjs.com/), [Grunt](http://gruntjs.com/) 등을 사용한다. 최근에는 webpack 사용자가 늘어나고 있고, Grunt 사용자는 줄어들고 있다. + parcel

### 데이터 저장소와 연동

데이터 저장소별로 Node.js를 연동할 때 사용할 수 있는 여러 도구가 있다.

- MongoDB 연동: [Mongoose](http://mongoosejs.com/)
- Elasticsearch 연동: [elasticsearch.js](https://www.elastic.co/guide/en/elasticsearch/client/javascript-api/current/index.html)
- [MySQL](https://www.mysql.com/) 연동: [node-mysql](https://github.com/redblaze/node-mysql)
- [Redis](http://redis.io/) 연동: [node_redis](https://github.com/NodeRedis/node_redis)

### 일괄 작업 관리

일괄 작업(batch)을 관리할 때는 [node-cron](https://github.com/ncb000gt/node-cron), [Node Schedule](https://github.com/node-schedule/node-schedule), [Agenda](https://github.com/rschmukler/agenda) 등을 사용한다.

### 배치 스크립트

일괄 작업을 실행하는 배치 스크립트는 gulp의 스크립트 파일을 작성해 실행한다.

### 템플릿 엔진

템플릿을 사용해 웹 페이지를 구성할 때는 [Jade](http://jade-lang.com/), [mustache.js](https://github.com/janl/mustache.js/) 등의 템플릿 엔진을 사용한다.

### 프로세스 관리

Node.js의 프로세스를 관리하는 도구로는 [PM2](http://pm2.keymetrics.io/)를 추천한다.

PM2를 사용하면 Node.js 프로세스를 여러 개 실행할 수 있다. Node.js에도 프로세스를 여러 개 실행하는 기능이 있지만 추가 코딩이 필요하다.

PM2에는 프로세스가 중지되면 프로세스를 다시 실행하는 기능도 있다. 그 외에 프로세스별로 CPU와 메모리 사용량을 모니터링할 수도 있다.

참고로, 보통 Node.js 프로세스의 개수는 CPU 코어의 개수로 한다. 메모리 용량은 'Node.js 프로세스의 개수 x 1GB'로 넉넉하게 한다. Node.js처럼 메모리 관리를 자동으로 하는 플랫폼을 사용할 때는 메모리 용량이 커야 한다.

<hr/>

### 최적화

- 비동기 처리 여러번 -> `Promise.all()` 사용하여 병렬 처리
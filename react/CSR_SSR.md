# CSR vs. SSR

## 웹 개발 발전 방향

1. 전체 HTML로 만드는 방식

2. Ajax 등장 - 동적인 컨텐츠 구성

   ![Google 추천검색어](https://subicura.com/assets/article_images/2016-06-20-server-side-rendering-with-react/google-auto-complete.png)

3. html + javascript

4. framework

   - angularJS : 기존의 라이브러리나 프레임워크들과는 다르게 DOM을 조작하거나 제어하는 방식에 초점을 맞추지 않고 데이터의 변화에 초점을 맞추는 완전히 새로운 접근법 (HTML에 작성해야 하는 코드는 조금 늘었지만 Javascript쪽 코드는 엄청 단순해짐)
     - 장점
       - 개발 속도 빠름
       - 유지보수 쉬움
       - 테스트 코드 작성 용이
       - 프로젝트 분리
     - 단점
       - 속도 느림
       - SEO 이슈
       - FOUC
       - 뒤로가기 누르면 새로 로딩됨
   - ReactJS : MVC프레임워크는 아니고 User Interface(View)를 만드는 라이브러리
     - 서버 사이드 렌더링을 지원하므로 웹앱때문에 생기는 단점이 거의 없고 컴포넌트를 이용한 구조는 개발속도를 빠르게 하고 유지보수를 용이하게 도와줌
     - 장점
       - Virtual Dom 이용하여 빠름
       - 2-way 바인딩 대신 1-way를 지원하고 Component 구성하기 쉬움.

## Isomorphic Javascript

- 서버와 클라이언트가 같은 코드를 사용함 (react + node.js)

![Client vs Server rendering from airbnb](https://subicura.com/assets/article_images/2016-06-20-server-side-rendering-with-react/client-side-vs-server-side.png)

SSR(server side rendering) + 코드 스플리팅(필요한 페이지만 불러옴 => 초기 렌더링 속도 향상)

> 일반적으로 검색 엔진의 크롤러들은 데이터를 긁어올 때 웹 페이지의 JS를 해석해서 노출시킴. but CSR은 View를 생성하기 위해 JS가 필요하고(그 전까지는 빈 페이지), View를 생성하기 전까지는 크롤러의 데이터 수집이 제한적

> SSR의 단점
>
> - 프로젝트 구조 복잡
> - 성능의 악화 가능성 : 서버사이드 렌더링을 할 때의 함수가 동기적으로 작동하여 렌더링하는 동안 다른 작업을 못하게 됨 => but 비동기식 렌더링 코드 있음

> SPA(single page application) 
>
> - 처음에 하나의 single page(빈 페이지)를 서버측에 제공하고, view에 대해서는 client에서 특정 라이브러리 혹은 프레임워크를 사용해 렌더링하는 방식
> - CSR(client side rendering)
> - 단점 : 앱의 규모가 커지면 자바스크립트 파일 사이즈가 너무 커져 로딩속도 지연(사용자가 실제로 방문하지 않을 수도 있는 페이지에 관련된 스크립트도 불러옴 + 자바스크립트 번들 파일에 모든 애플리케이션의 로직을 불러오기 때문에) => 코드 스플리팅

- 장점
  - 사용자가 처음으로 컨텐츠를 보는 속도가 빨라짐
  - 서버, 클라이언트 따로 작성하던 코드가 하나로 합쳐짐
  - SEO 적용 가능
  - 웹앱에서의 단점 대부분 사라짐(속도 등)



Single page application : 페이지가 1개인 어플리케이션

![img](https://thebook.io/img/006946/361_1.jpg)

- 뷰 렌더링을 브라우저가 담당. 로딩 후 필요한 데이터만 전달받음

- 서버에서 제공하는 페이지 하나이지만, 로딩 한 번 하고 나면 웹 브라우저에서 나머지 페이지들 정의

  > 페이지 이동 시, 새 페이지에 필요한 데이터만 받아오는 것
  >
  > 주소에 따라 다른 뷰를 보여주는 것 -> routing

> 기존에는 여러 페이지로 구성
>
> ![img](https://thebook.io/img/006946/360.jpg)
>
> - 유저가 요청할 때마다 페이지 새로고침하며, 페이지를 로딩할 때마다 서버에서 리소스를 전달받아 해석한 후 렌더링.
> - HTML 등을 사용해서 뷰를 어떻게 보일지도 서버에서 담당.
> - 웹에서 제공하는 정보가 많아지면서 속도 문제 => 캐싱, 압축으로 서비스 제공 but 이 방법은 사용자와 상호 작용이 많은 곳에서는 충분X
> - 서버에서 렌더링 -> 서버 자원을 렌더링하는데 사용하므로 불필요한 트래픽이 낭비

기존 웹어플리케이션은 javscript의 로딩이 모두 완료된 후 View를 그리기 시작한다. 그러나 서버 랜더링을 통해 미리 View를 만들어 내려주면 js가 로드되기 이전에도 사용자는 View를 볼 수 있다. 실제 사용자가 처음 UI를 보게 되는 시간이 js 로딩 후 렌더링되는 시간만큼 줄어드는 것이다. 또 js가 로딩되기 전엔 빈 화면만 보여주기 때문에, 크롤러(웹 사이트의 문서를 읽어와서 검색엔진에 저장해주는 bot)들이 접속했을 때 정보를 긁어갈 수 없으므로 검색 엔진에 노출되는데 불리한 점이 있다.(물론 구글같이 js를 실행해서 완성된 문서를 크롤링하는 곳도 있다.)

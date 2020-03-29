# Monorepo

Monorepo는 여러 프로젝트 코드를 하나의 repository에서 관리하는 패턴입니다. 대표적으로 Lerna, yarn workspaces가 있습니다.

![img](https://miro.medium.com/max/1342/1*jXZ26bo8TQE1Q0RBMan8kQ.jpeg)

- 개발의 독립성 보장
  - 모듈화 - 프로젝트가 명확하게 분리되어 설계
  - 분리된 모듈을 효율적으로 관리

## 장점

- 패키지 간의 느슨한 결합 / 패키지 강한 독립성
  - 하나의 eslint, prettier, bable 등의 설정을 공유할 수 있습니다. (독립된 lint, build, deploy)
  - 코드 재사용 - 프로젝트간 비슷한 로직을 중복구현하지 않고 쉽게 공유할 수 있습니다. (연관된 코드 수정 변경이 용이)
  - 모듈별 개별적인 버전 관리
- 프로젝트간 공통적인 npm패키지를 root에 설치할 수 있어 설치해야하는 패키지 크기를 줄일 수 있습니다.
- 이슈관리, 버전관리, 배포 및 테스트 관리를 한 곳에서 할 수 있어 간편합니다. (하나의 레포에서 작업 내역 추적 가능)
- 한 번의 클론으로 n개 이상의 모듈 개발 환경 구축
- 마이크로 서비스, 서비리스 아키텍처에 적합한 구조

## 단점

- 초기 세팅이 복잡합니다.
- 여러 프로젝트 코드를 하나의 repository로 묶어 repository 크기가 커질 수 있습니다.

## [Lerna](https://lerna.js.org/)

lerna는 monorepo의 workflow를 최적화 하는 도구입니다. 프로젝트 전체를 빌드하거나 테스트할 때, 또는 변경있는 패키지들을 배포할 때 도움을 줍니다. 그리고 여러 repository의 패키지를 묶어주는 역할을 하며, 각 패키지별 업데이트를 도와줍니다. Yarn, npm cli를 사용하여 프로젝트를 bootstrap(각 패키지에 대한 모든 종속성 설치)합니다. 즉, 프로젝트 내의 각 패키지를 호출한 다음 서로 참조하는 패키지 간에 심볼릭 링크를 만듭니다.

### 주요 기능

- lerna publish : 지난 릴리즈 이후 변경이 있었던 패키지를 배포합니다.
- lerna version : 패키지별로 변경된 패키지의 버전을 변경할 수 있습니다.
- lerna bootstrap: 여러 레파지토리의 dependency들을 묶어서 각 패키지별 라이브러리를 중복 없게 설치할 수 있습니다.
- 각 패키지에서 npm install + 모듈 간의 symbolic link 연결
- lerna link convert : 각 패키지의 devDependencies를 root에서 관리할 수 있습니다.
- lerna clean : 각 패키지의 node_modules 삭제


## [Yarn workspaces](https://classic.yarnpkg.com/en/docs/workspaces/)

Yarn Workspaces는 Lerna의 의존성 관리 부분인 하위 폴더에있는 여러 package.json 파일의 dependency들을 root에 있는 node_modules에 한 번에 설치할 수있는 기능입니다. 이 workspace에 있는 프로젝트들은 서로 참조하는 연관 관계를 가질 수 있습니다. 이를 통해 의존성 패키지의 상호 공유와 업데이트를 편리하게 할 수 있도록 도와줍니다. yarn workspaces에서는 lerna와 같이 많은 기능을 제공하지 않지만 프로젝트간 연관관계를 쉽게 표현할 수 있습니다.

## 사용 예시

- [babel](https://github.com/babel/babel/tree/master/packages)
- [RxJS](https://github.com/Reactive-Extensions/RxJS/tree/master/modules)
- [Angular](https://github.com/angular/angular/tree/master/modules)
- [Meteor](https://github.com/meteor/meteor/tree/devel/packages)
- [cycle.js](https://github.com/cyclejs/cyclejs)

- [pouchdb](https://github.com/pouchdb/pouchdb/tree/master/packages/node_modules)


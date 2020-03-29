

# graphql

- 장점

  1. REST API 를 GraphQL 로 대치할 수 있기에 기존 backend 와 비지니스 로직을 유지할 수 있습니다.
  2. 기존 React app에  GraphQL을 컴포넌트 단위로 적용할 수 있습니다.
  3. GraphQL 툴(tools)은 server code가 있는 곳이라면 어디든 실행 가능하므로 기존 application 인프라로 손쉽게 통합 가능합니다.

- 단점

  1. Http caching전략을 그대로 사용할 수 없음

     HTTP의 캐싱 전략은 http 헤더에 정책을 설정하는 형식으로 이루어집니다. REST API의 경우 URL마다 각각의 캐싱 전략을 적용하는 것이 가능합니다. 그러나 end point가 하나인 graphQL의 경우 이러한 http 캐싱 전략을 그대로 이용하기 어렵습니다.

     이를 보완하기 위해 http caching을 지원해야하는 자원관련 서버(웹서버)를 분리하였습니다. 또한 apollo engine을 이용하여 api 요청에 대한 결과를 캐싱하고 있습니다.

  2. 파일업로드에 추가비용이 들어감

     multipart/formData같은 파일 업로드 방식이 지원되지 않아 파일업로드 시 base64로의 인코딩이 필요합니다.

     이러한 비용을 줄이고, 서비스를 작은 단위로 모듈화하기 위해 이미지 컨버터 서버를 분리하였습니다. 파일 업로드 및 해당 파일의 parsing을 담당하는 역할로, REST API 방식으로 개발하였습니다.

- graphql은 구조(schema)와 행동(Resolver)이 분리되어있습니다.

- **스키마 :** 스키마는 GraphQL 서버를 통해 가져올 수있는 데이터 모델입니다. 클라이언트가 수행 할 수있는 쿼리, 서버에서 가져올 수있는 데이터 유형 및 이러한 유형 간의 관계가 무엇인지 정의합니다. 

- GraphQL의 가장 큰 특징은 클라이언트에서 모든 백엔드 복잡성을 숨길 수 있다는 것입니다. 앱에서 사용하는 백엔드 수에 관계없이 모든 클라이언트는 애플리케이션을위한 간단한 자체 문서화 API가있는 단일 GraphQL 엔드 포인트를 보게됩니다.

- schema

  - GraphQL 타입들의 집합(`Query`, `Mutation`, `Subscription`)
  - 어떤 필드를 선택할 수 있는지, 어떤 종류의 객체를 반환할 수 있는지, 하위 객체에서 사용할 수 있는 필드는 무엇인지 서버에 요청할 수 있는 데이터에 대한 정확한 표현을 갖는 것(클라이언트가 데이터에 접근하는 방법 정의)
  - 스키마 우선 개발 가능
    - 프론트/백엔드 개발자들은 구현 전에 구조에 대해 미리 상의해볼 수 있습니다.

- Resolver 실행 단계

  ```
  query {
  	user(id: "abc") {
  		id
  		name
  	}
  }
  ```

  1. 쿼리 파싱 : 문자열을 보고 AST(abstract syntax tree: 추상 구문 트리)로 바꿉니다. 오류가 있는경우 실행을 중지하고 클라이언트에게 알려줍니다.
  2. 유효성 검사
     - query에 user가 있는가?
     - user에 id라는 인수가 있는가?
     - user return field에 id, name이 있는가?
  3. 실행
     1. root에 있는 user의 resolver를 호출합니다. 이 resolver가 값을 리턴할 때까지 기다린 후(promise resolve) 다음 트리 아래로 내려가면서 진행됩니다. 
     2. user의 리턴값을 받은 id resolver / name resolver가 병렬로 실행됩니다.

- Resolver 인자 4개

  ```javascript
  fieldName(obj, args, context, info) { result }
  ```

  1. `obj`(= `parent`)

     - 이전 resolver의 리턴 값 (첫 번째 resolver일 경우 null)

       ![img](https://cdn-images-1.medium.com/max/3568/1*_fQh0zWBlDG1OJ-FbMnWcw.png)

       Query에서 user(root field), id, name 개의 필드를 가지고 있어 resolver 함수를 3번 호출합니다(필드당 한 번씩). 

       1. `user` resolver를 찾아 실행하고  `{ "id": "abc", "name": "Sarah" }` 를 리턴합니다.
       2. `id` resolver를 실행합니다. 여기서 `obj(parent)`는 `user` resolver의 리턴 값으로 들어오게 되어 해당 객체의 `id`를 리턴합니다.

       > GraphQL에서 field name과 root field를 기반으로 리턴해야하는 항목을 이미 유추할 수 있어 구현을 생략 할 수 있습니다.

  2. `args` : query의 인자 값 (`author(name: "Ada")` 로 호출한 경우 `args` 는 `{ "name": "Ada" }`)

  3. `context` : 모든 resolver로 전달되는 object (인증 정보 등에 사용)

  4. `info` : 현재 쿼리, 스키마 정보와 관련된 정보를 보유하는 object.

     ```javascript
     export type GraphQLResolveInfo = {
       fieldName: string;
       fieldASTs: Array<Field>;
       returnType: GraphQLOutputType;
       parentType: GraphQLCompositeType;
       path: Array<string | number>;
       schema: GraphQLSchema;
       fragments: { [fragmentName: string]: FragmentDefinition };
       rootValue: mixed;
       operation: OperationDefinition;
       variableValues: { [variableName: string]: mixed };
     };
     ```

- 스키마 디자인 : 데이터가 저장되는 방식이 아니라 데이터가 사용되는 방식에 따라 스키마 설계

  - 클라이언트가 사용하지 않는 필드는 스키마에서 생략하기

    > 일부 클라이언트가 사용 중인 기존 필드를 제거하는 것보다 스키마에 새 필드를 추가하는 것이 더 쉽고 안전

## caching

캐시는 GraphQL 서버에 대한 네트워크 요청 수를 줄임으로써 어플리케이션 클라이언트의 응답성을 향상시킵니다. 또한 새 데이터를 가져 와서 캐시에 저장함에 따라 UI 구성 요소를 자동으로 최신 상태로 유지합니다.

apollo-client의 cache state를 사용하여 client의 cache를 읽어오고 업데이트 할 수 있습니다. apollo cache는 Query, Mutation으로 네트워킹한 결과를 자동으로 캐쉬에 기록합니다. 이와 별도로 원하는 만큼의 추가 데이터를 관리할 수 있습니다.

Caching을 통해 쿼리 속도를 획기적으로 향상시킬 수 있지만, 단점으로는 데이터가 업데이트되는 Mutation 요청이 진행되었을 때, 페이지에서 새로고침을 하지않는 한 렌더된 데이터가 변하지 않는 현상이 발생한다는 것이 있습니다. 이는 DB를 조회하기 전, Cache 에 같은 Query의 이름이 있으면, 기존에 Cache에 있던 데이터만 가져오기 때문입니다

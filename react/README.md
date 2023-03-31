React 

1. React?

   - **React** : Facebook이 만든, 프론트엔드 라이브러리 (View만 담당하기 때문에 M, C는 다른 라이브러리, 패키지로 보완해주어야 함)

     > 웹 개발할 때, DOM관리와 상태값 업데이트 관리를 최소화 하고, 기능과 사용자 인터페이스를 구현하는 것에 집중할 수 있도록 하는 것이 프론트엔드 라이브러리 ex. Angular, Vue, React

   - 특징

     - Single page application : 페이지가 1개인 어플리케이션
   
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
       > -  HTML 등을 사용해서 뷰를 어떻게 보일지도 서버에서 담당.
       > - 웹에서 제공하는 정보가 많아지면서 속도 문제 => 캐싱, 압축으로 서비스 제공 but 이 방법은 사용자와 상호 작용이 많은 곳에서는 충분X
       > - 서버에서 렌더링 -> 서버 자원을 렌더링하는데 사용하므로 불필요한 트래픽이 낭비
     
     - Virtual DOM
  - JSX : DOM 엘리먼트들을 만들 때 javascript 형식으로 작성해야하는 것을 XML과 비슷한 형태로 작성할 수 있게 해 줌
    
      - 조건부 연산자 : 삼항연산자, &&, ||
      
        ```javascript
        {condition? 'ok':null}
        {condition && 'ok'}
        ```
    
   - Components  : 중복을 피해서 유지보수를 쉽게 해줌
   
   - 장점
   
     - Virtual DOM을 사용한 어플리케이션의 성능 향상
     - 클라이언트에서도 렌더링 될 수 있고, 서버측에서도 렌더링 될 수 있음(이를 통해 브라우저측의 초기 렌더링 딜레이를 줄이고, SEO 호환 가능)
     - Component의 가독성이 매우 높고 간단하여 유지보수 쉬움
   
   - React 시작
   
     `npm install react react-dom`
   
     > react-dom : react로 만들어진 dom과 가상 dom을 실제 dom에 렌더링할 수 있음. react 코드를 웹에 붙여주는 역할.
   
     ```javascript
     <head>
       <script src="https://unpkg.com/react@16/umd/react.development.js"></script>
     	<script src="https://unpkg.com/react-dom@16/umd/react-dom.development.js"></script>
     </head>
     <body>
     	<div id="root"></div>
     	<script>
     		const e = React.createElement;
     		
     		class LikeButton extends React.Component {
     			constructor(props) {
     				super(props);
     			}
     			
     			render() {
     				return e('button', { onClick: () => { console.log('clicked')}, type: 'submit'}, 'Like');
     			}
     		}
     	</script>
       <script>
         ReactDOM.render(e(LikeButton), document.querySelect('#root'));
     	</script>
     </body>
     ```

2. Virtual DOM

   - DOM - Document Object Model(객체를 통하여 구조화된 문서를 표현하는 방법) ex. XML, HTML

     - 트리 형식으로 되어 있어, 특정 node를 찾을 수 있고 수정이나 제거, 삽입 가능

       >  웹 브라우저는 이 DOM을 활용하여 객체에 javascript와 css 적용

   - 문제점

     - 동적 UI에 최적화 되어있지 않음
   
       > 페이스북에서 스크롤을 내릴 때 많은 데이터가 로딩되면서 리스트가 추가됨. 이런 규모 큰 웹에서 DOM에 직접 접근해서 변화를 주면, 느려짐
   
    => Virtual DOM으로 해결
   
- Virtual DOM
  
     - 실제 DOM에 접근하여 조작하지 않고, 이를 추상화 시킨 자바스크립트 객체를 구성하여 사용
     
       > React에서 데이터가 변할 때
       >
       > 1. 데이터가 업데이트 되면, 전체 UI를 Virtual DOM에 리렌더링함
       > 2. 이전 Virtual DOM에 있던 내용과 현재의 내용을 비교
       > 3. 바뀐 부분만 실제 DOM에 적용
       
     - virtual dom에서 컴포넌트 변화를 감지해낼 때 효율적으로 비교할 수 있도록 컴포넌트 내부는 dom 트리 구조 하나여야됨 
     
       > 그래서 맨날 `<></>` 나 `<div></div>`로 감싸준 것임.
       >
       > => 리액트 v16에서는 Fragment가 나와서 불필요한 div 렌더링 필요없게 됨

2. render

```javascript
ReactDOM.render(
  element,
  document.getElementById('root')
);
```

​	`ReactDOM.render()` API로 렌더링을 수행. 하지만 매번 모든 변화에 대해서 직접 `ReactDOM.render()`를 호출할 필요는 없음. 컴포넌트의 `setState()` 메서드가 수행되면 해당 컴포넌트를 변경 대상 컴포넌트(Dirty component)로 등록하고, 다음 이벤트 루프에서 배치 작업으로 대상 컴포넌트들의 엘리먼트를 렌더링함.

1. render()에서 새로운 엘리먼트 트리 생성

  2. 이전 엘리먼트 트리와 비교하여 변경점을 찾아 업데이트함

     - Reconciliation: The diffing algorithm

       react의 reconciliation은 어떤 변경에 대한 전/후 엘리먼트 트리를 비교(diff)하여 갱신이 필요한 부분만을 찾아 업데이트 하는 것을 의미. react는 렌더링에서 reconciliation작업을 선행하기 때문에 플랫폼 ui에 대한 제어를 최소화 시키는 것(보통 ui 제어 비용은 비싸기 때문). 즉, **브라우저에서 dom에 대한 제어를 최소화시키는 것**

       > https://meetup.toast.com/posts/110

3. `create-react-app` : react의 boilerplate

   > 일반적인 boilerplate 프로젝트는 package.json과 같은 모듈 관리 파일에 필요한 모듈을 정의해놓고 설치해서 사용 => 오래된 프로젝트가 되버리는 경우가 있음. 

   - 포함하고 있는 것
  - Webpack : minify, uglify 등을 포함한 모듈 번들링 도구
     - Babel : ES6, React 등의 문법을 ES5 코드로 변환시켜주는 트랜스파일러
  - Autoprefixer : 다양한 벤더(브라우저)들에게 적절한 CSS 가 적용될 수 있도록 prefix 를 붙여준다.
     - ESLint : 자바스크립트 lint, 코드 컨벤션과 오류 등을 잡아준다.
  - Jest : 자바스크립트 테스트 도구
     - 이외에 여러개

4. React lifecycle

   - Mounting : React 엘리먼트(컴포넌트 클래스의 인스턴스)를 DOM 노드에 추가할 때 발생

     Updating : 속성이나 상태가 변경되어 React 엘리먼트를 갱신할 때 발생

     - 업데이트 하는 경우
     1. props 바뀔 때
     2. state 바뀔 때
     3. 부모 컴포넌트가 리렌더링될 때
     4. this.forceUpdate로 강제로 렌더링을 트리거할 때
     
     unmounting : React 엘리먼트를 DOM에서 제거할 때 발생
     
   - Class인 경우

     ![img](https://thebook.io/img/006946/151_2.jpg)

     - constructor -> getDerivedStateFromProps -> render -> ref 설정 해놓은 부분 -> componentDidMount

       > constructor : 컴포넌트를 새로 만들 때마다 호출
       >
       > getDerivedStateFromProps(리액트 v16에 새로 나옴) : props에 있는 값을 state에 동기화
       >
       > ```javascript
       > static getDerivedStateFromProps(nextProps, prevState) {
       >     if(nextProps.value !== prevState.value) { // 조건에 따라 특정 값 동기화
       >       return { value: nextProps.value };
       >     }
       >     return null; // state를 변경할 필요가 없다면 null을 반환
       > }
       > ```
       >
       > render : 짠 코드를 렌더링
       >
       > componentDidMount : 컴포넌트가 웹 브라우저에 나타난 후 호출
       >
       > - 다른 자바스크립트 라이브러리 또는 프레임워크 함수를 호출
       > - 이벤트 등록
       > - setTimeout, setInterval
       > - 네트워크 요청 같은 비동기 작업 처리 

     - (setState/props 변경) -> shouldComponentUpdate -> render -> componentDidUpdate

       ![img](https://thebook.io/img/006946/142_1.jpg)

       > shouldComponentUpdate : 컴포넌트가 리렌더링을 할지 말지 결정
       >
       > getSnapshotBeforeUpdate : 컴포넌트 변화를 dom에 반영하기 바로 직전에 호출
       >
       > - 주로 업데이트 하기 직전의 값을 참고할 일이 있을 때 활용 ex) 스크롤바 위치 유지
       >
       >   ```javascript
       >   getSnapshotBeforeUpdate(prevProps, prevState) {
       >       if(prevState.array !== this.state.array) {
       >         const { scrollTop, scrollHeight } = this.list
       >         return { scrollTop, scrollHeight };
       >       }
       >   }
       >   ```

     - (부모가 나를 없앴을 때) -> componentWillUnmount -> 소멸

       > componentWillMount(): React 엘리먼트가 실제 DOM에 곧 추가될 것을 알려준다.
       >
       > componentDidMount() : 컴포넌트가 첫 렌더링 된 후 (리렌더링 후에는 실행xx), 비동기 요청을 이 함수에 많이 함. (ex. setInterval 1초마다 반복 작업) - React 엘리먼트를 실제 DOM에 추가한 시점으로, 이 시점의 React 엘리먼트는 DOM 노드
       > componentWillUnmount() : 컴포넌트가 제거되기 직전(부모가 나를 없앴을 때), 비동기 요청 정리를 이 함수에서 많이 함(ex. componentDidMount의 setInterval 부분을 없애야됨. 안 없애면 계속 실행됨.)
       >
       > componentDidUpdate() : 리렌더링 후
       >
       > https://thebook.io/006961/part01/ch05/06/01/

   - Hooks인 경우

     ```javascript
     // componentDidMount, componentDidUpdate 역할을 하나로 합쳐 놓음
     // 렌더링 할 때마다, [] 내의 값이 바뀔 때 계속 다시 실행
     useEffect(() => { 
       interval.current = setInterval(changeHand, 100);
     	return () -> { // componentWillUnmount 역할
         clearInterval(interval.current);  // setInterval이 실행되었다가 꺼지고 실행되었다가 꺼짐
       }
     }, [imgCoord]); // 두번째 parameter(imgCoord)가 바뀔 때 useEffect가 실행됨.
     // 만약 []이면 처음에만 딱 한 번 실행되고 다음에는 실행 안됨(componentDidMount와 동일)
     
     // componentDidMount만으로 사용하고 싶다!
     useEffect(() => {
       //ajax
     }, []);
     
     // componentDidUpdate만으로 사용하고 싶다!
     const mounted = useRef(false);
     useEffect(() => {
       if(!mounted.current) {
         mounted.current = true;
       }
       // ajax
     }, [바뀌는 값]);
     ```

   - 차이

     ```javascript
     componentDidMount() {
     	this.setState({
     		imgCoord: 3,
     		score: 1,
     		result: 2
     	})
     };
     
     // hooks의 경우 한 클래스 method에서 하던 것을 이렇게 나눠서 할 수 있음
     useEffect(() => {
     	setImgCoord(3);
     	setScore(1);
     }, [imgCoord, score])
     useEffect(() => {
     	setResult(2);
     }, [result])
     
     // hooks의 경우 이렇게 각 경우를 생각해야함
     												imgCoord			score				result
     componentDidMount
     componentDidUpdate
     componentWillUnmount
     ```

     

5. state / props

   **state** : 바뀌거나 바뀔 수 있는 부분

   > stateless component : 상태가 없는 컴포넌트. 클래스를 사용해서 만들지 않기!

   ```javascript
   constructor(props) {
     super(props);
     // state 초기화
     this.state = {
       liked: false,
     }
   }
   
   // 상태를 바꿔줄 때
   this.setState({
     liked: true
   });
   
   // 이전 상태 값을 활용하려고 할 때, this.state.value라고 쓰면 헷갈릴 수 있으니 아래와 같이 함수로 만들어서 prevState 사용
   this.setState((prevState) => {
     return {
       result: '정답: ' + prevState.value,
       value: '',
     }
   })
   ```

   ```javascript
   // props : 하위 컴포넌트에 값을 전달함
   <Try value={v} index={i}>
   
   class Try extends Component {
       render() {
         return (
         	<>
           	<b>{this.props.value} - {this.props.index}</b>
           </>
         )
       }
     }
   ```

   > 할아버지가 손자한테 데이터를 보내주고 싶을 때는(A -> B -> C일 때, A에서 C로 보내는 법은)? context, redux

   > 만약 props를 바꿔야할 때는 state로 넣어줌(원래 props는 자식에서 바꾸면 안 됨.) 엘리먼트는 기본적으로 immutable이기 때문에. props는 컴포넌트 생성시 전달받는 값이기 때문에 내부에서 수정 불가능 
   >
   > ```javascript
   > const Try = ({ tryInfo }) => {
   > 	const [result, setResult] = useState(tryInfo.result);
   >   
   >   const onClick = () => {
   >     setResult('1');
   >   }
   > }
   > ```

   > props를 변경하지 못하면, 서버에서 일치하는 항목에 대한 정보를 받아올 때 어떤 방법으로 뷰를 갱신..?
   >
   > - 서버에서 응답을 받을 때마다 새로운 속성으로 엘리먼트를 렌더링
   >
   >   but. 로직을 컴포넌트 외부에 작성해야되어서 독립적인 컴포넌트가 될 수 없음.
   >
   > - 따라서, 사용자 조작으로 발생한 이벤트를 처리하여 뷰를 갱신해야됨(state dldyd)

6. event : 사용자가 웹브라우저에서  dom 요소들과 상호작용하는 것

   - 리액트에서 이벤트 발생시, 이벤트 핸들러는 SyntheticEvent(리액트 이벤트 객체) 인스턴스 전달(e)

   - 규칙
     1. 이름은 camelCase ex) onClick
     2. 이벤트에 실행할 자바스크립트 코드가 아닌 함수를 전달
     3. Dom 요소에만 이벤트 설정 가능

7. JSX와 babel

   JSX(JS + XML) : html tag처럼 쓸 수 있도록 함

   jsx와 es6 문법을 사용하기 위해서 babel 사용

   or babel에서 require --> import

   > dev용
   >
   > babel/core : babel의 기본적인 것이 들어가있음
   >
   > babel/preset-env : 브라우저에 맞춰서 최신 문법을 옛날 문법으로 바꿔줌
   >
   > babel/preset-react : jsx 지원
   >
   > babel-loader : babel과 webpack 연결해줌
   >
   > * preset은 plugin의 모음임

   ```javascript
   e('button', { onClick: () => { console.log('clicked')}, type: 'submit'}, 'Like')
   
   <button type="submit" onClick={() => { this.setState({ liked: true })}}>
   Like
   </button>
   ```

8. class

   - 단점
     - this 바인딩을 직접 해야함 => [decorator로 해결](https://technologyadvice.github.io/es7-decorators-babel6/)
     - mixin을 사용할 수 없음

9. 함수형 컴포넌트

   - 컴포넌트에서 라이프사이클, state 등 불필요한 기능 제거

     ```javascript
     const Hello = ({name}) => {
       return (
         <div>Hello {name}</div>
       )
     }
     ```

   - 메모리 소모량 적어 클래스형보다 빠름

     > 리액트에서는 state를 사용하는 컴포넌트 개수 최소화하는 것이 좋음. 

10. React Hooks - 함수형

   - hook 
     - 함수 컴포넌트에서 React state와 생명주기 기능(lifecycle features)을 “연동(hook into)“할 수 있게 해주는 함수

   - 코드가 짧고 간결해짐
   - class가 아니라서 class method 못 씀

   ```javascript
   class Gugudan extens React.Component {
     state = {
       first: 0,
       second: 0,
       value: 0,
     }
     
     return <div>{this.state.first}</div>
   }
   
   // 원래 있었지만 이 경우는 상태변경을 안 하는 경우에만 사용했었음.
   const Gugudan = () => {
     // state 선언 방법. useState()내에 초기값을 넣어줌
     const [first, setFirst] = React.useState(0);
     const [second, setSecond] = React.useState(0);
     const [value, setValue] = React.useState('');
     const inputRef = React.useRef(null);
     
     // 이렇게 3개 하면 3번 렌더링 되는 것 아닐까? --> 리액트가 비동기인 이유! 알아서 하나로 처리해줌
     setFirst(1);
     setSecond(2);
     setValue('');
     inputRef.current.focus();
     
     return <input ref={inputRef}>{first}</input>
   }
   ```

   - method

     - useMemo : 복잡한 함수 결과값을 기억(useRef : 일반 값을 기억)

       ```javascript
       // 맨 뒤의 [] 내의 값이 바뀔 때 useMemo 다시 실행됨
       // 원래는 useState(getWinNumbers)였는데 함수 자체가 렌더링때마다 재실행되어서 lottoNumbers로 기억해서 넣어놓음.
       const lottoNumbers = useMemo(() => getWinNumbers(), []);
       const [winNumber, setWinNumber] = useState(lottoNumbers);
       ```

     - useCallback : 함수 자체를 기억. 만약 그 함수 내에서 state가 변경되면 [] 안에 넣어줘야함. 

       - 자식 컴포넌트에 함수를 넘길 때는 꼭 useCallback을 해줘야함

         > 안 하면 매 번 새로운 함수가 생성되고 자식 컴포넌트에 props가 계속 바뀌는 것으로 인식됨. 따라서 자식 컴포넌트는 매 번 새로 rendering을 하게 됨
       
     - useEffect : React는 DOM을 바꾼 뒤에 안의 함수를 실행.  React는 매 렌더링 이후에 effects를 실행(맨 처음 렌더링 포함). 
     
     - useReducer : state가 여러 개 일 때 하나로 묶는 역할(state를 바꿀 때 action을 써야함)
     
       > reducer와 차이점은 reducer는 동기적으로 바뀌고 useReducer는 state가 비동기로 바뀜
     
       ```javascript
       const initialState = {
         winner: '',
         turn: 0,
         tableData: [['', '', ''], ['', '', ''], ['', '', '']],
       }
       
       const SET_WINNER = 'SET_WINNER';
       
       const reducer = (state, action) => {
         switch(action.type) {
           case SET_WINNER:
             return {
               ...state, 
               winner: action.winner,
             }
         }
       }
       
       const TicTacToe = () => {
         // 자식에게 state, dispatch 모두 계속 넘겨줘야함
         // 너무 자식이 많아지면 context API 사용
         const [state, dispatch] = useReducer(reducer, initialState);
         
         const onClickTable = useCallback(() => {
           dispatch({type: SET_WINNER, winner: '0'});
         }, []);
         
         return (
         	<>
           	{state.winner && <div onClick={onClickTable}> {state.winner} </div>}
           </>
         )
       }
       
       ```
     
     - context API : useReducer에서 다층관계일 때 
     
       - createContext
     
         ```javascript
         // 다른 파일에서 쓸 수 있도록 export함
         export const TableContext = createContext({
         	tableData: [],
           dispatch: () => {};
         })
         
         const MineSearch = () => {
           
           // dispatch는 항상 같기 때문에 []에 들어가지 않음
           const value = useMemo(() => ({ tableData: state.tableData, dispatch}), [state.tableData]);
           
           return (
             // 아래와 같이 렌더링될 때 value 값도 새롭게 생겨서 성능적으로 문제가 생김 => 캐싱 필요(useMemo)
           	// <TableContext.Provider value={{ tableData: state.tableData, dispatch }}>
             <TableContext.Provider value={value}>
               <Form />
             </TableContext.Provider>
           )
         }
         ```
     
         ```javascript
         const Form = () => {
         
         }
         ```
     
   - 사용 규칙

      - **최상위(at the top level)**에서만 Hook을 호출해야 함. 반복문, 조건문, 중첩된 함수 내에서 Hook을 실행 노노
      - **React 함수 컴포넌트** 내에서만 Hook을 호출해야함. 일반 JavaScript 함수에서는 Hook을 호출 노노. (Hook을 호출할 수 있는 곳이 딱 한 군데 더 있음. 바로 직접 작성한 custom Hook 안에)

   - custom hook : 상태 관련 로직을 컴포넌트 간에 재사용하고 싶을 때

     > 일반적으로 higher-order components, render props를 사용하는 방법이 있지만 custom hook은 이들과 달리 컴포넌트 트리에 새 컴포넌트를 추가하지 않고도 이것을 가능하게 함

     - 이름 `use`로 시작

     ```javascript
     import React, { useState, useEffect } from 'react';
     
     function useFriendStatus(friendID) {
       const [isOnline, setIsOnline] = useState(null);
     
       function handleStatusChange(status) {
         setIsOnline(status.isOnline);
       }
     
       useEffect(() => {
         ChatAPI.subscribeToFriendStatus(friendID, handleStatusChange);
         return () => {
           ChatAPI.unsubscribeFromFriendStatus(friendID, handleStatusChange);
         };
       });
     
       return isOnline;
     }
     ```

     ```javascript
     function FriendStatus(props) {
       const isOnline = useFriendStatus(props.friend.id);
     
       if (isOnline === null) {
         return 'Loading...';
       }
       return isOnline ? 'Online' : 'Offline';
     }
     ```

     

11. React Router

    ![img](https://thebook.io/img/006946/361_2.jpg)

    - 페이지 주소를 변경했을 때, 주소에 따라 다른 컴포넌트를 렌더링

    - 주소 정보를 컴포넌트의 props로 전달하여 컴포넌트 단에서 주소 상태에 따라 다른 작업을 하도록 설정

    - BrowserRouter : HTML5의 history API를 사용하여 새로고침하지 않고도 페이지 주소 교체 가능

      ```javascript
      <BrowserRouter>
        // a tag로 바뀜(링크가 바뀜). a tag 못 쓰고 link로 써야됨.
        <Link to="/baseball">야구</Link>
        <Link to="/lotto">로또</Link>
      	<Route path="/baseball" component={Baseball}/>
        <Route path="/lotto" component={Lotto}/>
      </BrowserRouter>
      ```

      > HashRouter
      >
      > 주소 중간에 *localhost:8080/#/baseball* #(hash)가 들어감
      >
      > 새로고침시 동작함(hash뒤 주소 부분은 client만 아는 부분임.)
      >
      > 검색엔진에 잡히지 않음(ex. 관리자페이지)
      >
      > 
      >
      > but BrowserRouter는 서버가 알기 때문에 검색엔진에 잡힘(검색 엔진은 너희 ~이거 알아? 를 서버에게 물어봄)
      >
      > 새로고침에 뜨지 않음(/baseball을 url에 그냥 치면 cannot get /baseball 에러 나옴) => 서버 쪽에 등록해야함
      >
      > ```javascript
      > class GameMatcher extends Component {
      > }
      > ```

12. HOC(higher order component) : 리액트 컴포넌트를 인자로 받아서 새로운 리액트 컴포넌트를 리턴하는 함수 => hooks가 추가되어서 좋은 접근법 아님 이제.

    - convention

      - 파일명 with로 시작 ex) withNewPropName, withLoading, withAuth

      - [display 이름 명시](https://reactjs.org/docs/higher-order-components.html#convention-wrap-the-display-name-for-easy-debugging)

      - render에 사용하면 안됨

        > 렌더링할 때마다 새로 만들어지기 때문.

    - 사용하는 경우

      1. container 컴포넌트와 presentational 컴포넌트 분리 : 비지니스 로직을 담당하는 컴포넌트(container)와 디스플레이를 담당하는 컴포넌트(presentational)을 분리하여 사용할 때, container 컴포넌트를 HOC로 만들어 사용
      2. 로딩 중 화면 표시 : 화면이 로딩 중일 때, skeleton 화면을 보여주고, 완료되면 데이터를 보여줄 때 사용
      3. 유저 인증 로직 처리 : 컴포넌트 내에서 권한 체크나 로그인 상태를 체크하기 보다는 인증 로직을 HOC로 분리하면 컴포넌트 재사용성도 높일 수 있고, 컴포넌트에서 역할 분리도 쉽게 할 수 있음
      4. 에러 메시지 표시 : 컴포넌트 내에서 if/else 등을 통해 처리할 수 있지만, 분기문(if/else)를 HOC로 만들어 처리하면 컴포넌트를 더욱 깔끔하게 사용 가능

    - 예시

      ```javascript
      // functional component
      const withHOC = WrappedComponent => {
        const newProps = {
          loading: false,
        };
        return props => {
          return <WrappedComponent {...props} {...newProps} />
        }
      };
      
      // class component
      const withHOC = WrappedComponent => {
        const newProps = {
          loading: false,
        };
        return class extends React.Component {
          render() {
            return <WrappedComponent {...this.props} {...newProps} />
          }
        }
      };
      
      // hoc 사용할 때
      export default withHOC(AnyComponent);
      ```

      

13. redux

    ![with redux](https://image.toast.com/aaaadh/real/2018/techblog/8e8f54e897a711e69d4e129be73fb95d.png)

   - React-redux : react에서 redux를 사용할 수 있는 npm 모듈

        - connect() : react 컴포넌트에서 redux store에 접근할 수 있는 smart 컴포넌트 만들 수 있음. 이 때 아래 두 개의 인자를 전달함
        - mapStateToProps : 그림에서 파란색 화살표 역할을 하는 함수로 컴포넌트에 필요한 값을 store로부터 직접 조회하는 역할을 함
             - mapDispatchToProps : 그림에서 녹색 화살표 역할을 하는 함수로 사용자의 액션에서 발생하는 store의 변화를 구현함

   - 사용 이유

     - 안정성

     - state 통제 용이(하나로 모아놔서)하기 때문에 사용

       > state를 컴포넌트에 종속시키지 않고 밖에서 관리할 수 있음
       >
       > ex. A->D 데이터 전달 위해 A->B->C->D를 거쳐야 하는 경우, D의 자식인 F, E가 서로 데이터를 공유하고 싶어 D를 중간자로 공유하는 경우

   - 구조

     - action : state를 바꾸는 행동
     - dispatch : action을 실행
     - reducer : action의 결과로 state를 어떻게 바꿀지 정의

- Store, action creator, reducer로 구성

  1. store의 데이터로 뷰 렌더링

  2. 뷰에서 발생한 이벤트로 action(action creator로 생성)을 생성

  3. reducer는 생성된 action으로 store 갱신

  4. 갱신된 store로 뷰 렌더링

     ![redux and react data flow](https://image.toast.com/aaaadh/real/2018/techblog/uiworkflow.png)

  > 1.  DOM 위에 생성되기 전에 액션 메서드(action creator)는 fetch 요청에 필요한 정보(url, method)를 액션과의 dispatch를 통해 Redux에 알려 준다.
> 2. REST API에 미리 선언해 놓은 엔드포인트를 통해 전달 받은 데이터는 JSON 형식으로 반환한다.
  > 3. 데이터 준비가 완료되면 fetch 작업이 완료되었다고 액션을 통해 Redux에 알려 준다.
  > 4. 리듀서(reducer)를 통해 받은 데이터를 사용해 Redux는 스토어(store)에 있는 state 트리를 업데이트한다.
  > 5. 컴포넌트는 prop를 통해서 필요한 데이터를 전달받고, 자식 요소인 컴포넌트가 렌더링될 때 값을 전달한다.

   - 사용 규칙
  - 하나의 애플리케이션 안에는 하나의 스토어만
     - state는 읽기전용(불변성 유지)
     - reducer는 순수한 함수여야함
       - reducer는 이전 상태와 액션 객체를 파라미터로 받음
       - 이전 상태는 절대로 건들이지 않고 변화를 일으킨 새로운 상태 객체를 만들어 반환
       - 똑같은 파라미터로 호출된 reducer는 언제나 똑같은 결과값을 반환해야함
  
- store는 가능한 얇게 설계하는 것이 좋음. => 깊어질수록 reducer를 복잡하게 순회하며 구현해야함

  > Normalizr : 스키마 정의를 통해 쉽게 정규화할 수 있는 기능

- Redux-saga 

11. Apollo client 사용한 컴포넌트 렌더링

    - Apollo Client는 GraphQL 기반의 라이브러리로, 클라이언트 애플리케이션의 GraphQL과 데이터 교환을 도움

    - graphql

      - 서버 API를 통해 정보를 주고받기 위해 사용하는 질의 언어(query language)

      - 보통 하나의 엔드포인트를 사용하며, 요청 시 사용하는 질의문에 따라 응답의 구조가 달라짐

      - graphql-tag : query, mutation 정의

      - ![그림](https://d2.naver.com/content/images/2019/06/helloworld-201903-seungho-3.png)

        - query : 데이터를 받아올 때 사용
        - mutation : 데이터를 생성, 수정, 삭제할 때 사용
        - subscription : 웹소켓을 사용해 실시간 양방향 통신을 구현할 때 사용

      - 서버 개발 환경 설정

        ![그림](https://d2.naver.com/content/images/2019/06/helloworld-201903-seungho-4.png)

        1. GraphQL 스키마를 작성한다.

        2. resolve 함수를 작성한다.

        3. GraphQL 스키마와 resolver 함수를 병합한다.

        4. 서버 환경을 설정한다.

           ```javascript
           server.use('/graphql', bodyParser.json(), graphqlExpress({  
               schema
           }));
           ```

           > 스키마 : GraphQL 스키마를 작성해 질의에 대한 타입 정의(type definition)
           >
           > resolver : resolve 함수는 쿼리에 대해 서버가 어떻게 대응하는지를 정의. MVC 패턴에서 컨트롤러 역할

           

      ```javascript
      import gql from "graphql-tag";  
      import { Query } from "react-apollo";
      
      const GET_DOGS = gql`  
        {
          dogs {
            id
            breed
          }
        }
      `;
      
      const Dogs = ({ onDogSelected }) => (  
        <Query query={GET_DOGS}>
          {({ loading, error, data }) => {
            if (loading) return "Loading...";
            if (error) return `Error! ${error.message}`;
      
            return (
              <select name="dog" onChange={onDogSelected}>
                {data.dogs.map(dog => (
                  <option key={dog.id} value={dog.breed}>
                    {dog.breed}
                  </option>
                ))}
              </select>
            );
          }}
        </Query>
      );
      ```

      > 1. `<query/>` 컴포넌트가 마운트되면 Apollo Client는 요청할 데이터 값을 정의해 놓은 query에 대한 옵서버를 생성한다.
      > 2. 컴포넌트는 Apollo Client 캐시를 통해 query에 대한 결괏값을 구독한다.
      > 3. 이후 우선적으로 query 결괏값을 Apollo Client 캐시에서 탐색한다.
      > 4. 저장된 캐시가 없으면 서버로 요청을 보낸다. 서버에서 데이터를 받으면 Apollo Client 캐시에 저장한다.
      > 5. `<query>`컴포넌트가 결괏값을 구독하고 있기 때문에 자동으로 업데이트된다.

    - redux와의 차이

      Redux는 REST API를 사용하기 때문에 리소스의 크기가 서버에서 결정된다. 데이터 교환이 복잡하게 이루어지고, 엔드포인트 증가 및 overfetching과 underfetching 등의 문제점을 가지고 있다. 반면에 Apollo Client는 GraphQL을 기반으로 한다. 서버에서는 어떠한 자원을 사용할 수 있는지 정의하고, 클라이언트에서 렌더링에 필요한 데이터를 요청하는 방식이다.(React와 Redux의 조합에서 발생하는 불필요한 액션과 리듀서의 감소) 꼭 필요한 데이터 교환(라우팅(routing) 경로에 맞게 필요한 최소한의 리소스를 사용한 렌더링)이 이루어지기 때문에 매우 깔끔하며 효과적이다. + React 컴포넌트의 재사용성을 확대할 수 있게 라우팅 경로에서 렌더링 리소스 의존성 제거

    - 단점
      - 중첩된 객체와 객체 배열에 대해서도 스키마를 정의해야 한다. 만약 정의되지 않은 리소스 타입을 요청하거나 반환하면 오류가 발생한다. 복잡한 모델을 사용할 때에는 스키마를 정의하는 일이 복잡하게 느껴질 수 있다.
      - React 기반의 Apollo Client인 [react-apollo](https://github.com/apollographql/react-apollo)를 사용할 때에는 `Content-Type` 요청 헤더의 MIME 타입을 `application/graphql`로 설정해서 사용해야 한다. 서버에서도 GraphQL 파싱을 지원하는 [body-parser-graphql](https://github.com/graphql-middleware/body-parser-graphql)과 같은 파서를 사용해야 한다. 기본으로 사용하는 `application/json`으로 설정해서 사용하면 파싱 오류가 발생한다.
      - Apollo Client의 쿼리는 variables 객체를 기반으로 문자열 형태의 캐시 키 값을 만든다. variables 객체의 속성이 순서가 다르면 별도의 쿼리로 인식하는 문제가 있다. Apollo Client에서 기본으로 사용하는 캐시 라이브러리인 [apollo-cache-inmemory](https://github.com/apollographql/apollo-client/tree/master/packages/apollo-cache-inmemory)의 InMemoryCache 객체를 생성할 때 고유한(unique) 키를 생성하도록 [`dataIdFromObject` 옵션](https://www.apollographql.com/docs/react/advanced/caching.html#normalization)을 설정하는 방법으로 문제에 대응할 수 있다.

    - 자동 업데이트
      - apollo를 사용하여 mutation을 실행하면, apollo에서 내부적으로 부여하는 ID가 동일한 경우 리액트 컴포넌트가 자동으로 업데이트
      - 안 되는 경우 해결 방법
        1. Optimistic UI + update : store의 데이터 직접 변경
           - 장점 : 네트워크 지연시간 없이 유저에게 바로 변경된 데이터를 보여줌
           - 단점 : 직접 변경해야하기 때문에 코드량이 증가하고 데이터가 꼬일 수 있음
        2. refetchQueries : mutation 후 refetchQueries 배열에 있는 query를 다시 요청
           - 장점 : 코드 간단(mutation 후에 요청할 쿼리명만 적어주면 됨)
           - 단점 : 불필요한 네트워크 요청
        3. subscription : 실시간으로 데이터를 받아옴

12. Next.js

    - SSR(server side rendering) + 코드 스플리팅(필요한 페이지만 불러옴 => 초기 렌더링 속도 향상)

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

13. 코드 스플리팅

    - 웹팩에서 프로젝트를 번들링 할 때 파일 하나가 아니라 여러 개로 분리시켜 결과물을 만들 수 있음 + 페이지를 로딩할 때 한꺼번에 불러오는 것이 아니라 필요한 시점에 불러올 수 있음
    - Vendor 설정 : 프로젝트에서 전역적으로 사용하는 라이브러리(react, react-dom, redux, react-redux, styled-components...)를 다른 파일로 분리 => 업데이트할 때 업데이트하는 파일 크기를 최소화할 수 있음. 따라서 캐싱 효과를 오랫동안 누릴 수 있어 트랙픽 절감, 로딩 속도 개선 - 원활하게 캐싱할 수 있게 하는 작업
    - chunk 생성 - 페이지에서 필요한 코드들만 불러오는 것

14. test

    - 리액트 컴포넌트 테스트
      1. 특정 props 에 따라 컴포넌트가 크래쉬 없이 잘 렌더링이 되는지 확인
      2. 이전에 렌더링했던 결과와, 지금 렌더링한 결과가 일치하는지 확인
      3. 특정 DOM 이벤트를 시뮬레이트 하여, 원하는 변화가 제대로 발생하는지 확인
      4. 렌더링된 결과물을 *이미지* 로 저장을 하여 픽셀을 하나하나 확인해서 모두 일치하는지 확인

15. Tips

   - ref - dom에 직접 접근하고 싶을 때 ref를 붙여서 접근하면 됨.

     ```javascript
     import { createRef } from 'react';
     
     inputRef = createRef();
     <input ref={this.inputRef}>
     this.inputRef.current.focus();
     ```

     ````javascript
     // hooks
     const interval = useRef();
     ````

   - 함수 렌더링

     ```javascript
     // <> tag내에 함수를 직접 적으면 렌더링 할 때마다 그 함수 계속 새로 만듦.
     <form onSubmit={(e) => this.setState()}></form>
     
     // 그래서 이렇게 따로 빼줌
     <form onSubmit={this.submit}></form>
     ```

   - react-hot-loader : 추가적으로 파일이 수정되었을 때 화면을 새로고침하지 않고 바뀐 부분만 리로딩

     webpack-dev-server : webpack.config.js를 읽어주고 nodemon 같은 역할

     ```javascript
     // 이렇게 하면 WordRelay 변화를 감지해서 다시 실행시켜줌
     const { hot } = require('./WordRelay');
     
     const hot = hot(WordRelay);
     
     ReactDom.render(<Hot />);
     ```

   - import / require

     ```javascript
     export const hello = 'hello'; // import { hello }
     export default Number; // import Number
     ```

   - 화살표 함수 : 안 쓰면 this 사용 못함

     ```javascript
     // bind(this)를 자동으로 해줌
     onChangeInput = () => {
     	console.log(this.state.value)
     }
     ```

     ```javascript
     onChangeInput() {
     	console.log(this.state.value) // undefined 나옴
     }
     
     // 만약 쓰려면 이렇게 해야 됨. 이제 안 써도 됨.
     constructor(props) {
      	super(props);
       this.state = {
         value: 0
       }
       this.onChangeInput = this.onChangeInput.bind(this);
     }
     ```

     > render는 화살표 함수 사용 안 해도 됨 (extends Component에서 알아서 처리해줌)

   - 렌더링 최적화 : shouldComponentUpdate / PureComponent / memo

     ```javascript
     class Test extends Component {
     	state = {
     		counter: 0,
     	}
     	
     	// state가 안 바뀜에도 클릭하면 렌더링이 새로 됨.
     	onClick = () => {
     		this.setState({})
     	}
       
       // 그래서 어떨 때 렌더링이 되어야할 지를 적어줘야함.
       shouldComponentUpdate(nextProps, nextState, nextContext) {
         // 현재 counter와 바뀌는 counter가 다르면 true -> 렌더링함
         if(this.state.counter !== nextState.counter) {
           return true;
         }
         return false;
       }
     }
     
     // 아니면 PureComponent 사용 -> shouldComponentUpdate을 자동으로 구현해 놓은 컴포넌트
     class Test extends PureComponent {
     }
     
     // hooks에서는 memo를 쓰면 됨.
     const Test = memo(() => {
     });
     ```

     shouldComponentUpdate를 쓰는 경우

     1. 컴포넌트 배열이 렌더링되는 리스트 컴포넌트일 때
     2. 리스트 컴포넌트 내부에 있는 아이템 컴포넌트일 때
     3. 하위 컴포넌트 개수가 많으며, 리렌더링되지 말아야 할 상황에서도 리렌더링이 진행될 때

   - setState

     ```javascript
     // 렌더링 안 됨
     const array = this.state.array;
     array.push(1);
     this.setState({
     	array: array,
     })
     
     // 아래와 같이 해야 다른 것이라고 인식하여 렌더링됨.
     this.setState({
       array: [...this.state.array, 1],
     })
     ```

   - ... 문법

     - **불변성**을 위해서

       ```javascript
       const a = { b: 1, c: 2 };
       const b = a;
       a === b; // true
       const c = { ...a };
       a === c; // false
       ```
       
       > state 또는 상위 컴포넌트에서 전달받은 props 값이 변할 때 리렌더링 되는데, 배열이나 객체를 직접 수정한다면 내부 값을 수정했을지라도 레퍼런스가 가리키는 곳은 같기 때문에 똑같은 값으로 인식.
       >
       > but 객체가 깊어지면 코드가 복잡해짐
       >
       > => Immutable.js

   - 컴포넌트를 어떻게 나누어야 할까?

     - 처음에는 하나로 만든 뒤 쓸데없이 렌더링 되는 부분을 나눔
     - 쪼갤 수록 관리는 편하지만 부모-자식관계가 생겨서 힘듦
     
- 최적화

  - 특정 부모 컴포넌트의 상태가 변경될 때 모든 하위 컴포넌트가 렌더링되는데 이 때 몇몇 컴포넌트는 렌더링 되지 않아도 되는 경우 -> 마크업만 포함하는 컴포넌트
  - 어떤 조건에서만 렌더되면 되는 경우 -> [shouldComponentUpdate](https://facebook.github.io/react/docs/advanced-performance.html#shouldcomponentupdate-in-action) 로 구현

  
 <hr/>
 읽어볼 것들
 http://jeonghwan-kim.github.io/series/2019/12/10/frontend-dev-env-webpack-basic.html

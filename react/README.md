React 

1. React?

   - **React** : Facebook이 만든, 프론트엔드 라이브러리 (View만 담당하기 때문에 M, C는 다른 라이브러리, 패키지로 보완해주어야 함)

     > 웹 개발할 때, DOM관리와 상태값 업데이트 관리를 최소화 하고, 기능과 사용자 인터페이스를 구현하는 것에 집중할 수 있도록 하는 것이 프론트엔드 라이브러리 ex. Angular, Vue, React

   - 특징

     - Single page application : 페이지가 1개인 어플리케이션
   
       - 뷰 렌더링을 브라우저가 담당

         > 서버가 담당하면 느리고 불필요한 트래픽 낭비

     - Virtual DOM
  - JSX : DOM 엘리먼트들을 만들 때 javascript 형식으로 작성해야하는 것을 XML과 비슷한 형태로 작성할 수 있게 해 줌
     
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

3. React lifecycle

   - Class인 경우

     - constructor -> render -> ref 설정 해놓은 부분 -> componentDidMount

     - (setState/props 변경) -> shouldComponentUpdate -> render -> componentDidUpdate

     - (부모가 나를 없앴을 때) -> componentWillUnmount -> 소멸

       > componentDidMount() : 컴포넌트가 첫 렌더링 된 후 (리렌더링 후에는 실행xx), 비동기 요청을 이 함수에 많이 함. (ex. setInterval 1초마다 반복 작업)
       > componentWillUnmount() : 컴포넌트가 제거되기 직전(부모가 나를 없앴을 때), 비동기 요청 정리를 이 함수에서 많이 함(ex. componentDidMount의 setInterval 부분을 없애야됨. 안 없애면 계속 실행됨.)
       >
       > componentDidUpdate() : 리렌더링 후

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

     

4. state / props

   **state** : 바뀌거나 바뀔 수 있는 부분

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

   > 만약 props를 바꿔야할 때는 state로 넣어줌(원래 props는 자식에서 바꾸면 안 됨.)
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

5. JSX와 babel

   JSX(JS + XML) : html tag처럼 쓸 수 있도록 함

   javascript에서 아래와 같은 문법(html tag 사용)을 쓸 수 없어서 *babel* 을 사용해야함

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

6. React Hooks - 함수형

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

7. React Router

   - BrowserRouter

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

8. redux

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

   - 사용 규칙

     - 하나의 애플리케이션 안에는 하나의 스토어만
     - state는 읽기전용(불변성 유지)
     - reducer는 순수한 함수여야함
       - reducer는 이전 상태와 액션 객체를 파라미터로 받음
       - 이전 상태는 절대로 건들이지 않고 변화를 일으킨 새로운 상태 객체를 만들어 반환
       - 똑같은 파라미터로 호출된 reducer는 언제나 똑같은 결과값을 반환해야함

9. Next.js

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
     > - 단점 : 앱의 규모가 커지면 자바스크립트 파일 사이즈가 너무 커져 로딩속도 지연(사용자가 실제로 방문하지 않을 수도 있는 페이지에 관련된 스크립트도 불러옴) => 코드 스플리팅

10. Tips

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

   - 컴포넌트를 어떻게 나누어야 할까?

     - 처음에는 하나로 만든 뒤 쓸데없이 렌더링 되는 부분을 나눔
     - 쪼갤 수록 관리는 편하지만 부모-자식관계가 생겨서 힘듦
     
     
 <hr/>
 
 읽어볼 것들
 http://jeonghwan-kim.github.io/series/2019/12/10/frontend-dev-env-webpack-basic.html

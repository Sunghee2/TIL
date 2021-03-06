# Typescript

- 2012년에 Microsoft에서 개발한 static type system을 도입한 javascript입니다.
- 자바스크립트에 정적 타이핑과 es2015를 기반으로 하는 객체지향적 문법이 추가된 것이 특징입니다.
- Javascript는 소스의 규모가 커질 수록 그에 따른 관리에 어려움이 있는데 Typescript를 도입하여 실수로 인한 오작동 코드 작성을 줄일 수 있습니다.

### 동적 타입 언어 / 정적 타입 언어

- 프로그램의 타입을 분석하는 방식을 기준으로 프로그래밍 언어를 2가지로 나눕니다
  - 동적 타입 언어(**Javascript**) : 프로그램이 실제로 실행될 때에 타입 분석을 진행
    - 코드를 실행하는 시점에 인터프리터가 변수의 데이터 타입을 지정합니다.
    - 버그 발생률이 높습니다.  => 이를 보완하기 위해 **Typescript** 등장!
  - 정적 타입 언어(**Typescript**) : 프로그램을 실행해보지 않고도 런타임 이전 컴파일 타임에 타입 확인 진행
    - 코드 수준에서 미리 타입을 체크하여 오류를 찾습니다.

### 장점과 단점

#### 장점

- 프로그램이 실제로 실행되기 전에 상당수의 오류를 잡아낼 수 있습니다.
- 코드 의도가 분명해지면서 가독성이 좋아져 협업 효율이 높아집니다. 

- 타입에 대한 예외 처리를 따로 하지 않아도 됩니다.
- Private, protected 등의 접근 제한자, 추상클래스, 인터페이스, 제네릭, 데코레이터 등 기능 제공 => javascript 보다 OOP를 지향하며 개발할 수 있습니다.

#### 단점

- 환경 셋팅과 코드 구현에 있어 javascript보다 느릴 수 있습니다.
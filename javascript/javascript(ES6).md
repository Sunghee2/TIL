# Javascript - ES6

## 1. const, let

```javascript
if(true) {
	var x = 3;
}
console.log(x) // 3

if(true) {
  const y = 3;
}
console.log(y) // Uncaught ReferenceError: y is not defined
```

- var : function scope를 가지므로 블록과 관계없이 접근 가능
- const, let : block scope를 가지므로 블록 밖에서는 접근 불가능
  - const : 상수
  - let : 변수

<br/>

## 2. 템플릿 문자열

``을 이용해서 문자열 안에 변수를 넣을 수 있음

```javascript
// 기존
var num1 = 1;
var string = num1 + '이다';

// es6
const num1 = 1;
var string = `${num1}이다`
```

<br/>

## 3. 객체 리터럴

- 속성명과 변수명이 겹치는 경우 한 번만 쓸 수 있게 됨(코드 중복을 피함)

- 객체의 속성명을 동적으로 생성할 수 있음(객체 리터럴 안에서 선언 가능)

```javascript
// 기존
var sayNode = function() {
  console.log(Node);
};
var es = 'ES';
var oldObject = {
  sayJS: function() {
    console.log('JS');
  },
  sayNode: sayNode,
};
oldObject[es + 6] = 'Fantastic';

// es6
const newObject = {
  sayJS() {
    console.log('JS');
  },
  sayNode,
  [es + 6]: 'Fantastic',
};
```

<br/>

## 4. arrow function

- this bind 방식 다름

```javascript
// 기존
// forEach내에 function을 사용하여 각자 다른 함수 스코프를 가지므로 that이라는 변수를 이용해서 간접 접근
var relationship1 = {
  name: 'zero',
  friends: ['nero', 'hero', 'xero'],
  logFriends: function() {
    var that = this;
    this.friends.forEach(function(friend) {
      console.log(that.name, friend);
    })
  }
}

// es6
// arrow function으로 밖 스코프인 logFriends()의 this를 그대로 사용할 수 있음
// 상위 스코프의 this를 그대로 물려받는 것
const relationship = {
  name: 'zero',
  friends: ['nero', 'hero', 'xero'],
  logFriends() {
    this.friends.forEach(friend => {
      console.log(this.name, friend);
    })
  }
}
```

<br/>

## 5. 비구조화 할당

```react
// react 내의 component를 찾아서 매칭해줌
import react, { component } from 'react'
```

```javascript
// 배열도 비구조화 가능
// 기존
var array = ['node.js', {}, 10, true];
var node = array[0];
var obj = array[1];
var bool = array[3];

// es6
const [node, obj, , bool] = array;
```

<br/>

## 6. Promise

- callback대신 promise기반으로 재구성되어 callback hell 극복

```javascript
// 기존
function findAndSaveUser(Users) {
  Users.findOne({}, (err, user) => {
    if(err) {
      return console.error(err);
    }
    user.name = 'zero';
    user.save((err) => {
      if(err) => {
        return console.log(err);
      }
      Users.findOne({ gender: 'f' }, (err, user) => {
        
      })
    })
  })
}

// es6 - promise
function findAndSaveUser(Users) {
  Users.findOne({})
  	.then((user) => {
    	user.name = 'zero';
    	return user.save();
  	})
  	.then((user) => {
    	return Users.findOne({ gender: 'f' });
 		})
  	.catch(err => {
    	console.error(err);
  	});
}
```

<br/>

## 7. async/await

- promise보다 코드가 더 간결해짐

```javascript
async function findAndSaveUser(Users) {
	try {
		let user = await Users.findOne({});
    user.name = 'zero';
    user = await user.save();
    user = awiat Users.findOne({ gender: 'f' });
	} catch(error) {
    console.error(error);
  }
}
```


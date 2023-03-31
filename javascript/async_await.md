# async / await

- ES8 비동기 처리 패턴
- await , async function 자체 모두 promise를 반환합니다.
- await는 resolve로 리턴해주는 값을 꺼낸다.

## microtask queue

- Promise에서 `then(resolve, reject)` 가 호출되면 callback이 microtask queue에 들어갑니다.
- 각 event loop phase 사이마다 microtask queue에 있는 callback을 실행합니다.

## [ES5 변환](https://es6console.com/)

- async/await를 generator로 구현합니다.

  - 비동기 로직이 종료되었을 때마다 `next()`를 호출하는 방식입니다.
  - promise는 generator로 만들어진 iterator를 반복해서 실행해주는 역할을 합니다.

- await는 모두 promise.resolve()를 통해 전달되므로, 기본 프라미스가 아닌 프라미스를 안전하게 await 할 수 있습니다.

  > generator
  >
  > - generator를 호출하면 실행되는 것이 아니라 iterator 객체가 반환되어 iterator의 next()를 호출하면 generator가 yield를 만날때까지 실행되고, context는 저장된 상태로 남아있게 됩니다.

```js
async function main() {
  await getRecommendThemePlaces();
}
```

```js
// 즉시 실행 함수로 변환되어 선언과 동시에 함수가 실행됩니다.
// 즉, 외부에서 main()을 호출하면 리턴되는 function main이 호출됩니다.
let main = (() => {
  // _asyncToGenerator 함수는 generator 함수 인자를 가집니다.
  // babel에서 generator 함수는 `regenerator` 라이브러리 이용하여 구현합니다.
  var ref = _asyncToGenerator(function*() {
    yield getRecommendThemePlaces();
  });

  return function main() {
    return ref.apply(this, arguments);
  };
})();

// fn = function*() { yield getRecommendThemePlaces }
function _asyncToGenerator(fn) {
  return function() {
    var gen = fn.apply(this, arguments);
    // 여기 _asyncToGenerator가 promise를 리턴하여 async 함수가 promise를 리턴하는 것입니다.
    return new Promise(function(resolve, reject) {
      function step(key, arg) {
        try {
          // key가 next이면 {value: xxx, done: boolean } 형태의 iteration 객체를 반환합니다.
          // value는 yield의 리턴값이고 done은 generator 함수 안에 모든 yield가 실행되었는지 여부를 나타냅니다.
          var info = gen[key](arg);
          var value = info.value;
        } catch (error) {
          reject(error);
          return;
        }
        
        if (info.done) {
          // generator가 종료되어서 resolve(value)를 호출합니다.
          resolve(value);
        } else {
          // 아직 generator가 끝나지 않았으면 새로운 promise를 생성하고 step('next', value)를 실행합니다.
          return Promise.resolve(value).then(
            function(value) {
              // 재귀호출
              // step('next') 호출될 때마다 context의 위치를 변경하고(context.next), 해당 위치의 함수를 실행합니다.
              return step('next', value);
            },
            function(err) {
              return step('throw', err);
            }
          );
        }
      }
      // 내부적으로 위의 step 함수를 생성하고 step('next')를 호출합니다.
      return step('next');
    });
  };
}
```

## return Promise vs. return await Promise

- 공통점 : 두 함수 모두 promise를 리턴합니다.
- 차이점
  - `return await Promise`는 promise가 resolve 될 때까지 await(기다리고), 또 promise를 감쌉니다.
  - try / catch가 감싸고 있는 경우, `return Promise` 에서 catch는 절대 실행되지 않습니다. (await 없이 return 했기 때문입니다. )

>예를 들어, promise를 리턴하고 50%의 확률로 fulfill - "yay" / reject - error를 던지는 함수가 있습니다.
>
>```js
>async function waitAndMaybeReject() {
>  // Wait one second
>  await new Promise(r => setTimeout(r, 1000));
>  // Toss a coin
>  const isHeads = Boolean(Math.round(Math.random()));
>
>  if (isHeads) return 'yay';
>  throw Error('Boo!');
>}
>```
>
>1. 단순 호출 : 기다리지 않습니다.
>   - fulfill - undefined
>
> ```js
> async function foo() {
>   try {
>     waitAndMaybeReject();
>   }
>   catch (e) {
>     return 'caught';
>   }
> }
> ```
>
>2. await - 기다리지만 return이 없어 fulfill - undefined 이거나 'caught'
>
> ```js
> async function foo() {
>   try {
>     await waitAndMaybeReject();
>   }
>   catch (e) {
>     return 'caught';
>   }
> }
> ```
>
>3. return
>
>   - fulfill - 'yay'
>
>   - reject - Error('Boo!')
>
>     > await 없이 리턴하여 foo 내의 catch는 실행되지 않습니다.
>
> ```js
> async function foo() {
>   try {
>     return waitAndMaybeReject();
>   }
>   catch (e) {
>     return 'caught';
>   }
> }
> ```
>
>4. return await
>   - fulfill - 'yay' or 'caught'
>
> ```js
> async function foo() {
>   try {
>     return await waitAndMaybeReject();
>   }
>   catch (e) {
>     return 'caught';
>   }
> }
> ```

## 기타

이전에 헷갈렸던 것을 transpiler를 통해 변환하고나서야 제대로 이해해서 같이 정리해봅니다ㅎㅎ

##### map, forEach 안의 async / await   -   For loop 안의 await

- Map, forEach는 map 내부에 generator 함수가 생기는 반면 for loop는 for loop 밖에 generator함수가 감싸고 있어 yield로 차례대로 실행할 수 있습니다.

  > 따라서 map, foreach는 첫번째 generator가 완료되기를 기다리지 않고 두 번째 generator를 호출합니다.

```js
placesType.map(async placeType => {
  await upsertRecommendThemePlaces();
});

// transpile
placesType.map(
  (() => {
    var ref = _asyncToGenerator(function*(placeType) {
      yield upsertRecommendThemePlaces();
    });

    return function(_x) {
      return ref.apply(this, arguments);
    };
  })()
);
```

```js
async () => {
  for (const placeType of placeTypes) {
    await upsertRecommendThemePlaces();
  }
};

// transpile
var ref = _asyncToGenerator(function*() {
  for (const placeType of placesTypes) {
    yield upsertRecommendThemePlaces();
  }
});
```

##### 순차 / 병렬

1. 

```javascript
// 1000ms
async function series() {
  await wait(500);
  await wait(500);
  return "done!";
}

// 500ms (둘 다 동시에 일어나길 기다림)
async function parallel() {
  const wait1 = wait(500);
  const wait2 = wait(500);
  await wait1;
  await wait2;
  return "done!";
}
```

2. 

- URL을 가져와서 최대한 빨리 순서대로 로그로 기록하는 경우

```javascript
function logInOrder(urls) {
  // fetch all the URLs
  const textPromises = urls.map(url => {
    return fetch(url).then(response => response.text());
  });

  // log them in order
  textPromises.reduce((chain, textPromise) => {
    return chain.then(() => textPromise)
      .then(text => console.log(text));
  }, Promise.resolve());
}
```

```javascript
// NO!
// 훨씬 깔끔해보이지만 첫번재 가져오기를 완전히 읽은 후에야 두번째 가져오기가 시작됨
// 이렇게 하면 속도가 느려짐
async function logInOrder(urls) {
  for (const url of urls) {
    const response = await fetch(url);
    console.log(await response.text());
  }
}
```

```javascript
// YES!
// URL을 병렬로 가져와서 읽고 로그는 순차적으로 출력
async function logInOrder(urls) {
  // fetch all the URLs in parallel
  const textPromises = urls.map(async url => {
    const response = await fetch(url);
    return response.text();
  });

  // log them in sequence
  for (const textPromise of textPromises) {
    console.log(await textPromise);
  }
}
```

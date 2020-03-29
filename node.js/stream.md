# stream

## 등장 배경

- node에서 `fs.readFile` 는 non-blocking method임 -> 대용량 파일의 경우 파일 전체를 모두 로드(이벤트 루프를 막게 됨)하기 전에 메모리 버퍼를 절약하기 위해 stream 등장
- 큰 파일을 요청했을 때, 한번에 한 청크씩 스트림으로 흘려 보냄(모든 것을 메모리에 버퍼로 잡지 않음)

## stream type

모든 stream은 EventEmitter의 인스턴스. 데이터를 읽거나 쓸 때 사용할 이벤트를 emit 함. 아래와 같은 4개를 위한 클래스가 stream library에 존재함.

- readable : 소비할 수 있는 데이터를 추상화
- writable : 데이터를 기록할 수 있는 종착점을 추상화
- duplex : 읽기 쓰기 모두 가능 ex) TCP socket
- Transform : 기본적으로 duplex stream. 데이터를 읽거나 기록할 때 수정/변환될 수 있는 데이터

## 읽기 stream

- data, end, error 이벤트를 가진 eventEmitter

  > data: 파일의 일부를 리턴
  >
  > end: 읽기가 완료되었을 때 호출
  >
  > error: 에러가 발생했을 때 호출

## pipe

- 입력을 출력으로 리다이렉트 할 수 있게 해줌
- stream간에 read와 write event를 연결

```javascript
// 소스는 읽기가능한 스트림이고 목적지는 쓰기 가능한 스트림
readableSrc.pipe(writableDest)
```

- Duplex stream으로 연결하면 파이프체인 호출 가능

  ```javascript
  // 읽기 가능한 스트림 -> duplex 스트림 -> 쓰기 가능한 스트림
  reableSrc
    .pipe(transformStream1)
    .pipe(transformStream2)
    .pipe(finalWritableDest)
  ```

- 

## 문제점

- data 이벤트에 기반하여 읽는 타이밍이나 한번에 얼마나 많은 데이터를 읽을지 제어할 수 없음

# stream2 

- node v0.10

![img](https://cdn-images-1.medium.com/max/1600/1*HGXpeiF5-hJrOk_8tT2jFA.png)

## readable stream

- 이전 stream interface와 더불어 새로운 'readable' 이벤트가 추가

- 데이터를 받을 준비가 되었다고 알려줄 때까지 데이터를 보내지 않음.

- 읽는 타이밍과 얼마나 읽을지 제어할 수 있게 됨

  ```javascript
  // node.js v0.10 이상
  var fs = require('fs');
  var stream = fs.createReadStream('./testimg.jpg');
  var writeStream = fs.createWriteStream('./output.jpg');
  
  stream.on('readable', function () {
  	// stream 이 읽을 준비가 됨
  	var data = stream.read();
  	writeStream.write(data);
  });
  
  stream.on('end', function () {
  	writeStream.end();
  });
  ```

- `stream.read()` 로 데이터를 읽는 것을 제어할 수 있음

  > 만약, 데이터를 읽을 수 없다면 readable event는 다시 이벤트 루프에 던져지고 나중에 다시 걸리게 됨.

- mode (수동으로 변경하려면 resume(), pause() 메소드 사용)

  - pause mode (pull mode)
    - 스트림을 읽기 위해 read() 호출
  - flowing mode (push mode)
    - 기반 시스템에서 데이터를 읽어와서 가능한 한 빨리 프로그램에 제공

- push : 소비할 데이터 push. null을 push하면 더 이상 데이터가 없다는 신호

  ```javascript
  const { Readable } = require('stream');
  
  const inStream = new Readable();
  
  inStream.push('ABCDEFGHIJKLM');
  inStream.push('NOPQRSTUVWXYZ');
  
  inStream.push(null); // 더 이상 데이터 없음
  
  inStream.pipe(process.stdout);
  ```

- read function

  - 요청이 있을 때 데이터를 Push
  - 호출되면, 일부 데이터를 queue에 push함.
  - 내부 버퍼에서 데이터를 가져와서 반환.
  - 인자에 size를 전달할 수 있음. size를 정하지 않으면 내부 버퍼 데이터 모두 반환함
  - non-flowing 모드에서만 호출해야함. flowing 모드에서 이 메서드는 내부 버퍼가 비워질 때까지 자동으로 호출됨

- readable : 스트림에서 데이터의 청크를 읽을 수 있을 때(데이터가 있을 때) 발생

- data : 스트림이 flowing mode로 바뀌고 데이터를 사용할 수 있게 되면 바로 핸들러로 전달

  - 가능한 한 빨리 스트림에서 데이터를 모두 받기 위한 방법

- end : 읽을 데이터가 더이상 없을 때 발생

- close : 의존 리소스가 닫혔을 때 발생

## Duplex/Transform stream

- 한 객체로 읽기/쓰기가 가능한 stream을 만들 수 있음

```javascript
const { Duplex } = require('stream');

const inoutStream = new Duplex({
  write(chunk, encoding, callback) {
    console.log(chunk.toString());
    callback();
  },

  read(size) {
    this.push(String.fromCharCode(this.currentCharCode++));

    if (this.currentCharCode > 90) {
      this.push(null);
    }
  }
});

inoutStream.currentCharCode = 65;

process.stdin.pipe(inoutStream).pipe(process.stdout);
```

- 읽기/쓰기가 완전히 독립적으로 동작
- transform은 transform function만 구현하면 됨.

```javascript
const { Transform } = require('stream');

const upperCaseTr = new Transform({
  transform(chunk, encoding, callback) {
    this.push(chunk.toString().toUpperCase());
    callback();
  }
});

process.stdin.pipe(upperCaseTr).pipe(process.stdout);
```



## writable stream

- drain event 추가 - buffer에 있는 모든 데이터가 쓰여졌을 때 호출, buffer가 비워졌을 때 데이터를 쓸 수 있도록 타이밍 제어 가능

```javascript
// node.js v0.10 이상
var fs = require('fs');

var stream = fs.createReadStream('./input.mp4');
var writeStream = fs.createWriteStream('./output.mp4');

var writable = true;
var doRead = function () {
	var data = stream.read();
	//만약 wriable이 false 를 리턴한다면, buffer가 꽉 차있다는 뜻이다.
	writable = writeStream.write(data);
}

stream.on('readable', function () {
	if(writable) {
		doRead()
	} else {
		// stream buffur가 꽉 찼으니 drain 이벤트가 발생할 때까지 대기
		writeStream.removeAllListeners('drain');
		writeStream.once('drain', doRead)
	}
});

stream.on('end', function () {
	writeStream.end();
});
```

- finish - 파일 쓰기가 모두 완료되었을 때 호출

- custom writable stream 생성

  - streams2 writable abstract class 사용 or polyfill 모듈인 readable-stream 사용하여 구현

  - 단지 writable을 상속해서 _write(chunk, encoding, cb) 구현하면 됨

    ```javascript
    var util = require('util');
    var stream = require('stream');
    var Writable = stream.Writable || require('readable-stream').Writable;
    
    function MyStream (options) {
        Writable.call(this, options);
    }
    util.inherits(MyStream, Writable);
    
    MyStream.prototype._write = function (chunk, enc, cb) {
        // chunk를 저장한 뒤, 마치면 cb을 호출한다.
        cb();
    };
    ```

- write function(chunk, encoding, callback)

  - chunk : buffer
  - callback : 데이터 청크를 처리한 뒤에 호출되는 함수. 쓰기를 성공했는지 여부를 알림
#### 고급서버프로그래밍



##### 에러해결

> ##### npm start:server 안됨

```javascript
  "scripts": {
    "start": "nodemon server.js"
  },
```

> 이렇게 바꿔서 start하면 nodemon 되는데 start:server는 안됨..
>
> yarn을 깔면 해결..

`npm install -g yarn`

> ##### psql: 서버에 연결할 수 없음: Connection refused (0x0000274D/10061)
>
> ........재설치하니깐 해결됨...................
>
> ##### Proxy error: Could not proxy request /api/posts from localhost:3000 to http://localhost:3001/.
>
> 백앤드 서버 안켜짐.. 에러나서 
>
> ##### Error: Cannot find module '~blog\models/..configconfig.json'
>
> models/index.js  파일에서 var config    = require(__dirname + '/../config/config.json')[env]; 로 수정
>
> ##### sequelize deprecated String based operators are now deprecated. Please use Symbol based operators for better security,       
>
> ##### GET /api/posts 500 34.990 ms - 2276 
>
> config.json에   "operatorsAliases": false 추가
>
> ##### Error: No default engine was specified and no extension was provided.
>
> 




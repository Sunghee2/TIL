# MySQL

## CRUD

### CREATE

```mysql
CREATE TABLE users(
	id INT NOT NULL AUTO_INCREMENT,
  // char()은 고정 길이, varchar()는 가변 길이
  name VARCHAR(20) NOT NULL,
  // unsigned : 음수 안 됨
  age INT UNSIGNED NOT NULL,
  // -127 ~ 128까지 정수 저장. 또는 1 or 0 wjwkd
  married TINYINT NOT NULL,
  // 긴 글 저장. 몇백 자 이내는 varchar 사용
  comment TEXT NULL,
  create_at DATETIME NOT NULL DEFAULT now(),
  PRIMARY KEY(id),
  // 해당 값이 고유해야하는지 + name을 오름차순으로 기억. 
  // database가 별도의 컬럼을 관리하여 조회시 속도 빨라짐
  UNIQUE INDEX name_UNIQUE(name ASC)
	CONSTRAINT commenter FOREIGN KEY(commenter) REFERENCES nodejs.users(id)
  // 사용자 정보가 수정되거나 삭제되면 이것과 연결된 정보도 같이 수정하거나 삭제
	ON DELETE CASCADE
	ON UPDATE CASCADE)
  // table에 대한 보충 설명
  COMMENT = '사용자 정보'
  // 한글 입력
  DEFAULT CHARSET=utf-8
  ENGINE=InnoDB;
```

### READ

```mysql
SELECT id, name FROM users ORDER BY age DESC LIMIT 1 OFFSET 1;
```

> offset [건너뛸 숫자]

### UPDATE

```mysql
UPDATE users SET comment = 'hello' WHERE id = 2;
```

### DELETE

```mysql
DELETE FROM users WHERE id = 2;	
```




# Sqoop

1. **install sample data**

   `$ git clone https://github.com/datacharmer/test_db.git`

   `$ cd test_db`

2. **import DB**

   `$ mysql -u root -phadoop < employees.sql`

   `$ mysql -u root -phadoop employees`

   ```mysql
   > show tables;
   > desc employees;
   > select * from employees limit 10;
   > select count(*) from employees;
   
   > CREATE USER 'sqoop'@'localhost' IDENTIFIED BY 'hadoop_sq';
   > GRANT ALL PRIVILEGES ON employees.* TO 'sqoop'@'localhost';
   > FLUSH PRIVILEGES;
   ```

3. **password 파일 생성**

   `$ echo -n "hadoop_sq" > .password`

   `$ more .password`

   `$ hdfs dfs -put .password /user/$USER/`

   `$ hdfs dfs -chmod 400 .password /user/$USER/ .password`

   `$ rm .password`

4. **Sqoop import to HDFS**

   `$ sqoop import --connect jdbc:mysql://localhost/employees --table employees -m 1 --username sqoop --password-file hdfs:///user/maria_dev/.password --target-dir data/employees`

   ![](./screenshot/sqoop1.PNG)

   > Ambari의 File View에서 확인 가능

5. **Hive에 table 추가**

   ![](./screenshot/sqoop2.PNG)

6. **Sqoop Import to Hive**

   바로 Hive Table로 만들어서 import

   `$ sqoop import --connect jdbc:mysql://localhost/employees --table employees -m 1 --username sqoop --password-file /user/maria_dev/.password --hive-import --hive-overwrite --target-dir /user/maria_dev/data/tmp_employees --hive-table employees --create-hive-table`

   ![](./screenshot/sqoop3.PNG)

   <br/>

   SQL문으로부터 ORC Hive Table에 데이터 import

   `$ sqoop import --connect jdbc:mysql://localhost/employees -e "SELECT d.dept_no, d.dept_name, COUNT(e.emp_no) AS num_employees FROM departments d LEFT JOIN current_dept_emp e ON d.dept_no = e.dept_no WHERE \$CONDITIONS GROUP BY d.dept_no, d.dept_name;" -m 1 --username sqoop --password-file /user/maria_dev/.password --hcatalog-table departments` -> 해결 못함ㅠ

7. **movielens db, table 생성 / 사용권한 부여**

   ```mysql
   > DROP DATABASE IF EXISTS movielens;
   > CREATE DATABASE IF NOT EXISTS movielens;
   > USE movielens;
   > DROP TABLE IF EXISTS movies, ratings;
   > CREATE TABLE movies (
   	movieid INT NOT NULL,
   	title VARCHAR(255) NOT NULL,
   	genres VARCHAR(255),
   	PRIMARY KEY (movieid)
   );
   > CREATE TABLE export_employees (
   	emp_no INT NOT NULL,
   	birth_date DATE NOT NULL,
   	first_name VARCHAR(14) NOT NULL,
   	last_name VARCHAR(16) NOT NULL,
   	gender ENUM ('M', 'F') NOT NULL,
   	hire_date DATE NOT NULL,
   	PRIMARY KEY (emp_no)
   );
   > GRANT ALL PRIVILEGES ON movielens.* TO 'sqoop'@'localhost';
   > FLUSH PRIVILEGES;
   ```

8. **export movielens data**

   ORC File export

   `$ sqoop export --connect jdbc:mysql://localhost/movielens --table movies -m 1 --username sqoop --password-file hdfs:///user/maria_dev/.password --hcatalog-table movies ` -> 해결 못함ㅠ

   <br/>

   HDFS 파일에서 직접 export

   `$ sqoop export --connect jdbc:mysql://localhost/movielens --table export_employees --username sqoop --password-file /user/maria_dev/.password --export-dir /apps/hive/warehouse/employees --input-fields-terminated-by '\0001' `

   ![](./screenshot/sqoop4.PNG)

> :bug:
>
> `ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)`
>
> -> 뒤에 `-p` 써서 비밀번호 입력
>
> `Error while loading password file: The provided password file /user/maria_dev/.password does not exist!` -> 	`hadoop fs -ls` 하면 보이는데 ambari file view에는 안보임 이것때문일까... 다시 삭제하고 하니깐 됨
>
> `ERROR tool.ExportTool: Encountered IOException running export job: java.io.IOException: NoSuchObjectException(message:default.movies table not found)` -> hive table 생성 안해서 나오는 에러 
>
> `java.lang.ClassNotFoundException: org.apache.atlas.sqoop.hook.SqoopHook` -> atlas 안되서 나오는 문제... 해결 못함


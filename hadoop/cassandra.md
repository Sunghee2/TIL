# Cassandra

1. `$ cd /etc/yum.repos.d`

2. `$ sudo vi datastax.repo`

   ```
   [datastax]
   name = Datastax Repo for Apache Cassandra
   baseurl = http://rpm.datastax.com/community
   enabled = 1
   gpgcheck = 0
   ```

3. `$ sudo yum install dsc30`

4. `$ sudo service cassandra start`

5. `$ sudo yum install python-pip`

6. `$ sudo pip install cqlsh`

7. `$ cqlsh`

   ```cassandra
   cqlsh> CREATE KEYSPACE movielens WITH replication = {'class':'SimpleStrategy', 'replication_factor':'1'} AND durable_writes = true;
   cqlsh> USE movielens;
   cqlsh:movielens> CREATE TABLE users(user_id int, age int, gender text, occupation text, zip text, PRIMARY KEY(user_id));
   cqlsh:movielens> DESC users;
   ```

<br/>



> :memo:
>
> /etc/cassandra
>
> :bug:
>
> `IllegalArgumentException: Missing application resource.`
>
> cqlsh 실행할 때 `File "/usr/bin/cqlsh", line 121 except ImportError, e:` -> pip version이 3임. python 3 버전은 support안함. 삭제하고 다시 설치


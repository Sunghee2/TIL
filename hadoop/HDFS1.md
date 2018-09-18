**접속**

1. Ambari : https://localhost:8080 (maria_dev, maria_dev)
2. maria_dev/hadoop : `$ ssh maria_dev@localhost -p 2222 `

**파일 리스트**

```
# Local filesystem
$ ls -alF

# HDFS
$ hadoop fs -ls 
$ hadoop fs -ls <directory>
```



터미널에서 scp명령어를 사용해서 **파일 전송** 할 수 있음.

-  Local => VM

```
$ scp -P 2222 <local_directory_file> <user_name>@localhost:<vm_directory_file>
```



- VM => Local

```
$ scp -P 2222 <user_name>@localhost:<VM_directory_file><local_directory_file>
```



> 명령어 확인
>
> https://hadoop.apache.org/docs/r2.7.3/hadoop-project-dist/hadoop-common/FileSystemShell.html
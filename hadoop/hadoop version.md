## Hadoop 1.0

- **Hadoop 1.0 의 구성**

   ![hadoop1.0](http://2.bp.blogspot.com/-AOktw7cvoAA/VjOjt1tXlLI/AAAAAAACL24/DvtfyvNH0M8/s1600/snapshot930.jpeg)

   - hadoop 1.0 = HDFS + MapReduce
- 데이터를 담당하는 HDFS(하둡 분산 파일 시스템) : 네트워크로 연결된 여러 머신의 스토리지를 관리하는 하둡의 저장소 역할
     - 중복 저장(redundant)
     - 안정된 저장(fault-tolerant)
   - 프로세싱은 그 위의 MapReduce : 클러스터 리소스 관리와 데이터 프로세싱(분산된 대량 데이터를 읽어서 처리)
   
   - 이 기반 위에 Pig, Hive와 같은 부가 서비스 혹은 사용자의 어플리케이션이 돌아가게 된다. 



   ![img](https://t1.daumcdn.net/cfile/tistory/2160524953DF17D235)

HDFS와 MapReduce는 물리적으로 같은 서버들에 공존하는 것이 일반적이다. 두 시스템 모두 하나의 Master와 다중 Slave 구조를 갖는다. 이 경우 각 서버마다 HDFS slave와 MapReduce slave가 같이 놓인다. 많은 경우 master들은 별도 서버에 실행하지만 HDFS slave와 MapReduce slave는 같은 서버에 실행하기도 한다. 

- **HDFS(하둡 분산 파일 시스템)**

     - 네트워크로 연결된 여러 머신의 스토리지를 관리하는 하둡의 저장소 역할

     - 테라바이트 이상 크기의 데이터들을 여러 머신에 나누어 저장하기 위해 개발

       > 큰 데이터를 하나의 시스템에서 관리하는 것은 비용이 너무 크고 가능성이 낮기 때문에 자연스럽게 여러 대의 서버에 나누어 저장하는 분산 기술을 사용
       >
       > -> 파일을 64MB의 블록으로 나누어 분산된 서버에 저장

     - HDFS는 두 가지 메인 layer을 가짐

       1. Namespace = 디렉터리들과 파일들, 그리고 블록들로 구성
          - 디렉터리 혹은 파일의 생성, 삭제, 수정, 블록 위치 얻기 연산에 관한 명령어를 지원

       2. Block Storage

          - 이 layer는 다시 Block Management로 나뉨 

          - 이 부분은 Name Node에 포함되며, 

            1) Data Node의 등록을 관리하고, 주기적으로 상태를 체크, 

            2) 데이터 블록의 기록들을 처리하고 위치를 유지, 

            3) 블록 단위의 생성, 삭제, 수정과 같은 연산을 수행, 

            4) 블록의 복제를 관리한다.

          - 이와 같은 구조 특성에 따라 HDFS는 하나의 Namespace만 가능했다. 따라서 하나의 Name Node가 이 Namespace를 관리하기 때문에 가용성에 문제가 있을 수 있었다.

     또 HDFS는 세부적으로 하나의 Name Node와 여러 개의 Data Node로 구성되고 클러스터당 최대 4000개의 Node를 등록할 수 있다.

     1) **Name Node(Master Node)**

     HDFS에서 master 역할을 하며 서버 한 대로 구성된다. 역할은 다음과 같다. 

     - 메타데이터 관리 : editlog와 fsimage파일을 사용하여 이름, 파일 시스템의 트리와 모든파일과 디렉터리에 대한 메타데이터를 관리한다.

         > editlog : HDFS의 메타데이터에 대한 모든 변경 이력을 저장하는 로그파일이고 저장, 삭제, 이동 등의 액션 로그가 Name Node의 로컬에 저장된다.
         >
         > fsimage : 파일 시스템의 Namespace(디렉터리명, 파일명, 상태 정보)와 파일에 대한 블록 매핑 정보를 저장하는 파일로 Name Node의 로컬에 저장된다. 

     - 데이터노드 모니터링 : 데이터노드는 네임노드에게 3초마다 heartbeat를 전송한다. 네임노드는 이를 이용하여 데이터노드의 실행상태와 용량을 체크한다. 하트비트를 전송하지 않는 데이터노드는 장애서버로 판단한다.

     - 블록 관리 : 장애가 발생한 데이터노드의 블록을 새로운 데이터노드에 복제한다. 용량이 부족하다면 여유가 있는 데이터노드에 블록을 옮긴다.

     - 클라이언트 요청접수 : 클라이언트가 HDFS에 접근하려면 반드시 네임노드에 먼저 접속해야한다. HDFS에 파일을 저장할 경우 기존 파일의 저장여부와 권한 확인 절차를 거쳐 저장을 승인한다. 

     1.0에서 Name Node는 이중화 구성을 할 수 없어서, 하둡 클러스터를 운영할 때 단일 장애 지점이 된다. 

     2) **Data Node(Slave Node)**

     - 실제 데이터가 저장되며 서버가 여러 대로 구성

     - 클라이언트나 네임 노드의 요청으로 인한 블록 저장(실제 데이터의 저장)과 탐색을 담당

       > 클라이언트가 HDFS에 파일을 읽거나 쓰기 위해 Name Node에 요청을 날리면, Name Node는 어느 Data Node의 어느 블록에 파일이 있는지 알려준다. 그러면 클라이언트는 Data Node와 직접 통신하여 파일을 읽거나 쓰게 된다. 다시 말해, Data Node와 블록 위치가 정해지면 클라이언트는 Name Node와 통신하지 않고 해당 Data Node와 직접 통신한다. 

     - 클러스터가 처음 시작될 때, 각 Data Node에서 자신의 블록 정보를 Name Node에게 알려준다. Data Node는 주기적으로 Name Node에게 heartbeat와 블록의 목록이 저장된 block report를 보낸다. 또한 자신의 로컬 디스크에 변경사항이 발생할 때마다 Name Node에게 변경사항을 알려주게 된다. 

     - 그리고 동일한 데이터가 여러 서버에 중복 배치되어 있어 한 Data Node에 문제가 생기더라도 다른 Data Ndoe에서 그 데이터를 가져올 수 있어 무장애 운영을 할 수 있다.

     3) **Secondary Name Node(BackupNode, 체크포인팅 서버)**

     - Name Node의 복사본인 Secondary Name Node를 생성하기 때문에, 중요한 메타정보를 안전하게 관리

       Name Node가 메타데이터를 메모리에 담고 처리하는데 만약 서버가 리부팅 되면 사라질 수 있다. HDFS는 이러한 점때문에 editslog와 fsimage라는 두 개의 파일을 생성한다. 그런데 만약 editslog가 커지면 fsimage를 만드는데 시간이 많이 소요하게 된다.

     - Secondary Name Node는 이 문제를 해결하기 위해 fsimage를 갱신한다. 이러한 작업을 '체크포인트'라고 말한다.  Secondary Name Node는 네임노드의 백업이 아니고 단순히 fsimage를 줄여주는 역할만 한다. fsimage가 너무 커서 Name Node가 메모리에 로딩되지 못하는 경우를 예방하기 위해 사용되는 것이다. 

       edits는 최초 재시작 할 때만 empty상태가 된다. 운영 중 상태에서는 edits가 변경 사항을 저장하면서 무한정 커지게 된다. Secondary Name Node은 정기적으로 병합을 수행한다. 병합이 완료되면 edits.new는 비워지고, 변경된 최신 메타정보를 만들 수 있는데 이를 메인 네임노드와 동기화하는 것이다. 

- **MapReduce**

     구글에서 대용량 데이터 처리를 분산 병렬 컴퓨팅에서 처리하기 위한 목적으로 제작하여 2004년에 발표한 소프트웨어 프레임워크(구글의 웹 데이터 분석 모델)다. 이 프레임워크는 페타바이트 이상의 대용량 데이터를 신뢰도가 낮은 컴퓨터로 구성된 클러스터 환경에서 병렬 처리를 지원하기 위해서 개발되었다. 함수형 프로그래밍에서 일반적으로 사용되는 Map과 Reduce라는 함수 기반으로 주로 구성되어 처리해야할 데이터를 병렬화한다. 따라서 Map()과 Reduce()만 구현하면 뒷단의 복잡한 분산처리과정은 프레임워크가 처리하므로 개발자는 데이터 분석에만 집중할 수 있게 된다. 

     MapReduce Task는 Map과 Reduce 총 두 단계로 구성된다. 

     - Map은 임의 키-값 쌍을 읽어서 이를 필터링하거나 다른 값으로 변환하는 작업을 담당한다. 예를 들어 만들어진 샌드위치를 분해하는 것을 말한다. 
     - Reduce()는 Map()을 통해 출력된 값을 그룹화 하고, 그룹화한 값을 집계하는 역할을 한다. 예를 들어 분해한 샌드위치에서 각 재료를 key값으로 정렬 및 value를 추출하는 것을 말한다. 

     hadoop1.0에서는 큰 데이터가 들어왔을 때 64MB단위 블럭으로 분할하고 Map을 통해 각 블럭에 대한 연산을 수행한다. 그리고 **Shuffle**이라는 과정을 통해 같은 key값끼리는 같은 Reduce()가 호출되도록 한다(그래서 reduce가 list를 받는다). 이 후 각각의 블럭의 결과 정보를 합치는 Reduce()가 수행되고 이 결과들은 HDFS에 저장된다. 

     MapReduce를 통해 클러스터 별로 데이터를 프로세싱한다는 것은 데이터의 이동을 최소화 하는 의미가 있다. 프로세싱을 통해 최소한의 데이터만 추려서(reduce) 전달되기 때문에 모든 데이터를 한 곳에서 처리하기 위해 모두 옮겨야 했던 기존 방식에 비해 매우 효율적이다. 그러나 하나의 노드에서 실행될 수 있는 MapReduce의 작업의 개수가 제한되었다.                  MapReduce를 실행할 때는 슬롯 단위로 map/reduce task 개수를 관리했다. 따라서 mapper와 reduce를 따로 설정하다 보니 mapper는 모두 작동 중인데 reducer는 쉬고 있거나 이와 반대의 경우로 인해 클러스터의 전체 사용률이 낮았다. 이 때문에 클러스터 내 자원의 비효율적 사용이라는 문제점이 초래되었다. 하나의 노드에서 작업을 환료해도 아직 처리되지 않은 노드의 작업을 나눠가질 수 없는 구조이다. 

     hadoop 1.0의 MapReduce에서는 Job의 실행 과정을 제어하기 위해 Name Node(Master Node)에 하나의 Job Tracker을 사용하였고 각 Data Node에는 하나의 Task Tracker이 존재한다.

     1) **Job Tracker**

     ![관련 이미지](https://t1.daumcdn.net/cfile/tistory/1762633B4F571A051B)

     Job Tracker는 Job 스케쥴링(task와 Task Tracker를 연결)과 task 진행 모니터링(task를 추적하고, 실패하거나 느린 task를 다시 시작하고, 전체 카운터를 유지하는 방법으로 task 장부를 기록한다)를 맡고 있다. 따라서 하나의 노드인 Job Tracker는 Task Tracker 수천 개와 MapReduce Task를 처리 하며 리소스와 Job을 모두 관리한다. 이는 확장성과 관련된 선택권을 줄이며, 클러스터가 하나의 앱만 실행한다는 것을 알 수 있고  Job Tracker에서 지연이 생기면 모든 클러스터 노드가 지연될 것임을 뜻한다. 실제로 4천 대 이상의 클러스터나 4만개 이상의 task를 동시에 실행하지 못하는 hadoop 1.0의 문제점 중 하나인 병목현상이 생긴다. 

     2) **Task Tracker**

     Task Tracker는 동시에 task를 수행할 수 있으며, 서버 당 몇 개의 task를 동시에 수행할 것인지 설정 가능하다. 또 진행 상		황을 Job Tracker에게 전송한다. 만약 Task Tracker이 문제가 생기거나, 새로운 Task Tracker이 추가되면 Job Tracker는 자동으로 인식하여 추가 및 제거 작업을 수행한다. 장애가 발생한 Task Tracker의 작업은 Job Tracker가 다른 Task Tracker에게 재할당시키고(스케쥴링) task를 재시작한다.

     Task Tracker는 map 슬롯과 reduce 슬롯으로 구분된 고정 크기 '슬롯'의 정적 할당 설정을 가지고 있다. map 슬롯은 map task 실행에만 사용할 수 있고 reduce 슬롯은 reduce task에만 사용할 수 있다. 

- **Hadoop 1.0 의 동작방식**
  1. 클라이언트로부터 작업요청을 받은 Job Tracker는 Task Tracker별로 처리할 목록을 구성한다.
  2. Task Tracker는 주기적으로 heartbeat를 전송하고, Job Tracker는 이 메시지의 반환 값에 처리할 작업 ID를 반환한다.
  3. 작업 ID를 받은 Task Tracker는 관련된 작업의 정보를 하둡 파일 시스템에서 가져오고, 수행할 프로그램도 하둡 파일 시스템으로부터 로컬에 저장한다. 
  4. Task Tracker에서는 fork 명령을 이용해 Map과 Reduce를 실행하고 Job Tracker에게 메시지를 전달하면서 파일에 대한 변경사항은 Data Node와 통신한다. Data Node는 다시 Name Node에게 파일 블럭에 대한 정보를 전달한다. 



## Hadoop 2.0

hadoop 2.0에서는 1.0의 문제점을 해결할 YARN 아키텍처가 등장하였다.

- **Hadoop 2.0 의 구성**

  ![hadoop 2.0](https://i2.wp.com/www.dataenthusiast.com/wp-content/uploads/2014/09/yarn.png?w=491)

- **HDFS2**

  ![관련 이미지](https://t1.daumcdn.net/cfile/tistory/277D293E56854AE123)

   Name Node의 확장성, 고가용성을 위해 여러 개의 Name Node를 구성할 수 있도록 변경하였다. 그래서 네임 서버들을 구분하기 위해 여러 개의 Namespace가 독립적으로 사용된다. 이는 Name Node끼리 어떠한 조정도 불필요하다는 의미이다.  즉, 겉으로 보기에 완전히 다른 파일 시스템이 여러 개 있는 것처럼 보이지만 내부적으로는 Data Node들이 모든 Name Node들을 위한 공용의 Block Storage로서 사용된다. 각각의 Data Node는 클러스터 내의 모든 Name Node들에게 등록된다. Data Node들은 등록된 Name Node들에게 주기적으로 상태 정보를 전송하고, Name Node가 전송하는 명령을 처리한다.  

   또한 여러 개의 네임 서버에서 Data Node를 관리하기 위해서 Block Pools 개념도 등장한다. Block Pool은 하나의 Namespace에 속한 block들의 집합이다. Data Node들은 클러스터에 있는 모든 Block Pool들을 위해 block들을 저장한다. Name Node별로 Block Pool이 존재하는데, 이들은 서로 독립적으로 관리된다. 따라서 새로운 block을 추가하거나 삭제할 때 Name Node 사이에 메시지를 전달할 필요가 없다. 또한 하나의 Name Node에 문제가 생겨도 다른 Name Node의 block을 유지하고 있는 Data Node에는 영향이 없다. 

   1.0의 기존 HDFS에서는 하나의 Name Node를 통하여 Namespace를 유지했기 때문에 Namespace의 확장이 어려웠다. 작은 크기의 많은 파일을 생성하면 Name Node의 메모리의 한계때문에 시스템을 운용할 수 없었다. 그러나 2.0의 HDFS2에서는 Name Node를 추가하여 이를 해결할 수 있다. 또, 하나의 Name Node에서 모든 요청을 처리하면 요청에 대한 처리량이 저하된다(1.0). 따라서 2.0에서는 여러 Name Node를 운용함으로써 Name Node 요청에 대한 분산 효과를 가져올 수 있다. 마지막으로 여러 사용자가 존재하는 환경에서 서로 다른 Namespace를 제공할 수 있어 각 사용자는 독립된 저장 공간을 얻을 수 있다는 장점이 있다. 

 yarn의 경우, 하둡 1.0의 첫번째 문제점인 병목현상을 제거하기 위해서 잡트레커가 하던 관리 책임을 나누어 각각을 담당하는 컴포넌트를 만들었다. 

- **YARN(Yet Another Resource Negotiator)**

   1.0의 MapReduce모듈에서 발전한 것으로 기존에 비해 MapReduce뿐 아니라 다른 프로그래밍 모델도 적용할 수 있어 유연하고, 리소스도 훨씬 더 효율적으로 사용하도록 개선되었다. 

   yarn의 가장 핵심은 1.0에서의 Job Tracker의 두 가지 기능을 분리하자는 것이다. 위에 작성한 것과 같이 1.0의 Job Tracker는 클러스터의 리소스를 관리하는 것과 MapReduce Job을 스케쥴링, 모니터링하는 역할이다. 이 역할을 나누어 담당하는 컴포넌트를 만들었다. 클러스터의 전체적인 리소스를 관리하는 Resource Manager(RM)과 각 어플리케이션의 스케쥴링, 모니터링을 담당하는 Application Master로 나누었다. 따라서 hadoop 2.0에서는 하나의 Resource Manager와 여러 개의 Application master가 존재하여 별개의 Application Master이 각 Application을 관리하기 때문에 1.0의 문제점인 클러스터에서 병목 현상이 발생하지 않는다. 1.0은 4,000 Node나 40,000 task를 넘어서면 병목현상이 발생한다(Job Tracker가 Job과 task를 모두 관리). yarn은 10,000 Node와 100,000 task까지 확장할 수 있도록 설계되었다. 또한 yarn은 global resource manager로 자원 활용도를 높이고, 이를 추가하여 클러스터 속도를 높일 수 있다. 

   그리고 MapReduce 슬롯이 정해져 있지 않기 때문에, 클러스터 내부 자원을 더 효율적으로 활용하는데 도움을 준다. map과 reducer의 슬롯이 별도로 존재하지 않고 둘 다 컨테이너 안에서 동작하며 컨테이너 자체도 따로 슬롯이 있는 것이 아니라 전체 클러스터의 리소스 상황과 요청된 Job의 리소스 요구에 따라 Container가 몇 개나 실행될지 등이 결정된다. 따라서 1.0과 같이 슬롯이 없어서 task가 마냥 대기하고 있는 상황은 절대 발생하지 않는다. task를 실행할 수 있는 자원이 있으면 application은 그 자원을 받을 자격이 있다. 게다가 yarn의 자원은 잘게 쪼개져 있기 때문에 application은 필요한 만큼만 자원을 요청할 수 있다. 기존에는 개별 슬롯을 사용했기 때문에 특정 task를 위해 너무 많거나(자원의 낭비) 너무 적게(실패의 원인) 자원을 할당했다. 

   하둡 1.0의 경우는 MapReduce만을 기반으로 Hive, Pig 정도의 어플리케이션을 활용하는 반면 하둡 2.0의 경우는 YARN 위에 공유 자원풀을 공유하는 다양한 어플리케이션들을 활용할 수 있는 구조다. Yarn 위에선 Yarn API를 통해 새로운 분산처리 환경 개발이 가능하다. MapReduce프레임워크의 경우도 Yarn API이고 HAMA(오픈소스 분산처리 시스템), Storm on YARN(실시간 스트리밍 처리), HOYA(HBase), Spark on YARN, Apache Giraph on YARN과 같이 다양한 시도가 가능해졌다는 의미다(등이 지원되고 있다)(MapReduce프레임워크의 경우도 Yarn API입니다.). MapReduce/YARN 개념을 이용하여 대용량의 데이터를 나누어 분배할 수 있게 됐다. 어떻게 분배할 것인가를 생각할 필요가 있다. 클러스터에는 데이터를 처리할 수 있는 여러 노드들이 있고, 해당 노드에 어떤 처리를 하도록 스케줄링을 할 필요가 생긴 것이다.

  ![img](https://t1.daumcdn.net/cfile/tistory/2138435053DF191414)

  yarn은 Resource Manager와 Node Manager 등 두 가지 유형의 장기 실행 데몬을 통해 핵심 서비스를 제공한다. 

  1) **Resource Manager**

   Resource Manager(자원 관리)는 기존과 같이 클러스터마다 1개씩 존재하며 기본적으로 순수하게 하둡 클러스터의 전체적인 리소스 관리만을 담당하는 심플한 모듈이다. 현재 가용한 리소스들에 대한 정보를 바탕으로 이러한 리소스들을 각 application에 일종의 정책으로서 부여하고 그 이용 현황을 파악하는 업무에 집중한다. 세부적으로는 application에 자원을 할당하고(클러스터 전반의 자원 관리), Application Master(앱 관리자)를 관리하여 task들의 스케쥴링을 담당한다. 기존과 같이 클러스터마다 1개씩 존재한다. 클라이언트로부터 application 실행 요청을 받으면 그 application의 실행을 책임질 Application Master를 실행한다. 또한 클러스터 내의 모든 Node Manager와 통신을 통해서 각 서버마다 할당된 자원과 사용 중인 자원의 상황을 알 수 있으며, Application Master들과의 통신을 통해 필요한 자원이 무엇인지 알아내어 관리하게 된다. 

   Resource Manager 내부에는 여러 개의 컴포넌트들이 존재하며, Scheduler, Application Manager, Resource Tracker 세 개의 메인 컴포넌트가 있다.

  - **Scheduler**

     Node Manager들의 자원 상태를 관리하며 부족한 리소스들을 배정한다. Scheduler 는 프로그램의 상태를 검사하거나 모니터링 하지 않으며, 순수하게 스케쥴링 작업만 담당한다. 스케쥴링이란 자원 상태에 따라서 테스크들의 실행 여부를 허가해 주는 역할만 담당하며, 그 이상의 책임은 지지 않다. 즉, 프로그램 오류나 하드웨어의 오류로 문제가 발생한 프로그램을 재 시작시켜주지 않으며, 프로그램에서 요구하는 리소스(CPU, Disk, 네트워크등)에 관련된 기능만 처리한다.

  -  **Application Manager**

     Node Manager 에서 특정 작업을 위해서 Application Master를 실행하고, Application Master의 상태를 관리한다.

  - **Resource Tracker**
     Container가 아직 살아 있는지 확인하기 위해서, Application Master 재시도 최대 횟수, 그리고 Node Manager가 죽은 것으로 간주 될 때까지 얼마나 기다려야 하는지 등과 같은 설정 정보를 가지고 있다.

  2) **Node Manager**

   Node Manager는 클러스터의 각 노드마다 한 개씩 존재하며 노드의 Container를 관리해 할당된 자원 이상으로 사용하지 않도록 모니터링하고 관련 정보를 Resource Manager에게 알리는 역할을 담당한다. Application Master와 Container로 구성되어 있다. 

  - **Application Master**

      Application Master는 yarn에서 실행되는 하나의 task를 관리하는 마스터 서버를 말하며, 특정 프레임워크(MapReduce, Storm 등 다양한 application) 별로 Job을 실행시키기 위한 별도의 라이브러리이다. 예를 들면, 기존의 MapReduce는 MapReduce Application Master에서, 기존의 스트리밍 처리는 Storm Application Master에서 각자 담당하고 책임을 지게 된다. 하지만 2.0에서는 Job마다 하나의 서버가 Application Master로 실행되어 해당 Job에 필요한 자원을 Resource Manager로부터 받아내고 해당 Job 내의 task들을 관리한다. 즉, 특정한 application의 처리 라이브러리를 Application Master에 올림으로써 하나의 하둡 클러스터에서 다양한 application이 동시에 돌아가도록 하는 것이 핵심이다. 이러한 구조의 변화에 의해서 사용자는 데이터의 속성에 맞는 다양한 application을 처리하는 별도의 Application Master을 만들어서 확장시킬 수 있다. 

      Application Master는 하나의 프로그램에 대한 마스터 역할을 수행하며, Resource Manager와 협상하여 하둡 클러스처에서 자기가 담당하는 application에 필요한 리소스를 할당받고 Node Manager와 협의하여 자기가 담당하는 application을 실행하고 그 결과와 실행 중인 application의 생명주기를 주기적으로 모니터링한다. 그리고 담당 application의 실행 현황을 주기적으로 Resource Manager에게 보고한다. 

  - **Container**

      Container는 CPU, 디스크(Disk), 메모리(Memory) 등과 같은 속성으로 정의되며 실제 앱을 실행하고 상태값을 Application Master에 알린다. 이 속성은 그래프 처리(Graph processing)와 MPI와 같은 여러 응용 프로그램을 지원하는데 도움이 된다. 모든 작업(job)은 결국 여러 개의 테스크로 세분화되며, 각 테스크는 하나의 Container 안에서 실행이 된다. 필요한 자원의 요청은 Application Master가 담당하며, 승인 여부는 Resource Manager가 담당한다. Container 안에서 실행할 수 있는 프로그램은 자바 프로그램뿐만 아니라, 커맨드 라인에서 실행할 수 있는 프로그램이면 모두 가능하다.

       yarn의 설정방법에 따라 다르지만, Container는 Unix 프로세스 또는 리눅스 cgroup이 된다.

 

> MapReduce와 YARN 컴포넌트 비교
>
> |  MapReduce   |                 YARN                 |
> | :----------: | :----------------------------------: |
> | Job Tracker  | Resource Manager, Application Master |
> | Task Tracker |             Node Manager             |
> |     Slot     |              Container               |
>
>

- **Hadoop 2.0 의 동작방식**
  1. 클라이언트에서 응용프로그램을 요청한다.
  2. Resource Manager는 Container 할당을 책임지는 Applicatoin Master를 실행한다. 
  3. Application Master가 Resource Manager에 등록되고 클라이언트가 Resource Manager과 통신할 수 있게 된다.
  4. Application Master가 resource-request 프로토콜을 통해 적절한 리소스의 Container를 요청한다. 
  5. Conatiner이 성공적으로 할당되면, Application Master는 Container 실행 스펙을 Node Manager에게 제공하여 Container를 실행시킨다. 
  6. 응용프로그램 코드는 Container에서 실행되고, 진행률/상태 등의 정보를 Application Master에 제공한다. 
  7. 응용프로그램 실행 중 클라이언트는 진행률/상태 등을 얻기 위해 Application Master와 응용프로그램-스펙 프로토콜ㅇㄹ 통해 직접 통신한다.
  8. 응용프로그램이 완료되고 필요한 작업이 종료되면, Application Manager는 Resource Manager에 등록을 해제하고, 자신의 Container를 다른 용도로 사용할 수 있도록 종료한다. 



## Hadoop 3.0

hadoop 3.0 으로 넘어올 때는 HDFS의 효율화, 버그 수정, MR 성능 향상등의 변화가 있다. 

- **Java version**

  Hadoop 3.0을 사용할 때 필요한 Java version이 최소 8로 변화되었다. 

- **HDFS-EC(Erasure Coding)**

  Erasure Coding은 Fault-tolerance를 위한 데이터 보존 기법 중 하나로 흔히 RAID-5에서 사용되는 기법이며 안정성을 보장하는 데이터 저장 방식이다. 원래 HDFS는 데이터 안정성을 위해 데이터 복제(일반적으로 3개)로 인하여 저장공간이 많이 사용되는 문제를 가지고 있었다. 3.0에서는 Erasure Coding을 지원하여 데이터 저장공간을 줄일 수 있다. 데이터 원본을 작은 단위로 나누고 연속 단위를 서로 다른 디스크에 저장한다. 이것을 인코딩을 통해 parity bit를 계산하고 저장한다. 만약 데이터 손실시 남아있는 디스크의 bit들과 parity bit에 기초한 디코딩 계산을 통해 원본 데이터를 복구한다. 예를 들어 6개 블록이 존재할 때 이전 방식이라면 6 * 3 = 18 블록의 디스크 공간을 사용한다. 하지만 Erasure Coding(6 데이터, 3 패리티) 경우 디스크 공간은 9개 블록만 사용한다. 따라서 일반적으로 3배의 오버헤드를 갖는 HDFS의 복제 방식과 비교하여 약 1.4배의 오버헤드 만으로 더 적은 용량으로도 데이터를 저장하고 비슷한 fault-tolerance 수준을 갖는다.

- **YARN Timeline Service v.2**

  YARN Timeline Server는 YARN에서 실행되는 application의 현재 정보 및 히스토리 정보를 관리한다.

  먼저, YARN Timeline Service v.1을 살펴보자. YARN Timeline Server는 완료된 application들에 대한 일반적인 정보 관리를 한다. application의 일반적인 정보로 queue-name, user information, 컨테이너 리스트 등등으로 Resource Manager에 의해 history-store에 저장되고 web-UI에서 보여준다. 또 YARN Timeline Server는 실행 중이거나 완료된 application의 per-framework 정보를 관리한다. 여기서 pre-framework 정보는 application 또는 프레임워크에 특정한 정보를 의미한다. MapReduce를 예로 들면 map task, reduce task의 개수 등이 이에 해당한다. 이렇게 저장된 정보는 Timeline Server에 TimelineClient 에서 REST API 를 통해 Application Master 또는 Application Container 에게 쿼리로 요청될 수 있으며, 이를 통해 얻은 정보를 바탕으로 Application 의 다양한 정보를 확인하거나 UI 로 표현할 수 있다.

  YARN Timeline Service v.2 에서는 v.1 에서 가지고 있던 두가지 큰 문제점을 개선했는데, 첫번째는 데이터의 쓰기와 쓰기를 HBase 를 활용하여 분산처리 함으로써 확장성과 신뢰성을 확보한 것이며, 두번째는 flow와 aggregation 을 통해 YARN 애플리케이션에 대한 단계별 정보를 확인하는 기능의 사용성을 개선한 것 이다.

- **확장성**

  v.1에서는 writer/reader/storage가 단일 인스턴스로 제한되어 작은 클러스터에서 확장하기 어려웠다. v.2에서는 데이터 collector(wirter)와 reader를 구분짓는다. collector는 yarn application마다 기본적으로 한 개가 할당되고 reader는 분리된 인스턴스로 REST API를 통해 쿼리처리만 제공한다. 그리고 기본 백업 스토리지로 분산 저장이 가능한 Apache HBase를 사용한다.

- **사용성**

  ![flow_hierarchy](http://www.popit.kr/wp-content/uploads/2016/09/flow_hierarchy-600x418.png)

  yarn application의 단계적이고 논리적인 'Flow'를 제공하고 flow 수준에서의 metrics에 대한 aggregation도 지원한다. 이를 통해 yarn application들의 각 단계별 상태 정보를 수집, 관리하고 최적하를 하는 데 있어서 도움을 받을 수 있다. 

- **구조**

  ![timeline_v2](http://www.popit.kr/wp-content/uploads/2016/09/timeline_v2-600x422.jpg)

  YARN Timeline Service v.2는 각각 독립된 Application Master(AM)와 같은 노드에 있는 timeline collector들을 사용하여 데이터를 스토리지(HBase)에 각 application에 대한 metrics/events들을 분산 저장할 수 있다. Resource Manager 또한 자체의 timeline collector를 유지하면서 yarn의 일반적인 라이프사이클 등의 정보를 스토리지에 저장한다. Timeline reader은 timeline collector와는 분리된 별도의 데몬들로 REST API를 통해 받은 유저의 쿼리를 스토리지로부터 조회하여 결과를 전달하는 서비스를 제공한다. 

- **shell script 수정**

  hadoop shell script는 버그 수정 및 새로운 기능 추가를 위해 수정되었다. 따라서 기존 shell script 버전과 호환성이 유지되지 않는다. 

- **MapReduce task-level 최적화**

  MapReduce 수행 시 Shuffle 과정에서 발생하는 map 결과값 collector의 정렬 부분을 C/C++로 구현된 native 프로그램을 JNI(Java Native Interface)로 호출하는 것을 지원하기 시작하면서 성능이 약 30%이상 향상되었다. 

- **2개 이상의 Name Node 지원**

  hadoop 2.x의 HDFS Name Node HA는 단일 Active Name Node와 단일 Standby Name Node를 사용하고 editslog를 세 개의 Journal Node에 저장하는 방식으로 사용되었다. 하지만 Active NameNode 의 서버 혹은 프로세스 등의 장애상황이 발생하거나 소프트웨어/하드웨어 업그레이드를 통한 계획된 클러스터 재구동 상황에서도 Active 혹은 Standby NameNode 가 정상화 되는 시간까지, 전체 하둡클러스터는 서비스를 할 수 없는 장애상황을 맞이하게 된다. 이러한 상황은 클러스터를 운영하면서 증가하게되는 파일과 블록의 갯수, 그리고 네임스페이스 이미지의 크기가 커지면서 다운타임 시간이 점점 길어지게되는 치명적인 상황을 초래한다. 그러면서 좀 더 높은 수준의 fault-tolerance가 요구되어지면서 다수의 Standby Name Node를 동시에 운영할 수 새로운 기능이 추가되었다. 두 개 이상의 Name Node를 Running상태(Active/Passive)로 운영할 수 있는 설정이 가능하다. 예를 들어 3개의 Name Node(1 active 2 passive)와 5개의 Journal Node를 구성하면 해당 클러스터는 두 개 노드의 장애에 견딜 수 있게 된다. 

- **포트 변경**

  Hadoop 서비스에서 사용되던 디폴트 포트들이 수정되었다. 이전 버전에서는 여러 하둡 서비스의 포트가 Linux의 임시 포트 범위(32768-61000)를 사용하였다. 이때문에 충돌이 일어나 바인드 실패하는 경우가 발생하였다. 

  - Namenode ports: 50470 --> 9871, 50070 --> 9870, 8020 --> 9820
  - Secondary NN ports: 50091 --> 9869, 50090 --> 9868
  - Datanode ports: 50020 --> 9867, 50010 --> 9866, 50475 --> 9865, 50075 --> 9864
  - KMS server port : 16000 --> 9600

- **Microsoft 의 Azure Data Lake(클라우드 스토리지를 제공하면서 데이터 분석을 할 수 있게 해주는 서비스)를 지원**

- **Intra-datanode balancer**

  하나의 Data Node는 여러 Disk를 관리한다. write operation 중에는 일반적으로 데이터가 고르게 분할되어 디스크에 균등하게 채워진다. 하지만 Disk를 추가하거나 교체하면 해당 Data Node에 심각한 데이터 불균형 현상이 발생하게 된다. 기존 HDFS의 balancer에서는 이 상황을 처리할 수 없지만, hadoop 3.0은 CLI에서 hdfs diskbalancer명령어를 호출하는 것으로 해결할 수 있다. 

- **Reworked Daemon and Task Heap Management**

  MapReduce task 뿐만 아니라 hadoop 데몬의 heap 관리에도 일련의 수정이 이뤄졌다. 먼저, 데몬 힙 크기를 구성하는 새로운 방법으로 호스트의 메모리 크기에 따라 자동적으로 튜닝이 가능하며 HADOOP_HEAPSIZE 변수는 deprecated 되었다. 그 대신, 각각 Xms와 Xmx를 설정하기 위해 HADOOP_HEAPSIZE_MIN, HADOOP_HEAPSIZE_MAX가 도입되었다. 

> Xms : 최소 heap size		Xmx : 최대 heap size


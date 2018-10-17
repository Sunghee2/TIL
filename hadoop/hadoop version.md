## Hadoop 1.0

- **Hadoop 1.0 의 구성**

   ![hadoop1.0](http://2.bp.blogspot.com/-AOktw7cvoAA/VjOjt1tXlLI/AAAAAAACL24/DvtfyvNH0M8/s1600/snapshot930.jpeg)

    hadoop 1.0은 HDFS와 MapReduce로 이루어져 있다. 데이터를 담당하는 HDFS(하둡 분산 파일 시스템)은 네트워크로 연결된 여러 머신의 스토리지를 관리하는 하둡의 저장소 역할로 중복 저장(redundant)와 안정된 저장(fault-tolerant)을 담당한다. 프로세싱은 그 위의 MapReduce모듈이 맡는데, 클러스터 리소스 관리와 데이터 프로세싱(분산된 대량 데이터를 읽어서 처리)을 담당한다. 

    이 기반 위에 Pig, Hive와 같은 부가 서비스 혹은 사용자의 어플리케이션이 돌아가게 된다. 



   ![img](https://t1.daumcdn.net/cfile/tistory/2160524953DF17D235)

 HDFS와 MapReduce는 물리적으로 같은 서버들에 공존하는 것이 일반적이다. 두 시스템 모두 하나의 Master와 다중 Slave 구조를 갖는다. 이 경우 각 서버마다 HDFS slave와 MapReduce slave가 같이 놓인다. 많은 경우 master들은 별도 서버에 실행하지만 HDFS slave와 MapReduce slave는 같은 서버에 실행하기도 한다. 

- **HDFS(하둡 분산 파일 시스템)**

     네트워크로 연결된 여러 머신의 스토리지를 관리하는 하둡의 저장소 역할을 한다. 테라바이트 이상 크기의 데이터들을 여러 머신에 나누어 저장하기 위해 개발됐다. 큰 데이터를 하나의 시스템에서 관리하는 것은 비용이 너무 크고 가능성이 낮기 때문에 자연스럽게 여러 대의 서버에 나누어 저장하는 분산 기술을 사용하게 되었다. 따라서 블록 구조 파일 시스템인 HDFS는 파일을 64MB의 블록으로 나누어 분산된 서버에 저장된다. 

     HDFS는 두 가지 메인 layer을 가지고 있다. 첫 번째 layer는 Namespace이다. 이는 디렉터리들과 파일들, 그리고 블록들로 구성되어 있다. Namespace에서는 디렉터리 혹은 파일의 생성, 삭제, 수정, 블록 위치 얻기 연산에 관한 명령어를 지원한다. 두 번째 layer는 Block Storage이다. 이 layer는 다시 Block Management로 나뉜다. 이 부분은 Name Node에 포함되며, 1) Data Node의 등록을 관리하고, 주기적으로 상태를 체크, 2) 데이터 블록의 기록들을 처리하고 위치를 유지, 3) 블록 단위의 생성, 삭제, 수정과 같은 연산을 수행, 4) 블록의 복제를 관리한다. 이와 같은 구조 특성에 따라 HDFS는 하나의 Namespace만 가능했다. 따라서 하나의 Name Node가 이 Namespace를 관리하기 때문에 가용성에 문제가 있을 수 있었다.

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

      HDFS에서 slave 역할을 하고 실제 데이터가 저장되며 서버가 여러 대로 구성된다.  Data Node는 클라이언트나 네임 노드의 요청으로 인한 블록 저장(실제 데이터의 저장)과 탐색을 담당한다. 클라이언트가 HDFS에 파일을 읽거나 쓰기 위해 Name Node에 요청을 날리면, Name Node는 어느 Data Node의 어느 블록에 파일이 있는지 알려준다. 그러면 클라이언트는 Data Node와 직접 통신하여 파일을 읽거나 쓰게 된다. 다시 말해, Data Node와 블록 위치가 정해지면 클라이언트는 Name Node와 통신하지 않고 해당 Data Node와 직접 통신한다. 

      클러스터가 처음 시작될 때, 각 Data Node에서 자신의 블록 정보를 Name Node에게 알려준다. Data Node는 주기적으로 Name Node에게 heartbeat와 블록의 목록이 저장된 block report를 보낸다. 또한 자신의 로컬 디스크에 변경사항이 발생할 때마다 Name Node에게 변경사항을 알려주게 된다. 

      그리고 동일한 데이터가 여러 서버에 중복 배치되어 있어 한 Data Node에 문제가 생기더라도 다른 Data Ndoe에서 그 데이터를 가져올 수 있어 무장애 운영을 할 수 있다.

     3) **Secondary Name Node(BackupNode, 체크포인팅 서버)**

      HDFS는 Name Node의 복사본인 Secondary Name Node를 생성하기 때문에, 중요한 메타정보를 안전하게 관리할 수 있다. Name Node가 메타데이터를 메모리에 담고 처리하는데 만약 서버가 리부팅 되면 사라질 수 있다. HDFS는 이러한 점때문에 editslog와 fsimage라는 두 개의 파일을 생성한다. 그런데 만약 editslog가 커지면 fsimage를 만드는데 시간이 많이 소요하게 된다.

      Secondary Name Node는 이 문제를 해결하기 위해 fsimage를 갱신한다. 이러한 작업을 '체크포인트'라고 말한다.  Secondary Name Node는 네임노드의 백업이 아니고 단순히 fsimage를 줄여주는 역할만 한다. fsimage가 너무 커서 Name Node가 메모리에 로딩되지 못하는 경우를 예방하기 위해 사용되는 것이다. 

      edits는 최초 재시작 할 때만 empty상태가 됨. 운영 중 상태에서는 edits가 변경 사항을 저장하면서 무한정 커지게 된다. Secondary Name Node은 정기적으로 병합을 수행한다. 병합이 완료되면 edits.new는 비워지고, 변경된 최신 메타정보를 만들 수 있는데 이를 메인 네임노드와 동기화하는 것이다. 

- **MapReduce**

     구글에서 대용량 데이터 처리를 분산 병렬 컴퓨팅에서 처리하기 위한 목적으로 제작하여 2004년에 발표한 소프트웨어 프레임워크(구글의 웹 데이터 분석 모델)다. 이 프레임워크는 페타바이트 이상의 대용량 데이터를 신뢰도가 낮은 컴퓨터로 구성된 클러스터 환경에서 병렬 처리를 지원하기 위해서 개발되었다. 함수형 프로그래밍에서 일반적으로 사용되는 Map과 Reduce라는 함수 기반으로 주로 구성되어 처리해야할 데이터를 병렬화한다. 따라서 Map()과 Reduce()만 구현하면 뒷단의 복잡한 분산처리과정은 프레임워크가 처리하므로 개발자는 데이터 분석에만 집중할 수 있게 된다. 

     MapReduce Task는 Map과 Reduce 총 두 단계로 구성된다. 여기서 Map은 임의 키-값 쌍을 읽어서 이를 필터링하거나 다른 값으로 변환하는 작업을 담당한다. 예를 들어 만들어진 샌드위치를 분해하는 것을 말한다. Reduce()는 Map()을 통해 출력된 값을 그룹화 하고, 그룹화한 값을 집계하는 역할을 한다. 예를 들어 분해한 샌드위치에서 각 재료를 key값으로 정렬 및 value를 추출하는 것을 말한다. 

     hadoop1.0에서는 큰 데이터가 들어왔을 때 64MB단위 블럭으로 분할하고 Map을 통해 각 블럭에 대한 연산을 수행한다. 그리고 Shuffle이라는 과정을 통해 같은 key값끼리는 같은 Reduce()가 호출되도록 한다(그래서 reduce가 list를 받음). 이 후 각각의 블럭의 결과 정보를 합치는 Reduce()가 수행되고 이 결과들은 HDFS에 저장된다. 

     MapReduce를 통해 클러스터 별로 데이터를 프로세싱한다는 것은 데이터의 이동을 최소화 하는 의미가 있다. 프로세싱을 통해 최소한의 데이터만 추려서(reduce) 전달되기 때문에 모든 데이터를 한 곳에서 처리하기 위해 모두 옮겨야 했던 기존 방식에 비해 매우 효율적이다. 그러나 하나의 노드에서 실행될 수 있는 MapReduce의 작업의 개수가 제한되었다.                  MapReduce를 실행할 때는 슬롯 단위로 map/reduce task 개수를 관리했다. 따라서 mapper와 reduce를 따로 설정하다 보니 mapper는 모두 작동 중인데 reducer는 쉬고 있거나 이와 반대의 경우로 인해 클러스터의 전체 사용률이 낮았다. 이 때문에 클러스터 내 자원의 비효율적 사용이라는 문제점이 초래되었다. 하나의 노드에서 작업을 환료해도 아직 처리되지 않은 노드의 작업을 나눠가질 수 없는 구조이다. 

     hadoop 1.0의 MapReduce에서는 Job의 실행 과정을 제어하기 위해 Name Node(Master Node)에 하나의 Job Tracker을 사용하였고 각 Data Node에는 하나의 Task Tracker이 존재한다.

     1) **Job Tracker**

     ![관련 이미지](https://t1.daumcdn.net/cfile/tistory/1762633B4F571A051B)

     Job Tracker는 Job 스케쥴링(task와 Task Tracker를 연결)과 task 진행 모니터링(task를 추적하고, 실패하거나 느린 task를 다시 시작하고, 전체 카운터를 유지하는 방법으로 task 장부를 기록한다)를 맡고 있다. 따라서 하나의 노드인 Job Tracker는 Task Tracker 수천 개와 MapReduce Task를 처리 하며 리소스와 Job을 모두 관리한다는 의미이다. 이는 확장성과 관련된 선택권을 줄이며, 클러스터가 하나의 앱만 실행한다는 것을 알 수 있고  Job Tracker에서 지연이 생기면 모든 클러스터 노드가 지연될 것임을 뜻한다. 실제로 4천 대 이상의 클러스터나 4만개 이상의 task를 동시에 실행하지 못하는 hadoop 1.0의 문제점 중 하나인 병목현상이 생긴다. 

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

  ![hadoop 2.0](data:image/jpeg;base64,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)

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


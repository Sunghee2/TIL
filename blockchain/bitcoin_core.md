# Bitcoin Core

bitcoin core 공부하면서 헷갈린 것들 다시 정리한 것



**nonce (블록 헤더에 포함)**

특정 해시값을 결과로 나오게 하는 입력값을 찾으려면 무작위로 입력값을 계속 바꿔가며 찾아내야 됨(단방향 함수). 그 입력값을 바꿀 수 있는 유일한 것이 nonce

=> 블록 헤더에 포함된 6가지 정보 중에서 확정되지 않아 값을 바꿀 수 있는 유일한 항목

nonce값을 구해서 최종적으로 블록 해시 값을 구하고, 이 블록 해시값을 식별자로 가지는 유효한 블록을 만들어내는 것 : PoW

```
SHA-256 ("hello world" + " 0") = 3cad76d283686392c9c1813baf25239a3f09b9e075d830984a9a93d62b93adb8  
SHA-256 ("hello world" + " 1") = 063dbf1d36387944a5f0ace625b4d3ee36b2daefd8bdaee5ede723637efb1cf4  
SHA-256 ("hello world" + " 2") = ed12932f3ef94c0792fbc55263968006e867e522cf9faa88274340a2671d4441  
SHA-256 ("hello world" + " 3") = 4ffabbab4e763202462df1f59811944121588f0567f55bce581a0e99ebcf6606  
SHA-256 ("hello world" + " 4") = 000e5e410dd915d190cce21d72a40bdbcc9db96d80de87d28896b56766f31b4e  
SHA-256 ("hello world" + " 5") = f6471bb5cd1837f3ef4891903c40c5300c9f0fd8a902d5c3774628c44dab78ed  
SHA-256 ("hello world" + " 6") = 6a9b5a89258b50744dfdf62e49ac6d869e8916e04ce57d9d1fc953daed9bfcd8 
```

비트코인에서 사용하는 문제는 위와 같이 몇 개 이상의 0으로 시작하는 해시값을 찾으라는 것(hash값이 bits로 지정된 난이도값보다 작게 생성될 때 해당 블록 생성 성공 = 채굴). 원래는 임의의 문자열이 아닌 블록체인에 추가된 가장 최신 블록의 헤더가 해시의 대상이 됨. 



**Merkle–Damgård construction(M-D)**

: 한 개의 메시지를 해싱할 때 메시지를 같은 크기의 여러 블록으로 나눔 -> 그 블록을 하나의 압축함수(compress)를 이용하여 내부 상태와 함께 섞음 -> 내부 상태의 마지막 값(final hash) = 메시지의 해시 값 

![img](https:////upload.wikimedia.org/wikipedia/commons/thumb/e/e4/WidePipeHashFunction.png/400px-WidePipeHashFunction.png)

> 사진 : 위키피디아



**length-extension attack**

한 메시지(M)의 해시 값(final hash = Hash(M))을 알면, 임의의 블록(Block3)에 대한 Hash(M || Block3) 도 알 수 있음 (해싱된 메시지에 Block3을 붙일 수 있기 때문)

=> double hash 연산 사용(해시 함수 2개로 구성)



**머클트리(Merkle Tree)**

여러 개의 거래를 하나의 루트로 만듦. 두 거래를 묶은 다음 SHA256 알고리즘을 통해 해시값으로 나타내고 그렇게 묶은 값을 또 두 개씩 묶어 해싱 -> 수 백개의 거래 값들을 하나의 데이터로 만들어 줌.

![merkletrees.jpg](https://steemitimages.com/DQmWGVz7bsHEV82SahKn6t3iVFdF7AaP3kah4kxtxxWMJBb/merkletrees.jpg)

>사진 : https://steemit.com/kr/@jsralph/merkle-trees

거래량이 기하급수적으로 늘어나도 특정 거래를 찾는 경로는 단순해짐. log2(N)

-> 특정 거래가 블록 내부에 포함되는지 여부를 검증하는데 효과적



**Public Key, Private Key, Address**

public key는 타원곡선함수를 통해 private key로부터 계산됨. -> (x,y) 도출 -> 04+x+y(비압축 공개키) -> 03(or 02)+x (압축 공개키)

하나의 private key로 압축 public key는 2개 만듦 -> 각각 public key를 통해 2개의 address 생성(각 address는 동일한 private key에 대응)

Address : RIPEMD160(SHA256(public key)) -> Base58 Encoding

![img](https://t1.daumcdn.net/cfile/tistory/99B42D465AC617160A)

> 사진 : http://ihpark92.tistory.com/6?category=746286



> 출처
>
> https://d2.naver.com/helloworld/8237898
>
> https://homoefficio.github.io/
>
> 처음 배우는 암호화: 기초 수학부터 양자 컴퓨터 이후까지, 암호학의 현재와 미래 (저: 장필리프 오마송)
>
> https://steemit.com/kr/@jsralph/merkle-trees
>
> http://ihpark92.tistory.com/
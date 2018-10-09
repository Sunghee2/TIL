# Bitcoin Core

bitcoin core 공부하면서 헷갈린 것들 다시 정리한 것  

  

####**nonce (블록 헤더에 포함)**

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

  

#### **Merkle–Damgård construction(M-D)**

: 한 개의 메시지를 해싱할 때 메시지를 같은 크기의 여러 블록으로 나눔 -> 그 블록을 하나의 압축함수(compress)를 이용하여 내부 상태와 함께 섞음 -> 내부 상태의 마지막 값(final hash) = 메시지의 해시 값 

![img](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/WidePipeHashFunction.png/400px-WidePipeHashFunction.png)

> 사진 : 위키피디아  

  

#### **length-extension attack**

한 메시지(M)의 해시 값(final hash = Hash(M))을 알면, 임의의 블록(Block3)에 대한 Hash(M || Block3) 도 알 수 있음 (해싱된 메시지에 Block3을 붙일 수 있기 때문)

=> double hash 연산 사용(해시 함수 2개로 구성)  

  

#### **머클트리(Merkle Tree)**

여러 개의 거래를 하나의 루트로 만듦. 두 거래를 묶은 다음 SHA256 알고리즘을 통해 해시값으로 나타내고 그렇게 묶은 값을 또 두 개씩 묶어 해싱 -> 수 백개의 거래 값들을 하나의 데이터로 만들어 줌.

![merkletrees.jpg](https://steemitimages.com/DQmWGVz7bsHEV82SahKn6t3iVFdF7AaP3kah4kxtxxWMJBb/merkletrees.jpg)

>사진 : https://steemit.com/kr/@jsralph/merkle-trees

거래량이 기하급수적으로 늘어나도 특정 거래를 찾는 경로는 단순해짐. log2(N)

-> 특정 거래가 블록 내부에 포함되는지 여부를 검증하는데 효과적  

  

#### **Public Key, Private Key, Address**

public key : 코인 전송 받을 때 사용

private key : 전송 받은 코인을 소비할 때 거래 서명에 사용

public key는 타원곡선함수를 통해 private key로부터 계산됨. -> (x,y) 도출 -> 04+x+y(비압축 공개키) -> 03(or 02)+x (압축 공개키)

하나의 private key로 압축 public key는 2개 만듦 -> 각각 public key를 통해 2개의 address 생성(각 address는 동일한 private key에 대응)

Address : RIPEMD160(SHA256(public key)) -> Base58Check Encoding

> Base58 : 길이가 긴 숫자열을 압축해서 사용하는 방법으로 Base64가 대표적인데 이것의 부분집합으로 혼돈하기 쉬운 문자 6개('0', 'o', 'l', 'I', '+', '/' 등)을 제거한 텍스트 기반의 2진법 인코딩 포맷
>
> Base58Check : Base58의 결과 값으로 생성한 해시 값(checksum)을 마지막 4바이트에 추가
>
> checksum : 비트코인 주소의 오타나 오류 감지(잘못된 주소 입력으로 인한 코인 증발 방지)

![img](https://t1.daumcdn.net/cfile/tistory/99B42D465AC617160A)

> 사진 : http://ihpark92.tistory.com/6?category=746286  

  

#### UTXO(Unspent Transaction Output)

공개키로 암호화되어 아직 사용하지 않은 거래의 출력값(받은 이가 아직 다른 이에게 보내지 않은 채 남겨둔 비트코인 뭉치). 

> 입력값 : 거래에서 소비하고자 하는 UTXO(송금)
>
> 출력값 : 거래를 통해 새로 만들어지는 UTXO 
>
> (한 거래의 출력값이 새로운 거래의 입력값이 됨)

가장 최하단위 UTXO금액 1사토시(=0.00000001BTC)

ex) A가 10BTC, 5BTC짜리 UTXO를 보유하고 있고 B에게 12BTC를 보려고함. -> 입력값 : 10BTC, 5BTC 설정, 출력값으로 B의 주소와 보낼금액 12BTC 지정, 잔돈 3BTC A에게 보내는 출력값 지정(안할 시 채굴자의 수수료로 인식)

(10BTC CTxIn), (5BTC CTxIn) -> (B에게 12BTC CTxOut) (A에게 3BTC CTxOut)

![img](https://t1.daumcdn.net/cfile/tistory/9901D5455A6D67AA2A)![img](https://t1.daumcdn.net/cfile/tistory/993C8C475A6D628B11)

> CTxIn prevout - A의 공개키로 받은 CTxOut에 대한 포인터
>
> CTxIn scriptSig - A의 서명(private key)
>
> CTxOut nValue - 비트코인의 양
>
> CTxOut scriptPubKey - B의 public key



#### 비결정적 지갑(Non-Deterministic Wallet)

한 거래에만 사용하는 일회용 주소(무작위 생성)

주기적으로 모든 키를 백업하지 않으면 손실 일어날 수 있음 => 결정적 지갑



#### 결정적 지갑(Deterministic Wallet)

연상기호 코드 워드를 이용하여 Seed로 다른 모든 키들을 생성 가능.

Common Seed에서 단방향 Hash함수를 통해 private key를 연속적으로 생성

Seed만 알고 있으면 키를 전부 복원할 수 있음 (hash는 입력값이 같으면 동일한 출력값이므로 common seed만 알면모든 키 복원 가능)



Common Seed생성 위해 연상기호 코드 워드(Mnemonic Code Words) 사용

연상기호코드 : 임의의 영어 단어열 ex) "apple house soccer.." -> 이 단어를 PBKDF2를 사용하여 512비트의 common seed 생성



#### 계층결정적 지갑(HD Wallet)

트리 구조에서 생성된 키를 담고 있음(부모키가 자식키열을 만들어낼 수 있고, 각각의 자식키가 손자키열을 만들어낼 수 있음)

Root Seed는 결정적 지갑에서 설명되고 있는 연상기호코드 워드 사용. -> HMAC-SHA512 알고리즘(512bits)을 통해 Master private key(왼쪽 256bits)와 Master Chain code(오른쪽 256bits) 생성

키, 체인코드, 목표자식의 인덱스를 기반으로 자식키 생성

child private key : private key + chain code

child public key : public key + chain code (private key없이 public key로부터 child public key 생성)



> 출처
>
> https://bitcoin.org/en/developer-guide#block-chain
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
>
> http://decenter.sedaily.com/NewsView/1RZJK9SEOA
>
> http://joojis.tistory.com/entry/비트코인-주소에-대한-이해-1-UTXO-모델
# Ethereum Core

#### 이더리움 어카운트

1. 외부소유 어카운트 (EOA : Externally Owned Account)
   - 개인 키에 의해 통제되는 계정 정보
   - 따라서 자체적으로 트랜잭션 생성 가능
   - 다른 EOA에 이더를 전송하거나, 메시지를 통해 CA 계정 실행 가능
2. 컨트랙트 어카운트 (CA : Contract Account)
   - 컨트랙트 코드에 의해 통제되는 계정 정보(EOA와 달리 개인키 정보x)
   - 따라서 자체적으로 트랜잭션 생성 불가
   - 조건에 따라 다른 CA를 참조하기 위해 Internal Transaction 생성 가능

![62_1.png](https://steemitimages.com/DQmP4U8YyWpTtw4Z882ScaL6WsD3nuDbAaTx5zjZiTdyt9o/62_1.png)

> A가 B에게 10이더를 보내면서, 이더가 천만원이 되면 5이더는 B가 갖고 남은 5이더는 C에게 보내는 트랜잭션
>
> 1. A는 자신의 EOA로 이 내용을 담은 transaction을 만들어서 서명을 하고 블록에 포함시켜야 함
>
> 2. A가 보낸 transaction은 모든 노드들이 검증된 뒤 블록에 담겨 B에게 전송 됨
>
> 3. '이더가 천만원이 되면 ~' 이라는 조건이 담긴 메시지가 B의 CA로 보내짐
>
> 4. 이더가 천만원이 되면 B의 CA는 A로부터 받은 계약을 자동으로 실행
>
>    -> 5이더를 자신의 EOA로 보내고, 남은 5이더를 C의 EOA로 보내게 됨

<br/>

#### 머클 패트리시아 트리

이더리움에서 사용하는 수정된 머클트리이며 효율적으로 정보를 관리하기 위한 자료구조

각각의 노트들은 [key, value] 값을 갖고 있고 이웃 노드와 함께 상위 노드의 hash값으로 올려지게 됨 -> 반복된 과정을 거쳐 최상위 노드(root node)에 이르게 되고 이 노드의 hash 값을 root hash라 함

총 4종류

1. State Trie
2. Storage Trie
3. Transactions Trie
4. Receipts Trie



<br/>

> 출처
>
> https://steemit.com/kr/@yahweh87/eoa
>
> https://steemit.com/kr/@feyee95/5lzztc
>
> https://medium.com/ethereum-core-research/머클-패트리샤-트리-이해하기-2cb8a2617324


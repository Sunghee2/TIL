# 실습

```c++
pragma solidity ^0.4.0; // 버전 지정

contract SimpleStorage {
    uint storedData;  // block에 영구적으로 저장되는 data
    function set(uint x) public {
        storedData = x;
    }
    
    function get() public constant returns (uint) {
        return storedData;
    }
}

```



```c++
pragma solidity ^0.4.16;

contract MinimumViableToken {
    mapping (address => uint256) public balanceOf; 
    function MinimumViableToken(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    } // deploy할 때 수량 지정해줘야 함.
    function transfer(address _to, uint256 _value) public {
        balanceOf[msg.sender] -= _value; balanceOf[_to] += _value;
    }
}
```

:bug: compiler version 지정해줘야 함



#### 타입

- reference type 

  - array, struct는 메모리 or 스토리지에 위치할 수 있음

    > 예외적으로 mapping은 항상 스토리지에 위치해야함(hash table을 trie에 저장했기 때문)

  - 데이터 자체가 아닌 데이터가 저장된 메모리의 위치(pointer)를 가리킴
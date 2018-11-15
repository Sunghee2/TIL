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
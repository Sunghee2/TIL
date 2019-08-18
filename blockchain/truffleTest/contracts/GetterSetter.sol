pragma solidity 0.5.0;

contract GetterSetter {
    string message;
    
    constructor (string memory _initMessage) public {
        message = _initMessage;
    } 

    function getMessage() public view returns(string memory){
        return message;
    } 

    function setMessage(string memory _message) public {
        // message = _message;
        uint256 newMessageLength = bytes(_message).length;
        if(newMessageLength <= 5) {
            message = _message;
        } else {
            message = "-";
        }
    }

    function() external payable {
    }
}

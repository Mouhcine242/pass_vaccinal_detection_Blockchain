pragma solidity >=0.4.22 <0.9.0;

contract HelloWorld{
    string public name ;

    constructor() public {
        name = "Almoutanabi";
    }

    function setName (string memory nm) public {
        name = nm ;
    }
    




}
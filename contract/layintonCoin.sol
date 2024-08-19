// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
contract LayintonCoin {
    address public owner;
    mapping (address => uint  ) public  balances;
    event Sent(address from, address to);

    constructor() {
      owner = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == owner);
        balances[receiver] += amount;
    }

 
 function checkBal() public view returns (uint) {
       return balances[owner];
 }

    function send (address receiver, uint amount) public  {
        require(amount <= balances[msg.sender], "Insifficient balance"); 
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver);
    }

}
pragma solidity ^0.5.0;

contract ProfitSplitter {
    
    // payable addresses representing the employees and address owner representing the HR dept 

    address payable private employee_one;
    address payable private employee_two;
    address payable private employee_three;
    address payable owner;

    constructor (address payable _one, address payable _two, address payable _three) public {
    
    // Initialize the employyee addresses at the time of deployment. This enables not to hardcode the addresses in the program. 
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
        owner = msg.sender;
     }

    function balance() public view returns(uint) {

        // get the balance of the contract. this contract is set to only distribut but not to hold ether
        // hence, balance should always be 0. 
        return (address(this).balance);
    
    }

    function deposit() public payable {

        // deposit Ether to the employees after the required condition that only Owner can deposit. 

        require (msg.sender == owner, "You are not the Owner of this account");
        
        //split the amount to 3 employees equally

        uint amount = msg.value / 3; 

        //transfer the amount to 3 employees

        employee_one.transfer(amount);
        employee_two.transfer(amount);
        employee_three.transfer(amount);
        
        if (msg.value % 3 != 0) {

            //sending back to HR (`msg.sender`) any potential remainder amount from the split 
            owner.transfer(msg.value - amount * 3);
        }
        
        balance();
    }

    function fallback() external payable {
        // deposit any ether sent directly to the contract
        deposit();
    }

}
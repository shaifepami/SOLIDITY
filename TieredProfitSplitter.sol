pragma solidity ^0.5.0;

contract TieredProfitSplitter {
    
      // payable addresses representing the employees and address owner representing the HR dept 

    address payable private employee_one; // ceo address
    address payable private employee_two; // cto address
    address payable private employee_three; // coo's address
    uint private tier1_share;
    uint private tier2_share;
    uint private tier3_share;
    address payable owner;
    
    
    constructor (address payable ceo,  address payable cto, address payable coo, 
                    uint ceo_share, uint cto_share, uint coo_share) public {

        // Initialize the employee addresses and the %age share for each at the time of deployment  
        //This enables not to hardcode the addresses in the program. 

        employee_one = ceo;
        employee_two = cto;
        employee_three = coo;
        tier1_share = ceo_share;
        tier2_share = cto_share;
        tier3_share = coo_share;
        owner = msg.sender;
        
    }
    
    function balance() public view returns(uint) {

        // get the balance of the contract. this contract is set to only distribut but not to hold ether
        // hence, balance should always be 0. 

        return (address(this).balance);
    
    }
    
     function deposit() public payable {

         // deposit Ether to the employees after the required condition that only Owner can deposit. 

        require (msg.sender == owner, "You are not aythorized to operate this account"); 

        // Calculate rudimentary percentage by dividing msg.value into 100 units
        uint points = msg.value / 100; 
        uint total;
        uint amount;
        
        //transfer the amount to each of the employee
         
        amount = points * tier1_share;
        employee_one.transfer(amount);
        total += amount;
        
        amount = points * tier2_share;
        employee_two.transfer(amount);
        total += amount;
        
        amount = points * tier3_share;
        employee_three.transfer(amount);
        total += amount;
        
        
        if (total < msg.value) {

            // ceo gets the remaining tokens
            employee_one.transfer(msg.value - total); 
        }

      }

    function fallback() external payable {

         // deposit any ether sent directly to the contract
        
        deposit();
    }

    
}
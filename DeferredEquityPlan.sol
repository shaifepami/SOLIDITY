pragma solidity ^0.5.0;

contract DeferredEquityPlan {

    // define contract setup parameters 

    address payable private employee;
    address private human_resources;
    bool active = true; // this employee is active at the start of the contract
    uint total_shares = 1000;
    uint annual_distribution = 250;
   
    uint fakenow = now;     // used for testing purposes. 
    //comment the above line and replace fakenow instances in this program with 'now' before deploying to production.
    
    uint start_time = fakenow;  // permanently store the time this contract was initialized
    uint unlock_time = fakenow + 365 days;
    
    uint public distributed_shares;
    
    
    constructor (address payable _employee) public {

        //initialize the addresses of HR and the employee at the time of contract deployment without hardcoding
        
        human_resources = msg.sender;
        employee = _employee;
       
    }
    
    function distribute() public {

        // requires the following conditions to be met before distributing the equity.

        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract is not active.");
        require(unlock_time <= fakenow, "Account is locked until the next vesting period");
        require (distributed_shares < total_shares, "Cannot distribute beyond the Vested shares ");
        
        // set the account lock period to one more year so no distributions can happen before the vesting period.

        unlock_time +=365 days; 
        
        // distribute the vested amount by calculating the duration from the start date

        distributed_shares = ((fakenow - start_time)/(86400*365)) * annual_distribution;
        
        //double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > total_shares) {
            distributed_shares = total_shares;
        }
    }
    
    
    function fastforward() public {
        // enables to move the time forward by n number days so we can test the contract funcctionality of 
        // distributing the equity at vested periods. note: this function will consume gas.

        fakenow += 200 days;
    }

    
    function deactivate() public {

        // human_resources and the employee can deactivate this contract at-will

        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

   
    function() external payable {

         // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
        revert("Do not send Ether to this contract!");
    }
}

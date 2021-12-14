// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <=0.9.0;

contract LuckyDraw {
    
    struct participant {
        address payable participant_address;
        uint amount;
    }
    participant participantInfo; 
    participant[] public participants; 
    
    address payable public manager;
    uint public total_participants;
    uint public contractBalance;
    address public winner;

    modifier isPaymentEnough(){
        
        require( msg.value >= 0.5 ether );        
        _;
    }
    
    modifier restricted(){

        require( msg.sender == manager ); // Only Manager Can Call This Function
        _;
    }
    
    modifier ifOnlyHasParticipant(){

        require( total_participants > 0 );
        _;
    }
    

    constructor(){
        
        manager = payable(msg.sender);
    }
    
    function enterLuckyDraw() public payable isPaymentEnough{
       
        participantInfo = participant(payable(msg.sender), msg.value);
        participants.push( participantInfo );
        
        updateCondition();
    }
    
    
    function random() private view returns(uint){

        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp))) % total_participants;
    }
    
    function findWinner() public restricted ifOnlyHasParticipant{
      
        uint index = random();
     
        winner = participants[index].participant_address;
        
     
        participants[index].participant_address.transfer( address(this).balance );
        
     
        for( uint x = 0; x < total_participants; x++ ){
            participants.pop();
        }
        
        updateCondition();
    }
    
    
    function destroyContract() public restricted{
       
        selfdestruct( manager);
    }
    
    function updateCondition() private{
        contractBalance =  address(this).balance; 
        total_participants = participants.length; 
    }
    
}

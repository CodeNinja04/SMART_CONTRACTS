// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract Social{
    address public owner;
    uint256 private post_count;
    uint private total_posts;

     constructor(){
        owner=msg.sender;
    }

    modifier notOwner(){
        require(msg.sender!= owner);
        _;
    }
    
    // struct User{
    //     uint256 user_id;
    //     address user_addr;
    // }

    struct Post{
        uint256 userId;
        string _postImageHash;
        string authorName;
        string Description;
        uint256 post_id;
        uint256 total_post;
    }

    mapping (address => Post) private addressToUserPost;
    mapping (uint256 => address) private postToUserAddress;
    // User[] public userslist;
    // User userInfo;
    mapping (uint256 => bool) private notuserInfo;

   
    // function balanceof() public view returns(uint){
    //     return address(this).balance;
    // }

    event display(uint256 senderId, uint256 timestamp, string message, string image, string author , uint total_post, uint postid);
    event TransferReceived(address sender, uint256 amount);

    // Function for a user to post a message in our Social media app, user just need to write the description
    function displayPost(string memory _postdesc) public {
        emit display(addressToUserPost[msg.sender].userId, block.timestamp, _postdesc , addressToUserPost[msg.sender]._postImageHash,  addressToUserPost[msg.sender].authorName ,addressToUserPost[msg.sender].total_post,addressToUserPost[msg.sender].post_id );
    }
    // function to get the Post  details from a user 
    function SetPost( uint256 userId, string memory userName, string memory postDescription , string memory imageHash ) public{

        if(!notuserInfo[userId]){
            total_posts=0;
            notuserInfo[userId]=true;
        }
        postToUserAddress[ userId] = msg.sender;
        post_count++;
        total_posts++;
        addressToUserPost[ msg.sender].userId = userId;
        addressToUserPost[ msg.sender].authorName = userName;
        addressToUserPost[ msg.sender].Description = postDescription;
        addressToUserPost[ msg.sender]._postImageHash = imageHash;
        addressToUserPost[ msg.sender].post_id= post_count;
        addressToUserPost[postToUserAddress[ userId]].total_post= total_posts;
        
    }

    // Function to Display the user's post by PostId
    function getPostById(uint256 id ) public view returns(uint256 userid, uint timestamps, string memory desc,string memory avathash, string memory authname,uint256 total_post ){
        return (addressToUserPost[postToUserAddress[id]].userId, block.timestamp, addressToUserPost[postToUserAddress[id]].Description ,addressToUserPost[postToUserAddress[id]]._postImageHash,  addressToUserPost[postToUserAddress[id]].authorName,addressToUserPost[postToUserAddress[id]].total_post);
    }

    // Tipping Other User

    function SupportMe( address payable sender,uint256 amount ) notOwner payable external {
        require(sender != address(0), "Sender address cannot be zero.");
        sender.transfer(amount);
        emit TransferReceived(sender, amount);
    }
}
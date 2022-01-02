// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ERC20TokenInterface{
    
    // Returns the total token supply
    function totalSupply() external view returns (uint256);
    
    // Returns balance from owner account ( or someone account that own the token contract )
    function balanceOf(address _tokenOwner) external view returns (uint256 balance);
    
   
    function transfer(  address _to, 
                        uint256 _tokenValue ) external returns (bool success);
                        
   
    function approve(   address spender, 
                        uint256 tokens ) external returns (bool success);
    
    function allowance( address _tokenOwner, 
                        address _spender ) external view returns (uint256 remaining);
                        
    
    function transferFrom(  address from, 
                            address to, 
                            uint256 tokens ) external returns (bool success); 
    
    event Transfer(     address indexed _addressFrom, 
                        address indexed _addressTo, 
                        uint256 _tokenValue );
                        
    event Approval(	    address indexed _owner, 
    					address indexed _spender, 
    					uint256 _value );
}


contract MyToken is ERC20TokenInterface{
    
    address public contractOwner;
    
    uint public override totalSupply;

    mapping( address => uint ) public balances;
    
    mapping( address => mapping(address => uint)) allowed;
    
    constructor(){
        contractOwner = msg.sender;
        totalSupply = 100000;
        balances[contractOwner] = totalSupply; 
    }
    
     // Returns the name of the token
    function name() public pure returns (string memory){
        return 'MyToken';
    }
    
    // Returns the symbol of the token
    function symbol() public pure returns (string memory){
    	return 'MYTK';
    }
    
    // Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000
    function decimals() public pure returns (uint8){
    	return 0;
    }
    
    function balanceOf(address _tokenOwner) external view override returns (uint256 balance){
        return balances[_tokenOwner];
    }
    
    function transfer(  address _to, 
                        uint256 _tokenValue ) external override returns (bool success){
        require( balances[msg.sender] >= _tokenValue );  
        
        balances[_to] += _tokenValue; 
	    
	    balances[msg.sender] -= _tokenValue;
	    
	    emit Transfer( msg.sender ,_to,_tokenValue);
	    
	    return true;
    }

    function approve(   address spender, 
                        uint256 tokens ) external override returns (bool success){
        require( balances[msg.sender] >= tokens ); 
        
        require( tokens > 0 );
        
        allowed[msg.sender][spender] = tokens;
        
        emit Approval(msg.sender,spender,tokens);
        
        return true;
    }
    
    function allowance( address _tokenOwner, 
                        address _spender ) external view override returns (uint256 remaining){
                            
        return allowed[_tokenOwner][_spender];                    
    }
    
    function transferFrom(  address from, 
                            address to, 
                            uint256 tokens ) external override returns (bool success){
        
        require( allowed[from][to] >= tokens );
        
        require( balances[from] >= tokens );
        
        balances[to] += tokens;
	    
	    balances[from] -= tokens;
	    
	    allowed[from][to] -= tokens;
	    
	    return true;
    }
}
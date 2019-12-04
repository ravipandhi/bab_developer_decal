pragma solidity 0.5.11;

import './Queue.sol';
import './Token.sol';
import './SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	// YOUR CODE HERE
	
	using SafeMath for uint;
	
	address payable owner;
	
	//refund mappings
	mapping(address => uint) refunds;
	
    //token
    address token_contract_address;
    uint token_sold = 0;
	uint num_tokens_per_wei = 1;
	
	//time
	uint start_time;
	uint end_time; 
	
	//events
	 event token_events(
        address indexed _by,
        uint _value,
        uint _quantity,
        string _msg
    );
    

	constructor(uint _supply) public
	{
	   //create a new contract of crowdsale
	   
	   //set the deployment owner
	   owner = msg.sender;
	   
	   //set the token supply in Token.sol
	   
	   Token new_token_contract = new Token(_supply);
	   
	}
	
	
	//functions that can only be accessed by owner will follow now
	
	modifier onlyBy(address _account)
	{
	    require(msg.sender == _account, "Sender not authorized");
	    _;
	}
	
	function startCrowdSale(uint _start, uint _end) public onlyBy(owner) 
	{
	    start_time = _start;
	    end_time = _end;
	    
	    //TO DO : make user friendly change the start and end to be string and then convert from string to uint
	}
	
	function has_the_sale_ended() public 
	{
        require(now >= end_time);
        selfdestruct(owner);
    }
    
    function mint_new_tokens(uint _quantity) public onlyBy(owner) 
	{
	    //let the token contract handle all the logic of token mint
	    uint total_token_supply = Token(token_contract_address).mint(_quantity);
    }
    
    function burn_tokens(uint _quantity) public onlyBy(owner) 
	{
        //let the token contract handle all the logic of token burn
	    uint total_token_supply = Token(token_contract_address).burn(_quantity);
    }
    
    //functions that can be accessed by anyone
    
    
    function buy_tokens() payable public
    {
        //validation -starts
        
            //check if the supply has not exhausted
            
            
            //check if the crowdsale is alive
            
            
            //check if msg.sender satisfies queue conditions
            
        
        //validation -ends
        
        //calculate the number of FIT tokens they would get on the basis of the msg.value
        uint number_of_fits;
        //update the mapping in token.sol

        //change the tokenSold quantity.  
        
        //fire event
        emit token_events(msg.sender,msg.value,number_of_fits, "Tokens purchased");
        
    }
    
    function i_want_my_money_back(uint _number_of_fits) public
    {
        //validation -starts
        
            //check if the crowdsale is alive
            
            //check if they have invested ; call function in token.sol
            
            //check if msg.sender satisfies queue conditions
            
        
        //validation -ends
        
        //update the mapping in token.sol

        //change the tokenSold quantity.   
        
        //fire event
        emit token_events(msg.sender,msg.value,_number_of_fits, "Tokens refunded");
    }
    
    function () external payable 
    {
        
    }
    
	
}
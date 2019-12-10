
pragma solidity ^0.5.11;

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
    mapping(address => uint) deposits;
    //token
    Token token_contract;
    Queue queue_contract;
    uint token_sold = 0;
    uint tokens_per_wei = 1;

	//time
	uint start_time;
	uint end_time;

	function getOwner() public view returns (address)
    {
        return owner;
    }
    function getTokenConAdd() public view returns (address)
    {
        return address(token_contract);
    }
    function getQueueConAdd() public view returns (address)
    {
        return address(queue_contract);
    }
    function getTokensSold() public view returns (uint)
    {
        return token_sold;
    }


	//events
	 event token_events(
        address indexed _by,
        uint _value,
        uint _quantity,
        string _msg
    );


	constructor(address ad, address ad1) public
	{
	   //create a new contract of crowdsale

	   //set the deployment owner
	   owner = msg.sender;

	   //set the token supply and decimals in Token.sol

	   //token_contract = new Token(_supply, _decimals);
       //queue_contract = new Queue(5);
       token_contract = Token(ad);
       queue_contract = Queue(ad1);
       start_time = now;
	   end_time = start_time + 120;

	}

	function setTokenaddress(address ad1) public
	{
	    token_contract = Token(ad1);
	}


	//functions that can only be accessed by owner will follow now

	modifier onlyBy(address _account)
	{
	    require(msg.sender == _account, "Sender not authorized");
	    _;
	}

    //for each validation, have a modifier
    modifier onlyIfAlive()
    {
        require(now < end_time, "The crowdsale has ended");
        _;
    }

    //for each validation, have a modifier
    modifier onlyIfDead()
    {
        require(now >= end_time, "The crowdsale has not ended");
        _;
    }

    modifier onlyIfSupplyIsNotExhausted()
    {
        require(token_contract.getTotalSupply() != token_sold, "All the tokens have been sold");
        _;
    }

	function has_the_sale_ended() public onlyBy(owner) onlyIfDead()
	{
        refunds[owner] = address(this).balance; //owner can withdraw balance
    }


    function mint_new_tokens(uint _quantity) public onlyBy(owner) onlyIfAlive() returns(uint)
	{
	    //let the token contract handle all the logic of token mint
	    uint total_token_supply = token_contract.mint(_quantity);
        return total_token_supply;
    }

    function burn_tokens(address _buyer, uint _quantity) public onlyIfAlive() returns(uint)
	{
        //let the token contract handle all the logic of token burn
	    uint total_token_supply = token_contract.burn(_buyer,_quantity);
        return total_token_supply;
    }

    function getInLine() public returns(uint8 position)
    {
        uint8 queue_current_size = queue_contract.qsize();
        if(queue_current_size == 5)
        {
            revert('queue is full, wait a minute');
        }
        queue_contract.enqueue(msg.sender);

        return queue_current_size+1;
    }

    function buy_tokens() public payable onlyIfAlive() onlyIfSupplyIsNotExhausted()
    {


        uint8 queue_current_size = queue_contract.qsize();
        int my_place = queue_contract.checkPlace(msg.sender);

        if(my_place == -1)
        {
            //need to be added to the queue.

            //check for the size

            if(queue_current_size < 5)
            {
                //can be added
                queue_contract.enqueue(msg.sender);
                deposits[msg.sender] = msg.value;

            }
            else
            {
                revert('the queue is already full, try after some time');
            }

        }
        else
        {
            //already in queue
            if(my_place == 0)
            {
                if(queue_current_size >=2)
                {
                    // you can buy
                    uint total_ether_sent = msg.value + deposits[msg.sender];
                    require(total_ether_sent != 0, "send some ether to buy tokens");
                    uint number_of_fits = total_ether_sent * (10 ** token_contract.decimals()) / 1 ether;
                    //now we need to send tokens to the buyer from the source.

                    //update the mapping in token.sol
                    require(token_contract.transfer(msg.sender,number_of_fits), "token transfer not successful"); //here msg.sender would be the EOA which sent the funds using fallback.
                    //give approval to contract owner to give refund to you. In essence transferring from your account to their account.
                    require(token_contract.approveOwnerToRefund(msg.sender,number_of_fits), "approval to owner not successful");
                    //change the tokenSold quantity
                    token_sold = token_sold.add(number_of_fits);
                    //remove the buyer from the queue
                    queue_contract.dequeue();
                    //fire event
                    emit token_events(msg.sender,msg.value,number_of_fits, "Tokens purchased");
                    }
                    else
                    {
                        revert('you are the only one in the queue');
                    }
            }
            else
            {
                revert('wait for your turn');
            }
        }



    }

    function i_want_my_money_back(uint _number_of_fits) public onlyIfAlive()
    {
        //validation -starts

            //check if they have invested ; call function in token.sol
            require(token_contract.balanceOf(msg.sender) != 0, "You have not bought a thing");

        //validation -ends


        //either the buyer has to call the transfer method in Token.sol or he has to approve, he did approve owner when he first bought the tokens
        //update the mapping in token.sol
        require(token_contract.transferFrom(msg.sender,token_contract.owner(),_number_of_fits), "transfer from method not successful");
        //calculate ether quantity that has to be sent back
        uint ether_quantity = _number_of_fits / (10 ** token_contract.decimals()) * 1 ether;

        //change the tokenSold quantity
        token_sold = token_sold.sub(_number_of_fits);

        //add a mapping that says how much ether can you be reimbursed
        refunds[msg.sender] = ether_quantity;
        //fire event
        emit token_events(msg.sender,ether_quantity,_number_of_fits, "Tokens refunded");
    }



    function () external payable
    {
        buy_tokens();
    }

    function withdrawRefund() external returns(bool)
    {
		// YOUR CODE HERE

		uint amountOwed = refunds[msg.sender];

		if(amountOwed==0)
			revert("No amount owed to this address");

		refunds[msg.sender] = 0;

		bool transfer = msg.sender.send(amountOwed);

		if(!transfer)
		{
			refunds[msg.sender] = amountOwed;
			return false;
		}

		return true;
	}

}
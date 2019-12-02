pragma solidity 0.4.19;

import "./AuctionInterface.sol";

/** @title GoodAuction */
contract GoodAuction is AuctionInterface {

	/* New data structure, keeps track of refunds owed */
	mapping(address => uint) refunds;


	/* 	Bid function, now shifted to pull paradigm
		Must return true on successful send and/or bid, bidder
		reassignment. Must return false on failure and 
		allow people to retrieve their funds  */
	function bid() payable external returns(bool) {
		// YOUR CODE HERE


		// if(msg.sender!=getHighestBidder())
		// {
		// 	refunds[msg.sender] = msg.value;
		// 	return false;
		// }


		// uint highestBidAmnt = getHighestBid();
		// if(msg.value<=highestBidAmnt)
		// {
		// 	refunds[msg.sender] = msg.value;
		// 	return false;
		// }
		
		
		address highestBidderAddress = getHighestBidder();
		// bool sentSuccess = highestBidderAddress.send(highestBidAmnt);


		// if(!sentSuccess)
		// {
		// 	refunds[msg.sender] = msg.value;
		// 	return false;
		// }

		// highestBid = msg.value;
		// highestBidder = msg.sender;

		// return true;


		uint highestBidAmnt = getHighestBid();
		if(msg.value<=highestBidAmnt)
		{
			refunds[msg.sender] = msg.value;
			return false;
		}
		
		refunds[highestBidderAddress] = highestBidAmnt;

		highestBid = msg.value;
		highestBidder = msg.sender;

		return true;

	}

	/*  Implement withdraw function to complete new 
	    pull paradigm. Returns true on successful 
	    return of owed funds and false on failure
	    or no funds owed.  */
	function withdrawRefund() external returns(bool) {
		// YOUR CODE HERE

		uint amountOwed = refunds[msg.sender];

		if(amountOwed==0)
			return false;
		
		refunds[msg.sender] = 0; 
		
		bool transfer = msg.sender.send(amountOwed);

		if(!transfer)
		{
			refunds[msg.sender] = amountOwed;
			return false;
		}

		return true;
	}

	/*  Allow users to check the amount they are owed
		before calling withdrawRefund(). Function returns
		amount owed.  */
	function getMyBalance() constant external returns(uint) {
		return refunds[msg.sender];
	}


	/* 	Consider implementing this modifier
		and applying it to the reduceBid function 
		you fill in below. */
	modifier onlyBy(address _account) {
		require(msg.sender == _account);
		_;
	}


	/*  Rewrite reduceBid from BadAuction to fix
		the security vulnerabilities. Should allow the
		current highest bidder only to reduce their bid amount */
	// function reduceBid() 
	// 	external
	// 	onlyBy(highestBidder)
	// {
	// 	address highestBidderAddress = getHighestBidder();
	// 	uint highestBidAmnt = getHighestBid();

	// 	//require(msg.sender == highestBidderAddress);

	// 	require(highestBidAmnt >= 1);

	// 	highestBid = highestBid - 1;
		
	// 	bool transfer = highestBidderAddress.send(1);

	// 	if(!transfer)
	// 	{
	// 		highestBid += 1;
	// 	}
	// }

	function reduceBid() external onlyBy(highestBidder) 
	{
		// address hg = getHighestBidder();
		// require(msg.sender==hg);
		// assert(1 <= highestBid);

		// highestBid = highestBid - 1;

		// bool transfer = highestBidder.send(1);
		// if(!transfer)
		// {
		// 	highestBid = highestBid + 1; 
		// 	revert();
		// }


		uint amountToWithdraw = 1;
  highestBid = highestBid - amountToWithdraw;
  if (amountToWithdraw > 0) 
  {
    if (!(highestBidder.send(amountToWithdraw))) 
	{ 
		revert();
	}
  }
	}



	/* 	Remember this fallback function
		gets invoked if somebody calls a
		function that does not exist in this
		contract. But we're good people so we don't
		want to profit on people's mistakes.
		How do we send people their money back?  */

	function () payable {
		// YOUR CODE HERE
	}

}

pragma solidity ^0.5.11;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size;
	// YOUR CODE HERE

	struct Queue_Entry
	{
	    address element;
    }
	uint first_position_entry_time;
	uint queue_stay_duration;

    uint8 elements_present;
    Queue_Entry[] entries;

	/* Add events */
	// YOUR CODE HERE
	event TimeExceeded(address indexed _element, string _msg);


	/* Add constructor */
	constructor() public
	{
	    //initialize new queue contract
	    size = 5;
	    elements_present = 0;
	    queue_stay_duration = 300; //5 minutes
	}
	// YOUR CODE HERE

	/* Returns the number of people waiting in line */
	function qsize() public view returns(uint8) {
		// YOUR CODE HERE
		return elements_present;
	}

	/* Returns whether the queue is empty or not */
	function empty() public view returns(bool) {
		// YOUR CODE HERE
		return elements_present == 0;
	}

	modifier onlyIfSizeIsNot0()
	{
		require(elements_present > 0, "there are no elements in the queue");
		_;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() public view onlyIfSizeIsNot0() returns(address)
	{
		// YOUR CODE HERE
		address first = entries[0].element;
		assert(first!=address(0));
		return first;
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace(address _address) public view returns(int) {
		// YOUR CODE HERE
		Queue_Entry memory temp;
		for(uint8 i = 0;i < elements_present;i++)
		{
		    temp = entries[i];
		    if(temp.element == _address)
		        return i;
		}
		return -1;
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() public onlyIfSizeIsNot0(){
		// YOUR CODE HERE

		Queue_Entry memory first = entries[0];
		assert(first.element!=address(0));

		if(now >= first_position_entry_time + queue_stay_duration)
		    dequeue();


	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() public onlyIfSizeIsNot0() {
		// YOUR CODE HERE

		Queue_Entry memory first = entries[0];
		assert(first.element!=address(0));


		for(uint8 i = 0;i<qsize()-1;i++)
		{
		    entries[i] = entries[i+1];
		}
		entries[qsize()-1].element = address(0);
        elements_present--;
		//set the new start time for the first position
		first_position_entry_time = now;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) public {
		// YOUR CODE HERE
		uint i=0;
	    for(;i<elements_present;i++)
	    {
	        if(entries[i].element==address(0))
	            break;
	    }

	    //put at i

	    Queue_Entry memory myStruct = Queue_Entry({element:addr});
	    entries.push(myStruct);
		elements_present++;
	}
}
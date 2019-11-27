pragma solidity ^0.5.11;

//import "../contracts/strings.sol";

contract Betting {



    //contract owner and oracle can only be set once at the beginning.
    address contract_owner;  //there can only be one contract owner, so no 'set contract' method specified.
    address event_oracle;


    address[] public gamblers;
    address[] public list_of_winners;
    uint[] all_the_possible_outcomes;
    uint[] winn_amnt;

    bool auction_closed = false;

    mapping(address => uint) private map_addr_bet_amnt;
    mapping(address => uint) private map_addr_bet_outc;
    mapping(address => uint) private map_addr_bet_win_amt;


    constructor() public
    {
        //the contract owner is set.
        contract_owner = msg.sender;
        emit owner_oracle_set_broadcast(msg.sender, "Owner is set now", address(this));
    }

    // all the events --start

    event owner_oracle_set_broadcast(
        address indexed _from,
        string _value,
        address contract_address
    );

    event bet(
        address indexed _from,
        uint _value,
        string msg,
        uint bet_value
    );

    event possible_outcomes_broadcast(
        address indexed _from,
        uint[] _value,
        string msg
    );

    event common_event_msg(
        string common_msg
    );

    // all the events --end

    function set_oracle(address input) public{

        require(event_oracle==address(0), "Oracle cannot be reset");
        event_oracle = input;
        emit owner_oracle_set_broadcast(event_oracle,"Oracle is set now",address(this));
    }

    // function get_oracle() public view returns (address){
    //     return event_oracle;
    // }

    // function get_owner() public view returns (address){
    //     return contract_owner;
    // }

    function get_win_amnt() public view returns (uint[] memory){
        return winn_amnt;
    }
    function get_gamblers_list() public view returns (address[] memory){
        return gamblers;
    }

    function set_outcomes(uint[] memory outcomes) public{
        require(msg.sender==contract_owner, "Only the contract owner can set the outcomes");
        all_the_possible_outcomes = outcomes;
        emit possible_outcomes_broadcast(msg.sender, all_the_possible_outcomes, "The outcomes have been set");
    }


    function make_a_bet(uint expected_outcome) public payable returns (uint,uint,address[] memory)
    {
        //validation starts
        //the oracle should be set inorder to avoid oracle gambling first and then becoming oracle afterwards
        require(event_oracle!=address(0), "Oracle must be set before you can make a bet");
        //should not be an owner
        require(msg.sender!=contract_owner, "Owner cannot gamble");
        //should not be an oracle
        require(msg.sender!=event_oracle, "Oracle cannot gamble");
        //should not have placed a bet before
        require(map_addr_bet_amnt[msg.sender]==0, "You have already plavced a bet!");
        //should not place an empty bet (0)
        require(msg.value>0,"Please specify an amount");
        //validation ends

        //make a bet
        map_addr_bet_amnt[msg.sender] = msg.value;
        map_addr_bet_outc[msg.sender] = expected_outcome;

        //update variables
        gamblers.push(msg.sender);

        //emit an event to the blockchain
        emit bet(msg.sender, msg.value, "A bet was just made", expected_outcome);

        return (map_addr_bet_amnt[msg.sender],map_addr_bet_outc[msg.sender],gamblers);

    }

    function decide_winners(uint correct_outcome) public{

        
        require(list_of_winners.length==0,"Already decided the winners");
        //whom should the betting amount go to.
        for (uint i = 0; i<gamblers.length; i++)
        {
            if(map_addr_bet_outc[gamblers[i]]==correct_outcome)
            {
                list_of_winners.push(gamblers[i]);
            }
        }

    }


    function get_winners_list() public view returns (address[] memory){
        return list_of_winners;
    }

    function is_the_bet_same() public view returns(bool){
        bool same_bet_bool = true;

        //comparing if everyone has the same bet
        for (uint i = 0; i<gamblers.length; i++)
        {
            if(i!=gamblers.length-1 && map_addr_bet_outc[gamblers[i]] != map_addr_bet_outc[gamblers[i+1]])
            {
                same_bet_bool = false;
            }
        }

        return same_bet_bool;
    }

    function decide_the_outcome(uint correct_outcome) public returns(address[] memory){
        //validation starts

        //validate that all the gamblers have bet
        require(gamblers.length==2,"All the gamblers (2) have not placed a bet yet.");

        //validate that you are the oracle
        require(msg.sender==event_oracle, "Only the oracle can decide the outcome");

        //validate if the betting is still open
        require(auction_closed==false, "Betting is closed now");
    
        //validation ends

        //check if everyone has the same bet

        bool same_bet_bool = is_the_bet_same();
        

        if(same_bet_bool)
        {
            //reimburse all the money
            for (uint i = 0; i<gamblers.length; i++)
            {
                map_addr_bet_win_amt[gamblers[i]] = map_addr_bet_amnt[gamblers[i]];
            }
            emit common_event_msg("all bet on the same outcome, take your bet money back");
            //emit event : everyone bet on the same thing, not possible. take your money back
        }
        else
        {
            //this function decides who are the winners as per the outcome defined by the oracle.
            //decide_winners(correct_outcome);

            uint total_bet_amount = get_total_bet_amount();
            if(list_of_winners.length==0)
            {
                //emit event: no one had good luck. all the money goes to the oracle who decided the outcome
                emit common_event_msg("No one wins but the oracle.");
                map_addr_bet_win_amt[event_oracle] = total_bet_amount;

            }
            else
            {
                //emit event: the winners have been decided, you can request to withdraw to see if you have won.
                //give the amount on the basis of fair division.
                emit common_event_msg("The winners have been decided. You can try and withdraw to see if you have won.");
                uint num_of_winners = list_of_winners.length;
                uint amnt;
                for(uint i = 0;i<num_of_winners;i++)
                {
                    amnt = uint(total_bet_amount) / uint(num_of_winners);
                    winn_amnt.push(amnt);
                    map_addr_bet_win_amt[list_of_winners[i]] = amnt; //need to make changes for uneven division.
                }
            }
        }

        return list_of_winners;
    }

    function get_total_bet_amount() public view returns (uint){

        //iterate over all the gamblers and get the total amount invested.
        uint total_amount = 0;

        for (uint i = 0; i<gamblers.length; i++)
            total_amount += map_addr_bet_amnt[gamblers[i]];

        return total_amount;
    }


    /**
     This function allows the winners to withdraw their winning amount from the contract.
     */
    function take_my_winning_amount(uint amount) public payable returns (uint){
        //validation starts
        //withdrawer should be a winner
        require(map_addr_bet_win_amt[msg.sender]!=0, "You are not the winner, sorry!");
        require(map_addr_bet_win_amt[msg.sender] >= amount, "You have withdrawn your amount");

        map_addr_bet_win_amt[msg.sender] -= amount;

        if(!msg.sender.send(amount))
        {
            map_addr_bet_win_amt[msg.sender] += amount;
        }

        return map_addr_bet_win_amt[msg.sender];
    }
}
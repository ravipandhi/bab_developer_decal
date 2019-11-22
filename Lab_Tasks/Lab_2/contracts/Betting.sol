pragma solidity ^0.5.11;

//import "../contracts/strings.sol";

contract Betting {
    address contract_owner;
    address event_oracle;
    address[] public gamblers;
    address[] public list_of_winners;

    uint outcome_1;
    uint outcome_2;
    uint outcome_3;

    mapping(address => uint) private map_addr_bet_amnt;
    mapping(address => uint) private map_addr_bet_outc;
    mapping(address => uint) private map_addr_bet_win_amt;


    constructor() public
    {
        //the contract owner is set.
        contract_owner = msg.sender;
    }

    function set_oracle(address input) public{
        event_oracle = input;
    }

    function get_oracle() public view returns (address){
        return event_oracle;
    }

    function get_owner() public view returns (address){
        return contract_owner;
    }

    function get_gamblers_list() public view returns (address[] memory){
        return gamblers;
    }

    function set_outcomes(uint inp1, uint inp2, uint inp3) public{
        outcome_1 = inp1;
        outcome_2 = inp2;
        outcome_3 = inp3;
    }

    // event bet(
    //     address indexed _from,
    //     uint _value,
    //     uint bet_value
    // );

    function make_a_bet(uint expected_outcome, uint bet_amount) public payable returns (uint,uint,address[] memory)
    {
        //validation starts
        //should not be an owner
        require(msg.sender!=contract_owner, "Owner cannot gamble");
        //should not be an oracle
        require(msg.sender!=event_oracle, "Oracle cannot gamble");
        //should not have placed a bet before
        require(map_addr_bet_amnt[msg.sender]==0, "You have already plavced a bet!");
        //validation ends

        //make a bet
        map_addr_bet_amnt[msg.sender] = bet_amount;
        map_addr_bet_outc[msg.sender] = expected_outcome;

        //update variables
        gamblers.push(msg.sender);

        //emit an event to the blockchain
        // emit bet(msg.sender, amount, expected_outcome);

        return (map_addr_bet_amnt[msg.sender],map_addr_bet_outc[msg.sender],gamblers);

    }

    function decide_winners(uint correct_outcome) public{

        uint j = 0;

        //calculate if we have a same bet and also, decide the list of winners.
        for (uint i = 0; i<gamblers.length; i++)
        {
            if(map_addr_bet_outc[gamblers[i]]==correct_outcome)
            {
                list_of_winners[j++] = gamblers[i];
            }
        }

    }


    function get_winners_list() public view returns (address[] memory){
        return list_of_winners;
    }

    function same_bet() public view returns(bool){
        bool same_bet_bool = true;
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

        //validate that you are the oracle
        require(msg.sender==event_oracle, "Only the oracle can decide the outcome");

        //validation ends

        //check if everyone has the same bet

        bool same_bet_bool = same_bet();
        decide_winners(correct_outcome);

        if(same_bet_bool)
        {
            //reimburse all the money
            for (uint i = 0; i<gamblers.length; i++)
            {
                map_addr_bet_win_amt[gamblers[i]] = map_addr_bet_amnt[gamblers[i]];
            }
            //emit event : everyone bet on the same thing, not possible. take your money back
        }
        else
        {
            uint total_bet_amount = get_total_bet_amount();
            if(list_of_winners.length==0)
            {
                //emit event: no one had good luck. all the money goes to the oracle who decided the outcome
                map_addr_bet_win_amt[event_oracle] = total_bet_amount;

            }
            else
            {
                //emit event: the winners have been decided, you can request to withdraw to see if you have won.
                //give the amount on the basis of fair division.
                uint num_of_winners = list_of_winners.length;
                for(uint i = 0;i<num_of_winners;i++)
                {
                    map_addr_bet_win_amt[list_of_winners[i]] = total_bet_amount/num_of_winners; //need to make changes for uneven division.
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

        if(map_addr_bet_win_amt[msg.sender] >= amount)
        {
            map_addr_bet_win_amt[msg.sender] -= amount;

            if(!msg.sender.send(amount))
            {
                map_addr_bet_win_amt[msg.sender] -= amount;
            }
        }
        return map_addr_bet_win_amt[msg.sender];
    }
}
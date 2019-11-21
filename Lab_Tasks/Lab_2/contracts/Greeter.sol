pragma solidity ^0.5.11;

contract Greeter
{

    string private greeting_text = "hello, World!"; //private meaning only visible here ; just like java

    //here is the difference between memory and storage.
    /*
    Storage variables are state level variables meaning they persist the state. they persist across contract calls.
    Memory varibles are temporary RAM variables.
    When you get a value of a storage variable like greeeing_text in a memory variable, a copy is made.
    If you want to do some temporary manipulation, copy the data in memory and then do it.
    If you want the data to persist, make changes to the storage referenced variable.
    Really important link: https://medium.com/coinmonks/ethereum-solidity-memory-vs-storage-which-to-use-in-local-functions-72b593c3703a
    */

    //constructor
    constructor() public{
        //this does nothing.
    }

    //greeter
    function greet() public view returns(string memory){
        return greeting_text;
    }
    //this can modify the state variable.
    function change_greeting(string memory _this_greeting) public returns(string memory){
        greeting_text = _this_greeting;
        return greeting_text;
    }

    //here is the difference between pure and constant;view
    /*
    constant or view indicates that the function would not be able to change the state of the contract. So network verification is not necessary.
    pure indicates that the function would not even read the state of the contract.
    state of the contract means the storage variables of the contract.
    */

}
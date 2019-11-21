pragma solidity ^0.5.11;

contract xor
{

    //calculate xor value
    function calculate_xor_value(uint x, uint y) public pure returns(uint)
    {
        if(x==y)
            return 0;
        else return 1;
    }
    //input a binary string and see its XOR
    function calculate_xor_value_string(string memory _binary_string) public pure returns(uint)
    {
        //XOR would be 0 if there are even number of 1's else XOR is 1
        uint number_of_1s = 0;
        bytes memory _binary_bytes = bytes(_binary_string);
        for(uint i = 0;i < _binary_bytes.length;i++)
        {
            if(_binary_bytes[i]=='1')
                number_of_1s++;
        }
        if(number_of_1s%2==0)
            return 0;
        else
            return 1;
    }

}
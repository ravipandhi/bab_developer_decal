pragma solidity ^0.5.11;

contract string_fib_greet_functions
{

    string greeting_text = "hello, World!";

    //greeter
    function greet() public view returns(string memory){
        return greeting_text;
    }

    // returns an array of first n fibonacci numbers
    function calculate_first_n_fibonacci(uint256 n) public pure returns(uint256[] memory)
    {
        uint256[] memory fib_numbers = new uint256[](n);
        if(n==1)
        {
            fib_numbers[0] = 0;
        }
        else if(n==2)
        {
            fib_numbers[0] = 0;
            fib_numbers[1] = 1;
        }
        else if(n>2)
        {
            fib_numbers[0] = 0;
            fib_numbers[1] = 1;
            uint i = 2;
            while(i<n)
            {
                fib_numbers[i] = fib_numbers[i-1] + fib_numbers[i-2];
                i++;
            }
        }
        return fib_numbers;
    }


    function calculate_xor_value(uint x, uint y) public pure returns(uint)
    {
        if(x==y)
            return 0;
        else return 1;
    }

    function concatenate_string(string memory source, string memory destination) public pure returns(string memory)
    {
        bytes memory merged_string = new bytes(bytes(source).length+bytes(destination).length);
        //use bytes when you do not know the length of the data
        for(uint i = 0;i<bytes(source).length;i++)
        {
            merged_string[i] = bytes(source)[i];
        }

        uint j = bytes(source).length;

        for(uint i = 0;i<bytes(destination).length;i++)
        {
            merged_string[j++] = bytes(destination)[i];
        }

        return string(merged_string);
    }

}



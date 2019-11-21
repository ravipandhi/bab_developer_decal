pragma solidity ^0.5.11;

contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
        if(n==1)
            return 0;
        else if(n==2)
            return 1;
        else if(n>2)
            return fibRecur(n-1) + fibRecur(n-2);
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public pure returns (uint) {
        if(n==1)
            return 0;
        else if(n==2)
            return 1;
        else if(n>2)
        {
            uint prev = 0;
            uint latest = 1;
            uint sum = 0;
            uint i = 2;
            while(i<n)
            {
                sum = prev + latest;
                prev = latest;
                latest = sum;
                i++;
            }
            return latest;
        }
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
}
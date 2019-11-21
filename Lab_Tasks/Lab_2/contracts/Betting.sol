pragma solidity ^0.5.11;

//import "../contracts/strings.sol";

contract Betting {
    function concatWithoutImport(string memory source, string memory destination) public pure returns (string memory)
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

    /* BONUS */
    function concatWithImport(string memory s, string memory t) public pure returns (string memory) {
        //return s.toSlice().concat(t.toSlice());
    }
}
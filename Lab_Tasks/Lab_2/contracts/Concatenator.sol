pragma solidity ^0.5.11;

//import "../contracts/strings.sol" as stringfunc;

//import { strings } from "../contracts/strings.sol";

contract Concatenator {
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
        // strings.slice memory a = strings.toSlice(s);
        // strings.slice memory b = strings.toSlice(t);
        // string memory c = strings.concat(a,b);
        // return c;
        //return s.stringfunc.toSlice().concat(t.toSlice());
        return "as";
    }
}
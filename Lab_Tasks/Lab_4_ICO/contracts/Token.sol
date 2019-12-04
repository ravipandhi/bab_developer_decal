pragma solidity 0.5.11;

import './ERC20Interface.sol';
import './SafeMath.sol';


/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE
	using SafeMath for uint;
    
    mapping (address => uint) private balances;
    
    address public owner;
    
    mapping (address => mapping (address => uint256)) private allowed;
    
    constructor(uint _supply) public
    {
        totalSupply = _supply;
        owner = msg.sender;
    }
    
    function getTotalSupply() public view returns (uint) 
    { 
        return totalSupply;
    }
    
    function mint(uint _quantity) public returns(uint)
    {
        require(owner != address(0));
        require(_quantity != 0);
        totalSupply = totalSupply.add(_quantity); 
        balances[owner] = balances[owner].add(_quantity);
        emit Transfer(address(0),owner,_quantity);
    }
    
    function burn(address _buyer, uint _quantity) public returns(uint)
    {
        //check for integer overflow
        require(_buyer != address(0));
        require(_quantity != 0);
        require(_quantity <= balances[_buyer]);
        
        totalSupply = totalSupply.sub(_quantity); 
        balances[_buyer] = balances[_buyer].sub(_quantity);
        emit Burn(_buyer,_quantity);
    }

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint balance)
    {
        return balances[_owner];
    }
    
    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success)
    {
        require(_to != address(0));
        require(balances[msg.sender] >= _value);
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        
        emit Transfer(msg.sender,_to,_value);
        return true;
    }
    
    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    {
        require(_from != address(0));
        require(_to != address(0));
        
        require(balances[_from] >= _value);
        require(allowed[_from][msg.sender] >= _value);
        
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        
    
        emit Transfer(_from,_to,_value);
        return true;
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success)
    {
        require(_spender != address(0));
        require(_value != 0);
        require(balances[_spender] >= _value);
        
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
        emit Approval(msg.sender,_spender,_value);
        return true;
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }



    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _owner, uint256 _value);
}
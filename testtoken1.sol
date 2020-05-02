pragma solidity ^0.5.16;

contract testtoken1 {

	string public name = "testtoken1";
	string public symbol = "TTO";
	string public standard = "testtoken1 v 1.0";

	uint256 public totalSupply;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	event Approval(address indexed _owner, address indexed _spender, uint256 _value);

	mapping(address => uint256) public balanceOf;

	//the mapping below is allowing multiple contract addresses to be delegates for Delegated Transfer
	mapping(address => mapping(address => uint256)) public allowance;

	constructor(uint256 _initialsupply) public {

		balanceOf[msg.sender] = _initialsupply;
		totalSupply = _initialsupply;
	}

	function transfer(address _to, uint256 _no_of_tokens) public returns (bool success)
	{
		require(balanceOf[msg.sender] >= _no_of_tokens);
		balanceOf[msg.sender] -= _no_of_tokens;
		balanceOf[_to] += _no_of_tokens;

		emit Transfer(msg.sender, _to, _no_of_tokens);

		return true;
	}

	//Delegated Transfer

	function approve(address _spender, uint256 _value) public returns (bool success) {

		allowance[msg.sender][_spender] = _value;

		emit Approval(msg.sender, _spender, _value);

		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

		require(_value <= balanceOf[_from]);
		require(_value <= allowance[_from][msg.sender]);

		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;

		//Update the allowance
		allowance[_from][msg.sender] -= _value;

		emit Transfer(_from, _to, _value);
		return true;

		//Requirements of this functions are
		//Require _from has enough _no_of_tokens
		//Require allowance is big enough
		//change the balance 
		//Update the allowance
		//Transfer event emit
		//return a boolean
	}
}







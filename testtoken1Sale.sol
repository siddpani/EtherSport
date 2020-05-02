pragma solidity ^0.5.16;

import "./testtoken1.sol";

contract testtoken1Sale  {

	address admin; //does not have a public visibility because we do not want reveal the address
	testtoken1 public testtokenContract;
	uint256 public tokenPrice;
	uint256 public tokenSold;

	event Sell(address _buyer, uint256 _amount);

	//we need to pass the address to the contructor from migrations file
	constructor(testtoken1 _tokenContract, uint256 _tokenPrice) public {

		//Assign an admin
		//Token contract
		//Token Price
		admin = msg.sender;
		testtokenContract = _tokenContract;
		tokenPrice = _tokenPrice;

	}

	//Safe Multiply function from DSMath
	function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

	function buyToken(uint256 _no_of_tokens) public payable {  
	//payable because we have to exchange ether in return of the token


		//Require that the value people are paying is equal to the value of _no_of_tokens
		require(msg.value == mul(_no_of_tokens, tokenPrice));

		//Require that a transfer is successful
		require(testtokenContract.transfer(msg.sender, _no_of_tokens));

		//Require that the contract has enough _no_of_tokens
		require(testtokenContract.balanceOf(this) >= _no_of_tokens);

		//Keep track of the no of tokens sold
		tokenSold += _no_of_tokens;

		//Trigger a sell event
		emit Sell(msg.sender, _no_of_tokens);

	}

	//End the token Sale by admin
	function endSale() public {

		//Require an admin
		require(msg.sender == admin);

		//Transfer remaining dapp tokens to admin
		require(testtokenContract.transfer(admin, testtokenContract.balanceOf(this)));

		//you may or may not Destroy contract
		//selfdestruct(admin);
	}
}

















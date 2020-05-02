pragma solidity ^0.5.16;

import "./auction.sol";

contract organisation {

	address owner; 

	uint256 yearly_fund_player;

	auction public O_auction;

	//sets the owner of the contract
	constructor(auction _auctionContract) public {

		owner = msg.sender;

		O_auction = _auctionContract;
	}

	//sets the owner of the contract
	modifier centralAuthority() {

		require(msg.sender == owner);

		_;
	}

	//maps the addresses such that transfer request has been acknowledged and fund already transferred 
	mapping(address => bool) public Transferred;

	//maps the address of the player to Unique identification number(UIN) and if the player is already registered
	mapping(address => mapping(uint => bool)) public individual;

	//maps the address of a company to the buisness identification number(BIN) and if the company is already registered
	mapping(address => mapping(uint => bool)) public company;

	event Request_accept(address _requestor, uint256 _UIN);

	event Funds_transfered(address _requestor, uint256 _UIN);

	event ether_received(address _from, uint256 _value);

	event bid_request(address _requestor, uint256 _BIN);

	function accept_ether() public payable {

		emit ether_received(msg.sender, msg.value);
	}

	function fund_value_setter(uint256 _val) public {

		require(msg.sender == owner);

		yearly_fund_player = _val;
	}

	//Register the player
	function RegisterPlayer(uint256 _UIN) public returns (bool) {

		individual[msg.sender][_UIN] = true;

		return true;
	}  

	//Register the company
	function RegisterCompany(uint256 _BIN) public returns (bool) {

		company[msg.sender][_BIN] = true;

		return true;
	}

	//Request made by the player to get funds
	function request_for_funds(uint256 _UIN) public {

		require(individual[msg.sender][_UIN] == true);		

		emit Request_accept(msg.sender, _UIN);

		transfer(msg.sender, _UIN);
	}

	//transfer of funds from the contract to the player
	function transfer(address _to, uint256 _UIN) private returns (bool) {

		require(Transferred[_to] == false);

		require(yearly_fund_player <= address(this).balance);

		Transferred[_to] = true;

		_to.transfer(yearly_fund_player);

		emit Funds_transfered(_to, _UIN);

		return true;
	}

	function pass_value(uint256 _val) public {

		require(msg.sender == owner);

		O_auction.set_value_of_project(_val);
	}

	//bid by a company for infrastucture development
	//the lowest bid by a company will be the winner
	//it is a blind auction
	function bid_by_company(uint256 _BIN) public returns (bool) {

		require(company[msg.sender][_BIN] == true);

		emit bid_request(msg.sender, _BIN);

		O_auction.register(now, msg.sender);

		return true;
	}
	
}




















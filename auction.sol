pragma solidity ^0.5.16;

contract auction {

	address public bidder;
	uint256 public auctionEnd;

	//current winner of the auction
	address public lowestBidder;
	uint256 public lowestBid;

	//minimum cost projection of the project
	uint256 public value;

	//allowed withdrawals of the previous bid 
	//this is the minimum amount which the bidder is needed to submit
	//amount will be returned together with the infrastructure development fund
	//given by the central authority
	mapping(address => uint) pendingReturn;

	//auction ende or not
	bool ended;

	event lowestBidIncreased(address _bidder, uint256 _amount);
	event AuctionEnded(address _winner, uint256 _amount);

	function set_value_of_project(uint256 _value) public {
		value = _value;
	}

	function register(uint256 _biddingTime, address _bidder) public {

		bidder = _bidder;
		auctionEnd = now + _biddingTime;
	}

	function bid() public payable {

		//check if auction already ended
		require(now <= auctionEnd);

		require(msg.value > value);

		//check the value send with the bid to the highest bid
		require(msg.value < lowestBid);

		if(lowestBid != 0) {

			pendingReturn[lowestBidder] += lowestBid;
		}

		lowestBidder = msg.sender;
		lowestBid = msg.value;
		emit lowestBidIncreased(msg.sender, msg.value);
	}

	//withdraw a bid
	function withdraw() public returns (bool) {

		uint256 amount = pendingReturn[msg.sender];

		if (amount > 0) {

			pendingReturn[msg.sender] = 0;

			if(!msg.sender.send(amount)) {

				pendingReturn[msg.sender] += amount;
				return false;
			}

		}

		return true;
	}

	//End of the auction
	function auctionEnd() public {

		require(now >= auctionEnd);
		require(!ended);

		ended = true;
		emit AuctionEnded(lowestBidder, lowestBid);

		bidder.transfer(lowestBid);
	}
}

























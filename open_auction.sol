pragma solidity ^0.5.16;

contract open_auction {

	address public bidder;
	uint256 public auctionEnd;

	//current winner of the auction
	address public highestBidder;
	uint256 public highestBid;

	//allowed withdrawals of the previous bid 
	//this is the minimum amount which the bidder is needed to submit
	//amount will be returned together with the infrastructure development fund
	//given by the central authority
	mapping(address => uint) pendingReturn;

	//auction ende or not
	bool ended;

	event HighestBidIncreased(address _bidder, uint256 _amount);
	event AuctionEnded(address _winner, uint256 _amount);

	constructor(uint256 _biddingTime, address _bidder) public {

		bidder = _bidder;
		auctionEnd = now + _biddingTime;
	}

	function bid() public payable {

		//check if auction already ended
		require(now <= auctionEnd);

		//check the value send with the bid to the highest bid
		require(msg.value > highestBid);

		if(highestBid != 0) {

			pendingReturn[highestBidder] += highestBid;
		}

		highestBidder = msg.sender;
		highestBid = msg.value;
		emit HighestBidIncreased(msg.sender, msg.value);
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
		emit AuctionEnded(highestBidder, highestBid);

		bidder.transfer(highestBid);
	}
}

























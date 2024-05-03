// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Smart Contract
contract Crowdfunding {
	// Object: Crowdfunding Campaign
	struct Campaign{
		//Types that this campaign object will have
		address owner;
		string title; 
		string description;
		uint256 target; // The target amount we want to achieve for campaign
		uint256 deadline;
		uint256 amountCollected;
		string image; // image will be the URL of the image
		address[] donators; //an array of the addressess of the donators
		uint256[] donations; //an array to keep track of the actual number amount of our donations
	}

	mapping(uint256 => Campaign) public campaigns;

	uint256 public numberOfCampaigns = 0; // Global Variable: Keep track of the number of campaigns we have created to give them ID's


	//////////////////////Functionality of the Smart Contract; Smart Contract logic//////////////////////

	// A function to create a crowdfunding campaign
	// @param _owner = address of the owner of the campaign
	// @param _title = campaign title
	// @param _description = campaign description
	// @param _target = target value for campaign
	// @param _deadline = deadline to reach the campaign's target value
	// @param _image = default image of the campaign
	function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, 
	uint256 _deadline, string memory _image) public returns (uint256) {
		// Create a new campaign
		Campaign storage campaign = campaigns[numberOfCampaigns];

		// [Require] Statement in solidity is like a check; Is everything okay?
		// Check to see if deadline date is in the future
		require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

		campaign.owner = _owner;
        campaign.title = _title;
		campaign.description = _description;
		campaign.target = _target;
		campaign.deadline = _deadline;
		campaign.amountCollected = 0;
		campaign.image = _image;

		numberOfCampaigns++; 

		return numberOfCampaigns - 1; // Returns the index of the most newly created campaign

	} //END createCampaign()

	// A function to donate to a campaign
	// @keyword payable = A function for sending cryptocurrency
	// @param uint256 _id = ID of the campaign you want to donate to
	function donateToCampaign(uint256 _id) public payable {
		uint256 amount = msg.value; // Sending amount value from our front-end

		Campaign storage campaign = campaigns[_id]; // Get the campaign that the user wants to donate to
		campaign.donators.push(msg.sender); // Push the address of the user that donated
		campaign.donations.push(amount); // Push the amount that the user donated

		// Payble transaction to the owner of the campaign
		// @variable sent = variable to let us know that the transaction has been sent
		(bool sent, ) = payable(campaign.owner).call{value: amount}(""); 

		
		if(sent) {
			campaign.amountCollected = campaign.amountCollected + amount; 
		}
	}//END donateToCampaign()

	// A function to get a list of all the people that donated to a SPECIFIC campaign
	// @keyword view = The function will only return data to view, not modify
	// @param uint256 _id = ID of the campaign you want to get the donators from
	// @returns_param memory = Return an array of addresses already stored in memory; donators
	// @returns_param memory = Return an array of numbers already stored in memory; donations
	function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
	}//END getDonators()

	// A function to get  a list of all campaigns
	// @keyword view = A function that only reads, but doesn't alter the staate variables (view function)
	// @returns_param memory = Return an array of campains from memory
	function getCampaigns() public view returns (Campaign[] memory) {
        // @variable allCampaigns = An empty array with amount of elements 'numberOfCampaigns'
		Campaign[] memory allCampaigns = new Campaign[] (numberOfCampaigns); 

		// Populating allCampaigns array with campaigns
        for(uint i = 0; i < numberOfCampaigns; i++) {
			Campaign storage item = campaigns[i];

			allCampaigns[i] = item;
		}

		return allCampaigns; 
	}//END getCampaigns()

}
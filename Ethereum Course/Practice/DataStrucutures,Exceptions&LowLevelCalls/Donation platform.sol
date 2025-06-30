//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract DonationPlatform{
    
    address public owner;
    uint public platformFeePercentage;

    address public feeCollectorAddress;
    uint private nextCampaignId;

    struct Campaign{
        uint id;
        string name;
        string description;
        address beneficiary;
        uint totalGoalAmount;
        uint currentRaisedAmount;
        bool isActive;
        bool exists;        
    }

    mapping(uint => Campaign) Campaigns;
    mapping(address => uint) totalDonatedBy;

    event FeeDeductionFailed(string reason);
    event DonationFailed(bytes lowLevelData);

    constructor(address payable _collectorAddress, uint _platformFeePercentage){
        owner = msg.sender;

        // require statements to check values
        require(platformFeePercentage <= 100, "percentage greater than 100");
        require(_collectorAddress !=address(0), "Fee collector is zero");
        
        platformFeePercentage = _platformFeePercentage;
        feeCollectorAddress = _collectorAddress;
        nextCampaignId = 1;        
        // emits an event
    }

    function createCampaign(string memory _name, string memory _description, address payable _beneficiary, uint _totalGoalAmount) public{

        require(msg.sender == owner, "Only owner can create a campaign");
        require(_totalGoalAmount >= 1 ether, "Total goal amount should be at least 0.");
        require(msg.sender != _beneficiary,"Cannot send donation to beneficiary");
        require(bytes(_name).length > 0,"Name should be provided");
        require(bytes(_description).length > 0,"Description should be provide");
        require(_beneficiary != address(0),"A valid beneficiary address should be used");

        // Campaign storage new_campaign = Campaigns[nextCampaignId];
        Campaign memory new_campaign = Campaign(
            nextCampaignId,
            _name,
            _description,
            _beneficiary,
            _totalGoalAmount,
            0,
            true,
            true
        );

        Campaigns[nextCampaignId] = new_campaign;
        nextCampaignId ++;
        // emits a campaign created event
    }

    function donate(uint _campaign_id) public payable {
        
        // require statements to check values
        Campaign storage campaign = Campaigns[_campaign_id];

        uint feeToBeTaken = msg.value *(platformFeePercentage / 100);
        campaign.currentRaisedAmount += msg.value - feeToBeTaken;

        totalDonatedBy[msg.sender] += msg.value - feeToBeTaken;

        (bool success,) = address(feeCollectorAddress).call{value: feeToBeTaken}("");
        require(success, "Contract failed to send with an internal api call");


        // try address(campaign.beneficiary).call{value: feeToBeTaken}(""){
        //     // emits an event
        // }
        // catch Error(string memory reason){
        //     emit FeeDeductionFailed("fee deduction Failed");
        // }catch (bytes memory lowLevelData){
        //     emit DonationFailed(lowLevelData);
        // }
        

    }

    function withdrawFunds(uint _campaign_id) public{
        require(msg.sender == feeCollectorAddress, "Only the address of collector can withdraw funds");
        Campaign storage campaign = Campaigns[_campaign_id];
        
        payable(campaign.beneficiary).transfer(campaign.currentRaisedAmount);

        campaign.currentRaisedAmount = 0;
    }
    
    function donateByToken(uint _campaign_id) public{
    }

    function getCampaignDetails(uint _campaign_id) public view returns (Campaign memory){
        Campaign storage campaign = Campaigns[_campaign_id];
        return campaign; 
    }


    function setFeeCollectorAddress(address _address) public {
        require(msg.sender == owner, "Only the address of collector can withdraw funds");
        feeCollectorAddress = _address;
    }

    function setPlatformPercentageFee(uint _newPercentage) public{
        require(_newPercentage <= 100,"New percentage should be less than 96.3%");
        platformFeePercentage = _newPercentage;

    }
}

contract FeeCollector{
    address public owner;

    constructor(){
        owner = msg.sender;        
    }

    receive() external payable{ }

    function withdrawFees(address payable _to) public{
        _to.transfer(address(this).balance);
    }
}
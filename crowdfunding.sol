// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    uint256 private immutable priceInUSD;
    struct Campaign{
        address owner;
        uint256 goal;
        uint256 deadline;
        uint256 id;
        uint256 amountCollected;
        address[] donators;
        uint256 numberOfdonators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaignId;

    uint256 public numberOfCampaigns = 0;
    address public tokenAddress;

    constructor(string memory _name, string memory _symbol, uint256 _priceInUSD,address _tokenAddress)
        ERC20(_name, _symbol)
        Ownable(msg.sender)
    {
        priceInUSD = _priceInUSD;
        tokenAddress = _tokenAddress;
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }

    function getTokenPriceInUSD() external view returns (uint256) {
        return priceInUSD;
    }

    function createCampaign(address _owner,uint256 _goal, uint256 _duration) external {
        Campaign storage campaign = campaignId[numberOfCampaigns];
        campaign.owner = _owner;
        campaign.goal = _goal;
        campaign.deadline = block.timestamp + _duration;
        campaign.id = numberOfCampaigns + 1;
        campaign.amountCollected = 0;
        campaign.numberOfdonators = 0;
    }

    function contribute(uint256 _id, uint256 _amount, address donatorAddress) external payable {
        require(_amount > 0, "Contribution amount must be greater than zero");
        require(_id-1 <= numberOfCampaigns ,"Campaign with the given ID dosent exist.");
        Campaign storage campaign = campaignId[_id-1];
        require(donatorAddress != campaign.owner,"Owner of the campaign can't donate.");
        require(campaign.deadline > block.timestamp,"Campaig had ended");
        bool sent = ERC20(tokenAddress).transferFrom(donatorAddress, campaign.owner, _amount);
        if(sent){
            campaign.donators.push(donatorAddress);
            campaign.donations.push(_amount);
            campaign.numberOfdonators++;
            campaign.amountCollected += _amount;
        }
    }

    function cancelContribution(uint256 _id, address donatorAddress) external {
        require(_id-1 <= numberOfCampaigns,"Campaign with the given ID dosent exist.");
        Campaign storage campaign = campaignId[_id-1];
        bool contributed = false;
        uint i =0;
        for(i=0;i<campaign.numberOfdonators;i++){
            if(campaign.donators[i] == donatorAddress){
                contributed = true;
                break;
            }
        }
        require(contributed==true,"Donator didnt donate.");
        uint256 amount = campaign.donations[i];
        bool sent = ERC20(tokenAddress).transfer(campaign.donators[i], amount);
        require(sent==true,"Transaction failed.");
        campaign.amountCollected -= amount;
        campaign.donations[i] = 0;
    }

    function withdrawFunds(uint256 _id, address withdrawAddress) external onlyOwner {
        Campaign storage campaign = campaignId[_id-1];
        require(block.timestamp >= campaign.deadline, "Campaign deadline has not passed");
        require(campaign.amountCollected >= campaign.goal, "Campaign goal not met");
        uint256 amount = campaign.amountCollected;
        campaign.amountCollected = 0;
        ERC20(tokenAddress).transfer(withdrawAddress, amount);
    }

    function refund(uint256 _id, address donatorAddress) external  {
        Campaign storage campaign = campaignId[_id-1];
        require(block.timestamp >= campaign.deadline, "Campaign deadline has not passed");
        require(campaign.amountCollected < campaign.goal, "Campaign goal met");
        bool contributed = false;
        uint i =0;
        for(i=0;i<campaign.numberOfdonators;i++){
            if(campaign.donators[i] == donatorAddress){
                contributed = true;
                break;
            }
        }
        require(contributed==true,"Donator didnt donate.");
        uint256 amount = campaign.donations[i];
        bool sent = ERC20(tokenAddress).transfer(campaign.donators[i], amount);
        require(sent==true,"Transaction failed.");
        campaign.amountCollected -= amount;
        campaign.donations[i] = 0;
    }
}
pragma solidity 0.5.4;

import './AugurUniverse.sol';

contract FundTheDev {
    AugurUniverse public universe;

    enum CampaignStatus { Funded, Accepted }

    // Defines a new type with two fields.
    struct Funder {
        address addr;
        uint amount;
        CampaignStatus status;
    }

    uint numCampaigns;
    string[] fundedIssues;
    mapping (string => Funder) campaigns;

    constructor(AugurUniverse _universe) public {
      universe = _universe;
    }

    function newCampaign(string issue) public payable returns (uint campaignID) {
        campaignID = numCampaigns++; // campaignID is return variable
        // Creates new struct and saves in storage. We leave out the mapping type.
        fundedIssues[campaignID] = issue;
        campaigns[issue] = Funder(msg.sender, msg.value, CampaignStatus.Funded);
    }

    function numberOfCampaigns() public view returns (uint) {
        return numCampaigns;
    }

    // returns 0 if there's no associated campaign, 1 if the campaign has been funded, and 2 if it's been accepted.
    function campaignStatus(uint campaignId) public view returns (uint) {
        if (!campaigns[campaignId]) {
          return 0;
        }
        Campaign storage c = campaigns[campaignId];
        if (c.status == CampaignStatus.Funded) {
          return 1;
        }
        if (c.status == CampaignStatus.Accepted) {
          return 2;
        }
    }

    function campaignExists(string issue) returns (bool) {
        return campaigns[issue];
    }

    function acceptFunding(string issue) public payable returns (uint result) {
        require(campaignExists(issue));
        Campaign storage c = campaigns[issue];
        // create augur market
        require(universe.createYesNoMarket(now + 1 weeks, 0, 1, msg.sender, [], "", ""));
        c.status = CampaignStatus.Accepted;
        campaigns[issue] = c;
    }

    function contribute(uint campaignID) public payable {
        Campaign storage c = campaigns[campaignID];
        // Creates a new temporary memory struct, initialised with the given values
        // and copies it over to storage.
        // Note that you can also use Funder(msg.sender, msg.value) to initialise.
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }
}

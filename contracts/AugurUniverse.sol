pragma solidity 0.5.4;

contract AugurUniverse {
  function createYesNoMarket(uint256 _endTime, uint256 _feePerCashInAttoCash, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, bytes32 _topic, string memory _description, string memory _extraInfo) public returns (bool _newMarket);
}

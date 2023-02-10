// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Freelance.sol";

contract AgreementContract {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Agreement[] public agreements;
    Counters.Counter private _agreementIds;

    mapping(address => Agreement[]) public agreementMap;
    mapping(address => uint256) public agreementImap;

    event CreateAgreement(
        address indexed buyer,
        address indexed seller,
        uint256 price,
        address agreementAddress,
        string  title,
        string  description
    );

    function  agreementCreate(
        address payable _client,
        address payable _freelancer,
        uint256 _price,
        uint256 _statePercent,
        uint256 _freelancerPercent,
        string memory _title,
        string memory _description
    ) public {
        Agreement agreement = new Agreement(
            _client,
            _freelancer,
            _price,
            _statePercent,
            _freelancerPercent,
            _title,
            _description
        );
        agreements.push(agreement);
        uint256 currentIndex = _agreementIds.current();
        address agreementAdress = agreement.agreementAddress();
        agreementImap[agreementAdress] = currentIndex;
        _agreementIds.increment();
        agreementMap[_client].push(agreement);
        agreementMap[_freelancer].push(agreement);
        emit CreateAgreement(_client, _freelancer, _price, agreementAdress,_title, _description);
    }

    function getAgreementByParties(address _party)
        public
        view
        returns (Agreement[] memory)
    {
        return agreementMap[_party];
    }

    function getAgreementByIndex(uint256 _index)
        public
        view
        returns (Agreement)
    {
        return agreements[_index];
    }

    function getAgreementByAddress(address _addr)
        public
        view
        returns (Agreement)
    {
        uint256 idx = agreementImap[_addr];
        return agreements[idx];
    }

    function getAllAgreements() public view returns (Agreement[] memory) {
        return agreements;
    }
}
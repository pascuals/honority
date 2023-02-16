// Version de solidity del Smart Contract
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

// Smart Contract Information
// Name: PaperReview

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./IPaperReview.sol";

// Smart Contract - PaperReview
contract Paper is Ownable, Pausable {
    address reviewContract;

    // Paper data
    struct PaperData {
        // Unique paper id
        string paperId;
        // Publishing time
        uint published;
        // Ipfs cid
        string ipfsCid;
        // Reviewers array
        address[] reviewers;
        // Ipfs hashes
        bytes[] ipfsReviewCids;
    }

    // Relation of review processes by address and paperId hash
    // address -> publisher address
    // string -> paper id
    // PaperData -> paper data
    mapping(address => mapping(string => PaperData)) public papers;

    function getReviewData(string memory paperId, address publisher) public view returns (PaperStruts.ReviewData[] memory) {
        return IPaperReview(reviewContract).getReviews(paperId, publisher, papers[publisher][paperId].reviewers);
    }

    // PRIVATE FUNCTIONS
    function hash(string memory text) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(text));
    }

    function secureHash(string memory text) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(keccak256(abi.encodePacked(text))));
    }
}

// Version de solidity del Smart Contract
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

// Smart Contract Information
// Name: PaperReview

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// Smart Contract - PaperReview
contract PaperReview is Ownable, Pausable {

    // Single review data
    struct ReviewData {
        // Used as integrity check
        bytes32 reviewerHash;
        // Creation time
        uint created;
        // Updated time
        uint updated;
        // Ipfs file id hash
        bytes32 ipfsHash;
        // True when this is a positive review
        bool isPositive;
    }

    // Relation of review processes by address and paperId hash
    // address -> paper owner hash
    // bytes32 -> paperId hash
    // ReviewData -> list of reviews
    mapping(bytes32 => mapping(bytes32 => mapping(bytes32 => ReviewData[]))) public paperReviews;


    // PRIVATE FUNCTIONS
    function hash(string memory text) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(text));
    }

    function secureHash(string memory text) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(keccak256(abi.encodePacked(text))));
    }

    // Look for a positive review from a reviewer over a paper
    function checkIsNotApproved(string memory publisherHash, string memory paperHash, string memory reviewerHash, string memory errorMessage) private view {
        ReviewData[] memory _reviews = paperReviews[secureHash(publisherHash)][secureHash(paperHash)][secureHash(reviewerHash)];
        for (uint i = 0; i < _reviews.length; i++) {
            require(!_reviews[i].isPositive, errorMessage);
        }
    }


    // Modifiers

    modifier isNotApproved(string memory publisherHash, string memory paperHash, string memory reviewerHash, string memory errorMessage) {
        checkIsNotApproved(publisherHash, paperHash, reviewerHash, 'Paper has already been approved');
        _;
    }
}

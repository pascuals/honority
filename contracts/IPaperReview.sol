// Version de solidity del Smart Contract
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

// Smart Contract Information
// Name: IPaperReview

library PaperStruts {
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
}

interface IPaperReview {
    function getReviews(string memory paperId, address publisher, address[] memory reviewers) external view returns (PaperStruts.ReviewData[] memory);
}

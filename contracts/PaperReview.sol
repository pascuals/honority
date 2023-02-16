// Version de solidity del Smart Contract
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

// Smart Contract Information
// Name: PaperReview

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./IPaperReview.sol";

// Smart Contract - PaperReview
contract PaperReview is Ownable, Pausable, IPaperReview {
    // Enum representing shipping status
    enum Status {
        Submitted,
        PendingAllocation,
        PendingChanges,
        Reviewed,
        Disputed,
        PendingReview,
        FinalReview,
        Published,
        Rejected
    }

    // Single review data
    struct PaperData {
        // Publisher hash
        bytes32 publisherHash;
        // Creation time
        uint started;
        // Status
        Status status;
        // Ipfs file id hash
        uint ipfsHash;
    }

    // Relation of review processes by address and paperId hash
    // bytes32 -> paper hash
    // bytes32 -> reviewer hash
    // ReviewData -> list of reviews
    mapping(bytes32 => mapping(bytes32 => PaperStruts.ReviewData[])) public paperReviews;

    // bytes32 -> paper hash
    // PaperData -> paper data
    mapping(bytes32 => PaperData) public paperDatas;


    function publishReview(string calldata paperHash, string calldata reviewerHash) public view isNotApproved(paperHash, reviewerHash) isNotPublished(paperHash) {

    }

    function getReviews(string calldata paperId, address publisher, address[] calldata reviewers) external view isPublished(paperId) returns (PaperStruts.ReviewData[] memory) {
        // Hash the publisher
        bytes32 _publisherHash = secureHashAddress(paperId, publisher);
        // Hash the paperId
        bytes32 _paperHash = secureHash(string(paperId));

        require(_publisherHash == paperDatas[_paperHash].publisherHash, 'Incorrect publisher');

        mapping(bytes32 => PaperStruts.ReviewData[]) storage _reviewsMapping = paperReviews[_paperHash];
        PaperStruts.ReviewData[] memory _reviews;

        uint index = 0;

        for (uint i = 0; i < reviewers.length; i++) {
            // Hash the reviewer
            bytes32 reviewerHash = secureHashAddress(paperId, reviewers[i]);
            // Find the reviews
            PaperStruts.ReviewData[] memory _reviewsReviewer = _reviewsMapping[reviewerHash];

            // Concat the reviews
            for (uint j = 0; j < _reviews.length; j++) {
                _reviews[index] = _reviewsReviewer[i];
                index++;
            }
        }

        return _reviews;
    }

    // PRIVATE FUNCTIONS
    // Look for a positive review from a reviewer over a paper
    function checkIsNotApproved(string memory paperHash, string memory reviewerHash, string memory errorMessage) private view {
        PaperStruts.ReviewData[] memory _reviews = paperReviews[bytes32(abi.encodePacked(paperHash))][bytes32(abi.encodePacked(reviewerHash))];
        for (uint i = 0; i < _reviews.length; i++) {
            require(!_reviews[i].isPositive, string(abi.encodePacked(paperHash, errorMessage, reviewerHash)));
        }
    }

    function hash(string memory text) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(text));
    }

    function secureHash(string memory text) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(keccak256(abi.encodePacked(text))));
    }

    function secureHashAddress(string memory text, address _address) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(keccak256(abi.encodePacked(text, _address))));
    }

    // Modifiers

    modifier isNotApproved(string memory paperHash, string memory reviewerHash) {
        checkIsNotApproved(paperHash, reviewerHash, ' paper has already been approved by ');
        _;
    }

    modifier isNotPublished(string memory paperHash) {
        require(paperDatas[bytes32(abi.encodePacked(paperHash))].status != Status.Published, 'Paper has already been published');
        _;
    }

    modifier isPublished(string memory paperId) {
        require(paperDatas[secureHash(paperId)].status == Status.Published, 'Paper has not been published');
        _;
    }
}

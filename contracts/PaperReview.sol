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
        PendingChanges,
        PendingReview,
        FinalReview,
        Published,
        Rejected
    }

    // Single review data
    struct PaperReviewData {
        // Publisher hash
        bytes32 publisherHash;
        // Creation time
        uint created;
        // Status
        Status status;
        // Ipfs file id hash
        bytes32 ipfsHash;
    }

    // Relation of review processes by address and paperId hash
    // bytes32 -> paper hash
    // bytes32 -> reviewer hash
    // ReviewData -> list of reviews
    mapping(bytes32 => mapping(bytes32 => PaperStruts.ReviewData[])) paperReviews;

    // bytes32 -> paper hash
    // PaperReviewData -> paper data
    mapping(bytes32 => PaperReviewData) paperReviewDatas;

    // WRITE METHODS

    function submitPaper(string calldata paperHash, string calldata publisherHash, string calldata ipfsHash) public {
        /// TODO checks
        // Initialize paper data
        paperReviewDatas[bytes32(abi.encodePacked(paperHash))] = PaperReviewData(bytes32(abi.encodePacked(publisherHash)), block.timestamp, Status.Submitted, bytes32(abi.encodePacked(ipfsHash)));
        /// TODO emit event
    }

    function publishReview(string calldata paperHash, string calldata reviewerHash, string calldata ipfsHash, bool isPositive) public isNotApproved(paperHash, reviewerHash) isNotPublished(paperHash) {
        /// TODO checks
        PaperStruts.ReviewData memory _reviewData = PaperStruts.ReviewData(bytes32(abi.encodePacked(reviewerHash)), block.timestamp, bytes32(abi.encodePacked(ipfsHash)), isPositive);
        paperReviews[bytes32(abi.encodePacked(paperHash))][bytes32(abi.encodePacked(reviewerHash))].push(_reviewData);
        /// TODO emit event
    }

    // READ METHODS

    function getReviews(string calldata paperId, address publisher, address[] calldata reviewers) external view isPublished(paperId) returns (PaperStruts.ReviewData[] memory) {
        // Hash the publisher
        bytes32 _publisherHash = secureHashAddress(paperId, publisher);
        // Hash the paperId
        bytes32 _paperHash = secureHash(string(paperId));

        // Checks
        require(_publisherHash == paperReviewDatas[_paperHash].publisherHash, 'Incorrect publisher');

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
                // Note: Dynamic 'memory' array can online be accessed by index, (no push allowed)
                // 'storage' array
                _reviews[index] = _reviewsReviewer[i];
                index++;
            }
        }

        return _reviews;
    }

    // PRIVATE FUNCTIONS
    // Look for a positive review from a reviewer over a paper
    function checkIsNotApproved(string memory paperHash, string memory reviewerHash) private view {
        PaperStruts.ReviewData[] memory _reviews = paperReviews[bytes32(abi.encodePacked(paperHash))][bytes32(abi.encodePacked(reviewerHash))];
        for (uint i = 0; i < _reviews.length; i++) {
            require(!_reviews[i].isPositive, string(abi.encodePacked(paperHash, ' paper has already been approved by ', reviewerHash)));
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
        checkIsNotApproved(paperHash, reviewerHash);
        _;
    }

    modifier isNotPublished(string memory paperHash) {
        require(paperReviewDatas[bytes32(abi.encodePacked(paperHash))].status != Status.Published, 'Paper has already been published');
        _;
    }

    modifier isPublished(string memory paperId) {
        require(paperReviewDatas[secureHash(paperId)].status == Status.Published, 'Paper has not been published');
        _;
    }
}

const PaperReview = artifacts.require('PaperReview');

module.exports = function(deployer) {
    deployer.deploy(PaperReview);
};

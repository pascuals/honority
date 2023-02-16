const PaperReview = artifacts.require("PaperReview");
const Paper = artifacts.require("Paper");

module.exports = function(deployer) {
  deployer.deploy(PaperReview);
  deployer.deploy(Paper);
};

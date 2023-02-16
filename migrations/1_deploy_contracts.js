const IPaperReview = artifacts.require("IPaperReview");
const PaperReview = artifacts.require("PaperReview");
const Paper = artifacts.require("Paper");

module.exports = function(deployer) {
  deployer.deploy(IPaperReview);
  deployer.link(IPaperReview, PaperReview);
  deployer.deploy(PaperReview);
  deployer.link(IPaperReview, Paper);
  deployer.deploy(Paper);
};

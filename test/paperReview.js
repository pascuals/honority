const PaperReview = artifacts.require("PaperReview");

const PAPER_HASH = '0x000paperhash';
const IPFS_HASH = '0x000ipfsHash';
const PUBLISHER_HASH = '0xad73846d63d13659e7b2d62f7a18a0218539678d';

contract("PaperReview", accounts => {
  it("should put 10000 PaperReview in the first account", async () => {
    const paperReviewContract = await PaperReview.deployed();

    let paperData = await paperReviewContract.paperDatas(PAPER_HASH);
    let submitResult = paperReviewContract.submitPaper(PAPER_HASH, PUBLISHER_HASH, IPFS_HASH);
    paperData = await paperReviewContract.paperDatas(accounts[0]);
    let reviews = await paperReviewContract.getReviews(accounts[0], accounts[1], accounts);
    let publishResult = await paperReviewContract.publishReview(PAPER_HASH, accounts[0]);
    let checkNotApproved = await paperReviewContract.checkIsNotApproved(PAPER_HASH, accounts[0]);
    return undefined;
  });

  // it("should call a function that depends on a linked library", async () => {
  //   const metaCoinInstance = await PaperReview.deployed();
  //   const metaCoinBalance = (await metaCoinInstance.getBalance.call(accounts[0])).toNumber();
  //   const metaCoinEthBalance = (await metaCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();
  //
  //   assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpected function, linkage may be broken");
  // });
  //
  // it("should send coin correctly", async () => {
  //   const metaCoinInstance = await PaperReview.deployed();
  //
  //   // Setup 2 accounts.
  //   const accountOne = accounts[0];
  //   const accountTwo = accounts[1];
  //
  //   // Get initial balances of first and second account.
  //   const accountOneStartingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
  //   const accountTwoStartingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();
  //
  //   // Make transaction from first account to second.
  //   const amount = 10;
  //   await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });
  //
  //   // Get balances of first and second account after the transactions.
  //   const accountOneEndingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
  //   const accountTwoEndingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();
  //
  //   assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
  //   assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  // });
});

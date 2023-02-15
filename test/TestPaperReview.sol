// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// These files are dynamically created at test time
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PaperReview.sol";

contract TestPaperReview {

    function testInitialBalanceUsingDeployedContract() public {
        PaperReview meta = PaperReview(DeployedAddresses.PaperReview());

        uint expected = 10000;

        Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 PaperReview initially");
    }

    function testInitialBalanceWithNewPaperReview() public {
        PaperReview meta = new PaperReview();

        uint expected = 10000;

        Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 PaperReview initially");
    }

}

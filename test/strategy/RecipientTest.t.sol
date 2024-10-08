// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {BountyStrategy} from "../../src/contracts/BountyStrategy.sol";
import {IStrategy} from "../../lib/allo-v2/interfaces/IStrategy.sol";
import {Errors} from "../../lib/allo-v2/libraries/Errors.sol";
import {TestSetUpWithProfileId} from "../setup/TestSetUpWithProfileId.t.sol";

contract ExecutorSupplierVotingStrategy_RecipientTest is TestSetUpWithProfileId {
    function setUp() public override {
        super.setUp();
    }

    function test_UnAuthorizedReviewRecipient() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        vm.expectRevert(Errors.SUPPLIER_HAT_WEARING_REQUIRED.selector);

        vm.prank(unAuthorized);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);
    }

    function test_ReviewRecipientByProfileCreator() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);

        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        // console.log("::::: projectStrategy:", projectStrategy);

        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.expectRevert(Errors.MAX_RECIPIENTS_AMOUNT_REACHED.selector);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Rejected);

        strategyContract.reviewRecipient(projectExecutor2, IStrategy.Status.Accepted);

        vm.stopPrank();
    }

    function test_ReviewRecipientByProfileManager() external {
        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Rejected);

        vm.stopPrank();
    }

    function test_RevertDuplicatedReviewRecipientByMultipleProfileManagers() external {
        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        vm.startPrank(projectManager3);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.expectRevert(Errors.ALREADY_REVIEWED.selector);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Rejected);

        vm.stopPrank();

        vm.prank(projectManager2);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);
    }

    function test_RevertReviewRecipientWhenRecipientIsSetAndMultipleRecipients() external {
        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        vm.startPrank(projectManager3);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        vm.prank(projectManager2);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.prank(projectManager2);
        strategyContract.reviewRecipient(projectExecutor2, IStrategy.Status.Accepted);

        // vm.expectRevert(Errors.MAX_RECIPIENTS_AMOUNT_REACHED.selector);
        vm.prank(projectManager3);
        strategyContract.reviewRecipient(projectExecutor2, IStrategy.Status.Accepted);

        vm.expectRevert(Errors.MAX_RECIPIENTS_AMOUNT_REACHED.selector);
        vm.prank(projectManager3);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        // (uint256 votesFor, uint256 votesAgainst) = strategyContract.offeredRecipient(projectExecutor);
        // console.log(":::::: projectExecutor after (Accepted) review by Managers | votesFor:", votesFor);
        // console.log(":::::: projectExecutor after (Accepted) review by Managers | votesAgainst:", votesAgainst);

        // (uint256 votesFor2, uint256 votesAgainst2) = strategyContract.offeredRecipient(projectExecutor2);
        // console.log(":::::: projectExecutor2 after (Accepted) review by Managers | votesFor:", votesFor2);
        // console.log(":::::: projectExecutor2 after (Accepted) review by Managers | votesAgainst:", votesAgainst2);

        // uint256 totalSupply = strategyContract.totalSupply();
        // console.log(":::::: totalSupply1:", totalSupply);
    }
}

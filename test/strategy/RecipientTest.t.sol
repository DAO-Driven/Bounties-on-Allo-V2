// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {BountyStrategy} from "../../src/contracts/BountyStrategy.sol";
import {IStrategy} from "../../lib/allo-v2/interfaces/IStrategy.sol";
import {Errors} from "../../lib/allo-v2/libraries/Errors.sol";
import {TestSetUpWithProfileId} from "../setup/TestSetUpWithProfileId.t.sol";
import {MilestonesGetter} from "../helpers/GetMilestones.t.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";

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

        vm.prank(projectManager3);
        strategyContract.reviewRecipient(projectExecutor2, IStrategy.Status.Accepted);

        vm.expectRevert(Errors.MAX_RECIPIENTS_AMOUNT_REACHED.selector);
        vm.prank(projectManager3);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);
    }

    function test_ChngeRecipientAndDistributeToCorrectOne() external {
        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        BountyStrategy.Milestone[] memory milestones = new MilestonesGetter().getTwoEqualMilestones();

        strategyContract.offerMilestones(milestones);

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        // strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Rejected);

        // strategyContract.reviewRecipient(projectExecutor2, IStrategy.Status.Accepted);

        vm.stopPrank();

        // TODO: finish this logic

        // vm.expectRevert(Errors.RECIPIENT_NOT_ACCEPTED.selector);
        vm.prank(projectExecutor);
        strategyContract.submitMilestone(projectExecutor, 0, Metadata({protocol: 1, pointer: "example-pointer"}));

        // vm.expectRevert(Errors.RECIPIENT_NOT_ACCEPTED.selector);
        // vm.prank(projectExecutor2);
        // strategyContract.submitMilestone(projectExecutor, 0, Metadata({protocol: 1, pointer: "example-pointer"}));

        vm.prank(projectManager2);
        strategyContract.reviewSubmitedMilestone(projectExecutor, 0, IStrategy.Status.Accepted);
    }
}

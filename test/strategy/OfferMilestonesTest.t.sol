// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";
import {BountyStrategy} from "../../src/contracts/BountyStrategy.sol";
import {IStrategy} from "../../lib/allo-v2/interfaces/IStrategy.sol";
import {Errors} from "../../lib/allo-v2/libraries/Errors.sol";
import {TestSetUpWithProfileId} from "../setup/TestSetUpWithProfileId.t.sol";

contract ExecutorSupplierVotingStrategy_OfferMilestonesTest is TestSetUpWithProfileId {
    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    function setUp() public override {
        super.setUp();
    }

    function test_UnAuthorizedOfferMilestonesByRecipient() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        vm.prank(projectManager1);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        BountyStrategy.Milestone[] memory milestones = getMilestones();

        vm.expectRevert(Errors.SUPPLIER_HAT_WEARING_REQUIRED.selector);

        vm.prank(unAuthorized);
        strategyContract.offerMilestones(milestones);
    }

    function test_OfferMilestonesByManager() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        BountyStrategy.Milestone[] memory milestones = getMilestones();

        strategyContract.offerMilestones(milestones);

        vm.stopPrank();
    }

    function test_RevertDuplicatedOfferMilestonesByManager() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        BountyStrategy.Milestone[] memory milestones = getMilestones();

        strategyContract.offerMilestones(milestones);

        vm.expectRevert(Errors.MILESTONES_ALREADY_SET.selector);
        strategyContract.offerMilestones(milestones);

        vm.stopPrank();
    }

    function test_OfferMilestonesByMultipleManagers() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        vm.prank(projectManager1);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.prank(projectManager2);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        BountyStrategy.Milestone[] memory milestones = getMilestones();

        vm.prank(projectManager1);
        strategyContract.offerMilestones(milestones);

        vm.prank(projectManager2);
        strategyContract.reviewOfferedtMilestones(IStrategy.Status.Accepted);
    }

    function test_MilestonesResetByMultipleOfferMilestones() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        BountyStrategy strategyContract = BountyStrategy(payable(projectStrategy));

        vm.prank(projectManager1);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.prank(projectManager2);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        BountyStrategy.Milestone[] memory milestones = getMilestones();

        vm.prank(projectManager1);
        strategyContract.offerMilestones(milestones);

        vm.prank(projectManager1);
        strategyContract.offerMilestones(milestones);

        vm.prank(projectManager2);
        strategyContract.reviewOfferedtMilestones(IStrategy.Status.Accepted);
    }

    function getMilestones() public pure returns (BountyStrategy.Milestone[] memory milestones) {
        Metadata memory metadata = Metadata({protocol: 1, pointer: "example-pointer"});
        milestones = new BountyStrategy.Milestone[](2);

        // Initialize each element manually
        milestones[0] = BountyStrategy.Milestone({
            amountPercentage: 0.5 ether,
            metadata: metadata,
            milestoneStatus: IStrategy.Status.None, // Assuming 0 corresponds to Pending status
            description: "I will do my best"
        });

        milestones[1] = BountyStrategy.Milestone({
            amountPercentage: 0.5 ether,
            metadata: metadata,
            milestoneStatus: IStrategy.Status.None,
            description: "I will do my best"
        });
    }
}

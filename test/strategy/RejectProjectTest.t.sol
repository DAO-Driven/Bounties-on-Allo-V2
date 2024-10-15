// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";
import {BountyStrategy} from "../../src/contracts/BountyStrategy.sol";
import {IStrategy} from "../../lib/allo-v2/interfaces/IStrategy.sol";
import {Errors} from "../../lib/allo-v2/libraries/Errors.sol";
import {TestSetUpWithProfileId} from "../setup/TestSetUpWithProfileId.t.sol";

contract RejectProjectTest is TestSetUpWithProfileId {
    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    BountyStrategy oneManagerStrategy;

    function setUp() public override {
        super.setUp();

        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        oneManagerStrategy = BountyStrategy(payable(projectStrategy));

        oneManagerStrategy.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.stopPrank();
    }

    function test_UnAuthorizedRejectProject() external {
        vm.expectRevert(Errors.UNAUTHORIZED.selector);

        vm.prank(unAuthorized);
        oneManagerStrategy.rejectProject(IStrategy.Status.Accepted);
    }

    function test_RejectProject() external {
        vm.prank(projectManager1);
        oneManagerStrategy.rejectProject(IStrategy.Status.Accepted);
    }

    function test_RejectProjectAfterMilestonesSet() external {
        BountyStrategy.Milestone[] memory milestones = getMilestones();

        vm.startPrank(projectManager1);

        oneManagerStrategy.offerMilestones(milestones);
        oneManagerStrategy.rejectProject(IStrategy.Status.Accepted);

        vm.stopPrank();
    }

    function test_RejectProjectAfterMilestoneSubmited() external {
        BountyStrategy.Milestone[] memory milestones = getMilestones();

        vm.startPrank(projectManager1);

        oneManagerStrategy.offerMilestones(milestones);

        oneManagerStrategy.submitMilestone(projectExecutor, 0, Metadata({protocol: 1, pointer: "example-pointer"}));

        oneManagerStrategy.rejectProject(IStrategy.Status.Accepted);

        vm.stopPrank();
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

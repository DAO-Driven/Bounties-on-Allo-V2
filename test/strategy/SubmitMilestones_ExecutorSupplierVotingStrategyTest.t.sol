// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Manager} from "../../src/contracts/Manager.sol";
import {MockERC20} from "../../src/contracts/mocks/MockERC20.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";
import {IHats} from "../../lib/hats/IHats.sol";
import {ExecutorSupplierVotingStrategy} from "../../src/contracts/ExecutorSupplierVotingStrategy.sol";
import {StrategyFactory} from "../../lib/allo-v2/libraries/StrategyFactory.sol";
import {IStrategy} from "../../lib/allo-v2/interfaces/IStrategy.sol";
import {Errors} from "../../lib/allo-v2/libraries/Errors.sol";
import {TestSetUpWithProfileId} from "../setup/TestSetUpWithProfileId.t.sol";

contract ExecutorSupplierVotingStrategy_OfferMilestonesTest is TestSetUpWithProfileId {
    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    function test_UnAuthorizedSubmitMilestonesByRecipient() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        ExecutorSupplierVotingStrategy strategyContract = ExecutorSupplierVotingStrategy(payable(projectStrategy));

        vm.prank(projectManager1);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        ExecutorSupplierVotingStrategy.Milestone[] memory milestones = getMilestones();

        vm.expectRevert(Errors.SUPPLIER_HAT_WEARING_REQUIRED.selector);

        vm.prank(unAuthorized);
        strategyContract.offerMilestones(projectExecutor, milestones);
    }

    function test_SubmitMilestonesByManager() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        ExecutorSupplierVotingStrategy strategyContract = ExecutorSupplierVotingStrategy(payable(projectStrategy));

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        ExecutorSupplierVotingStrategy.Milestone[] memory milestones = getMilestones();

        strategyContract.offerMilestones(projectExecutor, milestones);

        vm.stopPrank();
    }

    function test_RevertDuplicatedSubmitMilestonesByManager() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        address projectStrategy = manager.getProjectStrategy(profileId);
        ExecutorSupplierVotingStrategy strategyContract = ExecutorSupplierVotingStrategy(payable(projectStrategy));

        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        ExecutorSupplierVotingStrategy.Milestone[] memory milestones = getMilestones();

        strategyContract.offerMilestones(projectExecutor, milestones);

        vm.expectRevert(Errors.MILESTONES_ALREADY_SET.selector);
        strategyContract.offerMilestones(projectExecutor, milestones);

        vm.stopPrank();
    }

    function test_SubmitMilestonesByMultipleManagers() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        ExecutorSupplierVotingStrategy strategyContract = ExecutorSupplierVotingStrategy(payable(projectStrategy));

        vm.prank(projectManager1);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.prank(projectManager2);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        ExecutorSupplierVotingStrategy.Milestone[] memory milestones = getMilestones();

        vm.prank(projectManager1);
        strategyContract.offerMilestones(projectExecutor, milestones);

        vm.prank(projectManager2);
        strategyContract.reviewOfferedtMilestones(projectExecutor, IStrategy.Status.Accepted);
    }

    function test_MilestonesResetByMultipleSubmitrMilestones() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        vm.startPrank(projectManager2);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 0.5e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        ExecutorSupplierVotingStrategy strategyContract = ExecutorSupplierVotingStrategy(payable(projectStrategy));

        vm.prank(projectManager1);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        vm.prank(projectManager2);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);

        ExecutorSupplierVotingStrategy.Milestone[] memory milestones = getMilestones();

        vm.prank(projectManager1);
        strategyContract.offerMilestones(projectExecutor, milestones);

        vm.prank(projectManager1);
        strategyContract.offerMilestones(projectExecutor, milestones);

        vm.prank(projectManager2);
        strategyContract.reviewOfferedtMilestones(projectExecutor, IStrategy.Status.Accepted);
    }

    function getMilestones() public pure returns (ExecutorSupplierVotingStrategy.Milestone[] memory milestones) {
        Metadata memory metadata = Metadata({protocol: 1, pointer: "example-pointer"});
        milestones = new ExecutorSupplierVotingStrategy.Milestone[](2);

        // Initialize each element manually
        milestones[0] = ExecutorSupplierVotingStrategy.Milestone({
            amountPercentage: 0.5 ether,
            metadata: metadata,
            milestoneStatus: IStrategy.Status.None, // Assuming 0 corresponds to Pending status
            description: "I will do my best"
        });

        milestones[1] = ExecutorSupplierVotingStrategy.Milestone({
            amountPercentage: 0.5 ether,
            metadata: metadata,
            milestoneStatus: IStrategy.Status.None,
            description: "I will do my best"
        });
    }
}

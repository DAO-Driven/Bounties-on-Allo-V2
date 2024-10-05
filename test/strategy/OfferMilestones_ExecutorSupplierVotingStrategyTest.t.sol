// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Manager} from "../../src/contracts/Manager.sol";
import {MockERC20} from "../../src/contracts/mocks/MockERC20.sol";
import {Metadata} from "../../src/contracts/libraries/Metadata.sol";
import {IHats} from "../../src/contracts/interfaces/Hats/IHats.sol";
import {ExecutorSupplierVotingStrategy} from "../../src/contracts/ExecutorSupplierVotingStrategy.sol";
import {StrategyFactory} from "../../src/contracts/libraries/StrategyFactory.sol";
import {IStrategy} from "../../src/contracts/interfaces/IStrategy.sol";
import {Errors} from "../../src/contracts/libraries/Errors.sol";
import {TestSetUpWithProfileId} from "../setup/TestSetUpWithProfileId.t.sol";

contract ExecutorSupplierVotingStrategy_OfferMilestonesTest is TestSetUpWithProfileId {

    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    function test_UnAuthorizedOfferMilestones() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(profileId, 1e18);

        vm.stopPrank();

        address projectStrategy = manager.getProjectStrategy(profileId);
        ExecutorSupplierVotingStrategy strategyContract = ExecutorSupplierVotingStrategy(payable(projectStrategy));

        vm.expectRevert(Errors.SUPPLIER_HAT_WEARING_REQUIRED.selector);

        vm.prank(unAuthorized);
        strategyContract.reviewRecipient(projectExecutor, IStrategy.Status.Accepted);
    }
}

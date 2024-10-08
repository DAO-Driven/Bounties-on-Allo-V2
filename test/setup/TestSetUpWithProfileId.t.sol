// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Manager} from "../../src/contracts/Manager.sol";
import {MockERC20} from "../mocks/MockERC20.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";
import {IHats} from "../../lib/hats/IHats.sol";
import {BountyStrategy} from "../../src/contracts/BountyStrategy.sol";
import {StrategyFactory} from "../../lib/allo-v2/libraries/StrategyFactory.sol";
import {IStrategy} from "../../lib/allo-v2/interfaces/IStrategy.sol";
import {Errors} from "../../lib/allo-v2/libraries/Errors.sol";

contract TestSetUpWithProfileId is Test {
    Manager public manager;
    address mainHat = 0x01Ae8d6d0F137CF946e354eA707B698E8CaE6485;
    uint256 topHatId = 0x0000005200010000000000000000000000000000000000000000000000000000;
    address projectExecutor = address(0x456);
    address projectExecutor2 = address(0x454);
    address projectManager1 = address(0x459);
    address projectManager2 = address(0x458);
    address projectManager3 = address(0x457);
    address unAuthorized = address(0x455);
    BountyStrategy strategy;
    StrategyFactory strategyFactory;
    address hatsContractAddress = 0x3bc1A0Ad72417f2d411118085256fC53CBdDd137;
    uint256 managerHatID = 0x0000005200010000000000000000000000000000000000000000000000000000;

    bytes32 profileId;
    MockERC20 projectToken;

    function setUp() public virtual {
        projectToken = new MockERC20("TOKEN", "TKN", 18);

        strategyFactory = new StrategyFactory();

        strategy = new BountyStrategy(0x1133eA7Af70876e64665ecD07C0A0476d09465a1, "BountyStrategy");

        manager = new Manager();

        manager.initialize(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1,
            address(strategy),
            address(strategyFactory),
            hatsContractAddress,
            managerHatID
        );

        projectToken.mint(address(projectManager1), 2000e18);
        projectToken.mint(address(projectManager2), 2000e18);
        projectToken.mint(address(projectManager3), 2000e18);

        IHats hatsProtocol = IHats(hatsContractAddress);

        vm.prank(mainHat);
        hatsProtocol.transferHat(topHatId, mainHat, address(manager));

        vm.prank(projectManager1);
        profileId = manager.registerProject(
            Manager.ProjectType.Bounty,
            address(projectToken),
            1e18,
            777777,
            "ExecutorSupplierVotingStrategyTest",
            Metadata({protocol: 1, pointer: ""})
        );
    }
}

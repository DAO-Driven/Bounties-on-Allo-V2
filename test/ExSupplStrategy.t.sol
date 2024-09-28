// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Manager} from "../src/contracts/Manager.sol";
import {MockERC20} from "../src/contracts/mocks/MockERC20.sol";
import {Metadata} from "../src/contracts/libraries/Metadata.sol";
import {IHats} from "../src/contracts/interfaces/Hats/IHats.sol";
import {ExecutorSupplierVotingStrategy} from "../src/contracts/ExecutorSupplierVotingStrategy.sol";
import {StrategyFactory} from "../src/contracts/libraries/StrategyFactory.sol";

contract ManagerTest is Test {
    Manager public manager;
    address mainHat = 0x01Ae8d6d0F137CF946e354eA707B698E8CaE6485;
    uint256 topHatId = 0x0000005200010000000000000000000000000000000000000000000000000000;
    address projectExecutor = address(0x456);
    address projectManager1 = address(0x459);
    ExecutorSupplierVotingStrategy strategy;
    StrategyFactory strategyFactory;
    address hatsContractAddress = 0x3bc1A0Ad72417f2d411118085256fC53CBdDd137;
    uint256 managerHatID = 0x0000005200010000000000000000000000000000000000000000000000000000;

    MockERC20 projectToken;

    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    function setUp() public {
        projectToken = new MockERC20("TOKEN", "TKN", 18);

        strategyFactory = new StrategyFactory();

        strategy = new ExecutorSupplierVotingStrategy(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1, 
            "ExecutorSupplierVotingStrategy"
        );

        manager = new Manager();

        manager.initialize(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1, 
            address(strategy), 
            address(strategyFactory), 
            hatsContractAddress, 
            managerHatID
        );

        projectToken.mint(address(projectManager1), 2000e18);

        IHats hatsProtocol = IHats(hatsContractAddress);

        vm.prank(mainHat);
        hatsProtocol.transferHat(topHatId, mainHat, address(manager));


    }

    function test_createPoolWithCustomStrategy() external {

        vm.startPrank(projectManager1);

        bytes32 profileId = manager.registerProject(
            address(projectToken), 
            1e18, 
            777777, 
            "test_createPoolWithCustomStrategy", 
            Metadata({protocol: 1, pointer: ""})
        );
        
        projectToken.approve(address(manager), 100e18);

        manager.supplyProject(profileId, 1e18);

        vm.stopPrank();
    }
}

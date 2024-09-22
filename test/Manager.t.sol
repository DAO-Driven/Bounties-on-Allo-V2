// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Manager} from "../src/contracts/Manager.sol";
import {MockERC20} from "../src/contracts/mocks/MockERC20.sol";
import {Metadata} from "../src/contracts/libraries/Metadata.sol";


contract ManagerTest is Test {
    Manager public manager;

    address projectExecutor = address(0x456);
    address strategy = address(0x123);
    address strategyFactory = address(0x457);
    address hatsContractAddress = address(0x458);
    uint256 managerHatID = 1;

    MockERC20 projectToken;

    function setUp() public {

        projectToken = new MockERC20("TOKEN", "TKN", 18);

        manager = new Manager();

        manager.initialize(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1, 
            strategy, 
            strategyFactory, 
            hatsContractAddress, 
            managerHatID
        );
    }

    function test_registerProjectWithoutPool() external {

        manager.registerProjectWithoutPool(
            address(projectToken),
            1e18,
            777777,
            "Test Project",
            Metadata({
                protocol: 1,
                pointer: ""
            }),
            projectExecutor
        );
    }
}

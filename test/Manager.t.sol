// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Manager} from "../src/contracts/Manager.sol";

contract ManagerTest is Test {
    Manager public manager;

    address alloAddress = address(0x456);
    address strategy = address(0x123);
    address strategyFactory = address(0x457);
    address hatsContractAddress = address(0x458);
    uint256 managerHatID = 1;

    function setUp() public {
        manager = new Manager();

        manager.initialize(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1, 
            strategy, 
            strategyFactory, 
            hatsContractAddress, 
            managerHatID
        );
    }

    function test_GetManagerNative() public view {
        address native = manager.NATIVE();
        console.log(":::::: Manager Native:", native);
    }
}

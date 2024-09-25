// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Manager} from "../src/contracts/Manager.sol";
import {MockERC20} from "../src/contracts/mocks/MockERC20.sol";
import {Metadata} from "../src/contracts/libraries/Metadata.sol";

contract ManagerTest is Test {
    Manager public manager;
    address projectManager1 = address(0x459);
    address strategy = address(0x123);
    address strategyFactory = address(0x457);
    address hatsContractAddress = address(0x458);
    uint256 managerHatID = 1;

    MockERC20 projectToken;

    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    function setUp() public {
        projectToken = new MockERC20("TOKEN6", "TKN6", 6);

        manager = new Manager();

        manager.initialize(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1, strategy, strategyFactory, hatsContractAddress, managerHatID
        );

        projectToken.mint(address(manager), 2000e6);
    }

    function test_supplyProjectAndRevokeSupply() external {
        bytes32 profileId = manager.registerProject(
            address(projectToken),
            1e6,
            777777,
            "test_supplyProjectAndRevokeSupply Project",
            Metadata({protocol: 1, pointer: ""})
        );

        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 1e6);

        manager.supplyProject(profileId, 0.5e6);

        uint256 projectManager1Supply = manager.getProjectSupplierById(profileId, projectManager1);

        assertTrue(
            projectManager1Supply == 0.5e6,
            "Expected projectManager1Supply to be 0.5e6 after supplying funds, but it was not."
        );

        manager.revokeProjectSupply(profileId);

        uint256 projectManager1SupplyAfterRevoke = manager.getProjectSupplierById(profileId, projectManager1);

        assertTrue(
            projectManager1SupplyAfterRevoke == 0,
            "Expected projectManager1Supply to be 0 after revoking funds, but it was not."
        );

        vm.stopPrank();
    }
}

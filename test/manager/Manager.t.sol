// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Manager} from "../../src/contracts/Manager.sol";
import {MockERC20} from "../mocks/MockERC20.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";
import "../../lib/allo-v2/interfaces/IRegistry.sol";
import {IHats} from "../../lib/hats/IHats.sol";

contract ManagerTest is Test {
    Manager public manager;
    address mainHat = 0x01Ae8d6d0F137CF946e354eA707B698E8CaE6485;
    uint256 topHatId = 0x0000005200000000000000000000000000000000000000000000000000000000;
    address unAuthorized = address(0x455);
    address projectExecutor = address(0x456);
    address projectManager1 = address(0x459);
    address strategy = address(0x123);
    address strategyFactory = address(0x457);
    address hatsContractAddress = 0x3bc1A0Ad72417f2d411118085256fC53CBdDd137;
    uint256 managerHatID = 1;
    bytes32 testProfileId;

    MockERC20 projectToken;

    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    function setUp() public {
        projectToken = new MockERC20("TOKEN", "TKN", 18);

        manager = new Manager();

        vm.prank(mainHat);
        manager.initialize(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1, strategy, strategyFactory, hatsContractAddress, managerHatID
        );

        projectToken.mint(address(projectManager1), 2000e18);

        IHats hatsProtocol = IHats(hatsContractAddress);

        vm.prank(mainHat);
        hatsProtocol.transferHat(topHatId, mainHat, address(manager));

        testProfileId = manager.registerProject(
            Manager.ProjectType.Bounty,
            address(projectToken),
            1e18,
            777777,
            "test_supplyProject Project",
            Metadata({protocol: 1, pointer: ""})
        );
    }

    function test_getProfile() external view {
        IRegistry.Profile memory profile = manager.getProfile(testProfileId);
        assertEq(profile.nonce, 777777);
    }

    function test_getProjectPool() external view {
        uint256 projectPool = manager.getProjectPool(testProfileId);
        assertEq(projectPool, 0);
    }

    function test_getProjectSuppliers() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);
        manager.supplyProject(testProfileId, 0.5e18);

        vm.stopPrank();

        address[] memory projectManagers = manager.getProjectSuppliers(testProfileId);

        assertEq(projectManagers[0], projectManager1);
    }

    function test_UnAuthorizedSetAlloAddress() external {
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", unAuthorized));

        vm.prank(unAuthorized);
        manager.setAlloAddress(unAuthorized);
    }

    function test_SetAlloAddress() external {
        vm.prank(mainHat);
        manager.setAlloAddress(mainHat);
    }

    function test_UnAuthorizedSetStrategyAddress() external {
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", unAuthorized));

        vm.prank(unAuthorized);
        manager.setAlloAddress(unAuthorized);
    }

    function test_SetStrategyAddress() external {
        vm.prank(mainHat);
        manager.setAlloAddress(mainHat);
    }

    function test_UnAuthorizedSetStrategyFactoryAddress() external {
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", unAuthorized));

        vm.prank(unAuthorized);
        manager.setStrategyFactoryAddress(unAuthorized);
    }

    function test_SetStrategyFactoryAddress() external {
        vm.prank(mainHat);
        manager.setStrategyFactoryAddress(mainHat);
    }

    function test_UnAuthorizedSetHatsContractAddress() external {
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", unAuthorized));

        vm.prank(unAuthorized);
        manager.setHatsContractAddress(unAuthorized);
    }

    function test_SetHatsContractAddress() external {
        vm.prank(mainHat);
        manager.setHatsContractAddress(mainHat);
    }

    function test_UnAuthorizedSetManagerHatID() external {
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", unAuthorized));

        vm.prank(unAuthorized);
        manager.setManagerHatID(topHatId);
    }

    function test_SetManagerHatID() external {
        vm.prank(mainHat);
        manager.setManagerHatID(topHatId);
    }

    function test_UnAuthorizedSetThresholdPercentage() external {
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", unAuthorized));

        vm.prank(unAuthorized);
        manager.setThresholdPercentage(77);
    }

    function test_SetThresholdPercentage() external {
        vm.prank(mainHat);
        manager.setThresholdPercentage(77);
    }

    function test_supplyProject() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);

        manager.supplyProject(testProfileId, 0.5e18);

        uint256 projectManager1Supply = manager.getProjectSupplierById(testProfileId, projectManager1);

        assertTrue(
            projectManager1Supply == 0.5e18,
            "Expected projectManager1Supply to be 0.5e18 after supplying funds, but it was not."
        );

        vm.stopPrank();
    }

    function test_supplyProjectAndRevokeSupply() external {
        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);

        manager.supplyProject(testProfileId, 0.5e18);

        uint256 projectManager1Supply = manager.getProjectSupplierById(testProfileId, projectManager1);

        assertTrue(
            projectManager1Supply == 0.5e18,
            "Expected projectManager1Supply to be 0.5e18 after supplying funds, but it was not."
        );

        manager.revokeProjectSupply(testProfileId);

        uint256 projectManager1SupplyAfterRevoke = manager.getProjectSupplierById(testProfileId, projectManager1);

        assertTrue(
            projectManager1SupplyAfterRevoke == 0,
            "Expected projectManager1Supply to be 0 after revoking funds, but it was not."
        );

        vm.stopPrank();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Manager} from "../../src/contracts/Manager.sol";
import {MockERC20} from "../mocks/MockERC20.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";
import {IHats} from "../../lib/hats/IHats.sol";

contract ManagerTest is Test {
    Manager public manager;
    address mainHat = 0x01Ae8d6d0F137CF946e354eA707B698E8CaE6485;
    uint256 topHatId = 0x0000005200000000000000000000000000000000000000000000000000000000;
    address projectExecutor = address(0x456);
    address projectManager1 = address(0x459);
    address strategy = address(0x123);
    address strategyFactory = address(0x457);
    address hatsContractAddress = 0x3bc1A0Ad72417f2d411118085256fC53CBdDd137;
    uint256 managerHatID = 1;

    MockERC20 projectToken;

    event ProjectRegistered(uint256 indexed profileId, uint256 nonce);

    function setUp() public {
        projectToken = new MockERC20("TOKEN", "TKN", 18);

        manager = new Manager();

        manager.initialize(
            0x1133eA7Af70876e64665ecD07C0A0476d09465a1, strategy, strategyFactory, hatsContractAddress, managerHatID
        );

        projectToken.mint(address(projectManager1), 2000e18);

        IHats hatsProtocol = IHats(hatsContractAddress);

        vm.prank(mainHat);
        hatsProtocol.transferHat(topHatId, mainHat, address(manager));
    }

    function test_registerProjectWithoutPool() external {
        manager.registerProject(
            Manager.ProjectType.Bounty,
            address(projectToken),
            1e18,
            777777,
            "Test Project",
            Metadata({protocol: 1, pointer: ""})
        );
    }

    function test_supplyProject() external {
        bytes32 profileId = manager.registerProject(
            Manager.ProjectType.Bounty,
            address(projectToken),
            1e18,
            777777,
            "test_supplyProject Project",
            Metadata({protocol: 1, pointer: ""})
        );

        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);

        manager.supplyProject(profileId, 0.5e18);

        uint256 projectManager1Supply = manager.getProjectSupplierById(profileId, projectManager1);

        assertTrue(
            projectManager1Supply == 0.5e18,
            "Expected projectManager1Supply to be 0.5e18 after supplying funds, but it was not."
        );

        vm.stopPrank();
    }

    function test_supplyProjectAndRevokeSupply() external {
        bytes32 profileId = manager.registerProject(
            Manager.ProjectType.Bounty,
            address(projectToken),
            1e18,
            777777,
            "test_supplyProjectAndRevokeSupply Project",
            Metadata({protocol: 1, pointer: ""})
        );

        vm.startPrank(projectManager1);

        projectToken.approve(address(manager), 100e18);

        manager.supplyProject(profileId, 0.5e18);

        uint256 projectManager1Supply = manager.getProjectSupplierById(profileId, projectManager1);

        assertTrue(
            projectManager1Supply == 0.5e18,
            "Expected projectManager1Supply to be 0.5e18 after supplying funds, but it was not."
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

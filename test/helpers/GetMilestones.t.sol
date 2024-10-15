// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {BountyStrategy} from "../../src/contracts/BountyStrategy.sol";
import {Metadata} from "../../lib/allo-v2/libraries/Metadata.sol";
import {IStrategy} from "../../lib/allo-v2/interfaces/IStrategy.sol";

contract MilestonesGetter {
    function getTwoEqualMilestones() public pure returns (BountyStrategy.Milestone[] memory milestones) {
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

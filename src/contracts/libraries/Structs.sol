// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Metadata} from "./Metadata.sol";

enum Status {
    None,
    Pending,
    Accepted,
    Rejected,
    Appealed,
    InReview,
    Canceled
}

/// @notice Struct to hold initialization data for setting up a project or strategy.
struct InitializeData {
    uint256 supplierHat; // ID of the Supplier Hat.
    uint256 executorHat; // ID of the Executor Hat.
    SupplierPower[] supliersPower; // Array of SupplierPower, representing the power of each supplier.
    address hatsContractAddress; // Address of the Hats contract.
    uint8 thresholdPercentage;
}

/// @notice Struct representing the supply details of a project.
struct ProjectSupply {
    uint256 need; // The total amount needed for the project.
    uint256 has; // The amount currently supplied.
}

/// @notice Struct for mapping suppliers to their supply amount by ID.
struct SuppliersById {
    mapping(address => uint256) supplyById; // Maps supplier address to their supply amount.
}

/// @notice Struct representing the power or influence of a supplier.
struct SupplierPower {
    address supplierId; // Address of the supplier.
    uint256 supplierPowerr; // Power value associated with the supplier.
}

/// @notice Struct holding IDs for different types of hats used in the system.
struct Hats {
    uint256 executorHat; // ID of the Executor Hat.
    uint256 supplierHat; // ID of the Supplier Hat.
}

/// @notice Struct containing all information relevant to a project.
struct ProjectInformation {
    address token;
    address projectExecutor;
    address[] projectSuppliers;
    SuppliersById projectSuppliersById;
    ProjectSupply projectSupply;
    uint256 projectPool;
    address projectStrategy;
    Hats projectHats;
}

/// @notice Struct to hold details of an recipient
struct Recipient {
    bool useRegistryAnchor;
    address recipientAddress;
    uint256 grantAmount;
    Metadata metadata;
    Status recipientStatus;
    Status milestonesReviewStatus;
}

/// @notice Struct to hold milestone details
struct Milestone {
    uint256 amountPercentage;
    Metadata metadata;
    Status milestoneStatus;
    string description;
}

/// @notice Struct to represent the offered milestones along with their voting status.
struct OfferedMilestones {
    Milestone[] milestones; // Array of Milestones that are offered.
    uint256 votesFor; // Total number of votes in favor of the offered milestones.
    uint256 votesAgainst; // Total number of votes against the offered milestones.
    mapping(address => uint256) suppliersVotes; // Mapping of supplier addresses to their vote counts.
}

/// @notice Struct to represent a submitted milestone and its voting status.
struct SubmiteddMilestone {
    uint256 votesFor; // Total number of votes in favor of the submitted milestone.
    uint256 votesAgainst; // Total number of votes against the submitted milestone.
    mapping(address => uint256) suppliersVotes; // Mapping of supplier addresses to their vote counts.
}

/// @notice Struct to represent the voting status for rejecting a project.
struct RejectProject {
    uint256 votesFor; // Total number of votes in favor of rejecting the project.
    uint256 votesAgainst; // Total number of votes against rejecting the project.
    mapping(address => uint256) suppliersVotes; // Mapping of supplier addresses to their vote counts.
}

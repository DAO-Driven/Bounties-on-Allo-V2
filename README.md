# DAO-Driven | Bounty-Strategy on Allo-V2

### Create a bounty with an ERC20 token pool and distribute tokens to bounty hunters based on submitted milestones

Welcome to an innovative bounty platform in the Web3 space, designed to bridge the gap between investors and developers. Leveraging the power of [Allo-V2](https://github.com/allo-protocol/allo-v2), and [Hats](https://github.com/Hats-Protocol/hats-protocol) protocols, our platform offers a transparent, democratic process for bounty funding and management.

## Key Features

### 1. **Bounty Creation**
   Managers can propose their bounties, outlining their goals and the size of the funding pool. The pool can be funded by either a single manager or multiple managers.

### 2. **Formation of Committee**
   After full funding is achieved, a 'Committee' is formed from the managers who have contributed to the pool, with each member's voting power proportional to their investment.

### 3. **Milestones Defining**
   Managers present a plan with milestones, including fund distribution for each. These milestones are subject to committee voting.

### 4. **Bounty Hunters Participation**
   Bounty Hunters have the flexibility to browse and pick up projects of their choice. Afterward, they can express their interest in the bounty, and the Managers will vote to determine whether to include them in the project.

### 5. **Milestone Submission and Approval Process**
   Developers submit completed milestones for committee review. Approval or rejection is based on majority votes. Once a milestone is approved, a percentage of the pool size allocated to that milestone is distributed to the Bounty Hunter.

### 6. **Bounty Hunter Replacement Option**
   If there is no progress, the committee can vote to remove the current Bounty Hunter and replace them with a new one.

### 7. **Fund Reclamation Option**
   In case of no progress, the committee can vote to retract funding, redistributing it back to its members.

## Operational Flow

- Managers present bounty.
- Managers fund projects and gain voting rights in the committee.
- The committee oversees fund distribution based on milestone completion.
- A mechanism for fund retraction ensures investor protection.

## Vision and Impact

Project aims to create a transparent, accountable, and mutually beneficial ecosystem for developers and investors in the decentralized world.

---

## Contracts Overview

### Manager Contract

The **Manager contract** manages the key aspects of bounty registration, pool funding, and the creation of a custom Bounty strategy for each bounty and its corresponding pool. Its main functions include:

- **Bounty Registration:**  
  The contract allows managers to register new bounties, providing the essential details such as funding requirements and project structure.

- **Pool Funding:**  
  The Manager contract handles the funding process for each registered bounty. Once a bounty is fully funded by one or more managers, the contract sets up the pool for the bounty's rewards distribution.

- **Bounty Strategy Creation:**  
  After a bounty is registered and funded, the contract creates a custom Bounty strategy tailored to the specific pool using the **Strategy Factory**. This strategy defines how the funds will be distributed to bounty hunters upon milestone completion.

- **Governance Integration:**  
  The contract integrates with the **Allo** and **Hats** protocols, leveraging decentralized governance mechanisms to ensure that funders have proportional voting power in managing the bounty’s progress, milestone approval, and possible replacement of Bounty Hunters.


### BountyStrategy Contract

The **BountyStrategy contract** is designed to manage the allocation and distribution of funds to recipients based on milestone-based payouts. It integrates with the **Allo** and **Hats** protocols to ensure a decentralized and transparent process for fund distribution, milestone approval, and governance. Key functionalities of the contract include:

- **Milestone-Based Payouts:**  
  The contract facilitates milestone-based payouts where recipients submit milestones for review. The pool managers and suppliers vote to approve or reject these milestones. Once approved, a portion of the funds from the pool is distributed to the recipient.

- **Recipient and Milestone Governance:**  
  The contract allows for the registration of recipients and the submission of milestones. Both recipients and milestones undergo a voting process where managers vote based on their power, which is proportional to their contribution to the pool. Recipients can be rejected, and milestones can be modified or reset as needed.

- **Voting Mechanism:**  
  The contract implements a voting system where each supplier's voting power is proportional to their contribution to the project. Decisions regarding the approval of milestones and recipients are made based on a threshold percentage of the total supplier voting power.

- **Hats Protocol Integration:**  
  Using the Hats protocol, the contract assigns specific roles to suppliers, managers, and recipients. Hats are created and minted for various project roles, such as managers and executors, ensuring that only eligible individuals can participate in the governance process.

- **Automated Fund Distribution:**  
  Upon the successful approval of milestones, the contract automatically distributes the allocated funds to the recipient. This ensures that payments are made in a timely and transparent manner based on the approved milestones.

- **Project Rejection Mechanism:**  
  The contract includes a mechanism to reject entire projects based on supplier votes. If a project is rejected, the contract redistributes the remaining funds back to the original suppliers according to their contribution percentages.

- **Security and Reentrancy Protection:**  
  Leveraging OpenZeppelin’s **ReentrancyGuard**, the contract ensures secure transactions and mitigates reentrancy attacks, providing a robust layer of security for fund distribution and voting processes.

The Bounty Strategy contract is the backbone of the Decentralized GrantStream platform is a crucial component that manages the allocation and distribution of funds to hunters based on milestone achievements. It ensures that the funding process is democratic, transparent, and aligned with the investors' interests.

For more details, visit the [Allo V2 GitHub Repository](https://github.com/allo-protocol/allo-v2/tree/main).

---

## Getting Started

To interact with our platform, clone the repository and install the dependencies. Ensure you have a working knowledge of Solidity, smart contract interactions, and a basic understanding of the Ethereum network.

## License

This project is licensed under [MIT License](LICENSE).

---

Join us in revolutionizing the Bounty landscape in the Web3 ecosystem with DAO Driven! 🚀🌐

---

# Bounty Scenarios

## Introduction

This document outlines various scenarios demonstrating the functionality of the project, a Web3 bounty ecosystem.

## Scenario Summaries

### CASE 1: Successful Project Completion

#### Steps:
1. **Project Registration**: A manager or automated bot registers a new project, providing the necessary details and funds the project.
2. **Milestone Planning**: The manager outlines a detailed milestone plan for the project's execution.
3. **Milestone Review and Approval**: The committee of managers and suppliers reviews and approves the proposed milestones.
4. **Milestone Submission and Completion**: The Bounty Hunter accepts the bounty, works on the milestones, and submits each one for review. Investors (managers and suppliers) review and approve the completed milestones.
5. **Project Completion**: Once the final milestone is approved, the project is successfully completed, and all allocated funds are distributed to the Bounty Hunter.

### CASE 2: Project Rejection

#### Steps:
1. **Project Funding**: Similar to Case 1, the project is fully funded by two investors.
2. **Project Rejection**: Due to a lack of progress from the bounty hunter, investors decide to revoke their support and vote to reject the project.
4. **Fund Redistribution**: Upon project rejection, funds are redistributed back to the managers.

## Conclusion

These scenarios demonstrate the flexibility and democratic nature of the platform. It empowers investors to actively participate in project development and ensures accountability from project executors. The platform's design caters to various possible outcomes, from successful project completion to partial success and complete rejection, reflecting real-world investment dynamics in the Web3 ecosystem.


## Future Plans for the Project

As we continue to develop and enhance the Decentralized GrantStream platform, we aim to introduce new features and strategies to improve functionality and user engagement:

1. **Integration of ERC-1155 Tokens:**
   - **Voting Token Type:** These tokens facilitate the delegation of voting rights, with a potential sub-delegation process.
   - **Reputation Token Type:** Aimed at building user reputation, these non-transferable tokens can be minted or revoked by the management contract.

2. **Delegate/Revoke & Sub-Delegate/Revoke Voting Rights:**
   A sophisticated system for the delegation and revocability of voting rights, allowing investors to delegate their voting tokens to managers, who can then sub-delegate to others, creating a hierarchical structure. This process is tracked using the Hats protocol and the project's ERC-1155 tokens, establishing a tiered system of delegation where any Hat at a higher level can revoke voting rights from any below it.
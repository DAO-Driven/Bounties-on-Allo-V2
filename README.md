**Dao Driven on Allo-V2**

[Platform page](https://dao-driven.github.io/ui-dao-driven/){:target="_blank"}

Welcome to Decentralized GrantStream, an innovative platform in the Web3 space, designed to bridge the gap between developers and investors. Leveraging the power of Arbitrum, Allo-V2 by GitCoin, and Hats protocols, our platform offers a transparent, democratic process for project funding and management.

Let's explore a very primitive scenario illustrating how this platform could be utilized:

<Person 1>
- Initiates a quest: Offers 1 ETH for writing a highly creative tweet on their behalf.

<Person 2>
- Discovers the task and decides to undertake it.
- Crafts a creative tweet for Person 1.
- Submits the tweet as evidence of completion.

<Person 1>
- Reviews the submitted tweet by Person 2.
- Option: Accepts or declines the completion.
  - If accepted: Transfers the agreed-upon funds to Person 2.
  - If declined: Retains the funds.

In more complex scenarios, multiple individuals may be involved from Person 1's side, constituting a committee of investors. On the other hand, many individuals from Person 2's side may participate as providers of services and recipients of funds.

Let's delve into a slightly more intricate scenario:

<Developers>
- Register a new project, providing necessary details like funding needs (let’s say 1 ETH), project name, description, and recipient address.

<Investors > 
- Two investors fund the project, each contributing 0.5 ether, fully funding the project and gain voting rights in the committee.

<Developers>
- Milestone Planning: Offer a detailed milestone plan for project execution.

<Investors > 
- Milestone Review and Approval: Review and vote on the offered milestones.

<Developers>
- Milestone Submission and Completion: The Developers work on and submits each milestone. 

<Investors> 
- Review and vote on the completed milestones. 
  - If accepted: Transfers the agreed-upon funds to Developers.
  - If declined: Retains the funds.
- After the last milestone is accepted, the project is completed. 
- Additionally, investors have the option to reject the project at any time and reclaim all funds if the developer fails to make any progress


**The project will be comprised of two essential components:**

1. **Allo-V2 Strategy:** This component will manage all the business logic, serving as the backbone of the project by directing its operational framework and decision-making processes.

2. **Committee Formation:** In this segment, each committee member will be allocated voting shares, empowering them with defined influence over decisions within the pool governance structure.

Together, these parts form a comprehensive system designed to ensure efficient execution and democratic decision-making.


***Milestone-Strategy***

The concept involves creating a milestone-based strategy that includes committee members and receivers (or executors). All steps will be DAO-driven, and the committee will vote on any decision.

The strategy encompasses the following use cases:

1. **Crowdfunding Initiative:** Here, project executors present their projects to await funding, while investors transition into roles as committee members. This setup facilitates direct involvement and decision-making by those financially supporting the projects.

2. **Quest Mechanism:** In this scenario, the committee establishes a funding pool and anticipates proposals from executors, who are selected through a voting process. This approach is designed to accommodate the complexities of large-scale projects with multiple milestones. It also offers versatility by serving as a component of broader strategies through sub-agreements. Additionally, it provides a practical solution for local communities aiming to collectively finance and manage tasks.

3. **Contractual Agreement:** This use case involves a predetermined set of executors and committee members, where the strategy essentially operates as a traditional service provision contract.

The core objective of this strategy is to provide a versatile framework capable of addressing everything from isolated cases to the broader vision of a self-sustaining economic ecosystem, acting as both a comprehensive main strategy and, simultaneously, as an integral component within itself


Committee formation 

The committee formation process is designed with distinct methodologies to accommodate different types of pools. Each mechanism is designed to establish a fair and transparent voting process, aligning with the pool's governance and operational dynamics:

1. **Public Committee:** In this model, voting power is allocated based on the investment amount contributed by each manager to the pool. This approach directly correlates a manager's financial contribution with their influence in decision-making processes.

2. **Private Committee:** Admins create this type of pool, specifying all managers and granting access during its creation. The private pool features varied mechanisms for committee formation:
   
   - **DAO-Token Based:** This mechanism is applicable when pool managers are also members of another DAO. The voting power within the pool is determined by the DAO tokens held by the managers. The total tokens held represent 100%, and each manager's share of these tokens dictates their voting power.
   
   - **Predefined Voting Power:** Here, the admin assigns voting power to each manager.
   
   - **Contribution-Based Voting:** Similar to the Public Committee approach, this mechanism assigns voting power based on the token amount each manager invests in the pool. It ensures that investment contributions directly influence decision-making authority.


Regardless of the chosen method for forming a committee, the final approval will hinge on a vote by the managers. This process must reach a threshold percentage, predetermined by the admin, to ensure consensus and legitimacy in the formation of the committee.


Advanced Governance and Community Engagement Mechanisms 

1. Integration of ERC-1155 Tokens:
   - Reputation Token Type: Aimed at building user reputation, these non-transferable tokens can be minted or revoked by the management contract, offering benefits like loans for executors with high reputation and additional voting power for reputable investors.

2. Delegate/Revoke & Sub-Delegate/Revoke Voting Rights:
   - A sophisticated system for the delegation and revocability of voting rights, allowing investors to delegate their voting tokens to managers, who can then sub-delegate to others, creating a hierarchical structure. This process is tracked using the Hats protocol and the project's ERC-1155 tokens, establishing a tiered system of delegation where any Hat at a higher level can revoke voting rights from any below it.

3. Utilization of the Hats Protocol and Guild for Discord Roles:
   - Establishing a new Discord branch for each strategy to enable efficient discussion and collaboration among participants.

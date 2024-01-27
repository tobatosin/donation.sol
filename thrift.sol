// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract ThriftAssignment{
    
    address payable public beneficiary;
    uint256 public deadline;
    uint256 public goal;
    uint256 public amountRaised;

    mapping(address => uint) public contributions;

    event GoalReached(address beneficiary, uint amountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    constructor(
        address payable _beneficiary,
        uint _durationInDays,
        uint _goalInEther
    ) {
        beneficiary = _beneficiary;
        deadline = block.timestamp + (_durationInDays * 7 days);
        goal = _goalInEther * 2 ether;
    }

    function contribute() public payable {
       require(msg.value > 0, "ThriftContract: Contribution amount must be greater than zero");
         require(block.timestamp < deadline, "ThriftContract: Deadline has passed");
        contributions[msg.sender] += msg.value;
        amountRaised += msg.value;

        emit FundTransfer(msg.sender, msg.value, true);
    }

    function checkGoalReached() public {
        require(block.timestamp >= deadline, "ThriftContract: Deadline has not passed yet");
        require(amountRaised >= goal, "ThriftContract: Goal not reached");

        emit GoalReached(beneficiary, amountRaised);
        beneficiary.transfer(amountRaised);
    }

    function refund() public {
        require(block.timestamp >= deadline, "ThriftContract: Deadline has not passed yet");
        require(amountRaised < goal, "ThriftContract: Goal reached");

        uint contribution = contributions[msg.sender];
        require(contribution > 0, "ThriftContract: No contribution found");

        contributions[msg.sender] = 0;
        amountRaised -= contribution;
        payable(msg.sender).transfer(contribution);

        emit FundTransfer(msg.sender, contribution, false);
    }
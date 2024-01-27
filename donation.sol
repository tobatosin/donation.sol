// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract donate {

    uint256  goal;
    uint256 progress;

    address owner;

    constructor(uint256 goal_){

        owner=msg.sender;
        goal=goal_;
    }

    function deposit() external payable {
        require(msg.value>=1 ether, "The least to send is 1 ether");
        progress = progress + msg.value;
    }

    function withdraw() external {
        require(msg.sender == owner, "only the owner can withdraw");
        require(progress >= goal,"");

         uint256 balance = address(this).balance;

        payable(owner).transfer(balance);
    }

}
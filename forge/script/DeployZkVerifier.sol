// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "src/ZKAverage.sol";
import "src/ZKHash.sol";

contract DeployZkVerifier is Script {
  ZKAverage averageVerifier;
  ZKHash hashVerifier;

  function run() external {
    _setup();
  }

  function _setup() public {
    vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    averageVerifier = new ZKAverage();
    hashVerifier = new ZKHash();
    vm.stopBroadcast();
  }
 }
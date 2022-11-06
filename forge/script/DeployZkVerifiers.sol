// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "src/ZKAverage.sol";


// firstDeploy: 0xBD93BDaff48C1273b7bc709781C6B35B40C19569 
contract DeployZkVerifier is Script {
  ZKAverage averageVerifier;

  function run() external {
    _setup();
  }

  function _setup() public {
    vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    averageVerifier = new ZKAverage();
    vm.stopBroadcast();
  }
 }
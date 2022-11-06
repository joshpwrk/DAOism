// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "src/WorkAgreement.sol";

// deploy: $ forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/MyContract.sol:MyContract

// firstDeploy: 0xBD93BDaff48C1273b7bc709781C6B35B40C19569 
contract Deploy is Script {
  WorkAgreement work;

  function run() external {
    _setup();
  }

  function _setup() public {
    vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    work = new WorkAgreement();
    vm.stopBroadcast();
  }
 }
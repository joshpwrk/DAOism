// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "src/WorkAgreement.sol";

// deploy: $ forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/MyContract.sol:MyContract

// seed: 


contract Seed is Script {
  WorkAgreement work;

  /* address setup */
  address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));
  address dao = vm.addr(vm.envUint("DAO_PRIVATE_KEY"));

  /* salaries */
  uint[30] salaries = [
    148_250e18, 115_000e18, 138_000e18, 143_000e18, 158_000e18, // des1
    168_250e18, 135_000e18, 168_000e18, 163_000e18, 178_000e18, // des2
    105_250e18, 110_000e18, 95_000e18, 79_000e18, 45_000e18, // eng1
    145_250e18, 156_000e18, 200_000e18, 179_000e18, 145_000e18, // eng2
    100_250e18, 99_000e18, 88_000e18, 104_000e18, 105_000e18, // mar1
    120_250e18, 109_000e18, 134_000e18, 123_000e18, 115_000e18
  ]; // mar2

  /* addresses are simply vm.addr(i) in ascending order similar to salaries */
  uint secret = 12345; // used to hash salaries

  function run() external {
    _setup();
    _issueAgreements();
  }

  function _setup() public {
    vm.startBroadcast(deployer);
    work = new WorkAgreement();
    vm.stopBroadcast();
  }

  function _issueAgreements() public {
    vm.startBroadcast(dao);
    WorkAgreement.AgreementInput memory input;
    for (uint i; i < 30; i++) {
      bytes32 role;
      if (i < 5) { role = "DESIGNER_1"; } 
      else if (i >= 5 && i < 10) { role = "DESIGNER_2"; }
      else if (i >= 10 && i < 15) { role = "ENGINEER_1"; }
      else if (i >= 15 && i < 20) { role = "ENGINEER_2"; }
      else if (i >= 20 && i < 25) { role = "MARKETING_1"; }
      else { role = "MARKETING_2"; }

      input = WorkAgreement.AgreementInput({
        recipient: vm.addr(i+1), // first one is the employer
        startDate: block.timestamp, // can change later
        endDate: 0,
        role: role,// bytes 32 string, assume ENUM? to keep simple?
        salaryFromHash: keccak256(abi.encodePacked(secret, salaries[i])) // hash(secretEmpr, salary)
      });
      work.issueAgreement(input);
    }
    vm.stopBroadcast();
  }

 }
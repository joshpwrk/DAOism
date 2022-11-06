// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "src/WorkAgreement.sol";
import "forge-std/console2.sol";

contract Seed is Script {
  WorkAgreement work;

  /* address setup */
  // address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));
  // address dao = vm.addr(vm.envUint("DAO_PRIVATE_KEY"));

  /* salaries */
  uint[10] salaries = [
    148_250, 115_000, 138_000, 143_000, 158_000, // eng1
    168_250, 135_000, 168_000, 163_000, 178_000 // des1
  ]; // mar2

  /* addresses are simply vm.addr(i) in ascending order similar to salaries */
  uint secret = 12345; // used to hash salaries

  function run() external {
    work = WorkAgreement(0x4DE482E4eF823F42f32Eea59c51D09FA6CAb5eb0);
    _issueAgreements();
  }

  function _issueAgreements() public {
    WorkAgreement.AgreementInput memory input;
    vm.startBroadcast(vm.envUint("DAO_PRIVATE_KEY"));
    for (uint i; i < 10; i++) {
      bytes32 role;
      if (i < 5) { role = "ENGINEER_1"; } 
      else { role = "DESIGNER_1"; }

      // console2.log(vm.addr(i+1));
      // console2.log(i, salaries[i]);

      input = WorkAgreement.AgreementInput({
        recipient: vm.addr(i+1), // first one is the employer
        startDate: block.timestamp, // can change later
        endDate: 0,
        role: role,// bytes 32 string, assume ENUM? to keep simple?
        salaryHash: sha256(abi.encode(secret, salaries[i])) // hash(secret, salary)
      });
      work.issueAgreement(input);
    }
    vm.stopBroadcast();
  }

 }
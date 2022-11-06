// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "src/WorkAgreement.sol";


contract WorkAgreementTest is Test {
  /* salaries */
  uint salary = 148_250;

  /* addresses are simply vm.addr(i) in ascending order similar to salaries */
  uint secret = 12345; // used to hash salaries

  function testRun() external {
   console.logBytes32(sha256(abi.encode(secret, salary)));
    console.logBytes32(sha256(abi.encode(secret, 148249999999999997378560)));
  }

  function testGetArrayOfBytes() external {
    bytes32 hashToSplit = "0xb4a96241fb6f6f221063d4a5f80e1b5c8845c8f952a43c4f6d2d44058b1338cb";
    for (uint i; i < 4; i++) {
        console2.logBytes1(hashToSplit[i]);
    }
}
  }
 }
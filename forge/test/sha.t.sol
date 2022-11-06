// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "src/WorkAgreement.sol";


contract WorkAgreementTest is Test {
  /* salaries */
  uint salary = 148_250;

  /* addresses are simply vm.addr(i) in ascending order similar to salaries */
  uint secret = 12345; // used to hash salaries

  function testRun() external view {
   console.logBytes32(sha256(abi.encode(secret, salary)));
    console.logBytes32(sha256(abi.encode(secret, 148249999999999997378560)));
  }

  function testGetArrayOfBytes() external pure {
    bytes32 hashToSplit = sha256(abi.encode(uint(1), uint(2)));
    uint256 numHash = uint256(hashToSplit);
    // console2.log("val to split", numHash);

    uint16[16] memory splitHash;
    for (uint j; j < 16; j++) {
        splitHash[j] = uint16((numHash >> 16 * j) & 65535);
        // console2.logUint(splitHash[j]);
    }

    //B4A96241FB6F6DBCB53BF7A4259A77CD0D04664348B999D18000000000000000
    //38CB

    // for (uint i; i < 4; i++) {
    //     console2.logBytes1(hashToSplit[i]);
    // }
  }
 }
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "src/WorkAgreement.sol";
import "src/ZKAverage.sol";
import "src/ZKHash.sol";


contract Prove is Script {
  WorkAgreement work;
  ZKAverage averageVerifier;
  ZKHash hashVerifier;

  function run() external {
    vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    work = WorkAgreement(0x4DE482E4eF823F42f32Eea59c51D09FA6CAb5eb0);
    averageVerifier = ZKAverage(0x61bF6080043bc5520d8c8BE8D44704eD0F45a8CD);
    hashVerifier = ZKHash(0xA8Dd58135c1b0Ddc452c01d4811F5910Fb4D1C28);

    doProof();
    vm.stopBroadcast();  
  }

  function doProof() public view {
    uint[2] memory averageSalaries;
    averageSalaries[0] = 140450;
    console2.log("averageSalaries", averageSalaries[0]);
    averageSalaries[1] = 162450;
    console2.log("averageSalaries", averageSalaries[1]);

    /* average polynomial proof */
    uint[2] memory avgPolyA;
    avgPolyA[0] = uint(0x1790a1654e1c48b24be6261cf041b1bafff5346abdc200def1cddb1552204d6b);
    console2.log("avgPolyA", avgPolyA[0]);
    avgPolyA[1] = uint(0x12d38a2ebb36456b63593d9a3dbabf968a3f142be996d77367d0ec95aac32694);
    console2.log("avgPolyA", avgPolyA[1]);

    uint[2][2] memory avgPolyB;
    avgPolyB[0][0] = uint(0x2982488510f818c8694ec1e0ad703b1dbad741ff06ecc98efacfd47f00aa0b90);
    console2.log("avgPolyB", avgPolyB[0][0]);
    avgPolyB[0][1] = uint(0x179df043ee026dd133c1b7f6945862be8a63d3a80c7f9bfc1f7b39f4cd1d6c3a);
    console2.log("avgPolyB", avgPolyB[0][1]);
    avgPolyB[1][0] = uint(0x157dbdd3e0376ab0e67569cdba838c832ce335b21a6edc86ba0b8e01d78bcdd2);
    console2.log("avgPolyB", avgPolyB[1][0]);
    avgPolyB[1][1] = uint(0x2a481bf470490effd04ff63489d5d0385e70069dc3791b96b4abfa172a27c33c);
    console2.log("avgPolyB", avgPolyB[1][1]);

    uint[2] memory avgPolyC;
    avgPolyC[0] = uint(0x084c150a77707a5d19e697e80b78798d007e62a38e1aeaffc96d246a1b7e6c87);
    console2.log("avgPolyC", avgPolyC[0]);
    avgPolyC[1] = uint(0x08dccdc38e5951252bd2763c9263b68acb931dae830d86f27c8618a75cdc3b8a);
    console2.log("avgPolyC", avgPolyC[1]);

    /* hash polynomial proof */
    uint[2] memory hashPolyA;
    hashPolyA[0] = uint(0x2a1c0d521d55855cab8e834516baf0f69c57677e6a25ef54cf842353ba74bcf6);
    console2.log("hashPolyA", hashPolyA[0]);
    hashPolyA[1] = uint(0x1147509acda3ac0c8f13263c70987a33600b02f5fdecbf41a60e308f8f07475d);
    console2.log("hashPolyA", hashPolyA[1]);

    uint[2][2] memory hashPolyB;
    hashPolyB[0][0] = uint(0x02f7824c5084200163db8cf6ab5adf58ab4b6fe1b68aa0a78c2e7820111642a0);
    console2.log("hashPolyB", hashPolyB[0][0]);

    hashPolyB[0][1] = uint(0x164b7fb74186442f2478d2c867f4fa935ce4dd30d90513a3c4c442d9a0628942);
    console2.log("hashPolyB", hashPolyB[0][1]);

    hashPolyB[1][0] = uint(0x04daef2617a5c16aa7fdf6afd60d9b7a35083787ba338353cf4abd35949451de);
    console2.log("hashPolyB", hashPolyB[1][0]);

    hashPolyB[1][1] = uint(0x15a69d92f4619f243340235ee0bc9e8231b4c77a9af24aace88fb5555a61671f);
    console2.log("hashPolyB", hashPolyB[1][1]);

    uint[2] memory hashPolyC;
    hashPolyC[0] = uint(0x015a0fed9118aadf393c44111c210693e8b25fd5e67b9274d6e7c851071ee1c9);
    console2.log("hashPolyC", hashPolyC[0]);

    hashPolyC[1] = uint(0x126d821f2bb4986e471807460edd53faa8ecea60a46df0b1a45e5cc7ea5cb342);
    console2.log("hashPolyC", hashPolyC[1]); 



    work.submitAverageSalaryProof(
      address(averageVerifier), 
      averageSalaries, 
      avgPolyA,
      avgPolyB,
      avgPolyC,
      address(hashVerifier), // slot in hash verifier
      hashPolyA,
      hashPolyB,
      hashPolyC
    );
  }

 }
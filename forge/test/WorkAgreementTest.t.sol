// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "src/WorkAgreement.sol";
import "src/ZKAverage.sol";
import "src/ZKHash.sol";


contract WorkAgreementTest is Test {
  WorkAgreement work;
  ZKAverage averageVerifier;
  ZKHash hashVerifier;

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

  function setUp() external {
    vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    work = new WorkAgreement();
    averageVerifier = new ZKAverage();
    hashVerifier = new ZKHash();
    vm.stopBroadcast();
  }

  function testRun() external {
    _issueAgreements();
  }

  function testProof() external view {
    uint[2] memory averageSalaries;
    averageSalaries[0] = 30;
    averageSalaries[1] = 80;

    /* average polynomial proof */
    uint[2] memory avgPolyA;
    avgPolyA[0] = uint(0x1e3b38a48c3187b08799478d8d60ccb03bd7485e0df79f65be6e4e6ddd8af911);
    avgPolyA[1] = uint(0x1c35b184cdf4687f2f00e46a1f0854c8d792398d56dc07298054873a7106005a);

    uint[2][2] memory avgPolyB;
    avgPolyB[0][0] = uint(0x21f659598007ee92a8ed3a6515dcdff9c577c2d0bebbfb39b0ee018e20be1fca);
    avgPolyB[0][1] = uint(0x0fd77325a8258971e7a2c2361101b736adb6329db08965c81abe9f63b9a8badf);
    avgPolyB[1][0] = uint(0x1adec63955abb10996be846e15a7b7c94bfbee836c24df8593b528e6f4576f11);
    avgPolyB[1][1] = uint(0x008c9821c773966a1f848db5de93c61cd5b810a68b48e41a98bf977aa7430897);

    uint[2] memory avgPolyC;
    avgPolyC[0] = uint(0x261f0ef778518d0388e0ddf82c44a26fdc3b715df7fee298690c1f6caca43cce);
    avgPolyC[1] = uint(0x16d9bf7ad3e3a6e7cf32d5224c9bf4c1e2052c8b6b7f00a37dbe44abeef0919b);

    /* hash polynomial proof */
    uint[2] memory hashPolyA;
    avgPolyA[0] = uint(0x2a1c0d521d55855cab8e834516baf0f69c57677e6a25ef54cf842353ba74bcf6);
    avgPolyA[1] = uint(0x1147509acda3ac0c8f13263c70987a33600b02f5fdecbf41a60e308f8f07475d);

    uint[2][2] memory hashPolyB;
    avgPolyB[0][0] = uint(0x02f7824c5084200163db8cf6ab5adf58ab4b6fe1b68aa0a78c2e7820111642a0);
    avgPolyB[0][1] = uint(0x164b7fb74186442f2478d2c867f4fa935ce4dd30d90513a3c4c442d9a0628942);
    avgPolyB[1][0] = uint(0x04daef2617a5c16aa7fdf6afd60d9b7a35083787ba338353cf4abd35949451de);
    avgPolyB[1][1] = uint(0x15a69d92f4619f243340235ee0bc9e8231b4c77a9af24aace88fb5555a61671f);

    uint[2] memory hashPolyC;
    avgPolyC[0] = uint(0x015a0fed9118aadf393c44111c210693e8b25fd5e67b9274d6e7c851071ee1c9);
    avgPolyC[1] = uint(0x126d821f2bb4986e471807460edd53faa8ecea60a46df0b1a45e5cc7ea5cb342);


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

  function _issueAgreements() public {
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
        salaryHash: sha256(abi.encode(secret, salaries[i])) // hash(secret, salary)
      });
      vm.startBroadcast(vm.envUint("DAO_PRIVATE_KEY"));
      work.issueAgreement(input);
      vm.stopBroadcast();
    }
  }
 }
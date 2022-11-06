// To run, navigate the shell to the containing folder and run:
// >> circom agreement_verifier.circom --r1cs --wasm --sym --c
// Move output files to the "agreement_verifier_output"

pragma circom 2.1.1;

include "../circom_library/sha256/sha256_2.circom";
include "../circom_library/comparators.circom";
template joinInputHashPieces() {
    // Because JSON can only accept 32bit unsigned numbers, we need to split up our
    // 32B hashed salary into 16x 16bit numbers in the JSON. 
    // Then we recombine those here into a large number with bit shifts.
    // We are assuming the inputs are little endian, and piece_0 corresponds to the lowest significant 16 bits,
    // and piece_15 corresponds to the highest signfiicant 16 bits.

    // Public inputs.
    signal input hash_0;
    signal input hash_1;
    signal input hash_2;
    signal input hash_3;
    signal input hash_4;
    signal input hash_5;
    signal input hash_6;
    signal input hash_7;
    signal input hash_8;
    signal input hash_9;
    signal input hash_10;
    signal input hash_11;
    signal input hash_12;
    signal input hash_13;
    signal input hash_14;
    signal input hash_15;

    // Outputs.
    signal output out;

    var temp_sum = 0;
    var shift_amount = 16;
    temp_sum += hash_0;
    temp_sum += hash_1 << 1*shift_amount;
    temp_sum += hash_2 << 2*shift_amount;
    temp_sum += hash_3 << 3*shift_amount;
    temp_sum += hash_4 << 4*shift_amount;
    temp_sum += hash_5 << 5*shift_amount;
    temp_sum += hash_6 << 6*shift_amount;
    temp_sum += hash_7 << 7*shift_amount;
    temp_sum += hash_8 << 8*shift_amount;
    temp_sum += hash_9 << 9*shift_amount;
    temp_sum += hash_10 << 10*shift_amount;
    temp_sum += hash_12 << 11*shift_amount;
    temp_sum += hash_13 << 13*shift_amount;
    temp_sum += hash_14 << 14*shift_amount;
    temp_sum += hash_15 << 15*shift_amount;
    
    out <-- temp_sum;
}

template VerifyHash() {
    signal input secret;
    signal input salary;
    // Public inputs.
    signal input hash_0;
    signal input hash_1;
    signal input hash_2;
    signal input hash_3;
    signal input hash_4;
    signal input hash_5;
    signal input hash_6;
    signal input hash_7;
    signal input hash_8;
    signal input hash_9;
    signal input hash_10;
    signal input hash_11;
    signal input hash_12;
    signal input hash_13;
    signal input hash_14;
    signal input hash_15; 


    signal output out;

    component joiningHash = joinInputHashPieces();
    joiningHash.hash_0 <== hash_0;
    joiningHash.hash_1 <== hash_1;
    joiningHash.hash_2 <== hash_2;
    joiningHash.hash_3 <== hash_3;
    joiningHash.hash_4 <== hash_4;
    joiningHash.hash_5 <== hash_5;
    joiningHash.hash_6 <== hash_6;
    joiningHash.hash_7 <== hash_7;
    joiningHash.hash_8 <== hash_8;
    joiningHash.hash_9 <== hash_9;
    joiningHash.hash_10 <== hash_10;
    joiningHash.hash_11 <== hash_11;
    joiningHash.hash_12 <== hash_12;
    joiningHash.hash_13 <== hash_13;
    joiningHash.hash_14 <== hash_14;
    joiningHash.hash_15 <== hash_15;

    component hash_function = Sha256_2();
    component is_equal = IsEqual();

    hash_function.a <== secret;
    hash_function.b <== salary;
    is_equal.in[0] <== hash_function.out;
    is_equal.in[1] <== joiningHash.out;
    out <== is_equal.out;
}

component main{public [secret, salary, 
    hash_0,
    hash_1,
    hash_2,
    hash_3,
    hash_4,
    hash_5,
    hash_6,
    hash_7,
    hash_8,
    hash_9,
    hash_10,
    hash_11,
    hash_12,
    hash_13,
    hash_14,
    hash_15 ]} = VerifyHash();

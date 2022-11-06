// To run, navigate the shell to the containing folder and run:
// >> circom agreement_verifier.circom --r1cs --wasm --sym --c
// Move output files to the "agreement_verifier_output"

pragma circom 2.1.1;

include "../circom_library/sha256/sha256_2.circom";
include "../circom_library/comparators.circom";


template VerifyHash() {
    // Private inputs.
    signal input secret;
    signal input salary;

    // Public inputs.
    signal input salary_hash;

    signal output out;

    component hash_function = Sha256_2();
    component is_equal = IsEqual();

    hash_function.a <== secret;
    hash_function.b <== salary;
    is_equal.in[0] <== hash_function.out;
    is_equal.in[1] <== salary_hash;
    out <== is_equal.out;
}

component main{public [salary_hash ]} = VerifyHash();

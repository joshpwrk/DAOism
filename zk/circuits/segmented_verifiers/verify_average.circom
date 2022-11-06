// To run, navigate the shell to the containing folder and run:
// >> circom agreement_verifier.circom --r1cs --wasm --sym --c
// Move output files to the "agreement_verifier_output"

pragma circom 2.1.1;

include "../circom_library/sha256/sha256_2.circom";
include "../circom_library/comparators.circom";
include "../circom_library/gates.circom";

template VerifyAverage() {
    // Private inputs.
    signal input list_of_salaries[10];

    // Public inputs.
    signal input average_of_salaries[2];

    signal output out;

    var true_salary_averages[2]; 
    var role_capacity = 5; // This should not change.
    for (var roles = 0; roles < 2; roles++) {
        true_salary_averages[roles] = 0;
        for (var person = 0; person < role_capacity; person++) {
            true_salary_averages[roles] += list_of_salaries[roles*role_capacity + person];
        }
        true_salary_averages[roles] /= role_capacity;
    }

    var truth_counter = 0;
    component are_averages_equal_components[2] ;
    for (var i = 0; i < 2; i++) {
        are_averages_equal_components[i] = IsEqual();
        are_averages_equal_components[i].in[0] <== true_salary_averages[i];
        are_averages_equal_components[i].in[1] <== average_of_salaries[i];
        truth_counter += are_averages_equal_components[i].out;
    }

    component final_comparator = IsEqual();
    final_comparator.in[0] <== 2;
    final_comparator.in[1] <== truth_counter;
    out <== final_comparator.out;
}

component main{public [average_of_salaries]} = VerifyAverage();
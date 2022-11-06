pragma circom 2.1.1;
include "../circom_library/comparators.circom";

template Test() {
    signal input a;
    signal input b;
    signal output equalOut;
    signal output zeroOut;

    component is_equal = IsEqual();
    is_equal.in[0] <== a;
    is_equal.in[1] <== b;
    equalOut <== is_equal.out;

    component is_zero = IsZero();
    is_zero.in <== a;
    zeroOut <== is_zero.out;
}

component main{public [a, b]} = Test();
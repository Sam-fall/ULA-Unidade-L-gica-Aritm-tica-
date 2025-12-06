
module add_sub (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    input Ctr,      // 1 para subtrair
    output [7:0] S,
    output Cout
);

    wire [6:0] C_interno; 
    wire [7:0] B_xor;
    wire Cin_or;

    assign B_xor  = B   ^ {8{Ctr}};
    assign Cin_or = Cin | Ctr;

    full_adder fa0 (
        .A(A[0]), 
        .B(B_xor[0]), 
        .Cin(Cin_or), 
        .S(S[0]), 
        .Cout(C_interno[0])
    );

    full_adder fa1 (
        .A(A[1]), 
        .B(B_xor[1]), 
        .Cin(C_interno[0]), 
        .S(S[1]), 
        .Cout(C_interno[1])
    );

    full_adder fa2 (
        .A(A[2]), 
        .B(B_xor[2]), 
        .Cin(C_interno[1]), 
        .S(S[2]), 
        .Cout(C_interno[2])
    );

    full_adder fa3 (
        .A(A[3]), 
        .B(B_xor[3]), 
        .Cin(C_interno[2]), 
        .S(S[3]), 
        .Cout(C_interno[3])
    );

    full_adder fa4 (
        .A(A[4]), 
        .B(B_xor[4]), 
        .Cin(C_interno[3]), 
        .S(S[4]), 
        .Cout(C_interno[4])
    );

    full_adder fa5 (
        .A(A[5]), 
        .B(B_xor[5]), 
        .Cin(C_interno[4]), 
        .S(S[5]), 
        .Cout(C_interno[5])
    );

    full_adder fa6 (
        .A(A[6]), 
        .B(B_xor[6]), 
        .Cin(C_interno[5]), 
        .S(S[6]), 
        .Cout(C_interno[6])
    );

    full_adder fa7 (
        .A(A[7]), 
        .B(B_xor[7]), 
        .Cin(C_interno[6]), 
        .S(S[7]), 
        .Cout(Cout) 
    );

endmodule


module full_adder (
    input  A, 
    input  B, 
    input  Cin,
    output S, 
    output Cout
);

    wire w1, w2, w3, w4;

    xor n1 (w1,   A,  B);
    xor n2 (S,    w1, Cin);
    and n3 (w2,   A,  B);
    and n4 (w3,   B,  Cin);
    and n5 (w4,   A,  Cin);
    or  n6 (Cout, w2, w3, w4);

endmodule


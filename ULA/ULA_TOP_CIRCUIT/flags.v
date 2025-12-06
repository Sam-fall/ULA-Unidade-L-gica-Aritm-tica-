module flags (
    input C_add_sub,    // Carry out somador/subtrator
    input [7:0] C_mul,  // Carry out multiplicador (os 8bits MSB)
    input A_msb,        // Bit mais significativo barramento A
    input B_msb,        // Bit mais significativo barramento B
    input [7:0] R_ula,  // Resultado (saida) da ULA
    input [4:0] Opcode,
    output Z,
    output N,
    output C,
    output V
);

//==============================//
//--------Opcode Decoder--------//
//==============================//
    wire is_add_sub, is_mul;
    wire w1_nor_decoder; 

    // É ADD ou SUB?
    assign is_add_sub = ~ ( | Opcode[4:1]);
    
    // É MUL?
    assign w1_nor_decoder = ~ ( | {Opcode[4:2], Opcode[0]});
    assign is_mul         = w1_nor_decoder & Opcode[1]; 

//====================//
//--------Zero--------//
//====================//
    assign Z = ~ ( | R_ula);

//========================//
//--------Negativo--------//
//========================//
    assign N = R_ula[7];

//=====================//
//--------Carry--------//
//=====================//
    wire w1_C_mul_or; 

    // Carry/Overflow MUL
    assign w1_C_mul_or = ( | C_mul);

    // Carry out ULA
    assign C = (C_add_sub & is_add_sub) | (w1_C_mul_or & is_mul);

//========================//
//--------Overflow--------//
//========================//
    wire w1_xor_B_sub;
    wire w1_xnor_v, w1_xor_v, w2_and_v;
    wire w1_V_mul_or;

    // Precisamos inverter o B se for subtração (Opcode[0]=1) para o XNOR funcionar
    assign w1_xor_B_sub = B_msb ^ Opcode[0];

    // Overflow ADD e SUB
    assign w1_xnor_v = ~ (A_msb ^ w1_xor_B_sub);
    assign w1_xor_v  =   (A_msb ^ R_ula[7]);  
    assign w2_and_v  =   (w1_xnor_v & w1_xor_v);

    // Overflow MUL
    assign w1_V_mul_or = w1_C_mul_or; // No MUL o Overflow == Carry

    // Overflow out ULA
    assign V = (w2_and_v & is_add_sub) | (w1_V_mul_or & is_mul);

endmodule
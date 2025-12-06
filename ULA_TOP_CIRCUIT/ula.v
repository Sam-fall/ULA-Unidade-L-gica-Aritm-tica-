`include "add_sub.v"
`include "flags.v"
`include "logic.v"
`include "mul.v"
`include "mux.v"


module ula (
    input C_in,
    input  [7:0] A,
    input  [7:0] B,
    input  [4:0] Opcode, // Opcode de entrada
    output [7:0] R,      // Resultado Final
    output Z,
    output N,
    output C,
    output V
);

//=======================//
//--------ADD SUB--------//
//=======================//
    wire       w1_c_add_sub;
    wire [7:0] w2_out_add_sub;

    add_sub add_sub_00 (
        .A(A),
        .B(B),
        .Cin(C_in),
        .Ctr(Opcode[0]), // 0=Add, 1=Sub      
        .S(w2_out_add_sub),
        .Cout(w1_c_add_sub)
    );

    //===================//
    //--------MUL--------//
    //===================//
    wire [7:0]  w3_C_mul_high; // Parte alta para verificar overflow
    wire [15:0] w4_out_mul_full;
    
    assign w3_C_mul_high = w4_out_mul_full[15:8];

    mul mul_00 (
        .A(A),
        .B(B),
        .P_full(w4_out_mul_full)
    );

    //=====================//
    //--------LOGIC--------//
    //=====================//
    wire [7:0] w5_out_logic;

    logic logic_00 (
        .A(A),
        .B(B),
        .Opcode(Opcode[2:0]), // Envia 3 bits para o módulo lógico
        .Out(w5_out_logic)
    );

    //===========================//
    //--------MUX FINAL----------//
    //===========================//
    
    wire [7:0] w_result_final; // Fio que sai do Mux e vai para a saída R

    ula_mux_final mux_instancia (
        // --- Aritmética ---
        .in_add(w2_out_add_sub),      // Conectado
        .in_sub(w2_out_add_sub),      // Conectado (Add/Sub usam mesmo hardware)
        .in_mul(w4_out_mul_full[7:0]),// Conectado (8bits LSB)
        .in_div(8'b0),                // Futuro
        .in_slt(8'b0),                // Futuro (SLT)
        .in_seq(8'b0),                // Futuro (SEQ)
        
        // --- Lógica ---
        .in_and(w5_out_logic), 
        .in_nand(w5_out_logic), 
        .in_or(w5_out_logic), 
        .in_nor(w5_out_logic), 
        .in_xor(w5_out_logic), 
        .in_xnor(w5_out_logic), 
        .in_not(w5_out_logic),
        
        // --- Shifter (Futuro) ---
        .in_shl(8'b0), .in_srl(8'b0), .in_sra(8'b0), 
        .in_rol(8'b0), .in_ror(8'b0),
        
        // --- Controle e Saída ---
        .Opcode(Opcode),
        .Result_Out(w_result_final)
    );

    // Conecta à saída do módulo ULA
    assign R = w_result_final;

    //=====================//
    //--------FLAGS--------//
    //=====================//
    flags flags_00 (
        .C_add_sub(w1_c_add_sub),
        .C_mul(w3_C_mul_high),    // Passa os 8 bits altos
        .A_msb(A[7]),
        .B_msb(B[7]),
        .R_ula(w_result_final), 
        .Opcode(Opcode),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

endmodule
//=========================================================================//
//-------------------------------ula_mux_out-------------------------------//
//-----Multiplexador Central da ULA (Todas as seleções em um só lugar)-----//
//=========================================================================//

module mux (
    // --- Entradas Aritméticas (Categoria 00) ---
    input [7:0] in_add, 
    input [7:0] in_sub, 
    input [7:0] in_mul, 
    input [7:0] in_div, 
    input [7:0] in_slt, 
    input [7:0] in_seq,
    
    // --- Entradas Lógicas (Categoria 01) ---
    input [7:0] in_and, 
    input [7:0] in_nand, 
    input [7:0] in_or, 
    input [7:0] in_nor, 
    input [7:0] in_xor, 
    input [7:0] in_xnor, 
    input [7:0] in_not,
    
    // --- Entradas Shifter (Categoria 10) ---
    input [7:0] in_shl, 
    input [7:0] in_srl, 
    input [7:0] in_sra, 
    input [7:0] in_rol, 
    input [7:0] in_ror,
    
    // --- Controle ---
    input [4:0] Opcode, // [4:3] = Categoria, [2:0] = Operação
    
    // --- Saída Final ---
    output [7:0] Result_Out
);

    // Fios internos para guardar o "Vencedor" de cada categoria
    reg [7:0] w_res_arith;
    reg [7:0] w_res_logic;
    reg [7:0] w_res_shifter;
    
    reg [7:0] w_res_final;

//====================================================//
//----------SELEÇÃO ARITMÉTICA (Opcode[2:0])----------//
//====================================================//
    always @(*) begin
        case (Opcode[2:0])
            3'b000: w_res_arith   = in_add;
            3'b001: w_res_arith   = in_sub;
            3'b010: w_res_arith   = in_mul;
            3'b011: w_res_arith   = in_div;
            3'b100: w_res_arith   = in_slt;
            3'b101: w_res_arith   = in_seq;
            default: w_res_arith  = 8'b0;
        endcase
    end

//================================================//
//----------SELEÇÃO LÓGICA (Opcode[2:0])----------//
//================================================//
    always @(*) begin
        case (Opcode[2:0])
            3'b000: w_res_logic   = in_and;
            3'b001: w_res_logic   = in_nand;
            3'b010: w_res_logic   = in_or;
            3'b011: w_res_logic   = in_nor;
            3'b100: w_res_logic   = in_xor;
            3'b101: w_res_logic   = in_xnor;
            3'b110: w_res_logic   = in_not;
            default: w_res_logic  = 8'b0;
        endcase
    end

//=================================================//
//----------SELEÇÃO SHIFTER (Opcode[2:0])----------//
//=================================================//
    always @(*) begin
        case (Opcode[2:0])
            3'b000: w_res_shifter = in_shl;
            3'b001: w_res_shifter = in_srl;
            3'b010: w_res_shifter = in_sra;
            3'b011: w_res_shifter = in_rol;
            3'b100: w_res_shifter = in_ror;
            default: w_res_shifter = 8'b0;
        endcase
    end

//================================================================//
//----------Seleciona o tipo de operação com Opcode[4:3]----------//
//================================================================//
    always @(*) begin
        case (Opcode[4:3])
            2'b00: w_res_final    = w_res_arith;   // Pega resultado da Aritmética
            2'b01: w_res_final    = w_res_logic;   // Pega resultado da Lógica
            2'b10: w_res_final    = w_res_shifter; // Pega resultado do Shifter
            default: w_res_final  = 8'b0;          // Segurança
        endcase
    end

    // Conecta o resultado escolhido à saída
    assign Result_Out = w_res_final;

endmodule
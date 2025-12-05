module logic_mux_style (
    input [7:0] A,
    input [7:0] B,
    input [2:0] Opcode,
    output [7:0] Out
);

    reg [7:0] selected_logic; // 'reg' porque recebe valor dentro do always

    always @(*) begin
        case (Opcode[2:1]) 
            2'b00: selected_logic = A & B; // AND
            2'b01: selected_logic = A | B; // OR
            2'b10: selected_logic = A ^ B; // XOR
            2'b11: selected_logic = ~A;    // NOT
            default: selected_logic = 8'b0;
        endcase
    end

    assign Out = selected_logic ^ {8{Opcode[0]}}; //Opcode 0 fica igual, Opcode 1 inverte

endmodule
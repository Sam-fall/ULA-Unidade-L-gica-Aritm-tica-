//Opcode
//bit LSB = 1 inverte o valor, 0 fica igual
//2bits MSM = 00 A and B 
//            01 A or  B
//            10 A xor B
//            11   not A 

module logic (
    input [7:0] A,
    input [7:0] B,
    input [2:0] Opcode,
    output [7:0] Out
);

    reg [7:0] selected_logic; 

    always @(*) begin
        case (Opcode[2:1]) 
            2'b00: selected_logic = A & B;
            2'b01: selected_logic = A | B;
            2'b10: selected_logic = A ^ B; 
            2'b11: selected_logic = ~A;    
            default: selected_logic = 8'b0;
        endcase
    end

    assign Out = selected_logic ^ {8{Opcode[0]}}; 

endmodule
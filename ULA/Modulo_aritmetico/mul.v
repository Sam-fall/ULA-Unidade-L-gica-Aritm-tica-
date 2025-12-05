module mul (
    input [7:0] A,
    input [7:0] B,
    output [15:0] P_full
);

    wire [7:0] ab_and [0:7];
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : gera_ands
            assign ab_and[i] = B & {8{A[i]}};
        end
    endgenerate

    // Ligaçoes internas (Somas e Carries)
    // Nomenclatura: w_s_c{COLUNA}_st{ESTAGIO} -> w_s... para soma e w_c... para carry
    // "st" (stage) é o número do somador dentro daquela coluna, de cima para baixo
    
    // Fios da Coluna 1
    wire w_c_c1_st0;

    // Fios da Coluna 2
    wire w_s_c2_st0, w_c_c2_st0, w_c_c2_st1;

    // Fios da Coluna 3
    wire w_s_c3_st0, w_c_c3_st0, w_s_c3_st1, w_c_c3_st1, w_c_c3_st2;

    // Fios da Coluna 4
    wire w_s_c4_st0, w_c_c4_st0, w_s_c4_st1, w_c_c4_st1, w_s_c4_st2, w_c_c4_st2, w_c_c4_st3;

    // Fios da Coluna 5
    wire w_s_c5_st0, w_c_c5_st0, w_s_c5_st1, w_c_c5_st1, w_s_c5_st2, w_c_c5_st2, w_s_c5_st3, w_c_c5_st3, w_c_c5_st4;

    // Fios da Coluna 6
    wire w_s_c6_st0, w_c_c6_st0, w_s_c6_st1, w_c_c6_st1, w_s_c6_st2, w_c_c6_st2, w_s_c6_st3, w_c_c6_st3, w_s_c6_st4, w_c_c6_st4, w_c_c6_st5;

    // Fios da Coluna 7
    wire w_s_c7_st0, w_c_c7_st0, w_s_c7_st1, w_c_c7_st1, w_s_c7_st2, w_c_c7_st2, w_s_c7_st3, w_c_c7_st3, w_s_c7_st4, w_c_c7_st4, w_s_c7_st5, w_c_c7_st5, w_c_c7_st6;

    // Fios da Coluna 8
    wire w_s_c8_st0, w_c_c8_st0, w_s_c8_st1, w_c_c8_st1, w_s_c8_st2, w_c_c8_st2, w_s_c8_st3, w_c_c8_st3, w_s_c8_st4, w_c_c8_st4, w_s_c8_st5, w_c_c8_st5, w_c_c8_st6;

    // Fios da Coluna 9
    wire w_s_c9_st0, w_c_c9_st0, w_s_c9_st1, w_c_c9_st1, w_s_c9_st2, w_c_c9_st2, w_s_c9_st3, w_c_c9_st3, w_s_c9_st4, w_c_c9_st4, w_c_c9_st5;

    // Fios da Coluna 10
    wire w_s_c10_st0, w_c_c10_st0, w_s_c10_st1, w_c_c10_st1, w_s_c10_st2, w_c_c10_st2, w_s_c10_st3, w_c_c10_st3, w_c_c10_st4;

    // Fios da Coluna 11
    wire w_s_c11_st0, w_c_c11_st0, w_s_c11_st1, w_c_c11_st1, w_s_c11_st2, w_c_c11_st2, w_c_c11_st3;

    // Fios da Coluna 12
    wire w_s_c12_st0, w_c_c12_st0, w_s_c12_st1, w_c_c12_st1, w_c_c12_st2;

    // Fios da Coluna 13
    wire w_s_c13_st0, w_c_c13_st0, w_c_c13_st1;

    // Fios da Coluna 14
    wire w_c_c14_st0;


    //-------------------------------------------------------------------------
    // IMPLEMENTAÇÃO DAS COLUNAS
    // Lembrete: ab_and[LINHA_B][COLUNA_A] -> A soma dos índices é a coluna P
    //-------------------------------------------------------------------------

    //--------- COLUNA 0 ---------
    assign P_full[0] = ab_and[0][0];

    //--------- COLUNA 1 ---------
    half_adder ha_c1_st0 (.A(ab_and[1][0]), .B(ab_and[0][1]), .S(P_full[1]), .C(w_c_c1_st0)); // Carry vai para Col 2

    //--------- COLUNA 2 ---------
    half_adder ha_c2_st0 (.A(ab_and[2][0]), .B(ab_and[1][1]), .S(w_s_c2_st0),   .C(w_c_c2_st0));
    full_adder fa_c2_st1 (.A(w_s_c2_st0),   .B(ab_and[0][2]), .Cin(w_c_c1_st0), .S(P_full[2]),  .Cout(w_c_c2_st1));

    //--------- COLUNA 3 ---------
    half_adder ha_c3_st0 (.A(ab_and[3][0]), .B(ab_and[2][1]), .S(w_s_c3_st0),   .C(w_c_c3_st0));
    full_adder fa_c3_st1 (.A(w_s_c3_st0),   .B(ab_and[1][2]), .Cin(w_c_c2_st0), .S(w_s_c3_st1), .Cout(w_c_c3_st1));
    full_adder fa_c3_st2 (.A(w_s_c3_st1),   .B(ab_and[0][3]), .Cin(w_c_c2_st1), .S(P_full[3]),  .Cout(w_c_c3_st2));

    //--------- COLUNA 4 ---------
    half_adder ha_c4_st0 (.A(ab_and[4][0]), .B(ab_and[3][1]), .S(w_s_c4_st0),   .C(w_c_c4_st0));
    full_adder fa_c4_st1 (.A(w_s_c4_st0),   .B(ab_and[2][2]), .Cin(w_c_c3_st0), .S(w_s_c4_st1), .Cout(w_c_c4_st1));
    full_adder fa_c4_st2 (.A(w_s_c4_st1),   .B(ab_and[1][3]), .Cin(w_c_c3_st1), .S(w_s_c4_st2), .Cout(w_c_c4_st2));
    full_adder fa_c4_st3 (.A(w_s_c4_st2),   .B(ab_and[0][4]), .Cin(w_c_c3_st2), .S(P_full[4]),  .Cout(w_c_c4_st3));

    //--------- COLUNA 5 ---------
    half_adder ha_c5_st0 (.A(ab_and[5][0]), .B(ab_and[4][1]), .S(w_s_c5_st0),   .C(w_c_c5_st0));
    full_adder fa_c5_st1 (.A(w_s_c5_st0),   .B(ab_and[3][2]), .Cin(w_c_c4_st0), .S(w_s_c5_st1), .Cout(w_c_c5_st1));
    full_adder fa_c5_st2 (.A(w_s_c5_st1),   .B(ab_and[2][3]), .Cin(w_c_c4_st1), .S(w_s_c5_st2), .Cout(w_c_c5_st2));
    full_adder fa_c5_st3 (.A(w_s_c5_st2),   .B(ab_and[1][4]), .Cin(w_c_c4_st2), .S(w_s_c5_st3), .Cout(w_c_c5_st3));
    full_adder fa_c5_st4 (.A(w_s_c5_st3),   .B(ab_and[0][5]), .Cin(w_c_c4_st3), .S(P_full[5]),  .Cout(w_c_c5_st4));

    //--------- COLUNA 6 ---------
    half_adder ha_c6_st0 (.A(ab_and[6][0]), .B(ab_and[5][1]), .S(w_s_c6_st0),   .C(w_c_c6_st0));
    full_adder fa_c6_st1 (.A(w_s_c6_st0),   .B(ab_and[4][2]), .Cin(w_c_c5_st0), .S(w_s_c6_st1), .Cout(w_c_c6_st1));
    full_adder fa_c6_st2 (.A(w_s_c6_st1),   .B(ab_and[3][3]), .Cin(w_c_c5_st1), .S(w_s_c6_st2), .Cout(w_c_c6_st2));
    full_adder fa_c6_st3 (.A(w_s_c6_st2),   .B(ab_and[2][4]), .Cin(w_c_c5_st2), .S(w_s_c6_st3), .Cout(w_c_c6_st3));
    full_adder fa_c6_st4 (.A(w_s_c6_st3),   .B(ab_and[1][5]), .Cin(w_c_c5_st3), .S(w_s_c6_st4), .Cout(w_c_c6_st4));
    full_adder fa_c6_st5 (.A(w_s_c6_st4),   .B(ab_and[0][6]), .Cin(w_c_c5_st4), .S(P_full[6]),  .Cout(w_c_c6_st5));

    //--------- COLUNA 7 (Topo) ---------
    half_adder ha_c7_st0 (.A(ab_and[7][0]), .B(ab_and[6][1]), .S(w_s_c7_st0),   .C(w_c_c7_st0));
    full_adder fa_c7_st1 (.A(w_s_c7_st0),   .B(ab_and[5][2]), .Cin(w_c_c6_st0), .S(w_s_c7_st1), .Cout(w_c_c7_st1));
    full_adder fa_c7_st2 (.A(w_s_c7_st1),   .B(ab_and[4][3]), .Cin(w_c_c6_st1), .S(w_s_c7_st2), .Cout(w_c_c7_st2));
    full_adder fa_c7_st3 (.A(w_s_c7_st2),   .B(ab_and[3][4]), .Cin(w_c_c6_st2), .S(w_s_c7_st3), .Cout(w_c_c7_st3));
    full_adder fa_c7_st4 (.A(w_s_c7_st3),   .B(ab_and[2][5]), .Cin(w_c_c6_st3), .S(w_s_c7_st4), .Cout(w_c_c7_st4));
    full_adder fa_c7_st5 (.A(w_s_c7_st4),   .B(ab_and[1][6]), .Cin(w_c_c6_st4), .S(w_s_c7_st5), .Cout(w_c_c7_st5));
    full_adder fa_c7_st6 (.A(w_s_c7_st5),   .B(ab_and[0][7]), .Cin(w_c_c6_st5), .S(P_full[7]),  .Cout(w_c_c7_st6));

    //--------- COLUNA 8 ---------
    full_adder fa_c8_st0 (.A(ab_and[7][1]), .B(ab_and[6][2]), .Cin(w_c_c7_st0), .S(w_s_c8_st0), .Cout(w_c_c8_st0));
    full_adder fa_c8_st1 (.A(w_s_c8_st0),   .B(ab_and[5][3]), .Cin(w_c_c7_st1), .S(w_s_c8_st1), .Cout(w_c_c8_st1));
    full_adder fa_c8_st2 (.A(w_s_c8_st1),   .B(ab_and[4][4]), .Cin(w_c_c7_st2), .S(w_s_c8_st2), .Cout(w_c_c8_st2));
    full_adder fa_c8_st3 (.A(w_s_c8_st2),   .B(ab_and[3][5]), .Cin(w_c_c7_st3), .S(w_s_c8_st3), .Cout(w_c_c8_st3));
    full_adder fa_c8_st4 (.A(w_s_c8_st3),   .B(ab_and[2][6]), .Cin(w_c_c7_st4), .S(w_s_c8_st4), .Cout(w_c_c8_st4));
    full_adder fa_c8_st5 (.A(w_s_c8_st4),   .B(ab_and[1][7]), .Cin(w_c_c7_st5), .S(w_s_c8_st5), .Cout(w_c_c8_st5));
    // Os últimos estagios desta coluna em diantes, estão recebendo os carries da coluna anterior ex fa_c9_st5
    half_adder ha_c8_st6 (.A(w_s_c8_st5),   .B(w_c_c7_st6),   .S(P_full[8]),    .C(w_c_c8_st6));

    //--------- COLUNA 9 ---------
    full_adder fa_c9_st0 (.A(ab_and[7][2]), .B(ab_and[6][3]), .Cin(w_c_c8_st0), .S(w_s_c9_st0), .Cout(w_c_c9_st0));
    full_adder fa_c9_st1 (.A(w_s_c9_st0),   .B(ab_and[5][4]), .Cin(w_c_c8_st1), .S(w_s_c9_st1), .Cout(w_c_c9_st1));
    full_adder fa_c9_st2 (.A(w_s_c9_st1),   .B(ab_and[4][5]), .Cin(w_c_c8_st2), .S(w_s_c9_st2), .Cout(w_c_c9_st2));
    full_adder fa_c9_st3 (.A(w_s_c9_st2),   .B(ab_and[3][6]), .Cin(w_c_c8_st3), .S(w_s_c9_st3), .Cout(w_c_c9_st3));
    full_adder fa_c9_st4 (.A(w_s_c9_st3),   .B(ab_and[2][7]), .Cin(w_c_c8_st4), .S(w_s_c9_st4), .Cout(w_c_c9_st4));
    full_adder fa_c9_st5 (.A(w_s_c9_st4),   .B(w_c_c8_st5),   .Cin(w_c_c8_st6), .S(P_full[9]),  .Cout(w_c_c9_st5));

    //--------- COLUNA 10 ---------
    full_adder fa_c10_st0 (.A(ab_and[7][3]), .B(ab_and[6][4]), .Cin(w_c_c9_st0), .S(w_s_c10_st0), .Cout(w_c_c10_st0));
    full_adder fa_c10_st1 (.A(w_s_c10_st0),  .B(ab_and[5][5]), .Cin(w_c_c9_st1), .S(w_s_c10_st1), .Cout(w_c_c10_st1));
    full_adder fa_c10_st2 (.A(w_s_c10_st1),  .B(ab_and[4][6]), .Cin(w_c_c9_st2), .S(w_s_c10_st2), .Cout(w_c_c10_st2));
    full_adder fa_c10_st3 (.A(w_s_c10_st2),  .B(ab_and[3][7]), .Cin(w_c_c9_st3), .S(w_s_c10_st3), .Cout(w_c_c10_st3));
    full_adder fa_c10_st4 (.A(w_s_c10_st3),  .B(w_c_c9_st4),   .Cin(w_c_c9_st5), .S(P_full[10]),  .Cout(w_c_c10_st4));

    //--------- COLUNA 11 ---------
    full_adder fa_c11_st0 (.A(ab_and[7][4]), .B(ab_and[6][5]), .Cin(w_c_c10_st0), .S(w_s_c11_st0), .Cout(w_c_c11_st0));
    full_adder fa_c11_st1 (.A(w_s_c11_st0),  .B(ab_and[5][6]), .Cin(w_c_c10_st1), .S(w_s_c11_st1), .Cout(w_c_c11_st1));
    full_adder fa_c11_st2 (.A(w_s_c11_st1),  .B(ab_and[4][7]), .Cin(w_c_c10_st2), .S(w_s_c11_st2), .Cout(w_c_c11_st2));
    full_adder fa_c11_st3 (.A(w_s_c11_st2),  .B(w_c_c10_st3),  .Cin(w_c_c10_st4), .S(P_full[11]),  .Cout(w_c_c11_st3));

    //--------- COLUNA 12 ---------
    full_adder fa_c12_st0 (.A(ab_and[7][5]), .B(ab_and[6][6]), .Cin(w_c_c11_st0), .S(w_s_c12_st0), .Cout(w_c_c12_st0));
    full_adder fa_c12_st1 (.A(w_s_c12_st0),  .B(ab_and[5][7]), .Cin(w_c_c11_st1), .S(w_s_c12_st1), .Cout(w_c_c12_st1));
    full_adder fa_c12_st2 (.A(w_s_c12_st1),  .B(w_c_c11_st2),  .Cin(w_c_c11_st3), .S(P_full[12]),  .Cout(w_c_c12_st2));

    //--------- COLUNA 13 ---------
    full_adder fa_c13_st0 (.A(ab_and[7][6]), .B(ab_and[6][7]), .Cin(w_c_c12_st0), .S(w_s_c13_st0), .Cout(w_c_c13_st0));
    full_adder fa_c13_st1 (.A(w_s_c13_st0),  .B(w_c_c12_st1),  .Cin(w_c_c12_st2), .S(P_full[13]),  .Cout(w_c_c13_st1));

    //--------- COLUNA 14 ---------
    // Aqui soma o último termo com os carries que sobraram
    full_adder fa_c14_st0 (.A(ab_and[7][7]), .B(w_c_c13_st0),  .Cin(w_c_c13_st1), .S(P_full[14]),  .Cout(w_c_c14_st0));

    //--------- COLUNA 15 (Carry Final) ---------
    assign P_full[15] = w_c_c14_st0;

endmodule

module full_adder (
    input A, B, Cin,
    output S, Cout
);

    wire w1, w2, w3, w4;

    xor n1 (w1, A, B);
    xor n2 (S, w1, Cin);
    and n3 (w2, A, B);
    and n4 (w3, B, Cin);
    and n5 (w4, A, Cin);
    or n6 (Cout, w2, w3, w4);

endmodule

module half_adder(
    input A, B,
    output S, C
);

    xor n1 (S, A, B);
    and n2 (C, A, B);

endmodule 
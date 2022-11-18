// Tales Ribeiro Bezerra
// Roteiro 3


parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by
 
parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
          input  logic [NBITS_TOP-1:0] SWI,
          output logic [NBITS_TOP-1:0] LED,
          output logic [NBITS_TOP-1:0] SEG,
          output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
          output logic [NBITS_INSTR-1:0] lcd_instruction,
          output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
          output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
            lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData,
          output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);
 
 always_comb begin
   //SEG <= SWI;
   lcd_WriteData <= SWI;
   lcd_pc <= 'h12;
   lcd_instruction <= 'h34567890;
   lcd_SrcA <= 'hab;
   lcd_SrcB <= 'hcd;
   lcd_ALUResult <= 'hef;
   lcd_Result <= 'h11;
   lcd_ReadData <= 'h33;
   lcd_MemWrite <= SWI[0];
   lcd_Branch <= SWI[1];
   lcd_MemtoReg <= SWI[2];
   lcd_RegWrite <= SWI[3];
   for(int i=0; i<NREGS_TOP; i++)
      if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
      else                   lcd_registrador[i] <= ~SWI;
   lcd_a <= {56'h1234567890ABCD, SWI};
   lcd_b <= {SWI, 56'hFEDCBA09876543};
 end
 
  parameter zero = 'b00111111;
  parameter um = 'b00000110;
  parameter dois = 'b01011011;
  parameter tres = 'b01001111;
  parameter umNeg = 'b10000110;
  parameter doisNeg = 'b11011011;
  parameter tresNeg = 'b11001111;
  parameter quatroNeg = 'b11100110;
 
  logic signed [2:0] A;
  logic signed [2:0] B;
  logic [1:0] F;
  logic signed [2:0] SOMA;
  logic signed [2:0] SUB;
 
  always_comb begin
    A <= SWI[7:5];
    B <= SWI[2:0];
    F <= SWI[4:3];
  end
  assign SOMA = A + B;
  assign SUB = A - B;
 
  always_comb
    case (F)
      'b00: LED[2:0] <= SOMA;
      'b01: LED[2:0] <= SUB;
      'b10: LED[2:0] <= A & B;
      'b11: LED[2:0] <= A | B;
    endcase
  
  always_comb
    case(LED[2:0])
      'b100: SEG <= quatroNeg;
      'b101: SEG <= tresNeg;
      'b110: SEG <= doisNeg;
      'b111: SEG <= umNeg;
      'b000: SEG <= zero;
      'b001: SEG <= um;
      'b010: SEG <= dois;
      'b011: SEG <= tres;
    endcase

  always_comb 
    if ((F == 'b00) & (A[2] == B[2]) & (A[2] == 'b0) & (SOMA > 3'b011)) LED[7] <= 'b1;
    else if ((F == 'b00) & (A[2] == B[2]) & (A[2] == 'b1) & (SOMA < 3'b100)) LED[7] <= 'b1;
    else if ((F == 'b01) & (A[2] != B[2]) & (A[2] == 'b0) & (SUB > 3'b011)) LED[7] <= 'b1;
    else if ((F == 'b01) & (A[2] != B[2]) & (A[2] == 'b1) & (SUB < 3'b100)) LED[7] <= 'b1;
    else LED[7] <= 'b0;
 
endmodule

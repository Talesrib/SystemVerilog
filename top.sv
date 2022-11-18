// Tales Ribeiro Bezerra - 119210161
// Roteiro 5
 
parameter divide_by=200000000;  // divisor do clock de referência
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
  
  parameter NBITS_COUNT = 4;
  logic [NBITS_COUNT-1:0] Data_in, Count;
  logic reset, load, select_count, counter_on;

  always_comb reset <= SWI[0];
  always_comb select_count <= SWI[1];
  always_comb load <= SWI[2];
  always_comb counter_on <= SWI[3];
  always_comb Data_in <= SWI[7:4];

  always_ff @(posedge reset or posedge clk_2) begin
    if(reset) 
      Count <= 0;
    else if (load) 
      Count <= Data_in;
    else if (counter_on) begin
      if(select_count) Count <= Count - 1;
      else Count <= Count +1;
    end
  end

  always_comb LED[0] <= clk_2;
  always_comb LED[1] <= select_count;
  always_comb LED[7:4] <= Count;
  //Seg
  always_comb SEG[0] <= (Count[3] | Count[2] | Count[1] | ~Count[0]) & (Count[3] | ~Count[2] | Count[1] | Count[0]) & (~Count[3] | Count[2] | ~Count[1] | ~Count[0]) & (~Count[3] | ~Count[2] | Count[1] | ~Count[0]);
  
  always_comb SEG[1] <= (Count[3] | ~Count[2] | Count[1] | ~Count[0]) & (~Count[2] | ~Count[1] | Count[0]) & (~Count[3] | ~Count[1] | ~Count[0]) & (~Count[3] | ~Count[2] | Count[0]);
  
  always_comb SEG[2] <= (Count[3] | Count[2] | ~Count[1] | Count[0]) & (~Count[3] | ~Count[2] | Count[0]) & (~Count[3] | ~Count[2] | ~Count[1]);
  
  always_comb SEG[3] <= (Count[3] | Count[2] | Count[1] | ~Count[0]) & (Count[3] | ~Count[2] | Count[1] | Count[0]) & (~Count[2] | ~Count[1] | ~Count[0]) & (~Count[3] | Count[2] | ~Count[1] | Count[0]);
  
  always_comb SEG[4] <= (Count[3] | ~Count[0]) & (Count[3] | ~Count[2] | Count[1]) & (Count[2] | Count[1] | ~Count[0]);
  
  always_comb SEG[5] <= (Count[3] | Count[2] | ~Count[0]) & (Count[3] | Count[2] | ~Count[1]) & (Count[3] | ~Count[1] | ~Count[0]) & (~Count[3] | ~Count[2] | Count[1] | ~Count[0]);

  always_comb SEG[6] <= (Count[3] | Count[2] | Count[1]) & (Count[3] | ~Count[2] | ~Count[1] | ~Count[0]) & (~Count[3] | ~Count[2] | Count[1] | Count[0]);
  
endmodule
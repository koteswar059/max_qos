module bar2bin (
  input  [7:0] i_bar,
  output [2:0] o_bin
);
  
  assign o_bin[0] = (i_bar[1] & ~i_bar[2]) | (i_bar[3] & ~i_bar[4]) | (i_bar[5] & ~i_bar[6] ) | i_bar[7];
  
  assign o_bin[1] = (i_bar[2] & ~i_bar[4]) | i_bar[6];
  
  assign o_bin[2] = i_bar[4];
  
endmodule

module bin2bar(
  input [2:0] i_bin,
  output [7:0] o_bar
);
  
  bin2bar_tree #( .BIN_WIDTH(3))
  u_bin2bar_tree (
    .i_bin(i_bin),
    .o_bar(o_bar)
  );
  
endmodule

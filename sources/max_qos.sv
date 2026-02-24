`timescale 1us/1us
module max_qos(
  
  input clk,
  input rst,
  
  input wr_vld,
  input [3:0] wr_id,
  input [2:0] wr_qos,
  
  input rd_vld,
  input [3:0] rd_id,
  
  output [2:0] rd_qos,
  
  output [2:0] o_max_qos
);

//internal logic

endmodule

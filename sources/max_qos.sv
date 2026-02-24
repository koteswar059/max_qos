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
  
  
  reg [2:0] stored_qos [15:0];
  reg       stored_vld [15:0];
  
  wire [2:0] stored_qos_vld [15:0];
  wire [7:0] stored_qos_bar [15:0];
  
  reg [7:0] max_qos_bar;
  
  integer i;
  genvar j;
  
  always @ (posedge clk) begin
    if (rst) begin
       for ( i=0; i<16; i=i+1) 
        begin
        	stored_vld[i] <= 1'b0;
        	stored_qos[i] <= 3'b0;
      	end
    end    
      
    else begin
        if (wr_vld) begin
          stored_vld[wr_id] <= 1'b1;
          stored_qos[wr_id] <= wr_qos;
        end
        
        if (rd_vld) 
          stored_vld[rd_id] <= 1'b0;   
    end
  end 
  
  assign rd_qos = stored_qos[rd_id];
  
  generate 
    for (j=0; j<16; j=j+1)
      assign stored_qos_vld[j] = stored_qos[j] & {3{stored_vld[j]}};
  endgenerate
  
  genvar k;
  integer l;
  
  generate
    for (k=0; k<16; k=k+1)
      bin2bar u_bin2bar(
        .i_bin(stored_qos_vld[k]),
        .o_bar(stored_qos_bar[k])
      );
   endgenerate
    
    
  always @(*) begin
     max_qos_bar=7'b0;
    
    for (l=0; l<16; l=l+1)
      max_qos_bar = max_qos_bar | stored_qos_bar[l];
    
  end
    
  bar2bin u_bar2bin (
    .i_bar (max_qos_bar),
    .o_bin (o_max_qos)
  );
  
endmodule

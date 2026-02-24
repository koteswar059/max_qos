module bin2bar_tree (
 i_bin,
 o_bar
);
 
  parameter   BIN_WIDTH = 2;
  localparam  BAR_WIDTH = 2**BIN_WIDTH;
  
  localparam  BAR_WIDTH_L = BAR_WIDTH/2;
  
  input  [BIN_WIDTH-1:0] i_bin;
  output [BAR_WIDTH-1:0] o_bar;
  
  wire   [BAR_WIDTH_L -1 : 0] bar_temp;
  
  generate
    if (BIN_WIDTH == 1) begin
      assign o_bar = {i_bin,1'b1};
    end
    else
      begin : gen_bin2bar_tree_instance
        bin2bar_tree #(
          .BIN_WIDTH(BIN_WIDTH-1)
        ) u_bin2bar_tree
        (
          .i_bin(i_bin[BIN_WIDTH-2:0]),
          .o_bar(bar_temp)
        );
        
        assign o_bar = {
          { {BAR_WIDTH_L{i_bin[BIN_WIDTH-1]}} & bar_temp } ,
          { {BAR_WIDTH_L{i_bin[BIN_WIDTH-1]}} | bar_temp }
        };
      end
  endgenerate

endmodule

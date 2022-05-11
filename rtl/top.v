`include "./sha3.v"

`define MDLEN 256
`define ILEN 344



module top(input wire clk,
           input wire rstn,
           output tp0,
           output tp1,
           output tp2,
           output reg [7:0] LED);

   reg [3:0] state;
   reg rst;
   reg [15:0] count;
   wire refclk;
   assign refclk = clk; 

   wire [`MDLEN-1:0] sha3_out;
   wire req_ready, req_busy, res_valid;
   reg res_ready;

   sha3 #(.MDLEN(`MDLEN), .N(`ILEN)) sha3_
   (.clk(refclk), .rst(rst),
    // "The quick brown fox jumps over the lazy dog"
    .md_in(344'h54686520717569636b2062726f776e20666f78206a756d7073206f76657220746865206c617a7920646f67),
    .md_out(sha3_out),
    .req_valid(1'b1),
    .req_ready(req_ready),
    .req_busy(req_busy),
    .res_valid(res_valid),
    .res_ready(res_ready));

   assign tp0 = count;

   always @(posedge refclk) begin
      if (rstn == 0) begin
	 rst <= 1;
	 count <= 0;
	 state <= 0;
      end
      if (state > 3) begin
	 rst <= 0;
      end
      else begin
	 state <= state + 1;
      end
      if (!rst) begin
         if (res_valid & !res_ready) begin
            res_ready <= 1;
	    if (sha3_out == 256'h69070dda01975c8c120c3aada1b282394e7f032fa9cf32f4cb2259a0897dfc00) begin
	       count <= count + 1;
	    end
	    LED[7:0] <= ~sha3_out[255:255-7];
	    state <= 4;
	 end
         else if (!res_valid) begin
            res_ready <= 0;
         end
      end // if (!rst)
   end // always @ (posedge clk)

endmodule

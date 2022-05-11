/*
 * Copyright 2013, Homer Hsing <homer.hsing@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 *     in      byte_num     out
 * 0x11223344      0    0x0M000000
 * 0x11223344      1    0x110M0000
 * 0x11223344      2    0x11220M00
 * 0x11223344      3    0x1122330M
 *
 * where M=01 for the original keccak and =06 for FIPS compat.
 */

`define FIPS_COMPAT 1

module padder1(in, byte_num, out);
    input      [31:0] in;
    input      [1:0]  byte_num;
    output reg [31:0] out;
    
    always @ (*)
      case (byte_num)
`ifdef FIPS_COMPAT
        0: out = 32'h06000000;
        1: out = {in[31:24], 24'h060000};
        2: out = {in[31:16], 16'h0600};
        3: out = {in[31:8],   8'h06};
`else
        0: out = 32'h01000000;
        1: out = {in[31:24], 24'h010000};
        2: out = {in[31:16], 16'h0100};
        3: out = {in[31:8],   8'h01};
`endif
      endcase
endmodule

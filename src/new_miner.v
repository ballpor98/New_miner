//module new_miner (clock, resetn, version_in, prev_in, root_in, time_in, target, nonce, hash_out);
module new_miner (clock, resetn, hash_out);
	input clock, resetn;
	//input [255:0] prev_in, root_in;
	//input [31:0] version_in,time_in, target, nonce;
	output reg [255:0] hash_out;
	reg [255:0] prev_in, root_in;
	reg [31:0] version_in,time_in, target, nonce;
	//reg [255:0] hash_out;
	
	localparam mode = 1; // sha256 mode
	wire [255:0] hash;
	wire [511:0] block1, block2, block3;
	wire ready_out, valid_out;
	
	reg [2:0] state;
	reg [511:0] data_in;
	//reg [255:0] reg_hash_out;
	reg valid_in,last_in;
	
	
	//assign block1 = {512'h61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161}; //test
	assign block1 = {version_in,prev_in,root_in[255:32]};
	//assign block1 = {512'h0100000081cd02ab7e569e8bcd9317e2fe99f2de44d49ab2b8851ba4a308000000000000e320b6c2fffc8d750423db8b1eb942ae710e951ed797f7affc8892b0};
	assign block2 = {root_in[31:0], time_in,target,nonce,384'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000280};
	//assign block2 = {512'h61616161616161616161616161616161616161616161616161616161616161616161616180000000000000000000000000000000000000000000000000000320};
	assign block3 = {hash,256'h8000000000000000000000000000000000000000000000000000000000000100};
	//assign hash_out = reg_hash_out;
	
	sha256_stream U1
  (.clk(clock),
   .rst(resetn),
   .mode(mode),
   .s_tdata_i(data_in),
   .s_tlast_i(last_in),
   .s_tvalid_i(valid_in),
   .s_tready_o(ready_out),
   .digest_o(hash),
  .digest_valid_o(valid_out));

  always @ (state) //or negedge clock)
  begin
	case(state)
		3'b000:
		begin
			data_in <= block1;
			last_in <= 0;
			valid_in <= 1;
		end
		3'b001:
		begin
			data_in <= block2;
			last_in <= 1;
			valid_in <= 0;
		end
		3'b010:
		begin
			data_in <= block2;
			last_in <= 1;
			valid_in <= 1;
		end
		3'b011:
		begin
			data_in <= block3;
			last_in <= 1;
			valid_in <= 0;
		end
		3'b100:
		begin
			data_in <= block3;
			last_in <= 1;
			valid_in <= 1;
		end
		3'b101:
		begin
			data_in <= block1;
			last_in <= 0;
			valid_in <= 0;
		end
	endcase
  end
  always @ (posedge clock)
  begin
	if(~resetn)
		begin
			prev_in <= 256'h81CD02AB7E569E8BCD9317E2FE99F2DE44D49AB2B8851BA4A308000000000000;
			root_in <= 256'hE320B6C2FFFC8D750423DB8B1EB942AE710E951ED797F7AFFC8892B0F1FC122B;
			version_in <= 32'h01000000;
			time_in <= 32'hC7F5D74D;
			target <= 32'hF2B9441A;
			nonce <= 32'h42A14695;
			state <= 3'b000;
		end
		case(state)
		3'b000:
		begin
			state <= 3'b001;
		end
		3'b001:
		begin
			if(ready_out & valid_out)
				state <= 3'b010;
		end
		3'b010:
		begin
			state <= 3'b011;
		end
		3'b011:
		begin
			if(ready_out & valid_out)
				state <= 3'b100;
		end
		3'b100:
		begin
			state <= 3'b101;
		end
		3'b101:
		begin
			if(ready_out & valid_out)
			begin
				state <= 3'b000;
				hash_out <= hash;
			end
		end
	endcase
	//hash_out <= hash;
  end
endmodule

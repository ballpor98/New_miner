module gen (clk,signal_in,signal_out);
	input clk;
	input signal_in;
	output signal_out;
	reg out_reg = 1'b0;
	reg state = 1'b0;
	reg pev_in = 1'b0;
	always @ (posedge clk)
	begin
		if(state == 1'b0 && signal_in == 1'b1 && pev_in == 1'b0)
			state <= 1'b1;
		if(state == 1'b1 && out_reg == 1'b1)
			state <= 1'b0;
		pev_in <= signal_in;
	end
	always @ (state)
	begin
		if(state == 1'b0)
			out_reg <= 1'b0;
		if(state == 1'b1)
			out_reg <= 1'b1;
	end
	assign signal_out = out_reg;
endmodule

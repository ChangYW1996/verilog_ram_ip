module verilog_ip_ram
(
input clk_50M,
input   RST_N,

output reg [7:0] address,  
output reg [7:0] wrdata,    
output [7:0] rddata,    
output reg [7:0] time_cnt,   
output  wren,					 
output  rden					 
);

always@(posedge clk_50M or negedge RST_N)
begin
	if(!RST_N)
		 time_cnt<=0;
	else if(time_cnt==7'd63)
		time_cnt<=0;
	else time_cnt<=time_cnt+1'b1;
end
assign wren=(time_cnt>=7'd0&&time_cnt<=7'd31);
assign rden=(time_cnt>=7'd32&&time_cnt<=7'd63);

always@(negedge clk_50M or  negedge RST_N )
begin
	if(!RST_N)
		wrdata<=0;
	else 
		begin
			wrdata<=time_cnt;
		end
end
always@(negedge clk_50M or  negedge RST_N )
begin
	if(!RST_N)
		address<=0;
	else 
		if(time_cnt<=7'd31)
			begin
				address<=time_cnt;
			end
		else
			begin
				address<=time_cnt-7'd32;
			end
end

RAM	RAM_init (
	.address ( address ),   
	.clock ( clk_50M ),  
	.data ( wrdata ), 
	.rden ( rden ),	 
	.wren ( wren ),    
	.q ( rddata )     
	);
	
endmodule

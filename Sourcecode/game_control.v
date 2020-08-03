`timescale 1 ns/ 1 ns
module game_control(clk,rst_n,dead_wall,dead_it,game_status);
input clk,rst_n,dead_wall,dead_it;
output reg [1:0]game_status;
reg [1:0]status,next_status;
parameter dead=2'b10;
parameter start=2'b00;

always@(posedge clk)
begin
if(dead_wall||dead_it)
	  next_status<=dead;
 else 
  begin
   case(status)
	start: begin  if(dead_wall||dead_it)
	                   next_status<=dead;
						else 
						    next_status<=start;
			 end

	dead:    next_status<=start;


    default: next_status<=start;
   endcase
  end


end

always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
 status<=start;
 else
 begin
 status<=next_status;
 game_status<=status;
end
end
endmodule
	
		
  	
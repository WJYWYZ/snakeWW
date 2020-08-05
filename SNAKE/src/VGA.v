`timescale 1 ns/ 1 ns
module VGA(clk,rst_n,snake,apple_x,apple_y,vga_g,vga_b,vga_r,x_pos,y_pos);
input clk,rst_n,snake;
input [11:0]apple_x,apple_y;
input [11:0]x_pos,y_pos;
output reg [7:0]vga_g;
output reg [7:0]vga_b,vga_r;

//------------------------------------------------------------------------------------------------------
//ǽ�Լ�����ʾ����
parameter Red_Wall=32'd30;
wire wall_area;
assign wall_area=((x_pos>=12'd0 && x_pos< Red_Wall) || 
                  ((x_pos >= (12'd1280 - Red_Wall)) &&( x_pos <= 12'd1280)) || 
						((y_pos >= 12'd0) && (y_pos <= Red_Wall)) ||
                  ((y_pos>=12'd720 - Red_Wall) &&(y_pos <= 12'd720)));


//-----------------------------------------
//vga���ص������ʾ
always@(posedge clk or negedge rst_n)
begin
 if(!rst_n)
  begin
   vga_r<=8'hff;
	vga_b<=8'hff;
	vga_g<=8'hff;
  end
   else if(wall_area)  //ɨ�赽ǽ
	 begin
	 vga_r<=8'h01;
	 vga_b<=8'hff;
	 vga_g<=8'hff;
	 end
	 else if(((x_pos>=apple_x-12'd10)&&(x_pos<=apple_x+12'd10))&&((y_pos>=apple_y-12'd10)&&(y_pos<=apple_y+12'd10))) //ɨ�赽ƻ��
	  begin
	  vga_r<=8'hff;
	  vga_b<=8'hff;
	  vga_g<=8'h01;
	  end	  
      else if(snake)   //ɨ����
	     begin
	     vga_r<=8'hff;
	     vga_b<=8'h01;
	     vga_g<=8'hff;
	     end	
		 else
		  begin 
		     vga_r<=8'hff;
	        vga_b<=8'hff;
	        vga_g<=8'hff;
        end
end
endmodule









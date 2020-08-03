`timescale 1 ns/ 1 ns
module VGA(clk,rst_n,k_up,k_down,k_right,k_left,snake,apple_x,apple_y,
            vga_g,vga_b,vga_r,vga_hs,vga_vs,x_pos,y_pos,clk_25M,game_status,led);
input [1:0]game_status;
input clk,rst_n,k_up,k_down,k_right,k_left,snake;
input [9:0]apple_x,apple_y;
output clk_25M;
output reg [9:0]x_pos,y_pos;
output reg vga_g;
output reg vga_b,vga_r;
output reg vga_hs,vga_vs;
output reg led;


//--------------------------------------
//像素扫描频率clk=25MHz
reg clk_25M;
reg [1:0]clk_count;
always@(posedge clk or negedge rst_n)
begin
 if(!rst_n)
 begin
  clk_count<=0;
  clk_25M<=0;
  end
  else if(clk_count==2'b11)
  begin
   clk_count<=0;
	clk_25M=~clk_25M;
  end
	else 
	 clk_count<=clk_count+1'b1;
end

//----------------------------------------------------------------------------------------
//扫描一行h_cnt，以及vga_hs的产生
parameter   Hor_Total_Time  =   32'd800;
parameter   Hor_Addr_Time   =   32'd640;
parameter   Hor_Sync_Time   =   10'd96;
parameter   Hor_Back_Porch  =   10'd40;
parameter   Hor_Left_Border =   10'd8;
parameter   Hor_Start       =   Hor_Sync_Time + Hor_Back_Porch + Hor_Left_Border; 
parameter   Hor_End         =   Hor_Start + Hor_Addr_Time;


reg [31:0]h_cnt;

always@(posedge clk_25M or negedge rst_n)
begin
 if(!rst_n)
 begin
  h_cnt<=0;
  end
  else 
   begin
	  if(h_cnt==Hor_Total_Time-1'b1)
				h_cnt<=0;
			else if(h_cnt!=Hor_Total_Time-1'b1)
			    h_cnt<=h_cnt+1'b1;
				else 
				 h_cnt<=h_cnt;
	end
end

always@(posedge clk_25M or negedge rst_n)
begin
 if(!rst_n)
  vga_hs<=0;
  else if(h_cnt==Hor_Sync_Time-1'b1)
  vga_hs<=0;
  else if(h_cnt==Hor_Total_Time-1'b1)
   vga_hs<=1'b1;
	else 
	 vga_hs<=0;
end
  
//---------------------------------------------------------------------------------------
//扫描一列v_cnt,以及vga_vs的产生
parameter   Ver_Total_Time  =   32'd525;
parameter   Ver_Addr_Time   =   32'd480;
parameter   Ver_Sync_Time   =   10'd2;
parameter   Ver_Back_Porch  =   10'd25;
parameter   Ver_Top_Border  =   10'd8;
parameter   Ver_Start       =   Ver_Sync_Time + Ver_Back_Porch + Ver_Top_Border; 
parameter   Ver_End         =   Ver_Start + Ver_Addr_Time;

reg [31:0]v_cnt;

always@(posedge clk_25M or negedge rst_n)
begin
 if(!rst_n)
 begin v_cnt<=0;  led=1'b0;end
  else if(h_cnt==Hor_Sync_Time-1'b1)
   begin
	  if(v_cnt==Ver_Total_Time-1'b1)
            v_cnt<=0;
			else 
			  begin v_cnt<=v_cnt+1'b1;led=1'b1; end
	end
				else 
				v_cnt<=v_cnt;
	end


always@(posedge clk_25M or negedge rst_n)
begin
 if(!rst_n)
  vga_vs<=0;
  else if((h_cnt==Hor_Sync_Time-1'b1)&&(v_cnt==Ver_Sync_Time-1'b1))
  vga_vs<=0;
  else if(v_cnt==Ver_Total_Time-1'b1)
   vga_vs<=1'b1;
	else 
	 vga_vs<=0;
end
//------------------------------------------------- 
//vga显示区域的定义
wire display_area;
assign  display_area=(h_cnt>=(Hor_Start-1'b1)&&h_cnt<(Hor_End-1'b1)&&v_cnt>=Ver_Start&&v_cnt<Ver_End);
//------------------------------------------------------------------------------------------------------
//墙以及其显示区域
parameter Red_Wall=32'd16;
wire wall_area;
assign wall_area=((h_cnt >= (Hor_Start - 1'b1) && h_cnt < (Hor_Start - 1'b1 + Red_Wall)) || 
                  (h_cnt >= (Hor_End - 1'b1 - Red_Wall) && h_cnt < (Hor_End - 1'b1)) || 
						(v_cnt >= Ver_Start && v_cnt < (Ver_Start + Red_Wall)) ||
                  (v_cnt >= (Ver_End - Red_Wall) && v_cnt < Ver_End));

//-------------------------------------------------------------------------------------------
//像素点坐标扫描
always@(posedge clk_25M or negedge rst_n)
begin
 if(!rst_n)
  begin
   x_pos<=10'b0;
	y_pos<=10'b0;
  end
  else if(display_area)
   begin
	 x_pos<=h_cnt-Hor_Start+10'd2;
	 y_pos<=v_cnt-Ver_Start;
	end
	else 
  begin
   x_pos<=10'b0;
	y_pos<=10'b0;
  end
end
//-----------------------------------------
//vga像素点输出显示
always@(posedge clk_25M or negedge rst_n)
begin
 if(!rst_n)
  begin
   vga_r<=0;
	vga_b<=0;
	vga_g<=0;
  end
   else 
	begin
	if(game_status==2'b0)
 begin
	if(wall_area)  //扫描到墙
	 begin
	 vga_r<=1'b1;
	 vga_b<=1'b0;
	 vga_g<=1'b0;
	 end
	 else if((x_pos==apple_x)&&(y_pos==apple_y))  //扫描到苹果
	  begin
	  vga_r<=1'b1;
	  vga_b<=1'b0;
	  vga_g<=1'b1;
	  end	  
      else if(snake)   //扫到蛇
	     begin
	     vga_r<=1'b0;
	     vga_b<=1'b1;
	     vga_g<=1'b1;
	     end	
		 else
		  begin 
		     vga_r<=0;
	        vga_b<=0;
	        vga_g<=0;
        end
end
end
end
endmodule












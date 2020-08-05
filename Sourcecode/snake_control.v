`timescale 1 ns/ 1 ns
module snake_control(clk,rst_n,k_up,k_down,k_right,k_left,x_pos,y_pos,apple_x,apple_y,apple_refresh,snake,
                     dead_it,dead_wall,game_status);
input clk,rst_n,k_up,k_down,k_right,k_left;
input [11:0] x_pos,y_pos,apple_x,apple_y;
input [1:0]game_status;
output reg apple_refresh;     // 给随机产生苹果模块的激励
output dead_it,dead_wall;
output snake;

reg [1:0]dir;        //direction,蛇头方向寄存器
parameter up=2'b00;
parameter down=2'b01;
parameter left=2'b10;
parameter right=2'b11;

always@(posedge clk or negedge rst_n)
begin
     if(!rst_n) dir=left;
  else if(!k_left&&dir!=right) dir<=left;
  else if(!k_right&&dir!=left) dir<=right;
  else if(!k_up&&dir!=down) dir<=up;	           
  else if(!k_down&&dir!=up) dir<=down;			 //蛇头移动	
end

//---------------------------------------------------------
//蛇体寄存器，蛇体坐标和当前移动方向  
reg dead_it,dead_wall;//游戏结束
reg [11:0]snake_x[11:0];
reg [11:0]snake_y[11:0];
reg [31:0]count;    //蛇身随头移动周期计时，一周期为2s
parameter count_num=32'd5000000;

always@(posedge clk or negedge rst_n)
begin 
 if(!rst_n)
     count<=0;
   else if(dead_it||dead_wall) 
	  count<=0;
	else if(count==count_num)
	  count<=0;
	  else
	   count<=count+1'b1;
end
//-------------------------------------------------------------------------------------------------------------

always@(posedge clk or negedge rst_n)  //蛇头移动，依靠坐标轴上的加一减一实现,屏幕分辨率为1280*720，一个像素为10*10
begin
 if(!rst_n||(game_status==2'b10))
  begin
    snake_x[0]<=12'd640;
	 snake_y[0]<=12'd360;
	end
 else if(count==count_num)
   case(dir)
   right: begin  if(snake_x[0]==12'd1280)
	                 snake_x[0]<=10'd0;
						 else 
						   snake_x[0]=snake_x[0]+1'd1;
			 end
   left: begin  if(snake_x[0]==12'd0)
	                 snake_x[0]<=12'd1280;
						 else 
						   snake_x[0]=snake_x[0]-1'b1;
			 end
   up: begin  if(snake_y[0]==12'd720)
	                 snake_y[0]<=12'd0;
						 else 
						   snake_y[0]=snake_y[0]+1'd1;
			 end			 
   down: begin  if(snake_y[0]==12'd0)
	                 snake_y[0]<=12'd720;
						 else 
						   snake_y[0]=snake_y[0]-1'd1;
			 end	   
    default:  begin  snake_x[0]<=snake_x[0];snake_y[0]<=snake_y[0];  end
    endcase
end

//----------------------------------------------------------------------------
always@(posedge clk or negedge rst_n)  //蛇身随着移动
begin
if(!rst_n)
   begin 
  snake_x[1]<=0;
  snake_y[1]<=0; 
  snake_x[2]<=0;
  snake_y[2]<=0;	
  snake_x[3]<=0;
  snake_y[3]<=0;
  snake_x[4]<=0;
  snake_y[4]<=0; 
  snake_x[5]<=0;
  snake_y[5]<=0;
  snake_x[6]<=0;
  snake_y[6]<=0;
  snake_x[7]<=0;
  snake_y[7]<=0; 
  snake_x[8]<=0;
  snake_y[8]<=0;	
  snake_x[9]<=0;
  snake_y[9]<=0;	
  snake_x[10]<=0;
  snake_y[10]<=0;  
  snake_x[11]<=0;
  snake_y[11]<=0; 
  end
 else if(count==count_num)
 begin
  snake_x[1]<=snake_x[0];
  snake_y[1]<=snake_y[0]; 
  snake_x[2]<=snake_x[1];
  snake_y[2]<=snake_y[1];	
  snake_x[3]<=snake_x[2];
  snake_y[3]<=snake_y[2];
  snake_x[4]<=snake_x[3];
  snake_y[4]<=snake_y[3]; 
  snake_x[5]<=snake_x[4];
  snake_y[5]<=snake_y[4];
  snake_x[6]<=snake_x[5];
  snake_y[6]<=snake_y[5];
  snake_x[7]<=snake_x[6];
  snake_y[7]<=snake_y[6]; 
  snake_x[8]<=snake_x[7];
  snake_y[8]<=snake_y[7];	
  snake_x[9]<=snake_x[8];
  snake_y[9]<=snake_y[8];	
  snake_x[10]<=snake_x[9];
  snake_y[10]<=snake_y[9];  
  snake_x[11]<=snake_x[10];
  snake_y[11]<=snake_y[10];  
  end
   else
	begin 
	 snake_x[0]<=snake_x[0];
	 snake_y[0]<=snake_y[0];
	 end
end
//----------------------------------------------------------
reg [4:0]lenth;
always@(posedge clk or negedge rst_n)   //长度检测
begin
if(!rst_n)
 begin 
  lenth<=5'd1;
  apple_refresh<=0;
  end
  else if((snake_x[0]==apple_x)&&(snake_y[0]==apple_y))
   begin
    if(lenth<=5'd23)
	  begin 
	   lenth<=lenth+5'd2;
		apple_refresh<=1'b1;
	 end
	else if(lenth>5'd23||game_status==2'b10)
	begin
	  lenth<=5'd1;
	end
	end
  else if(apple_refresh==1)
  apple_refresh<=0;
   else
    apple_refresh<=apple_refresh;
end
//----------------------------------------------------------------------------------
parameter Red_Wall=32'd30;
always@(posedge clk or negedge rst_n)     //死亡检测
begin
 if(!rst_n)   begin dead_it<=0; dead_wall<=0; end
 else if((snake_x[0]==snake_x[1])&&(snake_y[0]==snake_y[1]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[2])&&(snake_y[0]==snake_y[2]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[3])&&(snake_y[0]==snake_y[3]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[4])&&(snake_y[0]==snake_y[4]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[5])&&(snake_y[0]==snake_y[5]))    dead_it<=1'b1;  
 else if((snake_x[0]==snake_x[6])&&(snake_y[0]==snake_y[6]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[7])&&(snake_y[0]==snake_y[7]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[8])&&(snake_y[0]==snake_y[8]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[9])&&(snake_y[0]==snake_y[9]))    dead_it<=1'b1;
 else if((snake_x[0]==snake_x[10])&&(snake_y[0]==snake_y[10]))  dead_it<=1'b1;
 else if((snake_x[0]==snake_x[11])&&(snake_y[0]==snake_y[11]))  dead_it<=1'b1;
 else if((snake_x[0]==Red_Wall)||(snake_x[0]==12'd1280 - Red_Wall)||(snake_y[0] == Red_Wall)||(snake_y[0]==12'd720 - Red_Wall)) dead_wall<=1'b1;
 else   begin dead_it<=0; dead_wall<=0; end
end

//-------------------------------------------------------------------------------------------------------------------------
//蛇体显示
assign snake=(((x_pos>=snake_x[0]-12'd10)&&(x_pos<=snake_x[0]+12'd10))&&((y_pos>=snake_y[0]-12'd10)&&(y_pos<=snake_y[0]+12'd10)))||(((x_pos>=snake_x[1]-12'd10)&&(x_pos<=snake_x[1]+12'd10))&&((y_pos>=snake_y[1]-12'd10)&&(y_pos<=snake_y[1]+12'd10))&&lenth>5'd3)
            ||(((x_pos>=snake_x[2]-12'd10)&&(x_pos<=snake_x[2]+12'd10))&&((y_pos>=snake_y[2]-12'd10)&&(y_pos<=snake_y[2]+12'd10))&&lenth>5'd5)||(((x_pos>=snake_x[3]-12'd10)&&(x_pos<=snake_x[3]+12'd10))&&((y_pos>=snake_y[3]-12'd10)&&(y_pos<=snake_y[3]+12'd10))&&lenth>5'd7)
				||(((x_pos>=snake_x[4]-12'd10)&&(x_pos<=snake_x[4]+12'd10))&&((y_pos>=snake_y[4]-12'd10)&&(y_pos<=snake_y[4]+12'd10))&&lenth>5'd9)||(((x_pos>=snake_x[5]-12'd10)&&(x_pos<=snake_x[5]+12'd10))&&((y_pos>=snake_y[5]-12'd10)&&(y_pos<=snake_y[5]+12'd10))&&lenth>5'd11)
				||(((x_pos>=snake_x[6]-12'd10)&&(x_pos<=snake_x[6]+12'd10))&&((y_pos>=snake_y[6]-12'd10)&&(y_pos<=snake_y[6]+12'd10))&&lenth>5'd13)||(((x_pos>=snake_x[7]-12'd10)&&(x_pos<=snake_x[7]+12'd10))&&((y_pos>=snake_y[7]-12'd10)&&(y_pos<=snake_y[7]+12'd10))&&lenth>5'd15)
				||(((x_pos>=snake_x[8]-12'd10)&&(x_pos<=snake_x[8]+12'd10))&&((y_pos>=snake_y[8]-12'd10)&&(y_pos<=snake_y[8]+12'd10))&&lenth>5'd17)||(((x_pos>=snake_x[9]-12'd10)&&(x_pos<=snake_x[9]+12'd10))&&((y_pos>=snake_y[9]-12'd10)&&(y_pos<=snake_y[9]+12'd10))&&lenth>5'd19)
				||(((x_pos>=snake_x[10]-12'd10)&&(x_pos<=snake_x[10]+12'd10))&&((y_pos>=snake_y[10]-12'd10)&&(y_pos<=snake_y[10]+12'd10))&&lenth>5'd21)||(((x_pos>=snake_x[11]-12'd10)&&(x_pos<=snake_x[11]+12'd10))&&((y_pos>=snake_y[11]-12'd10)&&(y_pos<=snake_y[11]+12'd10))&&lenth>5'd23);
endmodule


 
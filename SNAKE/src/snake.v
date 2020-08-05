`timescale 1 ns/ 1 ns
module snake(clk,rst_n,k_up,k_down,k_right,k_left,TMDS_Tx_Clk_P,TMDS_Tx_Clk_N,led,TMDS_Tx_Data_N,TMDS_Tx_Data_P);
input clk,rst_n,k_up,k_down,k_right,k_left;
output  TMDS_Tx_Clk_P;
output  TMDS_Tx_Clk_N;
output [2:0]TMDS_Tx_Data_N;
output [2:0]TMDS_Tx_Data_P;
output led;
wire clk_sys;
wire vga_hs,vga_vs;
wire [7:0]vga_r,vga_g,vga_b;
wire [23:0]rgb_data;
wire dead_it,dead_wall;
wire apple_refresh,snake;
wire [1:0]game_status;
wire [11:0]x_pos,y_pos,apple_x,apple_y;
wire vde;
  clk_wiz_0 clk_wiz
  ( 
  // Clock out ports  
  .clk_out1(clk_sys),
 // Clock in ports
  .clk_in1(clk)
  );

    rgb2dvi_0 rgb (
        .TMDS_Clk_p(TMDS_Tx_Clk_P),
        .TMDS_Clk_n(TMDS_Tx_Clk_N),
        .TMDS_Data_p(TMDS_Tx_Data_P),
        .TMDS_Data_n(TMDS_Tx_Data_N),
        .vid_pData(rgb_data),
        .aRst_n(rst_n),
        .vid_pVDE(vde),
        .vid_pHSync(vga_hs),
        .vid_pVSync(vga_vs),
        .PixelClk(clk_sys)
    );
  Driver_HDMI_0 inst (
    .clk(clk_sys),
    .Rst(rst_n),
    .Video_Mode(1),
    .RGB_In({vga_r,vga_g,vga_b}),
    .RGB_Data(rgb_data),
    .RGB_HSync(vga_hs),
    .RGB_VSync(vga_vs),
    .RGB_VDE(vde),
    .Set_X(x_pos),
    .Set_Y(y_pos)
  );

game_control U1( .clk(clk_sys),
                 .rst_n(rst_n),
				 .dead_it(dead_it),
				 .dead_wall(dead_wall),
				 .game_status(game_status)
);

snake_control  U2(.clk(clk_sys),
               .rst_n(rst_n),
					.k_up(k_up),
					.k_down(k_down),
					.k_right(k_right),
					.k_left(k_left),
					.x_pos(x_pos),
					.y_pos(y_pos),
					.apple_x(apple_x),
					.apple_y(apple_y),
					.apple_refresh(apple_refresh),
					.snake(snake),
					.dead_it(dead_it),
					.dead_wall(dead_wall),
					.game_status(game_status)
);

VGA U3(             .clk(clk_sys),
                    .rst_n(rst_n),
					.x_pos(x_pos),
					.y_pos(y_pos),
					.apple_x(apple_x),
					.apple_y(apple_y),
					.snake(snake),
					.vga_g(vga_g),
					.vga_b(vga_b),
					.vga_r(vga_r)
					
);

cake U4(          .clk(clk_sys),
               .rst_n(rst_n),
					.drive(apple_refresh),
					.box_x(apple_x),
					.box_y(apple_y)
);
endmodule

`timescale 1 ns/ 1 ns
module snake(clk,rst_n,k_up,k_down,k_right,k_left,TMDS_Tx_Clk_P,TMDS_Tx_Clk_N,led,TMDS_Tx_Data_N,TMDS_Tx_Data_P);
input clk,rst_n,k_up,k_down,k_right,k_left;
output  TMDS_Tx_Clk_P;
output  TMDS_Tx_Clk_N;
output [2:0]TMDS_Tx_Data_N;
output [2:0]TMDS_Tx_Data_P;
output led;
wire clk_25M;
wire vga_hs,vga_vs;
wire vga_r,vga_g,vga_b;
wire dead_it,dead_wall;
wire finish,apple_refresh,snake;
wire [1:0]game_status;
wire [9:0]x_pos,y_pos,apple_x,apple_y;
;


    rgb2dvi_0 rgb (
        .TMDS_Clk_p(TMDS_Tx_Clk_P),
        .TMDS_Clk_n(TMDS_Tx_Clk_N),
        .TMDS_Data_p(TMDS_Tx_Data_P),
        .TMDS_Data_n(TMDS_Tx_Data_N),
        .vid_pData({vga_r,vga_g,vga_b}),
        .vid_pVDE(1),
        .vid_pHSync(vga_hs),
        .vid_pVSync(vga_vs),
        .PixelClk(clk_25M)
    );


game_control U1(.clk(clk),
             .rst_n(rst_n),
				 .dead_it(dead_it),
				 .dead_wall(dead_wall),
				 .game_status(game_status)
);


snake_control  U2(.clk(clk),
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
					.dead_wall(dead_wall)
);

VGA U3(           .clk(clk),
               .rst_n(rst_n),
					.k_up(k_up),
					.k_down(k_down),
					.k_right(k_right),
					.k_left(k_left),
					.x_pos(x_pos),
					.y_pos(y_pos),
					.apple_x(apple_x),
					.apple_y(apple_y),
					.snake(snake),
					.vga_g(vga_g),
					.vga_b(vga_b),
					.vga_r(vga_r),
					.vga_hs(vga_hs),
					.vga_vs(vga_vs),
					.clk_25M(clk_25M),
					.game_status(game_status),
					.led(led)
					
);

cake U4(          .clk(clk),
               .rst_n(rst_n),
					.drive(apple_refresh),
					.box_x(apple_x),
					.box_y(apple_y)
);
endmodule

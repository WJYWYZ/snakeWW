`timescale 1 ns/ 1 ns
module cake(

    input clk,

    input rst_n,

    input drive,

    output wire[11:0]box_x,

    output wire[11:0]box_y

    );

    //两个例化模块

    wire [8:0]rand_num;
    wire [11:0]rand_x;
    wire [11:0]rand_y;
    wire rand_drive,load;
	 wire [8:0]seed;

    random U1_random(

            .clk(clk),

            .rst_n(rst_n),

            .seed(seed),

            .load(load),

            .rand_num(rand_num)//�?共需要生成两个随机数在cake_create模块调用两次 

            );

    //随机生成模块


   

    cake_create U1_cake_create(

                    .clk(clk),

                    .rst_n(rst_n),

                    .rand_num(rand_num),

                    .rand_drive(drive),

                    .rand_x(rand_x),

                    .rand_y(rand_y)

                    );

      assign box_x = rand_x;//随机数坐标对应蛋糕坐�?

      assign box_y = rand_y;

    

    

endmodule
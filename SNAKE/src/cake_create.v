`timescale 1 ns/ 1 ns
 module cake_create(

    input clk,

    input rst_n,

    input[8:0] rand_num,

    input rand_drive,//???????

    output reg[11:0]rand_x,

    output reg[11:0]rand_y

    );


    reg flag;

    always@(posedge clk or negedge rst_n)

        if(!rst_n) 

            begin

                rand_x <= 12'd300;

                rand_y <= 12'd300;

                flag <= 1'b0;

            end

        else if(rand_drive) //???????
                
                begin flag <= 1'b1; 
       
                      rand_x <= rand_num; 

                end

        else if(flag == 1'b1) //??flag?????????????????????

                begin  rand_y <= rand_num; 

                         flag <= 1'b0;
   
                 end

endmodule
# snakeWW
## 2020年新工科联盟-Xilinx暑期学校（Summer School）项目
## 项目名称：经典游戏复现（贪吃蛇）
## 项目概要
设计目的：利用FPGA及相关外部设备实现经典游戏贪吃蛇的复现
相关知识：Verilog编程语言、VGA外部显示
## 技术方向
贪吃蛇蛇身由一个寄存器组构成，首先需要锁定蛇头的坐标，当生成果实的坐标与蛇头坐标重合时，蛇身长度加一，实现吃果实的功能。蛇的移动是将数据从蛇寄存器第0位逐级传到下一个单位来实现的。VGA连接的显示屏显示原理与动态扫描原理类似，重要的是扫描时生成坐标x pos与y pos，当该坐标与蛇身坐标，cake坐标重合时，显示对应的颜色，实现相应的画面，
其中cake的生成重点运用了LSFE生成伪随机数原理。
## 已实现的功能
完成了Verilog代码的编译，并进行了仿真验证，生成可用的bit文件。游戏能在显示屏上正常显示，并且可以通过按键操控，实现正常的游戏功能。
## 使用的工具版本
vivado2018.3
upycraft1.0
## 小组成员列表
王奕瞻（2018112744）
王佳颖（2018112771）
## 板卡型号与外设列表
板卡型号：SEA Spartan-7 
外设列表：HDMI转接线 、VGA接口
## 仓库目录介绍
images:存放作品照片
Sourcecode：存放项目源代码 （包含约束文件）
ExecutableFiles：存放可直接下载到板卡的bitstream文件
SNAKE：存放vivado工程
/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : serial_define.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 02 Jul 2021 03:21:06 PM CST
 ************************************************************************/
`define DataPacketSize 35
`define minConfPktSize 2
`define maxConfPktSize 4 
`define flitWidth      30

`define StartBit      1'b0
`define StopBit       1'b1
`define InfoFormat    1'b1
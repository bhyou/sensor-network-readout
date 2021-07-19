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
`define SoF_flag      2'b10
`define EoF_flag      2'b01
`define addrWidth      8
`define pktTpWidth     2

`define StartBit      1'b0
`define StopBit       1'b1
`define InfoFrame     1'b1
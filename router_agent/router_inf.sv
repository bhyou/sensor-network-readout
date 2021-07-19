/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : router_inf.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Mon 19 Jul 2021 10:12:36 AM CST
 ************************************************************************/
`include "router_defines.sv"
 
interface router_inf (input bit clk, rst);
    logic [`flitWidth-1:0]    out_flit_o;
    logic                     out_vld_o;
    logic                     out_rdy_i;

    logic [`flitWidth-1:0]    in_flit_i;
    logic                     in_vld_i;
    logic                     in_rdy_o;

    clocking mcb @(posedge clk);:wq
        default input #1 output #1;
        output     out_flit_o;
        output     out_vld_o;
        input      out_rdy_i;

        input      in_flit_i;
        input      in_vld_i;
        output     in_rdy_o;
    endclocking

    clocking scb @(posedge clk);
        default input #1 output #1;
        input       out_flit_o;
        input       out_vld_o;
        output      out_rdy_i;

        output      in_flit_i;
        output      in_vld_i;
        input       in_rdy_o;
    endclocking

    clocking cb @(posedge clk);
        default input #1 output #1;
        input       out_flit_o;
        input       out_vld_o;
        input      out_rdy_i;

        input      in_flit_i;
        input      in_vld_i;
        input       in_rdy_o;
    endclocking

    modport drv(input clk, rst, clocking mcb);
    modport rcv(input clk, rst, clocking scb);
    modport mon(input clk, rst, clocking cb);
endinterface

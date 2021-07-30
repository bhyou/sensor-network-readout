/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : router_agent.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Mon 19 Jul 2021 03:33:54 PM CST
 ************************************************************************/
 
`include "defines.vh"
`include "router_driver.sv"
`include "router_generator.sv"

class router_agent;

    virtual router_inf.drv     drvInf;
    virtual router_inf.mon     monInf;

    mailbox                    gen2drv;
    mailbox                    drv2scb;
//    mailbox                    mon2scb;

    router_driver              drv;
//    router_monitor             mon;
    router_generator           gen;
    
    function new(virtual router_inf.drv drvInf, virtual router_inf.mon monInf);
        this.drvInf = drvInf;
        this.monInf = monInf;
    endfunction //new()

    virtual task automatic  pre_test();
        gen2drv = new();
//        mon2scb = new();
        drv2scb = new();
        drv = new(drvInf, gen2drv, drv2scb);
//        mon = new(mon2scb);
    endtask //automatic pre_test()

    task automatic test();
        fork
            drv.transmit_a_packet();
//            mon.receive_a_packet();
        join_none
    endtask //automatic test

    task pst_test();
    endtask
endclass //router_agent
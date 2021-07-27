/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : serial_agent/serial_agent.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 16 Jul 2021 01:30:34 PM CST
 ************************************************************************/
 
`include "defines.vh"
`include "serial_generator.sv"
`include "serial_driver.sv"
`include "serial_monitor.sv"

class serial_agent;

    mailbox                     gen2drv;
    mailbox                     drv2scb;
    mailbox                     mon2scb;
    virtual serial_inf.master   drvInf;
    virtual serial_inf.monitor  monInf;

    serial_generator            serGen;
    serial_monitor              serMon;
    serial_driver               serDrv;

    function new(virtual serial_inf.master drvInf, virtual serial_inf.monitor monInf);
        this.drvInf = drvInf;
        this.monInf = monInf;
    endfunction

    task automatic pre_test();
        gen2drv = new();
        drv2scb = new();
        mon2scb = new();

        serGen = new(gen2drv);
        serDrv = new(gen2drv,drv2scb,drvInf);
        serMon = new(mon2scb,monInf);
    endtask

    task automatic test();
        bit    receiverRdy;
        bit    senderRdy  ;
        bit    frameFmt   ;

        fork
            serDrv.transmit_a_packet(senderRdy,receiverRdy, frameFmt);
            serMon.receive_a_packet(senderRdy,receiverRdy);
        join_none
    endtask // test

    task automatic post_test();
        #1000;
        $stop;
    endtask
endclass


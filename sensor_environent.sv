/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : sensor_environent.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Mon 19 Jul 2021 04:30:34 PM CST
 ************************************************************************/
 
class sensor_environent;
    
    router_inf.drv        routerDrvInf;
    serial_inf.master     serialDrvInf;

    router_inf.mon        routerMonInf;
    serial_inf.monitor    serialMonInf;

    router_agent          routerAgent;
    serial_agent          serialAgent;
    scoreboard            scoreboard;
    mailbox               gen2drv;
    mailbox               drv2scb;


    function new(router_inf.drv    routerDrvInf, router_inf.mon     routerMonInf, 
                 serial_inf.master serialDrvInf, serial_inf.monitor serialMonInf);
        this.routerDrvInf = routerDrvInf;
        this.routerMonInf = routerMonInf;
        this.serialDrvInf = serialDrvInf;
        this.serialMonInf = serialMonInf;
    endfunction //new()


    task automatic  pre_test();
        rouerAgent = new();

    endtask //automatic pre_test

endclass //sensor_environent
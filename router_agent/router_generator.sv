/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : router_generator.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 23 Jul 2021 02:57:46 PM CST
 ************************************************************************/
 
class router_generator;
    mailbox   gen2drv;

    function new(mailbox outBox);
        this.gen2drv =  outBox;
    endfunction
    task automatic  createTrns(arguments);
        packet  trns = new;
        assert(trns.randomize()) 
        else $display("randomize failed!");
        trns.timestamp = $time;
        gen2drv.put(trns);
    endtask //automatic createTrns
endclass
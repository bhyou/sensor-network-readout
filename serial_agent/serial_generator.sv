/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : serial_agent/serial_generator.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 16 Jul 2021 01:29:29 PM CST
 ************************************************************************/
`include "defines.vh" 
`include "packet.sv"

class serial_generator;
    mailbox       outBox;
    
    function new(mailbox outBox);
        this.outBox = outBox;
    endfunction

    task automatic createTrns();
        packet    serPkt = new;

        assert (serPkt.randomize()) 
        else  $fatal("randomize failed!");
        outBox.put(serPkt);
    endtask
endclass

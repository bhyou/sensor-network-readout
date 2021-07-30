/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : router_driver.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Mon 19 Jul 2021 02:06:07 PM CST
 ************************************************************************/
 
`include "defines.vh"
//`include "packet.sv"

class router_driver;

    virtual router_inf.drv drvInf;
    mailbox                inBox, outBox;

    function new(virtual router_inf.drv drvInf, mailbox inBox, outBox);
        this.drvInf = drvInf;
        this.inBox = inBox;
        this.outBox = outBox;    
    endfunction //new()

    virtual task automatic transmot_a_flit(logic [`flitWidth-1:0] flit);
        @(drvInf.mcb);
        if(drvInf.mcb.out_rdy_i) begin
            drvInf.mcb.out_flit_o <= flit;
            drvInf.mcb.out_vld_o <= 1'b1;
        end else begin
            drvInf.mcb.out_flit_o <= '0;
            drvInf.mcb.out_vld_o <=  '0;
        end
    endtask // transmot_a_flit

    virtual task automatic transmit_a_packet();
        packet                   drvPkt ;
        logic [`flitWidth-1:0]   flitTmp;

        inBox.get(drvPkt);
        outBox.put(drvPkt);
        flitTmp = drvPkt.get_head_flit();
        transmot_a_flit(flitTmp);
        foreach(drvPkt.payload[index]) begin
            flitTmp = {`DATA, drvPkt.payload[index]};
            transmot_a_flit(flitTmp);
        end
        flitTmp = drvPkt.get_tail_flit();
        transmot_a_flit(flitTmp);
    endtask // transmot_a_packet


endclass //router_driver
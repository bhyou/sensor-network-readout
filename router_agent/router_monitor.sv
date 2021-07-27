/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : router_monitor.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Mon 19 Jul 2021 02:37:25 PM CST
 ************************************************************************/
`include "defines.vh"

class router_monitor;
    virtual router_inf.cb  monInf;
    mailbox                outBox;

    function new(mailbox outBox, virtual router_inf.mon monInf);
        this.outBox = outBox;
        this.monInf = monInf;
    endfunction //new()

    task automatic receive_a_flit(logic [`flitWidth-1:0] flit);
        @(monInf.cb);
        if(monInf.in_vld_i) begin 
            flit = monInf.in_flit_i;
        end else begin 
            flit = '0;
        end
    endtask //automatic    

    task automatic receive_a_packet();
        router_pkt               monPkt = new;
        logic [`flitWidth-1:0]   flitTmp;
        int                      index;

        forever begin 
            receive_a_flit(flitTmp);
            if(flitTmp[`flitWidth-1 -: 2]==`SOF) begin
                index = 0;
                monPkt.destX = flitTmp[`flitWidth-3 -: `addrWidth];
                monPkt.destY = flitTmp[`flitWidth-`addrWidth-3 -: `addrWidth];
                monPkt.networkID = flitTmp[`flitWidth-`addrWidth*2-3];
                monPkt.packetType = flitTmp[`flitWidth-2*`addrWidth-4 -:`pktTpWidth];    
            end else if(flitTmp[`flitWidth-1 -: 2]==`EOF) begin
                monPkt.sourceX = flitTmp[`flitWidth-3 -: `addrWidth];
                monPkt.sourceY = flitTmp[`flitWidth-`addrWidth-3 -: `addrWidth];
                monPkt.timeStampe = flitTmp[`flitWidth-`addrWidth*2-3:0];
            end else if(flitTmp[`flitWidth-1 -: 2]==`DATA) begin
                monPkt.payload[index] = flitTmp[`flitWidth-3:0];
                index ++;
            end else begin
                $fatal("the format of received pakcet is error!")
            end
        end
    endtask //automatic receive_a_packet
endclass //router_monitor
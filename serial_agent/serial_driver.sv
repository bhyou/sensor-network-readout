/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : serial_driver.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 02 Jul 2021 03:31:08 PM CST
 ************************************************************************/
`include "defines.vh" 
class serial_driver;

    virtual serial_inf.master  driverInf    ;
    mailbox                    receivePktMbx;
    mailbox                    transmitPktMbx;

    function new(mailbox in_mbx,out_mbx, virtual serial_inf.master driverInf);
        this.receivePktMbx    = in_mbx ;
        this.transmitPktMbx   = out_bx;
        this.driverInf        = driverInf;
    endfunction //new()

    virtual task automatic transmit_a_bit(input bit bitValue);
        mcb.serial_tx = bitValue;
        @(mcb);
    endtask 

    virtual task automatic transmit_a_flit(input bit[`flitWidth-1:0]  flit);
       for(int item=`flitWidth-1; item>=0; item=item-1) begin
            transmit_a_bit(flit[item]);
            if(`TRACE_LOW) 
                $display("[TRACE] @%t driver send flit:\t 0x%h", $time, flit);
       end
    endtask 

    virtual task automatic transmit_status_info(input bit senderIsReady, receiverIsReady);
        transmit_a_bit(senderIsReady);
        transmit_a_bit(receiverIsReady);

        if(`TRACE_LOW) begin 
            $display("[TRACE] @%t driver send the current ready status of sender: %b", $time, senderIsReady);
            $display("[TRACE] @%t driver send the ready status of receiver stored in sender: %b", $time, receiverIsReady);
        end
    endtask // transmit_status_info

    virtual task automatic transmit_a_frame (input bit senderRdy, receiverRdy, frameFmt, input bit[29:0] flit);
        transmit_a_bit(`StartBit);
        transmit_a_bit(frmaeFmt);  // frame format bit
        if(frameFmt == `InfoFrame) begin 
            transmit_status_info(senderRdy, receiverRdy);
        end
        else begin
            transmit_a_flit(flit);
        end
        transmit_a_bit(`StopBit);
    endtask // send_a_flit 


    virtual task automatic transmit_a_packet(input bit senderRdy, receiverRdy, frameFmt);
        packet               drv_pkt;
        logic [`flitWidth-1:0]   flitTmp;

        receivePktMbx.get(drv_pkt);
        transmitPktMbx.put(drv_pkt.copy());
        flitTmp = drv_pkt.get_head_flit();
        transmit_a_frame(senderRdy, receiverRdy, frameFmt, flitTmp);
        foreach(drv_pkt.payload[index]) begin
            flitTmp = {`DATA,drv_pkt.payload[index]};
            transmit_a_frame(senderRdy, receiverRdy, frameFmt, flitTmp);
        end
        flitTmp = drv_pkt.get_tail_flit();
        transmit_a_frame(senderRdy, receiverRdy, frameFmt, flitTmp);
    endtask 

endclass //serial_driver
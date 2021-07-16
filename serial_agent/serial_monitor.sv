/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : serial_monitor.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 16 Jul 2021 10:09:26 AM CST
 ************************************************************************/
`include "defines.sv"
 
class serial_monitor;
    virtual serial_inf.monitor     monitorInf;
    mailbox                        outBox;
    
    function new(mailbox outBox, virtual serial_inf.monitor monInf);
        this.monitorInf = monInf;
        this.outBox = outBox;
    endfunction

    task automatic receive_a_bit(output bit bitVal);
        @(posedge monitorInf.clk)
        bitVal = monitorInf.serial_rx;
    endtask // receive_a_bit

    task automatic receive_a_flit(output logic [`flitWidth-1:0] flit);
        for(int idx = `flitWidth; idx > 0, idx --) begin 
            receive_a_bit(flit[idx-1]); 
        end
    endtask // receive_a_flit


    task automatic receive_a_frame(output logic senderRdy, receiverRdy, logic [`flitWidth-1:0] flit);
        bit                    isStart;
        bit                    isStop ;
        // frame format: 0 --> exchange ready status; 1 --> exchange data 
        bit                    frameFmt; 
        logic [`flitWidth-1:0] flitTmp ;

        receive_a_bit(isStart);
        if(isStart == `StartBit) begin
            receive_a_bit(frameFmt);
            if(frameFmt == `InfoFormat) begin 
                receive_a_bit(senderRdy);
                receive_a_bit(receiverRdy)；
            end else begin
                receive_a_flit(flitTmp);
            end
            receive_a_bit(isStop);            
        end

        if(isStop == `StopBit) begin
            flit = flitTmp;
        end else begin
            flit = 0;
        end
    endtask // receive_a_frame

    task automatic receive_a_pkt();
        
    endtask // receive_a_pkt

endclass

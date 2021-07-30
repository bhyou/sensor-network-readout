/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : serial_monitor.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 16 Jul 2021 10:09:26 AM CST
 ************************************************************************/
`include "defines.vh"
 
class serial_monitor;
    virtual serial_inf.monitor     monitorInf;
    mailbox                        outBox;
    
    function new(mailbox outBox, virtual serial_inf.monitor monInf);
        this.monitorInf = monInf;
        this.outBox = outBox;
    endfunction

    virtual task automatic receive_a_bit(output bit bitVal);
        @(posedge monitorInf.clk)
        bitVal = monitorInf.serial_rx;
    endtask // receive_a_bit

    virtual task automatic receive_a_flit(output logic [`flitWidth-1:0] flit);
        for(int idx = `flitWidth; idx > 0; idx --) begin 
            receive_a_bit(flit[idx-1]); 
        end
    endtask // receive_a_flit


    virtual task automatic receive_a_frame(output logic frameFmt, senderRdy,receiverRdy, logic [`flitWidth-1:0] flit);
        bit                    isStart;
        bit                    isStop ;
        // frame format: 0 --> exchange ready status; 1 --> exchange data 
        // bit                    frameFmt; 
        logic [`flitWidth-1:0] flitTmp ;

        receive_a_bit(isStart);
        if(isStart == `StartBit) begin
            receive_a_bit(frameFmt);
            if(frameFmt == `InfoFrame) begin 
                receive_a_bit(senderRdy);
                receive_a_bit(receiverRdy);
                flitTmp = {senderRdy,receiverRdy, {`flitWidth-2{1'b0}}};
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

    virtual task receive_a_packet(output logic senderRdy, receiverRdy);
        logic [`flitWidth-1:0] flitTmp ;
        logic                  frameFmt;
        int                    index   ;
        packet                 recvPkt ;

        forever begin 
            recvPkt = new;
            receive_a_frame(frameFmt, flitTmp, senderRdy,receiverRdy);
            if(frameFmt != `InfoFrame) begin
                if(flitTmp[(`flitWidth-1) -: 2]==`SoF_flag) begin
                    index = 0;
                    recvPkt.destX = flitTmp[`flitWidth-3 -: `addrWidth];
                    recvPkt.destY = flitTmp[`flitWidth-`addrWidth-3 -: `addrWidth];
                    recvPkt.netID = flitTmp[`flitWidth-2*`addrWidth-3];
                    recvPkt.packetType = flitTmp[`flitWidth-`addrWidth*2-4 -: `pktTpWidth];
                end else if(flitTmp[`flitWidth-1 -:2] == `EoF_flag)begin
                    recvPkt.sourceX = flitTmp[`flitWidth-3 -: `addrWidth];
                    recvPkt.sourceY = flitTmp[`flitWidth-`addrWidth-3 -:`addrWidth];
                    recvPkt.timestamp = flitTmp[`flitWidth-`addrWidth*2-3:0];
                    outBox.put(recvPkt);
                end else begin
                    if(flitTmp[`flitWidth-1 -: 2]==0) begin
                        recvPkt.payload[index] = flitTmp[27:0];
                        index ++;
                    end else begin
                        $fatal("the format of received pakcet is error!");
                    end
                end
            end else begin
                $warning("the format of received pakcet is info frame!");
            end
        end
        
    endtask

endclass

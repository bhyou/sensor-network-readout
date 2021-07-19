/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : serial_pkt.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Fri 02 Jul 2021 01:29:15 PM CST
 ************************************************************************/
class serial_pkt;

    rand bit [7:0]  destX;  // the x coordinate of destination
    rand bit [7:0]  destY;  // the y coordinate of destination  
    rand bit        netwrokID ;
    rand enum {writePkt, readPkt, testPkt, dataPkt} packetType;

    rand bit [27:0] payload [];
         bit [7:0]  sourceX;
         bit [7:0]  sourceY;
         bit [11:0] timeStampe;

    constraint destination_limit {
        soft destX inside {[1:224]};
        soft destY inside {[1:224]};
    }

    constraint pcketSize_limit{
        if (packetType==dataPkt) 
            payload.size() == `DataPacketSize;
        else if(packetType==testPkt)
            payload.size() inside {[10:35]};
        else 
            payload.size() inside {[`minConfPktSize:`maxConfPktSize]};
    }

    function void print();
        $display("destX=%d, destY=%d, networkID=%d, packet type=%s", destX, destY, networkID,packetType);
        foreach(padload[index])
            $display("payload[%d] = 0x%h", index, payload[index]);        
    endfunction     

    function serial_pkt copy();
        serial_pkt trns = new;
        trns.destX   = destX;
        trns.destY   = destY;
        trns.sourceX = sourceX;
        trns.sourceY = sourceY;
        trns.networkID   = networkID;
        trns.packetType   = packetType;
        trns.timeStampe   = timeStampe;
        foreach(padload[index])
            trns.padload[index] = padload[index];
        
        return trns;
    endfunction

    function bit[29:0] get_head_flit();
        return {2'b10,this.destX, this.destY, this.networkID,packetType,8'h00};
    endfunction

    function bit [29:0] get_tail_flit();
        return {2'b01,this.sourceX, this.sourceY, this.timeStampe};
    endfunction

endclass //serial_pkt 
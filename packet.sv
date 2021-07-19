/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : packet.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Mon 19 Jul 2021 04:58:39 PM CST
 ************************************************************************/
 
class packet;

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

    function packet copy();
        packet trns = new;
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

    function bit compare(packet pkt2cmp);
        if(payload.size()==pkt2cmp.payload.szie()) begin
            $display("Payload Size is match!");

            if(payload == pkt2cmp.payload) begin
                $display("Payload is match!");
                if(get_tail_flit()==pkt2cmp.get_tail_flit) begin
                    $display("the two packetes are matched!")
                    return (1'b1);
                end else begin
                    $display("the two packetes are mismatched!")
                    return (1'b0);
                end
            end else begin
                $display("Payload is mismatch!");
                return (1'b0);
            end
        end else begin
            $display("Payload Size is mismatch");
            $display("Expected Size: %d, Received Size: %d", payload.size(), pkt2cmp.payload.size());
            return (1'b0);
        end
    endfunction
endclass // packet

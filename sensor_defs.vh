`define SOF  2'b10
`define DATA 2'b00
`define EOF  2'b01
 
`define DataPacketSize 5
//`define DataPacketSize 35

`define DataPacketSize 35
`define minConfPktSize 2
`define maxConfPktSize 4 


`define flitWidth      30
`define SoF_flag      2'b10
`define EoF_flag      2'b01
`define addrWidth      8
`define pktTpWidth     2

`define StartBit      1'b0
`define StopBit       1'b1
`define InfoFrame     1'b1
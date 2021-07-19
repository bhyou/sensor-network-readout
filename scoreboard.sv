/*************************************************************************
 > Copyright (C) 2021 Sangfor Ltd. All rights reserved.
 > File Name   : scoreboard.sv
 > Author      : bhyou
 > Mail        : bhyou@foxmail.com 
 > Created Time: Mon 19 Jul 2021 04:51:12 PM CST
 ************************************************************************/
 
class scoreboard #(int serialPorts=4);
    mailbox      serialBox [serialPorts];
    mailbox      routerBox;

    packet       trns [];

    function new(mailbox serialBox[serialPorts], routerBox);
        this.serialBox = serialBox;
        this.routerBox = routerBox;        
    endfunction //new()

    task automatic check();
        foreach() begin
            
        end
    endtask //automatic
endclass //scoreboard
   module LCD_tb;
    reg           SYS_clk;
    reg           SYS_reset;
    reg [1:0]     SYS_buttons;
    
    wire [14:4]   pin;
    wire [5:0]    state;
    
    lcd testbench(.SYS_clk(SYS_clk), .state(state), .SYS_reset(SYS_reset), .SYS_buttons(SYS_buttons), .pin(pin));
    initial begin
        SYS_clk = 1'b1;
        forever begin
            #0.01 SYS_clk = ~SYS_clk;
        end
    end
    initial begin
        $monitor("time %t:  SYS_reset: %b, SYS_buttons: %b, data_out: %b\n", $time, SYS_reset, SYS_buttons, pin);
    end
    initial begin
            SYS_buttons = 2'b00;
            SYS_reset   = 1;
        #10 SYS_buttons = 2'b00;
            SYS_reset   = 0;
        #10 SYS_buttons = 2'b01;
        #10 SYS_buttons = 2'b01;
        #10 SYS_buttons = 2'b10;
        #10 SYS_buttons = 2'b10;
        #10 SYS_buttons = 2'b11;
        #10 SYS_buttons = 2'b11;
        #10 $finish;
    end
endmodule
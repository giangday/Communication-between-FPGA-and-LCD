module lcd (  
    input       SYS_clk,
    input       SYS_reset,
    input[1:0]  SYS_buttons,

    output [14:4] pin,
    output reg [5:0] state
);
    parameter   CLEAR_DISPLAY_SIGNAL       = 8'h01,
                TWO_LINE_SIGNAL            = 8'h38,
                INCREMENT_CURSOR_SIGNAL    = 8'h06,
                RETURN_HOME_SIGNAL         = 8'h02,
                DISPLAYON_CURSOROFF_SIGNAL = 8'h0c,

                SANG    = 2'b00,
                TRUA    = 2'b01,
                CHIEU   = 2'b10,
                TOI     = 2'b11,
                
                //states list
                CLEAR_0             = 0,
                CLEAR_1             = 1 ,
                CLEAR_2             = 2,

                SET_TWO_LINE_1      = 3,
                SET_TWO_LINE_2      = 4,

                INCREMENT_CURSOR_1  = 5,
                INCREMENT_CURSOR_2  = 6,

                RETURN_HOME_1       = 7,
                RETURN_HOME_2       = 8,

                TURN_OFF_CURSOR_1   = 9,
                TURN_OFF_CURSOR_2   = 10,

                SANG_WRITE_S_1      = 11,
                SANG_WRITE_S_2      = 12,
                SANG_WRITE_A_1      = 13,
                SANG_WRITE_A_2      = 14,
                SANG_WRITE_N_1      = 15,
                SANG_WRITE_N_2      = 16,
                SANG_WRITE_G_1      = 17,
                SANG_WRITE_G_2      = 18,

                TRUA_WRITE_T_1      = 19,
                TRUA_WRITE_T_2      = 20,
                TRUA_WRITE_R_1      = 21,
                TRUA_WRITE_R_2      = 23,
                TRUA_WRITE_U_1      = 24,
                TRUA_WRITE_U_2      = 25,
                TRUA_WRITE_A_1      = 26,
                TRUA_WRITE_A_2      = 27,

                CHIEU_WRITE_C_1     = 28,
                CHIEU_WRITE_C_2     = 29,
                CHIEU_WRITE_H_1     = 30,
                CHIEU_WRITE_H_2     = 31,
                CHIEU_WRITE_I_1     = 32,
                CHIEU_WRITE_I_2     = 33,
                CHIEU_WRITE_E_1     = 34,
                CHIEU_WRITE_E_2     = 35,
                CHIEU_WRITE_U_1     = 36, 
                CHIEU_WRITE_U_2     = 37,

                TOI_WRITE_T_1       = 38,
                TOI_WRITE_T_2       = 39, 
                TOI_WRITE_O_1       = 40,
                TOI_WRITE_O_2       = 41,
                TOI_WRITE_I_1       = 42,
                TOI_WRITE_I_2       = 43,

                IDLE                = 44;


    reg         RS;     
    reg         EN;
    reg [7:0]   DATA_out;
    wire        RW = 1'b0;

    assign pin[14:7] = DATA_out;
    assign pin[6]    = EN;
    assign pin[5]    = RW;
    assign pin[4]    = RS;

    wire us_clk;
    freq_divider #(.divisor(125_000))us_divider(
        .SYS_clk    (SYS_clk),
//        .SYS_reset  (SYS_reset), 
        .divided_clk(us_clk)
    );

    reg [5:0]  next_state;
    reg [1:0]  old_buttons;

    //define the current state
    always @(negedge us_clk) 
    begin
        old_buttons <= SYS_buttons;
        if (SYS_reset || (old_buttons != SYS_buttons))
            state <= CLEAR_0;

        else
            state <= next_state;
    end

    //define the next state
    //it only depends on the current state cause of no input!
    always @(state)
    begin
        case (state)
            CLEAR_0:            next_state = CLEAR_1;
            CLEAR_1:            next_state = CLEAR_2;
            CLEAR_2:            next_state = SET_TWO_LINE_1;

            SET_TWO_LINE_1:     next_state = SET_TWO_LINE_2;
            SET_TWO_LINE_2:     next_state = INCREMENT_CURSOR_1;
            INCREMENT_CURSOR_1: next_state = INCREMENT_CURSOR_2;
            INCREMENT_CURSOR_2: next_state = RETURN_HOME_1;
            RETURN_HOME_1:      next_state = RETURN_HOME_2;
            RETURN_HOME_2:      next_state = TURN_OFF_CURSOR_1;
            TURN_OFF_CURSOR_1:  next_state = TURN_OFF_CURSOR_2;
            TURN_OFF_CURSOR_2: 
                case (SYS_buttons)
                    SANG:       next_state = SANG_WRITE_S_1;
                    TRUA:       next_state = TRUA_WRITE_T_1;
                    CHIEU:      next_state = CHIEU_WRITE_C_1;
                    TOI:        next_state = TOI_WRITE_T_1;
                endcase
            
            SANG_WRITE_S_1:     next_state = SANG_WRITE_S_2;
            SANG_WRITE_S_2:     next_state = SANG_WRITE_A_1;
            SANG_WRITE_A_1:     next_state = SANG_WRITE_A_2; 
            SANG_WRITE_A_2:     next_state = SANG_WRITE_N_1;
            SANG_WRITE_N_1:     next_state = SANG_WRITE_N_2;
            SANG_WRITE_N_2:     next_state = SANG_WRITE_G_1;
            SANG_WRITE_G_1:     next_state = SANG_WRITE_G_2;
            SANG_WRITE_G_2:     next_state = IDLE;

            TRUA_WRITE_T_1:     next_state = TRUA_WRITE_T_2;
            TRUA_WRITE_T_2:     next_state = TRUA_WRITE_R_1;
            TRUA_WRITE_R_1:     next_state = TRUA_WRITE_R_2;
            TRUA_WRITE_R_2:     next_state = TRUA_WRITE_U_1;
            TRUA_WRITE_U_1:     next_state = TRUA_WRITE_U_2;
            TRUA_WRITE_U_2:     next_state = TRUA_WRITE_A_1;
            TRUA_WRITE_A_1:     next_state = TRUA_WRITE_A_2;
            TRUA_WRITE_A_2:     next_state = IDLE;

            CHIEU_WRITE_C_1:    next_state = CHIEU_WRITE_C_2;
            CHIEU_WRITE_C_2:    next_state = CHIEU_WRITE_H_1;
            CHIEU_WRITE_H_1:    next_state = CHIEU_WRITE_H_2;
            CHIEU_WRITE_H_2:    next_state = CHIEU_WRITE_I_1;
            CHIEU_WRITE_I_1:    next_state = CHIEU_WRITE_I_2;
            CHIEU_WRITE_I_2:    next_state = CHIEU_WRITE_E_1;
            CHIEU_WRITE_E_1:    next_state = CHIEU_WRITE_E_2;
            CHIEU_WRITE_E_2:    next_state = CHIEU_WRITE_U_1;
            CHIEU_WRITE_U_1:    next_state = CHIEU_WRITE_U_2;
            CHIEU_WRITE_U_2:    next_state = IDLE;

            TOI_WRITE_T_1:      next_state = TOI_WRITE_T_2;
            TOI_WRITE_T_2:      next_state = TOI_WRITE_O_1;
            TOI_WRITE_O_1:      next_state = TOI_WRITE_O_2;
            TOI_WRITE_O_2:      next_state = TOI_WRITE_I_1;
            TOI_WRITE_I_1:      next_state = TOI_WRITE_I_2;
            TOI_WRITE_I_2:      next_state = IDLE;

            IDLE:               next_state = IDLE;
            default:            next_state = IDLE;
        endcase

    end

    //define the output to the lcd
    always @(state)
    begin
        case (state)
            CLEAR_0: begin
                RS = 0;
                EN = 0;
                DATA_out = CLEAR_DISPLAY_SIGNAL;
            end

            CLEAR_1: begin
                RS = 0;
                EN = 1;
                DATA_out = CLEAR_DISPLAY_SIGNAL;
            end

            CLEAR_2: begin
                RS = 0;
                EN = 0;
                DATA_out = CLEAR_DISPLAY_SIGNAL;
            end

            SET_TWO_LINE_1: begin
                RS = 0;
                EN = 1;
                DATA_out = TWO_LINE_SIGNAL;
            end

            SET_TWO_LINE_2: begin
                RS = 0;
                EN = 0;
                DATA_out = TWO_LINE_SIGNAL;
            end

            INCREMENT_CURSOR_1: begin
                RS = 0;
                EN = 1;
                DATA_out = INCREMENT_CURSOR_SIGNAL;
            end

            INCREMENT_CURSOR_2: begin
                RS = 0;
                EN = 0;
                DATA_out = INCREMENT_CURSOR_SIGNAL;
            end

            RETURN_HOME_1: begin
                RS = 0;
                EN = 1;
                DATA_out = RETURN_HOME_SIGNAL;
            end
            
            RETURN_HOME_2: begin
                RS = 0;
                EN = 0;
                DATA_out = RETURN_HOME_SIGNAL;
            end
            
            TURN_OFF_CURSOR_1: begin
                RS = 0;
                EN = 1;
                DATA_out = DISPLAYON_CURSOROFF_SIGNAL;
            end
            
            TURN_OFF_CURSOR_2: begin
                RS = 0;
                EN = 0;
                DATA_out = DISPLAYON_CURSOROFF_SIGNAL;
            end
            
            SANG_WRITE_S_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "S";
            end
            
            SANG_WRITE_S_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "S";
            end
            
            SANG_WRITE_A_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "A";
            end
            
            SANG_WRITE_A_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "A";
            end
            
            SANG_WRITE_N_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "N";
            end
            
            SANG_WRITE_N_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "N";
            end
            
            SANG_WRITE_G_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "G";
            end
            
            SANG_WRITE_G_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "G";
            end

            TRUA_WRITE_T_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "T";
            end
            
            TRUA_WRITE_T_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "T";
            end
            
            TRUA_WRITE_R_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "R";
            end
            
            TRUA_WRITE_R_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "R";
            end
            
            TRUA_WRITE_U_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "U";
            end
            
            TRUA_WRITE_U_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "U";
            end
            
            TRUA_WRITE_A_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "A";
            end
            
            TRUA_WRITE_A_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "A";
            end

            CHIEU_WRITE_C_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "C";
            end

            CHIEU_WRITE_C_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "C";
            end

            CHIEU_WRITE_H_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "H";
            end

            CHIEU_WRITE_H_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "H";
            end

            CHIEU_WRITE_I_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "I";
            end

            CHIEU_WRITE_I_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "H";
            end

            CHIEU_WRITE_E_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "E";
            end

            CHIEU_WRITE_E_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "E";
            end

            CHIEU_WRITE_U_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "U";
            end

            CHIEU_WRITE_U_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "U";
            end

            TOI_WRITE_T_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "T";
            end

            TOI_WRITE_T_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "T";
            end

            TOI_WRITE_O_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "O";
            end

            TOI_WRITE_O_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "O";
            end

            TOI_WRITE_I_1: begin
                EN = 1;
                RS = 1;
                DATA_out = "I";
            end

            TOI_WRITE_I_2: begin
                EN = 0;
                RS = 1;
                DATA_out = "I";
            end
            
            IDLE: begin
                EN = 0;
                RS = 1'bx;
                DATA_out = 8'dx;
            end
            default: begin
                EN = 0;
                RS = 1'bx;
                DATA_out = 8'dx;
            end
        endcase
    end
endmodule



module freq_divider(
    input SYS_clk,
    output reg divided_clk
);
    parameter divisor = 125_000_000;
    parameter m = divisor/2;
    integer count;
    
    initial count = 0;
    always @(negedge SYS_clk)
    begin
        if (count >= m)
        begin
            count        <= 0;
            divided_clk  <= ~divided_clk;
        end
        else count <= count + 1;
    end
endmodule
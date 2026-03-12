module traffic_light_controller(
    input clk,
    input reset,
    input emergency,
    output reg NS_R, NS_Y, NS_G,
    output reg EW_R, EW_Y, EW_G
);

// FSM States
parameter S0 = 2'b00;  // NS Green
parameter S1 = 2'b01;  // NS Yellow
parameter S2 = 2'b10;  // EW Green
parameter S3 = 2'b11;  // EW Yellow

reg [1:0] state, next_state;
reg [3:0] timer;

// State Register
always @(posedge clk or posedge reset)
begin
    if(reset)
        state <= S0;
    else
        state <= next_state;
end

// Timer Logic
always @(posedge clk or posedge reset)
begin
    if(reset)
        timer <= 0;
    else
        timer <= timer + 1;
end

// Next State Logic
always @(*)
begin
    case(state)

    S0: begin
        if(emergency)
            next_state = S0;
        else if(timer == 5)
            next_state = S1;
        else
            next_state = S0;
    end

    S1: begin
        if(timer == 2)
            next_state = S2;
        else
            next_state = S1;
    end

    S2: begin
        if(timer == 5)
            next_state = S3;
        else
            next_state = S2;
    end

    S3: begin
        if(timer == 2)
            next_state = S0;
        else
            next_state = S3;
    end

    endcase
end

// Output Logic
always @(*)
begin
    case(state)

    S0: begin
        NS_G=1; NS_Y=0; NS_R=0;
        EW_G=0; EW_Y=0; EW_R=1;
    end

    S1: begin
        NS_G=0; NS_Y=1; NS_R=0;
        EW_G=0; EW_Y=0; EW_R=1;
    end

    S2: begin
        NS_G=0; NS_Y=0; NS_R=1;
        EW_G=1; EW_Y=0; EW_R=0;
    end

    S3: begin
        NS_G=0; NS_Y=0; NS_R=1;
        EW_G=0; EW_Y=1; EW_R=0;
    end

    endcase
end

endmodule
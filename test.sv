`timescale 1ns/1ps

module traffic_tb;

reg clk;
reg reset;
reg emergency;

wire NS_R, NS_Y, NS_G;
wire EW_R, EW_Y, EW_G;

// Instantiate DUT
traffic_light_controller uut (
    .clk(clk),
    .reset(reset),
    .emergency(emergency),
    .NS_R(NS_R),
    .NS_Y(NS_Y),
    .NS_G(NS_G),
    .EW_R(EW_R),
    .EW_Y(EW_Y),
    .EW_G(EW_G)
);

// Clock generation
always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;
    emergency = 0;

    #10 reset = 0;

    // Normal operation
    #60;

    // Emergency vehicle detected
    emergency = 1;

    #30;

    emergency = 0;

    #80;

    $finish;
end

initial
begin
    $dumpfile("traffic.vcd");
    $dumpvars(0,traffic_tb);
end

endmodule
`timescale 1ns/1ps
module pwm_gen #(parameter WIDTH = 8)(
    input  wire             clk,
    input  wire             rst,
    input  wire             en,
    input  wire [WIDTH-1:0] duty,
    output reg              pwm_out
);
    reg [WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (rst) begin
            cnt     <= {WIDTH{1'b0}};
            pwm_out <= 1'b0;
        end else if (en) begin
            cnt     <= cnt + 1'b1;
            pwm_out <= (cnt < duty);
        end else begin
            pwm_out <= 1'b0;
        end
    end
endmodule
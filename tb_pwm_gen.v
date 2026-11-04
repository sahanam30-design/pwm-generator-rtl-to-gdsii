`timescale 1ns/1ps
module tb_pwm_gen;
    reg        clk = 0, rst, en;
    reg  [7:0] duty;
    wire       pwm_out;
    integer    fails = 0;

    pwm_gen #(8) dut (.clk(clk), .rst(rst), .en(en), .duty(duty), .pwm_out(pwm_out));

    always #5 clk = ~clk;

    task measure(input [7:0] d);
        integer high, i;
        begin
            @(negedge clk); duty = d;
            repeat (3) @(posedge clk);
            high = 0;
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge clk); #1;
                if (pwm_out) high = high + 1;
            end
            if (high == d)
                $display("PASS  duty=%0d  high=%0d/256 (%0d%%)", d, high, (high*100)/256);
            else begin
                $display("FAIL  duty=%0d  high=%0d/256", d, high);
                fails = fails + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("pwm_gen.vcd");
        $dumpvars(0, tb_pwm_gen);
        rst = 1; en = 0; duty = 8'd0;
        #25;
        @(negedge clk); rst = 0; en = 1;

        measure(8'd0);
        measure(8'd64);
        measure(8'd128);
        measure(8'd192);
        measure(8'd255);

        @(negedge clk); en = 0;
        repeat (4) @(posedge clk);
        #1;
        if (pwm_out === 1'b0) $display("PASS  en=0 keeps output low");
        else begin $display("FAIL  output high while disabled"); fails = fails + 1; end

        #20;
        if (fails == 0) $display("ALL TESTS PASSED");
        else            $display("%0d TEST(S) FAILED", fails);
        $finish;
    end
endmodule
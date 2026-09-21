`timescale 1ns/1ps

module tb_conv_optimized;

    reg clk;
    reg rst;
    reg load_en;
    reg [4:0] addr;
    reg signed [15:0] data_in;
    reg start;

    wire signed [35:0] y;
    wire done;

    integer errors;

    // DUT: Pipelined 3x3 Convolution Engine
    conv_optimized DUT (
        .clk     (clk),
        .rst     (rst),
        .load_en (load_en),
        .addr    (addr),
        .data_in (data_in),
        .start   (start),
        .y       (y),
        .done    (done)
    );

    // 100 MHz clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Waveform dump
    initial begin
        $dumpfile("conv_optimized_5tests.vcd");
        $dumpvars(0, tb_conv_optimized);
    end

    // Task to load a pixel/kernel value
    task load_value;
        input [4:0] address;
        input signed [15:0] value;
        begin
            @(negedge clk);
            addr = address;
            data_in = value;
            load_en = 1'b1;

            @(posedge clk);
            #1;
            load_en = 1'b0;
        end
    endtask

    // Task to start convolution and await pipelined done flag
    task run_convolution;
        begin
            @(negedge clk);
            start = 1'b1;

            @(posedge clk);
            #1;
            start = 1'b0;

            wait(done == 1'b1);
            #1;
        end
    endtask

    // Test sequence
    initial begin

        errors = 0;

        rst = 1'b1;
        load_en = 1'b0;
        start = 1'b0;
        addr = 5'd0;
        data_in = 16'sd0;

        // Reset
        repeat(2)
            @(posedge clk);
        #1;

        rst = 1'b0;

        // ------------------------------------------------
        // Load 3x3 Pixel Matrix
        // 10 20 30
        // 40 50 60
        // 70 80 90
        // ------------------------------------------------

        load_value(5'd0, 16'sd10);
        load_value(5'd1, 16'sd20);
        load_value(5'd2, 16'sd30);
        load_value(5'd3, 16'sd40);
        load_value(5'd4, 16'sd50);
        load_value(5'd5, 16'sd60);
        load_value(5'd6, 16'sd70);
        load_value(5'd7, 16'sd80);
        load_value(5'd8, 16'sd90);

        // =================================================
        // TEST 1 : IDENTITY FILTER
        // 0 0 0
        // 0 1 0
        // 0 0 0
        // Expected = 50
        // =================================================

        load_value(5'd9,  16'sd0);
        load_value(5'd10, 16'sd0);
        load_value(5'd11, 16'sd0);
        load_value(5'd12, 16'sd0);
        load_value(5'd13, 16'sd1);
        load_value(5'd14, 16'sd0);
        load_value(5'd15, 16'sd0);
        load_value(5'd16, 16'sd0);
        load_value(5'd17, 16'sd0);

        run_convolution();

        $display("--------------------------------------------");
        $display("TEST 1 : IDENTITY FILTER (PIPELINED)");
        $display("Expected = 50");
        $display("Output = %0d", y);

        if (y !== 36'sd50) begin
            errors = errors + 1;
            $display("STATUS = FAIL");
        end
        else begin
            $display("STATUS = PASS");
        end


        // =================================================
        // TEST 2 : BLUR FILTER
        // 1 1 1
        // 1 1 1
        // 1 1 1
        // Expected = 450
        // =================================================

        load_value(5'd9,  16'sd1);
        load_value(5'd10, 16'sd1);
        load_value(5'd11, 16'sd1);
        load_value(5'd12, 16'sd1);
        load_value(5'd13, 16'sd1);
        load_value(5'd14, 16'sd1);
        load_value(5'd15, 16'sd1);
        load_value(5'd16, 16'sd1);
        load_value(5'd17, 16'sd1);

        run_convolution();

        $display("--------------------------------------------");
        $display("TEST 2 : BLUR FILTER (PIPELINED)");
        $display("Expected = 450");
        $display("Output = %0d", y);

        if (y !== 36'sd450) begin
            errors = errors + 1;
            $display("STATUS = FAIL");
        end
        else begin
            $display("STATUS = PASS");
        end


        // =================================================
        // TEST 3 : EDGE DETECTION
        // -1 -1 -1
        // -1  8 -1
        // -1 -1 -1
        // Expected = 0
        // =================================================

        load_value(5'd9,  -16'sd1);
        load_value(5'd10, -16'sd1);
        load_value(5'd11, -16'sd1);
        load_value(5'd12, -16'sd1);
        load_value(5'd13,  16'sd8);
        load_value(5'd14, -16'sd1);
        load_value(5'd15, -16'sd1);
        load_value(5'd16, -16'sd1);
        load_value(5'd17, -16'sd1);

        run_convolution();

        $display("--------------------------------------------");
        $display("TEST 3 : EDGE DETECTION (PIPELINED)");
        $display("Expected = 0");
        $display("Output = %0d", y);

        if (y !== 36'sd0) begin
            errors = errors + 1;
            $display("STATUS = FAIL");
        end
        else begin
            $display("STATUS = PASS");
        end


        // =================================================
        // TEST 4 : SHARPENING
        //  0 -1  0
        // -1  5 -1
        //  0 -1  0
        // Expected = 50
        // =================================================

        load_value(5'd9,  16'sd0);
        load_value(5'd10, -16'sd1);
        load_value(5'd11,  16'sd0);
        load_value(5'd12, -16'sd1);
        load_value(5'd13,  16'sd5);
        load_value(5'd14, -16'sd1);
        load_value(5'd15,  16'sd0);
        load_value(5'd16, -16'sd1);
        load_value(5'd17,  16'sd0);

        run_convolution();

        $display("--------------------------------------------");
        $display("TEST 4 : SHARPENING (PIPELINED)");
        $display("Expected = 50");
        $display("Output = %0d", y);

        if (y !== 36'sd50) begin
            errors = errors + 1;
            $display("STATUS = FAIL");
        end
        else begin
            $display("STATUS = PASS");
        end


        // =================================================
        // TEST 5 : EMBOSS
        // -2 -1  0
        // -1  1  1
        //  0  1  2
        // Expected = 290
        // =================================================

        load_value(5'd9,  -16'sd2);
        load_value(5'd10, -16'sd1);
        load_value(5'd11,  16'sd0);
        load_value(5'd12, -16'sd1);
        load_value(5'd13,  16'sd1);
        load_value(5'd14,  16'sd1);
        load_value(5'd15,  16'sd0);
        load_value(5'd16,  16'sd1);
        load_value(5'd17,  16'sd2);

        run_convolution();

        $display("--------------------------------------------");
        $display("TEST 5 : EMBOSS (PIPELINED)");
        $display("Expected = 290");
        $display("Output = %0d", y);

        if (y !== 36'sd290) begin
            errors = errors + 1;
            $display("STATUS = FAIL");
        end
        else begin
            $display("STATUS = PASS");
        end


        // =================================================
        // FINAL RESULT
        // =================================================

        $display("--------------------------------------------");
        $display("ALL PIPELINED TEST CASES COMPLETED");
        $display("Total Errors = %0d", errors);

        if (errors == 0)
            $display("FINAL RESULT = PASS");
        else
            $display("FINAL RESULT = FAIL");

        $display("--------------------------------------------");

        #20;
        $finish;

    end

endmodule

module conv (
    input clk,
    input rst,
    input load_en,
    input [4:0] addr,
    input signed [15:0] data_in,
    input start,
    output reg signed [35:0] y,
    output reg done
);

    // Pixel registers
    reg signed [15:0] p00, p01, p02;
    reg signed [15:0] p10, p11, p12;
    reg signed [15:0] p20, p21, p22;

    // Kernel registers
    reg signed [15:0] k00, k01, k02;
    reg signed [15:0] k10, k11, k12;
    reg signed [15:0] k20, k21, k22;

    // Input loading
    always @(posedge clk) begin
        if (rst) begin
            p00 <= 0;
            p01 <= 0;
            p02 <= 0;
            p10 <= 0;
            p11 <= 0;
            p12 <= 0;
            p20 <= 0;
            p21 <= 0;
            p22 <= 0;

            k00 <= 0;
            k01 <= 0;
            k02 <= 0;
            k10 <= 0;
            k11 <= 0;
            k12 <= 0;
            k20 <= 0;
            k21 <= 0;
            k22 <= 0;
        end

        else if (load_en) begin
            case (addr)
                // Pixel registers
                5'd0:  p00 <= data_in;
                5'd1:  p01 <= data_in;
                5'd2:  p02 <= data_in;
                5'd3:  p10 <= data_in;
                5'd4:  p11 <= data_in;
                5'd5:  p12 <= data_in;
                5'd6:  p20 <= data_in;
                5'd7:  p21 <= data_in;
                5'd8:  p22 <= data_in;

                // Kernel registers
                5'd9:  k00 <= data_in;
                5'd10: k01 <= data_in;
                5'd11: k02 <= data_in;
                5'd12: k10 <= data_in;
                5'd13: k11 <= data_in;
                5'd14: k12 <= data_in;
                5'd15: k20 <= data_in;
                5'd16: k21 <= data_in;
                5'd17: k22 <= data_in;

                default: begin
                end
            endcase
        end
    end

    // Nine parallel 16x16 signed multipliers
    wire signed [31:0] m00, m01, m02;
    wire signed [31:0] m10, m11, m12;
    wire signed [31:0] m20, m21, m22;

    assign m00 = p00 * k00;
    assign m01 = p01 * k01;
    assign m02 = p02 * k02;
    assign m10 = p10 * k10;
    assign m11 = p11 * k11;
    assign m12 = p12 * k12;
    assign m20 = p20 * k20;
    assign m21 = p21 * k21;
    assign m22 = p22 * k22;

    // First level of adder tree
    wire signed [32:0] s0, s1, s2, s3;

    assign s0 = m00 + m01;
    assign s1 = m02 + m10;
    assign s2 = m11 + m12;
    assign s3 = m20 + m21;

    // Second level of adder tree
    wire signed [33:0] t0, t1;

    assign t0 = s0 + s1;
    assign t1 = s2 + s3;

    // Third level of adder tree
    wire signed [34:0] u0;

    assign u0 = t0 + t1;

    // Final 36-bit signed convolution result
    wire signed [35:0] convolution_result;

    assign convolution_result =
        {u0[34], u0} +
        {{4{m22[31]}}, m22};

    // Output register
    always @(posedge clk) begin
        if (rst) begin
            y <= 0;
            done <= 0;
        end
        else begin
            done <= 0;

            if (start) begin
                y <= convolution_result;
                done <= 1;
            end
        end
    end

endmodule

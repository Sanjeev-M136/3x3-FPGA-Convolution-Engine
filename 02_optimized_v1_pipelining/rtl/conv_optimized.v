module conv_optimized (
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

    // Input loading (retaining identical address map as baseline)
    always @(posedge clk) begin
        if (rst) begin
            p00 <= 16'sd0; p01 <= 16'sd0; p02 <= 16'sd0;
            p10 <= 16'sd0; p11 <= 16'sd0; p12 <= 16'sd0;
            p20 <= 16'sd0; p21 <= 16'sd0; p22 <= 16'sd0;

            k00 <= 16'sd0; k01 <= 16'sd0; k02 <= 16'sd0;
            k10 <= 16'sd0; k11 <= 16'sd0; k12 <= 16'sd0;
            k20 <= 16'sd0; k21 <= 16'sd0; k22 <= 16'sd0;
        end else if (load_en) begin
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
                default: begin end
            endcase
        end
    end

    // =========================================================================
    // PIPELINE STAGE 1: Parallel 16x16 Multiplier Registers
    // Maps directly into DSP block internal output registers
    // =========================================================================
    reg signed [31:0] m00_r, m01_r, m02_r;
    reg signed [31:0] m10_r, m11_r, m12_r;
    reg signed [31:0] m20_r, m21_r, m22_r;

    always @(posedge clk) begin
        if (rst) begin
            m00_r <= 32'sd0; m01_r <= 32'sd0; m02_r <= 32'sd0;
            m10_r <= 32'sd0; m11_r <= 32'sd0; m12_r <= 32'sd0;
            m20_r <= 32'sd0; m21_r <= 32'sd0; m22_r <= 32'sd0;
        end else begin
            m00_r <= p00 * k00;
            m01_r <= p01 * k01;
            m02_r <= p02 * k02;
            m10_r <= p10 * k10;
            m11_r <= p11 * k11;
            m12_r <= p12 * k12;
            m20_r <= p20 * k20;
            m21_r <= p21 * k21;
            m22_r <= p22 * k22;
        end
    end

    // =========================================================================
    // PIPELINE STAGE 2: Adder Tree Level 1 (Pairwise Partial Sums)
    // =========================================================================
    reg signed [32:0] s0_r, s1_r, s2_r, s3_r;
    reg signed [31:0] m22_r2;

    always @(posedge clk) begin
        if (rst) begin
            s0_r   <= 33'sd0;
            s1_r   <= 33'sd0;
            s2_r   <= 33'sd0;
            s3_r   <= 33'sd0;
            m22_r2 <= 32'sd0;
        end else begin
            s0_r   <= m00_r + m01_r;
            s1_r   <= m02_r + m10_r;
            s2_r   <= m11_r + m12_r;
            s3_r   <= m20_r + m21_r;
            m22_r2 <= m22_r;
        end
    end

    // =========================================================================
    // PIPELINE STAGE 3: Adder Tree Level 2 (Quad Partial Sums)
    // =========================================================================
    reg signed [33:0] t0_r, t1_r;
    reg signed [31:0] m22_r3;

    always @(posedge clk) begin
        if (rst) begin
            t0_r   <= 34'sd0;
            t1_r   <= 34'sd0;
            m22_r3 <= 32'sd0;
        end else begin
            t0_r   <= s0_r + s1_r;
            t1_r   <= s2_r + s3_r;
            m22_r3 <= m22_r2;
        end
    end

    // =========================================================================
    // PIPELINE STAGE 4: Final Addition and Output Register
    // =========================================================================
    wire signed [34:0] u0 = t0_r + t1_r;
    wire signed [35:0] convolution_result = {u0[34], u0} + {{4{m22_r3[31]}}, m22_r3};

    // Control pipeline shift register: 4-cycle latency from start to done
    reg [3:0] start_pipe;

    always @(posedge clk) begin
        if (rst) begin
            start_pipe <= 4'b0000;
            y          <= 36'sd0;
            done       <= 1'b0;
        end else begin
            start_pipe <= {start_pipe[2:0], start};
            done       <= start_pipe[3];

            if (start_pipe[3]) begin
                y <= convolution_result;
            end
        end
    end

endmodule

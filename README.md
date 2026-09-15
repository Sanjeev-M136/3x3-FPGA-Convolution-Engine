# 3×3 FPGA Convolution Engine

A Verilog HDL implementation of a 3×3 image convolution engine using nine parallel signed 16×16 multipliers and a multi-level adder tree, targeted to an Intel Cyclone V FPGA.

## Overview

Convolution is a fundamental operation in digital image processing used for applications such as:

- Image blurring
- Edge detection
- Sharpening
- Embossing

This project implements the hardware computation for a single 3×3 image patch.

The design performs nine pixel–kernel multiplications in parallel and combines the resulting partial products using a multi-level adder tree to generate a 36-bit signed convolution result.

## Architecture

```text
              3×3 Pixel Patch
                     │
                     │
              3×3 Kernel
                     │
                     ▼
        ┌────────────────────────┐
        │  9 Parallel Multipliers│
        │       16 × 16          │
        └────────────────────────┘
                     │
                     ▼
              Partial Products
                     │
                     ▼
        ┌────────────────────────┐
        │    Multi-Level Adder   │
        │         Tree           │
        └────────────────────────┘
                     │
                     ▼
              36-bit Signed
             Convolution Result
                     │
                     ▼
               Registered y
vlib work
vlog -work work rtl/conv_optimized.v simulation/tb_conv_optimized.v
vsim -voptargs=+acc work.tb_conv_optimized

add wave -divider "Clock & Reset"
add wave -color Yellow /tb_conv_optimized/clk
add wave -color Red /tb_conv_optimized/rst

add wave -divider "Control & Handshake"
add wave -color Cyan /tb_conv_optimized/load_en
add wave -color Green /tb_conv_optimized/start
add wave -color Orange /tb_conv_optimized/done

add wave -divider "Inputs"
add wave -radix unsigned -color White /tb_conv_optimized/addr
add wave -radix decimal -color White /tb_conv_optimized/data_in

add wave -divider "Pipeline Registers (Center Element)"
add wave -radix decimal /tb_conv_optimized/DUT/p11
add wave -radix decimal /tb_conv_optimized/DUT/k11
add wave -radix decimal /tb_conv_optimized/DUT/m11_r
add wave -radix decimal /tb_conv_optimized/DUT/s2_r
add wave -radix decimal /tb_conv_optimized/DUT/t1_r

add wave -divider "Convolution Output"
add wave -radix decimal -color Magenta /tb_conv_optimized/y

run -all
wave zoom full

Add-Type -AssemblyName System.Drawing

$width = 1600
$height = 980

$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Characters
$charMult = [char]0x00D7
$charBullet = [char]0x2022

# Fonts
$fontHeader = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
$fontSubHeader = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Regular)
$fontStageTitle = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
$fontStageSub = New-Object System.Drawing.Font("Segoe UI", 7.5, [System.Drawing.FontStyle]::Regular)
$fontReg = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
$fontSymbol = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$fontSymbolLg = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fontLabel = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)
$fontBoldLabel = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$fontTiny = New-Object System.Drawing.Font("Segoe UI", 7, [System.Drawing.FontStyle]::Regular)

# Brushes & Pens
$brushBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(248, 250, 252))
$brushWhite = [System.Drawing.Brushes]::White
$brushDark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15, 23, 42))
$brushGray = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 116, 139))
$brushNavy = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 58, 138))
$brushBlue = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 64, 175))
$brushGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(21, 128, 61))
$brushOrange = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(194, 65, 12))
$brushPurple = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(107, 33, 168))

$penBlue = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 64, 175), 1.8)
$penGreen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(21, 128, 61), 1.8)
$penOrange = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(194, 65, 12), 1.8)
$penPurple = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(107, 33, 168), 2.0)
$penGray = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(203, 213, 225), 1.0)
$penDark = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(51, 65, 85), 1.4)

# 1. Background
$g.FillRectangle($brushBg, 0, 0, $width, $height)

# 2. Header
$brushHeaderBar = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(0, 0)),
    (New-Object System.Drawing.Point($width, 0)),
    [System.Drawing.Color]::FromArgb(15, 23, 42),
    [System.Drawing.Color]::FromArgb(30, 58, 138)
)
$g.FillRectangle($brushHeaderBar, 0, 0, $width, 64)
$g.DrawString("IEEE Standard Microarchitecture: 4-Stage Pipelined 2D Convolution Accelerator", $fontHeader, $brushWhite, 25, 12)
$g.DrawString("Target FPGA: Intel Cyclone V (5CSXFC6D6F31C6) | 185.15 MHz Fmax | Clock: 10.0 ns | conv_optimized.v", $fontSubHeader, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(147, 197, 253))), 27, 39)

# 3. Stages Column Boxes
$stages = @(
    @{ Name="STAGE 0: INPUTS & STORAGE"; Sub="Cycle 0: Addr Decode & Latch"; X=25; W=235; Bg=[System.Drawing.Color]::FromArgb(241, 245, 249); Accent=[System.Drawing.Color]::FromArgb(71, 85, 105) },
    @{ Name="STAGE 1: 16" + $charMult + "16 MULTIPLIERS"; Sub="Cycle 1: 9 Parallel DSP Multipliers"; X=275; W=285; Bg=[System.Drawing.Color]::FromArgb(239, 246, 255); Accent=[System.Drawing.Color]::FromArgb(30, 64, 175) },
    @{ Name="STAGE 2: ADDER TREE LEVEL 1"; Sub="Cycle 2: 4 Pairwise Sums + Delay Reg"; X=575; W=285; Bg=[System.Drawing.Color]::FromArgb(240, 253, 244); Accent=[System.Drawing.Color]::FromArgb(21, 128, 61) },
    @{ Name="STAGE 3: ADDER TREE LEVEL 2"; Sub="Cycle 3: 2 Quad Sums + Delay Reg"; X=875; W=285; Bg=[System.Drawing.Color]::FromArgb(255, 247, 237); Accent=[System.Drawing.Color]::FromArgb(194, 65, 12) },
    @{ Name="STAGE 4: ACCUMULATION & OUTPUT"; Sub="Cycle 4: Final Sum & Handshake"; X=1175; W=400; Bg=[System.Drawing.Color]::FromArgb(250, 245, 255); Accent=[System.Drawing.Color]::FromArgb(107, 33, 168) }
)

foreach ($st in $stages) {
    $brushColBg = New-Object System.Drawing.SolidBrush($st.Bg)
    $brushColAccent = New-Object System.Drawing.SolidBrush($st.Accent)
    $penDash = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(203, 213, 225), 1.2)
    $penDash.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash

    $g.FillRectangle($brushColBg, $st.X, 76, $st.W, 825)
    $g.DrawRectangle($penDash, $st.X, 76, $st.W, 825)
    $g.FillRectangle($brushColAccent, $st.X, 76, $st.W, 38)

    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString($st.Name, $fontStageTitle, $brushWhite, ($st.X + $st.W / 2), 82, $sf)
    $g.DrawString($st.Sub, $fontStageSub, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(226, 232, 240))), ($st.X + $st.W / 2), 97, $sf)
}

# 4. Control Path Bar across stages (Y: 125 to 175)
$g.FillRectangle($brushWhite, 35, 125, 1530, 52)
$g.DrawRectangle($penGray, 35, 125, 1530, 52)
$g.DrawString("CONTROL PATH & HANDSHAKE: 4-Stage Shift Register (start_pipe[3:0] -> done)", $fontBoldLabel, $brushDark, 48, 131)

# start input port
$g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(241, 245, 249))), 48, 147, 55, 22)
$g.DrawRectangle($penGray, 48, 147, 55, 22)
$g.DrawString("start", $fontReg, $brushDark, 62, 151)

# FFs in Control Path
$ctrlFFs = @(
    @{ Name="pipe[0]"; X=385; Color=[System.Drawing.Color]::FromArgb(30, 64, 175) },
    @{ Name="pipe[1]"; X=685; Color=[System.Drawing.Color]::FromArgb(21, 128, 61) },
    @{ Name="pipe[2]"; X=985; Color=[System.Drawing.Color]::FromArgb(194, 65, 12) },
    @{ Name="pipe[3]"; X=1285; Color=[System.Drawing.Color]::FromArgb(107, 33, 168) }
)

$prevX = 103
foreach ($cff in $ctrlFFs) {
    $p = New-Object System.Drawing.Pen($cff.Color, 1.8)
    $p.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
    $g.DrawLine($p, $prevX, 158, $cff.X, 158)

    $b = New-Object System.Drawing.SolidBrush($cff.Color)
    $g.FillRectangle($brushWhite, $cff.X, 144, 65, 26)
    $g.DrawRectangle((New-Object System.Drawing.Pen($cff.Color, 1.5)), $cff.X, 144, 65, 26)
    $g.DrawString($cff.Name, $fontBoldLabel, $b, ($cff.X + 10), 150)
    $prevX = $cff.X + 65
}

# done output port
$pDone = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(107, 33, 168), 2.0)
$pDone.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
$g.DrawLine($pDone, $prevX, 158, 1455, 158)
$g.FillRectangle($brushNavy, 1455, 145, 75, 25)
$g.DrawString("done", $fontReg, $brushWhite, 1478, 150)

# 5. Datapath Inputs & Address Map (Y: 185 to 240)
$g.FillRectangle($brushWhite, 35, 185, 95, 52)
$g.DrawRectangle($penGray, 35, 185, 95, 52)
$g.DrawString("data_in [15:0]", $fontBoldLabel, $brushDark, 42, 191)
$g.DrawString("addr [4:0]", $fontLabel, $brushGray, 42, 206)
$g.DrawString("load_en, clk", $fontLabel, $brushGray, 42, 220)

$g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(248, 250, 252))), 150, 185, 100, 52)
$g.DrawRectangle($penGray, 150, 185, 100, 52)
$g.DrawString("Address Map", $fontBoldLabel, $brushDark, 162, 191)
$g.DrawString("0..8: Pixels (p_ij)", $fontTiny, $brushGray, 162, 207)
$g.DrawString("9..17: Kernel (k_ij)", $fontTiny, $brushGray, 162, 220)

$pArrow = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(71, 85, 105), 1.4)
$pArrow.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
$g.DrawLine($pArrow, 130, 211, 150, 211)

# 6. Datapath 9 Parallel Rows (Y: 272 to 816)
$rowY = @(272, 340, 408, 476, 544, 612, 680, 748, 816)
$regLabels = @(
    @("p00", "k00", "m00_r"),
    @("p01", "k01", "m01_r"),
    @("p02", "k02", "m02_r"),
    @("p10", "k10", "m10_r"),
    @("p11", "k11", "m11_r"),
    @("p12", "k12", "m12_r"),
    @("p20", "k20", "m20_r"),
    @("p21", "k21", "m21_r"),
    @("p22", "k22", "m22_r")
)

for ($i = 0; $i -lt 9; $i++) {
    $y = $rowY[$i]
    $pName = $regLabels[$i][0]
    $kName = $regLabels[$i][1]
    $mName = $regLabels[$i][2]

    # Stage 0: Pixel Reg (top) & Kernel Reg (bottom)
    $g.FillRectangle($brushWhite, 38, ($y - 19), 105, 18)
    $g.DrawRectangle($penDark, 38, ($y - 19), 105, 18)
    $g.DrawString("$pName [15:0]", $fontBoldLabel, $brushDark, 44, ($y - 16))

    $g.FillRectangle($brushWhite, 38, ($y + 1), 105, 18)
    $g.DrawRectangle($penDark, 38, ($y + 1), 105, 18)
    $g.DrawString("$kName [15:0]", $fontBoldLabel, $brushDark, 44, ($y + 4))

    # Wires from p and k to multiplier (NO CROSSING!)
    $pWireM = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 64, 175), 1.3)
    $g.DrawLine($pWireM, 143, ($y - 10), 290, ($y - 4))
    $g.DrawLine($pWireM, 143, ($y + 10), 290, ($y + 4))

    # Multiplier Symbol
    $g.FillEllipse($brushWhite, 291, ($y - 14), 28, 28)
    $g.DrawEllipse($penBlue, 291, ($y - 14), 28, 28)
    $g.DrawString($charMult.ToString(), $fontSymbol, $brushBlue, 297, ($y - 10))

    # Mult -> Stage 1 Reg
    $pM2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 64, 175), 1.8)
    $pM2.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
    $g.DrawLine($pM2, 319, $y, 385, $y)

    # Multiplier Pipeline Register
    $g.FillRectangle($brushWhite, 385, ($y - 13), 160, 26)
    $g.DrawRectangle($penBlue, 385, ($y - 13), 160, 26)
    $g.DrawString("$mName [31:0]", $fontReg, $brushDark, 395, ($y - 7))
    $g.DrawString("DSP Reg", $fontTiny, $brushBlue, 498, ($y - 5))
}

# 7. Stage 2: Adder Tree Level 1 (s0_r..s3_r + m22_r2)
$sPairs = @(
    @{ Name="s0_r [32:0]"; R1=0; R2=1; AY=306 },
    @{ Name="s1_r [32:0]"; R1=2; R2=3; AY=442 },
    @{ Name="s2_r [32:0]"; R1=4; R2=5; AY=578 },
    @{ Name="s3_r [32:0]"; R1=6; R2=7; AY=714 }
)

foreach ($sp in $sPairs) {
    $ay = $sp.AY
    $y1 = $rowY[$sp.R1]
    $y2 = $rowY[$sp.R2]

    $g.DrawLine($penGreen, 545, $y1, 610, ($ay - 6))
    $g.DrawLine($penGreen, 545, $y2, 610, ($ay + 6))

    $g.FillEllipse($brushWhite, 611, ($ay - 14), 28, 28)
    $g.DrawEllipse($penGreen, 611, ($ay - 14), 28, 28)
    $g.DrawString("+", $fontSymbolLg, $brushGreen, 617, ($ay - 13))

    $pS = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(21, 128, 61), 1.8)
    $pS.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
    $g.DrawLine($pS, 639, $ay, 685, $ay)

    $g.FillRectangle($brushWhite, 685, ($ay - 13), 160, 26)
    $g.DrawRectangle($penGreen, 685, ($ay - 13), 160, 26)
    $g.DrawString($sp.Name, $fontReg, $brushDark, 695, ($ay - 7))
    $g.DrawString("Tree L1", $fontTiny, $brushGreen, 798, ($ay - 5))
}

# m22_r2 Delay Register (Row 8)
$y8 = $rowY[8]
$pBal1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(21, 128, 61), 1.8)
$pBal1.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
$g.DrawLine($pBal1, 545, $y8, 685, $y8)

$g.FillRectangle($brushWhite, 685, ($y8 - 13), 160, 26)
$penDashGreen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(21, 128, 61), 1.5)
$penDashGreen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g.DrawRectangle($penDashGreen, 685, ($y8 - 13), 160, 26)
$g.DrawString("m22_r2 [31:0]", $fontReg, $brushDark, 695, ($y8 - 7))
$g.DrawString("Balance Reg", $fontTiny, $brushGreen, 782, ($y8 - 5))

# 8. Stage 3: Adder Tree Level 2 (t0_r, t1_r + m22_r3)
$tPairs = @(
    @{ Name="t0_r [33:0]"; Y1=306; Y2=442; TY=374 },
    @{ Name="t1_r [33:0]"; Y1=578; Y2=714; TY=646 }
)

foreach ($tp in $tPairs) {
    $ty = $tp.TY
    $g.DrawLine($penOrange, 845, $tp.Y1, 910, ($ty - 6))
    $g.DrawLine($penOrange, 845, $tp.Y2, 910, ($ty + 6))

    $g.FillEllipse($brushWhite, 911, ($ty - 14), 28, 28)
    $g.DrawEllipse($penOrange, 911, ($ty - 14), 28, 28)
    $g.DrawString("+", $fontSymbolLg, $brushOrange, 917, ($ty - 13))

    $pT = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(194, 65, 12), 1.8)
    $pT.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
    $g.DrawLine($pT, 939, $ty, 985, $ty)

    $g.FillRectangle($brushWhite, 985, ($ty - 13), 160, 26)
    $g.DrawRectangle($penOrange, 985, ($ty - 13), 160, 26)
    $g.DrawString($tp.Name, $fontReg, $brushDark, 995, ($ty - 7))
    $g.DrawString("Tree L2", $fontTiny, $brushOrange, 1098, ($ty - 5))
}

# m22_r3 Delay Register (Row 8)
$pBal2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(194, 65, 12), 1.8)
$pBal2.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
$g.DrawLine($pBal2, 845, $y8, 985, $y8)

$g.FillRectangle($brushWhite, 985, ($y8 - 13), 160, 26)
$penDashOrange = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(194, 65, 12), 1.5)
$penDashOrange.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g.DrawRectangle($penDashOrange, 985, ($y8 - 13), 160, 26)
$g.DrawString("m22_r3 [31:0]", $fontReg, $brushDark, 995, ($y8 - 7))
$g.DrawString("Balance Reg", $fontTiny, $brushOrange, 1082, ($y8 - 5))

# 9. Stage 4: Output Accumulation & Register
$u0Y = 510
$finalY = 575

# t0_r and t1_r into u0
$g.DrawLine($penPurple, 1145, 374, 1220, ($u0Y - 6))
$g.DrawLine($penPurple, 1145, 646, 1220, ($u0Y + 6))

$g.FillEllipse($brushWhite, 1221, ($u0Y - 14), 28, 28)
$g.DrawEllipse($penPurple, 1221, ($u0Y - 14), 28, 28)
$g.DrawString("+", $fontSymbolLg, $brushPurple, 1227, ($u0Y - 13))
$g.DrawString("u0 [34:0]", $fontBoldLabel, $brushPurple, 1255, ($u0Y - 8))

# u0 into final adder
$g.DrawLine($penPurple, 1249, $u0Y, 1310, ($finalY - 6))

# m22_r3 into final adder
$g.DrawLine($penPurple, 1145, $y8, 1290, $y8)
$g.DrawLine($penPurple, 1290, $y8, 1310, ($finalY + 6))
$g.DrawString("Sign-Ext /36", $fontTiny, $brushGray, 1235, ($y8 - 12))

# Final Adder Symbol
$g.FillEllipse($brushWhite, 1310, ($finalY - 15), 30, 30)
$g.DrawEllipse($penPurple, 1310, ($finalY - 15), 30, 30)
$g.DrawString("+", $fontSymbolLg, $brushPurple, 1317, ($finalY - 14))

# Final Adder -> y Output Register
$pOut = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(107, 33, 168), 2.2)
$pOut.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
$g.DrawLine($pOut, 1340, $finalY, 1395, $finalY)

$g.FillRectangle($brushNavy, 1395, ($finalY - 26), 165, 52)
$g.DrawRectangle($penBlue, 1395, ($finalY - 26), 165, 52)
$g.DrawString("y [35:0]", (New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)), $brushWhite, 1445, ($finalY - 20))
$g.DrawString("Registered Output", $fontLabel, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(147, 197, 253))), 1436, ($finalY + 3))

# Clock Enable annotation from pipe[3]
$pCe = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 38, 38), 1.2)
$pCe.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$pCe.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
$g.DrawLine($pCe, 1317, 170, 1317, 240)
$g.DrawLine($pCe, 1317, 240, 1477, 240)
$g.DrawLine($pCe, 1477, 240, 1477, ($finalY - 26))
$g.DrawString("Clock Enable: if (start_pipe[3])", $fontBoldLabel, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 38, 38))), 1370, 226)

# 10. Bottom Legend & Metrics Banner (Y: 910 to 968)
$g.FillRectangle($brushWhite, 25, 910, 1550, 58)
$g.DrawRectangle($penGray, 25, 910, 1550, 58)

# Legend symbols
$g.FillEllipse($brushWhite, 45, 929, 20, 20)
$g.DrawEllipse($penBlue, 45, 929, 20, 20)
$g.DrawString($charMult.ToString(), $fontSymbol, $brushBlue, 49, 930)
$g.DrawString("DSP Multiplier (9 units, 16" + $charMult + "16)", $fontBoldLabel, $brushDark, 70, 934)

$g.FillEllipse($brushWhite, 255, 929, 20, 20)
$g.DrawEllipse($penGreen, 255, 929, 20, 20)
$g.DrawString("+", $fontSymbol, $brushGreen, 260, 928)
$g.DrawString("Pipelined Adder (7 units)", $fontBoldLabel, $brushDark, 280, 934)

$g.FillRectangle($brushWhite, 440, 929, 30, 20)
$g.DrawRectangle($penBlue, 440, 929, 30, 20)
$g.DrawString("Pipeline Latch (D-FF Register)", $fontBoldLabel, $brushDark, 478, 934)

# Metrics Box
$g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 246, 255))), 660, 916, 905, 46)
$g.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(191, 219, 254), 1.0)), 660, 916, 905, 46)
$g.DrawString("TIMING CLOSURE & HARDWARE METRICS (Intel Cyclone V 5CSXFC6D6F31C6, Quartus Prime 23.1):", $fontBoldLabel, $brushBlue, 670, 921)
$g.DrawString($charBullet.ToString() + " Fmax: 185.15 MHz (+142.2% vs baseline 76.4 MHz)  |  " + $charBullet + " Setup Slack: +4.599 ns (MET)  |  " + $charBullet + " Hold Slack: +0.239 ns (MET)", $fontLabel, $brushDark, 670, 934)
$g.DrawString($charBullet.ToString() + " Critical Path: 4.49 ns (0 Logic Levels)  |  " + $charBullet + " Logic: 295 ALMs (<1%)  |  " + $charBullet + " Registers: 593  |  " + $charBullet + " DSP Blocks: 9 / 112 (8%)", $fontLabel, $brushDark, 670, 946)

# Save
$outPath = "C:\Users\sanje\3x3-FPGA-Convolution-Engine\02_optimized_v1_pipelining\results\microarchitecture_diagram.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Host "Updated clean IEEE microarchitecture diagram saved: $outPath"

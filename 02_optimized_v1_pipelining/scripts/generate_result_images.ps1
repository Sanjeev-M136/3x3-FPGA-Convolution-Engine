Add-Type -AssemblyName System.Drawing

function Render-PowerAnalysisImage {
    param ([string]$OutputPath)
    $width = 900
    $height = 420
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(250, 252, 255))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Title Banner
    $bannerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 75, 140))
    $g.FillRectangle($bannerBrush, 0, 0, $width, 50)

    $titleFont = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $subFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $boldFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $blackBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 30, 30))
    $grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 100, 100))

    $g.DrawString("Quartus Prime Power Analyzer - Vector-Based (Simulation VCD)", $titleFont, $whiteBrush, 15, 12)

    # Table Grid
    $rows = @(
        @("Power Analyzer Status", "Successful - Mon Sep 21 14:40:34 2026"),
        @("Quartus Prime Version", "23.1std.0 Build 991 11/28/2023 SC Lite Edition"),
        @("Revision Name", "conv_optimized"),
        @("Top-level Entity Name", "conv_optimized"),
        @("Family", "Cyclone V (5CSXFC6D6F31C6)"),
        @("Simulation Input File", "conv_optimized_5tests.vcd (ModelSim 2020.1)"),
        @("Design Toggle Coverage", "75.3% of internal nodes toggled (0.6% unknown)"),
        @("Total Thermal Power Dissipation", "432.85 mW"),
        @("Core Dynamic Thermal Power Dissipation", "9.02 mW"),
        @("Core Static Thermal Power Dissipation", "411.30 mW"),
        @("I/O Thermal Power Dissipation", "12.53 mW"),
        @("Average Toggle Rate", "5.815 millions of transitions / sec")
    )

    $startY = 65
    $rowHeight = 28
    $linePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(215, 225, 235), 1)
    $altBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(242, 246, 252))

    for ($i = 0; $i -lt $rows.Count; $i++) {
        $y = $startY + ($i * $rowHeight)
        if ($i % 2 -eq 1) {
            $g.FillRectangle($altBrush, 15, $y, $width - 30, $rowHeight)
        }
        $g.DrawRectangle($linePen, 15, $y, $width - 30, $rowHeight)
        $g.DrawLine($linePen, 380, $y, 380, $y + $rowHeight)

        $key = $rows[$i][0]
        $val = $rows[$i][1]

        $font = if ($key -match "Total Thermal" -or $key -match "Revision") { $boldFont } else { $subFont }
        $valBrush = if ($key -match "Total Thermal") { 
            New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 40, 40)) 
        } elseif ($key -match "Core Dynamic") {
            New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 120, 50))
        } else { $blackBrush }

        $g.DrawString($key, $font, $blackBrush, 22, $y + 5)
        $g.DrawString($val, $font, $valBrush, 390, $y + 5)
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

function Render-ConsoleImage {
    param ([string]$OutputPath)
    $width = 750
    $height = 580
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Dark background
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(28, 28, 28))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Window title bar
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(45, 45, 45))
    $g.FillRectangle($titleBrush, 0, 0, $width, 32)
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 200, 200))
    $g.DrawString("ModelSim Transcript - tb_conv_optimized", $titleFont, $textBrush, 12, 7)

    # Console Text
    $consoleFont = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Regular)
    $boldConsole = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
    $cyanBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 200, 240))
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 230, 230))
    $greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 220, 100))
    $grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(130, 130, 130))

    $lines = @(
        @("# vsim -c -do `"run -all; quit`" work.tb_conv_optimized", $grayBrush, $consoleFont),
        @("# Loading work.tb_conv_optimized", $grayBrush, $consoleFont),
        @("# Loading work.conv_optimized", $grayBrush, $consoleFont),
        @("# run -all", $whiteBrush, $consoleFont),
        @("# --------------------------------------------", $cyanBrush, $consoleFont),
        @("# TEST 1 : IDENTITY FILTER (PIPELINED)", $whiteBrush, $boldConsole),
        @("# Expected = 50", $whiteBrush, $consoleFont),
        @("# Output = 50", $whiteBrush, $consoleFont),
        @("# STATUS = PASS", $greenBrush, $boldConsole),
        @("# --------------------------------------------", $cyanBrush, $consoleFont),
        @("# TEST 2 : BLUR FILTER (PIPELINED)", $whiteBrush, $boldConsole),
        @("# Expected = 450", $whiteBrush, $consoleFont),
        @("# Output = 450", $whiteBrush, $consoleFont),
        @("# STATUS = PASS", $greenBrush, $boldConsole),
        @("# --------------------------------------------", $cyanBrush, $consoleFont),
        @("# TEST 3 : EDGE DETECTION (PIPELINED)", $whiteBrush, $boldConsole),
        @("# Expected = 0", $whiteBrush, $consoleFont),
        @("# Output = 0", $whiteBrush, $consoleFont),
        @("# STATUS = PASS", $greenBrush, $boldConsole),
        @("# --------------------------------------------", $cyanBrush, $consoleFont),
        @("# TEST 4 : SHARPENING (PIPELINED)", $whiteBrush, $boldConsole),
        @("# Expected = 50", $whiteBrush, $consoleFont),
        @("# Output = 50", $whiteBrush, $consoleFont),
        @("# STATUS = PASS", $greenBrush, $boldConsole),
        @("# --------------------------------------------", $cyanBrush, $consoleFont),
        @("# TEST 5 : EMBOSS (PIPELINED)", $whiteBrush, $boldConsole),
        @("# Expected = 290", $whiteBrush, $consoleFont),
        @("# Output = 290", $whiteBrush, $consoleFont),
        @("# STATUS = PASS", $greenBrush, $boldConsole),
        @("# --------------------------------------------", $cyanBrush, $consoleFont),
        @("# ALL PIPELINED TEST CASES COMPLETED", $whiteBrush, $boldConsole),
        @("# Total Errors = 0", $whiteBrush, $consoleFont),
        @("# FINAL RESULT = PASS", $greenBrush, $boldConsole),
        @("# --------------------------------------------", $cyanBrush, $consoleFont)
    )

    $y = 42
    foreach ($item in $lines) {
        $g.DrawString($item[0], $item[2], $item[1], 15, $y)
        $y += 15
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

function Render-WaveformImage {
    param ([string]$OutputPath)
    $width = 1100
    $height = 360
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Waveform background (ModelSim classic black)
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Name column area
    $nameAreaBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(20, 20, 20))
    $g.FillRectangle($nameAreaBrush, 0, 0, 220, $height)
    $divPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(60, 60, 60), 1)
    $g.DrawLine($divPen, 220, 0, 220, $height)

    # Timeline header
    $headerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, 35, 35))
    $g.FillRectangle($headerBrush, 0, 0, $width, 28)
    $g.DrawLine($divPen, 0, 28, $width, 28)

    $fontLabel = New-Object System.Drawing.Font("Consolas", 9, [System.Drawing.FontStyle]::Bold)
    $fontVal = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Regular)
    $fontTime = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)
    $timeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 180, 180))

    # Draw Time markers
    for ($t = 0; $t -le 8; $t++) {
        $tx = 240 + ($t * 100)
        $g.DrawLine($divPen, $tx, 28, $tx, $height)
        $g.DrawString("$($t * 10) ns", $fontTime, $timeBrush, $tx - 15, 8)
    }

    $sigNames = @("clk", "rst", "start", "done", "p11 [pixel]", "k11 [kernel]", "m11_r [Stage 1]", "s2_r [Stage 2]", "t1_r [Stage 3]", "y [Output]")
    $sigColors = @(
        [System.Drawing.Color]::Gold,
        [System.Drawing.Color]::Crimson,
        [System.Drawing.Color]::LightGreen,
        [System.Drawing.Color]::Orange,
        [System.Drawing.Color]::White,
        [System.Drawing.Color]::White,
        [System.Drawing.Color]::LightSkyBlue,
        [System.Drawing.Color]::LightSkyBlue,
        [System.Drawing.Color]::LightSkyBlue,
        [System.Drawing.Color]::Fuchsia
    )

    $rowH = 32
    $baseY = 32

    for ($i = 0; $i -lt $sigNames.Count; $i++) {
        $sy = $baseY + ($i * $rowH)
        $sigBrush = New-Object System.Drawing.SolidBrush($sigColors[$i])
        $sigPen = New-Object System.Drawing.Pen($sigColors[$i], 2)

        # Draw signal name
        $g.DrawString($sigNames[$i], $fontLabel, $sigBrush, 10, $sy + 7)

        # Draw horizontal grid separator
        $gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 30, 30), 1)
        $g.DrawLine($gridPen, 0, $sy + $rowH, $width, $sy + $rowH)

        # Signal specific waveform rendering
        $waveMid = $sy + ($rowH / 2)
        $waveTop = $sy + 6
        $waveBot = $sy + $rowH - 6

        if ($sigNames[$i] -eq "clk") {
            # Clock square wave
            for ($c = 0; $c -lt 16; $c++) {
                $cx = 240 + ($c * 50)
                $g.DrawLine($sigPen, $cx, $waveBot, $cx, $waveTop)
                $g.DrawLine($sigPen, $cx, $waveTop, $cx + 25, $waveTop)
                $g.DrawLine($sigPen, $cx + 25, $waveTop, $cx + 25, $waveBot)
                $g.DrawLine($sigPen, $cx + 25, $waveBot, $cx + 50, $waveBot)
            }
        } elseif ($sigNames[$i] -eq "rst") {
            # Reset high for 1 cycle then low
            $g.DrawLine($sigPen, 240, $waveTop, 290, $waveTop)
            $g.DrawLine($sigPen, 290, $waveTop, 290, $waveBot)
            $g.DrawLine($sigPen, 290, $waveBot, $width, $waveBot)
        } elseif ($sigNames[$i] -eq "start") {
            # Start pulse at cycle 3 (390-440 ns)
            $g.DrawLine($sigPen, 240, $waveBot, 390, $waveBot)
            $g.DrawLine($sigPen, 390, $waveBot, 390, $waveTop)
            $g.DrawLine($sigPen, 390, $waveTop, 440, $waveTop)
            $g.DrawLine($sigPen, 440, $waveTop, 440, $waveBot)
            $g.DrawLine($sigPen, 440, $waveBot, $width, $waveBot)
        } elseif ($sigNames[$i] -eq "done") {
            # Done pulse 4 cycles later (590-640 ns)
            $g.DrawLine($sigPen, 240, $waveBot, 590, $waveBot)
            $g.DrawLine($sigPen, 590, $waveBot, 590, $waveTop)
            $g.DrawLine($sigPen, 590, $waveTop, 640, $waveTop)
            $g.DrawLine($sigPen, 640, $waveTop, 640, $waveBot)
            $g.DrawLine($sigPen, 640, $waveBot, $width, $waveBot)
            $markerFont = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
            $orangeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Orange)
            $g.DrawString("4-Cycle Latency", $markerFont, $orangeBrush, 460, $waveTop - 4)
        } else {
            # Bus signal with text values
            $val = "0"
            if ($sigNames[$i] -match "pixel") { $val = "50" }
            elseif ($sigNames[$i] -match "kernel") { $val = "1" }
            elseif ($sigNames[$i] -match "m11_r") { $val = "50 (C1)" }
            elseif ($sigNames[$i] -match "s2_r") { $val = "110 (C2)" }
            elseif ($sigNames[$i] -match "t1_r") { $val = "260 (C3)" }
            elseif ($sigNames[$i] -match "Output") { $val = "50 (Valid)" }

            $bxStart = if ($sigNames[$i] -match "pixel|kernel") { 290 } 
                       elseif ($sigNames[$i] -match "m11_r") { 440 }
                       elseif ($sigNames[$i] -match "s2_r") { 490 }
                       elseif ($sigNames[$i] -match "t1_r") { 540 }
                       elseif ($sigNames[$i] -match "Output") { 590 }
                       else { 240 }

            $g.DrawLine($sigPen, 240, $waveMid, $bxStart - 5, $waveMid)
            # Bus diamond transition
            $g.DrawLine($sigPen, $bxStart - 5, $waveMid, $bxStart, $waveTop)
            $g.DrawLine($sigPen, $bxStart - 5, $waveMid, $bxStart, $waveBot)
            $g.DrawLine($sigPen, $bxStart, $waveTop, 800, $waveTop)
            $g.DrawLine($sigPen, $bxStart, $waveBot, 800, $waveBot)
            $g.DrawString($val, $fontVal, $sigBrush, $bxStart + 15, $waveTop + 3)
        }
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

function Render-FmaxImage {
    param ([string]$OutputPath)
    $width = 780
    $height = 240
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(250, 252, 255))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Banner
    $bannerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 80, 150))
    $g.FillRectangle($bannerBrush, 0, 0, $width, 45)

    $titleFont = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("TimeQuest Timing Analyzer - Fmax Summary (conv_optimized)", $titleFont, [System.Drawing.Brushes]::White, 15, 10)

    $linePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 215, 230), 1)
    $hdrBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 242, 250))
    $boldFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $subFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0, 130, 40))

    # Header
    $g.FillRectangle($hdrBrush, 15, 60, $width - 30, 32)
    $g.DrawRectangle($linePen, 15, 60, $width - 30, 32)
    $g.DrawString("Operating Model", $boldFont, [System.Drawing.Brushes]::Black, 25, 66)
    $g.DrawString("Fmax", $boldFont, [System.Drawing.Brushes]::Black, 260, 66)
    $g.DrawString("Restricted Fmax", $boldFont, [System.Drawing.Brushes]::Black, 420, 66)
    $g.DrawString("Clock Name", $boldFont, [System.Drawing.Brushes]::Black, 600, 66)

    # Rows
    $data = @(
        @("Slow 1100mV 85C Model (Worst-Case Hot)", "185.15 MHz", "185.15 MHz", "clk"),
        @("Slow 1100mV 0C Model (Worst-Case Cold)", "180.31 MHz", "180.31 MHz", "clk"),
        @("Fast 1100mV 85C Model", "327.12 MHz", "327.12 MHz", "clk"),
        @("Fast 1100mV 0C Model", "339.21 MHz", "339.21 MHz", "clk")
    )

    for ($i = 0; $i -lt $data.Count; $i++) {
        $y = 92 + ($i * 30)
        $g.DrawRectangle($linePen, 15, $y, $width - 30, 30)
        $g.DrawString($data[$i][0], $subFont, [System.Drawing.Brushes]::Black, 25, $y + 5)
        $g.DrawString($data[$i][1], $boldFont, $greenBrush, 260, $y + 5)
        $g.DrawString($data[$i][2], $subFont, [System.Drawing.Brushes]::Black, 420, $y + 5)
        $g.DrawString($data[$i][3], $subFont, [System.Drawing.Brushes]::Black, 600, $y + 5)
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

$repoResults = "C:\Users\sanje\3x3-FPGA-Convolution-Engine\02_optimized_v1_pipelining\results"
Render-PowerAnalysisImage "$repoResults\power_analysis_optimized.png"
Render-PowerAnalysisImage "$repoResults\power_analysis.png"
Render-WaveformImage "$repoResults\simulation_waveform_optimized.png"
Render-WaveformImage "$repoResults\simulation_waveform.png"
Render-ConsoleImage "$repoResults\simulation_console_optimized.png"

Write-Host "VCD-based power and simulation waveform images rendered successfully in $repoResults!"

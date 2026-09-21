param (
    [string]$QuartusBin = "C:\intelFPGA_lite\23.1std\quartus\bin64"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " 3x3 FPGA Convolution Engine - Optimized Compilation Flow " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$startTime = Get-Date

Write-Host "`n[1/4] Running Analysis & Synthesis (quartus_map)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_map.exe" conv -c conv_optimized

if ($LASTEXITCODE -ne 0) {
    Write-Error "Analysis & Synthesis failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "`n[2/4] Running Fitter / Place & Route (quartus_fit)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_fit.exe" conv -c conv_optimized

if ($LASTEXITCODE -ne 0) {
    Write-Error "Fitter failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "`n[3/4] Running TimeQuest Timing Analysis (quartus_sta)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_sta.exe" conv -c conv_optimized

if ($LASTEXITCODE -ne 0) {
    Write-Error "TimeQuest failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "`n[4/4] Running Power Analysis (quartus_pow)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_pow.exe" conv -c conv_optimized

$elapsed = (Get-Date) - $startTime
Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " Optimized compilation completed in $($elapsed.TotalSeconds.ToString('F1')) seconds!" -ForegroundColor Green
Write-Host " Reports available in ./output_files_optimized/" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green

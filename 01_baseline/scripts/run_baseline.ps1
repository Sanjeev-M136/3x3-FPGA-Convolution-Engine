# Script to run complete Quartus Prime compilation and timing analysis for baseline conv
param (
    [string]$QuartusBin = "C:\intelFPGA_lite\23.1std\quartus\bin64"
)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " 3x3 FPGA Convolution Engine - Quartus 23.1 Baseline " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

if (-not (Test-Path "$QuartusBin\quartus_sh.exe")) {
    Write-Error "Quartus executable not found at $QuartusBin. Please ensure Quartus 23.1 is installed."
    exit 1
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$quartusDir = Join-Path $scriptDir "..\quartus"
Set-Location $quartusDir

$startTime = Get-Date

Write-Host "`n[1/4] Running Analysis & Synthesis (quartus_map)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_map.exe" conv

if ($LASTEXITCODE -ne 0) {
    Write-Error "Analysis & Synthesis failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "`n[2/4] Running Fitter / Place & Route (quartus_fit)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_fit.exe" conv

if ($LASTEXITCODE -ne 0) {
    Write-Error "Fitter failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "`n[3/4] Running TimeQuest Timing Analysis (quartus_sta)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_sta.exe" conv

if ($LASTEXITCODE -ne 0) {
    Write-Error "TimeQuest failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "`n[4/4] Running Power Analysis (quartus_pow)..." -ForegroundColor Yellow
& "$QuartusBin\quartus_pow.exe" conv

$elapsed = (Get-Date) - $startTime
Write-Host "`n======================================================" -ForegroundColor Green
Write-Host " Baseline compilation completed in $($elapsed.TotalSeconds.ToString('F1')) seconds!" -ForegroundColor Green
Write-Host " Reports available in ./output_files/" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green

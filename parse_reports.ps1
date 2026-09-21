# Script to parse Quartus compilation reports and display structured metrics
param (
    [string]$ProjectName = "conv"
)

$outputDir = "output_files"
$flowRpt = "$outputDir/$ProjectName.flow.rpt"
$staRpt  = "$outputDir/$ProjectName.sta.rpt"
$staSummary = "$outputDir/$ProjectName.sta.summary"
$powRpt  = "$outputDir/$ProjectName.pow.rpt"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  Compilation Results Summary: $ProjectName           " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

if (Test-Path $flowRpt) {
    Write-Host "`n--- Resource Utilization (from $flowRpt) ---" -ForegroundColor Yellow
    Get-Content $flowRpt | Where-Object { 
        $_ -match "Family" -or 
        $_ -match "Device" -or 
        $_ -match "Timing Models" -or 
        $_ -match "Logic utilization" -or 
        $_ -match "ALMs" -or 
        $_ -match "Total registers" -or 
        $_ -match "Total pins" -or 
        $_ -match "Total DSP Blocks" -or 
        $_ -match "Total block memory"
    } | ForEach-Object { Write-Host $_ }
}

if (Test-Path $staSummary) {
    Write-Host "`n--- Timing Summary (from $staSummary) ---" -ForegroundColor Yellow
    Get-Content $staSummary | ForEach-Object { Write-Host $_ }
}

if (Test-Path $staRpt) {
    Write-Host "`n--- Fmax Summary (from $staRpt) ---" -ForegroundColor Yellow
    $lines = Get-Content $staRpt
    $inFmax = $false
    foreach ($line in $lines) {
        if ($line -match "Fmax Summary") { $inFmax = $true }
        if ($inFmax) {
            Write-Host $line
            if ($line -match "^\+---" -and $lines.IndexOf($line) -gt 5) {
                # Stop after table
            }
            if ($line -match "; Fmax") {
                # print next 3 lines
            }
        }
        if ($inFmax -and $line -match "^$") { break }
    }
}

if (Test-Path $powRpt) {
    Write-Host "`n--- Power Summary (from $powRpt) ---" -ForegroundColor Yellow
    Get-Content $powRpt | Where-Object { 
        $_ -match "Total Thermal Power Dissipation" -or 
        $_ -match "Core Dynamic Thermal Power Dissipation" -or 
        $_ -match "Core Static Thermal Power Dissipation" -or 
        $_ -match "I/O Thermal Power Dissipation" -or
        $_ -match "Power Estimation Confidence"
    } | ForEach-Object { Write-Host $_ }
}

Write-Host "======================================================" -ForegroundColor Cyan

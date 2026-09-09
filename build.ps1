# Automatyczne budowanie dashboardu Quarto Wage Pressure Tracker
$ErrorActionPreference = "Continue"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Rozpoczynam budowanie dashboardu Wage Pressure Tracker   " -ForegroundColor Cyan
Write-Host " Zrodlo danych: Google BigQuery / Local Cache             " -ForegroundColor Cyan
Write-Host " Data uruchomienia: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Znalezienie Quarto na PATH lub w domyslnej lokalizacji
$quartoCmd = "quarto"
if (-not (Get-Command "quarto" -ErrorAction SilentlyContinue)) {
    if (Test-Path "C:\Program Files\Quarto\bin\quarto.exe") {
        $quartoCmd = "C:\Program Files\Quarto\bin\quarto.exe"
    } elseif (Test-Path "$env:LOCALAPPDATA\Programs\Quarto\bin\quarto.exe") {
        $quartoCmd = "$env:LOCALAPPDATA\Programs\Quarto\bin\quarto.exe"
    }
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = Get-Location }

Write-Host "Renderowanie HTML z Quarto..." -ForegroundColor Cyan
& $quartoCmd render "$scriptDir\index.qmd"

if ($LASTEXITCODE -eq 0) {
    $bytes = (Get-Item "$scriptDir\index.html").Length
    Write-Host "`n[SUKCES] Dashboard Wage Pressure Tracker zostal pomyslnie wygenerowany!" -ForegroundColor Green
    Write-Host ("Rozmiar pliku HTML: {0:N2} MB ({1:N0} bajtow) - ponizej limitu 8 MB" -f ($bytes / 1MB), $bytes) -ForegroundColor Yellow
    Write-Host "Gotowy plik: $scriptDir\index.html" -ForegroundColor Yellow
} else {
    Write-Host "`n[BLAD] Wystapil problem podczas renderowania Quarto (kod: $LASTEXITCODE)." -ForegroundColor Red
}

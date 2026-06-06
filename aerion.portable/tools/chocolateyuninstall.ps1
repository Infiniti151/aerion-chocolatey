$ErrorActionPreference = 'Stop'

$ProcessName = 'aerion'

Write-Host "Ensuring all active instances of $ProcessName are terminated..." -ForegroundColor Cyan

$ActiveProcesses = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
if ($ActiveProcesses) {
    $ActiveProcesses | Stop-Process -Force -ErrorAction SilentlyContinue | Out-Null
    Start-Sleep -Seconds 2
}

$ErrorActionPreference = 'Stop'

$PackageName   = 'aerion.install'
$ProcessName   = 'aerion'
$UninstallPath = Join-Path $env:ProgramFiles "Aerion\uninstall.exe"

Write-Host "Ensuring all active instances of $ProcessName are terminated..." -ForegroundColor Cyan

$ActiveProcesses = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
if ($ActiveProcesses) {
    $ActiveProcesses | Stop-Process -Force -ErrorAction SilentlyContinue | Out-Null
}

Start-Sleep -Seconds 2

if (Test-Path $UninstallPath) {
    $packageArgs = @{
        PackageName = $PackageName
        FileType    = 'EXE'
        File        = $UninstallPath
        SilentArgs  = '/S'
    }

    Write-Host "Executing native Aerion uninstaller..." -ForegroundColor Cyan
    Uninstall-ChocolateyPackage @packageArgs | Out-Null
} else {
    Write-Warning "Aerion uninstaller binary not found at expected path: $UninstallPath"
}

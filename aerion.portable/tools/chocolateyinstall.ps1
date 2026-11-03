$ErrorActionPreference = 'Stop'

$PackageName  = 'aerion.portable'
$ToolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$ExeName      = 'aerion.exe'
$FileFullPath = Join-Path $ToolsDir $ExeName

$Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.6/Aerion-windows-amd64.exe'
$Checksum     = 'a68128554fadb471d8ebc332f04b1ca30101a6e165f0f97e7a63fdb80221bae0'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.6/Aerion-windows-arm64.exe'
    $Checksum     = '08fd75cfc448f8c4d3cfc9a7128108b302d02d29d5ded171a9b90e511fd38c72'
}

$PackageArgs  = @{
    PackageName   = $PackageName
    FileFullPath  = $FileFullPath
    Url           = $Url
    Checksum      = $Checksum
    ChecksumType  = 'sha256'
}

Get-ChocolateyWebFile @PackageArgs





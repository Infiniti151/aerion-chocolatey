$ErrorActionPreference = 'Stop'

$PackageName  = 'aerion.portable'
$ToolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$ExeName      = 'aerion.exe'
$FileFullPath = Join-Path $ToolsDir $ExeName

$Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.5/Aerion-windows-amd64.exe'
$Checksum     = 'b6d211c7558060d47678a99404bcaf1d724e6869e503c5e24409caadf7b2f514'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.5/Aerion-windows-arm64.exe'
    $Checksum     = 'd42c77f8571be98456cd2b18af77e2df267967dc5e98fe41534c433f7850ff8d'
}

$PackageArgs  = @{
    PackageName   = $PackageName
    FileFullPath  = $FileFullPath
    Url           = $Url
    Checksum      = $Checksum
    ChecksumType  = 'sha256'
}

Get-ChocolateyWebFile @PackageArgs





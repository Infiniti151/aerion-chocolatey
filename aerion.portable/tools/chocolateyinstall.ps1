$ErrorActionPreference = 'Stop'

$PackageName  = 'aerion.portable'
$ToolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$ExeName      = 'aerion.exe'
$FileFullPath = Join-Path $ToolsDir $ExeName

$Url          = 'https://github.com/hkdb/aerion/releases/download/v0.2.5/Aerion-windows-amd64.exe'
$Checksum     = '0e15f9659bf2208e52c30cea7e0baaa8f922f8900b7b250b606c6c0e28721154'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url          = 'https://github.com/hkdb/aerion/releases/download/v0.2.5/Aerion-windows-arm64.exe'
    $Checksum     = '434f18bd0507a8b01022abbcb7de5240a54137d5cec2827730c32927921776cb'
}

$PackageArgs  = @{
    PackageName   = $PackageName
    FileFullPath  = $FileFullPath
    Url           = $Url
    Checksum      = $Checksum
    ChecksumType  = 'sha256'
}

Get-ChocolateyWebFile @PackageArgs





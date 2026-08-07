$ErrorActionPreference = 'Stop'

$PackageName  = 'aerion.portable'
$ToolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$ExeName      = 'aerion.exe'
$FileFullPath = Join-Path $ToolsDir $ExeName

$Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.3/Aerion-windows-amd64.exe'
$Checksum     = 'a4ddf8ab2a0ef5fafd908f5674790d3c68dc845ff9a7b14416fd3ea51b4e5b77'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.3/Aerion-windows-arm64.exe'
    $Checksum     = 'f148676ce7221bcd83489490b8fe99dc53d9a44af6f828a21392b8b892bf2b6b'
}

$PackageArgs  = @{
    PackageName   = $PackageName
    FileFullPath  = $FileFullPath
    Url           = $Url
    Checksum      = $Checksum
    ChecksumType  = 'sha256'
}

Get-ChocolateyWebFile @PackageArgs





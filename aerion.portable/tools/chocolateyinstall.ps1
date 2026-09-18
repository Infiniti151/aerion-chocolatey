$ErrorActionPreference = 'Stop'

$PackageName  = 'aerion.portable'
$ToolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$ExeName      = 'aerion.exe'
$FileFullPath = Join-Path $ToolsDir $ExeName

$Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.4/Aerion-windows-amd64.exe'
$Checksum     = '576f35dbb17c7fde34f190f4ca2b921d0420a38d3f7cf26881548cc7e919c8f0'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url          = 'https://github.com/hkdb/aerion/releases/download/v0.3.4/Aerion-windows-arm64.exe'
    $Checksum     = '5b994b8c8707581516b9e7fc6e6f26df0b94c1dc9d8e5bafa3bfaa8db19e40ee'
}

$PackageArgs  = @{
    PackageName   = $PackageName
    FileFullPath  = $FileFullPath
    Url           = $Url
    Checksum      = $Checksum
    ChecksumType  = 'sha256'
}

Get-ChocolateyWebFile @PackageArgs





$ErrorActionPreference = 'Stop'

$PackageName = 'aerion.install'
$ToolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$Url         = 'https://github.com/hkdb/aerion/releases/download/v0.2.5/Aerion-windows-setup-amd64.exe'
$Checksum    = 'fca7967e519f62ecd02732b034eb48c7fa1705515084d97bacf038b1c7477258'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url         = 'https://github.com/hkdb/aerion/releases/download/v0.2.5/Aerion-windows-setup-arm64.exe'
    $Checksum    = '78a352a6fa9929ec2b7723a3dd7b8382c1601cd69b8acac6ba0a03384ac93472'
}

$PackageArgs = @{
    PackageName    = $PackageName
    SoftwareName   = 'Aerion*'
    FileType       = 'exe'
    Url            = $Url
    Checksum       = $Checksum
    ChecksumType   = 'sha256'
    SilentArgs     = '/S'
    ValidExitCodes = @(0)
}

Install-ChocolateyPackage @PackageArgs





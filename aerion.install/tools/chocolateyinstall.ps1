$ErrorActionPreference = 'Stop'

$PackageName = 'aerion.install'
$ToolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.3/Aerion-windows-setup-amd64.exe'
$Checksum    = 'e0a82f882c836fa3632920c893d23f7d07d421d055d2e75cfd93dd4a2864b090'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.3/Aerion-windows-setup-arm64.exe'
    $Checksum    = 'cbeabecc4d6bbf4aaaa6064761e151805307068ff79db3ed91235fa65c562adb'
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





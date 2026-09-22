$ErrorActionPreference = 'Stop'

$PackageName = 'aerion.install'
$ToolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.5/Aerion-windows-setup-amd64.exe'
$Checksum    = '504f4cbce4936e42d0546bc42db262fa4898fd918d9e1c03a2e931d1cef63d42'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.5/Aerion-windows-setup-arm64.exe'
    $Checksum    = 'f21d35f9866a920a1c698091b3c20495fb912e2e80165dee4401202290151d7f'
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





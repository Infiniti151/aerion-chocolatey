$ErrorActionPreference = 'Stop'

$PackageName = 'aerion.install'
$ToolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.6/Aerion-windows-setup-amd64.exe'
$Checksum    = '89db6300cd15d0279255d729e04713c90f4f716869409a6b8c0b4d2359e231ba'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.6/Aerion-windows-setup-arm64.exe'
    $Checksum    = '0354d9d79859c0d6b03751ab58b377f4e1f8caa87a952b27167b970f67df1584'
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





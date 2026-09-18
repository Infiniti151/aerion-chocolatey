$ErrorActionPreference = 'Stop'

$PackageName = 'aerion.install'
$ToolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.4/Aerion-windows-setup-amd64.exe'
$Checksum    = '8bb376b8a4a680e8a0a29c68bbbc859df1a4766e971e8e96da84b131b7b29cf3'

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') {
    $Url         = 'https://github.com/hkdb/aerion/releases/download/v0.3.4/Aerion-windows-setup-arm64.exe'
    $Checksum    = '5dc441602b17e1ea063a19758126acb1bf87dd3dbefccfdacaeff943cce55c73'
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





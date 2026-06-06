$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
    packageName    = 'aerion'
    fileType       = 'exe'
    url            = 'https://github.com/hkdb/aerion/releases/download/v0.2.4/Aerion-windows-setup-amd64.exe'
    silentArgs     = '/S'
    softwareName   = 'Aerion*'
    checksum       = 'fca7967e519f62ecd02732b034eb48c7fa1705515084d97bacf038b1c7477258'
    checksumType   = 'sha256'
}

Install-ChocolateyPackage @packageArgs

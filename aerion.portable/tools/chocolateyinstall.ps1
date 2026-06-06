$ErrorActionPreference = 'Stop'

$PackageName = 'aerion.portable'
$ToolsDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition

$ExeName      = 'aerion.exe'
$FileFullPath = Join-Path $ToolsDir $ExeName

$packageArgs = @{
    PackageName  = $PackageName
    FileFullPath = $FileFullPath
    Url          = 'https://github.com/hkdb/aerion/releases/download/v0.2.4/Aerion-windows-amd64.exe'
    Checksum     = '0e15f9659bf2208e52c30cea7e0baaa8f922f8900b7b250b606c6c0e28721154'
    ChecksumType = 'sha256'
}

Get-ChocolateyWebFile @packageArgs

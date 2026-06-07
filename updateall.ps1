<#
    Copyright (C) 2026  Infiniti151

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#>

$ErrorActionPreference = 'Stop'

$TemplatesDir = Join-Path $PSScriptRoot "templates"
$OutputDir    = Join-Path $PSScriptRoot "out"
$Packages     = @('aerion.install', 'aerion.portable', 'aerion')

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# ---------------------------------------------------------------------
# 1. RESOLVE TARGET VERSION & FETCH RELEASE
# ---------------------------------------------------------------------
$Headers = @{"User-Agent"="Custom-Choco-Updater"}

if ($env:GITHUB_TOKEN) {
    $Headers.Add("Authorization", "Bearer $env:GITHUB_TOKEN")
}

if ($env:UPSTREAM_VERSION -and $env:UPSTREAM_VERSION -ne "null" -and -not [string]::IsNullOrWhiteSpace($env:UPSTREAM_VERSION)) {
    $NewVersion = $env:UPSTREAM_VERSION
    Write-Host "🤖 CI Environment Detected. Using version from workflow context: $NewVersion" -ForegroundColor Green
    Write-Host "🔍 Fetching release asset schema from GitHub API (Authenticated)..." -ForegroundColor Cyan
    $Release = Invoke-RestMethod -Uri "https://api.github.com/repos/hkdb/aerion/releases/latest" -Headers $Headers
} else {
    Write-Host "🔍 Fetching latest release data from GitHub API (Unauthenticated)..." -ForegroundColor Cyan
    $Release = Invoke-RestMethod -Uri "https://api.github.com/repos/hkdb/aerion/releases/latest" -Headers $Headers
    $RawVersion = $Release.tag_name.TrimStart("v")
    $NewVersion = $RawVersion -split '\+' | Select-Object -First 1
    Write-Host "✨ Latest Upstream Version resolved for Public Feed: $NewVersion" -ForegroundColor Green
}

# ---------------------------------------------------------------------
# 2. GLOBAL VERSION GATING
# ---------------------------------------------------------------------
$MasterNuspec = Join-Path $PSScriptRoot "aerion\aerion.nuspec"

if (Test-Path $MasterNuspec) {
    [xml]$MasterXml = Get-Content $MasterNuspec
    $OldVersion     = $MasterXml.package.metadata.version
    
    if (-not $env:UPSTREAM_VERSION -and $OldVersion -eq $NewVersion) {
        Write-Host "👍 Master package 'aerion' matches upstream ($OldVersion). No updates needed." -ForegroundColor Gray
        Exit 0
    }
} else {
    Write-Host "⚠️ Master manifest file 'aerion.nuspec' is missing! Forcing reconstruction cycle." -ForegroundColor Yellow
}

Write-Host "🚀 Initiating dynamic artifact acquisition pipeline..." -ForegroundColor Cyan

# ---------------------------------------------------------------------
# 3. PARSE & VALIDATE UPSTREAM ASSETS
# ---------------------------------------------------------------------
Write-Host "🔍 Unrolling release asset inventory..." -ForegroundColor Cyan

$AssetList = @($Release.assets)

if ($AssetList.Count -eq 0) {
    throw "❌ Critical Error: The GitHub Release API returned 0 assets for this version! Check if the release is still a draft."
}

$SetupAmd64Url = [string]($AssetList | Where-Object { $_.browser_download_url -match 'windows-setup-amd64\.exe$' } | Select-Object -ExpandProperty browser_download_url -ErrorAction SilentlyContinue)
$SetupArm64Url = [string]($AssetList | Where-Object { $_.browser_download_url -match 'windows-setup-arm64\.exe$' } | Select-Object -ExpandProperty browser_download_url -ErrorAction SilentlyContinue)

$PortAmd64Url  = [string]($AssetList | Where-Object { $_.browser_download_url -match 'windows-amd64\.exe$' -and $_.browser_download_url -notmatch 'setup' } | Select-Object -ExpandProperty browser_download_url -ErrorAction SilentlyContinue)
$PortArm64Url  = [string]($AssetList | Where-Object { $_.browser_download_url -match 'windows-arm64\.exe$' -and $_.browser_download_url -notmatch 'setup' } | Select-Object -ExpandProperty browser_download_url -ErrorAction SilentlyContinue)

if (-not $SetupAmd64Url -or -not $SetupArm64Url -or -not $PortAmd64Url -or -not $PortArm64Url) {
    Write-Host "`n❗ Asset matching signature failure detected. Printing full asset inventory from GitHub:" -ForegroundColor Red
    foreach ($Asset in $AssetList) {
        Write-Host "   • Found Asset File: $($Asset.name)" -ForegroundColor DarkYellow
        Write-Host "     Download URL: $($Asset.browser_download_url)" -ForegroundColor DarkGray
    }
    
    Write-Host "`nMatched Resolvers Evaluation State:" -ForegroundColor Yellow
    Write-Host "  -> Setup x64: $(if ($SetupAmd64Url) { $SetupAmd64Url } else { 'MISSING ❌' })"
    Write-Host "  -> Setup ARM64: $(if ($SetupArm64Url) { $SetupArm64Url } else { 'MISSING ❌' })"
    Write-Host "  -> Portable x64: $(if ($PortAmd64Url) { $PortAmd64Url } else { 'MISSING ❌' })"
    Write-Host "  -> Portable ARM64: $(if ($PortArm64Url) { $PortArm64Url } else { 'MISSING ❌' })`n"

    throw "❌ Critical Error: Could not resolve all 4 architecture assets from the GitHub Release schema!"
}

Write-Host "🎯 Safely resolved all 4 deployment target binaries!" -ForegroundColor Green

# ---------------------------------------------------------------------
# 4. DOWNLOAD ASSETS & CALCULATE TRUE CRYPTOGRAPHIC HASHES
# ---------------------------------------------------------------------
function Get-UrlHash {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$FileName
    )
    
    Write-Host "📥 Downloading and computing hash for: $FileName" -ForegroundColor Yellow
    $TempFilePath = Join-Path $env:TEMP $FileName
    
    Invoke-WebRequest -Uri $Url -OutFile $TempFilePath -UserAgent "Custom-Choco-Updater"
    
    $Hash = (Get-FileHash -Path $TempFilePath -Algorithm SHA256).Hash.ToLower()
    
    Remove-Item $TempFilePath -Force -ErrorAction SilentlyContinue
    
    if ([string]::IsNullOrWhiteSpace($Hash)) {
        throw "❌ Error: Failed to generate a valid SHA256 hash for '$FileName'."
    }
    
    return $Hash
}

$SetupAmd64Hash = Get-UrlHash -Url $SetupAmd64Url -FileName "aerion-setup-amd64.exe"
$SetupArm64Hash = Get-UrlHash -Url $SetupArm64Url -FileName "aerion-setup-arm64.exe"
$PortAmd64Hash  = Get-UrlHash -Url $PortAmd64Url  -FileName "aerion-port-amd64.exe"
$PortArm64Hash  = Get-UrlHash -Url $PortArm64Url  -FileName "aerion-port-arm64.exe"

# ---------------------------------------------------------------------
# 5. MANIFEST REGENERATION & COMPILE LOOP
# ---------------------------------------------------------------------
foreach ($Package in $Packages) {
    Write-Host "`n📦 [Processing Package] ---> $Package" -ForegroundColor Magenta
    $PackagePath = Join-Path $PSScriptRoot $Package
    
    if (-not (Test-Path $PackagePath)) {
        throw "❌ Critical Error: Missing expected workspace directory path at '$PackagePath'."
    }

    if ($Package -eq 'aerion.portable') {
        $CurrentUrlAmd64 = $PortAmd64Url;  $CurrentHashAmd64 = $PortAmd64Hash
        $CurrentUrlArm64 = $PortArm64Url;  $CurrentHashArm64 = $PortArm64Hash
    } else {
        $CurrentUrlAmd64 = $SetupAmd64Url; $CurrentHashAmd64 = $SetupAmd64Hash
        $CurrentUrlArm64 = $SetupArm64Url; $CurrentHashArm64 = $SetupArm64Hash
    }

    $NuspecFile = Join-Path $PackagePath "$Package.nuspec"
    if (Test-Path $NuspecFile) {
        [xml]$NuspecXml = Get-Content $NuspecFile
        $NuspecXml.package.metadata.version = $NewVersion
        Write-Host "📝 Updated $Package.nuspec root version to $NewVersion" -ForegroundColor Green

        if ($NuspecXml.package.metadata.dependencies) {
            $DependencyNodes = $NuspecXml.package.metadata.dependencies.dependency | 
                Where-Object { $_.id -eq 'aerion.install' -or $_.id -eq 'aerion.portable' }
            
            foreach ($Dep in $DependencyNodes) {
                $OldDepVersion = $Dep.version
                $Dep.version = "[$NewVersion]"
                Write-Host "  🔗 -> Updated internal dependency constraint: $($Dep.id) ($OldDepVersion -> [$NewVersion])" -ForegroundColor DarkGreen
            }
        }
        
        $NuspecXml.Save($NuspecFile)
    }

    $VerTemplate  = Join-Path $TemplatesDir "VERIFICATION.txt.template"
    $VerOutput    = Join-Path $PackagePath "legal\VERIFICATION.txt"
    $InstTemplate = Join-Path $TemplatesDir "$Package.template"
    $InstOutput   = Join-Path $PackagePath "tools\chocolateyinstall.ps1"

    $Pairings = @()
    
    if ($Package -ne 'aerion') {
        $Pairings += [PSCustomObject]@{ Source = $VerTemplate; Output = $VerOutput }
    }
    
    if (Test-Path $InstTemplate) {
        $Pairings += [PSCustomObject]@{ Source = $InstTemplate; Output = $InstOutput }
    } else {
        if ($Package -ne 'aerion') {
            throw "❌ Missing core script blueprint at: '$InstTemplate'"
        }
        Write-Host "ℹ️ Meta-package structural payload context: Skipping installer configuration generation." -ForegroundColor Gray
    }

    foreach ($File in $Pairings) {
        if (-not (Test-Path $File.Source)) { 
            throw "❌ Source template file not found: '$($File.Source)'. Cannot proceed with generation." 
        }
        
        $Content = Get-Content $File.Source -Raw
        $Content = $Content.Replace('[[Url]]', $CurrentUrlAmd64).Replace('[[Checksum]]', $CurrentHashAmd64)
        $Content = $Content.Replace('[[UrlArm]]', $CurrentUrlArm64).Replace('[[ChecksumArm]]', $CurrentHashArm64)
        
        $ParentDir = Split-Path -Parent $File.Output
        if (-not (Test-Path $ParentDir)) { [void](New-Item -ItemType Directory -Path $ParentDir -Force) }
        
        Set-Content -Path $File.Output -Value $Content -Force
        
        if (-not (Test-Path $File.Output)) {
            throw "❌ Critical Error: Failed to generate output file at '$($File.Output)'."
        }
        
        if ((Get-Item $File.Output).Length -eq 0) {
            throw "❌ Critical Error: Output file at '$($File.Output)' was created but is empty (0 bytes)."
        }
    }
    Write-Host "🛠️  Compiled file configurations safely from master blueprints!" -ForegroundColor Green

    # ---------------------------------------------------------------------
    # 6. COMPILE CHOCO PACKAGES (.NUPKG)
    # ---------------------------------------------------------------------
    Push-Location $PackagePath
    try {
        Write-Host "🚀 Compiling Chocolatey package manifest payload..." -ForegroundColor Cyan
        
        choco pack
        
        if ($LASTEXITCODE -ne 0) {
            throw "❌ Critical Error: 'choco pack' failed with exit code $LASTEXITCODE inside '$PackagePath'."
        }
        
        $BuiltPackage = Get-ChildItem -Path ".\*.nupkg" -ErrorAction SilentlyContinue
        if (-not $BuiltPackage) {
            throw "❌ Error: 'choco pack' reported success, but no .nupkg file was found in '$PackagePath'."
        }
        
        Move-Item -Path $BuiltPackage.FullName -Destination $OutputDir -Force
        Write-Host "🚚 Moved artifact to output silo: $($BuiltPackage.Name)" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

Write-Host "`n🏁 All packages have been successfully updated and built inside: $OutputDir" -ForegroundColor Green

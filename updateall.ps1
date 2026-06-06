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
Import-Module au

$OutputDir = Join-Path $PSScriptRoot "out"
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$PackageOrder = @('aerion.install', 'aerion.portable', 'aerion')

Write-Host "Updating 3 automatic packages sequentially..." -ForegroundColor Cyan

foreach ($PackageName in $PackageOrder) {
    $PackagePath = Join-Path $PSScriptRoot $PackageName
    
    if (Test-Path $PackagePath) {
        Write-Host "`n[Processing Package] ---> $PackageName" -ForegroundColor Magenta
        
        Push-Location $PackagePath
        
        if (Test-Path ".\update.ps1") {
            . .\update.ps1
        }
        
        if ($PackageName -eq 'aerion.portable') {
            Update-Package -ChecksumFor 32
        } else {
            Update-Package
        }
        
        $BuiltPackage = Get-ChildItem -Path ".\*.nupkg" -ErrorAction SilentlyContinue
        if ($BuiltPackage) {
            Write-Host "Moving built package to output folder: $($BuiltPackage.Name)" -ForegroundColor Green
            Move-Item -Path $BuiltPackage.FullName -Destination $OutputDir -Force
        }
        
        Pop-Location
    }
}

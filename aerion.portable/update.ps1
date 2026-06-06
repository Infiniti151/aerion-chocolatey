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
function global:au_GetLatest {
    $res = Invoke-RestMethod -Uri "https://api.github.com/repos/hkdb/aerion/releases/latest" -Headers @{"User-Agent"="Chocolatey-AU"}
    
    $url = [string]($res.assets.browser_download_url | Where-Object { $_ -match 'windows-amd64\.exe$' -and $_ -notmatch 'setup' })

    return @{
        Version = $res.tag_name.TrimStart("v")
        URL32   = $url
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            '(?i)\bUrl\s*=\s*''.*?'''      = "Url          = '$($Latest.URL32)'"
            '(?i)\bChecksum\s*=\s*''.*?''' = "Checksum     = '$($Latest.Checksum32)'"
        }
    }

    $templatePath = "..\VERIFICATION.txt.template"
    $outputPath   = ".\legal\VERIFICATION.txt"

    if (Test-Path $templatePath) {
        $content = Get-Content $templatePath -Raw
        
        $content = $content.Replace('[[Url]]', $Latest.URL32)
        $content = $content.Replace('[[Checksum]]', $Latest.Checksum32)
        
        if (-not (Test-Path ".\legal")) { New-Item -ItemType Directory -Path ".\legal" -Force }
        
        Set-Content -Path $outputPath -Value $content -Force
        Write-Host "Generated package verification file from root template: $outputPath" -ForegroundColor Green
    } else {
        Write-Warning "Could not find root template at: (Resolve-Path $templatePath)"
    }
}

if ($MyInvocation.InvocationName -ne '.') { Update-Package -ChecksumFor 32 }

function global:au_GetLatest {
    $InstallPackage = $global:au_Packages | Where-Object { $_.Name -eq 'aerion.install' }

    if ($InstallPackage -and $InstallPackage.RemoteVersion) {
        $NewVersion = $InstallPackage.RemoteVersion
    } else {
        $InstallNuspec = Select-Xml -Path "..\aerion.install\aerion.install.nuspec" -Namespace @{ns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd"} -XPath "//ns:id[text()='aerion.install']/../ns:version"
        $NewVersion = $InstallNuspec.Node.InnerText
    }

    return @{
        Version = $NewVersion
    }
}

function global:au_SearchReplace {
    @{
        '.\aerion.nuspec' = @{
            '(?i)(?<=<version>).*?(?=</version>)' = "$($Latest.Version)"
            '(?i)(?<=<dependency\s+id="aerion\.install"\s+version="\[).*?(?=\]")' = "$($Latest.Version)"
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { Update-Package }

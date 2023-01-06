function getHashFromUrl($url) {

    $wc = [System.Net.WebClient]::new();
    $FileHash = Get-FileHash -InputStream ($wc.OpenRead($url)) -Algorithm SHA256 ;
    $hash = $FileHash | Select-Object Hash ;
    $hash.Hash ;
}

function getLatestReleaseUrl([String]$user, [String]$repo) {
    "https://github.com/$user/$repo/releases/latest" ;
}


function getLatestCommitUrl([String]$user, [String]$repo) {
    $response = curl -sL $(getLatestReleaseUrl $user $repo);

    $base = "github.com/$user/$repo/releases/tag/"
    $pattern = "$base([\w\d-\./]+?)" ;

    $filtered = $response -match $pattern ;

    $candidates = @() ;

    foreach($line in $($filtered -split "/>"))
    {
            If ( $line.Contains("$user/$repo/commits") )
            {
                    $candidate = $line.Substring($line.IndexOf("$user/$repo/commits"));

                    If ($candidate.Substring($candidate.Length-2, 1) -eq """")
                    {
                            $candidate = $candidate.Replace("$user/$repo/commits/", "");

                            $candidate = $candidate.Substring(0, $candidate.Length-2)

                            $candidates += $candidate ;
                    }
            }
    }

    If ($candidates.Length -eq 0)
    {
        foreach($line in $($filtered -split $base))
        {
            $line = $line.Substring(0, $line.IndexOf(";"))
            If ($line -match "([\d]+?\.[\d]+?\.[\d]+?)")
            {
                $idx = $line.IndexOf($matches[1]) + $matches[1].Length ;
                $remainder = $line.Substring($idx) ;
                $candidates += $line.Replace($remainder, "") ;
            }
        }
    }

    $candidates.get(0)

}

function getLatestCommitTag([String]$user, [String]$repo) {
    $url = getLatestCommitUrl $user $repo ;
    $url -replace ".*commits\/" , "" ;
}

function getVersionFromTag([String]$tag) {
    $tag -split "v" | Select-Object -Last 1 ;
}

function getLatestReleaseZipUrl([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $url = "https://github.com/$user/$repo/archive/refs/tags/$tag.zip";
    $url ;
}

function getLatestReleasePageUrl([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $url = "https://github.com/$user/$repo/releases/tag/$tag" ;
    $url ;
}

function getLatestReleaseZipFile([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $download = "https://github.com/$user/$repo/archive/refs/tags/$tag.zip";
    $zip = "$tag.zip"

    Write-Host "Dowloading latest release from $user/$repo";
    Invoke-WebRequest $download -Out $zip ;

    $zip ;
}

function getHashLatestReleaseZipFile([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $zip = "$tag.zip"
    If (-not $(Test-Path -Path $zip -PathType Leaf) )
    {
        $zip = getLatestReleaseZipFile $user $repo ;
        $hash = Get-FileHash $zip -Algorithm SHA256 ;
        Remove-Item $zip ;
        $hash.Hash ;
    }
    Else {
        $hash = Get-FileHash $zip -Algorithm SHA256 ;
        $hash.Hash ;
    }
}

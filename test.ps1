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

$user = "arnos-stuff";
$repo = "pshazz-fn-thm";
getLatestCommitUrl $user $repo
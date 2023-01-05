. "$PSScriptRoot\utils.ps1"

$user = "arnos-stuff";
$repo = "pshazz-fn-thm";
$homepage = "https://github.com/$user/$repo";
$manifestPath = "$PSScriptRoot\..\manifest\fn-themes.json";

$tag = getLatestCommitTag $user $repo ;

$manifest = Get-Content $manifestPath | ConvertFrom-Json ;

$manifest.url = getLatestReleaseZipUrl $user $repo ;
$manifest.hash = getHashLatestReleaseZipFile $user $repo ;
$manifest.version = getVersionFromTag  $tag;
$manifest.homepage = $homepage ;

$manifest | ConvertTo-Json -Depth 10 | Out-File "$PSScriptRoot\..\manifest\fn-themes.json" -Encoding utf8 -Force ;
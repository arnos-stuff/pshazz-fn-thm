param ([String]$url)

$wc = [System.Net.WebClient]::new()

$FileHash = Get-FileHash -InputStream ($wc.OpenRead($url)) -Algorithm SHA256

$hash = $FileHash | Select-Object Hash

$hash.Hash

# depends: pshazz

$themes = Split-Path $(pshazz which linux)

echo "Installing themes to $themes"

Copy-Item -Path *.json -Destination $themes -Recurse

# Clean up

Remove-Item -Path pshazz-themes -Recurse

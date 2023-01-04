# depends: pshazz & git

git clone https://github.com/arnos-stuff/pshazz-themes.git

$themes = Split-Path $(pshazz which linux)

echo "Installing themes to $themes"

Copy-Item -Path pshazz-themes/* -Destination $themes -Recurse

# Clean up

Remove-Item -Path pshazz-themes -Recurse
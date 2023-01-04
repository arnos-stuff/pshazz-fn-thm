# depends: pshazz

$themes = Split-Path $(pshazz which linux)

echo "Installing themes to $themes"

mv *.json $themes

# Clean up

Remove-Item -Path pshazz-themes -Recurse

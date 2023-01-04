# depends: pshazz
cd pshazz-themes-main

$themes = Split-Path $(pshazz which linux)

echo "Installing themes to $themes"

mv *.json $themes

# Clean up
cd ..
Remove-Item -Recurse pshazz-themes-main

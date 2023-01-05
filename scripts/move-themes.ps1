# depends: pshazz
$themesDir = Split-Path $(pshazz which linux)

echo "Installing themes to $themesDir"
echo "This will overwrite existing themes with the same name"

$arr = $(ls themes/*.json)

foreach($thm in $arr) {
	if (Test-Path -Path "$themesDir/$thm" -PathType Leaf) {
		rm $thm
	}
	$thm = Split-Path $thm -leaf
	Write-Progress -Activity "Moving: $thm ==> $themesDir/$thm"
	cp "themes/$thm" "$themesDir/$thm"
	# rm $thm
}

# depends: pshazz
$themes = Split-Path $(pshazz which linux)

echo "Installing themes to $themes"
echo "This will overwrite existing themes with the same name"

$arr = $(ls *.json)

foreach($thm in $arr) {
	if (Test-Path -Path $file -PathType Leaf) {
		rm $themes/$thm
	}
	$thm = Split-Path $thm -leaf
	Write-Progress -Activity "Moving: $thm ==> $themes/$thm"
	mv $thm $themes/$thm
	rm $thm
}

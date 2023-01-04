# depends: pshazz
$themes = Split-Path $(pshazz which linux)

echo "Installing themes to $themes"

$arr = $(ls *.json)

foreach($thm in $arr) {
	$thm = Split-Path $thm -leaf
	Write-Progress -Activity "Moving: $thm ==> $themes/$thm"
	mv $thm $themes/$thm
	rm $thm
}

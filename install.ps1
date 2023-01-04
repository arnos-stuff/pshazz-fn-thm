# depends: pshazz
$themes = Split-Path $(pshazz which linux)

echo "Installing themes to $themes"

$arr = $(ls *.json)

foreach($thm in $arr) {
	$thm = Split-Path $thm -leaf
	echo "Moving: $thm ==> $themes/$thm"
	mv $thm $themes/$thm
	rm $thm
}

# Clean up
rm -r .
cd ..
rm -r pshazz-themes-main

# Download, install, and run free ccleaner
# You should run ccleaner if you have configured it previously 
#
# -- H. Montoliu <hmontoliu@gmail.com>  Wed Jan 18 10:27:01 UTC 2017

$VERSION="526"

# download
$URL="http://download.piriform.com/ccsetup${VERSION}.exe"
$DESTDIR="c:\_administrador\programas"
$INSTALLER="ccsetup${VERSION}.exe"
mkdir -force $DESTDIR

# (New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + [System.IO.Path]::GetFileName($URL))
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# install
&$DESTDIR\$INSTALLER "/S"

# run
$ccleaner = get-childitem "C:\prog*\ccleaner" -include ccleaner.exe -recurse
&$ccleaner "/auto"


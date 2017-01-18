# Descarga e instalación de ccleaner (test)
$VERSION="526"
$URL="http://download.piriform.com/ccsetup${VERSION}.exe"
$DESTDIR="c:\_administrador\programas"
$INSTALLER="ccsetup${VERSION}.exe"
mkdir -force $DESTDIR
# (New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + [System.IO.Path]::GetFileName($URL))
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# instalacion
cd $DESTDIR
&$INSTALLER "/S"




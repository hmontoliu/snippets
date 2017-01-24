# mantenimiento.ps1
# just a draft
# -- H. Montoliu <hmontoliu@gmail.com>  Wed Jan 18 10:27:01 UTC 2017



# ERROR/SYS LOG

get-eventlog -logname system -entrytype error,warning -newest 50 | out-gridview
get-eventlog -logname application -entrytype error,warning -newest 50 | out-gridview

# COBIAN BACKUP SUMMARY
# cobian10
gci 'C:\program files*\Cobian*\Settings\Logs\*' | sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview
# cobian11
gci 'C:\program files*\Cobian*\Logs\*' | sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview


# PROGRAM DOWNLOAD AND INSTALL
$DESTDIR="c:\_administrador\programas"
mkdir -force $DESTDIR

# CCLEANER

# Download, install, and run free ccleaner
# You should run ccleaner if you have configured it previously 
#
#
$VERSIONCC="526"

# download
$URL="http://download.piriform.com/ccsetup${VERSIONCC}.exe"
$INSTALLER="ccsetup${VERSIONCC}.exe"

# (New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + [System.IO.Path]::GetFileName($URL))
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# install
&$DESTDIR\$INSTALLER "/S"

# run
$ccleaner = get-childitem "C:\prog*\ccleaner" -include ccleaner.exe -recurse
&$ccleaner "/auto"

# DEFRAGGLER
$VERSIONDF="221"

# download
$URL="http://download.piriform.com/dfsetup${VERSIONDF}.exe"
$INSTALLER="dfsetup${VERSIONDF}.exe"
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# install
&$DESTDIR\$INSTALLER "/S"

# Malwarebytes
# TODO Download and install
$mbam = get-childitem "C:\prog*\malwarebytes*" -include mbam.exe -recurse
&$mbam

$management = "compmgmt.msc"
&management

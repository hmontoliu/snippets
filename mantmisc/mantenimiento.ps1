# mantenimiento.ps1
# draft
# -- H. Montoliu <hmontoliu@gmail.com>  Wed Jan 18 10:27:01 UTC 2017

# TODO
# use system env vars
# integrate legacy systems


# ERROR/SYS LOG
get-eventlog -logname system -entrytype error,warning -newest 50 | Select-Object Index,TimeGenerated,EntryType,Source,EventID,InstanceId,Message | Out-GridView
get-eventlog -logname application -entrytype error,warning -newest 50 | Select-Object Index,TimeGenerated,EntryType,Source,EventID,InstanceId,Message | Out-GridView

# COBIAN BACKUP SUMMARY
# cobian10
gci 'C:\program files*\Cobian*\Settings\Logs\*' | sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview
# cobian11
gci 'C:\program files*\Cobian*\Logs\*' | sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview
# legacy windows TODO
gci 'C:\Arch*\Cobian*\Settings\Logs\*' | sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview

# ROBOCOPY BACKUP SUMMARY
gci 'c:\_backups\logs\*' | select-string -Pattern 'Started|error|Copied|Inicio|error|Copiado' -Context 4 | out-gridview

# PROGRAM DOWNLOAD AND INSTALL
$DESTDIR="c:\_administrador\programas"
mkdir -force $DESTDIR

# CCLEANER
# Download, install, and run free ccleaner
# You should run ccleaner if you have configured it previously 
$VERSIONCC="526"

# download
$URL="http://download.piriform.com/ccsetup${VERSIONCC}.exe"
$INSTALLER="ccsetup${VERSIONCC}.exe"

# (New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + [System.IO.Path]::GetFileName($URL))
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# install
&$DESTDIR\$INSTALLER "/S"

# run ccleaner
$ccleaner = get-childitem "C:\prog*\ccleaner" -include ccleaner.exe -recurse
# legacy TODO
# do not run ccleaner until eventlog is fully checked
# &$ccleaner "/auto"
# launch ccleaner in interactive mode
&$ccleaner

# DEFRAGGLER
$VERSIONDF="221"

# download
$URL="http://download.piriform.com/dfsetup${VERSIONDF}.exe"
$INSTALLER="dfsetup${VERSIONDF}.exe"
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# install
&$DESTDIR\$INSTALLER "/S"

# run defraggler
$defraggler = get-childitem "C:\prog*\defraggler" -include defraggler.exe -recurse
# legacy TODO
# launch defraggler in interactive mode
&$defraggler

# MALWAREBYTES
# TODO Download and install
# launch mbam
$mbam = get-childitem "C:\prog*\malwarebytes*" -include mbam.exe -recurse
# legacy windows launch mbam TODO
# $mbam = get-childitem "C:\arch*\malwarebytes*" -include mbam.exe -recurse
&$mbam

# COMPMGMT
# open compmgmt.msc at end
$compmgmt="compmgmt.msc"
&$compmgmt

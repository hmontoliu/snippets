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
# TODO
# gci c:\_backups\logs\* | select-string -Pattern 'Started|error|Copied|Inicio|error|Copiado' -Context 4


# PROGRAM DOWNLOAD AND INSTALL
$DESTDIR="c:\_administrador\programas"
mkdir -force $DESTDIR

function install($url, $dest, $silent) {
    (New-Object System.Net.Webclient).DownloadFile($url, $dest)
    &$dest $silent
}

# CCLEANER
# Download, install, and run free ccleaner
# You should run ccleaner if you have configured it previously 
$VERSIONCC="526"
$INSTALLER="ccsetup${VERSIONCC}.exe"
$URL="http://download.piriform.com/${INSTALLER}"
$DEST=${DESTDIR}+"\"+${INSTALLER}

install "${URL}" "${DEST}" "/S"

# TODO run ccleaner
#$ccleaner = Get-ChildItem "C:\Program Files*\CCleaner\" -include CCleaner64.exe -recurse
# legacy TODO
# do not run ccleaner until eventlog is fully checked
# &$ccleaner "/auto"
# launch ccleaner in interactive mode
#&$ccleaner

# DEFRAGGLER
$VERSIONDF="221"
$INSTALLER="dfsetup${VERSIONDF}.exe"
$URL="http://download.piriform.com/${INSTALLER}"
$DEST=$DESTDIR+"\"+$INSTALLER

install "${URL}" "${DEST}" "/S"

# TODO run defraggler
#$defraggler = Get-ChildItem "C:\Program Files*\Defraggler\" -include Defragler.exe -recurse
# legacy TODO
# launch defraggler in interactive mode
#&$defraggler

# MALWAREBYTES
# Download and install
$INSTALLER="mb3-setup-consumer-3.0.6.1469.exe"
$URL="https://downloads.malwarebytes.com/file/mb3/"
$DEST=${DESTDIR}+"\"+${INSTALLER}

install "${URL}" "${DEST}" "/SILENT"

# TODO launch mbam
#$mbam = Get-ChildItem "C:\Program Files*\Malwarebytes*\Anti-Malware\" -include mbam.exe -recurse
# legacy windows launch mbam TODO
# $mbam = get-childitem "C:\arch*\malwarebytes*" -include mbam.exe -recurse
#&$mbam

# COMPMGMT
# open compmgmt.msc at end
$compmgmt="compmgmt.msc"
&$compmgmt

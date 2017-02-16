# mantenimiento.ps1
# draft/beta
# . { iwr -useb https://raw.githubusercontent.com/hmontoliu/snippets/master/mantmisc/mantenimiento.ps1 } | iex
# -- H. Montoliu <hmontoliu@gmail.com>  Wed Jan 18 10:27:01 UTC 2017

# Editable variables
$ccleaner_ver = "526"
$defraggler_ver = "221"
$localdir = "c:\_administrador\programas"

# Common stuff
function which($cmd) {
     # find object in progrmafiles/programfiles(x86)/archivos de programa....
     gci ${env:programfiles},${env:programfiles(x86)} -Include $cmd -Recurse -ErrorAction silentlycontinue | Select-Object -First 1
     }

function getlog($logname) {
    # parse and get event logs
    $entrytype="error","warning"
    $entries=50
    $eventobjects="Index","TimeGenerated","EntryType","Source","EventID","InstanceId","Message"
    get-eventlog -logname $logname -entrytype $entrytype -Newest $entries | Select-Object $eventobjects | Out-GridView
    }

function downinstandexec([string[]]$arr) {
	$test = Test-Path $arr[1]
    $exec = which $arr[2]
    # comprobar que exista ya la descarga
    If ($test -eq $True) {
        & $exec
    } else {
	    # download
	    (New-Object System.Net.WebClient).DownloadFile($arr[0], $arr[1])
	    # install
	    &$arr[1] + " " + $arr[3]
	    # exec
	    $exec = which $arr[2]
	    & $exec
    }
}

# ERROR/SYS LOG
getlog system
getlog application

# COBIAN BACKUP SUMMARY
# search order: cobian 11, cobian 10, legacy
gci ${env:programfiles}\Cobian*\Logs\*,
    ${env:programfiles}\Cobian*\Settings\Logs\*,
    ${env:programfiles(x86)}\Cobian*\Settings\Logs\* -ErrorAction silentlycontinue |
    sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview

# ROBOCOPY BACKUP SUMMARY
# TODO, testing
gci c:\_backups\logs\*  -ErrorAction silentlycontinue | select -last 7 | select-string -Pattern 'Started|error|Copied|Inicio|error|Copiado' -Context 4

# PROGRAM DOWNLOAD AND INSTALL (TODO: refactor as function; TODO: skip download if file already exists)
mkdir -force $localdir

# CCLEANER
# You should run ccleaner if you have configured it previously 
$INSTALLER = "ccsetup${ccleaner_ver}.exe"
$URL = "http://download.piriform.com/${INSTALLER}"
$DESTDIR = $localdir + "\" + $INSTALLER

downinstandexec("${URL}","${DESTDIR}","ccleaner.exe", "/S")

# DEFRAGGLER
$INSTALLER="dfsetup${defraggler_ver}.exe"
$URL="http://download.piriform.com/${INSTALLER}"
$DESTDIR = $localdir + "\" + $INSTALLER

downinstandexec("${URL}","${DESTDIR}","defraggler.exe", "/S")

# MALWAREBYTES
$INSTALLER="mb3-setup-consumer-3.0.6.1469.exe"
$URL="https://downloads.malwarebytes.com/file/mb3/"
$DESTDIR = $localdir + "\" + $INSTALLER

downinstandexec("${URL}","${DESTDIR}","mbam.exe", "/SILENT")

# COMPMGMT
# open compmgmt.msc at end
$compmgmt="compmgmt.msc"
&$compmgmt

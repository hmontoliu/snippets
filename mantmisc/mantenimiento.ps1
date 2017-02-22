# mantenimiento.ps1
# draft/beta
# . { iwr -useb https://raw.githubusercontent.com/hmontoliu/snippets/master/mantmisc/mantenimiento.ps1 } | iex
# -- H. Montoliu <hmontoliu@gmail.com>  Wed Jan 18 10:27:01 UTC 2017

# Editable variables
$ccleaner_ver = "527"
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

# ERROR/SYS LOG
getlog system
getlog application

# COBIAN BACKUP SUMMARY
# search order: cobian 11, cobian 10, legacy
gci ${env:programfiles}\Cobian*\Logs\*,
    ${env:programfiles}\Cobian*\Settings\Logs\*,
    ${env:programfiles(x86)}\Cobian*\Logs\*, 
    ${env:programfiles(x86)}\Cobian*\Settings\Logs\* -ErrorAction silentlycontinue |
    sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview

# ROBOCOPY BACKUP SUMMARY
# TODO, testing
#gci c:\_backups\logs\*  -ErrorAction silentlycontinue | select -last 7 | select-string -Pattern 'Started|error|Copied|Inicio|error|Copiado' -Context 4
#$TMPFILE=[System.IO.Path]::GetTempFileName() # fichero temporal (TODO)
$LASTLOGS=7
gci c:\_backups\logs\* -ErrorAction silentlycontinue | 
 sort LastWriteTime | select -last $LASTLOGS |
 select-string -Pattern 'Started|error|Copied|Inicio|error|Copiado' -Context 4,4 | 
 foreach-object {
    $_ | select-object `
      @{Name="Fichero"; Expression={$_.Filename}},
      @{Name="Linea";   Expression={$_.LineNumber}},
      @{Name="Cadena";     Expression={(($_.context.PreContext -join "`r`n"),
                                     ($_.Line -join "`r`n"),
                                     ($_.context.PostContext -join "`r`n")) -join "`r`n"}}
    } | Out-GridView


# PROGRAM DOWNLOAD AND INSTALL (TODO: refactor as function; TODO: skip download if file already exists)
$DESTDIR=$localdir
mkdir -force $DESTDIR

# CCLEANER
# Download, install, and run free ccleaner
# You should run ccleaner if you have configured it previously 
$VERSIONCC=$ccleaner_ver

# download
$URL="http://download.piriform.com/ccsetup${VERSIONCC}.exe"
$INSTALLER="ccsetup${VERSIONCC}.exe"

# (New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + [System.IO.Path]::GetFileName($URL))
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# install
&$DESTDIR\$INSTALLER "/S"

# run ccleaner
$ccleaner = which ccleaner.exe
# do not run ccleaner until eventlog is fully checked
# &$ccleaner "/auto"
# launch ccleaner in interactive mode
&$ccleaner

# DEFRAGGLER
$VERSIONDF=$defraggler_ver

# download
$URL="http://download.piriform.com/dfsetup${VERSIONDF}.exe"
$INSTALLER="dfsetup${VERSIONDF}.exe"
(New-Object System.Net.WebClient).DownloadFile($URL, $DESTDIR + "\" + $INSTALLER)

# install
&$DESTDIR\$INSTALLER "/S"

# run defraggler
$defraggler = which defraggler.exe
# launch defraggler in interactive mode
&$defraggler

# MALWAREBYTES
# TODO Download and install
# launch mbam
$mbam = which mbam.exe
&$mbam

# COMPMGMT
# open compmgmt.msc at end
$compmgmt="compmgmt.msc"
&$compmgmt

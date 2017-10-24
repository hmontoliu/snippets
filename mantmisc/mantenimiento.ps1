# mantenimiento.ps1
# draft/beta
# Download & exec in PowerShell 3.1.0 or higher
# . { iwr -useb https://raw.githubusercontent.com/hmontoliu/snippets/master/mantmisc/mantenimiento.ps1 } | iex
# -- H. Montoliu <hmontoliu@gmail.com>  Wed Jan 18 10:27:01 UTC 2017
# -- Marcos Leal Sierra <marcoslealsierra90@gmail.com> 


# Variables
$ccleaner_ver = "536"
$defraggler_ver = "221"
$localdir = "c:\_administrador\programas"

# Temp dir for downloads
$DESTDIR=$localdir
mkdir -force $DESTDIR

$herramientas = `
@("CCleaner", "CCleaner.exe", "http://download.piriform.com/ccsetup${ccleaner_ver}.exe", "/S"),
@("Defraggler", "Defraggler.exe", "http://download.piriform.com/dfsetup${defraggler_ver}.exe", "/S")
@("Malwarebytes", "mbam.exe", "https://data-cdn.mbamupdates.com/web/mb3-setup-consumer/mb3-setup-consumer-3.1.2.1733-1.0.160-1.0.2251.exe", "/S")
# TODO MALWAREBYTES INSTALLATION WITHOUT CHROME BROWSER AUTOINSTALL
#$herramientas += ,@("Malwarebytes", "mbam.exe", "https://xxxxxx", "/SILENT")

# Common stuff
function which($cmd) {
     # Find object in progrmafiles/programfiles(x86)/archivos de programa....
     gci ${env:programfiles}, ${env:programfiles(x86)} -Include $cmd -Recurse -ErrorAction silentlycontinue | Select-Object -First 1
}

function getlog($logname) {
    # Parse and get event logs
    $entrytype="error","warning"
    $entries=50
    $eventobjects="Index","TimeGenerated","EntryType","Source","EventID","InstanceId","Message"
    get-eventlog -logname $logname -entrytype $entrytype -Newest $entries | Select-Object $eventobjects | Out-GridView
}

function dandi($array) {
    # Download and silent install software
	foreach($element in $array) {
		$nombre = $element[0]
		$binario = $element[1]
		$url = $element[2]
		$silent = $element[3]
		$path = $localdir + "\" + $binario
		(New-Object System.Net.Webclient).DownloadFile($url, $path)
		&$path + " " + $silent
	}
}

# download and install software
dandi($herramientas)

# Create restore point (recommended)
Checkpoint-Computer -Description "Mantenimiento"

# error/sys log
getlog system
getlog application

# cobian backup summary
# search order: cobian 11, cobian 10, legacy
gci ${env:programfiles}\Cobian*\Logs\*,
    ${env:programfiles}\Cobian*\Settings\Logs\*,
    ${env:programfiles(x86)}\Cobian*\Logs\*, 
    ${env:programfiles(x86)}\Cobian*\Settings\Logs\* -ErrorAction silentlycontinue |
    sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview

# robocopy backup summary
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

# do not run ccleaner automatically until eventlog is fully checked
# &$(which ccleaner.exe) "/auto"
# launch ccleaner in interactive mode
&$(which ccleaner.exe)
&$(which defraggler.exe)
&$(which mbam.exe)

# compmgmt
# open compmgmt.msc at end
&compmgmt.msc

# system reliability 
&perfmon /rel

# system diagnostic
&perfmon /report

# windows update
# panel
control /name Microsoft.WindowsUpdate
# check upgrades
wuauclt.exe /detectnow
# autoinstall (Disabled)
# wuauclt.exe /detectnow /updatenow

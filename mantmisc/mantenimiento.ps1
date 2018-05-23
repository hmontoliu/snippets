# mantenimiento.ps1
# draft/beta
# Download & exec in PowerShell 3.1.0 or higher
# . { iwr -useb https://raw.githubusercontent.com/hmontoliu/snippets/master/mantmisc/mantenimiento.ps1 } | iex
# -- H. Montoliu <hmontoliu@gmail.com>  Wed Jan 18 10:27:01 UTC 2017
# -- Marcos Leal Sierra <marcoslealsierra90@gmail.com> 

# Variables
$ccleaner_ver = "540"
$defraggler_ver = "221"
$localdir = "c:\_administrador\programas"

# Temp dir for downloads
$DESTDIR=$localdir
mkdir -force $DESTDIR

# Create restore point (recommended)
echo "Creating a restore point..."
Checkpoint-Computer -Description "Mantenimiento"

$herramientas = `
@("CCleaner", "CCleaner.exe", "http://download.ccleaner.com/ccsetup${ccleaner_ver}.exe", "/S", "uninst.exe"),
@("Defraggler", "Defraggler.exe", "http://download.ccleaner.com/dfsetup${defraggler_ver}.exe", "/S", "uninst.exe")
@("Malwarebytes", "mbam.exe", "https://data-cdn.mbamupdates.com/web/mb3-setup-consumer/mb3-setup-consumer-3.3.1.2183-1.0.262-1.0.4124.exe", "/S", "uninst.exe")

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

# install third party apps
function dandi($appsarray) {
    # Download and silent install software
	foreach($element in $appsarray) {
        if ($element.GetType() -eq  $appsarray.GetType()) {
		$nombre = $element[0]
		$binario = $element[1]
		$url = $element[2]
		$silent = $element[3]
        $uninstall = $element[4] # not used here
		$installerpath = $localdir + "\" + $binario
        echo "Downloading $nombre ..."
		(New-Object System.Net.Webclient).DownloadFile($url, $installerpath)
        echo "Installing $nombre ..."
		&$installerpath + " " + $silent
    }
	}
}

# for later cleanup
function uninstallstuffbydandi($appsarray) {
    # silent uninstall previously installed software
	foreach($element in $appsarray) {
        if ($element.GetType() -eq  $appsarray.GetType()) {
		$nombre = $element[0]
		$binario = $element[1]
		$url = $element[2]
		$silent = $element[3]
        $uninstall = $element[4]
        echo "Uninstalling $nombre ..."
        &(Join-Path (split-path (which $binario)) $uninstall) /S
    }
	}
}

# download and install third party software
echo "Installing third party apps..."
dandi($herramientas)

# error/sys log
echo "Opening system log..."
getlog system
echo "Opening application log..."
getlog application

# cobian backup summary
# search order: cobian 11, cobian 10, legacy
echo "Checking cobian backup history..."
gci ${env:programfiles}\Cobian*\Logs\*,
    ${env:programfiles}\Cobian*\Settings\Logs\*,
    ${env:programfiles(x86)}\Cobian*\Logs\*, 
    ${env:programfiles(x86)}\Cobian*\Settings\Logs\* -ErrorAction silentlycontinue |
    sort LastWriteTime | select -last 7 | select-string 'error' -Context 4 | out-gridview

# robocopy backup summary
# TODO, testing
#gci c:\_backups\logs\*  -ErrorAction silentlycontinue | select -last 7 | select-string -Pattern 'Started|error|Copied|Inicio|error|Copiado' -Context 4
#$TMPFILE=[System.IO.Path]::GetTempFileName() # fichero temporal (TODO)
echo "Checking robocopy backup history..."
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
echo "Opening third party apps..."
&$(which ccleaner.exe)
&$(which defraggler.exe)
&$(which mbam.exe)

# compmgmt
# open compmgmt.msc at end
echo "Opening computer management..."
&compmgmt.msc

# system reliability 
echo "Opening computer reliability reports..."
&perfmon /rel

# system diagnostic
echo "Opening computer diagnostic reports..."
&perfmon /report

# windows update
# panel
echo "Opening windows update..."
control /name Microsoft.WindowsUpdate
# check upgrades
echo "Checking for windows udpates..."
wuauclt.exe /detectnow
# autoinstall (Disabled)
#echo "Installing available windows udpates..."
# wuauclt.exe /detectnow /updatenow

# uninstall installed third party apps
#echo "Uninstalling previously installed third party apps..."
#uninstallstuffbydandi($herramientas)

echo "Exiting..."

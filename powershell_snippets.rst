Download Powershell 2.0
-----------------------------------

     http://support.microsoft.com/kb/968929/es


Download a file
-------------------------------

Download a file/page to $destdir.

::

    $destdir = "c:\administrador\programs\"
    $srcurl = "http://download.piriform.com/dfsetup212.exe"
    (New-Object System.Net.WebClient).DownloadFile($srcurl, $destdir + "\" + [System.IO.Path]::GetFileName($srcurl))


Manage/download hotfixes from MBSA reports
-----------------------------------------------------

Convert each missing hotfix to object::

    $mbsa_report = path al informe
    $update_dir = c:\administrador\actualizaciones 

    [xml]$mbsa = Get-Content $mbsa_report 

    $hotfixes = $mbsa.GetElementsByTagName('Check') | Foreach-Object {$_.GetElementsByTagName('UpdateData')} | where-object {$_.IsInstalled -eq "false"}  

Get a list with all the missing hotfixes/patches/service packs:: 
    
    $hotfixes | foreach-object {$_.Title} > $update_dir\list.txt

Download those hotfixes to update_dir::

    $hotfixes | foreach-object {(New-Object System.Net.WebClient).DownloadFile($_.References.DownloadURL, $update_dir + "\" + [System.IO.Path]::GetFileName($_.References.DownloadURL))}

Install hotfixes (examples)::

    $arguments = "/quiet /norestart"
    gci *.exe | ForEach-Object {Start-Process -Wait $_.FullName $arguments}

EventLog examples
--------------------------elec

example::
    
    get-eventlog -logname system -entrytype error,warning -newest 30

    Get-EventLog -LogName system -EntryType error,warning -After '01-febrero-2013' | more
    
    get-eventlog -logname application -entrytype error,warning -newest 30 | Group-Object -Property Source, Message | fl -GroupBy Name -Property Count, Name

System processes 
----------------

example:: 

    Get-Process | Sort-Object CPU -desc | Select-Object -first 5 | Format-Table CPU,ProcessName


Audit robocopy logs
-----------------------------------------

::

    gci path/*log | select-string 'Inicio' 
    gci path/*log | select-string 'error' -Context 4
    gci path/*log | select-string 'Copiado' -Context 4

    gci path/*log | select-string -Pattern 'Started|error|Copied' -Context 4

Audit cobian backup logs
----------------------------------------------------------

Last 5 days summaries::

    gci 'C:\Archivos de *\Cobian*\Settings\Logs\*' | sort LastWriteTime | select -last 5 | select-string 'Errores:'

Last 5 days error list::

    gci 'C:\program files*\Cobian*\Logs\*' | sort LastWriteTime | select -last 5 | select-string 'error' -Context 4
    gci 'C:\Archivos de *\Cobian*\Settings\Logs\*' | sort LastWriteTime | select -last 5 | select-string 'error' -Context 4

Scheduled tasks
---------------------------

Perfeccionar::

    $schedtasks = schtasks.exe /query /V /FO CSV | ConvertFrom-Csv



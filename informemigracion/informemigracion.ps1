<#
# vim:ts=4:sw=4:et:
# Description: informe de migración de equipos
# powershell -executionpolicy unrestricted ./script.ps1
# . { iwr -useb https://raw.githubusercontent.com/hmontoliu/snippets/master/informemigracion/informemigracion.ps1 } | iex
# Created: 2016-11-18
# Copyright (c) 2016: Hilario J. Montoliu <hmontoliu@gmail.com>
 
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
# the full text of the license.
#>

$computername = $ENV:COMPUTERNAME
$username = "${ENV:USERNAME}@${ENV:USERDOMAIN}"
$outdir = "C:\temp\" 
$localdir = "c:\_administrador\programas"
 
New-Item -ItemType Directory -Force -Path "$outdir"
New-Item -ItemType Directory -Force -Path "$localdir"

$OUTFILE = "${outdir}\${computername}-${username}.html"

# Create restore point (recommended)
echo "Creating restore point ..."
Checkpoint-Computer -Description "Migracion"

# auxiliar functions to install third party apps (last ver in mantenimiento.ps1)
$herramientas = `
@("ProduKey", "ProduKey.exe", "http://www.nirsoft.net/utils/produkey_setup.exe", "/S", "uninst.exe"),
#@("MailPV", "mailpv.exe", "http://www.nirsoft.net/toolsdownload/mailpv_setup.exe", "/S", "uninst.exe"),
"" #necesario

# Common stuff
function which($cmd) {
     # Find object in progrmafiles/programfiles(x86)/archivos de programa....
     gci ${env:programfiles}, ${env:programfiles(x86)} -Include $cmd -Recurse -ErrorAction silentlycontinue | Select-Object -First 1
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
		$path = $localdir + "\" + $binario
        echo "Downloading $nombre ..."
		(New-Object System.Net.Webclient).DownloadFile($url, $path)
        echo "Installing $nombre ..."
		&$path + " " + $silent
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

# document
$head = @"
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<title>Informe equipo $computername (gen: $username)</title>
<meta name="author" content="Hilario J. Montoliu (hmontoliu at gmail.com)" />
<style type="text/css">
html, body { margin: 0; padding: 0; height: 100%; font-family: arial; }
body { background-color : #ffffff; color : #000000; }
#container { width: 960px; min-height: 100%; position: relative;
    margin: 0 auto; }
#cabecera { background-color: #005B9A; color: white; padding:10px; 
    box-shadow: 5px 5px 5px #555; }
#cabecera h1 { font-size: 150%; font-weight: bold; }
h3 { background-color: #005B9A; color: white; padding:10px; display:inline-block;
 padding:1em; }
#cabecera span { display: block; font-size: 85%; padding-top: 6px; }
#contenido {
    padding-top: 10px;
    padding-bottom: 80px; /* altura del pie */
}
#pie { position: absolute; bottom: 0; width: 100%; height: 80px; color:
    #8C8984; font-size: 90%; font-style: italic; border-top: solid 2px; }
#autor { float: left; }
#fecha { float: right; text-align: right; }
table { border-collapse: collapse; border: 1px solid #74C2E1; width: 100%; 
    margin-bottom: 5px;}
th { background-color: #74C2E1; font-size: 11pt; padding: 5px; text-align:
    left; white-space: nowrap; font-weight: bold; border: 1px solid #74C2E1;
    color: #005B9A;}
td { background-color: #FFFFFF; font-size: 11pt; text-align: left; font-weight:
normal; border: 1px solid #74C2E1;padding: 5px }
pre {
 white-space: pre-wrap;       /* css-3 */
 white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
 white-space: -pre-wrap;      /* Opera 4-6 */
 white-space: -o-pre-wrap;    /* Opera 7 */
 word-wrap: break-word;       /* Internet Explorer 5.5+ */
 font-size: 11pt;
}
</style>
<script language="javascript" type="text/javascript">
<!--
// all credits to esr at http://catb.org/~esr/datestamp.js
function parse_date(date)
{
    var dia = date.getDate();
    var mes = date.getMonth();
    var year = date.getFullYear();
    return "" + dia + "-" + mes + "-" + year;
}  
function date_lastmodified()
{
  var fecha = "Sin datos";
  var ultimamodif = document.lastModified;
  var sfepoch;
  // check if we have a valid date before proceeding
  if(0 != (sfepoch = Date.parse(ultimamodif)))
  {
    fecha = "" + parse_date(new Date(sfepoch));  
  }
  return fecha;
}
//-->
</script>
</head>
<body>
<div id="container">
<div id="cabecera">
<h2>
Informe equipo $computername (gen: $username)
</h2>
$(Get-Date)
<span>
</span>
</div>
<div id="contenido">
Algunas funciones solo est&acute;n disponibles con <a href="https://www.microsoft.com/en-us/download/details.aspx?id=50395">powershell 4.0 o superior</a>. Versi&oacute;n actual: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).
"@

$footer = '
</div>
<div id="pie">
<p>
</p>
<div id="autor">
Hilario J. Montoliu (hmontoliu at gmail.com)
</div>
<div id="fecha">
<script language="JavaScript" type="text/javascript">document.writeln("&Uacute;ltima modificaci&oacute;n: "+date_lastmodified());</script>
</div>
</div> <!-- pie -->
</div> <!-- container -->
</body>
</html>
'

echo "Obteniendo datos de equipo..."
$computersystem = Get-WmiObject win32_computersystem |
     ConvertTo-Html -Fragment name, domain, model `
     -precontent "<div id='equipo'><h3>Nombre, dominio/grupo de trabajo y modelo del equipo</h3>"`
     -postcontent "</div>" | 
     Out-String

echo "Obteniendo datos de sistema..."
$operatingsystem = Get-WMIObject Win32_OperatingSystem  |
     ConvertTo-Html -Fragment Caption, OSArchitecture,  ServicePackMajorVersion `
     -precontent "<div id='os'><h3>Detalle del sistema operativo</h3>"`
     -postcontent "</div>" | 
     Out-String

echo "Obteniendo datos de red..."
$nic = Get-WmiObject win32_networkadapterConfiguration  -Filter "Ipenabled=True" | foreach-object {
    $_ | select-object `
      @{Name="MAC";       Expression={$_.MACAddress}},
      @{Name="IP";        Expression={$_.IPAddress -join ', '}}, # necesario para mostar arrays en html
      @{Name="Subnet";         Expression={$_.IPSubnet}}, 
      @{Name="Gateway"; Expression={$_.DefaultIPGateway -join ', '}},
      @{Name="DHCP";      Expression={$_.DHCPEnabled}},
      @{Name="DHCPServer";       Expression={$_.DHCPServer}},
      @{Name="DNSDomain";        Expression={$_.DNSDomain}},
      @{Name="DNS";   Expression={$_.DNSServerSearchOrder -join ', '}},
      @{Name="Description";      Expression={$_.Description}}
} |
     ConvertTo-Html `
     -Fragment name, MAC, IP, Subnet, Gateway, DHCP, DHCPServer, DNSDomain, DNS, Description `
     -precontent "<div id='nic'><h3>Interfaces de red operativas (configuraci&oacute;n)</h3>" `
     -postcontent "</div>" |
     Out-String

echo "Obteniendo datos de productos..."
$aplicaciones = Get-WMIObject Win32_Product  |
     ConvertTo-Html -Fragment Caption, Name, Vendor, Version, InstallDate `
     -precontent "<div id='os'><h3>Software instalado</h3>"`
     -postcontent "</div>" |
     Out-String

echo "Obteniendo datos de cuentas de usuario local..."
$localusers = Get-WmiObject win32_UserAccount | 
     Select-Object name, @{N="password";E={$null}}, caption, fullname, disabled, sid |
     ConvertTo-Html -Fragment `
     -precontent "<div id='localusers'><h3>Cuentas locales</h3>"`
     -postcontent "</div>" | 
     Out-String

### ### $localgroups = Get-WMIObject win32_group -filter "LocalAccount='True'" |
### ###   Select PSComputername,Name,@{Name="Members";Expression={
### ###    $_.GetRelated("win32_useraccount").Name -join ";"
### ###   }}

### echo "Obteniendo relaciones de grupos con cuentas de usuario local..."
### $localgroups = Get-WMIObject win32_group -filter "LocalAccount='True'" | ForEach-Object -Process {"`n$($_.Name): "; $_.GetRelated("Win32_Account","Win32_GroupUser","","","PartComponent","GroupComponent",$FALSE,$NULL) | select -ExpandProperty Name | ForEach-Object -Process {"$($_), " }} | ConvertTo-Html -Fragment `
###      -precontent "<div id='localgroups'><h3>Relación cuentas locales con grupos locales</h3><pre>"`
###      -postcontent "</pre></div>" | 
###      Out-String

echo "Obteniendo datos de antivirus..."
$antivirus = Get-WmiObject -Namespace "root\securityCenter2" -Query "Select * From AntiVirusProduct" |
     Select-Object displayName, pathToSignedProductExe, timestamp |
     ConvertTo-Html -Fragment `
     -precontent "<div id='antiviruss'><h3>Antivirus instalado</h3>"`
     -postcontent "</div>" | 
     Out-String     

echo "Obteniendo datos de discos y particiones..."
$logicaldisk = Get-WMIObject Win32_logicaldisk |
     ConvertTo-Html -Fragment DeviceID, DriveType, ProviderName, Size, FreeSpace, VolumeName `
     -precontent "<div id='drives'><h3>Unidades locales y unidades de red</h3>"`
     -postcontent "</div>" | 
     Out-String
 
echo "Obteniendo datos de impresoras..."
$impresoras = Get-WMIObject Win32_printer |
     ConvertTo-Html -Fragment name, sharename, status `
     -precontent "<div id='printers'><h3>Impresoras</h3>"`
     -postcontent "</div>" | 
     Out-String
     
$impresorasred = Get-WMIObject Win32_TCPIPPrinterPort |
     ConvertTo-Html -Fragment Name, Hostaddress, Protocol, PortNumber, Description `
     -precontent "<div id='printersport'><h3>Puertos de Impresoras</h3>"`
     -postcontent "</div>" | 
     Out-String

echo "Obteniendo datos de recursos compartidos..."
$share = Get-WMIObject Win32_share |
     ConvertTo-Html -Fragment  name, path, status, caption, description  `
     -precontent "<div id='share'><h3>Recursos compartidos</h3>"`
     -postcontent "</div>" | 
     Out-String
  

# tareas programadas
echo "Obteniendo datos de tareas programadas..."
$tareastitle = "Listado de tareas programadas (taskpath '\')"
try {
# en w10 o 2016 usar get-scheduledtask
$tareashtml = Get-ScheduledTask -TaskPath \ |Get-ScheduledTaskInfo |
     Select-Object TaskName, LastRunTime, NextRunTime, lasttaskresult |
     ConvertTo-Html -Fragment  `
     -precontent "<div id='tareasprogramadas'><h3>$tareastitle</h3>"`
     -postcontent "</div>" | 
     Out-String
}
catch {
# para versiones anteriores saco los datos de schtasks.exe
# (no he podido hacer que funcione una regex multiline
# así que esto es provisional)
$mostrar = 0
$lineas = ''
foreach ($tarea in $(schtasks.exe)) {
    if ($mostrar -eq 1) { $lineas += "$tarea `r`n" }
    if ($tarea -match '^$') { $mostrar = 0 }
    if ($tarea -match '^Carpeta: \\$') { $mostrar = 1 }
    
} 

$tareashtml = @"
<div id='tareasprogramadas'><h3>$tareastitle</h3>
<pre>
$lineas
</pre>
</div>
"@
}
  
echo "Obteniendo datos de certificados..."
$certificados =  Get-ChildItem cert:\currentuser\my |
     ConvertTo-Html -Fragment  issuer, subject, hasprivatekey, notbefore, notafter `
     -precontent "<div id='certificados'><h3>Certificados del usuario</h3>"`
     -postcontent "</div>" | 
     Out-String

echo "Obteniendo datos de licencias..."
# licencias
$tmplicfile = "c:/temp/produkey.html"
&(which produkey.exe) /shtml $tmplicfile
echo "Waiting 10 seconds to complete license checking..."
start-sleep 10
[string]$licencias = Get-Content $tmplicfile
#remove-item -Path $tmplicfile

$emaillist = @"
<div id='emaillist'><h3>Listado de cuentas de correo</h3>
<p><a href="http://www.nirsoft.net/utils/mailpv.html">http://www.nirsoft.net/utils/mailpv.html</a></p>
<ul>
<li>Crear cuentas:</li>
<li>Migrar correos:</li>
<li>Firmas</li>
<li>Plantillas de correo</li>
<li>C:\Program Files\Common Files\Microsoft Shared\Stationery</li>
</ul>
</div>
"@

$varios1 = @"
<div style="width: 100%; display: table;">
<div style="display: table-row">
<div id='antivirus' style="width: 30%; display: table-cell;"><h3>Antivirus:</h3>
<ul>
<li>Nombre:</li>
<li>Lic:</li>
<li>Desinst viejo</li>
<li>Instalar nuevo</li>
<li>Activar nuevo</li>
</ul>
</div>
<div id='gfi' style="width: 30%; display: table-cell;"><h3>GFI:</h3>
<ul>
<li>Desinst viejo</li>
<li>Instalar nuevo</li>
<li>Configurar</li>
</ul>
</div>
<div id='datosamigrar' style="display: table-cell;"><h3>Datos a migrar:</h3>
<ul>
<li>Archivos:</li>
<ul>
<li>Escritorio</li>
<li>Mis documentos</li>
<li>Otros (listar)</li>
</ul>
<li>iexplore (export/import):</li>
<ul>
<li>certificados</li>
<li>bookmarks.htm</li>
<li>cookies</li>
<li>...</li>
</ul>
</ul>
</div>
</div>
</div>
"@

$varios2 = @"
<div style="width: 100%; display: table;">
<div style="display: table-row">
<div id='hitos' style="width: 50%; display: table-cell;">
<h3>Aplicaciones e hitos</h3>
<ul>
<li>OS</li>
<li>Activar OS</li>
<li>Drivers</li>
<li>Office</li>
<li>Activar Office</li>
<li>Winrar</li>
<li>Notepad++</li>
<li>.NET4</li>
<li>Adobe reader</li>
<li>Adobe flash</li>
<li>Java</li>
<li>Control userpasswords2/o secpol.msc</li>
<li>Admin energ&iacute;a</li>
<li>GFI</li>
<li>Ccleaner</li>
<li>Limpieza Ccleaner</li>
<li>cobian/robocopy</li>
<li>UAC</li>
<li>Pdfcreator</li>
<li>Spybot/malwarebytes</li>
<li>VideoLan</li>
<li>Defragller</li>
<li>Antivirus</li>
<li>Excepciones Antivirus</li>
<li>Firewall (desactivar)</li>
<li>Acceso recursos administrativos desde Samba</li>
<li>Otros hacks</li>
<li>PS5 (w7)</li>
<li>WUA (w7)</li>
<li>&nbsp;</li>        
<li>&nbsp;</li>        
<li>&nbsp;</li>
<li>&nbsp;</li>       
</ul>
</div>

<div style="display: table-cell;">
<div id='aplicacionesdelcliente'>
<h3>Listado de aplicaciones propias del cliente</h3>
<ul>
<li>&nbsp;</li>        
<li>&nbsp;</li>        
<li>&nbsp;</li>
<li>&nbsp;</li>  
</ul>
</div>
<div id='Backups'>
<h3>Backups</h3>
<ul>
<li>&nbsp;</li>        
<li>&nbsp;</li>        
<li>&nbsp;</li>
<li>&nbsp;</li>  
</ul>
</div>
</div>
</div>
</div>
"@

$notas = @"
<div id='notas'><h3>Notas:</h3>
</div>
"@

# todo junto
#ConvertTo-HTML -head $head -PostContent `
    $head,
    $computersystem, 
    $operatingsystem, 
    $nic, 
    $localusers, 
###     $localgroups, 
    $logicaldisk, 
    $share, 
    $impresoras,
    $impresorasred,
    $licencias,
    $antivirus,
    $emaillist,
    $tareashtml,
    $certificados,
    $datosamigrar,
    $varios1,
    $varios2,
    $notas,
    $aplicaciones,
    $footer > $OUTFILE

# uninstall installed third party apps
echo "Uninstalling previously installed third party apps..."
uninstallstuffbydandi($herramientas)

Invoke-Item $OUTFILE

echo "Exiting..."

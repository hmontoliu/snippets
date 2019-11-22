<#
# vim:ts=4:sw=4:et:
# Description: Listar certificados del equipo y guardarlos en un archivo csv
# powershell -executionpolicy unrestricted ./listar_certificados.ps1
# . { iwr -useb https://raw.githubusercontent.com/hmontoliu/snippets/master/listar_certificados/listar_certificados.ps1 } | iex
# Created: 2019-11-21
# Copyright (c) 2019: Hilario J. Montoliu <hmontoliu@gmail.com>, Fernando Brines <fbrines@hotmail.com>
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
# the full text of the license.
#>

$computername = $ENV:COMPUTERNAME
$username = "${ENV:USERNAME}@${ENV:USERDOMAIN}"
$outdir = "c:\temp\" 
$localdir = "c:\temp\"

New-Item -ItemType Directory -Force -Path "$outdir"

$OUTFILE = "${outdir}\${computername}-${username}-cert.csv"

Get-ChildItem cert:\currentuser\my  | Select-Object -Property DNSNameList, notbefore, notafter, hasprivatekey, Issuer, Subject | Export-CSV -Path $OUTFILE -Delimiter ';' -NoTypeInformation

echo "Exiting..."

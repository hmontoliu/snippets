$detalles = @("computersystem", "os",
              "baseboard", "cpu", "memorychip",
              "nic", "nicconfig",
              "logicaldisk", "netuse", "volume", "diskdrive", "partition",
              "useraccount",
              "printer",
              "share",
              "startup",
			  "job",
			  "product"
	)
	
$salida = "C:\temp\informe.html"
$formato = "htable"
$append = "output"

cmd /c "md C:\temp"
foreach ($detalle in $detalles) {
    cmd /c "wmic /${append}:${salida} ${detalle} list brief /format:${formato}"
    $append = "append"
}

Invoke-Item $salida

 #Invoke-Expression -Command:$command
 
 
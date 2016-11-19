set salida = "C:\temp\informe2.html"
set formato = htable

for %%i in ( "computersystem", "os",
              "baseboard", "cpu", "memorychip",
              "nic", "nicconfig",
              "logicaldisk", "netuse", "volume", "diskdrive", "partition",
              "useraccount",
              "printer",
              "share",
              "startup",
			  "job",
			  "product" ) do (
	wmic /append:C:\temp\informe2.html %%i list brief /format:htable
)


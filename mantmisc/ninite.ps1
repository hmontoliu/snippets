# -- Marcos Leal Sierra <marcoslealsierra90@gmail.com> lunes 13 de febrero del 2017 a las 10:54:09

Write-Host Ninite autoinstall

# Programas a descargar
$items = @("winrar", "chrome", "java", "notepadplusplus", "thunderbird", 
"vlc", "pdfcreator", "essentials", "malwarebytes")

# Generar URL
$url = ""
foreach ($item in $items)
{ 
  $url += $item + "-"
}

$url = "http://www.ninite.com/" + $url.TrimEnd("-") + "/ninite.exe"

# Descarga y ejecución 
$file = [system.environment]::getenvironmentvariable("userprofile") + "\Downloads\ninite.exe"
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($url,$file)

& $file

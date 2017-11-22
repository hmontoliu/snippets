# based on borgfriend's https://gist.github.com/borgfriend/5763637
# -- Marcos Leal Sierra <marcoslealsierra90@gmail.com> lunes 13 de febrero del 2017 a las 10:54:09

Write-Host Ninite autoinstall

# Items to download
$items = @("winrar", "chrome", "java", "notepadplusplus", "thunderbird", 
"vlc", "pdfcreator", "essentials", "malwarebytes")

# Generate URL
$url = ""
foreach ($item in $items)
{ 
  $url += $item + "-"
}

$url = "http://www.ninite.com/" + $url.TrimEnd("-") + "/ninite.exe"

# Download and exec 
$file = [system.environment]::getenvironmentvariable("userprofile") + "\Downloads\ninite.exe"
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($url,$file)

& $file

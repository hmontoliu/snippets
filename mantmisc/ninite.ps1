Write-Host Ninite autoinstall

# Get item names by reading ninite.exe download url
$items = @("winrar", "chrome", "java", "notepadplusplus", "thunderbird", 
"vlc", "pdfcreator", "essentials", "malwarebytes")

# Create URL
foreach ($item in $items)
{ 
  $url += $item + "-"
}

$url = "http://www.ninite.com/" + $url.TrimEnd("-") + "/ninite.exe"

# Download 
$file = [system.environment]::getenvironmentvariable("userprofile") + "\Downloads\ninite.exe"
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($url,$file)

& $file

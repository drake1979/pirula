# $username = "SZTE\azr-svc-bi-adf-dev"
# $password = "gEA2cGsZuQJZR7ljncQl"

param($username, $password)

$serviceName = "SZTEBIWS - Pirula"

# verify if the service already exists, and if yes remove it first
if (Get-Service $serviceName -ErrorAction SilentlyContinue)
{
	# using WMI to remove Windows service because PowerShell does not have CmdLet for this
    $serviceToRemove = Get-WmiObject -Class Win32_Service -Filter "name='$serviceName'"
    $serviceToRemove.delete()
    "service removed"
}
else
{
	# just do nothing
    "service does not exists"
}

"remove completed"


$x = (Get-Item "$PSScriptRoot\..").FullName
Write-Output $x

$binaryPath = (Get-Item "$PSScriptRoot\..").FullName + "\IFUA.SZTE.BI.WS.exe"
Write-Output $binaryPath
$serviceName = "SZTEBIWS - Pirula"

"installing service"
# creating credentials which can be used to run my windows service
$secpasswd = ConvertTo-SecureString $password  -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
# creating widnows service using all provided parameters
New-Service -name $serviceName -binaryPathName $binaryPath -displayName $serviceName -startupType Manual -credential $mycreds

Start-Service -Name "SZTEBIWS - Pirula"

"installation completed"
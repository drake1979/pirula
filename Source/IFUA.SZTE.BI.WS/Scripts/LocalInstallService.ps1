param($username, $password)

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
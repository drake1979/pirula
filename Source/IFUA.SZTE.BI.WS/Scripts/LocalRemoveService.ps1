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
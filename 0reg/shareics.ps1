#http://www.expta.com/2017/03/how-to-self-elevate-powershell-script.html
# Self-elevate the script if required
Set-ExecutionPolicy Bypass -Scope Process -Force
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

Set-ExecutionPolicy Bypass -Scope Process -Force
$wf="Wi-Fi 2"
$eth="Ethernet 4"



#For ($i=0; $i -le 1; $i++) {
#    "10 * $i = " + (10 * $i)
#.\00resetdns.ps1
netsh int ip reset
netsh winsock reset all
netsh int tcp reset all
netsh int ipv4 reset all
netsh int ipv6 reset all
netsh int httpstunnel reset all
ipconfig /flushdns

Start-Sleep -s 5

#.\0DisableICS.ps1
# Register the HNetCfg library (once)
regsvr32 hnetcfg.dll

# Create a NetSharingManager object
$m = New-Object -ComObject HNetCfg.HNetShare

# List connections
$m.EnumEveryConnection |% { $m.NetConnectionProps.Invoke($_) }

# Find connection
#$c = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "Wi-Fi 8" }
$c = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "$wf" }

# Get sharing configuration
$config = $m.INetSharingConfigurationForINetConnection.Invoke($c)

# See if sharing is enabled
Write-Output $config.SharingEnabled

# See the role of connection in sharing
# 0 - public, 1 - private
# Only meaningful if SharingEnabled is True
Write-Output $config.SharingType

$config.DisableSharing()

REGSVR32 /U hnetcfg.dll


#cd scriptpath
$ScriptPath = Split-Path $MyInvocation.InvocationName
echo $ScriptPath
cd $ScriptPath

#Turnon and turn off Mobile Hotspot
#.\turnoffmh.ps1
#Start-Sleep -s 5
#.\turnonmh.ps1
#Start-Sleep -s 5
#.\turnoffmh.ps1

#Run Network Adapter Settings
#ncpa.cpl


Start-Sleep -s 5
#TURN ON ICS
#https://superuser.com/questions/1110866/internet-connection-sharing-stopped-working-after-windows-10-anniversary-update
param(
    $sPublicAdapterName,
    $sPrivateAdapterName
)

#$sPublicAdapterName="Wi-Fi 8"
#$sPrivateAdapterName="Ethernet 7"
$sPublicAdapterName="$wf"
$sPrivateAdapterName="$eth"
if (!$sPrivateAdapterName) {
    Write-Host "EnableSharing.ps1 sPublicAdapterName sPrivateAdapterName"
    return
}#if

# Constants
$public = 0
$private = 1

Write-Host "Creating netshare object..."
$netshare = New-Object -ComObject HNetCfg.HNetShare

Write-Host "Getting public adapter..."
$publicadapter = $netshare.EnumEveryConnection | Where-Object {
    $netshare.NetConnectionProps($_).Name -eq $sPublicAdapterName
}#foreach

Write-Host "Getting private adapter..."
$privateadapter = $netshare.EnumEveryConnection | Where-Object {
    $netshare.NetConnectionProps($_).Name -eq $sPrivateAdapterName
}#foreach


For ($i=0; $i -le 1; $i++) {
Write-Host "Disabling and enabling public sharing for public adapter...."
$netshare.INetSharingConfigurationForINetConnection($publicadapter).DisableSharing()
$netshare.INetSharingConfigurationForINetConnection($publicadapter).EnableSharing($public)
$netshare.INetSharingConfigurationForINetConnection($publicadapter)

Write-Host "Disabling and enabling private sharing for private adapter...."
$netshare.INetSharingConfigurationForINetConnection($privateadapter).DisableSharing()
$netshare.INetSharingConfigurationForINetConnection($privateadapter).EnableSharing($private)
$netshare.INetSharingConfigurationForINetConnection($privateadapter)

# Clean up
Remove-Variable netshare

}


#pause
Start-Sleep -s 15

#For ($i=0; $i -le 1; $i++) {
#    "10 * $i = " + (10 * $i)
#.\00resetdns.ps1
netsh int ip reset
netsh winsock reset all
netsh int tcp reset all
netsh int ipv4 reset all
netsh int ipv6 reset all
netsh int httpstunnel reset all
ipconfig /flushdns

Start-Sleep -s 5

#.\0DisableICS.ps1
# Register the HNetCfg library (once)
regsvr32 hnetcfg.dll

# Create a NetSharingManager object
$m = New-Object -ComObject HNetCfg.HNetShare

# List connections
$m.EnumEveryConnection |% { $m.NetConnectionProps.Invoke($_) }

# Find connection
#$c = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "Wi-Fi 8" }
$c = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "$wf" }

# Get sharing configuration
$config = $m.INetSharingConfigurationForINetConnection.Invoke($c)

# See if sharing is enabled
Write-Output $config.SharingEnabled

# See the role of connection in sharing
# 0 - public, 1 - private
# Only meaningful if SharingEnabled is True
Write-Output $config.SharingType

$config.DisableSharing()

REGSVR32 /U hnetcfg.dll


#cd scriptpath
$ScriptPath = Split-Path $MyInvocation.InvocationName
echo $ScriptPath
cd $ScriptPath

#Turnon and turn off Mobile Hotspot
#.\turnoffmh.ps1
#Start-Sleep -s 5
#.\turnonmh.ps1
#Start-Sleep -s 5
#.\turnoffmh.ps1

#Run Network Adapter Settings
#ncpa.cpl


Start-Sleep -s 5
#TURN ON ICS
#https://superuser.com/questions/1110866/internet-connection-sharing-stopped-working-after-windows-10-anniversary-update
param(
    $sPublicAdapterName,
    $sPrivateAdapterName
)

#$sPublicAdapterName="Wi-Fi 8"
#$sPrivateAdapterName="Ethernet 7"
$sPublicAdapterName="$wf"
$sPrivateAdapterName="$eth"
if (!$sPrivateAdapterName) {
    Write-Host "EnableSharing.ps1 sPublicAdapterName sPrivateAdapterName"
    return
}#if

# Constants
$public = 0
$private = 1

Write-Host "Creating netshare object..."
$netshare = New-Object -ComObject HNetCfg.HNetShare

Write-Host "Getting public adapter..."
$publicadapter = $netshare.EnumEveryConnection | Where-Object {
    $netshare.NetConnectionProps($_).Name -eq $sPublicAdapterName
}#foreach

Write-Host "Getting private adapter..."
$privateadapter = $netshare.EnumEveryConnection | Where-Object {
    $netshare.NetConnectionProps($_).Name -eq $sPrivateAdapterName
}#foreach


For ($i=0; $i -le 1; $i++) {
Write-Host "Disabling and enabling public sharing for public adapter...."
$netshare.INetSharingConfigurationForINetConnection($publicadapter).DisableSharing()
$netshare.INetSharingConfigurationForINetConnection($publicadapter).EnableSharing($public)
$netshare.INetSharingConfigurationForINetConnection($publicadapter)

Write-Host "Disabling and enabling private sharing for private adapter...."
$netshare.INetSharingConfigurationForINetConnection($privateadapter).DisableSharing()
$netshare.INetSharingConfigurationForINetConnection($privateadapter).EnableSharing($private)
$netshare.INetSharingConfigurationForINetConnection($privateadapter)

# Clean up
Remove-Variable netshare

}

pause
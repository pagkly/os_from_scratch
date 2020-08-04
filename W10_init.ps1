#CHOCO
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#DISABLEUAC
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
#disable firewall
choco install -y virtio-drivers spice-agent instchoco
netsh advfirewall set allprofiles state off
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "ShowCortanaButton" -Value 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "ShowTaskViewButton" -Value 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\" -Name "SearchboxTaskbarMode" -Value 0
#Windef exclusion
#$ScriptPath = Split-Path $MyInvocation.InvocationName
#echo $ScriptPath
#cd $ScriptPath
#Add-MpPreference -ExclusionPath "$ScriptPath"
Add-MpPreference -ExclusionPath "C:\"
Add-MpPreference -ExclusionPath "D:\"
Disable-BitLocker -MountPoint "C:\"
 
#activate windows10
#https://www.youtube.com/watch?v=RN8oLGum8Rw
#https://www.reddit.com/r/Piracy/comments/9vtkn0/how_to_upgrade_windows_10_home_to_pro_the_pirate/
#https://www.reddit.com/r/sjain_guides/comments/9qyuij/hwidkms38genmk6_download_and_usage_guide/
#https://www.nsaneforums.com/topic/312871-windows-10-digital-license-hwid-kms38%E2%84%A2-generation/
#W10 pro for workstation
#slmgr /ipk NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
#W10 pro
slmgr /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
#Settings > Update & Security > Activation > Change product key > VK7JG-NPHTM-C97JM-9MPGT-3V66T > Next...
#hwidgen > HWID > START
#@jR6Vu!jY

#autologin
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$DefaultUsername = "user"
$DefaultPassword = "qwerty"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String

#WSL2
#https://docs.microsoft.com/en-us/windows/wsl/install-win10
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2



#darktheme
#https://www.tenforums.com/tutorials/24038-change-default-app-windows-mode-light-dark-theme-windows-10-a.html
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_SZ /d "0" /f
#HideCortana
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /f /v "ShowCortanaButton" /d "0"
#HideTaskView
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /f /v "ShowTaskViewButton" /d "0"
#blackwallpaper
#https://superuser.com/questions/850989/change-windows-desktop-background-command-line
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallPaper /t REG_SZ /d " " /f
reg add "HKEY_CURRENT_USER\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f

# https://www.tenforums.com/tutorials/53449-lock-unlock-taskbar-windows-10-a.html
# https://www.tenforums.com/gtsearch.php?cx=partner-pub-7156303416008077%3A205v6qk06j2&cof=FORID%3A9&ie=ISO-8859-1&q=show+hidden+items&sa.x=0&sa.y=0
#showtouchkeyboard(manual)
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7\" -Name "TipbandDesiredVisibility" -Value 1
#showinkworkspace(manual)
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace\" -Name "PenWorkspaceButtonDesiredVisibility" -Value 1
#unlocktasbar
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "TaskbarSizeMove" -Value 1

#FileExplorer
#ShowFileExt
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "HideFileExt" -Value 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "AutoCheckSelect" -Value 1
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "Hidden" -Value 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\" -Name "FullPath" -Value 1
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\" -Name "FullPathAddress" -Value 1

#FULLPATHINTITLEBAR
#https://www.itprotoday.com/cloud-computing/how-can-i-modify-registry-enable-option-display-full-path-windows-explorer-address
#ShowSuperHidden
#0 = Hide protected operating system files
#1 = Show protected operating system files
#Display
#Set-ItemProperty "HKCU:\Control Panel\Desktop\" -Name "LogPixels" -Value 120






#ENABLERDPAFTERFIREWALL
#ENABLE RDP
#https://theitbros.com/how-to-remotely-enable-remote-desktop-using-powershell/
#Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices -Computer 192.168.1.90 -Authentication 6
#(Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices -Computer 192.168.1.90 -Authentication 6).SetAllowTSConnections(1,1)
#https://sid-500.com/2018/08/22/remotely-enable-remote-desktop-with-powershell/
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name "fDenyTSConnections" -Value 0
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -Name "UserAuthentication" -Value 1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"




#https://edi.wang/post/2018/12/21/automate-windows-10-developer-machine-setup
#https://www.tenforums.com/tutorials/124150-hide-show-cortana-button-taskbar-windows-10-a.html
#https://www.askvg.com/collection-of-windows-10-hidden-secret-registry-tweaks/
#https://winaero.com/blog/change-taskbar-button-width-windows-10/
#https://www.tenforums.com/tutorials/6401-change-time-zone-windows-10-a.html
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
REG ADD "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f


#W10_Anaconda3envpath
#https://stackoverflow.com/questions/9546324/adding-directory-to-path-environment-variable-in-windows
#https://stackoverflow.com/questions/44515769/conda-is-not-recognized-as-internal-or-external-command
#setx /M path "%path%;C:\tools\Anaconda3;C:\tools\Anaconda3\Scripts;C:\tools\Anaconda3\Library\bin"
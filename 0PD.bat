::autoelevate
::https://stackoverflow.com/questions/7044985/how-can-i-auto-elevate-my-batch-file-so-that-it-requests-from-uac-administrator
@ECHO OFF & CLS & ECHO.
NET FILE 1>NUL 2>NUL & IF ERRORLEVEL 1 (ECHO You must right-click and select &
  ECHO "RUN AS ADMINISTRATOR"  to run this batch. Exiting... & ECHO. &
  PAUSE & EXIT /D)
REM ... proceed here with admin rights ...

:: https://social.technet.microsoft.com/Forums/windows/en-US/c69d3bb5-328c-43e3-9239-837171e42b88/diskpart-batch-file?forum=w7itproinstall
:: get path of script
:: https://stackoverflow.com/questions/3827567/how-to-get-the-path-of-the-batch-script-in-windows
SET scpath=%~dp0
echo %scpath:~0,-1%

::list disk
diskpart /s "%scpath%admin_listdisk.txt"
:: input number and bootmode
:: https://stackoverflow.com/questions/1223721/in-windows-cmd-how-do-i-prompt-for-user-input-and-use-the-result-in-another-com
set /p number="Enter number: "
set /p bootmode="UEFI/BIOS : "

::vars
set "pdformat=vmdk"
set "pddir=C:\Users\%USERNAME%\VirtualBox VMs"
set "pddir=D:\VBOX"
set "pdname=PD%number%.%pdformat%"
set "pdfp=%pddir%\%pdname%"
echo "%pdfp%"

:: delete
set "vmname=USB_%bootmode%"
:: del "%pdfp%"
echo %vmname%

::
vboxmanage storageattach "%vmname%" ^
                        --storagectl "SATA Controller" --port 0 --medium emptydrive
vboxmanage closemedium disk "%pdfp%" --delete

:: https://www.serverwatch.com/server-tutorials/using-a-physical-hard-drive-with-a-virtualbox-vm.html#:~:text=To%20do%20so%2C%20open%20the,when%20creating%20the%20VMDK%20file.
vboxmanage internalcommands createrawvmdk -filename "%pdfp%" -rawdisk \\.\PhysicalDrive%number%
:: vboxmanage storagectl "%vmname%" --name "SATA Controller" --add sata --controller IntelAhci  
vboxmanage storageattach "%vmname%" ^
                        --storagectl "SATA Controller" ^
                        --device 0 ^
                        --port 0 ^
                        --type hdd ^
                        --medium "%pdfp%"
:: vboxmanage storagectl "%vmname%" ^
::                        --name "RSCSI" ^
::                        --add scsi
:: vboxmanage storageattach "%vmname%" ^
::                        --storagectl "RSCSI" ^
::                        --device 0 ^
::                        --port 0 ^
::                        --type hdd ^
::                        --medium "%pdfp%"
vboxmanage startvm "%vmname%" 
pause
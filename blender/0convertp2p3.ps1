pip install 2to3

#https://www.autoitconsulting.com/site/scripting/get-current-script-directory-powershell-vbscript-batch/
# Determine script location for PowerShell
$scdir = Split-Path $script:MyInvocation.MyCommand.Path

Get-ChildItem "$scdir" -Filter *.py | 
Foreach-Object {
$fn=$_.FullName
#$content = Get-Content $_.FullName
echo "$fn"
python C:\Python38\Tools\scripts\2to3.py -w "$fn"
}

cmd /c pause | out-null

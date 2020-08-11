@ECHO OFF
:: SET "THISFOLDER=%~dp0PYTHON26"
:: set "THISFOLDER=D:\VBOX\GitHub\os_from_scratch\0others\blender249_sketchfab_edition\PYTHON26"
:: set "fdir=D:\VBOX\GitHub\os_from_scratch\0others\blender249_sketchfab_edition\sketchfab_rip_script_here"
:: SET PythonPath=%THISFOLDER%;%THISFOLDER%\DLLs;%THISFOLDER%\LIB;%THISFOLDER%\LIB\LIB-TK

SET "THISFOLDER=C:\Python38"
set "bf=C:\Program Files\Blender Foundation\Blender 2.83"
set "fdir=D:\VBOX\GitHub\os_from_scratch\0others\Blender249"
SET PythonPath=%THISFOLDER%;%THISFOLDER%\DLLs;%THISFOLDER%\LIB;%THISFOLDER%\LIB\LIB-TK
start "%bf%\blender.exe" "%fdir%\Blender249.blend"
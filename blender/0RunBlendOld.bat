@ECHO OFF
SET "THISFOLDER=%~dp0PYTHON26"
SET PythonPath=%THISFOLDER%;%THISFOLDER%\DLLs;%THISFOLDER%\LIB;%THISFOLDER%\LIB\LIB-TK
start %~dp0blender.exe "%~dp0\sketchfab_rip_script_here\Blender249.blend"
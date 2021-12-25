@echo off
SET THEFILE=C:\Users\owner\Documents\Peach 3\Peach.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.2.0\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections  -s --subsystem windows --entry=_WinMainCRTStartup    -o "C:\Users\owner\Documents\Peach 3\Peach.exe" "C:\Users\owner\Documents\Peach 3\link.res"
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end

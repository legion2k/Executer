@echo off
set mcFile=EventLog
set mcFull=%mcFile%.mc
set mcFilFulle=%mcFile%.mc
set mcOut32=%mcFile%32
set mcOut64=%mcFile%64
set mc32="c:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x86\mc.exe"
set rc32="c:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x86\rc.exe"
set mc64="c:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64\mc.exe"
set rc64="c:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64\rc.exe"

::del %mcOut32%.res > nul
::%mc32% -u -U -z %mcOut32% %mcFull%
::del %mcOut32%.h > nul
::%rc32% -r %mcOut32%.rc
::del %mcOut32%.rc > nul
::del %mcOut32%*.bin > nul
::echo Done 32

del %mcOut64%.res > nul
%mc64% -u -U -z %mcOut64% %mcFull%
del %mcOut64%.h > nul
%rc64% -r %mcOut64%.rc
del %mcOut64%.rc > nul
del %mcOut64%*.bin > nul
echo Done 64

pause





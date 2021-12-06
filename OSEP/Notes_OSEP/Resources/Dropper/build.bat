@ECHO OFF

"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.30.30705\bin\Hostx64\x86\cl.exe" /nologo /Ox /MT /W0 /GS- /DNDEBUG /Tp dropperV1.cpp /link /OUT:dropper.exe /SUBSYSTEM:WINDOWS
rem Cleaning up...
del *.obj
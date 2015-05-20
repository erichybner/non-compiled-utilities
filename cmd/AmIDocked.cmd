@echo off
setlocal
for /f "Tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\IDConfigDB" /V CurrentConfig^|FIND "REG_DWORD"') do (set /a profile=%%b)

if %profile%==1 goto undocked
if %profile%==2 goto docked
goto EOF

:undocked
echo Computer isn't docked.
goto EOF

:docked
echo Computer is docked.

:EOF
endlocal
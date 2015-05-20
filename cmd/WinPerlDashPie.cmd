@echo off
IF "%1"=="" echo Usage: WinPerlDashPie "x:\dir" *.txt "replace this" "with this"
IF "%1"=="" echo Usage: Escape special characters per regex i.e. 4.0 == 4\.0
IF "%1"=="" goto end

IF "%1" == "process" GOTO processFile
GOTO convertAll

:convertALL
FOR /R %1 %%f IN (%2) DO cmd /c %0 process "%%f" %3 %4
GOTO end

:processFile
  SET IN=%2
  SetLocal EnableDelayedExpansion
  REM Remove Quotes - needed for cmd arg but not ignored for perl
  SET ReplaceThis=%3
  CALL :dequote ReplaceThis
  SET WithThis=%4
  CALL :dequote WithThis  	
  C:\src\tools\strawberry-perl-5.12.2.0\perl\bin\perl -p -i.bak -e "s/%ReplaceThis%/%WithThis%/g" %IN%
  del %IN%.bak
GOTO end

:dequote

SET _DeQuoteVar=%1
CALL SET _DeQuoteString=%%!_DeQuoteVar!%%
IF [!_DeQuoteString:~0^,1!]==[^"] (
IF [!_DeQuoteString:~-1!]==[^"] (
SET _DeQuoteString=!_DeQuoteString:~1,-1!
) ELSE (GOTO :EOF)
) ELSE (GOTO :EOF)
SET !_DeQuoteVar!=!_DeQuoteString!
SET _DeQuoteVar=
SET _DeQuoteString=
GOTO :EOF

:end
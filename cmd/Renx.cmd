@REM=========================================================
@REM rename multiple files with string search and replace
@REM=========================================================
 
@if "%1" NEQ "" @goto go
@echo USAGE: 
@echo renx (/T /R) filemask searchstring replacestring 
@echo /T print filenames only 
@echo /R recurse subdirectories
@echo.
 
:go
@set rencmd=move
@set rec=
 
:parseopts
@if /i "%1" =="/T" set rencmd=rem && shift && goto parseopts
@if /i "%1" =="/R" set rec=/R && shift && goto parseopts
 
@for %rec% %%x in (%1) DO @call :RenameFile "%%x" "%2" "%3"
@goto end
 
@REM=======================================================
@REM RenameFile (filename, searchstring, replacestring)
@REM=======================================================
:RenameFile
@set name=%1
@>tmp.bat echo @set newname=%%name:%2=%3%%
@>>tmp.bat echo @echo %%name%%
@>>tmp.bat echo @echo %%newname%%
@>>tmp.bat echo @echo.
@>>tmp.bat echo @%rencmd% %name% %%newname%%
@call tmp.bat
@del tmp.bat
@goto end
:end
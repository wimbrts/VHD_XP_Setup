:: install.cmd, v.1.0
:: Written by Pauli Pesonen December 17, 2007.
:: Install Enhanced Write Filter Manager and Driver
@Echo off
@Echo *******************************************************************************
@Echo * Enhanced Write Filter Manager and Driver installation start.                *
@Echo *******************************************************************************
pause
@SET DEST=%ProgramFiles%\EWF\
@SET Icons=%ALLUSERSPROFILE%\Start Menu\Programs\Enhanced Write Filter Manager
@SET MYDIR=%~DP0%
:: Check boot.ini
@type c:\boot.ini | findstr /i "multi(0)disk(0)rdisk(0)partition(1)"
@if %errorlevel% == 0 @Echo C:\BOOT.INI is correct. & goto ewf.reg_match
@if %errorlevel% == 1 @Echo C:\BOOT.INI and ewf.reg file do not match. & Echo Check ewf.reg file. & pause & goto END
:ewf.reg_match
copy /Y "%MYDIR%ewfmgr.exe" %SystemRoot%\system32\ewfmgr.exe
copy /Y "%MYDIR%ewf.sys" %SystemRoot%\system32\drivers\ewf.sys
if not exist "%DEST%" md "%DEST%"
if not exist "%Icons%" md "%Icons%"
copy /Y "%MYDIR%EWF.txt" "%DEST%"
copy /Y "%MYDIR%Status.cmd" "%DEST%"
copy /Y "%MYDIR%Write changes to the protected volume and turn EWF back on.cmd" "%DEST%"
copy /Y "%MYDIR%Icons" "%Icons%"
:: *** Add Registry rights Administrators FULL***
"%MYDIR%RegDACL.exe" "HKLM\SYSTEM\CurrentControlSet\Enum\Root" /gga:F >nul
regedit /s "%MYDIR%ewf.reg"
@Echo.
@Echo Look full documentation %ProgramFiles%\EWF\EWF.txt
@Echo.
@Echo The typical process for making persistent changes to the EWF protected volume
@Echo is run Write changes to the protected volume and turn EWF back on.cmd
@Echo command and restart computer.
@Echo.
@Echo Status.bat display protected volume information.
@Echo.
@Echo *******************************************************************************
@Echo * Enhanced Write Filter Manager and Driver installation is now complete.      *
@Echo * Restart computer to finalize installation.                                  *
@Echo *******************************************************************************
pause
:END

@echo off

IF EXIST "%SystemDrive%\TXTSETUP.SIF" DEL "%SystemDrive%\TXTSETUP.SIF"
IF EXIST "%SystemDrive%\$LDR$" DEL "%SystemDrive%\$LDR$"
IF EXIST "%SystemDrive%\$WIN_NT$.~BT\" rd /S /Q "%SystemDrive%\$WIN_NT$.~BT\"


exit
::
:: When in winnt.sif file in [Data] Section UnattendSwitch="No" 
:: we can use OOBEINFO.INI for Settings of Windows Welcome Screens
::
:: OOBEINFO.INI - skip anything but Resolution Check and User creation - 12 May 2008
:: placed in USB_MultiBoot_9\$OEM$_UserXP\$$\System32\oobe folder as File OOBEINFO.INI

:: SkipAutoUpdate = 1 does not work, requires Registry Patch with Batch File SET_WUP.cmd running from CMDLINES.TXT
:: SET_WUP.cmd in $OEM$ Folder - skip Windows Update Screen in OOBE - Windows Welcome Screens
::
:: 4 = Automatic Updates Download + Install, Required to skip Windows Update Screen in OOBE 
:: 3 = Only Download Updates
:: 2 = Only Notify Updates
:: 1 = No Windows Updates
::
SET RegKey="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" 
reg.exe add %RegKey% /v AUOptions /t REG_DWORD /d 4 /f 
EXIT

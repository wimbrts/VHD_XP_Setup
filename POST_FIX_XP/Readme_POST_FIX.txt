POST_FIX_XP Tools - Readme

You can use DriverForge.v4.5.4.exe to Install any missing driver (e.g. video audio or WLAN)
by selecting Path to Uncompressed Driver Files e.g. S:\D

In that case DevicePath in HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion
is set to what DriverForge needs. 
It means that any previous settings are lost e.g. for making use of the KTP C:\WINDOWS\DriverPacks store.

If you have selected in DPsBase.exe to Keep The Drivers by using KTP Option,
then after using DriverForge you need to run DevicePath_Reset_KTP.reg to Reset DevicePath to the KTD settings. 

=======================================================================================================

If you did not use the advised Keep The Drivers Option KTD when integrating DriverPacks in your XP Setup Source with DPsBase.exe
then you can later add to your Image the WINDOWS\DriverPacks folder with subfolders C and CPU and M of extracted DriverPacks
After booting with XP Image you can run POST_FIX_XP\DevicePath_Reset_KTP.reg to Reset DevicePath to the KTD settings
Additionally the Environment value of KTD must be set as C:\WINDOWS\DriverPacks by using KTD_SystemRoot_DP.reg

Alternatively you can use this method:

Post Install Add DriverPacks:

1. Boot with Universal XP Image file
2. Extract 3 DriverPacks to C:\ e.g. Chipset + CPU + MassStorage - will give C:\D folder
3. Use R-mouse to Open command prompt at C:\POST_FIX_XP and run command

DevPath.exe %SystemDrive%\D


DevicePath in HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion
is set to subfolders of C:\D

=======================================================================================================

If you have Installed XP on AMD machine and then boot XP Image file on Intel machine,
then intelppm Service will have Start=1 value, which will give BSOD 7 E when booting on AMD machine.

This problem can be overcome by running the intelppm_Start3.reg registry tweak.
In that case intelppm Service will get Start=3 and everything will be OK for AMD and Intel.

=======================================================================================================

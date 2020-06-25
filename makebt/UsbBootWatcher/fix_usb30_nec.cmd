@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem insert Renesas USB 3.0 settings to online or offline registry
rem
rem copy files nusb3xhc.sys and nusb3hub.sys to @SystemRoot@\system32\drivers\
rem 
rem fix_usb30_nec.cmd v0.02
rem created by cdob

set ClassGUID={36FC9E60-C465-11CF-8056-444553540000}

rem case: copy *.cmd to offline @SystemRoot@ and use runas (runas pwd use online %SystemRoot%)
pushd %~dp0
set WinSystemRoot=.

rem read command line
if not %1.==. set WinSystemRoot=%1

if not exist "%WinSystemRoot%\System32\config\system" set /P WinSystemRoot=Path to your SystemRoot folder on usb drive (e:\Windows): 
popd
if not exist "%WinSystemRoot%\System32\config\system" (echo Error: target not found &pause &popd &goto :eof)

pushd "%WinSystemRoot%"
set WinSystemRoot=%cd%

set offline=true
if /I "%WinSystemRoot%"=="%SystemRoot%" set offline=

set CriticalDeviceDatabase=HKLM\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase
set Services=HKLM\SYSTEM\CurrentControlSet\Services

if DEFINED offline (
  echo. &echo offline windows &echo.
  echo backup System32\config\system
  copy System32\config\system System32\config\system.%random%.sav
  reg.exe unload HKLM\loaded_SYSTEM >nul 2>&1
  echo load registry file %cd%\System32\config\system 
  reg.exe load HKLM\loaded_SYSTEM System32\config\system 

  rem detect CurrentControlSet
  for /f "tokens=3" %%a in ('reg.exe query "HKLM\loaded_SYSTEM\Select" /v "Current"') do set /a ControlSet=%%a
  set ControlSet=00000!ControlSet!
  set ControlSet=ControlSet!ControlSet:~-3!
  echo. &echo ControlSet "!ControlSet!" used.

  set CriticalDeviceDatabase=HKLM\loaded_SYSTEM\!ControlSet!\Control\CriticalDeviceDatabase
  set Services=HKLM\loaded_SYSTEM\!ControlSet!\Services
)

echo Services %Services%

echo on
@rem USB 3.0 Host Controller
reg.exe add "%CriticalDeviceDatabase%\PCI#VEN_1033&DEV_0194&REV_03" /f /v "ClassGUID" /d "%ClassGUID%"
reg.exe add "%CriticalDeviceDatabase%\PCI#VEN_1033&DEV_0194&REV_03" /f /v "Service" /d "nusb3xhc"
reg.exe add "%CriticalDeviceDatabase%\PCI#VEN_1033&DEV_0194&REV_04" /f /v "ClassGUID" /d "%ClassGUID%"
reg.exe add "%CriticalDeviceDatabase%\PCI#VEN_1033&DEV_0194&REV_04" /f /v "Service" /d "nusb3xhc"

reg.exe add "%Services%\nusb3xhc" /f /v "DisplayName" /d "Renesas Electronics USB 3.0 Host Controller Driver"
reg.exe add "%Services%\nusb3xhc" /f /v "Group" /d "Boot Bus Extender"
reg.exe add "%Services%\nusb3xhc" /f /v "ImagePath" /d "system32\drivers\nusb3xhc.sys"
reg.exe add "%Services%\nusb3xhc" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\nusb3xhc" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\nusb3xhc" /f /t REG_DWORD /v "Type" /d 1


@rem USB 3.0 Hub
reg.exe add "%CriticalDeviceDatabase%\NUSB3#ROOT_HUB30" /f /v "ClassGUID" /d "%ClassGUID%"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#ROOT_HUB30" /f /v "Service" /d "nusb3hub"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09" /f /v "ClassGUID" /d "%ClassGUID%"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09" /f /v "Service" /d "nusb3hub"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09&SUBCLASS_00&PROT_01" /f /v "ClassGUID" /d "%ClassGUID%"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09&SUBCLASS_00&PROT_01" /f /v "Service" /d "nusb3hub"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09&SUBCLASS_00&PROT_02" /f /v "ClassGUID" /d "%ClassGUID%"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09&SUBCLASS_00&PROT_02" /f /v "Service" /d "nusb3hub"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09&SUBCLASS_00&PROT_03" /f /v "ClassGUID" /d "%ClassGUID%"
reg.exe add "%CriticalDeviceDatabase%\NUSB3#CLASS_09&SUBCLASS_00&PROT_03" /f /v "Service" /d "nusb3hub"

reg.exe add "%Services%\nusb3hub" /f /v "DisplayName" /d "Renesas Electronics USB 3.0 Hub Driver"
reg.exe add "%Services%\nusb3hub" /f /v "Group" /d "System Bus Extender"
reg.exe add "%Services%\nusb3hub" /f /v "ImagePath" /d "system32\drivers\nusb3hub.sys"
reg.exe add "%Services%\nusb3hub" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\nusb3hub" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\nusb3hub" /f /t REG_DWORD /v "Type" /d 1
@echo off

rem pause
if DEFINED offline reg.exe unload HKLM\loaded_SYSTEM
popd
:: pause
goto :eof
rem ===================================================================

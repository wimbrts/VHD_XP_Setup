@echo off
pushd %~dp0

rem usb_xp_init.cmd v0.02
rem created by cdob

rem addon to UsbBootWatcher by marv
rem http://www.911cd.net/forums//index.php?showtopic=22473

echo prepare offline XP files, set USB boot drivers
echo running windows XP or Windows 7
echo.

set OsXP=
ver | find "Version 5.1" && set OsXP=XP

if %1.==-secret_add_system_boot. (
  echo ### -secret_add_system_boot ###
  call :set_usb_boot_setting
  exit
  goto :eof
)

set XP_system32=\Windows\system32
if not %1.==. set XP_system32=%1

if not exist "%XP_system32%\config\system" set /P XP_system32=Path to your system32 folder on usb drive (e:\Windows\system32): 
if not exist "%XP_system32%\config\system" (echo Error: target not found &pause &popd &goto :eof)

copy "%XP_system32%\config\system" "%XP_system32%\config\system_%random%.sav"
reg.exe load HKLM\loaded_SYSTEM "%XP_system32%\config\system"

rem running XP, run at system account (that's not Windows 7)
rem this includes first installation reboot: system registry use system permissions
rem launch cmd.exe using system account
rem http://blogs.msdn.com/adioltean/articles/271063.aspx
if defined OsXP (
  echo run UsbBootCmd at system premission
  sc.exe delete UsbBootCmd >nul
  sc.exe create UsbBootCmd binpath= "%SystemRoot%\system32\cmd.exe /c start /min %~s0 -secret_add_system_boot" type= own type= interact >nul
  sc.exe start  UsbBootCmd >nul
  sc.exe delete UsbBootCmd >nul
)


set OS_Architecture=I386
if exist "%XP_system32%\..\Driver Cache\AMD64\driver.cab" set OS_Architecture=AMD64

rem detect last sp*.cab
For /f "delims=" %%a in ('dir /a-d /on /b /s "%XP_system32%\..\Driver Cache\%OS_Architecture%\sp*.cab"') do set sp_cab=%%a
echo sp driver cab: %sp_cab%

for %%b in (usbehci.sys usbohci.sys usbuhci.sys usbport.sys usbhub.sys usbd.sys usbccgp.sys usbstor.sys) do (
  if not exist "%XP_system32%\drivers\%%b" (
    echo expand %%b
    expand.exe "%XP_system32%\..\Driver Cache\%OS_Architecture%\driver.cab" -F:%%b "%XP_system32%\drivers"
    expand.exe "%sp_cab%" -F:%%b "%XP_system32%\drivers"
  )
)

rem add IDE and ATAPI
for %%b in (pciide.sys intelide.sys pciidex.sys atapi.sys) do (
  if not exist "%XP_system32%\drivers\%%b" (
    echo expand %%b
    expand.exe "%XP_system32%\..\Driver Cache\%OS_Architecture%\driver.cab" -F:%%b "%XP_system32%\drivers"
    expand.exe "%sp_cab%" -F:%%b "%XP_system32%\drivers"
  )
)


:UsbBootWatcher
if %OS_Architecture%.==I386. set OS_Architecture=x86
copy %OS_Architecture%\UsbBootWatcher.* %XP_system32%

rem at Windows 7: use administrator account: fully installed offline Windows XP
if not defined OsXP call :set_usb_boot_setting

popd
goto :eof
rem ===================================================================


:set_usb_boot_setting =================================================
echo on

rem detect Clone control CurrentControlSet
for /f "tokens=3" %%a in ('reg.exe query "HKLM\loaded_SYSTEM\Select" /v "Default"') do set /a ControlSet=%%a
set ControlSet=00000%ControlSet%
set ControlSetNNN=ControlSet%ControlSet:~-3%
echo. &echo ControlSet "%ControlSetNNN%" used.

set CriticalDeviceDatabase=HKLM\loaded_SYSTEM\%ControlSetNNN%\Control\CriticalDeviceDatabase

reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0C0300" /f /v "ClassGUID" /d "{36FC9E60-C465-11CF-8056-444553540000}"
reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0C0300" /f /v "Service" /d "usbuhci"

reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0C0310" /f /v "ClassGUID" /d "{36FC9E60-C465-11CF-8056-444553540000}"
reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0C0310" /f /v "Service" /d "usbohci"

reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0C0320" /f /v "ClassGUID" /d "{36FC9E60-C465-11CF-8056-444553540000}"
reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0C0320" /f /v "Service" /d "usbehci"

reg.exe add "%CriticalDeviceDatabase%\USB#CLASS_08" /f /v "ClassGUID" /d "{36FC9E60-C465-11CF-8056-444553540000}"
reg.exe add "%CriticalDeviceDatabase%\USB#CLASS_08" /f /v "Service" /d "usbstor"

reg.exe add "%CriticalDeviceDatabase%\USB#CLASS_09" /f /v "ClassGUID" /d "{36FC9E60-C465-11CF-8056-444553540000}"
reg.exe add "%CriticalDeviceDatabase%\USB#CLASS_09" /f /v "Service" /d "usbhub"

reg.exe add "%CriticalDeviceDatabase%\USB#ROOT_HUB" /f /v "ClassGUID" /d "{36FC9E60-C465-11CF-8056-444553540000}"
reg.exe add "%CriticalDeviceDatabase%\USB#ROOT_HUB" /f /v "Service" /d "usbhub"

reg.exe add "%CriticalDeviceDatabase%\USB#ROOT_HUB20" /f /v "ClassGUID" /d "{36FC9E60-C465-11CF-8056-444553540000}"
reg.exe add "%CriticalDeviceDatabase%\USB#ROOT_HUB20" /f /v "Service" /d "usbhub"

rem add IDE and ATAPI
reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0101" /f /v "ClassGUID" /d "{4D36E96A-E325-11CE-BFC1-08002BE10318}"
reg.exe add "%CriticalDeviceDatabase%\PCI#CC_0101" /f /v "Service" /d "pciide"
                                                  
reg.exe add "%CriticalDeviceDatabase%\PCI#VEN_8086&CC_0101" /f /v "ClassGUID" /d "{4D36E96A-E325-11CE-BFC1-08002BE10318}"
reg.exe add "%CriticalDeviceDatabase%\PCI#VEN_8086&CC_0101" /f /v "Service" /d "intelide"

reg.exe add "%CriticalDeviceDatabase%\*PNP0600" /f /v "ClassGUID" /d "{4D36E96A-E325-11CE-BFC1-08002BE10318}"
reg.exe add "%CriticalDeviceDatabase%\*PNP0600" /f /v "Service" /d "atapi"
reg.exe add "%CriticalDeviceDatabase%\Primary_IDE_Channel" /f /v "ClassGUID" /d "{4D36E96A-E325-11CE-BFC1-08002BE10318}"
reg.exe add "%CriticalDeviceDatabase%\Primary_IDE_Channel" /f /v "Service" /d "atapi"
reg.exe add "%CriticalDeviceDatabase%\Secondary_IDE_Channel" /f /v "ClassGUID" /d "{4D36E96A-E325-11CE-BFC1-08002BE10318}"
reg.exe add "%CriticalDeviceDatabase%\Secondary_IDE_Channel" /f /v "Service" /d "atapi"
reg.exe add "%CriticalDeviceDatabase%\*azt0502" /f /v "ClassGUID" /d "{4D36E96A-E325-11CE-BFC1-08002BE10318}"
reg.exe add "%CriticalDeviceDatabase%\*azt0502" /f /v "Service" /d "atapi"


set Services=HKLM\loaded_SYSTEM\%ControlSetNNN%\Services

reg.exe add "%Services%\usbohci" /f /v "Group" /d "Boot Bus Extender"
reg.exe add "%Services%\usbohci" /f /t REG_DWORD /v "Tag" /d 3
reg.exe add "%Services%\usbohci" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\usbohci" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\usbohci" /f /t REG_DWORD /v "Type" /d 1

reg.exe add "%Services%\usbuhci" /f /v "Group" /d "Boot Bus Extender"
reg.exe add "%Services%\usbuhci" /f /t REG_DWORD /v "Tag" /d 3
reg.exe add "%Services%\usbuhci" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\usbuhci" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\usbuhci" /f /t REG_DWORD /v "Type" /d 1

reg.exe add "%Services%\usbehci" /f /v "Group" /d "Boot Bus Extender"
reg.exe add "%Services%\usbehci" /f /t REG_DWORD /v "Tag" /d 3
reg.exe add "%Services%\usbehci" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\usbehci" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\usbehci" /f /t REG_DWORD /v "Type" /d 1

reg.exe add "%Services%\usbhub" /f /v "Group" /d "System Bus Extender"
reg.exe add "%Services%\usbhub" /f /t REG_DWORD /v "Tag" /d 2
reg.exe add "%Services%\usbhub" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\usbhub" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\usbhub" /f /t REG_DWORD /v "Type" /d 1

reg.exe add "%Services%\usbstor" /f /v "Group" /d "SCSI miniport"
reg.exe add "%Services%\usbstor" /f /t REG_DWORD /v "Tag" /d 7
reg.exe add "%Services%\usbstor" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\usbstor" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\usbstor" /f /t REG_DWORD /v "Type" /d 1

reg.exe add "HKLM\loaded_SYSTEM\Setup\AllowStart\UsbBootWatcher" /f
reg.exe add "%Services%\UsbBootWatcher" /f /v "ImagePath" /d "UsbBootWatcher.exe"
reg.exe add "%Services%\UsbBootWatcher" /f /v "ObjectName" /d "LocalSystem"
reg.exe add "%Services%\UsbBootWatcher" /f /v "DisplayName" /d "Usb Boot Watcher Service"
reg.exe add "%Services%\UsbBootWatcher" /f /t REG_DWORD /v "ErrorControl" /d 0
reg.exe add "%Services%\UsbBootWatcher" /f /t REG_DWORD /v "Start" /d 2
reg.exe add "%Services%\UsbBootWatcher" /f /t REG_DWORD /v "Type" /d 0x10


rem add IDE and ATAPI
reg.exe add "%Services%\PCIIde" /f /v "Group" /d "System Bus Extender"
reg.exe add "%Services%\PCIIde" /f /t REG_DWORD /v "Tag" /d 3
reg.exe add "%Services%\PCIIde" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\PCIIde" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\PCIIde" /f /t REG_DWORD /v "Type" /d 1

reg.exe add "%Services%\IntelIde" /f /v "Group" /d "System Bus Extender"
reg.exe add "%Services%\IntelIde" /f /t REG_DWORD /v "Tag" /d 4
reg.exe add "%Services%\IntelIde" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\IntelIde" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\IntelIde" /f /t REG_DWORD /v "Type" /d 1

reg.exe add "%Services%\atapi" /f /v "Group" /d "SCSI miniport"
reg.exe add "%Services%\atapi" /f /t REG_DWORD /v "Tag" /d 0x19
reg.exe add "%Services%\atapi" /f /t REG_DWORD /v "ErrorControl" /d 1
reg.exe add "%Services%\atapi" /f /t REG_DWORD /v "Start" /d 0
reg.exe add "%Services%\atapi" /f /t REG_DWORD /v "Type" /d 1

rem internal debug
for %%i in (*.reg) do reg.exe import "%%i"

reg.exe unload HKLM\loaded_SYSTEM
goto :eof

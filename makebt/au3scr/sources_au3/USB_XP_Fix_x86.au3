#RequireAdmin
#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.14.5 + file SciTEUser.properties in your UserProfile e.g. C:\Documents and Settings\UserXP Or C:\Users\User-10

 Author:        WIMB  -  April 11, 2019

 Program:       USB_XP_Fix_x86.exe - Version 8.7 in rule 224
	part of IMG_XP Package and used to Update XP VHD Image file with tweaks and UsbBootWatcher for booting from USB

 Script Function:

 Credits and Thanks to:
	JFX for making WinNTSetup3 to Install Windows 2k/XP/2003/Vista/7/8 x86/x64 - http://www.msfn.org/board/topic/149612-winntsetup-v30/
	chenall, tinybit and Bean for making Grub4dos - http://code.google.com/p/grub4dos-chenall/downloads/list
	karyonix for making FiraDisk driver- http://reboot.pro/topic/8804-firadisk-latest-00130/
	Sha0 for making WinVBlock driver - http://reboot.pro/topic/8168-winvblock/
	Olof Lagerkvist for ImDisk virtual disk driver - http://www.ltr-data.se/opencode.html#ImDisk and http://reboot.pro/index.php?showforum=59
	Uwe Sieber for making ListUsbDrives - http://www.uwe-sieber.de/english.html
	Dariusz Stanislawek for the DS File Ops Kit (DSFOK) - http://members.ozemail.com.au/~nulifetv/freezip/freeware/
	cdob and maanu to Fix Win7 for booting from USB - http://reboot.pro/topic/14186-usb-hdd-boot-and-windows-7-sp1/
	marv for making UsbBootWatcher - https://github.com/vavrecan/usb-boot-watcher and http://www.911cd.net/forums//index.php?showtopic=22473
	usb_xp_init.cmd of cdob http://www.911cd.net/forums//index.php?showtopic=22473&st=37

	More Info on booting Win 7 VHD from grub4dos menu by using FiraDisk Or WinVBlock driver:
	http://reboot.pro/topic/9830-universal-hdd-image-files-for-xp-and-windows-7/ Or http://www.911cd.net/forums//index.php?showtopic=23553

	The program is released "as is" and is free for redistribution, use or changes as long as original author,
	credits part and link to the reboot.pro and 911cd support forum are clearly mentioned
	http://reboot.pro/topic/9830-universal-hdd-image-files-for-xp-and-windows-7/ and http://www.911cd.net/forums//index.php?showtopic=23553

	Author does not take any responsibility for use or misuse of the program.

#ce ----------------------------------------------------------------------------

#include <guiconstants.au3>
#include <ProgressConstants.au3>
#include <GuiConstantsEx.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#Include <GuiStatusBar.au3>
#include <Array.au3>
#Include <String.au3>
#include <Process.au3>
#include <Date.au3>
#include <Constants.au3>

Opt('MustDeclareVars', 1)
Opt("GuiOnEventMode", 1)
Opt("TrayIconHide", 1)

; Setting variables
Global $ProgressAll, $Paused, $btimgfile="", $hStatus, $tmpdrive = "", $DP_M_found = 1, $DP_CU_found = 1
Global $hGuiParent, $GO, $EXIT, $image_file="", $img_fname="", $img_fext="", $RegSoftAdd, $RegSysAdd, $RegAMDAHCI, $RegIASTOR, $minlogon
Global $BTIMGSize=0, $IMG_File, $IMG_FileSelect, $ImageType, $ImageSize, $WinFol="\WINDOWS"

Global $SourceDir, $Source, $HalKernAdd, $WinSource="", $AMD64=0, $PostFixAdd, $UsbFixAdd, $waitbtAdd, $Boot_Menu, $grldrUpd, $Scsi_Menu, $ForceUpdate, $usb3_Menu
Global $TargetDrive="", $g4d_vista=0, $mk_bcd=0, $ntfs_bs=1, $bs_valid=0, $needxp=0, $g4d=0
Global $TargetSpaceAvail=0, $TargetSize, $TargetFree, $DriveType="Fixed", $usbfix=0
Global $TargetSel, $Target, $EWFAdd, $PArch=@OSArch, $ComStartMenu="\Documents and Settings\All Users\Start Menu"

Global $WinDrv, $WinDrvSel, $WinDrvSize, $WinDrvFree, $WinDrvFileSys, $WinDrvSpaceAvail=0, $WinDrvDrive=""

Global $NTLDR_BS=1, $bcdedit="", $IMG_Path = "", $inst_valid=1, $driver_flag=1

Global $expand = "expand.exe", $XP_Arch = "I386", $driver_cab = "\driver.cab"

Global $drv_file = "", $driver_files[16] = ["atapi.sys", "aliide.sys", "cmdide.sys", "intelide.sys", "pciide.sys",  "pciidex.sys", "toside.sys", "viaide.sys", _
"usbehci.sys", "usbohci.sys", "usbuhci.sys", "usbport.sys", "usbhub.sys", "usbd.sys", "usbccgp.sys", "usbstor.sys"]

Global $sys32_files[3] = ["storprop.dll", "usbui.dll", "hccoin.dll"]

Global $msst[138] = ["3waregsm", "3wdrv100", "3waredrv", "aec6210", "aec6260", "aec6280", "aec67160", "aec671x", "aec6880", "aec6897", _
"aec68x5", "a320raid", "cda1000", "aacad2", "aar1210", "aar81xx", "aarahci", "adp3132", "adpu160m", "adpu320", _
"ash1205", "adpu3202", "dpti2o", "aac", "aacsas", "ahcix86", "amdbusdr", "amdide", "atiide", "ahcix862", _
"ahcix863", "ahcix864", "arcm_x86", "asahxp32", "aliide", "m5228", "m5281", "m5287", "m5288", "m5289", _
"cpq32fs2", "cpqarry2", "cpqcissm", "hpcissm2", "cercsr6", "perc2", "2310_00", "272x_1x", "274x_3x", "hpt374", _
"hpt3xx", "hptiop", "hptmv6", "rr172x", "rr174x", "rr232x", "rr2340", "rr2644", "rr2680", "rr26xx", _
"rr276x2", "rr62x", "rr64x", "hptmv2", "iastor", "raidsrc", "iastor2", "iastor3", "iastor4", "iastor5", _
"adp94xx", "ipsraidn", "nfrd960", "inic162x", "iteatapi", "iteraid", "iteatap2", "jraid", "dac2w2k", "dac960nt", _
"megaide", "megaintl", "megasas", "megasr", "sas2xp86", "symmpi", "symmpi2", "mv614x", "mv61xx", "mv91xx", _
"mvsata", "mv64xx", "nvgts", "nvgts2", "nvgts3", "nvgts4", "nvrd32", "fastsx", "fttxr52p", "fasttx2k", _
"ide376xp", "sptrak", "ultra", "fasttrak", "fasttx22", "s150sx8", "ulsata", "ulsata2", "fasttx23", "fttxr5_o", _
"fttxr54p", "ql12160", "ql2100", "ql2200", "pnp649r", "si3114r5", "pnp680r", "pnp680", "si3531", "si3112", _
"si3112r", "si3114r", "si3114", "si3124", "si3124r", "3124r5a", "3124r5a2", "si3132b2", "si31322", "si3132r5", _
"siside", "sisraid2", "sisraid4", "kr10n", "viamraid", "viapdsk", "videx32", "vmscsi"]

; MSST output modified - use nvrd32 of N8 instead of nvrd322

; Eclude by using X
Global $M_sub[138] = ["3", "3", "3", "A", "A", "A", "A", "A", "A", "A", _
"A", "AD", "AD", "AD", "AD", "AD", "AD", "AD", "AD", "AD", _
"AD", "AD", "AD", "ADB", "ADB", "AM8", "AM", "AM", "AM", "X", _
"X", "X", "AR", "AS", "AU", "AU", "AU", "AU", "AU", "AU", _
"C", "C", "C", "C", "D", "D", "H", "H", "H", "H", _
"H", "H", "H", "H", "H", "H", "H", "H", "H", "H", _
"H", "H", "H", "X", "I7", "I", "X", "X", "X", "X", _
"IB", "IB", "IB3", "IN", "IT", "IT", "IT2", "J", "L", "L", _
"L", "L", "L", "L", "L", "L", "L", "M", "M", "M", _
"M", "M4", "N8", "X", "X", "X", "N8", "P", "P", "P2", _
"P", "P", "P", "P1", "X", "P3", "P6", "P7", "X", "PC", _
"PD", "Q", "Q", "Q", "S", "S0", "S1", "S2", "S3", "S4", _
"S5", "S6", "S7", "S8", "S9", "SA", "SA2", "SB2", "SB5", "SC", _
"SS", "SS", "SS2", "T", "V", "V", "V", "V"]

; Global $str = "", $bt_files[4] = ["\makebt\dsfo.exe", "\makebt\grldr.mbr", "\makebt\grldr", "\makebt\menu.lst"]
Global $str = "", $bt_files[23] = ["\makebt\dsfo.exe", "\makebt\BootSect.exe", "\makebt\PS.exe", "\makebt\minlogon.exe", _
"\makebt\listusbdrives\ListUsbDrives.exe", "\makebt\UsbBootWatcher\x86\UsbBootWatcher.exe", "\makebt\UsbBootWatcher\x86\UsbBootWatcher.conf", _
"\makebt\UsbBootWatcher\amd64\UsbBootWatcher.exe", "\makebt\UsbBootWatcher\amd64\UsbBootWatcher.conf", _
"\makebt\waitbt\amd64\waitbt.sys", "\makebt\waitbt\x86\waitbt.sys", _
"\makebt\registry_tweaks\HKLM_systemdst_BOOT_HDD.reg", "\makebt\registry_tweaks\HKLM_systemdst_USB_XP.reg", _
"\makebt\registry_tweaks\HKLM_systemdst_iaStor.reg", "\makebt\registry_tweaks\HKLM_softwaredst_Add.reg", _
"\makebt\registry_tweaks\HKLM_systemdst_AMD_AHCIx64.reg", "\makebt\registry_tweaks\HKLM_systemdst_AMD_AHCIx86.reg", _
"\makebt\registry_tweaks\HKLM_systemdst_Add_XP.reg", "\makebt\registry_tweaks\HKLM_systemdst_waitbt.reg", _
"\makebt\registry_tweaks\HKLM_defaultdst_minixp.reg", "\makebt\registry_tweaks\HKLM_softwaredst_minixp.reg", _
"\makebt\registry_tweaks\HKLM_softwaredst_DevicePath_KTD.reg", "\makebt\registry_tweaks\HKLM_systemdst_KTD_SystemRoot_DP.reg"]

; USB3 boot support
Global $usb3[16] = ["amdhub30", "amdxhc", "asmthub3", "asmtxhci", "EtronHUB3", "EtronXHCI", "FLxHCIh", "FLxHCIc", _
"nusb3hub", "nusb3xhc", "rusb3hub", "rusb3xhc", "tihub3", "tixhci", "ViaHub3", "xhcdrv"]

Global $CU_sub[16] = ["A", "A", "AS", "AS", "E", "E", "FR", "FR", _
"RE", "RE", "RE", "RE", "T", "T", "V", "V"]

If @OSArch <> "X86" Then
   MsgBox(48, "ERROR - Environment", "In x64 environment use VHD_XP_Create_x64.exe ")
   Exit
EndIf

For $str In $bt_files
	If Not FileExists(@ScriptDir & $str) Then
		MsgBox(48, "ERROR - Missing File", "File " & $str & " NOT Found ")
		Exit
	EndIf
Next

If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")

; dmadmin in x64 found by using @WindowsDir & "\system32\dmadmin.exe" instead of @SystemDir
; Thanks to Lancelot and blue_life for solving x64 issue
; Wow64 must be Disabled to find dmadmin in x64 OS and Then again Enabled since otherwise it will effect DirRemove and DirCreate following in the program
; If @OSArch = "X64" Then DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
; find dmadmin in x64 OS (File dmadmin.exe is used to get MBR-code necessary in _FormatUSB Function)
; If @OSArch = "X64" Then DllCall("kernel32.dll", "int", "Wow64EnableWow64FsRedirection", "int", 1)
; Instead we can use Function SystemFileRedirect given by Lancelot and blue_life for x64 Support

SystemFileRedirect("On")
If Not FileExists(@ScriptDir & "\makebt\dmadmin.exe") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
	If FileExists(@WindowsDir & "\system32\dmadmin.exe") Then
		FileCopy(@WindowsDir & "\system32\dmadmin.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf
If Not FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
	If FileExists(@WindowsDir & "\system32\bcdedit.exe") And @OSArch = "X86" Then
		FileCopy(@WindowsDir & "\system32\bcdedit.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf
If Not FileExists(@ScriptDir & "\makebt\expand.exe") Then
	If FileExists(@WindowsDir & "\system32\expand.exe") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
		FileCopy(@WindowsDir & "\system32\expand.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf
If Not FileExists(@ScriptDir & "\makebt\fsutil.exe") Then
	If FileExists(@WindowsDir & "\system32\fsutil.exe") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
		FileCopy(@WindowsDir & "\system32\fsutil.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf
If Not FileExists(@ScriptDir & "\makebt\xcopy.exe") Then
	If FileExists(@WindowsDir & "\system32\xcopy.exe") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
		FileCopy(@WindowsDir & "\system32\xcopy.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf
If Not FileExists(@WindowsDir & "\system32\imdisk.exe") Then
	SystemFileRedirect("Off")
	MsgBox(48, "WARNING - Manual Install ImDisk Driver ", "ImDisk Driver needed for Virtual Drive  " _
	& @CRLF & @CRLF & " First Install ImDisk using makebt\imdiskinst.exe ")
	Exit
EndIf

If FileExists(@WindowsDir & "\system32\expand.exe") Then
	$expand = "expand.exe"
ElseIf FileExists(@ScriptDir & "\makebt\expand.exe") Then
	$expand = "makebt\expand.exe"
Else
	MsgBox(48, "WARNING - system32\expand.exe Missing ", "system32\expand.exe needed to expand cab files " _
	& @CRLF & @CRLF & " Use Add Hal and Select XP Setup Source ")
	; Exit
EndIf

SystemFileRedirect("Off")

; Get XP BootFiles
If FileExists(@HomeDrive & "\BOOTFONT.BIN") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
	IF Not FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then
		FileCopy(@HomeDrive & "\BOOTFONT.BIN", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", "-RSH")
	EndIf
EndIf
If FileExists(@HomeDrive & "\NTDETECT.COM") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
	If Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") Then
		FileCopy(@HomeDrive & "\NTDETECT.COM", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", "-RSH")
	EndIf
EndIf
If FileExists(@HomeDrive & "\NTLDR") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
	If Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then
		FileCopy(@HomeDrive & "\NTLDR", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTLDR", "-RSH")
	EndIf
EndIf

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "TogglePause")

; Creating GUI and controls
$hGuiParent = GUICreate(" USB_XP_Fix - for XP VHD File Or USB Drive ", 400, 430, 100, _
		40, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")

GUICtrlCreateGroup("Target   - x86 Version 8.7 ", 18, 10, 364, 67)

$ImageType = GUICtrlCreateLabel( "", 270, 29, 110, 15, $ES_READONLY)
$ImageSize = GUICtrlCreateLabel( "", 210, 29, 50, 15, $ES_READONLY)

GUICtrlCreateLabel( "Select Windows XP VHD File ", 32, 29)
$IMG_File = GUICtrlCreateInput($IMG_FileSelect, 32, 45, 303, 20, $ES_READONLY)
$IMG_FileSelect = GUICtrlCreateButton("...", 341, 46, 26, 18)
GUICtrlSetTip(-1, " Select Windows XP VHD Image File on USB-drive " & @CRLF _
& " to be mounted in Virtual drive for Update of Registry ")

GUICtrlSetOnEvent($IMG_FileSelect, "_img_fsel")

GUICtrlCreateGroup(" Make Universal Image - Option use XP Setup Source to Add Hal Files ", 18, 87, 364, 193)

$PostFixAdd = GUICtrlCreateCheckbox("", 32, 107, 17, 17)
GUICtrlSetTip($PostFixAdd, " Add POST_FIX_XP  Folder with useful Tools and " & @CRLF _
& " Tweaks Command Here + intelppm_Start3 ")
GUICtrlCreateLabel( "Add POST_FIX  Folder", 56, 107)

$UsbFixAdd = GUICtrlCreateCheckbox("", 32, 130, 17, 17)
GUICtrlSetTip($UsbFixAdd, " Add UsbBootWatcher to protect and  " & @CRLF _
& " Add USB Tweaks for Booting from USB " & @CRLF _
& " USB Services are made Boot Bus Extender with Start = 0 ")
GUICtrlCreateLabel( "Add UsbBootWatcher Tweaks", 56, 130)

$waitbtAdd = GUICtrlCreateCheckbox("", 240, 130, 17, 17)
GUICtrlSetTip($waitbtAdd, " Add waitbt Service to prevent BSOD 7B  " & @CRLF _
& " waitbt improves timing for Booting from USB " & @CRLF _
& " needed in case of WinVBlock FileDisk ")
GUICtrlCreateLabel( "Add waitbt for USB", 264, 130)

$minlogon = GUICtrlCreateCheckbox("", 240, 155, 17, 17)
GUICtrlSetTip($minlogon, " Use minlogon and Create Default User Account ")
GUICtrlCreateLabel( "Use minlogon", 264, 155)

$Source = GUICtrlCreateInput($SourceDir, 132, 178, 203, 20, $ES_READONLY)
$SourceDir = GUICtrlCreateButton("...", 341, 179, 26, 18)
GUICtrlSetTip($SourceDir, " Select your XP Setup Source Folder containing I386 folder " & @CRLF _
& " Needed to get Hal and NT Kernel Files for making XP Universal ")
GUICtrlSetOnEvent($SourceDir, "_xp_selfol")

$EWFAdd = GUICtrlCreateCheckbox("", 32, 155, 17, 17)
GUICtrlSetTip(-1, " Add EWF - Enhanced Write Filter Manager " & @CRLF _
& " Protects for Unwanted Changes in Image File ")
GUICtrlCreateLabel( "Add EWF Write Filter ", 56, 155)

$HalKernAdd = GUICtrlCreateCheckbox("", 32, 180, 17, 17)
GUICtrlSetTip(-1, " Add Hal and NT Kernel Files for making XP Universal " & @CRLF _
& " Make Multiple boot.ini Menu Options useful for old Computers ")
GUICtrlCreateLabel( "Add Hal from  ", 56, 180, 75, 15)

;	$RegSysAdd = GUICtrlCreateCheckbox("", 32, 205, 17, 17)
;	GUICtrlSetTip(-1, " Extra Tweaks for HKLM System Registry " & @CRLF _
;	& " Set intelppm Service Manual - Start = 3 - Required for AMD64 ")
;	GUICtrlCreateLabel( "Add HKLM System Registry ", 56, 205)

$RegSysAdd = GUICtrlCreateCheckbox("", 32, 205, 17, 17)
GUICtrlSetTip(-1, " Add Drivers from makebt\drivers\XP_x86 " & @CRLF _
& " Useful to Update MassStorage Boot Drivers ")
GUICtrlCreateLabel( "Extra Drivers ", 56, 205)

$RegAMDAHCI = GUICtrlCreateCheckbox("", 32, 230, 17, 17)
GUICtrlSetTip(-1, " Add AMD AHCI Driver and Registry Tweaks " & @CRLF _
& " AHCI Driver is needed on AMD systems with AHCI BIOS Setting " & @CRLF _
& " Add Driver and CriticalDeviceDatabase Registry Values ")
GUICtrlCreateLabel( "Add AMD AHCI", 56, 230)

$usb3_Menu = GUICtrlCreateCheckbox("", 150, 230, 17, 17)
GUICtrlSetTip(-1, " Add USB 3.0 Drivers from Windows\DriverPacks\C\U " & @CRLF _
& " Add Service and CriticalDeviceDatabase Registry Values " & @CRLF _
& " About 6 MB for 16 extra Drivers to boot from USB 3.0 ")
GUICtrlCreateLabel( "USB 3", 174, 230)

$RegIASTOR = GUICtrlCreateCheckbox("", 32, 255, 17, 17)
GUICtrlSetTip(-1, " Add iaStor Driver and AHCI Registry Tweaks " & @CRLF _
& " Adding iaStor Driver can prevent BSOD 7B in booting from USB " & @CRLF _
& " Adding iaStor Driver is needed on systems with AHCI BIOS Setting " & @CRLF _
& " Add Drivers and CriticalDeviceDatabase Registry Values ")
GUICtrlCreateLabel( "Add iaStor ", 56, 255)

;	$RegSoftAdd = GUICtrlCreateCheckbox("", 32, 255, 17, 17)
;	GUICtrlSetTip(-1, " Silent Install of New Hardware - Disable New Hardware Wizard " & @CRLF _
;	& " Disable SystemRestore - Set Windows Update - Notify Only ")
;	GUICtrlCreateLabel( "Add HKLM Software Tweaks ", 56, 255)

$grldrUpd = GUICtrlCreateCheckbox("", 224, 205, 17, 17)
GUICtrlSetTip($grldrUpd, " Update Grub4dos grldr and grldr.mbr on Target Boot Drive " & @CRLF _
& " Force to Create Grub4dos entry in Boot Manager Menu ")
GUICtrlCreateLabel( "Update Grub4dos grldr", 248, 205)

$Boot_Menu = GUICtrlCreateCheckbox("", 224, 230, 17, 17)
GUICtrlSetTip(-1, " Make Grub4dos Menu on Boot Drive " & @CRLF _
& " for XP VHD Image file on Target System Drive ")
GUICtrlCreateLabel( "Make Grub4dos Menu ", 248, 230)

$ForceUpdate = GUICtrlCreateCheckbox("", 150, 255, 17, 17)
GUICtrlSetTip(-1, " Force Update for MassStorage Drivers ")
GUICtrlCreateLabel( "Force", 174, 255)

$Scsi_Menu = GUICtrlCreateCheckbox("", 224, 255, 17, 17)
GUICtrlSetTip(-1, " Add MassStorage Drivers from Windows\DriverPacks\M " & @CRLF _
& " Add Service and CriticalDeviceDatabase Registry Values " & @CRLF _
& " About 17 MB for 130 extra Drivers to boot any hardware ")
GUICtrlCreateLabel( "MassStorage Drivers", 248, 255)

GUICtrlCreateGroup("USB Target System Drive ", 18, 290, 245, 54)

; Target is Drive with VHD or Installed Windows System
$WinDrv = GUICtrlCreateInput("", 32, 312, 75, 20, $ES_READONLY)
$WinDrvSel = GUICtrlCreateButton("...", 113, 313, 26, 18)
GUICtrlSetTip(-1, " Select USB Target System Drive for Fixing XP ")
GUICtrlSetOnEvent($WinDrvSel, "_WinDrv_drive")
$WinDrvSize = GUICtrlCreateLabel( "", 155, 306, 100, 15, $ES_READONLY)
$WinDrvFree = GUICtrlCreateLabel( "", 155, 323, 100, 15, $ES_READONLY)

GUICtrlCreateGroup("Boot Drive ", 275, 290, 107, 54)

; Target is Boot Drive
$Target = GUICtrlCreateInput("", 289, 312, 35, 20, $ES_READONLY)
$TargetSel = GUICtrlCreateButton("...", 330, 313, 26, 18)
GUICtrlSetTip(-1, " Select USB Boot Drive to Make Grub4dos Menu " & @CRLF _
& " for XP VHD Image file on Target System Drive ")
GUICtrlSetOnEvent($TargetSel, "_target_drive")
;	$TargetSize = GUICtrlCreateLabel( "", 305, 306, 70, 15, $ES_READONLY)
;	$TargetFree = GUICtrlCreateLabel( "", 305, 323, 70, 15, $ES_READONLY)

;	GUICtrlCreateGroup("Image Type", 295, 290, 87, 54)
;	$ImageType = GUICtrlCreateLabel( "", 305, 306, 70, 15, $ES_READONLY)
;	$ImageSize = GUICtrlCreateLabel( "", 305, 323, 70, 15, $ES_READONLY)

$GO = GUICtrlCreateButton("GO", 235, 360, 70, 30)
GUICtrlSetTip($GO, " Fix XP USB Drive Or XP VHD Image File to Boot from USB " & @CRLF _
& " Add Drivers and CriticalDeviceDatabase Registry Tweaks " & @CRLF _
& " and Make Grub4dos Boot Menu for XP VHD Image File ")
$EXIT = GUICtrlCreateButton("EXIT", 320, 360, 60, 30)
GUICtrlSetState($GO, $GUI_DISABLE)
GUICtrlSetOnEvent($GO, "_Go")
GUICtrlSetOnEvent($EXIT, "_Quit")

$ProgressAll = GUICtrlCreateProgress(16, 368, 203, 16, $PBS_SMOOTH)

$hStatus = _GUICtrlStatusBar_Create($hGuiParent, -1, "", $SBARS_TOOLTIPS)
Global $aParts[3] = [310, 350, -1]
_GUICtrlStatusBar_SetParts($hStatus, $aParts)

_GUICtrlStatusBar_SetText($hStatus," Select XP VHD Image File Or USB Target System Drive", 0)

DisableMenus(1)

GUICtrlSetState($IMG_FileSelect, $GUI_ENABLE)
GUICtrlSetState($TargetSel, $GUI_ENABLE)
GUICtrlSetState($WinDrvSel, $GUI_ENABLE)

GUICtrlSetState($SourceDir, $GUI_DISABLE)

If FileExists(@ScriptDir & "\makebt\halkern\halstan.dll") And FileExists(@ScriptDir & "\makebt\halkern\ntkrup.exe") Then
	GUICtrlSetState($HalKernAdd, $GUI_ENABLE)
Else
	GUICtrlSetState($HalKernAdd, $GUI_DISABLE)
EndIf
GUICtrlSetState($UsbFixAdd, $GUI_ENABLE + $GUI_CHECKED)
GUICtrlSetState($PostFixAdd, $GUI_ENABLE + $GUI_CHECKED)
GUICtrlSetState($EWFAdd, $GUI_ENABLE)

GUICtrlSetState($RegSysAdd, $GUI_ENABLE + $GUI_UNCHECKED)
GUICtrlSetState($RegAMDAHCI, $GUI_ENABLE + $GUI_CHECKED)
GUICtrlSetState($RegIASTOR, $GUI_ENABLE + $GUI_CHECKED)
; GUICtrlSetState($RegSoftAdd, $GUI_DISABLE + $GUI_CHECKED)

GUICtrlSetState($waitbtAdd, $GUI_ENABLE + $GUI_CHECKED)
GUICtrlSetState($minlogon, $GUI_ENABLE + $GUI_CHECKED)

GUICtrlSetState($grldrUpd, $GUI_DISABLE + $GUI_UNCHECKED)
GUICtrlSetState($Boot_Menu, $GUI_DISABLE + $GUI_UNCHECKED)
GUICtrlSetState($ForceUpdate, $GUI_ENABLE)
GUICtrlSetState($Scsi_Menu, $GUI_ENABLE + $GUI_CHECKED)
GUICtrlSetState($usb3_Menu, $GUI_ENABLE + $GUI_CHECKED)

GUISetState(@SW_SHOW)

;===================================================================================================
While 1
	CheckGo()
    Sleep(300)
WEnd   ;==> Loop
;===================================================================================================
Func CheckGo()
	If $btimgfile <> "" Or $WinDrvDrive  <> "" Then
		GUICtrlSetState($GO, $GUI_ENABLE)
		_GUICtrlStatusBar_SetText($hStatus," Use GO to Fix XP for booting from USB ", 0)
	Else
		If GUICtrlRead($GO) = $GUI_ENABLE Then
			GUICtrlSetState($GO, $GUI_DISABLE)
			_GUICtrlStatusBar_SetText($hStatus," Select XP VHD Image File Or USB Target System Drive", 0)
		EndIf
	EndIf
EndFunc ;==> _CheckGo
;===================================================================================================
Func _Quit()
	Local $ikey
	DisableMenus(1)
    If @GUI_WinHandle = $hGuiParent Then
		$ikey = MsgBox(48+4+256, " STOP Program ", " STOP Program ? ")
		If $ikey = 6 Then
			Exit
		Else
		DisableMenus(0)
			Return
		EndIf
    Else
        GUIDelete(@GUI_WinHandle)
    EndIf
	DisableMenus(0)
EndFunc   ;==> _Quit
;===================================================================================================
Func SystemFileRedirect($Wow64Number) ; Function given by Lancelot and blue_life for support of x64 Windows
	If @OSArch = "X64" Then
		Local $WOW64_CHECK = DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "ptr*", 0)
		If Not @error Then
			If $Wow64Number = "On" And $WOW64_CHECK[1] <> 1 Then
				DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
			ElseIf $Wow64Number = "Off" And $WOW64_CHECK[1] <> 0 Then
				DllCall("kernel32.dll", "int", "Wow64EnableWow64FsRedirection", "int", 1)
			EndIf
		EndIf
	EndIf
EndFunc   ;==> SystemFileRedirect
;===================================================================================================
Func _img_fsel()
	Local $len, $pos, $valid=0, $noxpmbr = 0, $pos1=0, $pos2=0, $tempfsel=""
	Local $Tdrive, $FSvar, $valid = 0, $ValidDrives, $RemDrives
	Local $NoDrive[2] = ["A:", "B:"], $FileSys[3] = ["NTFS", "FAT32", "FAT"]

	DisableMenus(1)
	GUICtrlSetData($ImageType, "")
	GUICtrlSetData($ImageSize, "")
	GUICtrlSetData($IMG_File, "")
	$btimgfile = ""
	$image_file = ""
	$img_fname = ""
	$img_fext = ""

	$IMG_Path = ""
	$WinDrvDrive = ""
	GUICtrlSetData($WinDrv, "")
	GUICtrlSetData($WinDrvSize, "")
	GUICtrlSetData($WinDrvFree, "")
	GUICtrlSetState($grldrUpd, $GUI_DISABLE + $GUI_UNCHECKED)
	GUICtrlSetState($Boot_Menu, $GUI_DISABLE + $GUI_UNCHECKED)

	$ValidDrives = DriveGetDrive( "FIXED" )
	_ArrayPush($ValidDrives, "")
	_ArrayPop($ValidDrives)
	$RemDrives = DriveGetDrive( "REMOVABLE" )
	_ArrayPush($RemDrives, "")
	_ArrayPop($RemDrives)
	_ArrayConcatenate($ValidDrives, $RemDrives)
	; _ArrayDisplay($ValidDrives)

	IF FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")

	$tempfsel = FileOpenDialog("Select Windows XP VHD Image File", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "VHD or HDD Image Files ( *.img; *.vhd; )")
	If @error Then
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($tempfsel, "\", 0, -1)
	If $pos = 0 Then
		MsgBox(48,"ERROR - Path Invalid", "Path Invalid - No Backslash Found" & @CRLF & @CRLF & "Selected Path = " & $tempfsel)
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($tempfsel, " ", 0, -1)
	If $pos Then
		MsgBox(48,"ERROR - Path Invalid", "Path Invalid - Space Found" & @CRLF & @CRLF & "Selected Path = " & $tempfsel & @CRLF & @CRLF _
		& "Solution - Use simple Path without Spaces ")
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($tempfsel, ":", 0, 1)
	If $pos <> 2 Then
		MsgBox(48,"ERROR - Path Invalid", "Drive Invalid - : Not found" & @CRLF & @CRLF & "Selected Path = " & $tempfsel)
		DisableMenus(0)
		Return
	EndIf

	$len = StringLen($tempfsel)
	$pos = StringInStr($tempfsel, "\", 0, -1)
	If StringLen(StringLeft($tempfsel, $pos-1)) > 11 Then
		MsgBox(48,"ERROR - Path Invalid", "Folder Name  Max = 8 chars  is allowed in Target" & @CRLF & @CRLF & "Selected = " & $tempfsel)
		DisableMenus(0)
		Return
	EndIf

	$Tdrive = StringLeft($tempfsel, 2)
	FOR $d IN $ValidDrives
		If $d = $Tdrive Then
			$valid = 1
			ExitLoop
		EndIf
	NEXT
	FOR $d IN $NoDrive
		If $d = $Tdrive Then
			$valid = 0
			MsgBox(48, "ERROR - Drive NOT Valid", " Drive A: B: ", 3)
			DisableMenus(0)
			Return
		EndIf
	NEXT
	If $valid And DriveStatus($Tdrive) <> "READY" Then
		$valid = 0
		MsgBox(48, "ERROR - Drive NOT Ready", "Drive NOT READY", 3)
		DisableMenus(0)
		Return
	EndIf
	If $valid Then
		$FSvar = DriveGetFileSystem( $Tdrive )
		FOR $d IN $FileSys
			If $d = $FSvar Then
				$valid = 1
				ExitLoop
			Else
				$valid = 0
			EndIf
		NEXT
		IF Not $valid Then
			MsgBox(48, "ERROR - Invalid FileSystem", " NTFS - FAT32 or FAT FileSystem NOT Found ", 3)
			DisableMenus(0)
			Return
		EndIf
	EndIf

	$btimgfile = $tempfsel
	$BTIMGSize = FileGetSize($btimgfile)
	$BTIMGSize = Round($BTIMGSize / 1024 / 1024)

	RunWait(@ComSpec & " /c makebt\dsfo.exe " & '"' & $btimgfile & '"' & " 0 512 makebt\bs_temp\img_xp.mbr", @ScriptDir, @SW_HIDE)
	$pos1 = HexSearch(@ScriptDir & "\makebt\bs_temp\img_xp.mbr", "NTFS", 16, 0)
	$pos2 = HexSearch(@ScriptDir & "\makebt\bs_temp\img_xp.mbr", "FAT", 16, 0)
	If $pos1 Or $pos2 Then
		MsgBox(48, " WARNING - SuperFloppy Image - MBR is missing ", "Selected = " & $btimgfile & @CRLF & @CRLF _
			& "Image Size = " & $BTIMGSize & " MB " & @CRLF & @CRLF _
			& "SuperFloppy Image - NTFS or FAT in BootSector Found ", 0)
			$valid = 0
	Else
		; Vista MBR and NTFS Bootsector contain 33C08ED0BC007C
		; $noxpmbr = HexSearch(@ScriptDir & "\makebt\bs_temp\img_xp.mbr", "33C08ED0BC007CFB50", 16, 1)
		$noxpmbr = HexSearch(@ScriptDir & "\makebt\bs_temp\img_xp.mbr", "33C08ED0BC007C", 16, 1)
		; MsgBox(48, "INFO - Search MBR BootCode", "MBR BootCode at pos = " & $noxpmbr, 0)
		If $noxpmbr <> 1 Then
			MsgBox(48, " WARNING - XP MBR BootCode NOT Found ", "Selected = " & $btimgfile & @CRLF & @CRLF _
				& "Image Size = " & $BTIMGSize & " MB " & @CRLF & @CRLF _
				& "XP MBR BootCode NOT Found ", 0)
			$valid = 0
		EndIf
	EndIf

	If $valid Then
		$len = StringLen($btimgfile)
		$pos = StringInStr($btimgfile, "\", 0, -1)
		$IMG_Path = StringLeft($btimgfile, $pos-1)
		$image_file = StringRight($btimgfile, $len-$pos)
		$len = StringLen($image_file)
		$pos = StringInStr($image_file, ".", 0, -1)
		$img_fname = StringLeft($image_file, $pos-1)
		$img_fext = StringRight($image_file, $len-$pos)
		GUICtrlSetData($IMG_File, $btimgfile)
		GUICtrlSetData($ImageSize, Round($BTIMGSize / 1024, 1) & " GB")
		GUICtrlSetData($ImageType, "VHD - IMG")

		$WinDrvDrive = $Tdrive
		; $WinDrvDrive = StringLeft($IMG_Path, 2)

		If StringLen($IMG_Path) < 12 Then
			If StringLen($IMG_Path) = 3 Then
				$IMG_Path = $WinDrvDrive
			Else
				$pos = StringInStr(StringMid($IMG_Path, 4), "\", 0, -1)
				If $pos <> 0 Then
					$IMG_Path = $WinDrvDrive
				EndIf
			EndIf
		Else
			$IMG_Path = $WinDrvDrive
		EndIf
		GUICtrlSetData($WinDrv, $IMG_Path)
		$WinDrvSpaceAvail = Round(DriveSpaceFree($WinDrvDrive))
		GUICtrlSetData($WinDrvSize, $FSvar & "     " & Round(DriveSpaceTotal($WinDrvDrive) / 1024, 1) & " GB")
		GUICtrlSetData($WinDrvFree, "FREE  = " & Round(DriveSpaceFree($WinDrvDrive) / 1024, 1) & " GB")
		If $TargetDrive <> "" Then
			GUICtrlSetState($grldrUpd, $GUI_ENABLE + $GUI_UNCHECKED)
			GUICtrlSetState($Boot_Menu, $GUI_ENABLE + $GUI_CHECKED)
		EndIf
	Else
		GUICtrlSetData($ImageType, "")
		GUICtrlSetData($ImageSize, "")
		GUICtrlSetData($IMG_File, "")
		$btimgfile = ""
		$image_file = ""
		$img_fname = ""
		$img_fext = ""
		$IMG_Path = ""
	EndIf
	DisableMenus(0)
EndFunc   ;==> _img_fsel
;===================================================================================================
Func _target_drive()
	Local $TargetSelect, $Tdrive, $valid = 0, $ValidDrives, $RemDrives, $FSvar
	Local $NoDrive[2] = ["A:", "B:"], $FileSys[3] = ["NTFS", "FAT32", "FAT"]

	; GUICtrlSetState($Boot_Menu, $GUI_CHECKED)
	DisableMenus(1)
	$ValidDrives = DriveGetDrive( "FIXED" )
	_ArrayPush($ValidDrives, "")
	_ArrayPop($ValidDrives)
	$RemDrives = DriveGetDrive( "REMOVABLE" )
	_ArrayPush($RemDrives, "")
	_ArrayPop($RemDrives)
	_ArrayConcatenate($ValidDrives, $RemDrives)
;	; _ArrayDisplay($ValidDrives)

	$TargetDrive = ""
	GUICtrlSetData($Target, "")
	;	GUICtrlSetData($TargetSize, "")
	;	GUICtrlSetData($TargetFree, "")

	$TargetSelect = FileSelectFolder("Select USB Boot Drive for Grub4dos Menu", "")
	If @error Then
		DisableMenus(0)
		Return
	EndIf

	$Tdrive = StringLeft($TargetSelect, 2)
	FOR $d IN $ValidDrives
		If $d = $Tdrive Then
			$valid = 1
			ExitLoop
		EndIf
	NEXT
	FOR $d IN $NoDrive
		If $d = $Tdrive Then
			$valid = 0
			MsgBox(48, "ERROR - Drive NOT Valid", "NOT Valid as USB Drive with XP", 3)
			DisableMenus(0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	NEXT

	If StringLeft(@WindowsDir, 2) = $Tdrive Then
		$valid = 0
		MsgBox(48,"INVALID Drive - Windows is Running on Target ", " Windows is Running on Target Boot Drive " & @CRLF & @CRLF _
			& " Boot with other Windows OS ")
		DisableMenus(0)
		GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf

	If $valid And DriveStatus($Tdrive) <> "READY" Then
		$valid = 0
		MsgBox(48, "ERROR - Drive NOT Ready", "Drive NOT READY", 3)
		DisableMenus(0)
		GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf
	If $valid Then
		$FSvar = DriveGetFileSystem( $Tdrive )
		FOR $d IN $FileSys
			If $d = $FSvar Then
				$valid = 1
				ExitLoop
			Else
				$valid = 0
			EndIf
		NEXT
		IF Not $valid Then
			MsgBox(48, "ERROR - Invalid FileSystem", "NTFS - FAT32 or FAT FileSystem NOT Found", 3)
			DisableMenus(0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	EndIf
	;	If $valid Then
	;		If Not FileExists($Tdrive & $WinFol) Or Not FileExists($Tdrive & "\NTLDR") Or Not FileExists($Tdrive & "\NTDETECT.COM") Then
	;			$valid = 0
	;			MsgBox(48, "INVALID Drive - XP Not Found ", "WINDOWS Or NTLDR Or NTDETECT.COM NOT Found ")
	;			DisableMenus(0)
	;			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
	;			Return
	;		EndIf
	;	EndIf

	If $valid Then
		$TargetDrive = $Tdrive
		GUICtrlSetData($Target, $TargetDrive)
		$DriveType=DriveGetType($TargetDrive)
		$TargetSpaceAvail = Round(DriveSpaceFree($TargetDrive))
		; GUICtrlSetData($TargetSize, $FSvar & "     " & Round(DriveSpaceTotal($TargetDrive) / 1024, 1) & " GB")
		; GUICtrlSetData($TargetSize, $FSvar)
		; GUICtrlSetData($TargetFree, "FREE  = " & Round(DriveSpaceFree($TargetDrive) / 1024, 1) & " GB")
		GUICtrlSetState($grldrUpd, $GUI_ENABLE + $GUI_UNCHECKED)
		GUICtrlSetState($Boot_Menu, $GUI_ENABLE + $GUI_CHECKED)
	Else
		$TargetDrive = ""
		GUICtrlSetData($Target, "")
		; GUICtrlSetData($TargetSize, "")
		; GUICtrlSetData($TargetFree, "")
		MsgBox(48, "ERROR - Drive NOT Valid", "Drive NOT Valid as Boot Drive for Grub4dos Menu", 3)
		GUICtrlSetState($grldrUpd, $GUI_DISABLE + $GUI_UNCHECKED)
		GUICtrlSetState($Boot_Menu, $GUI_DISABLE + $GUI_UNCHECKED)
		DisableMenus(0)
		GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf
	DisableMenus(0)
EndFunc   ;==> _target_drive
;===================================================================================================
Func _WinDrv_drive()
	Local $WinDrvSelect, $Tdrive, $valid = 0, $ValidDrives, $RemDrives, $FSvar
	Local $NoDrive[2] = ["A:", "B:"], $FileSys[3] = ["NTFS", "FAT32", "FAT"]

	; GUICtrlSetState($Boot_Menu, $GUI_CHECKED)
	DisableMenus(1)
	$ValidDrives = DriveGetDrive( "FIXED" )
	_ArrayPush($ValidDrives, "")
	_ArrayPop($ValidDrives)
	$RemDrives = DriveGetDrive( "REMOVABLE" )
	_ArrayPush($RemDrives, "")
	_ArrayPop($RemDrives)
	_ArrayConcatenate($ValidDrives, $RemDrives)
;	; _ArrayDisplay($ValidDrives)

	$WinDrvDrive = ""
	GUICtrlSetData($WinDrv, "")
	GUICtrlSetData($WinDrvSize, "")
	GUICtrlSetData($WinDrvFree, "")

	$TargetDrive = ""
	GUICtrlSetData($Target, "")
	;	GUICtrlSetData($TargetSize, "")
	;	GUICtrlSetData($TargetFree, "")

	$WinDrvSelect = FileSelectFolder("Select USB Target System Drive for Fixing of XP", "")
	If @error Then
		DisableMenus(0)
		Return
	EndIf

	$Tdrive = StringLeft($WinDrvSelect, 2)
	FOR $d IN $ValidDrives
		If $d = $Tdrive Then
			$valid = 1
			ExitLoop
		EndIf
	NEXT
	FOR $d IN $NoDrive
		If $d = $Tdrive Then
			$valid = 0
			MsgBox(48, "ERROR - Drive NOT Valid", "NOT Valid as USB Drive with XP", 3)
			DisableMenus(0)
			GUICtrlSetState($WinDrvSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	NEXT

	If StringLeft(@WindowsDir, 2) = $Tdrive Then
		$valid = 0
		MsgBox(48,"INVALID Drive - Windows is Running on Target ", " Windows is Running on Target System Drive " & @CRLF & @CRLF _
			& " Boot with other Windows OS ")
		DisableMenus(0)
		GUICtrlSetState($WinDrvSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf

	If $valid And DriveStatus($Tdrive) <> "READY" Then
		$valid = 0
		MsgBox(48, "ERROR - Drive NOT Ready", "Drive NOT READY", 3)
		DisableMenus(0)
		GUICtrlSetState($WinDrvSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf
	If $valid Then
		$FSvar = DriveGetFileSystem( $Tdrive )
		FOR $d IN $FileSys
			If $d = $FSvar Then
				$valid = 1
				ExitLoop
			Else
				$valid = 0
			EndIf
		NEXT
		IF Not $valid Then
			MsgBox(48, "ERROR - Invalid FileSystem", "NTFS - FAT32 or FAT FileSystem NOT Found", 3)
			DisableMenus(0)
			GUICtrlSetState($WinDrvSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	EndIf
	If $valid Then
		If Not FileExists($Tdrive & $WinFol) Then
			$valid = 0
			MsgBox(48, "INVALID Drive - XP Not Found ", "WINDOWS NOT Found ")
			DisableMenus(0)
			GUICtrlSetState($WinDrvSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	EndIf

	If $valid Then
		$WinDrvDrive = $Tdrive
		GUICtrlSetData($WinDrv, $WinDrvDrive)
		$DriveType=DriveGetType($WinDrvDrive)
		$WinDrvSpaceAvail = Round(DriveSpaceFree($WinDrvDrive))
		GUICtrlSetData($WinDrvSize, $FSvar & "     " & Round(DriveSpaceTotal($WinDrvDrive) / 1024, 1) & " GB")
		GUICtrlSetData($WinDrvFree, "FREE  = " & Round(DriveSpaceFree($WinDrvDrive) / 1024, 1) & " GB")
		;	GUICtrlSetState($grldrUpd, $GUI_DISABLE + $GUI_UNCHECKED)
		;	GUICtrlSetState($Boot_Menu, $GUI_DISABLE + $GUI_UNCHECKED)
	Else
		$WinDrvDrive = ""
		GUICtrlSetData($WinDrv, "")
		GUICtrlSetData($WinDrvSize, "")
		GUICtrlSetData($WinDrvFree, "")
		MsgBox(48, "ERROR - Drive NOT Valid", "Drive NOT Valid for Fixing of XP", 3)
		;	GUICtrlSetState($grldrUpd, $GUI_ENABLE)
		;	GUICtrlSetState($Boot_Menu, $GUI_ENABLE + $GUI_CHECKED)
		DisableMenus(0)
		GUICtrlSetState($WinDrvSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf
	DisableMenus(0)
EndFunc   ;==> _WinDrv_drive
;===================================================================================================
Func _IMG_Update()
	Local $val=0, $valid = 0, $AllDrives, $search_handle, $file_found="", $win_count = 0, $ikey
	Local $TempDrives[23] = ["Z:", "Y:", "X:", "W:", "V:", "U:", "T:", "S:", "R:", "Q:", "P:", "O:", "N:", "M:", "L:", "K:", "J:", "I:", "H:", "G:", "F:", "E:", "D:" ]

	$AllDrives = DriveGetDrive( "all" )

	_GUICtrlStatusBar_SetText($hStatus," ImDisk Opening Virtual Drive ", 0)

	$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\imdisk.exe" & " -a -t file -b auto -f " & $btimgfile & " -o rw -m #: ", @ScriptDir, @SW_HIDE)

	If $val Then
		SystemFileRedirect("Off")
		MsgBox(48, "ERROR - ImDisk ", "ImDisk returned with exit code:" & $val & @CRLF & @CRLF & "Unable to Open Virtual Drive "  _
		& @CRLF & @CRLF & "Please Reboot Computer and try again ")
		Exit
	EndIf

	FOR $d IN $TempDrives
		$valid = 1
		For $i = 1 to $AllDrives[0]
			If $d = $AllDrives[$i] Then
				$valid = 0
			;	MsgBox(48,"Invalid Drive " & $i, "Invalid Drive " & $AllDrives[$i])
			;	_ArrayDisplay($AllDrives)
				ExitLoop
			EndIf
		Next
		If $valid Then
			$search_handle = FileFindFirstFile($d & "\WIN*")
			; Check if the search was successful
			If $search_handle = -1 Then
				$valid = 0
			;	MsgBox(0, "Error", "No files/directories matched the search pattern")
			Else
				$win_count = 0
				While 1
					$file_found = FileFindNextFile($search_handle)
					If @error Then ExitLoop
					If FileExists($d & "\" & $file_found & "\system32") Then
						$win_count = $win_count + 1
						$WinFol = "\" & $file_found
					;	MsgBox(48, "Windows system32 Found ", "Windows system32 = " & $d & "\" & $file_found & "\system32")
					EndIf
				WEnd
				; Close the search handle
				FileClose($search_handle)
			EndIf
		EndIf
		If $win_count > 1 Then $valid = 0
		If $valid Then
			$tmpdrive = $d
			ExitLoop
		EndIf
	NEXT

	IF $tmpdrive = "" Or Not $valid Or $win_count <> 1 Then
		_GUICtrlStatusBar_SetText($hStatus,"Virtual Drive " & $tmpdrive & " NOT Valid", 0)
		MsgBox(48, "ERROR - Image file or Virtual Drive NOT valid ", " Virtual Drive with " & $WinFol & " folder NOT found " _
		& @CRLF & @CRLF & "Reboot and Select valid XP VHD Image file ")
		_GUICtrlStatusBar_SetText($hStatus,"Wait Virtual Drive " & $tmpdrive & " will be Closed", 0)
		Sleep(3000)
		$val = _RunDOS(@WindowsDir & "\system32\imdisk.exe" & " -D -m " & $tmpdrive)
		If $val Then MsgBox(48, "WARNING - ImDisk could not Close Virtual Drive ", "Manually Close Virtual Drive using R-mouse " & @CRLF & @CRLF & "Imdisk Exit code = " & $val, 0)
		SystemFileRedirect("Off")
		Exit
	EndIf

	If Not FileExists($tmpdrive & "\NTLDR") Or Not FileExists($tmpdrive & "\NTDETECT.COM") Then
		_GUICtrlStatusBar_SetText($hStatus,"Virtual Drive " & $tmpdrive & " NOT Valid", 0)
		$valid = 0
		MsgBox(48, " WARNING - Image File is Not Valid ", " STOP Program " & @CRLF & @CRLF _
		& " NTLDR Or NTDETECT.COM Not Found" & @CRLF & @CRLF _
		& " BootFiles missing - Selected = " & $btimgfile, 0)
		_GUICtrlStatusBar_SetText($hStatus,"Wait Virtual Drive " & $tmpdrive & " will be Closed", 0)
		Sleep(3000)
		$val = _RunDOS(@WindowsDir & "\system32\imdisk.exe" & " -D -m " & $tmpdrive)
		If $val Then MsgBox(48, "WARNING - ImDisk could not Close Virtual Drive ", "Manually Close Virtual Drive using R-mouse " & @CRLF & @CRLF & "Imdisk Exit code = " & $val, 0)
		SystemFileRedirect("Off")
		Exit
	EndIf

	_XP_Update()

	_GUICtrlStatusBar_SetText($hStatus,"Wait Virtual Drive " & $tmpdrive & " will be Closed", 0)

	Sleep(3000)

	$val = _RunDOS(@WindowsDir & "\system32\imdisk.exe" & " -D -m " & $tmpdrive)

	If $val Then MsgBox(48, "WARNING - ImDisk could not Close Virtual Drive ", "Imdisk Exit code = ", $val & @CRLF & @CRLF & "Manually Close Virtual Drive using R-mouse ", 0)

;	MsgBox(0, "ImDisk Close returned with exit code:", $val)

	Return $val
EndFunc   ;==> _IMG_Update
;===================================================================================================
Func _Go()
	Local $ikey, $len, $pos

	Local $file, $line, $linesplit[20], $inst_disk="", $inst_part="", $mptarget=0, $count=0

	_GUICtrlStatusBar_SetText($hStatus,"", 0)
	GUICtrlSetData($ProgressAll, 5)
	DisableMenus(1)

	; ImDisk Driver needed for Virtual Drive
	; First always Manually Install ImDisk using USB_XP_Setup\makebt\imdiskinst.exe
	; 64-bits XP - Enable to find imdisk.exe and drivers in @WindowsDir & "\system32
	SystemFileRedirect("On")

	If $btimgfile <> "" Then
		If Not FileExists(@WindowsDir & "\system32\imdisk.exe") Then
			SystemFileRedirect("Off")
			MsgBox(48, "WARNING - Manual Install ImDisk Driver ", "ImDisk Driver needed for Virtual Drive  " & @CRLF & @CRLF & " First Install ImDisk using makebt\imdiskinst.exe ")
			Exit
		EndIf
		; Keep SystemFileRedirect On until End

		GUICtrlSetData($ProgressAll, 10)
		_IMG_Update()
		_GUICtrlStatusBar_SetText($hStatus,"Update of XP VHD Image file finished ", 0)
	Else
		_GUICtrlStatusBar_SetText($hStatus," Checking drives - wait ...", 0)
		$DriveType=DriveGetType( $WinDrvDrive)

		If $DriveType="Removable" Or $DriveType="Fixed" Then
			GUICtrlSetData($ProgressAll, 10)
		Else
			SystemFileRedirect("Off")
			MsgBox(48, "ERROR - Target System Drive NOT Valid", "Target System Drive = " &  $WinDrvDrive & " Not Valid " & @CRLF & @CRLF & _
			" Only Removable Or Fixed Drive allowed ", 0)
			_GUICtrlStatusBar_SetText($hStatus," Select XP VHD Image File Or USB Target System Drive", 0)
			GUICtrlSetData($ProgressAll, 0)
			DisableMenus(0)
			Return
		EndIf

		GUICtrlSetData($ProgressAll, 10)
		If FileExists(@ScriptDir & "\makebt\usblist.txt") Then
			FileCopy(@ScriptDir & "\makebt\usblist.txt", @ScriptDir & "\makebt\usblist_bak.txt", 1)
			FileDelete(@ScriptDir & "\makebt\usblist.txt")
		EndIf

		RunWait(@ComSpec & " /c makebt\listusbdrives\ListUsbDrives.exe -a > makebt\usblist.txt", @ScriptDir, @SW_HIDE)

		$usbfix=0
		$file = FileOpen(@ScriptDir & "\makebt\usblist.txt", 0)
		If $file <> -1 Then
			$count = 0
			$mptarget = 0
			While 1
				$line = FileReadLine($file)
				If @error = -1 Then ExitLoop
				If $line <> "" Then
					$count = $count + 1
					$linesplit = StringSplit($line, "=")
					$linesplit[1] = StringStripWS($linesplit[1], 3)
					If $linesplit[1] = "MountPoint" And $linesplit[0] = 2 Then
						$linesplit[2] = StringStripWS($linesplit[2], 3)
						If $linesplit[2] =  $WinDrvDrive & "\" Then
							$mptarget = 1
							; MsgBox(0, "TargetDrive Found - OK", " TargetDrive = " & $linesplit[2], 3)
						Else
							$mptarget = 0
						EndIf
					EndIf
					If $mptarget = 1 Then
						If $linesplit[1] = "Bus Type" And $linesplit[0] = 2 Then
							$linesplit[2] = StringStripWS($linesplit[2], 3)
							If $linesplit[2] = "USB" Then
								$usbfix = 1
							Else
								If $linesplit[2] = "ATA" Then
									$usbfix = 0
								EndIf
							EndIf
							;	MsgBox(0, "TargetDrive USB or HDD ?", " Bus Type = " & $linesplit[2], 3)
						EndIf
						If $linesplit[1] = "Device Number" And $linesplit[0] = 2 Then
							$inst_disk = StringStripWS($linesplit[2], 3)
						EndIf
						If $linesplit[1] = "Partition Number" Then
							$inst_part = StringLeft(StringStripWS($linesplit[2], 3), 1)
						EndIf
					EndIf
				EndIf
			Wend
			FileClose($file)
		EndIf
		If $DriveType="Removable" Or $usbfix Then
			$tmpdrive =  $WinDrvDrive
			_XP_Update()
			_GUICtrlStatusBar_SetText($hStatus,"Update of XP Target System Drive finished ", 0)
		Else
			SystemFileRedirect("Off")
			MsgBox(48, "INVALID Drive - USB Not Found ", "Only for Removable Or Fixed USB Drives ")
			_GUICtrlStatusBar_SetText($hStatus," Select XP VHD Image File Or USB Target System Drive", 0)
			GUICtrlSetData($ProgressAll, 0)
			DisableMenus(0)
			Return
		EndIf
	EndIf

	; Update existing grldr
	If $btimgfile <> "" And  GUICtrlRead($grldrUpd) = $GUI_CHECKED And FileExists($TargetDrive & "\grldr") Then
		FileSetAttrib($TargetDrive & "\grldr", "-RSH")
		FileCopy($TargetDrive & "\grldr", $TargetDrive & "\grldr_old")
		FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
		If FileExists($TargetDrive & "\grldr.mbr") Then FileCopy(@ScriptDir & "\makebt\grldr.mbr", $TargetDrive & "\", 1)
		; If FileExists(@ScriptDir & "\makebt\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
	EndIf

	GUICtrlSetData($ProgressAll, 70)

	If $btimgfile <> "" And $TargetDrive <> "" And GUICtrlRead($Boot_Menu) = $GUI_CHECKED Then
		For $str In $bt_files
			If Not FileExists(@ScriptDir & $str) And $IMG_Path <> "" Then
					MsgBox(48, "WARNING - Missing File", " File " & $str & " NOT Found " & @CRLF & @CRLF _
					& " Skip Install of " & $image_file & " in GRUB4DOS Menu ", 10)
					$inst_valid=0
			EndIf
		Next

		If $inst_valid And $IMG_Path <> "" And FileExists($btimgfile) Then
			_GUICtrlStatusBar_SetText($hStatus," Checking BootSector ... ", 0)
			_Copy_BS()
			If $bs_valid = 0 Then $inst_valid=2

			If $inst_valid = 1 And $g4d Then
				If Not FileExists($TargetDrive & "\grldr") Then
					FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
					; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
				EndIf
				If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
			EndIf
			Sleep(2000)
		EndIf

		GUICtrlSetData($ProgressAll, 80)

		If $inst_valid =1 And $IMG_Path <> "" And FileExists($btimgfile) Then
			_Make_Boot_Menu()
			Sleep(2000)
		EndIf
	EndIf

	GUICtrlSetData($ProgressAll, 100)
	_GUICtrlStatusBar_SetText($hStatus," End of Program - OK ", 0)

	SystemFileRedirect("Off")

	If Not $DP_CU_found Then
		MsgBox(48, "WARNING -  Chipset DP Not Found ", " Windows\DriverPacks\C\U  NOT found in Source " & @CRLF & @CRLF & _
		" Unable to Add Drivers to boot from USB 3.0 ", 0)
	EndIf
	If Not $DP_M_found Then
		MsgBox(48, "WARNING -  MassStorage DP Not Found ", " Windows\DriverPacks\M  NOT found in Source " & @CRLF & @CRLF & _
		" Unable to Add MassStorage Drivers to boot any hardware ", 0)
	EndIf

	If $inst_valid=1 Then
		If $btimgfile <> "" Then
			MsgBox(64, " END OF PROGRAM - OK ", " Update Ready of XP VHD Image = " & $btimgfile & @CRLF _
			& @CRLF & " Reboot Image from Grub4dos Menu on Boot Drive " & $TargetDrive)
		Else
			MsgBox(64, " END OF PROGRAM - OK ", " Update Ready of XP on Target System Drive " &  $WinDrvDrive & @CRLF _
			& @CRLF & " Reboot XP from Boot Drive ")
		EndIf
	Else
		MsgBox(64, " END OF PROGRAM - WARNING ", " Update Ready of XP VHD Image = " & $btimgfile & @CRLF _
		& @CRLF & " Image is on Drive " &  $WinDrvDrive & @CRLF & @CRLF & _
		" Boot Problems may need to be Solved ", 0)
	EndIf

	Exit
EndFunc ;==> _Go
;===================================================================================================
Func TogglePause()
	$Paused = NOT $Paused
    While $Paused
        Sleep(100)
        ToolTip('Script is "Paused"',220,410)
	WEnd
    ToolTip("")
EndFunc ;==>TogglePause()
;===================================================================================================
Func DisableMenus($endis)
	If $endis = 0 Then
		$endis = $GUI_ENABLE
	Else
		$endis = $GUI_DISABLE
	EndIf

	GUICtrlSetState($UsbFixAdd, $endis)
	GUICtrlSetState($PostFixAdd, $endis)
	GUICtrlSetState($EWFAdd, $endis)

	If FileExists(@ScriptDir & "\makebt\halkern\halstan.dll") And FileExists(@ScriptDir & "\makebt\halkern\ntkrup.exe") Then
		GUICtrlSetState($HalKernAdd, $endis)
	Else
		GUICtrlSetState($HalKernAdd, $GUI_DISABLE + $GUI_UNCHECKED)
	EndIf
	GUICtrlSetState($SourceDir, $endis)
	GUICtrlSetState($Source, $endis)

	GUICtrlSetState($RegSysAdd, $endis)
	GUICtrlSetState($RegAMDAHCI, $endis)
	GUICtrlSetState($RegIASTOR, $endis)
	; GUICtrlSetState($RegSoftAdd, $endis)
	; GUICtrlSetState($RegSoftAdd, $GUI_DISABLE + $GUI_CHECKED)

	GUICtrlSetState($waitbtAdd, $endis)
	GUICtrlSetState($minlogon, $endis)
    GUICtrlSetState($ForceUpdate, $endis)
    GUICtrlSetState($Scsi_Menu, $endis)
	GUICtrlSetState($usb3_Menu, $endis)

	GUICtrlSetState($IMG_File, $endis)
	GUICtrlSetState($Target, $endis)
	GUICtrlSetState($WinDrv, $endis)
	; GUICtrlSetState($TargetSel, $endis)

	If $WinDrvDrive <> "" Then
		GUICtrlSetState($IMG_FileSelect, $GUI_DISABLE)
	Else
		GUICtrlSetState($IMG_FileSelect, $endis)
	EndIf

	If $btimgfile = "" And $WinDrvDrive <> "" Then
		GUICtrlSetState($TargetSel, $GUI_DISABLE)
	Else
		GUICtrlSetState($TargetSel, $endis)
	EndIf

	If $btimgfile <> "" Then
		GUICtrlSetState($IMG_FileSelect, $endis)
		GUICtrlSetState($WinDrvSel, $GUI_DISABLE)
		GUICtrlSetData($WinDrv, $IMG_Path)
	Else
		GUICtrlSetState($WinDrvSel, $endis)
		GUICtrlSetData($WinDrv, $WinDrvDrive)
	EndIf

	If $btimgfile <> "" And $TargetDrive <> "" Then
		GUICtrlSetState($Boot_Menu, $endis)
		GUICtrlSetState($grldrUpd, $endis)
	Else
		GUICtrlSetState($grldrUpd, $GUI_DISABLE + $GUI_UNCHECKED)
		GUICtrlSetState($Boot_Menu, $GUI_DISABLE + $GUI_UNCHECKED)
	EndIf

	GUICtrlSetState($GO, $GUI_DISABLE)

	GUICtrlSetData($Target, $TargetDrive)
	GUICtrlSetData($IMG_File, $btimgfile)
	GUICtrlSetData($Source, $WinSource)
EndFunc ;==>DisableMenus
;===================================================================================================
Func HexSearch($fl, $str1, $bin = 0, $ind = 0)
	Local $src, $file, $strpos=0
	; $bin=16 for hex search, $ind=0 for StringToHex conversion
	If $bin = 16 And $ind = 0 Then
		$str1 = _StringToHex($str1)
	EndIf
	$file = FileOpen($fl, $bin)
	If $file = -1 Then
		MsgBox(48, "Error", "Unable to open " & $fl & " for Search ", 3)
		Return 0
	EndIf
	$src = FileRead($file)
	FileClose($file)
	$strpos = StringInStr($src, $str1)
	If $bin = 16 Then $strpos = Int($strpos / 2)
	Return $strpos
	; Not Found Returns $strpos=0
	; $strpos=1 is the first byte - substract 1 for comparison with TinyHexer and gsar
	; In TinyHexer and gsar the first byte has position 0
EndFunc
;===================================================================================================
Func HexReplace($fl, $str1, $str2, $flag = 0, $bin = 0, $ind = 0)
	Local $hOut, $src, $file
	;flag- The number of times to replace the searchstring, 0 for all
	;$bin- 16 for hex editing
	If $bin = 16 And $ind = 0 Then
		$str1 = _StringToHex($str1)
		$str2 = _StringToHex($str2)
	EndIf
	$file = FileOpen($fl, $bin)
	If $file = -1 Then
		MsgBox(16, "Error", "Unable to open " & $fl & " for editing, Aborting in 10 seconds...", 10)
		Exit
	EndIf
	$src = FileRead($file)
	FileClose($file)
;	FileMove($fl, $fl & ".bak", 8)
	$src = StringReplace($src, $str1, $str2, $flag)
	If $src = "" Then
		MsgBox(16, "Error", "Something wont wrong whille editing " & $fl)
	EndIf
	$hOut = FileOpen($fl, $bin + 2)
    FileWrite($hOut , $src)
    FileClose($hOut)
	Return @extended
EndFunc
;===================================================================================================
Func _Copy_BS()
	Local $pos=0, $ntpos=0, $bmpos=0, $grpos=0

;	IF FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")

	RunWait(@ComSpec & " /c makebt\dsfo.exe \\.\" & $TargetDrive & " 0 512 makebt\bs_temp\Back512.bs", @ScriptDir, @SW_HIDE)

	$pos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "NTFS", 16, 0)
	;
	; NTFS BootSector
	If $pos = 4 Then
		$ntfs_bs = 1
		$g4d_vista = 0
		RunWait(@ComSpec & " /c makebt\dsfo.exe \\.\" & $TargetDrive & " 0 8192 makebt\bs_temp\Back8192.bs", @ScriptDir, @SW_HIDE)
		; Search N T L D R
		$ntpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back8192.bs", "4E0054004C0044005200", 16, 1)
		If $ntpos = 515 Then
			$bs_valid = 1
		;	MsgBox(0, "Valid BootSector - NTFS - N T L D R", "NTFS  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF & "N T L D R  Found at OFFSET  " & $ntpos-1 & "  ", 0)
		Else
			; Search B O O T M G R
			$bmpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back8192.bs", "42004F004F0054004D0047005200", 16, 1)
			If $bmpos = 515 Then
				$bs_valid = 1
				$g4d_vista = 1
			;	MsgBox(0, "Valid BootSector - NTFS - B O O T M G R", "NTFS  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF & "B O O T M G R  Found at OFFSET  " & $bmpos-1 & "  ", 0)
			Else
				; Search grldr - Offset = 474 = 0x1DA so that $grpos = 475
				$grpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back8192.bs", "grldr", 16, 0)
				If $grpos Then
					$g4d = 1
					$bs_valid = 3
				;	MsgBox(0, "Valid BootSector - NTFS - grldr", "NTFS  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF  _
				;	& "grldr  Found at OFFSET  " & $grpos-1 & "  ",0)
				Else
					$bs_valid = 0
					MsgBox(48, "STOP - NTFS BootSector - NOT Valid for MultiBoot Menu", "N T L D R  or  B O O T M G R  or grldr NOT Found in BootSector  " & @CRLF & @CRLF _
					& "Solution: First Format your Target Boot Drive and then Try Again ", 0)
					Return
				EndIf
			EndIf
		EndIf
	Else
		$ntfs_bs = 0
	EndIf
	;
	; FAT BootSector
	If $ntfs_bs = 0 Then
		$pos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "FAT", 16, 0)
		If $pos = 55 Then
			$g4d_vista = 0
			$ntpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "NTLDR", 16, 0)
			If $ntpos = 418 Then
				$bs_valid = 1
			;	MsgBox(0, "Valid BootSector - FAT - NTLDR", "FAT  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF & "NTLDR  Found at OFFSET  " & $ntpos-1 & "  ", 0)
			Else
				$bmpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "BOOTMGR", 16, 0)
				; FAT16 has BOOTMGR at OFFSET=417 so that $bmpos=418 - Equal pos as NTLDR
				If $bmpos = 418 Then
					$bs_valid = 1
					$g4d_vista = 1
				;	MsgBox(0, "Valid BootSector - FAT - BOOTMGR", "FAT  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF & "BOOTMGR  Found at OFFSET  " & $bmpos-1 & "  ", 0)
				Else
					; Search grldr
					$grpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "GRLDR", 16, 0)
					If $grpos Then
						$g4d = 1
						$bs_valid = 3
					;	MsgBox(0, "Valid BootSector - FAT - GRLDR", "FAT  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF  _
					;	& "GRLDR  Found at OFFSET  " & $grpos-1 & "  ", 0)
					Else
						$bs_valid = 0
						; case of IO.SYS - MSDOS BootSector
						MsgBox(48, "STOP - FAT BootSector - NOT Valid for MultiBoot Menu", "NTLDR or BOOTMGR or GRLDR NOT Found in BootSector  " & @CRLF & @CRLF _
						& "Solution: First Format your Target Boot Drive and then Try Again ", 0)
						Return
					EndIf
				EndIf
			EndIf
		ElseIf $pos = 83 Then
			$g4d_vista = 0
			$ntpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "NTLDR", 16, 0)
			If $ntpos = 369 Then
				$bs_valid = 1
			;	MsgBox(0, "Valid BootSector - FAT32 - NTLDR", "FAT32  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF & "NTLDR  Found at OFFSET  " & $ntpos-1 & "  ", 0)
			Else
				$bmpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "BOOTMGR", 16, 0)
				; FAT32 has BOOTMGR at OFFSET=361 so that $bmpos=362 - Different pos as NTLDR
				If $bmpos Then
					$bs_valid = 1
					$g4d_vista = 1
				;	MsgBox(0, "Valid BootSector - FAT32 - BOOTMGR", "FAT32  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF & "BOOTMGR  Found at OFFSET  " & $bmpos-1 & "  ", 0)
				Else
					; Search grldr
					$grpos = HexSearch(@ScriptDir & "\makebt\bs_temp\Back512.bs", "GRLDR", 16, 0)
					If $grpos Then
						$g4d = 1
						$bs_valid = 3
					;	MsgBox(0, "Valid BootSector - FAT32 - GRLDR", "FAT32  Found at OFFSET  " & $pos-1 & "  " & @CRLF & @CRLF _
					;	& "GRLDR  Found at OFFSET  " & $grpos-1 & "  ", 0)
					Else
						$bs_valid = 0
						MsgBox(48, "STOP - FAT32 BootSector - NOT Valid for MultiBoot Menu", "NTLDR or BOOTMGR or GRLDR NOT Found in BootSector  " & @CRLF & @CRLF _
						& "Solution: First Format your Target Boot Drive and then Try Again ", 0)
						Return
					EndIf
				EndIf
			EndIf
		Else
			$bs_valid = 0
			MsgBox(48, "STOP - Unknown Type BootSector", "NTFS or FAT or FAT32  NOT Found in BootSector  ", 0)
		EndIf
	EndIf
EndFunc   ;==> _Copy_BS
;===================================================================================================
Func _Make_Boot_Menu()
	Local $i, $len, $pos, $file, $line
	Local $store, $guid, $bcdentry, $pos1, $pos2

	_GUICtrlStatusBar_SetText($hStatus," Making Grub4dos Menu for XP VHD Image File - wait ....", 0)

	If $g4d And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
		FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
		If $driver_flag = 1 Then
			_grub4dos_winvb_menu()
		ElseIf $driver_flag = 2 Then
			_grub4dos_fira_menu()
		Else
			_grub4dos_ram_menu()
		EndIf
		Return
	EndIf

	If FileExists($TargetDrive & "\grldr") And FileExists($TargetDrive & "\menu.lst") And $g4d_vista = 0 And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
		FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
		If $driver_flag = 1 Then
			_grub4dos_winvb_menu()
		ElseIf $driver_flag = 2 Then
			_grub4dos_fira_menu()
		Else
			_grub4dos_ram_menu()
		EndIf
		Return
	EndIf

	GUICtrlSetData($ProgressAll, 80)

	If $g4d_vista = 0 Then
		If FileExists($TargetDrive & "\boot.ini") Then
			FileSetAttrib($TargetDrive & "\boot.ini", "-RSH")
			FileCopy($TargetDrive & "\boot.ini", $TargetDrive & "\boot_ini.txt", 1)
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS Menu"')
			IniWrite($TargetDrive & "\boot.ini", "Boot Loader", "Timeout", 20)
		Else
			IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
			"Default=C:\grldr")
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS Menu"')
		EndIf

		If Not FileExists($TargetDrive & "\BOOTFONT.BIN") Then
				FileCopy(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", $TargetDrive & "\", 1)
		EndIf

	;	use modified ntdetect if exists in makebt folder
		If Not FileExists($TargetDrive & "\NTDETECT.COM") Then
			IF FileExists(@ScriptDir & "\makebt\ntdetect.com") Then
				FileCopy(@ScriptDir & "\makebt\ntdetect.com", $TargetDrive & "\", 1)
			Else
				FileCopy(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", $TargetDrive & "\", 1)
			EndIf
		EndIf

		If Not FileExists($TargetDrive & "\ntldr") Then
				FileCopy(@ScriptDir & "\makebt\Boot_XP\NTLDR", $TargetDrive & "\", 1)
		EndIf

		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
		If $driver_flag = 1 Then
			_grub4dos_winvb_menu()
		ElseIf $driver_flag = 2 Then
			_grub4dos_fira_menu()
		Else
			_grub4dos_ram_menu()
		EndIf
	Else
		$mk_bcd = 1
		If Not FileExists($TargetDrive & "\bootmgr") Then $mk_bcd = 2
		If Not FileExists($TargetDrive & "\Boot\BCD") Then $mk_bcd = 2
		; If FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") Then $mk_bcd = 2

		If FileExists(@WindowsDir & "\system32\bcdedit.exe") Then
			$bcdedit = @WindowsDir & "\system32\bcdedit.exe"
		; Removed - In x86 OS with Target x64 W7 gives bcdedit is not valid 32-bits
		; 32-bits makebt\bcdedit.exe can be used in any case
		;	ElseIf FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
		;		$bcdedit = "makebt\bcdedit.exe"
		Else
			$mk_bcd = 2
		EndIf
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
		If $driver_flag = 1 Then
			_grub4dos_winvb_menu()
		ElseIf $driver_flag = 2 Then
			_grub4dos_fira_menu()
		Else
			_grub4dos_ram_menu()
		EndIf
		If $mk_bcd = 1 And $bcdedit <> "" Then
			If Not FileExists($TargetDrive & "\grldr.mbr") Or GUICtrlRead($grldrUpd) = $GUI_CHECKED Then
				FileCopy(@ScriptDir & "\makebt\grldr.mbr", $TargetDrive & "\", 1)
				$store = $TargetDrive & "\Boot\BCD"
				RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
				& $store & " /create /d " & '"' & "Start GRUB4DOS" & '"' & " /application bootsector > makebt\bs_temp\bcd_out.txt", @ScriptDir, @SW_HIDE)
				$file = FileOpen(@ScriptDir & "\makebt\bs_temp\bcd_out.txt", 0)
				$line = FileReadLine($file)
				FileClose($file)
				$pos1 = StringInStr($line, "{")
				$pos2 = StringInStr($line, "}")
				If $pos2-$pos1=37 Then
					$guid = StringMid($line, $pos1, $pos2-$pos1+1)
					RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
					& $store & " /set " & $guid & " device boot", $TargetDrive & "\", @SW_HIDE)
					RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
					& $store & " /set " & $guid & " path \grldr.mbr", $TargetDrive & "\", @SW_HIDE)
					RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
					& $store & " /displayorder " & $guid & " /addlast", $TargetDrive & "\", @SW_HIDE)
					;		MsgBox(0, "BOOTMGR - GRUB4DOS ENTRY in BCD OK ", "GRUB4DOS Boot Entry was made in Store Boot\BCD " & @CRLF & @CRLF _
					;		& "Grub4Dos GUID in BCD Store = " & $guid, 3)
				Else
					GUICtrlSetState($Boot_Menu, $GUI_UNCHECKED + $GUI_DISABLE)
					$mk_bcd = 2
					MsgBox(48, "ERROR - GRUB4DOS GUID NOT Valid", "Unabele to Add GRUB4DOS to BOOTMGR Menu", 3)
				EndIf
				;	Else
				;		GUICtrlSetState($Boot_Menu, $GUI_UNCHECKED + $GUI_DISABLE)
				;		$mk_bcd = 2
				;		MsgBox(48, "WARNING - grldr.mbr Found ", "New GRUB4DOS entry NOT made in BOOTMGR Menu" & @CRLF & @CRLF _
				;		& "Use Update Grub4dos grldr Checkbox if Needed ", 3)
			EndIf
		Else
			If Not FileExists($TargetDrive & "\grldr.mbr") Then
				GUICtrlSetState($Boot_Menu, $GUI_UNCHECKED + $GUI_DISABLE)
				MsgBox(48, "bcdedit or Boot\BCD Missing ", "Unabele to Add GRUB4DOS to BOOTMGR Menu" & @CRLF & @CRLF _
				& "Solution: Run in Win7 OS and Try Again ", 3)
			EndIf
		EndIf
	EndIf
EndFunc   ;==> _Make_Boot_Menu
;===================================================================================================
Func _xp_selfol()
	Local $pos, $len, $xpdir = "\I386\", $TempWinSource, $FixedDrives
	GUICtrlSetState($HalKernAdd, $GUI_DISABLE + $GUI_UNCHECKED)
	DisableMenus(1)
	$TempWinSource = FileSelectFolder("Select your XP Setup Source Folder", "")
	If Not @error Then
		$pos = StringInStr($TempWinSource, "\", 0, -1)
		If $pos = 0 Then
			MsgBox(48,"ERROR - Return", "XP Source Path Invalid - No Backslash Found" & @CRLF & "XP Setup Source = " & $TempWinSource)
			GUICtrlSetData($Source, "")
			$WinSource = ""
			DisableMenus(0)
			GUICtrlSetState($SourceDir, $GUI_FOCUS)
			Return
		EndIf
		If StringLen($TempWinSource) = 3 Then $TempWinSource = StringLeft($TempWinSource, 2)
		$len = StringLen($TempWinSource)
		If StringRight($TempWinSource, $len-$pos) = "I386" Then
			MsgBox(48,"ERROR - XP Setup Source Path Invalid", "Select your XPSOURCE and NOT I386 Folder " & @CRLF & @CRLF & "Selected XP Source = " & $TempWinSource)
			GUICtrlSetData($Source, "")
			$WinSource = ""
			DisableMenus(0)
			GUICtrlSetState($SourceDir, $GUI_FOCUS)
			Return
		EndIf
		If StringRight($TempWinSource, $len-$pos) = "AMD64" Then
			MsgBox(48,"ERROR - XP Setup Source Path Invalid", "Select your XPSOURCE and NOT AMD64 Folder " & @CRLF & @CRLF & "Selected XP Source = " & $TempWinSource)
			GUICtrlSetData($Source, "")
			$WinSource = ""
			DisableMenus(0)
			GUICtrlSetState($SourceDir, $GUI_FOCUS)
			Return
		EndIf
		If Not FileExists($TempWinSource & "\i386\NTLDR") Then
			MsgBox(48, "Error: XP Setup Source NOT Valid", "Error: I386 Folder with NTLDR NOT Found ")
			GUICtrlSetData($Source, "")
			$WinSource = ""
			DisableMenus(0)
			GUICtrlSetState($SourceDir, $GUI_FOCUS)
			Return
		EndIf
		If FileExists($TempWinSource & "\AMD64") Then
			$AMD64=1
			$xpdir = "\AMD64\"
		Else
			$AMD64=0
			$xpdir = "\I386\"
		EndIf
		$WinSource=$TempWinSource
		GUICtrlSetData($Source, $WinSource)
		If FileExists(@ScriptDir & "\makebt\halkern") Then DirRemove(@ScriptDir & "\makebt\halkern",1)
		If Not FileExists(@ScriptDir & "\makebt\halkern") Then DirCreate(@ScriptDir & "\makebt\halkern")

		If Not FileExists(@ScriptDir & "\makebt\Boot_XP") Then DirCreate(@ScriptDir & "\makebt\Boot_XP")
		IF Not FileExists(@ScriptDir & "\makebt\ATTRIB.EX_") Then
			FileCopy($WinSource & $xpdir & "ATTRIB.EX_", @ScriptDir & "\makebt\", 1)
			FileSetAttrib(@ScriptDir & "\makebt\ATTRIB.EX_", "-RSH")
		EndIf
		IF Not FileExists(@ScriptDir & "\makebt\XCOPY.EX_") Then
			FileCopy($WinSource & $xpdir & "XCOPY.EX_", @ScriptDir & "\makebt\", 1)
			FileSetAttrib(@ScriptDir & "\makebt\XCOPY.EX_", "-RSH")
		EndIf
		IF Not FileExists(@ScriptDir & "\makebt\EXPAND.EXE") Then
			FileCopy($WinSource & $xpdir & "EXPAND.EXE", @ScriptDir & "\makebt\", 1)
			FileSetAttrib(@ScriptDir & "\makebt\EXPAND.EXE", "-RSH")
		EndIf
		IF Not FileExists(@ScriptDir & "\makebt\xcopy.exe") Then
			RunWait(@ComSpec & " /c makebt\expand makebt\XCOPY.EX_ makebt\xcopy.exe", @ScriptDir, @SW_HIDE)
		EndIf
		IF Not FileExists(@ScriptDir & "\makebt\attrib.exe") Then
			RunWait(@ComSpec & " /c makebt\expand makebt\ATTRIB.EX_ makebt\attrib.exe", @ScriptDir, @SW_HIDE)
		EndIf
		If FileExists($WinSource & "\i386\BOOTFONT.BIN") Then
			IF Not FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then
				FileCopy($WinSource & "\i386\BOOTFONT.BIN", @ScriptDir & "\makebt\Boot_XP\", 1)
				FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", "-RSH")
			EndIf
		EndIf
		IF Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") Then
			FileCopy($WinSource & "\i386\NTDETECT.COM", @ScriptDir & "\makebt\Boot_XP\", 1)
			FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", "-RSH")
		EndIf
		IF Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then
			FileCopy($WinSource & "\i386\NTLDR", @ScriptDir & "\makebt\Boot_XP\", 1)
			FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTLDR", "-RSH")
		EndIf
		$needxp = 0

		SystemFileRedirect("On")
		If FileExists($WinSource & $xpdir & "sp3.cab") Then
			If FileExists(@WindowsDir & "\system32\expand.exe") Then
				RunWait(@ComSpec & " /c expand.exe " & '"' & $WinSource & "\i386\sp3.cab" & '"' & " -f:hal*.dll makebt\halkern\", @ScriptDir, @SW_HIDE)
				RunWait(@ComSpec & " /c expand.exe " & '"' & $WinSource & "\i386\sp3.cab" & '"' & " -f:nt*.exe makebt\halkern\", @ScriptDir, @SW_HIDE)
			Else
				RunWait(@ComSpec & " /c makebt\expand.exe " & '"' & $WinSource & "\i386\sp3.cab" & '"' & " -f:hal*.dll makebt\halkern\", @ScriptDir, @SW_HIDE)
				RunWait(@ComSpec & " /c makebt\expand.exe " & '"' & $WinSource & "\i386\sp3.cab" & '"' & " -f:nt*.exe makebt\halkern\", @ScriptDir, @SW_HIDE)
			EndIf
		ElseIf FileExists($WinSource & $xpdir & "sp2.cab") Then
			If FileExists(@WindowsDir & "\system32\expand.exe") Then
				RunWait(@ComSpec & " /c expand.exe " & '"' & $WinSource & "\i386\sp2.cab" & '"' & " -f:hal*.dll makebt\halkern\", @ScriptDir, @SW_HIDE)
				RunWait(@ComSpec & " /c expand.exe " & '"' & $WinSource & "\i386\sp2.cab" & '"' & " -f:nt*.exe makebt\halkern\", @ScriptDir, @SW_HIDE)
			Else
				RunWait(@ComSpec & " /c makebt\expand.exe " & '"' & $WinSource & "\i386\sp2.cab" & '"' & " -f:hal*.dll makebt\halkern\", @ScriptDir, @SW_HIDE)
				RunWait(@ComSpec & " /c makebt\expand.exe " & '"' & $WinSource & "\i386\sp2.cab" & '"' & " -f:nt*.exe makebt\halkern\", @ScriptDir, @SW_HIDE)
			EndIf
		Else
			If FileExists(@WindowsDir & "\system32\expand.exe") Then
				RunWait(@ComSpec & " /c expand.exe " & '"' & $WinSource & "\i386\driver.cab" & '"' & " -f:hal*.dll makebt\halkern\", @ScriptDir, @SW_HIDE)
				RunWait(@ComSpec & " /c expand.exe " & '"' & $WinSource & "\i386\driver.cab" & '"' & " -f:nt*.exe makebt\halkern\", @ScriptDir, @SW_HIDE)
			Else
				RunWait(@ComSpec & " /c makebt\expand.exe " & '"' & $WinSource & "\i386\driver.cab" & '"' & " -f:hal*.dll makebt\halkern\", @ScriptDir, @SW_HIDE)
				RunWait(@ComSpec & " /c makebt\expand.exe " & '"' & $WinSource & "\i386\driver.cab" & '"' & " -f:nt*.exe makebt\halkern\", @ScriptDir, @SW_HIDE)
			EndIf
		EndIf
		SystemFileRedirect("Off")
		FileMove(@ScriptDir & "\makebt\halkern\hal.dll", @ScriptDir & "\makebt\halkern\halstan.dll", 1)
		FileMove(@ScriptDir & "\makebt\halkern\ntoskrnl.exe", @ScriptDir & "\makebt\halkern\ntkrup.exe", 1)
		FileMove(@ScriptDir & "\makebt\halkern\ntkrnlpa.exe", @ScriptDir & "\makebt\halkern\ntkruppa.exe", 1)
		FileMove(@ScriptDir & "\makebt\halkern\ntkrnlmp.exe", @ScriptDir & "\makebt\halkern\ntkrmp.exe", 1)
		FileMove(@ScriptDir & "\makebt\halkern\ntkrpamp.exe", @ScriptDir & "\makebt\halkern\ntkrmppa.exe", 1)
		GUICtrlSetState($HalKernAdd, $GUI_CHECKED)
	Else
		GUICtrlSetData($Source, "")
		$WinSource = ""
	EndIf
	DisableMenus(0)
EndFunc   ;==> _xp_selfol
;===================================================================================================
Func _grub4dos_winvb_menu()
	Local $entry_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	Else
		$entry_image_file = $image_file
	EndIf
	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - WinVBlock FILEDISK - " & $BTIMGSize & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "# Sector-mapped disk")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - WinVBlock RAMDISK  - " & $BTIMGSize & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "# Sector-mapped disk")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_image_file & " (hd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")

EndFunc   ;==> _grub4dos_winvb_menu
;===================================================================================================
Func _grub4dos_fira_menu()
	Local $entry_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	Else
		$entry_image_file = $image_file
	EndIf

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - FiraDisk  FILEDISK - " & $BTIMGSize & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --heads=2 --sectors-per-track=18 --mem (md)0x800+4 (99)")
	FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "write (99) [FiraDisk]\nStartOptions=disk,vmem=find:/" & $entry_image_file & ",boot;\n\0")
	FileWriteLine($TargetDrive & "\menu.lst", "rootnoverify (hd0,0)")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")
	FileWriteLine($TargetDrive & "\menu.lst", "map --status")
	FileWriteLine($TargetDrive & "\menu.lst", "pause Press any key . . .")

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - FiraDisk  RAMDISK  - " & $BTIMGSize & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --heads=2 --sectors-per-track=18 --mem (md)0x800+4 (99)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_image_file & " (hd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "write (99) [FiraDisk]\nStartOptions=disk,vmem=find:/" & $entry_image_file & ",boot;\n\0")
	FileWriteLine($TargetDrive & "\menu.lst", "rootnoverify (hd0,0)")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")
	FileWriteLine($TargetDrive & "\menu.lst", "map --status")
	FileWriteLine($TargetDrive & "\menu.lst", "pause Press any key . . .")

EndFunc   ;==> _grub4dos_winvb_menu
;===================================================================================================
Func _grub4dos_ram_menu()
	Local $entry_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	Else
		$entry_image_file = $image_file
	EndIf

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title Load " & $entry_image_file & " in RAMDISK and Boot Windows Image ")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_image_file & " (hd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
	If $NTLDR_BS Then
		FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")
	Else
		FileWriteLine($TargetDrive & "\menu.lst", "chainloader /bootmgr")
	EndIf

EndFunc   ;==> _grub4dos_winvb_menu
;===================================================================================================
Func _XP_Update()
	Local $val=0, $i = 0

	GUICtrlSetData($ProgressAll, 20)

	_GUICtrlStatusBar_SetText($hStatus," Extract XP Boot drivers from driver.cab ", 0)

	$XP_Arch = "I386"
	If FileExists($tmpdrive & $WinFol & "\Driver Cache\AMD64") Then
		$XP_Arch = "AMD64"
	EndIf

	If FileExists($tmpdrive & $WinFol & "\Driver Cache\" & $XP_Arch & "\sp3.cab") Then
		$driver_cab = "\sp3.cab"
	ElseIf FileExists($tmpdrive & $WinFol & "\Driver Cache\" & $XP_Arch & "\sp2.cab") Then
		$driver_cab = "\sp2.cab"
	Else
		$driver_cab = "\driver.cab"
	EndIf

	; if missing get ide and usb driver files from driver.cab
	For $drv_file In $driver_files
		If Not FileExists($tmpdrive & $WinFol & "\system32\drivers\" & $drv_file) Then
			If FileExists($tmpdrive & $WinFol & "\Driver Cache\" & $XP_Arch & $driver_cab) Then
				RunWait(@ComSpec & " /c " & $expand & " " & '"' & $tmpdrive & $WinFol & "\Driver Cache\" & $XP_Arch & $driver_cab & '"' & " -f:" & $drv_file & " " & $tmpdrive & $WinFol & "\system32\drivers\", @ScriptDir, @SW_HIDE)
			EndIf
		EndIf
	Next

	For $drv_file In $sys32_files
		If Not FileExists($tmpdrive & $WinFol & "\system32\" & $drv_file) Then
			If FileExists($tmpdrive & $WinFol & "\Driver Cache\" & $XP_Arch & $driver_cab) Then
				RunWait(@ComSpec & " /c " & $expand & " " & '"' & $tmpdrive & $WinFol & "\Driver Cache\" & $XP_Arch & $driver_cab & '"' & " -f:" & $drv_file & " " & $tmpdrive & $WinFol & "\system32\", @ScriptDir, @SW_HIDE)
			EndIf
		EndIf
	Next

	Sleep(1000)

	If FileExists($tmpdrive & $WinFol & "\system32\drivers\wvblk32.sys") Then RunWait(@ComSpec & " /c compact.exe /u " & $tmpdrive & $WinFol & "\system32\drivers\wvblk32.sys", @ScriptDir, @SW_HIDE)
	If FileExists($tmpdrive & $WinFol & "\system32\drivers\firadisk.sys") Then RunWait(@ComSpec & " /c compact.exe /u " & $tmpdrive & $WinFol & "\system32\drivers\firadisk.sys", @ScriptDir, @SW_HIDE)

	GUICtrlSetData($ProgressAll, 30)

	_GUICtrlStatusBar_SetText($hStatus," Update of SYSTEM Registry in Drive " & $tmpdrive, 0)

	RunWait(@ComSpec & " /c reg load HKLM\systemdst " & $tmpdrive & $WinFol & "\system32\config\system", @ScriptDir, @SW_HIDE)

	If GUICtrlRead($UsbFixAdd) = $GUI_CHECKED Then
		; _GUICtrlStatusBar_SetText($hStatus," Adding UsbBootWatcher and USB Tweaks - wait ...", 0)
		RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_systemdst_USB_XP.reg", @ScriptDir, @SW_HIDE)
		If FileExists($tmpdrive & $WinFol & "\SysWOW64") Then
			FileCopy(@ScriptDir & "\makebt\UsbBootWatcher\amd64\UsbBootWatcher.exe", $tmpdrive & $WinFol & "\system32\", 1)
			FileCopy(@ScriptDir & "\makebt\UsbBootWatcher\amd64\UsbBootWatcher.conf", $tmpdrive & $WinFol & "\system32\", 1)
		Else
			FileCopy(@ScriptDir & "\makebt\UsbBootWatcher\x86\UsbBootWatcher.exe", $tmpdrive & $WinFol & "\system32\", 1)
			FileCopy(@ScriptDir & "\makebt\UsbBootWatcher\x86\UsbBootWatcher.conf", $tmpdrive & $WinFol & "\system32\", 1)
		EndIf
		;	If Not FileExists($tmpdrive & $WinFol & "\SysWOW64") Then
		;	; _GUICtrlStatusBar_SetText($hStatus," FileCopy NUSB3 - wait ...", 0)
		;		FileCopy(@ScriptDir & "\makebt\NUSB3\nusb3hub\nusb3hub.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
		;		FileCopy(@ScriptDir & "\makebt\NUSB3\nusb3hub\nusb3hub.inf", $tmpdrive & $WinFol & "\inf\", 1)
		;		FileCopy(@ScriptDir & "\makebt\NUSB3\nusb3hub\nusb3hub.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
		;
		;		FileCopy(@ScriptDir & "\makebt\NUSB3\nusb3xhc\nusb3xhc.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
		;		FileCopy(@ScriptDir & "\makebt\NUSB3\nusb3xhc\nusb3xhc.inf", $tmpdrive & $WinFol & "\inf\", 1)
		;		FileCopy(@ScriptDir & "\makebt\NUSB3\nusb3xhc\nusb3xhc.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
		;	EndIf
	EndIf
	If GUICtrlRead($waitbtAdd) = $GUI_CHECKED Then
		; _GUICtrlStatusBar_SetText($hStatus," Adding waitbt Service for USB - wait ...", 0)
		RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_systemdst_waitbt.reg", @ScriptDir, @SW_HIDE)
		If FileExists($tmpdrive & $WinFol & "\SysWOW64") Then
			FileCopy(@ScriptDir & "\makebt\waitbt\amd64\waitbt.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
		Else
			FileCopy(@ScriptDir & "\makebt\waitbt\x86\waitbt.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
		EndIf
	EndIf

	; HKLM_SYSTEM_Add.reg
	; always
	RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_systemdst_Add_XP.reg", @ScriptDir, @SW_HIDE)

	If GUICtrlRead($RegAMDAHCI) = $GUI_CHECKED Then
		; _GUICtrlStatusBar_SetText($hStatus," Add AMD AHCI Driver - wait ...", 0)
		If FileExists($tmpdrive & $WinFol & "\SysWOW64") Then
			If Not FileExists($tmpdrive & $WinFol & "\system32\drivers\ahcix64.sys") Then
				RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_systemdst_AMD_AHCIx64.reg", @ScriptDir, @SW_HIDE)
				FileCopy(@ScriptDir & "\makebt\AMD_AHCI\x64\ahcix64.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
				FileCopy(@ScriptDir & "\makebt\AMD_AHCI\x64\ahcix64.inf", $tmpdrive & $WinFol & "\inf\", 1)
				FileCopy(@ScriptDir & "\makebt\AMD_AHCI\x64\ahcix64.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
			EndIf
		Else
			If Not FileExists($tmpdrive & $WinFol & "\system32\drivers\ahcix86.sys") Then
				RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_systemdst_AMD_AHCIx86.reg", @ScriptDir, @SW_HIDE)
				FileCopy(@ScriptDir & "\makebt\AMD_AHCI\x86\ahcix86.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
				FileCopy(@ScriptDir & "\makebt\AMD_AHCI\x86\ahcix86.inf", $tmpdrive & $WinFol & "\inf\", 1)
				FileCopy(@ScriptDir & "\makebt\AMD_AHCI\x86\ahcix86.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
			EndIf
		EndIf
	EndIf

	GUICtrlSetData($ProgressAll, 35)
	If GUICtrlRead($RegIASTOR) = $GUI_CHECKED Then
		; SystemFileRedirect("On")
		If Not FileExists($tmpdrive & $WinFol & "\system32\drivers\IaStor.sys") Then
			_GUICtrlStatusBar_SetText($hStatus," Add iaStor Driver and AHCI Registry Tweaks ", 0)
			RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_systemdst_iaStor.reg", @ScriptDir, @SW_HIDE)
			If FileExists($tmpdrive & $WinFol & "\SysWOW64") Then
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver64\IaStor.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver64\iaAHCI.inf", $tmpdrive & $WinFol & "\inf\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver64\iaStor.inf", $tmpdrive & $WinFol & "\inf\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver64\iaAHCI.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver64\iaStor.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
			Else
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver\IaStor.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver\iaAHCI.inf", $tmpdrive & $WinFol & "\inf\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver\iaStor.inf", $tmpdrive & $WinFol & "\inf\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver\iaAHCI.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
				FileCopy(@ScriptDir & "\makebt\IASTOR\winall\Driver\iaStor.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
			EndIf
		EndIf
		; SystemFileRedirect("Off")
	EndIf

	GUICtrlSetData($ProgressAll, 40)

	If GUICtrlRead($usb3_Menu) = $GUI_CHECKED Then
		If FileExists($tmpdrive & $WinFol & "\SysWOW64") Or Not FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U") Then
			GUICtrlSetState($usb3_Menu, $GUI_DISABLE + $GUI_UNCHECKED)
			If Not FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U") Then $DP_CU_found = 0
		Else
			 _GUICtrlStatusBar_SetText($hStatus," Add USB 3.0 Drivers and Registry Tweaks ", 0)
			For $i = 0 To 15
				; MsgBox(0, "Add USB 3.0 Driver", "Index = " & $i & @CRLF & "File = " & $usb3[$i] & ".inf" & @CRLF & "CU_sub = " & $CU_sub[$i])
				If Not FileExists($tmpdrive & $WinFol & "\system32\drivers\" & $usb3[$i] & ".sys") And FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\" & $usb3[$i] & ".inf") Or FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\" & $usb3[$i] & ".sys") Then
					RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\USB3\" & $usb3[$i] & ".reg", @ScriptDir, @SW_HIDE)
					If FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\x86\" & $usb3[$i] & ".sys") Then
						FileCopy($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\x86\" & $usb3[$i] & ".sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
					ElseIf FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\i386\" & $usb3[$i] & ".sys") Then
						FileCopy($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\i386\" & $usb3[$i] & ".sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
					Else
						FileCopy($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\" & $usb3[$i] & ".sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
					EndIf
					If FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\" & $usb3[$i] & ".inf") Then FileCopy($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\" & $usb3[$i] & ".inf", $tmpdrive & $WinFol & "\inf\", 1)
					If FileExists($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\" & $usb3[$i] & ".cat") Then FileCopy($tmpdrive & $WinFol & "\DriverPacks\C\U\" & $CU_sub[$i] & "\" & $usb3[$i] & ".cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
				EndIf
			Next
			Sleep(1000)
		EndIf
	EndIf

	If GUICtrlRead($Scsi_Menu) = $GUI_CHECKED Then
		If FileExists($tmpdrive & $WinFol & "\SysWOW64") Or Not FileExists($tmpdrive & $WinFol & "\DriverPacks\M") Then
			GUICtrlSetState($Scsi_Menu, $GUI_DISABLE + $GUI_UNCHECKED)
			If Not FileExists($tmpdrive & $WinFol & "\DriverPacks\M") Then $DP_M_found = 0
		Else
			 _GUICtrlStatusBar_SetText($hStatus," Add MassStorage Drivers and Registry Tweaks ", 0)
			For $i = 0 To 137
				; MsgBox(0, "Add MassStorage Driver", "Index = " & $i & @CRLF & "File = " & $msst[$i] & ".sys" & @CRLF & "Msub = " & $M_sub[$i])
				If Not FileExists($tmpdrive & $WinFol & "\system32\drivers\" & $msst[$i] & ".sys") Or GUICtrlRead($ForceUpdate) = $GUI_CHECKED And FileExists($tmpdrive & $WinFol & "\DriverPacks\M\" & $M_sub[$i] & "\" & $msst[$i] & ".sys") Then
					RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\MSST\" & $msst[$i] & ".reg", @ScriptDir, @SW_HIDE)
					FileCopy($tmpdrive & $WinFol & "\DriverPacks\M\" & $M_sub[$i] & "\" & $msst[$i] & ".sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
					FileCopy($tmpdrive & $WinFol & "\DriverPacks\M\" & $M_sub[$i] & "\" & $msst[$i] & ".inf", $tmpdrive & $WinFol & "\inf\", 1)
					FileCopy($tmpdrive & $WinFol & "\DriverPacks\M\" & $M_sub[$i] & "\" & $msst[$i] & ".cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
				EndIf
			Next
			If Not FileExists($tmpdrive & $WinFol & "\inf\iaAHCI.inf") Or GUICtrlRead($ForceUpdate) = $GUI_CHECKED And FileExists($tmpdrive & $WinFol & "\DriverPacks\M\" & $M_sub[64] & "\iaAHCI.inf") Then
				FileCopy($tmpdrive & $WinFol & "\DriverPacks\M\" & $M_sub[64] & "\iaAHCI.inf", $tmpdrive & $WinFol & "\inf\", 1)
			EndIf
		EndIf
	EndIf

	; set DevicePath to KTD values - support of WINDOWS\DriverPacks\M and C\U
	If GUICtrlRead($usb3_Menu) = $GUI_CHECKED Or GUICtrlRead($Scsi_Menu) = $GUI_CHECKED Then
		RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_systemdst_KTD_SystemRoot_DP.reg", @ScriptDir, @SW_HIDE)
	EndIf

	If GUICtrlRead($RegSysAdd) = $GUI_CHECKED Then
		; _GUICtrlStatusBar_SetText($hStatus," Add Drivers from makebt\drivers\XP - wait ...", 0)
		If FileExists($tmpdrive & $WinFol & "\SysWOW64") Then
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x64\*.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x64\*.inf", $tmpdrive & $WinFol & "\inf\", 1)
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x64\*.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x64\*.dll", $tmpdrive & $WinFol & "\system32\", 1)
		Else
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x86\*.sys", $tmpdrive & $WinFol & "\system32\drivers\", 1)
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x86\*.inf", $tmpdrive & $WinFol & "\inf\", 1)
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x86\*.cat", $tmpdrive & $WinFol & "\system32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\", 1)
			FileCopy(@ScriptDir & "\makebt\drivers\XP_x86\*.dll", $tmpdrive & $WinFol & "\system32\", 1)
		EndIf
	EndIf

	; MsgBox(0, "System Registry Update Ready", "Image Update System Registry Ready")

	RunWait(@ComSpec & " /c reg unload HKLM\systemdst", @ScriptDir, @SW_HIDE)

	GUICtrlSetData($ProgressAll, 45)

	If GUICtrlRead($minlogon) = $GUI_CHECKED Then
		_GUICtrlStatusBar_SetText($hStatus," Add minlogon in Default Registry on Drive " & $tmpdrive, 0)
		If FileExists($tmpdrive & $WinFol & "\System32\config\default") Then
			RunWait(@ComSpec & " /c reg load HKLM\defaultdst " & $tmpdrive & $WinFol & "\System32\config\default", @ScriptDir, @SW_HIDE)
			RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_defaultdst_minixp.reg", @ScriptDir, @SW_HIDE)
			RunWait(@ComSpec & " /c reg unload HKLM\defaultdst", @ScriptDir, @SW_HIDE)
		Else
		;	$inst_valid=0
		;	MsgBox(48, " config\default Registry Not Found ", "Unable to Load default Registry ", 3)
		EndIf
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Update of SOFTWARE Registry in Drive " & $tmpdrive, 0)
	; always
	; If GUICtrlRead($RegSoftAdd) = $GUI_CHECKED Then
	RunWait(@ComSpec & " /c reg load HKLM\softwaredst " & $tmpdrive & $WinFol & "\system32\config\software", @ScriptDir, @SW_HIDE)
	If GUICtrlRead($minlogon) = $GUI_CHECKED Then
		RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_softwaredst_minixp.reg", @ScriptDir, @SW_HIDE)
	Else
		RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_softwaredst_Add.reg", @ScriptDir, @SW_HIDE)
	EndIf
	; set DevicePath to KTD values - support of WINDOWS\DriverPacks\M and C\U
	If GUICtrlRead($usb3_Menu) = $GUI_CHECKED Or GUICtrlRead($Scsi_Menu) = $GUI_CHECKED Then
		RunWait(@ComSpec & " /c reg import makebt\registry_tweaks\HKLM_softwaredst_DevicePath_KTD.reg", @ScriptDir, @SW_HIDE)
	EndIf
	$ComStartMenu = StringMid(RegRead('HKLM\softwaredst\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Common Start Menu'), 3)
	; MsgBox(0, "Software Registry Update Ready", "Image Update Software Registry Ready")
	RunWait(@ComSpec & " /c reg unload HKLM\softwaredst", @ScriptDir, @SW_HIDE)
	; EndIf

	If GUICtrlRead($minlogon) = $GUI_CHECKED Then
		; _GUICtrlStatusBar_SetText($hStatus," Add minlogon to Drive " & $tmpdrive, 0)
		; Use minlogon renamed as winlogon
		FileCopy(@ScriptDir & "\makebt\minlogon.exe", $tmpdrive & $WinFol & "\system32\", 1)
		FileMove($tmpdrive & $WinFol & "\system32\minlogon.exe", $tmpdrive & $WinFol & "\system32\winlogon.exe", 1)
		SystemFileRedirect("Off")
		If Not FileExists($tmpdrive & "\Documents and Settings\Default User") Then
			DirCreate($tmpdrive & "\Documents and Settings\Default User")
		EndIf
		SystemFileRedirect("On")
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Registry Updated in Drive " & $tmpdrive, 0)
	GUICtrlSetData($ProgressAll, 50)
	Sleep(1000)

	If GUICtrlRead($EWFAdd) = $GUI_CHECKED Then
		_GUICtrlStatusBar_SetText($hStatus," Adding EWF Manager to Drive " & $tmpdrive, 0)
		RunWait(@ComSpec & " /c xcopy.exe " & '"' & @ScriptDir & "\EWF_INST\WINDOWS\*.*" & '"' & " " & '"' & $tmpdrive & $WinFol & "\" & '"' & " /i /k /e /r /y /h", @ScriptDir, @SW_HIDE)
		RunWait(@ComSpec & " /c xcopy.exe " & '"' & @ScriptDir & "\EWF_INST\Program Files\*.*" & '"' & " " & '"' & $tmpdrive & "\Program Files\" & '"' & " /i /k /e /r /y /h", @ScriptDir, @SW_HIDE)
		;	If FileExists($tmpdrive & "\Documents and Settings\All Users\Start Menu\Programs") Then
		;		RunWait(@ComSpec & " /c xcopy.exe " & '"' & @ScriptDir & "\EWF_INST\Start Menu\Programs\*.*" & '"' & " " & '"' & $tmpdrive & "\Documents and Settings\All Users\Start Menu\Programs\" & '"' & " /i /k /e /r /y /h", @ScriptDir, @SW_HIDE)
		;	ElseIf FileExists($tmpdrive & "\Documents and Settings\All Users\Menu Start") Then
		;		RunWait(@ComSpec & " /c xcopy.exe " & '"' & @ScriptDir & "\EWF_INST\Start Menu\Programs\*.*" & '"' & " " & '"' & $tmpdrive & "\Documents and Settings\All Users\Menu Start\" & '"' & " /i /k /e /r /y /h", @ScriptDir, @SW_HIDE)
		;	ElseIf FileExists($tmpdrive & "\Documents and Settings\All Users\Start Menu") Then
		;		RunWait(@ComSpec & " /c xcopy.exe " & '"' & @ScriptDir & "\EWF_INST\Start Menu\Programs\*.*" & '"' & " " & '"' & $tmpdrive & "\Documents and Settings\All Users\Start Menu\" & '"' & " /i /k /e /r /y /h", @ScriptDir, @SW_HIDE)
		;	EndIf
		RunWait(@ComSpec & " /c xcopy.exe " & '"' & @ScriptDir & "\EWF_INST\Start Menu\Programs\*.*" & '"' & " " & '"' & $tmpdrive & $ComStartMenu & "\" & '"' & " /i /k /e /r /y /h", @ScriptDir, @SW_HIDE)

		$val = RunWait(@ComSpec & " /c reg load HKLM\loaded_SYSTEM " & '"' & $tmpdrive & "\WINDOWS\system32\config\system" & '"', @ScriptDir, @SW_HIDE)
		$val = RunWait(@ComSpec & " /c reg load HKLM\loaded_SOFTWARE " & '"' & $tmpdrive & "\WINDOWS\system32\config\software" & '"', @ScriptDir, @SW_HIDE)

		$val=RunWait(@ComSpec & " /c SetACL.exe  -on " & '"' & "HKEY_LOCAL_MACHINE\loaded_SYSTEM\ControlSet001\Enum\Root" & '"' & " -ot reg -actn ace -ace " & '"' & "n:S-1-5-32-544;p:full;s:y" & '"', @ScriptDir & "\AIK_Tools\" & $PArch, @SW_HIDE)
		$val=RunWait(@ComSpec & " /c SetACL.exe  -on " & '"' & "HKEY_LOCAL_MACHINE\loaded_SYSTEM\ControlSet002\Enum\Root" & '"' & " -ot reg -actn ace -ace " & '"' & "n:S-1-5-32-544;p:full;s:y" & '"', @ScriptDir & "\AIK_Tools\" & $PArch, @SW_HIDE)
		$val = ShellExecuteWait(@WindowsDir & "\regedit.exe", "/S " & '"' & @ScriptDir & "\EWF_INST\ewf_xp_loaded.reg" & '"', "", "open", @SW_HIDE)

		RunWait(@ComSpec & " /c reg unload HKLM\loaded_SYSTEM", @ScriptDir, @SW_HIDE)
		RunWait(@ComSpec & " /c reg unload HKLM\loaded_SOFTWARE", @ScriptDir, @SW_HIDE)
	EndIf

	GUICtrlSetData($ProgressAll, 60)

	If GUICtrlRead($HalKernAdd) = $GUI_CHECKED And FileExists($tmpdrive & "\NTLDR") And $NTLDR_BS And FileExists($tmpdrive & "\boot.ini") Then
		_GUICtrlStatusBar_SetText($hStatus," Adding halkern files to Drive " & $tmpdrive, 0)
		FileCopy(@ScriptDir & "\makebt\halkern\*.dll", $tmpdrive & $WinFol & "\system32\", 1)
		FileCopy(@ScriptDir & "\makebt\halkern\*.exe", $tmpdrive & $WinFol & "\system32\", 1)
		FileSetAttrib($tmpdrive & "\boot.ini", "-RSH")
		FileCopy($tmpdrive & "\boot.ini", $tmpdrive & "\boot_ini.txt", 1)
		IniWriteSection($tmpdrive & "\boot.ini", "Boot Loader", "Timeout=10" & @LF & _
		"Default=multi(0)disk(0)rdisk(0)partition(1)" & $WinFol)
		IniWriteSection($tmpdrive & "\boot.ini", "Operating Systems", _
		"multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & '"LAST CONFIG - XP Pro (Last Configuration)"' & " /noexecute=optin /fastdetect")
		FileWriteLine($tmpdrive & "\boot.ini", "multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & _
		'"MP HALMACPI - XP Pro (ACPI Multiprocessor PC) for multi-core, hyperthreading"' & "   /noexecute=optin /fastdetect /kernel=ntkrmp.exe /hal=halmacpi.dll")
		FileWriteLine($tmpdrive & "\boot.ini", "multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & _
		'"UP HALAACPI - XP Pro (ACPI Uniprocessor PC) for single-core, no hyperthreading"' & " /noexecute=optin /fastdetect /kernel=ntkrup.exe /hal=halaacpi.dll")
		FileWriteLine($tmpdrive & "\boot.ini", "multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & _
		'"UP HALACPI  - XP Pro (ACPI PC) for most compatability on ACPI computers"' & "        /noexecute=optin /fastdetect /kernel=ntkrup.exe /hal=halacpi.dll")
		FileWriteLine($tmpdrive & "\boot.ini", "multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & _
		'"MP HALMPS   - XP Pro (MPS Multiprocessor PC) for multi-core Xeons"' & "              /noexecute=optin /fastdetect /kernel=ntkrmp.exe /hal=halmps.dll")
		FileWriteLine($tmpdrive & "\boot.ini", "multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & _
		'"UP HALAPIC  - XP Pro (MPS Uniprocessor PC)  for single-core Xeons"' & "              /noexecute=optin /fastdetect /kernel=ntkrup.exe /hal=halapic.dll")
		FileWriteLine($tmpdrive & "\boot.ini", "multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & _
		'"UP HALSTAN  - XP Pro (Standard PC) for old non-ACPI computers"' & "                  /noexecute=optin /fastdetect /kernel=ntkrup.exe /hal=halstan.dll")
		FileWriteLine($tmpdrive & "\boot.ini", "multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & _
		'"MP HALSP    - XP Pro (Compaq SystemPro Multiprocessor PC)"' & "                      /noexecute=optin /fastdetect /kernel=ntkrmp.exe /hal=halsp.dll")
	Else
		GUICtrlSetState($HalKernAdd, $GUI_DISABLE + $GUI_UNCHECKED)
	EndIf

	FileCopy(@ScriptDir & "\makebt\PS.exe", $tmpdrive & $WinFol & "\system32\", 1)

	If FileExists($tmpdrive & $WinFol & "\system32\drivers\wvblk32.sys") Then
		$driver_flag = 1
	ElseIf FileExists($tmpdrive & $WinFol & "\system32\drivers\firadisk.sys") Then
		$driver_flag = 2
	Else
		$driver_flag = 0
	EndIf

	If GUICtrlRead($PostFixAdd) = $GUI_CHECKED Then
		_GUICtrlStatusBar_SetText($hStatus," Add POST_FIX_XP  Folder to Drive " & $tmpdrive, 0)
		RunWait(@ComSpec & " /c xcopy.exe " & '"' & @ScriptDir & "\POST_FIX_XP\*.*" & '"' & " " & '"' & $tmpdrive & "\POST_FIX_XP\" & '"' & " /i /k /e /r /y /h", @ScriptDir, @SW_HIDE)
	EndIf

	GUICtrlSetData($ProgressAll, 70)
	; MsgBox(0, "Image Update Ready", "Image Update FileCopy Ready")

	Sleep(3000)

	Return $val
EndFunc   ;==> _XP_Update
;===================================================================================================

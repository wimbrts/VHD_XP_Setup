#RequireAdmin
#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.14.5 + file SciTEUser.properties in your UserProfile e.g. C:\Documents and Settings\UserXP Or C:\Users\User-10

 Author:        WIMB  -  April 11, 2019

 Program:       VHD_XP_Create_x86.exe - Version 8.7 in rule 150
	part of IMG_XP Package and used to Create VHD file for Install of XP

 Script Function:

 Credits:
	JFX for making WinNTSetup2 to Install Windows 2k/XP/2003/Vista/7/8 x86/x64 - http://www.msfn.org/board/topic/149612-winntsetup-v2/
	chenall, tinybit and Bean for making Grub4dos - http://code.google.com/p/grub4dos-chenall/downloads/list
	karyonix for making FiraDisk driver- http://reboot.pro/topic/8804-firadisk-latest-00130/
	Sha0 for making WinVBlock driver - http://reboot.pro/topic/8168-winvblock/
	Olof Lagerkvist for ImDisk virtual disk driver - http://www.ltr-data.se/opencode.html#ImDisk and http://reboot.pro/index.php?showforum=59
	Uwe Sieber for making ListUsbDrives - http://www.uwe-sieber.de/english.html
	Dariusz Stanislawek for the DS File Ops Kit (DSFOK) - http://members.ozemail.com.au/~nulifetv/freezip/freeware/
	cdob and maanu to Fix Win7 for booting from USB - http://reboot.pro/topic/14186-usb-hdd-boot-and-windows-7-sp1/
	marv for making UsbBootWatcher - https://github.com/vavrecan/usb-boot-watcher and http://www.911cd.net/forums//index.php?showtopic=22473

	More Info on booting Win 7 VHD from grub4dos menu by using FiraDisk Or WinVBlock driver:
	http://reboot.pro/topic/9830-universal-hdd-image-files-for-xp-and-windows-7/ Or http://www.911cd.net/forums//index.php?showtopic=23553
	Boot Windows 7 from USB - http://reboot.pro/index.php?showforum=77
	Boot Windows 7 from USB - karyonix - http://reboot.pro/index.php?showtopic=9196

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
Global $TargetDrive="", $ProgressAll, $Paused, $g4d_vista=0, $mk_bcd=0, $ntfs_bs=1, $bs_valid=0, $g4d=0, $g4dmbr=0
Global $hStatus, $hGuiParent, $GO, $EXIT
Global $TargetSel, $Target, $bcdedit="", $bcd_flag = 0, $w7_nr=1
Global $TargetSpaceAvail=0, $TargetSize, $TargetFree, $FSvar
Global $DriveType="Fixed", $usbfix=0, $SysDriveType="Fixed", $Sysusbfix=0
Global $vhd_name="XPSRC", $img_fname="", $img_fext=".img", $image_file="", $img_fsize
Global $TCyl=183, $THds=255, $TSec=63

Global $ISO_GUI, $ISO_Select, $xpiso="", $grldrUpd, $BlackFix, $Inst_Chk, $mem_Chk, $IsoSize, $iso_size=0

Global $ComboSize, $vhd_size="2000", $NTFS_Compr

Global $WinDrv, $WinDrvSel, $WinDrvSize, $WinDrvFree, $WinDrvFileSys, $WinDrvSpaceAvail=0, $WinDrvDrive=""

Global $OS_drive = StringLeft(@WindowsDir, 2)
Global $ProgDrive = StringLeft(@ScriptDir, 2)

Global $Create="", $TempFolder = @ScriptDir & "\VHD_W7\temp", $TempFolderSpaceAvail=0

Global $str = "", $bt_files[10] = ["\makebt\VhdTool.exe", "\makebt\dsfo.exe", "\makebt\dsfi.exe", "\makebt\BootSect.exe", "\makebt\win_xp.mbr", "\makebt\winvblock.ima", _
"\makebt\listusbdrives\ListUsbDrives.exe", "\makebt\grldr.mbr", "\makebt\grldr", "\makebt\menu.lst"]

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

If Not FileExists(@ScriptDir & "\makebt\Boot_XP") Then DirCreate(@ScriptDir & "\makebt\Boot_XP")

; dmadmin in x64 found by using @WindowsDir & "\system32\dmadmin.exe" instead of @SystemDir
; Thanks to Lancelot and blue_life for solving x64 issue
; Wow64 must be Disabled to find dmadmin in x64 OS and Then again Enabled since otherwise it will effect DirRemove and DirCreate following in the program
; If @OSArch = "X64" Then DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
; find dmadmin in x64 OS (File dmadmin.exe is used to get MBR-code necessary in _FormatUSB Function)
; If @OSArch = "X64" Then DllCall("kernel32.dll", "int", "Wow64EnableWow64FsRedirection", "int", 1)
; Instead we can use Function SystemFileRedirect given by Lancelot and blue_life for x64 Support
SystemFileRedirect("On")
If Not FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
	If FileExists(@WindowsDir & "\system32\bcdedit.exe") And @OSArch = "X86" Then
		FileCopy(@WindowsDir & "\system32\bcdedit.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf
SystemFileRedirect("Off")

If Not FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then
	If FileExists($OS_drive & "\BOOTFONT.BIN") And @OSVersion = "WIN_XP" Then
		FileCopy($OS_drive & "\BOOTFONT.BIN", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", "-RSH")
	EndIf
EndIf

If Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") Then
	If FileExists($OS_drive & "\NTDETECT.COM") And @OSVersion = "WIN_XP" Then
		FileCopy($OS_drive & "\NTDETECT.COM", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", "-RSH")
	EndIf
EndIf

If Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then
	If FileExists($OS_drive & "\NTLDR") And @OSVersion = "WIN_XP" Then
		FileCopy($OS_drive & "\NTLDR", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTLDR", "-RSH")
	EndIf
EndIf

;	If @OSVersion <> "WIN_7" Then
;		MsgBox(48, "WARNING - OS Version is Not Valid ", "VHD_XP_Create.exe is for Windows 7 Or 7 PE ")
;		; Exit
;	EndIf

If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")

; If FileExists(@ScriptDir & "\VHD_W7\temp") Then DirRemove(@ScriptDir & "\VHD_W7\temp",1)
; If Not FileExists(@ScriptDir & "\VHD_W7\temp") Then DirCreate(@ScriptDir & "\VHD_W7\temp")
If FileExists($TempFolder) Then DirRemove($TempFolder,1)
If Not FileExists($TempFolder) Then DirCreate($TempFolder)

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "TogglePause")

; Creating GUI and controls
$hGuiParent = GUICreate(" VHD_XP_Create - Make VHD file for Install of XP", 400, 430, 100, _
		40, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")

GUICtrlCreateGroup("XP Setup Source ------- Prog x86 Version 8.7 ", 18, 10, 364, 70)

GUICtrlCreateLabel( "XP Setup ISO file", 32, 29)
$IsoSize = GUICtrlCreateLabel( "", 160, 29, 50, 15, $ES_READONLY)
$ISO_GUI = GUICtrlCreateInput($ISO_Select, 32, 45, 200, 20, $ES_READONLY)
$ISO_Select = GUICtrlCreateButton("...", 238, 46, 26, 18)
GUICtrlSetTip($ISO_Select, " Select your XP Setup ISO file in Root of Harddisk Drive " & @CRLF _
& " for Install of XP in VHD Image file - WinVBlock driver ")
GUICtrlSetOnEvent($ISO_Select, "_iso_fsel")

; GUICtrlCreateGroup("Settings ", 18, 130, 364, 150)
GUICtrlCreateGroup("Settings ", 18, 85, 364, 150)

$grldrUpd = GUICtrlCreateCheckbox("", 32, 110, 17, 17)
GUICtrlSetTip($grldrUpd, " Update Grub4dos grldr Version on Boot Drive " & @CRLF _
& " Forces Update grldr.mbr and Add Grub4dos to Boot Manager Menu ")
GUICtrlCreateLabel( "Update Grub4dos grldr Version on Boot Drive ", 56, 110)

$BlackFix = GUICtrlCreateCheckbox("", 32, 135, 17, 17)
GUICtrlSetTip($BlackFix, " Black Screen Fix to prevent freezing of TXT-mode XP Setup " & @CRLF _
& " map --e820cycles=0  means int15 never hook by Grub4dos ")
GUICtrlCreateLabel( "Black Screen Fix - In Grub4dos use map --e820cycles=0", 56, 135)

$Inst_Chk = GUICtrlCreateCheckbox("", 32, 160, 17, 17)
GUICtrlSetTip($Inst_Chk, " Make Entries in Gru4dos menu.lst on Boot Drive " & @CRLF _
& " for Install of XP in VHD Image file - WinVBlock driver " & @CRLF _
& " Select XP Setup ISO file for Install from CD Menu Or " & @CRLF _
& " Make NT Setup Install Menu and later use WinNTSetup3 ")
GUICtrlCreateLabel( "Make Grub4dos Boot Menu on Boot Drive - Install XP in VHD ", 56, 160)

$mem_Chk = GUICtrlCreateCheckbox("", 32, 185, 17, 17)
GUICtrlSetTip($mem_Chk, " Load XP Setup ISO in RAM - use mem Option " & @CRLF _
& " NOT preferred for contiguous ISO above 700 MB ")
GUICtrlCreateLabel( "Load XP Setup ISO in RAM - use mem Option ", 56, 185)

$NTFS_Compr = GUICtrlCreateCheckbox("", 32, 210, 17, 17)
GUICtrlSetTip(-1, " Format VHD with NTFS Compression ")
GUICtrlCreateLabel( "Use Compression for NTFS Format of VHD ", 56, 210)

GUICtrlCreateGroup("Target", 18, 252, 364, 89)

GUICtrlCreateLabel( "Boot Drive", 32, 273)
$Target = GUICtrlCreateInput($TargetSel, 110, 270, 45, 20, $ES_READONLY)
$TargetSel = GUICtrlCreateButton("...", 161, 271, 26, 18)
GUICtrlSetTip(-1, " Select your Boot Drive - Active FAT32 USB-drive for Boot Files " & @CRLF _
& " On Boot Drive make Grub4dos entries for Install of XP in VHD located on NTFS System Drive ")
GUICtrlSetOnEvent($TargetSel, "_target_drive")
$TargetSize = GUICtrlCreateLabel( "", 203, 264, 100, 15, $ES_READONLY)
$TargetFree = GUICtrlCreateLabel( "", 203, 281, 100, 15, $ES_READONLY)

GUICtrlCreateLabel( "System Drive", 32, 315)
$WinDrv = GUICtrlCreateInput("", 110, 312, 45, 20, $ES_READONLY)
$WinDrvSel = GUICtrlCreateButton("...", 161, 313, 26, 18)
GUICtrlSetTip(-1, " Select NTFS System Drive on local Harddisk where to Create New VHD file " & @CRLF _
& " for Install of XP in VHD located on NTFS drive and using WinVBlock driver ")
GUICtrlSetOnEvent($WinDrvSel, "_WinDrv_drive")
$WinDrvSize = GUICtrlCreateLabel( "", 203, 306, 100, 15, $ES_READONLY)
$WinDrvFree = GUICtrlCreateLabel( "", 203, 323, 100, 15, $ES_READONLY)

GUICtrlCreateLabel( "VHD Size", 305, 290)
$ComboSize = GUICtrlCreateCombo("", 300, 312, 65, 24, $CBS_DROPDOWNLIST)
; GUICtrlSetData($ComboSize,"1.0 GB|1.2 GB|1.4 GB|1.6 GB|1.8 GB|2.0 GB|2.5 GB|3.0 GB|3.5 GB|3.9 GB|7.0 GB|10.0 GB", "2.0 GB")
GUICtrlSetData($ComboSize,"0.4 GB|0.5 GB|0.6 GB|0.7 GB|0.8 GB|0.9 GB|1.0 GB|1.2 GB|1.4 GB|1.6 GB|1.8 GB|2.0 GB|2.5 GB|3.0 GB|3.5 GB|3.9 GB|7.0 GB|10.0 GB", "2.0 GB")

$GO = GUICtrlCreateButton("GO", 235, 360, 70, 30)
GUICtrlSetTip($GO, " Will Create New VHD file on Target System Drive ")
$EXIT = GUICtrlCreateButton("EXIT", 320, 360, 60, 30)
GUICtrlSetState($GO, $GUI_DISABLE)
GUICtrlSetOnEvent($GO, "_Go")
GUICtrlSetOnEvent($EXIT, "_Quit")

$ProgressAll = GUICtrlCreateProgress(16, 368, 203, 16, $PBS_SMOOTH)

$hStatus = _GUICtrlStatusBar_Create($hGuiParent, -1, "", $SBARS_TOOLTIPS)
Global $aParts[3] = [310, 350, -1]
_GUICtrlStatusBar_SetParts($hStatus, $aParts)

_GUICtrlStatusBar_SetText($hStatus," Select Boot and System Drive and XP Setup ISO file", 0)

DisableMenus(1)

GUICtrlSetState($ISO_Select, $GUI_DISABLE)

GUICtrlSetState($grldrUpd, $GUI_ENABLE)
GUICtrlSetState($BlackFix, $GUI_CHECKED + $GUI_ENABLE)
GUICtrlSetState($Inst_Chk, $GUI_UNCHECKED + $GUI_DISABLE)
GUICtrlSetState($mem_Chk, $GUI_UNCHECKED + $GUI_DISABLE)

GUICtrlSetState($NTFS_Compr, $GUI_ENABLE + $GUI_UNCHECKED)

GUICtrlSetState($ComboSize, $GUI_ENABLE)
GUICtrlSetState($TargetSel, $GUI_ENABLE)
GUICtrlSetState($WinDrvSel, $GUI_ENABLE)

GUISetState(@SW_SHOW)

;===================================================================================================
While 1
	CheckGo()
    Sleep(1000)
WEnd   ;==> Loop
Func CheckGo()
	If $WinDrvDrive <> "" Then
		GUICtrlSetState($GO, $GUI_ENABLE)
		If $xpiso = "" Then
			_GUICtrlStatusBar_SetText($hStatus," Make empty VHD for NT Setup Or Select XP Setup ISO file", 0)
		Else
			_GUICtrlStatusBar_SetText($hStatus," Make VHD on System Drive for Install of XP in VHD", 0)
		EndIf
	Else
		GUICtrlSetState($GO, $GUI_DISABLE)
		_GUICtrlStatusBar_SetText($hStatus," Select Boot and System Drive and XP Setup ISO file", 0)
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
Func _iso_fsel()
	Local $tmpfsel, $len, $pos, $iso_file="", $iso_fname="", $iso_fext=""

	DisableMenus(1)
	GUICtrlSetData($ISO_GUI, "")
	GUICtrlSetData($IsoSize, "")
	$xpiso = ""
	$iso_size = 0
	GUICtrlSetState($Inst_Chk, $GUI_UNCHECKED + $GUI_ENABLE)
	GUICtrlSetState($mem_Chk, $GUI_UNCHECKED + $GUI_DISABLE)

	$tmpfsel = FileOpenDialog("Select XP Setup ISO File", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISO File ( *.iso; )")
	If @error Then
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($tmpfsel, "\", 0, -1)
	If $pos = 0 Then
		MsgBox(48,"ERROR - Selection Invalid", "Selection Invalid - No Backslash Found" & @CRLF & @CRLF & "Selection = " & $tmpfsel)
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($tmpfsel, "\", 0, -2)
	If $pos <> 0 Then
		MsgBox(48,"ERROR - Selection Invalid", "Selection Invalid - Second Backslash Found" & @CRLF & @CRLF & "Selection = " & $tmpfsel & @CRLF & @CRLF _
		& "Solution - Use simple Path - Use ISO file in root of drive ")
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($tmpfsel, " ", 0, -1)
	If $pos Then
		MsgBox(48,"ERROR - Selection Invalid", "Selection Invalid - Space Found" & @CRLF & @CRLF & "Selection = " & $tmpfsel & @CRLF & @CRLF _
		& "Solution - Use simple Path and FileName without Spaces ")
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($tmpfsel, ":", 0, 1)
	If $pos <> 2 Then
		MsgBox(48,"ERROR - Selection Invalid", "Drive Invalid - : Not found" & @CRLF & @CRLF & "Selection = " & $tmpfsel)
		DisableMenus(0)
		Return
	EndIf

	;	If StringLeft($tmpfsel, 2) <> $WinDrvDrive Then
	;		MsgBox(48,"ERROR - Invalid Location for ISO File ", " XP Setup ISO file must be on TargetDrive  " & @CRLF & @CRLF & " Selection = " & $tmpfsel)
	;		DisableMenus(0)
	;		Return
	;	EndIf

	$len = StringLen($tmpfsel)
	$pos = StringInStr($tmpfsel, "\", 0, -1)
	$iso_file = StringRight($tmpfsel, $len-$pos)
	$len = StringLen($iso_file)
	$pos = StringInStr($iso_file, ".", 0, -1)
	$iso_fext = StringRight($iso_file, $len-$pos)
	$iso_fname = StringLeft($iso_file, $pos-1)
	If $iso_fext = "iso" Then
		If $len > 12 Or StringRegExp($iso_fname, "[^A-Z0-9a-z-_]") Or StringRegExp($iso_fext, "[^A-Za-z_]") Then
			MsgBox(48, " File or FileName NOT Valid ", "Selected = " & $iso_file & @CRLF & @CRLF _
			& "IMG FileNames must be conform DOS 8.3 " & @CRLF & "Allowed Characters 0-9 A-Z a-z - _  ")
			DisableMenus(0)
			Return
		Else
			; MsgBox(48,"OK - ISO file", "OK - Valid  ISO File" & @CRLF & @CRLF & "Selection = " & $tmpfsel)
		EndIf
	Else
		MsgBox(48,"ERROR - Selection Invalid", "Not valid  as ISO File" & @CRLF & @CRLF & "Selection = " & $tmpfsel)
		DisableMenus(0)
		Return
	EndIf

	$xpiso = $tmpfsel
	$iso_size = FileGetSize($xpiso)
	$iso_size = Round($iso_size / 1024 / 1024)
	GUICtrlSetState($Inst_Chk, $GUI_CHECKED)
	;	If $iso_size > 1000 Then
	;		GUICtrlSetState($mem_Chk, $GUI_UNCHECKED)
	;	Else
	;		GUICtrlSetState($mem_Chk, $GUI_CHECKED)
	;	EndIf

	GUICtrlSetData($ISO_GUI, $xpiso)
	GUICtrlSetData($IsoSize, $iso_size & " MB")
	DisableMenus(0)
EndFunc   ;==> _iso_fsel
;===================================================================================================
Func _target_drive()
	Local $TargetSelect, $Tdrive, $FSvar, $valid = 0, $ValidDrives, $RemDrives
	Local $NoDrive[2] = ["A:", "B:"], $FileSys[3] = ["NTFS", "FAT32","FAT"]
	Local $pos, $fs_ok=0

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
	GUICtrlSetData($TargetSize, "")
	GUICtrlSetData($TargetFree, "")

	$xpiso = ""
	GUICtrlSetData($ISO_GUI, "")
	GUICtrlSetState($Inst_Chk, $GUI_UNCHECKED + $GUI_DISABLE)
	GUICtrlSetState($mem_Chk, $GUI_UNCHECKED + $GUI_DISABLE)

	$TargetSelect = FileSelectFolder("Select Boot Drive e.g. Active FAT32 USB-drive for Boot Files ", "")
	If @error Then
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($TargetSelect, "\", 0, -1)
	If $pos = 0 Then
		MsgBox(48,"ERROR - Path Invalid", "Path Invalid - No Backslash Found" & @CRLF & @CRLF & "Selected Path = " & $TargetSelect)
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($TargetSelect, " ", 0, -1)
	If $pos Then
		MsgBox(48,"ERROR - Path Invalid", "Path Invalid - Space Found" & @CRLF & @CRLF & "Selected Path = " & $TargetSelect)
		 DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($TargetSelect, ":", 0, 1)
	If $pos <> 2 Then
		MsgBox(48,"ERROR - Path Invalid", "Drive Invalid - : Not found" & @CRLF & @CRLF & "Selected Path = " & $TargetSelect)
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
			MsgBox(48, "ERROR - Drive NOT Valid ", "Drive NOT Valid as Boot Drive ", 3)
			DisableMenus(0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	NEXT

	If $valid And DriveStatus($Tdrive) <> "READY" Then
		$valid = 0
		MsgBox(48, "ERROR - Drive NOT Ready", "Drive NOT READY", 3)
		DisableMenus(0)
		GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf
	If $valid Then
		$FSvar = DriveGetFileSystem( $Tdrive )
		If $FSvar = "NTFS" Or $FSvar = "FAT32" Or $FSvar = "FAT" Then
			; OK
		Else
			MsgBox(48, "ERROR - Invalid FileSystem", "NTFS Or FAT32 Or FAT FileSystem NOT Found", 3)
			DisableMenus(0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	EndIf
	If $valid Then
		$TargetDrive = $Tdrive
		GUICtrlSetData($Target, $TargetDrive)
		$DriveType=DriveGetType($TargetDrive)
		$TargetSpaceAvail = Round(DriveSpaceFree($TargetDrive))
		GUICtrlSetData($TargetSize, $FSvar & "     " & Round(DriveSpaceTotal($TargetDrive) / 1024, 1) & " GB")
		GUICtrlSetData($TargetFree, "FREE  = " & Round(DriveSpaceFree($TargetDrive) / 1024, 1) & " GB")
		GUICtrlSetState($Inst_Chk, $GUI_CHECKED + $GUI_ENABLE)
	Else
		$TargetDrive = ""
		GUICtrlSetData($Target, "")
		GUICtrlSetData($TargetSize, "")
		GUICtrlSetData($TargetFree, "")
		MsgBox(48, "ERROR - Drive NOT Valid", "Drive NOT Valid as Boot Drive ", 3)
		DisableMenus(0)
		GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
		Return
	EndIf
	DisableMenus(0)
EndFunc   ;==> _target_drive
;===================================================================================================
Func _WinDrv_drive()
	Local $WinDrvSelect, $Tdrive, $FSvar, $valid = 0, $ValidDrives, $RemDrives
	Local $NoDrive[3] = ["A:", "B:", "X:"], $FileSys[1] = ["NTFS"]
	Local $pos

	DisableMenus(1)
	; $IMG_Path = ""
	$ValidDrives = DriveGetDrive( "FIXED" )
	_ArrayPush($ValidDrives, "")
	_ArrayPop($ValidDrives)
	$RemDrives = DriveGetDrive( "REMOVABLE" )
	_ArrayPush($RemDrives, "")
	_ArrayPop($RemDrives)
	_ArrayConcatenate($ValidDrives, $RemDrives)
	; _ArrayDisplay($ValidDrives)

	$WinDrvDrive = ""
	GUICtrlSetData($WinDrv, "")
	GUICtrlSetData($WinDrvFileSys, "")
	GUICtrlSetData($WinDrvSize, "")
	GUICtrlSetData($WinDrvFree, "")

	$WinDrvSelect = FileSelectFolder("Select NTFS System Drive where to make VHD file", "")
	If @error Then
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($WinDrvSelect, "\", 0, -1)
	If $pos = 0 Then
		MsgBox(48,"ERROR - Path Invalid", "Path Invalid - No Backslash Found" & @CRLF & @CRLF & "Selected Path = " & $WinDrvSelect)
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($WinDrvSelect, " ", 0, -1)
	If $pos Then
		MsgBox(48,"ERROR - Path Invalid", "Path Invalid - Space Found" & @CRLF & @CRLF & "Selected Path = " & $WinDrvSelect & @CRLF & @CRLF _
		& "Solution - Use simple Path without Spaces ")
		 DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($WinDrvSelect, ":", 0, 1)
	If $pos <> 2 Then
		MsgBox(48,"ERROR - Path Invalid", "Drive Invalid - : Not found" & @CRLF & @CRLF & "Selected Path = " & $WinDrvSelect)
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
			MsgBox(48, "ERROR - Drive NOT Valid", " Drive A: B: and X: ", 3)
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
			MsgBox(48, "ERROR - Invalid FileSystem", " NTFS FileSystem NOT Found ", 3)
			DisableMenus(0)
			Return
		EndIf
	EndIf
	If $valid Then
		$WinDrvDrive = StringLeft($WinDrvSelect, 2)

		GUICtrlSetData($WinDrv, $WinDrvDrive)
		$WinDrvSpaceAvail = Round(DriveSpaceFree($WinDrvDrive))
		GUICtrlSetData($WinDrvSize, $FSvar & "     " & Round(DriveSpaceTotal($WinDrvDrive) / 1024, 1) & " GB")
		GUICtrlSetData($WinDrvFree, "FREE  = " & Round(DriveSpaceFree($WinDrvDrive) / 1024, 1) & " GB")
	EndIf
	DisableMenus(0)
EndFunc   ;==> _WinDrv_drive
;===================================================================================================
Func _Go()
	Local $i=0, $file, $line

	Local $inst_valid=0, $PSize = "2.0 GB"

	Local $linesplit[20], $inst_disk="", $inst_part="", $mptarget=0, $mpsys = 0
	Local $i, $ikey, $notactiv=0, $xpmbr=0, $count, $activebyte = "00"

	Local $fhan, $mbrsrc

	DisableMenus(1)
	_GUICtrlStatusBar_SetText($hStatus," ", 0)
	GUICtrlSetData($ProgressAll, 0)

	; Better use ListUsbDrives.exe because MBRWiz.exe can give wrong $inst_disk nr when USB-drives are disconnected

	_GUICtrlStatusBar_SetText($hStatus," Checking Target System Drive - wait ...", 0)
	$SysDriveType=DriveGetType($WinDrvDrive)

	If $SysDriveType="Removable" Or $SysDriveType="Fixed" Then
		GUICtrlSetData($ProgressAll, 10)
	Else
		_GUICtrlStatusBar_SetText($hStatus," Select Target System Drive", 0)
		MsgBox(48, "ERROR - Target System Drive NOT Valid", "Target System Drive = " & $WinDrvDrive & " Not Valid " & @CRLF & @CRLF & _
		" Only Removable Or Fixed Drive allowed ", 0)
		DisableMenus(0)
		Return
	EndIf

	If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")

	If FileExists($TempFolder) Then DirRemove($TempFolder,1)
	If Not FileExists($TempFolder) Then DirCreate($TempFolder)

	If FileExists(@ScriptDir & "\makebt\usblist.txt") Then
		FileCopy(@ScriptDir & "\makebt\usblist.txt", @ScriptDir & "\makebt\usblist_bak.txt", 1)
		FileDelete(@ScriptDir & "\makebt\usblist.txt")
	EndIf

	RunWait(@ComSpec & " /c makebt\listusbdrives\ListUsbDrives.exe -a > makebt\usblist.txt", @ScriptDir, @SW_HIDE)

	$usbfix=0
	$Sysusbfix=0
	$file = FileOpen(@ScriptDir & "\makebt\usblist.txt", 0)
	If $file <> -1 Then
		$count = 0
		$mptarget = 0
		$mpsys = 0
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			If $line <> "" Then
				$count = $count + 1
				$linesplit = StringSplit($line, "=")
				$linesplit[1] = StringStripWS($linesplit[1], 3)
				If $linesplit[1] = "MountPoint" And $linesplit[0] = 2 Then
					$linesplit[2] = StringStripWS($linesplit[2], 3)
					If $linesplit[2] = $TargetDrive & "\" Then
						$mptarget = 1
						; MsgBox(0, "TargetDrive Found - OK", " TargetDrive = " & $linesplit[2], 3)
					Else
						$mptarget = 0
					EndIf
					If $linesplit[2] = $WinDrvDrive & "\" Then
						$mpsys = 1
						; MsgBox(0, "WinDrvDrive Found - OK", " WinDrvDrive = " & $linesplit[2], 3)
					Else
						$mpsys = 0
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
				If $mpsys = 1 Then
					If $linesplit[1] = "Bus Type" And $linesplit[0] = 2 Then
						$linesplit[2] = StringStripWS($linesplit[2], 3)
						If $linesplit[2] = "USB" Then
							$Sysusbfix = 1
						Else
							If $linesplit[2] = "ATA" Then
								$Sysusbfix = 0
							EndIf
						EndIf
						;	MsgBox(0, "WinDrvDrive USB or HDD ?", " Bus Type = " & $linesplit[2], 3)
					EndIf
				EndIf
			EndIf
		Wend
		FileClose($file)
	EndIf

	GUICtrlSetData($ProgressAll, 10)
	; MsgBox(0, "TargetDrive - OK", $TargetDrive & "\" & " Drive was found " & @CRLF & "Device Number = " & $inst_disk & @CRLF & "Partition Number = " & $inst_part, 0)

	If GUICtrlRead($ComboSize) = "7.0 GB" And DriveGetFileSystem($WinDrvDrive) <> "NTFS" Then
		MsgBox(48,"ERROR - Invalid FileSystem on Location for Image File ", " NTFS FileSystem needed on Location for Image File " & @CRLF & @CRLF & " Location = " & $WinDrvDrive)
		DisableMenus(0)
		Return
	EndIf
	If GUICtrlRead($ComboSize) = "10.0 GB" And DriveGetFileSystem($WinDrvDrive) <> "NTFS" Then
		MsgBox(48,"ERROR - Invalid FileSystem on Location for Image File ", " NTFS FileSystem needed on Location for Image File " & @CRLF & @CRLF & " Location = " & $WinDrvDrive)
		DisableMenus(0)
		Return
	EndIf

	For $i = 1 To 9
		If Not FileExists($WinDrvDrive & "\" & $vhd_name & $i & ".vhd") Then
			$w7_nr = $i
			ExitLoop
		EndIf
		If $i = 9 Then
			; SystemFileRedirect("Off")
			MsgBox(48, "Error - Too many XPSx.vhd VHD Files ", " Max x = 9 on Drive " & $WinDrvDrive & @CRLF & @CRLF _
			&  " Remove or Rename some VHD Files on Drive " & $WinDrvDrive)
			Exit
		EndIf
	Next

	$PSize = GUICtrlRead($ComboSize)
	If $PSize = "0.4 GB" Then
		$vhd_size="400"
	ElseIf $PSize = "0.5 GB" Then
		$vhd_size="500"
	ElseIf $PSize = "0.6 GB" Then
		$vhd_size="600"
	ElseIf $PSize = "0.7 GB" Then
		$vhd_size="700"
	ElseIf $PSize = "0.8 GB" Then
		$vhd_size="800"
	ElseIf $PSize = "0.9 GB" Then
		$vhd_size="900"
	ElseIf $PSize = "1.0 GB" Then
		$vhd_size="1000"
	ElseIf $PSize = "1.2 GB" Then
		$vhd_size="1200"
	ElseIf $PSize = "1.4 GB" Then
		$vhd_size="1400"
	ElseIf $PSize = "1.6 GB" Then
		$vhd_size="1600"
	ElseIf $PSize = "1.8 GB" Then
		$vhd_size="1800"
	ElseIf $PSize = "2.0 GB" Then
		$vhd_size="2000"
	ElseIf $PSize = "2.5 GB" Then
		$vhd_size="2500"
	ElseIf $PSize = "3.0 GB" Then
		$vhd_size="3000"
	ElseIf $PSize = "3.5 GB" Then
		$vhd_size="3500"
	ElseIf $PSize = "3.9 GB" Then
		$vhd_size="3900"
	ElseIf $PSize = "7.0 GB" Then
		$vhd_size="7000"
	ElseIf $PSize = "10.0 GB" Then
		$vhd_size="10000"
	Else
		$vhd_size="2000"
	EndIf

	;	If $vhd_size < "1600" And $vhd_size <> "10000" Then
	;		$ikey = MsgBox(48+4, "WARNING - VHD Size too Small ", " VHD Size might be too Small - 1.6 GB needed " & @CRLF & @CRLF & " STOP Program and Reset VHD Size ? ", 0)
	;		If $ikey = 6 Then
	;			SystemFileRedirect("Off")
	;			DisableMenus(0)
	;			Return
	;		EndIf
	;	EndIf


	If $SysDriveType="Removable" Or $Sysusbfix Then
		$Create = $TempFolder
		$TempFolderSpaceAvail = Round(DriveSpaceFree($TempFolder))
		If GUICtrlRead($ComboSize) = "7.0 GB" And DriveGetFileSystem($ProgDrive) <> "NTFS" Then
			GUICtrlSetData($ProgressAll, 0)
			_GUICtrlStatusBar_SetText($hStatus," Invalid Drive", 0)
			MsgBox(48,"ERROR - Invalid FileSystem on Program Drive ", " NTFS FileSystem needed on Program Drive " & $ProgDrive)
			DisableMenus(0)
			Return
		EndIf
		If GUICtrlRead($ComboSize) = "10.0 GB" And DriveGetFileSystem($ProgDrive) <> "NTFS" Then
			GUICtrlSetData($ProgressAll, 0)
			_GUICtrlStatusBar_SetText($hStatus," Invalid Drive", 0)
			MsgBox(48,"ERROR - Invalid FileSystem on Program Drive ", " NTFS FileSystem needed on Program Drive " & $ProgDrive)
			DisableMenus(0)
			Return
		EndIf
		If $TempFolderSpaceAvail < $vhd_size + 1024 Then
			MsgBox(48, "STOP - Not enough Space on Program Drive ", " ERROR - Not enough Space on Temp Folder = " & $TempFolder & @CRLF & @CRLF _
			& " Free Space = " & $TempFolderSpaceAvail & " MB " & @CRLF & @CRLF & " New Image Size = " & $vhd_size & " MB ", 0)
			DisableMenus(0)
			Exit
		EndIf
	Else
		$Create = $WinDrvDrive
		If $WinDrvSpaceAvail < $vhd_size + 1024 Then
			MsgBox(48, "ERROR - Not enough Space on Target System Drive ", " ERROR - Not enough Space on Target System Drive " & @CRLF & @CRLF _
			& " Free Space = " & $WinDrvSpaceAvail & " MB " & @CRLF & @CRLF & " New VHD Size = " & $vhd_size & " MB ", 0)
			DisableMenus(0)
			Return
		EndIf
	EndIf

	;	;  _Make_VHD Not used since _New_HDDIMG is doing better.....

	;	If @OSVersion = "WIN_7" Or @OSVersion = "WIN_8" Then
	;		If DriveGetFileSystem($WinDrvDrive) <> "NTFS" Then
	;			MsgBox(48,"ERROR - Invalid FileSystem on Location for Image File ", " NTFS FileSystem needed on Location for Image File " & @CRLF & @CRLF & " Location = " & $WinDrvDrive)
	;			DisableMenus(0)
	;			Return
	;		EndIf
	;		_Make_VHD()
	;	Else

	SystemFileRedirect("On")

	If Not FileExists(@WindowsDir & "\system32\imdisk.exe") Then
		SystemFileRedirect("Off")
		MsgBox(48, "WARNING - Manual Install ImDisk Driver ", "ImDisk Driver needed for Virtual Drive  " _
		& @CRLF & @CRLF & " First Install ImDisk using makebt\imdiskinst.exe ")
		Exit
	EndIf

	If Not FileExists(@WindowsDir & "\system32\fsutil.exe") Then
		SystemFileRedirect("Off")
		MsgBox(48, "WARNING - Manual Install system32\fsutil.exe ", @WindowsDir & "\system32\fsutil.exe needed to make Image File" _
		& @CRLF & @CRLF & " First add fsutil.exe to " & @WindowsDir & "\system32 ")
		Exit
	EndIf

	;	If Not FileExists(@ScriptDir & "\makebt\dmadmin.exe") Then
	;		SystemFileRedirect("Off")
	;		MsgBox(16, "STOP - Missing File dmadmin.exe ", "XP File dmadmin.exe is needed in makebt Folder " & @CRLF _
	;		& "dmadmin.exe is used to Create MBR of Image File " & @CRLF & @CRLF _
	;		& "Solution: Run Program Once in XP Environment " & @CRLF & "Or Copy C:\WINDOWS\system32\dmadmin.exe to makebt Folder ")
	;		Exit
	;	EndIf

	SystemFileRedirect("Off")

	_New_HDDIMG()

	;	EndIf

	Sleep(2000)

	If $Create = $TempFolder Then
		_GUICtrlStatusBar_SetText($hStatus," FileCopy VHD_W7\temp\" & $vhd_name & $w7_nr & ".vhd to " & $WinDrvDrive & " - Wait ....", 0)
		GUICtrlSetData($ProgressAll, 75)
		RunWait(@ComSpec & " /c makebt\VhdTool.exe /convert " & '"' & $TempFolder & "\" & $image_file & '"' & " /quiet ", @ScriptDir, @SW_HIDE)
		Sleep(2000)
		FileMove($TempFolder & "\" & $image_file, $TempFolder & "\" & $vhd_name & $w7_nr & ".vhd", 1)
		; FileMove($TempFolder & "\" & $vhd_name & "temp.PLN", $TempFolder & "\" & $vhd_name & $w7_nr & ".PLN", 1)
		Sleep(2000)
		FileCopy($TempFolder & "\" & $vhd_name & $w7_nr & ".vhd", $WinDrvDrive & "\", 9)
		; FileCopy($TempFolder & $vhd_name & $w7_nr & ".PLN", $WinDrvDrive & "\", 9)
	Else
		RunWait(@ComSpec & " /c makebt\VhdTool.exe /convert " & '"' & $WinDrvDrive & "\" & $image_file & '"' & " /quiet ", @ScriptDir, @SW_HIDE)
		Sleep(2000)
		FileMove($WinDrvDrive & "\" & $image_file, $WinDrvDrive & "\" & $vhd_name & $w7_nr & ".vhd", 1)
	EndIf

	Sleep(2000)

	; Update existing grldr
	If GUICtrlRead($grldrUpd) = $GUI_CHECKED And $TargetDrive <> "" And FileExists($TargetDrive & "\grldr") Then
		FileSetAttrib($TargetDrive & "\grldr", "-RSH")
		FileCopy($TargetDrive & "\grldr", $TargetDrive & "\grldr_old")
		FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
		If FileExists($TargetDrive & "\grldr.mbr") Then FileCopy(@ScriptDir & "\makebt\grldr.mbr", $TargetDrive & "\", 1)
		; If FileExists(@ScriptDir & "\makebt\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
	EndIf

	FileCopy(@ScriptDir & "\makebt\winvblock.ima", $WinDrvDrive & "\", 1)

	GUICtrlSetData($ProgressAll, 50)

	; Make only VHD and NO Boot Menu
	If GUICtrlRead($Inst_Chk) = $GUI_UNCHECKED Then
		Sleep(2000)
		GUICtrlSetData($ProgressAll, 100)
		_GUICtrlStatusBar_SetText($hStatus," End of Program ", 0)
		MsgBox(64, " END OF PROGRAM - OK ", " End of Program  - OK " & @CRLF _
		& @CRLF & "Created File " & $vhd_name & $w7_nr & " VHD on Drive " & $WinDrvDrive & " of your Computer ", 0)
		Exit
	EndIf


	_GUICtrlStatusBar_SetText($hStatus," Checking Target Boot Drive - wait ...", 0)

	$DriveType=DriveGetType($TargetDrive)

	GUICtrlSetData($ProgressAll, 60)
	; using Result of ListUsbDrives
	; MsgBox(0, "TargetDrive - OK", $TargetDrive & "\" & " Drive was found " & @CRLF & "Device Number = " & $inst_disk & @CRLF & "Partition Number = " & $inst_part, 0)

	If $inst_disk = "" Or $inst_part = "" Then
		$inst_valid=0
		MsgBox(48, "WARNING - Target Boot Drive may be NOT Valid", "Device Number NOT Found in makebt\usblist.txt" & @CRLF & @CRLF & _
		"Target Boot Drive = " & $TargetDrive & "   HDD = " & $inst_disk & "   PART = " & $inst_part)
	Else
		$inst_valid=1

		RunWait(@ComSpec & " /c makebt\dsfo.exe \\.\PHYSICALDRIVE" & $inst_disk & " 0 512 makebt\bs_temp\hd_" & $inst_disk & ".mbr", @ScriptDir, @SW_HIDE)

		$fhan = FileOpen(@ScriptDir & "\makebt\bs_temp\hd_" & $inst_disk & ".mbr", 16)
		If $fhan = -1 Then
		;	MsgBox(48, "WARNING - MBR NOT FOUND", "Unable to open file makebt\bs_temp\hd_" & $inst_disk & ".mbr", 3)
		Else
			$mbrsrc = FileRead($fhan)
			FileClose($fhan)
			If $inst_part > 0  And $inst_part < 5  Then
				$activebyte = StringMid($mbrsrc, 895 + ($inst_part-1)*32, 2)
			EndIf
			If $activebyte <> "80" Then $notactiv=1
			$xpmbr = 0
			$g4dmbr = 0
			$xpmbr = HexSearch(@ScriptDir & "\makebt\bs_temp\hd_" & $inst_disk & ".mbr", "33C08ED0BC007C", 16, 1)
			If Not $xpmbr Then $g4dmbr = HexSearch(@ScriptDir & "\makebt\bs_temp\hd_" & $inst_disk & ".mbr", "EB5E80052039", 16, 1)
			If Not $xpmbr And Not $g4dmbr Then $g4dmbr = HexSearch(@ScriptDir & "\makebt\bs_temp\hd_" & $inst_disk & ".mbr", "33C0EB5C80002039", 16, 1)
		EndIf
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Checking BootSector ... ", 0)

	Sleep(2000)

	_Copy_BS()
	If $bs_valid = 0 And $g4dmbr=0 Then $inst_valid=2

	Sleep(2000)

	If $g4d Or $g4dmbr Then
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
	EndIf

	If Not $g4d_vista And Not FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") Then
		If Not FileExists($TargetDrive & "\NTDETECT.COM") And Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") And Not FileExists(@ScriptDir & "\makebt\ntdetect.com") Then
			MsgBox(48, "WARNING - File NTDETECT.COM Needed ", " Missing File makebt\Boot_XP\NTDETECT.COM " & @CRLF & @CRLF _
			& " Solution - Run Prg once in XP OS to get NTDETECT.COM " & @CRLF & @CRLF _
			& " Or add NTDETECT.COM manually to Target Boot Drive ", 5)
			$inst_valid=0
		EndIf
		If Not FileExists($TargetDrive & "\NTLDR") And Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then
			MsgBox(48, "WARNING - File NTLDR Needed ", " Missing File makebt\Boot_XP\NTLDR " & @CRLF & @CRLF _
			& " Solution - Run Prg once in XP OS to get NTLDR " & @CRLF & @CRLF _
			& " Or add NTLDR manually to Target Boot Drive ", 5)
			$inst_valid=0
		EndIf
	EndIf

	GUICtrlSetData($ProgressAll, 70)

	_GUICtrlStatusBar_SetText($hStatus," Make Entry in Grub4dos Boot Menu - wait ....", 0)

	Sleep(2000)

	_VHD_IMG()

	GUICtrlSetData($ProgressAll, 80)

	Sleep(2000)

	_GUICtrlStatusBar_SetText($hStatus,"", 0)

	If $inst_valid <> 0 And $xpmbr = 0 And $g4dmbr = 0 Then
		$inst_valid=2
		$ikey = MsgBox(48, " WARNING - MBR BootCode may be Invalid ", "  Target Boot Drive may be Not bootable - Continue " & @CRLF & @CRLF & _
		"  Windows Or Grub4dos MBR Bootcode NOT found " & @CRLF & @CRLF & _
		"  MBRFix.exe Or grubinst.exe can make disk  " & $inst_disk & "  Bootable ", 0)

		;	$ikey = MsgBox(48+4, " WARNING - Windows MBR BootCode NOT Found ", "  Fix MBR with Windows MBR BootCode ? ", 0)
		;	If $ikey = 6 Then
		;		_GUICtrlStatusBar_SetText($hStatus," MBRFix makes Windows MBR BootCode - Wait ... ", 0)
		;		If @OSArch = "X86" Then
		;			RunWait(@ComSpec & " /c makebt\MBRFIX.EXE /drive " & $inst_disk & " fixmbr /vista /yes", @ScriptDir, @SW_HIDE)
		;		Else
		;			RunWait(@ComSpec & " /c makebt\MbrFix64.exe /drive " & $inst_disk & " fixmbr /vista /yes", @ScriptDir, @SW_HIDE)
		;		EndIf
		;	Else
		;		$inst_valid=2
		;	EndIf
	EndIf

	If $inst_valid <> 0 And $notactiv Then
		$inst_valid=2
		MsgBox(48, "WARNING - Target Boot Drive is NOT Active", "Booting needs Activ Target Boot Drive " & @CRLF & @CRLF & _
		"Use Disk Management and R-mouse to Set Target Boot Drive Activ " & @CRLF & @CRLF & _
		"Target Boot Drive = " & $TargetDrive & "   HDD = " & $inst_disk & "   PART = " & $inst_part)
		;	SystemFileRedirect("On")
		;	RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\diskmgmt.msc", @ScriptDir, @SW_HIDE)
		;	SystemFileRedirect("Off")
	EndIf

	GUICtrlSetData($ProgressAll, 100)

	_GUICtrlStatusBar_SetText($hStatus," End of Program ", 0)

	If $inst_valid=1 And $mk_bcd <> 2 Then
		If $xpiso <> "" Then
			MsgBox(64, " END OF PROGRAM - OK ", " End of Program  - OK " & @CRLF _
			& @CRLF & "Created File " & $vhd_name & $w7_nr & " VHD on System Drive " & $WinDrvDrive & " of your Computer " & @CRLF & @CRLF & _
			"Reboot from Boot Drive to Start XP Setup on " & $vhd_name & $w7_nr & " VHD ", 0)
		Else
			MsgBox(64, " END OF PROGRAM - OK ", " End of Program  - OK " & @CRLF _
			& @CRLF & "Created File " & $vhd_name & $w7_nr & " VHD on System Drive " & $WinDrvDrive & " of your Computer " & @CRLF & @CRLF & _
			"First use R-mouse to Mount " & $vhd_name & $w7_nr & " VHD in ImDisk Virtual Drive " & @CRLF & @CRLF & _
			"Then use WinNTSetup3 to prepare XP Setup in " & $vhd_name & $w7_nr & " VHD " & @CRLF & @CRLF & _
			"Then Reboot from Boot Drive to Start XP Setup on " & $vhd_name & $w7_nr & " VHD ", 0)
		EndIf
	Else
		MsgBox(64, " END OF PROGRAM - WARNING ", " End of Program with Warnings " & @CRLF _
		& @CRLF & $vhd_name & $w7_nr & " VHD is on System Drive " & $WinDrvDrive & " of your Computer " & @CRLF & @CRLF & _
		"Boot Problems may need to be Solved First ", 0)
	EndIf
	Exit
EndFunc   ;==> _Go
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

	GUICtrlSetState($grldrUpd, $endis)
	GUICtrlSetState($BlackFix, $endis)

	;	GUICtrlSetState($Inst_Chk, $endis)
	;	GUICtrlSetState($mem_Chk, $endis)

	If $WinDrvDrive = "" Then
		GUICtrlSetState($ISO_Select, $GUI_DISABLE)
		GUICtrlSetState($ISO_GUI, $GUI_DISABLE)
	Else
		GUICtrlSetState($ISO_Select, $endis)
		GUICtrlSetState($ISO_GUI, $endis)
	EndIf

	GUICtrlSetState($NTFS_Compr, $endis)

	If $TargetDrive = "" Then
		GUICtrlSetState($Inst_Chk, $GUI_UNCHECKED + $GUI_DISABLE)
	Else
		GUICtrlSetState($Inst_Chk, $endis)
	EndIf

	If $xpiso <> "" Then
		GUICtrlSetState($mem_Chk, $endis)
	Else
		GUICtrlSetState($mem_Chk, $GUI_UNCHECKED + $GUI_DISABLE)
	EndIf

	GUICtrlSetState($TargetSel, $endis)
	GUICtrlSetState($Target, $endis)
	GUICtrlSetState($WinDrvSel, $endis)
	GUICtrlSetState($WinDrv, $endis)
	GUICtrlSetState($ComboSize, $endis)

	GUICtrlSetData($ISO_GUI, $xpiso)
	GUICtrlSetState($GO, $GUI_DISABLE)
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
					& "Solution: First Format your Target Drive and then Try Again ", 0)
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
						& "Solution: First Format your Target Drive and then Try Again ", 0)
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
						& "Solution: First Format your Target Drive and then Try Again ", 0)
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
Func _VHD_IMG()
	Local $boot_g4d_ok=0

	; In case of Grub4dos BootSector or Grub4dos MBR Or Boot Manager with grldr.mbr then simply make entry in menu.lst
	If FileExists($TargetDrive & "\grldr") And FileExists($TargetDrive & "\menu.lst") Then
		If $g4d Or $g4dmbr Then
			$boot_g4d_ok=1
		ElseIf $g4d_vista And FileExists($TargetDrive & "\grldr.mbr") And FileExists($TargetDrive & "\bootmgr") And FileExists($TargetDrive & "\Boot\BCD") And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			$boot_g4d_ok=1
		EndIf
		If $boot_g4d_ok Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			If $xpiso <> "" Then
				_g4d_vhd_xp_menu()
			Else
				_g4d_vhd_ntsetup_menu()
			EndIf
			Return
		EndIf
	EndIf

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
			If FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then FileCopy(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", $TargetDrive & "\", 1)
		EndIf

	;	use modified ntdetect if exists in makebt folder
		If Not FileExists($TargetDrive & "\NTDETECT.COM") Then
			IF FileExists(@ScriptDir & "\makebt\ntdetect.com") Then
				FileCopy(@ScriptDir & "\makebt\ntdetect.com", $TargetDrive & "\", 1)
			Else
				If FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") Then FileCopy(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", $TargetDrive & "\", 1)
			EndIf
		EndIf

		If Not FileExists($TargetDrive & "\ntldr") Then
			If FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then FileCopy(@ScriptDir & "\makebt\Boot_XP\NTLDR", $TargetDrive & "\", 1)
		EndIf

		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf
		If Not FileExists($TargetDrive & "\menu.lst") Then
			FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
			If FileExists($TargetDrive & "\bootmgr")  And FileExists($TargetDrive & "\Boot\BCD") Then
				$bcd_flag = 1
			EndIf
		EndIf
		If $xpiso <> "" Then
			_g4d_vhd_xp_menu()
		Else
			_g4d_vhd_ntsetup_menu()
		EndIf
		If $bcd_flag = 1 Then
			FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title BootManager Menu - Win7/8  VHD")
			FileWriteLine($TargetDrive & "\menu.lst", "chainloader /bootmgr")
		EndIf
	Else
		$mk_bcd = 1
		If FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			$mk_bcd = 2
			MsgBox(48, "WARNING - SUSPECT CONFIG ERROR ", " grldr found without menu.lst " & @CRLF & @CRLF _
			& " Unable to Add Grub4dos to BootManager Menu" & @CRLF & @CRLF _
			& " Enable with Checkbox to Update Grub4dos grldr Version ", 0)
			Return
		EndIf
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		If $xpiso <> "" Then
			_g4d_vhd_xp_menu()
		Else
			_g4d_vhd_ntsetup_menu()
		EndIf
		_bcd_menu()
	EndIf
EndFunc   ;==> _VHD_IMG
;===================================================================================================
Func _g4d_vhd_xp_menu()
	Local $entry_image_file="", $entry_iso_file=""

	; _GUICtrlStatusBar_SetText($hStatus," Make WinVBlock XP Setup Entry in Boot Menu - wait ....", 0)

	$entry_image_file= $vhd_name & $w7_nr & ".vhd"

	$entry_iso_file = StringMid($xpiso, 4)

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title Continue GUI-mode XP Setup on " & $entry_image_file & " - " & $entry_iso_file & " - Size " & $iso_size & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_iso_file)
	If GUICtrlRead($mem_Chk) = $GUI_CHECKED Then
		FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_iso_file & " (0xff)")
	Else
		FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_iso_file & " (0xff)")
	EndIf
	; write XP Setup ISO filename in phony RAMDISK to prevent BSOD 44 in case ISO is not loaded in RAM
	FileWriteLine($TargetDrive & "\menu.lst", "map --rd-size=2048")
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem (rd)+4 (0x55)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "write (0x55) #!GRUB4DOS\x00v=1\x00/" & $entry_iso_file & "\x00\xff\x00")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /winvblock.ima (fd1)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /winvblock.ima (fd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --rehook")
	FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title Start -  TXT-mode XP Setup on " & $entry_image_file & " - " & $entry_iso_file & " - Size " & $iso_size & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_iso_file)
	If GUICtrlRead($mem_Chk) = $GUI_CHECKED Then
		FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_iso_file & " (0xff)")
	Else
		FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_iso_file & " (0xff)")
	EndIf
	FileWriteLine($TargetDrive & "\menu.lst", "map --rd-size=2048")
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem (rd)+4 (0x55)")
	; prevent int15 hook by using map --e820cycles=0
	If GUICtrlRead($BlackFix) = $GUI_CHECKED Then
		FileWriteLine($TargetDrive & "\menu.lst", "map --e820cycles=0")
	EndIf
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "write (0x55) #!GRUB4DOS\x00v=1\x00/" & $entry_iso_file & "\x00\xff\x00")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /winvblock.ima (fd1)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /winvblock.ima (fd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
	; prevent int15 hook by using map --e820cycles=0
	If GUICtrlRead($BlackFix) = $GUI_CHECKED Then
		FileWriteLine($TargetDrive & "\menu.lst", "map --e820cycles=0")
	EndIf
	FileWriteLine($TargetDrive & "\menu.lst", "map --rehook")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader (0xff)")

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title Boot  Windows XP from Image - " & $entry_image_file & " - WinVBlock driver - " & $vhd_size & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
	; FileWriteLine($TargetDrive & "\menu.lst", "map --rd-size=2048")
	; FileWriteLine($TargetDrive & "\menu.lst", "map --mem (rd)+4 (0x55)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	; FileWriteLine($TargetDrive & "\menu.lst", "write (0x55) #!GRUB4DOS\x00v=1\x00" & $entry_image_file & "\x00\x80\x00")
	FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")

EndFunc   ;==> _g4d_vhd_xp_menu
;===================================================================================================
Func _g4d_vhd_ntsetup_menu()
	Local $entry_image_file=""

	; _GUICtrlStatusBar_SetText($hStatus," Make WinVBlock XP Setup Entry in Boot Menu - wait ....", 0)

	$entry_image_file= $vhd_name & $w7_nr & ".vhd"

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title Start -  TXT-mode XP Setup on " & $entry_image_file & " - WinVBlock driver - " & $vhd_size & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /winvblock.ima (fd1)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /winvblock.ima (fd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
	If GUICtrlRead($BlackFix) = $GUI_CHECKED Then
		FileWriteLine($TargetDrive & "\menu.lst", "map --e820cycles=0")
	EndIf
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title Boot  Windows XP from Image - " & $entry_image_file & " - WinVBlock driver - " & $vhd_size & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")

EndFunc   ;==> _g4d_vhd_ntsetup_menu
;===================================================================================================
Func _bcd_menu()
	Local $file, $line, $store, $guid, $pos1, $pos2, $val=0


	SystemFileRedirect("On")

	If @OSVersion = "WIN_10" Or @OSVersion = "WIN_81" Or @OSVersion = "WIN_7" Or @OSVersion = "WIN_8" And Not FileExists($TargetDrive & "\bootmgr") And Not FileExists($TargetDrive & "\Boot\BCD") Then
		_GUICtrlStatusBar_SetText($hStatus," Adding Boot Manager to Target Boot Drive " & $TargetDrive & " - wait .... ", 0)
		If FileExists(@WindowsDir & "\system32\bcdboot.exe") And FileExists(@WindowsDir & "\Boot") Then
			$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdboot.exe " & @WindowsDir & " /s " & $TargetDrive, @ScriptDir, @SW_HIDE)
			Sleep(2000)
		EndIf
	EndIf

	If Not FileExists($TargetDrive & "\bootmgr") Then $mk_bcd = 2
	If Not FileExists($TargetDrive & "\Boot\BCD") Then $mk_bcd = 2

	If FileExists(@WindowsDir & "\system32\bcdedit.exe") Then
		$bcdedit = @WindowsDir & "\system32\bcdedit.exe"
	; Removed - In x86 OS with Target x64 W7 gives bcdedit is not valid 32-bits
	;	ElseIf FileExists($TargetDrive & "\Windows\System32\bcdedit.exe") Then
	;		$bcdedit = $TargetDrive & "\Windows\System32\bcdedit.exe"
	; 32-bits makebt\bcdedit.exe can be used in any case
	;	ElseIf FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
	;		$bcdedit = "makebt\bcdedit.exe"
	Else
		$mk_bcd = 2
	EndIf
	If $mk_bcd = 1 And $bcdedit <> "" Then
		$store = $TargetDrive & "\Boot\BCD"
		If Not FileExists($TargetDrive & "\grldr.mbr") Or GUICtrlRead($grldrUpd) = $GUI_CHECKED Then
			_GUICtrlStatusBar_SetText($hStatus," Adding Grub4dos to Boot Manager on Drive " & $TargetDrive & " - wait .... ", 0)
			FileCopy(@ScriptDir & "\makebt\grldr.mbr", $TargetDrive & "\", 1)
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
				If $DriveType="Removable" Or $usbfix Then
					RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /default " & $guid, $TargetDrive & "\", @SW_HIDE)
				EndIf
				;	MsgBox(0, "BOOTMGR - GRUB4DOS ENTRY in BCD OK ", "GRUB4DOS Boot Entry was made in Store " & $TargetDrive & "\Boot\BCD " & @CRLF & @CRLF _
				;	& "Grub4Dos GUID in BCD Store = " & $guid, 3)
				; Else
				;	MsgBox(48, "ERROR - GRUB4DOS GUID NOT Valid", "GRUB4DOS GUID NOT Found in BOOTMGR Menu", 3)
			EndIf
		EndIf
	Else
		If Not FileExists($TargetDrive & "\grldr.mbr") Or GUICtrlRead($grldrUpd) = $GUI_CHECKED Then
			MsgBox(48, "CONFIG ERROR Or Missing File", "Unable to Add to Boot Manager Menu" & @CRLF & @CRLF _
				& " Missing bcdedit.exe Or bootmgr and Boot Folder ", 3)
		EndIf
	EndIf

	SystemFileRedirect("Off")

EndFunc   ;==> _bcd_menu
;===================================================================================================
Func _Make_VHD()

	Local $i=0, $file, $line, $linesplit[20], $AutoPlay_Data=""

	Local $tmpdrive = "", $val=0, $valid = 0, $AllDrives
	Local $TempDrives[8] = ["V:", "T:", "S:", "Q:", "P:", "O:", "Y:", "W:"]

	; Local $TempDrives[23] = ["Z:", "Y:", "X:", "W:", "V:", "U:", "T:", "S:", "R:", "Q:", "P:", "O:", "N:", "M:", "L:", "K:", "J:", "I:", "H:", "G:", "F:", "E:", "D:" ]

	SystemFileRedirect("On")

	If Not FileExists(@WindowsDir & "\system32\diskpart.exe") Then
		SystemFileRedirect("Off")
		MsgBox(48, "ERROR - DiskPart Not Found ", " system32\diskpart.exe needed to Create VHD Drive " & @CRLF & @CRLF & " Boot with Windows 7 or 7 PE ")
		Exit
	EndIf

	If FileExists(@ScriptDir & "\VHD_W7\temp\Reg_DisableAutoPlay.txt") Then FileDelete(@ScriptDir & "\VHD_W7\temp\Reg_DisableAutoPlay.txt")

	RunWait(@ComSpec & " /c reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v DisableAutoplay" & " > VHD_W7\temp\Reg_DisableAutoPlay.txt", @ScriptDir, @SW_HIDE)

	$file = FileOpen(@ScriptDir & "\VHD_W7\temp\Reg_DisableAutoPlay.txt", 0)
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		If $line <> "" Then
			$line = StringStripWS($line, 7)
			$linesplit = StringSplit($line, " ")
			; _ArrayDisplay($linesplit)
			If $linesplit[1] = "DisableAutoplay" Then
				$AutoPlay_Data = $linesplit[3]
			EndIf
		EndIf
	Wend
	FileClose($file)

	; MsgBox(48, "Info AutoPlay ", "  " & @CRLF & @CRLF & " AutoPlay_Data = " & $AutoPlay_Data, 0)

	If $AutoPlay_Data = "0x0" Or $AutoPlay_Data = "" Then
		RunWait(@ComSpec & " /c reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v DisableAutoplay /t REG_DWORD /d 1 /f", @ScriptDir, @SW_HIDE)
		; MsgBox(48, "Info AutoPlay Disabled ", "  " & @CRLF & @CRLF & " Disable AutoPlay_Data = 1 ", 0)
	EndIf

	If FileExists(@ScriptDir & "\VHD_W7\temp\attach_srcvhd.txt") Then FileDelete(@ScriptDir & "\VHD_W7\temp\attach_srcvhd.txt")
	If FileExists(@ScriptDir & "\VHD_W7\temp\make_vhd.txt") Then FileDelete(@ScriptDir & "\VHD_W7\temp\make_vhd.txt")
	If FileExists(@ScriptDir & "\VHD_W7\temp\detach_srcvhd.txt") Then FileDelete(@ScriptDir & "\VHD_W7\temp\detach_srcvhd.txt")
	If FileExists(@ScriptDir & "\VHD_W7\temp\detach_dstvhd.txt") Then FileDelete(@ScriptDir & "\VHD_W7\temp\detach_dstvhd.txt")


	_GUICtrlStatusBar_SetText($hStatus," Search Free Drive Letter for VHD", 0)
	GUICtrlSetData($ProgressAll, 15)

	$AllDrives = DriveGetDrive( "all" )

	; _ArrayDisplay($AllDrives)

	FOR $d IN $TempDrives
		If Not FileExists($d & "\nul") Then
			$valid = 1
			For $i = 1 to $AllDrives[0]
				If $d = $AllDrives[$i] Then
					$valid = 0
				;	MsgBox(48,"Invalid Drive " & $i, "Invalid Drive " & $AllDrives[$i])
				EndIf
			Next
			If $valid Then
				$tmpdrive = $d
				ExitLoop
			EndIf
		Else
			$valid = 0
		EndIf
	NEXT

	IF $tmpdrive = "" Or Not $valid Then
		; Reset Disable AutoPlay to Original value 0 = Enable AutoPlay
		If $AutoPlay_Data = "0x0" Or $AutoPlay_Data = "" Then
			RunWait(@ComSpec & " /c reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v DisableAutoplay /t REG_DWORD /d 0 /f", @ScriptDir, @SW_HIDE)
			; MsgBox(48, "Info AutoPlay Enabled ", "  " & @CRLF & @CRLF & " Disable AutoPlay_Data = 0 ", 0)
		EndIf
		SystemFileRedirect("Off")
		MsgBox(48, "ERROR - VHD Drive Not available", "No Free Drive Letter for VHD Drive " _
		& @CRLF & @CRLF & "Please Reboot Computer and try again ")
		Exit
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Create Target " & $WinDrvDrive & "\" & $vhd_name & $w7_nr & ".vhd - wait about 3 min ....", 0)
	GUICtrlSetData($ProgressAll, 20)


	FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","create vdisk file=" & $WinDrvDrive & "\" & $vhd_name & $w7_nr & ".vhd maximum=" & $vhd_size & " type=fixed")
	FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","select vdisk file=" & $WinDrvDrive & "\" & $vhd_name & $w7_nr & ".vhd")
	FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","attach vdisk")
	FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","create partition primary")
	FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","active")
	If GUICtrlRead($NTFS_Compr) = $GUI_CHECKED Then
		FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","FORMAT FS=NTFS LABEL=" & '"' & $vhd_name & $w7_nr & " VHD" & '"' & " QUICK COMPRESS")
	Else
		FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","FORMAT FS=NTFS LABEL=" & '"' & $vhd_name & $w7_nr & " VHD" & '"' & " QUICK")
	EndIf
	FileWriteLine(@ScriptDir & "\VHD_W7\temp\make_vhd.txt","assign letter=" & StringLeft($tmpdrive, 1))

	FileWriteLine(@ScriptDir & "\VHD_W7\temp\detach_dstvhd.txt","select vdisk file=" & $WinDrvDrive & "\" & $vhd_name & $w7_nr & ".vhd")
	FileWriteLine(@ScriptDir & "\VHD_W7\temp\detach_dstvhd.txt","detach vdisk")

	$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\diskpart.exe /s  VHD_W7\temp\make_vhd.txt", @ScriptDir, @SW_HIDE)
	If $val <> 0 Then
		; Reset Disable AutoPlay to Original value 0 = Enable AutoPlay
		If $AutoPlay_Data = "0x0" Or $AutoPlay_Data = "" Then
			RunWait(@ComSpec & " /c reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v DisableAutoplay /t REG_DWORD /d 0 /f", @ScriptDir, @SW_HIDE)
			; MsgBox(48, "Info AutoPlay Enabled ", "  " & @CRLF & @CRLF & " Disable AutoPlay_Data = 0 ", 0)
		EndIf
		SystemFileRedirect("Off")
		MsgBox(48, " STOP - Error DiskPart", " Create VHD - DiskPart Error = " & $val, 0)
		Exit
	EndIf

	GUICtrlSetData($ProgressAll, 30)


	sleep(2000)
	; use BootSect.exe to give VHD NTLDR-type BootSector and XP-type MBR
	RunWait(@ComSpec & " /c makebt\BootSect.exe /nt52 "& $tmpdrive & " /force /mbr", @ScriptDir, @SW_HIDE)

	Sleep(5000)

	; Reset Disable AutoPlay to Original value 0 = Enable AutoPlay
	If $AutoPlay_Data = "0x0" Or $AutoPlay_Data = "" Then
		RunWait(@ComSpec & " /c reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v DisableAutoplay /t REG_DWORD /d 0 /f", @ScriptDir, @SW_HIDE)
		; MsgBox(48, "Info AutoPlay Enabled ", "  " & @CRLF & @CRLF & " Disable AutoPlay_Data = 0 ", 0)
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Detaching VHD - Wait ....", 0)
	$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\diskpart.exe /s  VHD_W7\temp\detach_dstvhd.txt", @ScriptDir, @SW_HIDE)
	If $val <> 0 Then
		; SystemFileRedirect("Off")
		MsgBox(48, " Error DiskPart", " Detach VHD - DiskPart Error = " & $val, 0)
		; Exit
	EndIf

	sleep(2000)
	SystemFileRedirect("Off")

EndFunc   ;==> _Make_VHD
;==================================================================================================
Func _New_HDDIMG()

	Local $tmpdrive=""

	Local $val=0, $valid = 0
;	Local $TempDrives[23] = ["Z:", "Y:", "X:", "W:", "V:", "U:", "T:", "S:", "R:", "Q:", "P:", "O:", "N:", "M:", "L:", "K:", "J:", "I:", "H:", "G:", "F:", "E:", "D:" ]
	Local $TempDrives[8] = ["V:", "T:", "S:", "Q:", "P:", "O:", "Y:", "W:"], $AllDrives, $MD_signat

	Local $FSbox="NTFS", $FShex="07", $sigword="CD0B", $signat="CD0BCD0B0000", $PSize = "1.6 GB"
	Local $mbrpos=0, $posm=0, $mbrfound=0, $bkp, $mbr100sec
	Local $ECyl, $EHd, $ESec, $partab_1, $partab_2, $TNsec, $Nsec, $HNsec, $BCyl_2, $BSec_2, $ECyl_2, $ESec_2, $Hid2, $NSec2, $HNsec2, $NrC2=1, $part2=0
	Local $file_rd, $fhan_rd, $rd_mbr, $file_wr, $fhan_wr, $wr_mbr, $fhan, $mvol, $chs_patch=0

	If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")

;	$FSbox = GUICtrlRead($ComboForm)
;	If $FSbox = "FAT32" Then
;		$FShex = "0C"
;	ElseIf $FSbox = "FAT" Then
;		$FShex = "0E"
;	Else
		$FShex = "07"
;	EndIf

	IF FileExists(@ScriptDir & "\makebt\bs_temp\tmp_xp.mbr") Then
		FileCopy(@ScriptDir & "\makebt\bs_temp\tmp_xp.mbr", @ScriptDir & "\makebt\tmp_xp_bak.mbr", 1)
		FileDelete(@ScriptDir & "\makebt\bs_temp\tmp_xp.mbr")
	EndIf

	$AllDrives = DriveGetDrive( "all" )

	FOR $d IN $TempDrives
		If Not FileExists($d & "\nul") Then
			$valid = 1
			For $i = 1 to $AllDrives[0]
				If $d = $AllDrives[$i] Then
					$valid = 0
				;	MsgBox(48,"Invalid Drive " & $i, "Invalid Drive " & $AllDrives[$i])
				;	_ArrayDisplay($AllDrives)
				EndIf
			Next
			If $valid Then
				$tmpdrive = $d
				ExitLoop
			EndIf
		Else
			$valid = 0
		EndIf
	NEXT

	IF $tmpdrive = "" Or Not $valid Then
		MsgBox(48, "ERROR - Virtual Drive Not available", "No Free Drive Letter for Virtual Drive " _
		& @CRLF & @CRLF & "Please Reboot Computer and try again ")
		Exit
	EndIf
;	$tmpdrive = "V:"

	_GUICtrlStatusBar_SetText($hStatus," Creating Image File ", 0)

	;	If FileExists(@ScriptDir & "\makebt\dmadmin.exe") Then
	;		; MBR XP - 33C08ED0BC007CFB50  -  MBR Vista 33C08ED0BC007C
	;		$posm = HexSearch(@ScriptDir & "\makebt\dmadmin.exe", "33C08ED0BC007CFB50", 16, 1)
	;		$mbrpos = $posm - 1
	;		; mbr in dmadmin of XP at OffSet 0x34E28 = 216616
	;		If $posm > 0 Then
	;			; MsgBox(64, "MBR - Found", " MBR at OffSet = " & $mbrpos, 0)
	;			IF FileExists(@ScriptDir & "\makebt\win_xp.mbr") Then
	;				FileCopy(@ScriptDir & "\makebt\win_xp.mbr", @ScriptDir & "\makebt\win_xp_bak.mbr", 1)
	;				FileDelete(@ScriptDir & "\makebt\win_xp.mbr")
	;			EndIf
	;			RunWait(@ComSpec & " /c makebt\dsfo.exe makebt\dmadmin.exe " & $mbrpos & " 512 makebt\win_xp.mbr", @ScriptDir, @SW_HIDE)
	;		EndIf
	;	EndIf

	;	; Should Not occur ....
	;	If Not FileExists(@ScriptDir & "\makebt\win_xp.mbr") Then
	;		_GUICtrlStatusBar_SetText($hStatus," STOP - makebt\win_xp.mbr Not Found ", 0)
	;		MsgBox(16, "STOP - ERROR - MBR File Not Found ", " XP MBR File makebt\win_xp.mbr Not Found " & @CRLF _
	;			& "XP File dmadmin.exe is needed in makebt Folder " & @CRLF _
	;			& "dmadmin.exe is used to Create MBR for Image File " & @CRLF & @CRLF _
	;			& "Copy C:\WINDOWS\system32\dmadmin.exe to makebt Folder ", 0)
	;		Exit
	;	EndIf

	FileCopy(@ScriptDir & "\makebt\win_xp.mbr", @ScriptDir & "\makebt\bs_temp\tmp_xp.mbr", 1)

	$PSize = GUICtrlRead($ComboSize)
	If $PSize = "0.4 GB" Then
		$TCyl = 52
	ElseIf $PSize = "0.5 GB" Then
		$TCyl = 66
	ElseIf $PSize = "0.6 GB" Then
		$TCyl = 79
	ElseIf $PSize = "0.7 GB" Then
		$TCyl = 92
	ElseIf $PSize = "0.8 GB" Then
		$TCyl = 105
	ElseIf $PSize = "0.9 GB" Then
		$TCyl = 118
	ElseIf $PSize = "1.0 GB" Then
		$TCyl = 131
;	If $PSize = "1.0 GB" Then
;		$TCyl = 131
	ElseIf $PSize = "1.2 GB" Then
		$TCyl = 157
	ElseIf $PSize = "1.6 GB" Then
		$TCyl = 209
	ElseIf $PSize = "1.8 GB" Then
		$TCyl = 235
	ElseIf $PSize = "2.0 GB" Then
		$TCyl = 261
	ElseIf $PSize = "2.5 GB" Then
		$TCyl = 325
	ElseIf $PSize = "3.0 GB" Then
		$TCyl = 391
	ElseIf $PSize = "3.5 GB" Then
		$TCyl = 456
	ElseIf $PSize = "3.9 GB" Then
		$TCyl = 497
;	ElseIf $PSize = "6.0 GB" Then
;		$TCyl = 782
	ElseIf $PSize = "7.0 GB" Then
		$TCyl = 913
	ElseIf $PSize = "10.0 GB" Then
		$TCyl = 1305
	Else
		$TCyl = 183
	EndIf

;	$TCyl = 179
	$THds = 255
	$TSec = 63
	$TNsec = $TCyl * $THds * $TSec

	; Create Partition Table Entry partition 1
	$Nsec = $TNsec - $TSec
	$HNsec = Hex($NSec, 8)
	$ECyl = $TCyl - 1
	If $ECyl > 1023 Then $ECyl = 1023
	$ESec = BitShift(BitShift($ECyl, 8),-6) + $TSec
	$EHd = $THds - 1

	$partab_1 = "80010100" & $FShex & Hex($EHd, 2) & Hex($ESec, 2) & Hex($ECyl, 2) & Hex($TSec, 2) & "000000" _
	& StringMid($HNsec, 7, 2) & StringMid($HNsec, 5, 2) & StringMid($HNsec, 3, 2) & StringMid($HNsec, 1, 2)


	$sigword = Hex(Random(4522, 56814, 1), 4)
	$signat = $sigword & $sigword & "0000"

	$file_rd = @ScriptDir & "\makebt\win_xp.mbr"
	$file_wr = @ScriptDir & "\makebt\bs_temp\tmp_xp.mbr"

	$fhan_rd = FileOpen($file_rd, 16)
	If $fhan_rd = -1 Then
		MsgBox(48, "ERROR - File NOT Open", "Unable to Read - File Handle = " & $fhan_rd & @CRLF & $file_rd, 0)
		Exit
	EndIf
	$rd_mbr = FileRead($fhan_rd)
	FileClose($fhan_rd)
	; Cut at 894 - 12

	$wr_mbr = StringLeft($rd_mbr, 882) & $signat & $partab_1 & StringRight($rd_mbr, 100)

	$fhan_wr = FileOpen($file_wr, 16 + 2)
	If $fhan_wr = -1 Then
		MsgBox(48, "ERROR - File NOT Open", "Unable to Write - File Handle = " & $fhan_wr & @CRLF & $file_wr, 0)
		Exit
	EndIf
	FileWrite($fhan_wr , $wr_mbr)
	FileClose($fhan_wr)

	; 179C 255H 63S = 2875635 sectoren * 512 = 1472325120 bytes = 1,37 GB = 1404 MB  - Drive = 2875572 sectoren
	$img_fsize = $TCyl * 255 * 63 * 512

	If $Create = $TempFolder Then
		$img_fname = $vhd_name & "temp"
		$image_file = $vhd_name & "temp" & $img_fext
		;	FileWriteLine($TempFolder & "\" & $img_fname & ".PLN","DRIVETYPE ide")
		;	FileWriteLine($TempFolder & "\" & $img_fname & ".PLN", "CYLINDERS " & $TCyl)
		;	FileWriteLine($TempFolder & "\" & $img_fname & ".PLN", "HEADS 255")
		;	FileWriteLine($TempFolder & "\" & $img_fname & ".PLN", "SECTORS 63")
		;	FileWriteLine($TempFolder & "\" & $img_fname & ".PLN", "ACCESS " & $image_file & " 0 " & $TNsec)
	Else
		$img_fname = $vhd_name & $w7_nr
		$image_file = $vhd_name & $w7_nr & $img_fext
		;	FileWriteLine($WinDrvDrive & "\" & $img_fname & ".PLN","DRIVETYPE ide")
		;	FileWriteLine($WinDrvDrive & "\" & $img_fname & ".PLN", "CYLINDERS " & $TCyl)
		;	FileWriteLine($WinDrvDrive & "\" & $img_fname & ".PLN", "HEADS 255")
		;	FileWriteLine($WinDrvDrive & "\" & $img_fname & ".PLN", "SECTORS 63")
		;	FileWriteLine($WinDrvDrive & "\" & $img_fname & ".PLN", "ACCESS " & $image_file & " 0 " & $TNsec)
	EndIf

	SystemFileRedirect("On")
	If FileExists(@WindowsDir & "\system32\fsutil.exe") Then
		_RunDOS("fsutil.exe file createnew " & '"' & $Create & "\" & $image_file & '"' & " " & $img_fsize)
	EndIf
	SystemFileRedirect("Off")

	If Not FileExists($Create & "\" & $image_file) Then
		MsgBox(16, "STOP - ERROR - Image File Not Created ", " Unable to Create Empty Image File with fsutil.exe ", 0)
		Exit
	EndIf

	If 	$Create = $TempFolder Then
		RunWait(@ComSpec & " /c makebt\dsfi.exe VHD_W7\temp" & "\" & $image_file & " 0 512 makebt\bs_temp\tmp_xp.mbr", @ScriptDir, @SW_HIDE)
	Else
		RunWait(@ComSpec & " /c makebt\dsfi.exe " & $WinDrvDrive & "\" & $image_file & " 0 512 makebt\bs_temp\tmp_xp.mbr", @ScriptDir, @SW_HIDE)
	EndIf

	$AllDrives = DriveGetDrive( "all" )

	GUICtrlSetData($ProgressAll, 30)
	_GUICtrlStatusBar_SetText($hStatus," ImDisk Opening Virtual Drive ", 0)
	Sleep(2000)

	; ImDisk Driver needed for Virtual Drive
	; First always Manually Install ImDisk using USB_XP_Setup\makebt\imdiskinst.exe
	; 64-bits XP - Enable to find imdisk.exe
	SystemFileRedirect("On")

;	If Not FileExists(@WindowsDir & "\system32\imdisk.exe") Then
;		SystemFileRedirect("Off")
;		MsgBox(48, "WARNING - Manual Install ImDisk Driver ", "ImDisk Driver needed for Virtual Drive  " & @CRLF & @CRLF & " First Install ImDisk using USB_XP_Setup\makebt\imdiskinst.exe ")
;		Exit
;	EndIf

	If 	$Create = $TempFolder Then
		$val = RunWait(@ComSpec & " /c " & '"' & @WindowsDir & "\system32\imdisk.exe" & '"' & " -a -t file -b auto -f VHD_W7\temp" & "\" & $image_file & " -o rw -m " & $tmpdrive, @ScriptDir, @SW_HIDE)
	Else
		$val = RunWait(@ComSpec & " /c " & '"' & @WindowsDir & "\system32\imdisk.exe" & '"' & " -a -t file -b auto -f " & $WinDrvDrive & "\" & $image_file & " -o rw -m " & $tmpdrive, "", @SW_HIDE)
	EndIf

	If $val Then
		SystemFileRedirect("Off")
		MsgBox(48, "ERROR - ImDisk ", "ImDisk returned with exit code:" & $val & @CRLF & @CRLF & "Unable to Open Virtual Drive "  _
		& @CRLF & @CRLF & "Please Reboot Computer and try again ")
		Exit
	EndIf

	GUICtrlSetData($ProgressAll, 40)

	_GUICtrlStatusBar_SetText($hStatus,"Formatting NTFS - Virtual Drive " & $tmpdrive & " - Please wait ...", 0)
	If GUICtrlRead($NTFS_Compr) = $GUI_CHECKED Then
		$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $tmpdrive & " /FS:NTFS /C /v:" & $vhd_name & $w7_nr & "-VHD" & " /Q /force", "", @SW_HIDE)
	Else
		$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $tmpdrive & " /FS:NTFS /v:" & $vhd_name & $w7_nr & "-VHD" & " /Q /force", "", @SW_HIDE)
	EndIf

	SystemFileRedirect("Off")

	If $val Then
		Sleep(2000)
		; 64-bits XP - Enable to find imdisk.exe
		SystemFileRedirect("On")
		;	$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\imdisk.exe" & " -d -m " & $tmpdrive, @ScriptDir, @SW_HIDE)
		_RunDOS(@WindowsDir & "\system32\imdisk.exe" & " -D -m " & $tmpdrive)
		SystemFileRedirect("Off")
		MsgBox(48, "ERROR - Format Virtual Drive", "Format returned with exit code:" & $val _
		& @CRLF & @CRLF & "Please Reboot Computer and try again ")
		Exit
	EndIf

	Sleep(2000)

	; BootSect.exe cannot change BootSector of Image mounted with ImDisk

	; MsgBox(0, "Image Mounted", "ImageDrive = " & $tmpdrive)

	GUICtrlSetData($ProgressAll, 50)


	GUICtrlSetData($ProgressAll, 75)

	_GUICtrlStatusBar_SetText($hStatus,"Wait Virtual Drive " & $tmpdrive & " will be Closed", 0)

	; MsgBox(0, "FileCopy to Image Drive Ready", "FileCopy to Image Drive " & $tmpdrive & "  -  Ready")

	Sleep(2000)

	; 64-bits XP - Enable to find imdisk.exe
	SystemFileRedirect("On")
	;	$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\imdisk.exe" & " -d -m " & $tmpdrive, @ScriptDir, @SW_HIDE)
	$val = _RunDOS(@WindowsDir & "\system32\imdisk.exe" & " -D -m " & $tmpdrive)
	SystemFileRedirect("Off")
	If $val Then MsgBox(48, "WARNING - ImDisk could not Close Virtual Drive ", "Imdisk Exit code = " & $val & @CRLF & @CRLF & "Manually Close Virtual Drive using R-mouse ", 0)

	; MsgBox(0, "ImDisk Close returned with exit code:", $val)

	Return $val
EndFunc   ;==> _Make_HDDIMG
;===================================================================================================


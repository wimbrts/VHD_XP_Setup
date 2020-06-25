#RequireAdmin
#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.8.1
 Author:        WIMB  -  April 22, 2014

 Program:       UFD_FORMAT.exe - part of IMG_XP Package - Version 8.5 in rule 106
	can be used to Format USB-stick for Booting with Boot Manager Menu on BIOS or UEFI computer and
	can be used to make USB-Stick having two partitions - FAT32 Boot partition for WIM or ISO and NTFS System partition for VHD
	UEFI_MULTI.exe can be used to Make Bootable USB-drives by using Boot Image Files (VHD IMG ISO or WIM)
	Boot UEFI - F12 - BIOS - Grub4dos - VHD - Ramdisk - Win 8x32
	
	Win- XP/7/8 VHD on NTFS System partition is loaded fast from USB-Stick into RAMDISK and then booting from RAMDISK occurs.
	 
	Running in XP or Vista / Windows 7 / 8 Environment and in 7PE Environment

 Script Function of UEFI_MULTI.exe
	Install Boot IMAGE File on Harddisk or USB-Drive
	Enables to Launch Boot Image from GRUB4DOS menu.lst
	Useful as Escape Boot Option for System Backup and Restore with Ghost
	or to boot with PE to prepare your Harddisk for Install of Windows XP or Windows 7

	Install as Boot Option on Harddisk or USB-stick of: 
	- BartPE / UBCD4Win / LiveXP - IMG or ISO files booting from RAMDISK
	- Parted Magic - Acronis - LiveXP_RAM - CD - ISO File
	- Superfloppy Image files e.g. to boot 15 MB FreeDOS or 25 MB MS-DOS floppy images
	- XP Recovery Console Image RECONS.img booting from RAMDISK
	- 7pe_x86_E.iso - Win7 PE booting from RAMDISK
	- XP*.vhd - XP VHD Image file booting as FILEDISK or RAMDISK using WinVBlock or FiraDisk driver
	- W7*.vhd - Win7 VHD file booting as FILEDISK or RAMDISK using WinVBlock or FiraDisk driver
	- boot.wim - 7/8 Recovery or WinPE booting from RAMDISK
	
 Credits and Thanks to:
	JFX for making WinNTSetup3 to Install Windows 2k/XP/2003/Vista/7/8 x86/x64 - http://www.msfn.org/board/topic/149612-winntsetup-v30/
	chenall, tinybit and Bean for making Grub4dos - http://code.google.com/p/grub4dos-chenall/downloads/list
	karyonix for making FiraDisk driver- http://reboot.pro/topic/8804-firadisk-latest-00130/
	Sha0 for making WinVBlock driver - http://reboot.pro/topic/8168-winvblock/
	Olof Lagerkvist for ImDisk virtual disk driver - http://www.ltr-data.se/opencode.html#ImDisk and http://reboot.pro/index.php?showforum=59
	Uwe Sieber for making ListUsbDrives - http://www.uwe-sieber.de/english.html
	Dariusz Stanislawek for the DS File Ops Kit (DSFOK) - http://members.ozemail.com.au/~nulifetv/freezip/freeware/
	cdob and maanu to Fix Win7 for booting from USB - http://reboot.pro/topic/14186-usb-hdd-boot-and-windows-7-sp1/
	ktp for using two partition USB-Stick with UEFI_MULTI - http://reboot.pro/topic/18182-uefi-multi-make-multi-boot-usb-harddisk/page-2#entry177216

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

Opt('MustDeclareVars', 1)
Opt("GuiOnEventMode", 1)
Opt("TrayIconHide", 1)

; Setting variables
Global $TargetDrive="", $ProgressAll
Global $hStatus, $pausecopy=0, $TargetSpaceAvail=0, $TargetSize, $TargetFree, $FSvar=""
Global $hGuiParent, $EXIT, $TargetSel, $Target, $ComboBoot, $BootLoader, $Bootmgr_Menu
Global $DriveType="Fixed", $usbfix=0

Global $FormUSB, $ComboForm, $Check_2nd, $Combo_2nd
Global $TSize=0, $TCyl=0, $THds=255, $TSec=63, $hdisk="", $hpart="", $mbrndx, $act, $dt, $inst_disk="", $inst_part=""
; Target Drive has $TSec sectors per head and $THds heads per Cylinder - final geometry values are derived from MBRWiz

Global $OS_drive = StringLeft(@WindowsDir, 2)

Global $str = "", $bt_files[14] = ["\makebt\touchdrv.exe", "\makebt\dsfo.exe", "\makebt\dsfi.exe", "\makebt\p_x80.bin", "\makebt\win8_mbr.dat", "\makebt\listusbdrives\ListUsbDrives.exe", _
"\makebt\grldr.mbr", "\makebt\grldr", "\makebt\menu.lst", "\makebt\grubinst.exe", "\makebt\Erase_100.bin", "\makebt\MBRWiz.exe", "\makebt\MBRWiz64.exe", "\makebt\BootSect.exe"]

For $str In $bt_files
	If Not FileExists(@ScriptDir & $str) Then
		MsgBox(48, "ERROR - Missing File", "File " & $str & " NOT Found ")
		Exit
	EndIf
Next

; Remove bs_temp in _FormatUSB used After Select Format Stick
; If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")
If Not FileExists(@ScriptDir & "\makebt\backups") Then DirCreate(@ScriptDir & "\makebt\backups")
	
; Creating GUI and controls
$hGuiParent = GUICreate(" UFD_FORMAT - Tool for USB Flash Drive", 400, 430, 100, 40, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")

GUICtrlCreateGroup("USB - Stick  Format - Version 8.5 ", 18, 10, 364, 235)

GUICtrlCreateLabel( "1st Partition", 56, 157)

GUICtrlCreateLabel( "For Booting with Boot Manager menu -  BIOS  or  UEFI  FAT32", 32, 37)
GUICtrlCreateLabel( "Use  UEFI_MULTI  to Add Boot Image Files - WIM  ISO or VHD", 32, 67)
GUICtrlCreateLabel( "Boot UEFI  or  BIOS - Win 8 x 64 WIM in Ramdisk ", 32, 97)
; GUICtrlCreateLabel( "Boot BIOS - Grub4dos - Win 7 x32  VHD in Ramdisk", 32, 127)

$ComboForm = GUICtrlCreateCombo("", 125, 154, 60, 24, $CBS_DROPDOWNLIST)
GUICtrlSetData($ComboForm,"NTFS|FAT32", "FAT32")

GUICtrlCreateLabel( "FAT32   Boot  Partition - WIM  ISO", 200, 157)

$Check_2nd = GUICtrlCreateCheckbox("", 32, 192, 17, 17)
GUICtrlCreateLabel( "2nd Partition", 56, 192)
GUICtrlSetTip($Check_2nd, "Make Second Partition - use NTFS Format for VHD FileDisk " & @CRLF _
& "USB_Part_Flip.exe can make 2nd Partition visible in Windows ")

$Combo_2nd = GUICtrlCreateCombo("", 125, 187, 60, 24, $CBS_DROPDOWNLIST)
GUICtrlSetData($Combo_2nd,"25 %|50 %|75 %|MAX|MIN", "MAX")

GUICtrlCreateLabel( "NTFS  System  Partition - VHD", 200, 190)
GUICtrlCreateLabel( "2nd Partition  is visible in Windows After using USB_Part_Flip.exe ", 32, 220)

GUICtrlCreateLabel( "MBR BootCode", 25, 262)

$ComboBoot = GUICtrlCreateCombo("", 110, 258, 75, 24, $CBS_DROPDOWNLIST)
GUICtrlSetData($ComboBoot,"Standard|Grub4dos", "Standard")
GUICtrlSetTip($ComboBoot, " Standard MBR Boot Code will use bootmgr as Boot Loader with Boot Manager Menu " _
& @CRLF & " Grub4dos MBR Boot Code will use   grldr    as Boot Loader with menu.lst Menu ")

$Bootmgr_Menu = GUICtrlCreateCheckbox("", 224, 260, 17, 17)
GUICtrlSetTip($Bootmgr_Menu, " Make USB Drive bootable with Boot Manager and Grub4dos Menu " _
& @CRLF & " Win 7/8 or 7/8 PE is needed to Make Boot Manager Menu ")
GUICtrlCreateLabel( "Make Boot Menu", 248, 262)

GUICtrlCreateGroup("Target USB Drive", 18, 290, 265, 54)
$Target = GUICtrlCreateInput($TargetSel, 32, 312, 95, 20, $ES_READONLY)
$TargetSel = GUICtrlCreateButton("...", 133, 313, 26, 18)
GUICtrlSetTip(-1, " Select USB-Stick as Target USB Drive for " & @CRLF _
& " Quick Erase and Format USB-stick - UEFI needs FAT32 FileSystem ")
GUICtrlSetOnEvent($TargetSel, "_target_drive")
$TargetSize = GUICtrlCreateLabel( "", 175, 306, 100, 15, $ES_READONLY)
$TargetFree = GUICtrlCreateLabel( "", 175, 323, 100, 15, $ES_READONLY)
GUICtrlSetOnEvent($TargetSel, "_target_drive")

GUICtrlCreateGroup("", 295, 290, 87, 54)

$FormUSB = GUICtrlCreateButton("Format Stick", 235, 360, 70, 30)
GUICtrlSetTip($FormUSB, " Quick Erase and Format USB-stick - UEFI needs FAT32 FileSystem ")
GUICtrlSetOnEvent($FormUSB, "_FormatUSB")

$EXIT = GUICtrlCreateButton("EXIT", 320, 360, 60, 30)
GUICtrlSetOnEvent($EXIT, "_Quit")

$ProgressAll = GUICtrlCreateProgress(16, 368, 203, 16, $PBS_SMOOTH)

$hStatus = _GUICtrlStatusBar_Create($hGuiParent, -1, "", $SBARS_TOOLTIPS)
Global $aParts[3] = [310, 350, -1]
_GUICtrlStatusBar_SetParts($hStatus, $aParts)

_GUICtrlStatusBar_SetText($hStatus," Select USB-Stick as Target Drive ", 0)

DisableMenus(1)

GUICtrlSetState($ComboForm, $GUI_ENABLE)
GUICtrlSetState($Check_2nd, $GUI_ENABLE)
GUICtrlSetState($Combo_2nd, $GUI_ENABLE)
GUICtrlSetState($TargetSel, $GUI_ENABLE)
GUICtrlSetState($FormUSB, $GUI_DISABLE)
; old OS cannot use bcdboot to make Boot Manager Menu - Instead use Grub4dos as Bootloader and boot direct with Grub4dos Menu
If @OSVersion = "WIN_VISTA" Or @OSVersion = "WIN_2003" Or @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Or @OSVersion = "WIN_2000" Then
	GUICtrlSetData($ComboBoot,"Grub4dos")
EndIf
GUICtrlSetState($ComboBoot, $GUI_ENABLE)
GUICtrlSetState($Bootmgr_Menu, $GUI_ENABLE + $GUI_CHECKED)

GUISetState(@SW_SHOW)

;===================================================================================================
While 1
	CheckGo()
    Sleep(300)
WEnd   ;==> Loop
;===================================================================================================
Func CheckGo()
	Local $valid=1

	If $TargetDrive <> "" And $DriveType="Removable" Then 
		GUICtrlSetState($FormUSB, $GUI_ENABLE)
		_GUICtrlStatusBar_SetText($hStatus," Use Format Stick to Quick Erase and Format USB-stick", 0)
	Else
		If GUICtrlRead($FormUSB) = $GUI_ENABLE Then
			GUICtrlSetState($FormUSB, $GUI_DISABLE)
			_GUICtrlStatusBar_SetText($hStatus," Select USB-Stick as Target Drive ", 0)
		EndIf
	EndIf
EndFunc ;==> _CheckGo
;===================================================================================================
Func _Quit()
	Local $ikey
    If @GUI_WinHandle = $hGuiParent Then
		If Not $pausecopy Then DisableMenus(1)
	    GUICtrlSetState($EXIT, $GUI_DISABLE)
		$ikey = MsgBox(48+4+256, " STOP Program ", " STOP Program ? ")
		If $ikey = 6 Then
			Exit
		Else
			If Not $pausecopy Then DisableMenus(0)
			If $TargetDrive = "" Then
				DisableMenus(1)
				GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			EndIf
			GUICtrlSetState($EXIT, $GUI_ENABLE)
			Return
		EndIf
    Else        
        GUIDelete(@GUI_WinHandle)
    EndIf
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
Func _target_drive()
	Local $TargetSelect, $Tdrive, $FSvar, $valid = 0, $ValidDrives, $RemDrives
	Local $NoDrive[3] = ["A:", "B:", "X:"], $FileSys[3] = ["NTFS", "FAT32", "FAT"]
	Local $pos, $fs_ok=0

	$DriveType="Fixed"
	DisableMenus(1)
	
	_GUICtrlStatusBar_SetText($hStatus," Select USB-Stick as Target Drive ", 0)
	
	$ValidDrives = DriveGetDrive( "FIXED" )
	_ArrayPush($ValidDrives, "")
	_ArrayPop($ValidDrives)
	$RemDrives = DriveGetDrive( "REMOVABLE" )
	_ArrayPush($RemDrives, "")
	_ArrayPop($RemDrives)
	_ArrayConcatenate($ValidDrives, $RemDrives)
	; _ArrayDisplay($ValidDrives)
	
	$TargetDrive = ""
	$FSvar=""
	$TargetSpaceAvail = 0
	GUICtrlSetData($Target, "")
	GUICtrlSetData($TargetSize, "")
	GUICtrlSetData($TargetFree, "")
	GUICtrlSetState($FormUSB, $GUI_DISABLE)

	$TargetSelect = FileSelectFolder("Select USB-Stick as Target Drive", "")
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
		MsgBox(48,"ERROR - Path Invalid", "Path Invalid - Space Found" & @CRLF & @CRLF & "Selected Path = " & $TargetSelect & @CRLF & @CRLF _
		& "Solution - Use simple Path without Spaces ")
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
			MsgBox(48, "ERROR - Drive NOT Valid", " Drive A: B: and X: ", 3)
			DisableMenus(0)
			Return
		EndIf
	NEXT
	If $valid And DriveStatus($Tdrive) <> "READY" Then 
		$valid = 0
		MsgBox(48, "WARNING - Drive NOT Ready", "Drive NOT READY " & @CRLF & @CRLF & "First Format Target Drive  ", 0)
		DisableMenus(0)
		Return
	EndIf
	If $valid Then
		$DriveType=DriveGetType($Tdrive)
		IF $DriveType <> "Removable" Then 
			$valid = 0
			MsgBox(48, "WARNING - Invalid Drive Type ", "Selected Drive Type = " & $DriveType & @CRLF _
			& @CRLF & "Target Drive Type must be Removable USB-Stick ", 0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			_GUICtrlStatusBar_SetText($hStatus," Select USB-Stick as Target Drive ", 0)
			Return
		EndIf
		$FSvar = DriveGetFileSystem( $Tdrive )
		FOR $d IN $FileSys
			If $d = $FSvar Then
				$fs_ok = 1
				ExitLoop
			Else
				$fs_ok = 0
			EndIf
		NEXT
		IF Not $fs_ok Then 
			$valid = 0
			MsgBox(48, "WARNING - Invalid FileSystem", "NTFS - FAT32 or FAT FileSystem NOT Found" & @CRLF _
			& @CRLF & "Continue and First Format Target Drive ", 0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			_GUICtrlStatusBar_SetText($hStatus," First Format Target Drive ", 0)
			Return
		EndIf
	EndIf
	If $valid Then
		$TargetDrive = $Tdrive
		; $TargetDrive = StringLeft($TargetSelect, 2)
		
		GUICtrlSetData($Target, $TargetDrive)
		$TargetSpaceAvail = Round(DriveSpaceFree($TargetDrive))
		GUICtrlSetData($TargetSize, $FSvar & "     " & Round(DriveSpaceTotal($TargetDrive) / 1024, 1) & " GB")
		GUICtrlSetData($TargetFree, "FREE  =  " & Round(DriveSpaceFree($TargetDrive) / 1024, 1) & " GB")
	EndIf
	_GUICtrlStatusBar_SetText($hStatus," Select USB-Stick as Target Drive ", 0)
	DisableMenus(0)
EndFunc   ;==> _target_drive
;===================================================================================================
Func _ListUsb()
	
	Local $file, $line, $linesplit[20], $mptarget=0, $count
	
	If FileExists(@ScriptDir & "\makebt\usblist.txt") Then
		FileCopy(@ScriptDir & "\makebt\usblist.txt", @ScriptDir & "\makebt\usblist_bak.txt", 1)
		FileDelete(@ScriptDir & "\makebt\usblist.txt")
	EndIf
	Sleep(2000)
	
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
					If $linesplit[2] = $TargetDrive & "\" Then
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
		
	If $inst_disk = "" Or $inst_part = "" Then
		MsgBox(48, "WARNING - Target Drive is NOT Valid", "Device Number NOT Found in makebt\usblist.txt" & @CRLF & @CRLF & _
		"Target Drive = " & $TargetDrive & "   HDD = " & $inst_disk & "   PART = " & $inst_part)
		Exit
	EndIf
		
EndFunc ;==> _ListUsb
;===================================================================================================
Func DisableMenus($endis)
	If $endis = 0 Then 
		$endis = $GUI_ENABLE
	Else
		$endis = $GUI_DISABLE
	EndIf
	GUICtrlSetState($FormUSB, $GUI_DISABLE)
	GUICtrlSetState($ComboForm, $endis)
	GUICtrlSetState($Check_2nd, $endis)
	GUICtrlSetState($Combo_2nd, $endis)
	GUICtrlSetState($ComboBoot, $endis)
	GUICtrlSetState($Bootmgr_Menu, $endis)

	GUICtrlSetState($TargetSel, $endis)
	GUICtrlSetState($Target, $endis)
	GUICtrlSetData($Target, $TargetDrive)
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
Func _FormatUSB() ; Erase and Format USB-sticks using _FormatUSB
	Local $val=0
	Local $FSbox="FAT32", $FShex="0C", $ikey, $sigword="CD0B", $signat="CD0BCD0B0000", $PSize = "MIN"
	Local $mbrfound=0, $bkp, $mbr100sec
	Local $ECyl, $EHd, $ESec, $partab_1, $partab_2, $Nsec, $HNsec, $BCyl_2, $BSec_2, $ECyl_2, $ESec_2, $Hid2, $NSec2, $HNsec2, $NrC2=1, $part2=0 
	Local $file_rd, $fhan_rd, $rd_mbr, $file_wr, $fhan_wr, $wr_mbr, $fhan, $mvol, $Hid1 = 2048, $Hid1_bytes = 2048 * 512
	; Offset to Bootsector 1st partition is Hidden Sectors * Bytes per sector giving usually 2048 * 512 = 1048576
	
	DisableMenus(1)
	GUICtrlSetState($Exit, $GUI_DISABLE)

	$DriveType=DriveGetType($TargetDrive)
	
	; Should not occur ....
	If $DriveType <> "Removable" Then
		MsgBox(16, "Invalid Drive", " Drive is NOT Removable USB-stick ", 0)
		Exit
	EndIf
	
	If DriveStatus($TargetDrive) <> "READY" Then 
		MsgBox(48, "WARNING - Drive NOT Ready", "Drive NOT READY " & @CRLF & @CRLF & "First Format Target Drive using HP Tool ", 0)
		Exit
	EndIf

	If @SystemDir = "X:\i386\system32" Or @SystemDir = "X:\minint\system32" Then
		MsgBox(16, "BartPE type Operating System", " Unable to Format USB-stick in BartPE Environment ", 0)
		Exit
	EndIf

	; Should Not occur ....
	If Not FileExists(@ScriptDir & "\makebt\win8_mbr.dat") Then
		_GUICtrlStatusBar_SetText($hStatus," STOP - makebt\win8_mbr.dat Not Found ", 0)
		MsgBox(16, "STOP - ERROR - MBR File Not Found ", " Win8 MBR File makebt\win8_mbr.dat Not Found ", 0)
		Exit
	EndIf

	IF FileExists(@ScriptDir & "\makebt\bs_temp\usb_mbr.dat") Then
		FileDelete(@ScriptDir & "\makebt\bs_temp\usb_mbr.dat")
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Getting Drive Parameters - Wait ... ", 0)
	GUICtrlSetData($ProgressAll, 10)
	
		
	If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")
	
	Sleep(1000)
	
	$FSbox = GUICtrlRead($ComboForm)
	If $FSbox = "FAT32" Then
		$FShex = "0C"
	Else
		$FShex = "07"
	EndIf
	
	FileCopy(@ScriptDir & "\makebt\win8_mbr.dat", @ScriptDir & "\makebt\bs_temp\usb_mbr.dat", 1)

	Sleep(1000)

	_ListUsb()
	
	Sleep(1000)
	
	_MBRWiz()
	
	GUICtrlSetData($ProgressAll, 20)
	; Should NOT occur ....
	If $hpart <> 1 Or $hdisk = 0 Or $hdisk <> $inst_disk Or $hdisk="" Then
		MsgBox(16, "STOP - MBRWiz failed ", " Disk Number not defined ", 0)
		Exit
	EndIf

	If $TSize=0 Or $TCyl=0 Then
		MsgBox(16, "STOP - MBRWiz failed ", " Geometry of USB-Stick not defined ", 0)
		Exit
	EndIf

	If GUICtrlRead($Check_2nd) = $GUI_CHECKED Then $part2=1
	If $part2 Then
		$PSize = GUICtrlRead($Combo_2nd)
		If $PSize = "MAX" Then
			If $TCyl > 500 Then
				$NrC2 = $TCyl - 254
			Else
				$NrC2 = Round($TCyl * 0.5)
			EndIf
		ElseIf $PSize = "25 %" Then
			$NrC2 = Round($TCyl * 0.25)
		ElseIf $PSize = "50 %" Then
			$NrC2 = Round($TCyl * 0.5)
		ElseIf $PSize = "75 %" Then
			$NrC2 = Round($TCyl * 0.75)
		Else
			$NrC2 = 1
		EndIf
	EndIf

	; Create Partition Table Entry partition 1
	; 2048 = 32*63 + 33 - 1
	; case of 2048 hidden sectors = 0x0800
	
	$Hid1 = 32 * $TSec + 33 - 1
	$Hid1 = Int($Hid1)
	$Hid1_bytes = $Hid1 * 512
	
	If $part2 Then 
		$Nsec = ($TCyl - $NrC2) * $THds * $TSec - $Hid1
	Else
		$Nsec = $TCyl * $THds * $TSec - $Hid1
	EndIf

	; convert to Integer needed for Hex function
	$NSec = Int($NSec)
	$HNsec = Hex($NSec, 8)
	$ECyl = $TCyl - 1
	If $part2 Then $ECyl = $TCyl - 1 - $NrC2
	If $ECyl > 1023 Then $ECyl = 1023
	$ESec = BitShift(BitShift($ECyl, 8),-6) + $TSec
	$EHd = $THds - 1
	
	; convert to Integer needed for Hex function
	$ECyl = Int($ECyl)
	$ESec = Int($ESec)
	$EHd = Int($EHd)
	$TSec = Int($TSec)
	
	$partab_1 = "80202100" & $FShex & Hex($EHd, 2) & Hex($ESec, 2) & Hex($ECyl, 2) & "00080000" _
	& StringMid($HNsec, 7, 2) & StringMid($HNsec, 5, 2) & StringMid($HNsec, 3, 2) & StringMid($HNsec, 1, 2)
	
	; Create Partition Table Entry partition 2
	$Hid2 = Hex(($NSec + $Hid1), 8)
	$NSec2 = $NrC2 * $THds * $TSec
	; convert to Integer needed for Hex function
	$NSec2 = Int($NSec2)
	$HNsec2 = Hex($NSec2, 8)
	$BCyl_2 = $ECyl + 1
	$ECyl_2 = $ECyl + $NrC2
	If $BCyl_2 > 1023 Then $BCyl_2 = 1023
	If $ECyl_2 > 1023 Then $ECyl_2 = 1023
	$BSec_2 = BitShift(BitShift($BCyl_2, 8),-6) + 1
	$ESec_2 = BitShift(BitShift($ECyl_2, 8),-6) + $TSec

	; convert to Integer needed for Hex function
	$BCyl_2 = Int($BCyl_2)
	$BSec_2 = Int($BSec_2)
	$ESec_2 = Int($ESec_2)
	$ECyl_2 = Int($ECyl_2)

	; NTFS = 07
	$partab_2 = "0000" & Hex($BSec_2, 2) & Hex($BCyl_2, 2) & "07" & Hex($EHd, 2) & Hex($ESec_2, 2) & Hex($ECyl_2, 2) _
	& StringMid($Hid2, 7, 2) & StringMid($Hid2, 5, 2) & StringMid($Hid2, 3, 2) & StringMid($Hid2, 1, 2) _
	& StringMid($HNsec2, 7, 2) & StringMid($HNsec2, 5, 2) & StringMid($HNsec2, 3, 2) & StringMid($HNsec2, 1, 2)
		
	$ikey = MsgBox(48+4+256, "Erase and Quick Format USB-stick ? ", "USB-stick = " & $TargetDrive & "   Part = " & $hpart & "   Disk = " & $hdisk & "   Stick = " & $TSize & @CRLF _
	& "Geometry CHS = " & $TCyl & "  " & $THds & "  " & $TSec & @CRLF & @CRLF _
	& "Erase and Quick Format Target Drive " & $TargetDrive & " with " & $FSbox & "  "	& @CRLF & @CRLF _
	& "WARNING - All Data on Selected Drive get Lost ")

	; MsgBox(48, "partab_1 and partab_2", "partab_1 = " & $partab_1 & @CRLF & "partab_2 = " & $partab_2, 0)
	; Return

	If $ikey <> 6 Then 
		DisableMenus(0)
		GUICtrlSetState($Exit, $GUI_ENABLE)
		_GUICtrlStatusBar_SetText($hStatus," Select USB-Stick as Target Drive ", 0)
		Return
	EndIf
	
	$sigword = Hex(Random(4522, 56814, 1), 4)
	$signat = $sigword & $sigword & "0000"

	$file_rd = @ScriptDir & "\makebt\win8_mbr.dat"
	$file_wr = @ScriptDir & "\makebt\bs_temp\usb_mbr.dat"

	$fhan_rd = FileOpen($file_rd, 16)
	If $fhan_rd = -1 Then
		MsgBox(48, "ERROR - File NOT Open", "Unable to Read - File Handle = " & $fhan_rd & @CRLF & $file_rd, 0)
		Exit
	EndIf
	$rd_mbr = FileRead($fhan_rd)
	FileClose($fhan_rd)
	; Cut at 894 - 12
	If Not $part2 Then
		$wr_mbr = StringLeft($rd_mbr, 882) & $signat & $partab_1 & StringRight($rd_mbr, 100)
	Else
		$wr_mbr = StringLeft($rd_mbr, 882) & $signat & $partab_1 & $partab_2 & StringRight($rd_mbr, 68)
	EndIf

	$fhan_wr = FileOpen($file_wr, 16 + 2)
	If $fhan_wr = -1 Then
		MsgBox(48, "ERROR - File NOT Open", "Unable to Write - File Handle = " & $fhan_wr & @CRLF & $file_wr, 0)
		Exit
	EndIf
	FileWrite($fhan_wr , $wr_mbr)
	FileClose($fhan_wr)

	; Make backup of mbr 1st 100 sec
	$dt = StringReplace(_NowCalc(), "/", "", 0)
	$dt = StringReplace($dt, ":", "", 0)
	$dt = StringReplace($dt, " ", "-", 0)
	$bkp = "mbrorgdisk" & $hdisk & "-" & $dt & ".dat"
	; $mbr100sec = "mbr100secdisk" & $hdisk & "-" & $dt & ".dat"
	
	RunWait(@ComSpec & " /c makebt\dsfo.exe \\.\PHYSICALDRIVE" & $hdisk & " 0 512 makebt\backups\" & $bkp, @ScriptDir, @SW_HIDE)
	; RunWait(@ComSpec & " /c makebt\dsfo.exe \\.\PHYSICALDRIVE" & $hdisk & " 0 51200 makebt\backups\" & $mbr100sec, @ScriptDir, @SW_HIDE)

	; Test if disk has MBR, otherwise later Reconnect is necessary after dsfi is used to write MBR

	$mbrfound = HexSearch(@ScriptDir & "\makebt\backups\" & $bkp, "33C08ED0BC007C", 16, 1)
	If Not $mbrfound  Then $mbrfound = HexSearch(@ScriptDir & "\makebt\backups\" & $bkp, "EB5E80052039", 16, 1)
	If Not $mbrfound  Then $mbrfound = HexSearch(@ScriptDir & "\makebt\backups\" & $bkp, "33C0EB5C80002039", 16, 1)

	_GUICtrlStatusBar_SetText($hStatus," Quick Erase Target USB-stick - Wait ... ", 0)
	GUICtrlSetData($ProgressAll, 25)
	; Erase first 100 sectors and use dsfi.exe to write the created MBR with Partition Table
	RunWait(@ComSpec & " /c makebt\dsfi.exe \\.\PHYSICALDRIVE" & $hdisk & " 0 0 makebt\Erase_100.bin", @ScriptDir, @SW_HIDE)
	Sleep(3000)
	RunWait(@ComSpec & " /c makebt\dsfi.exe \\.\PHYSICALDRIVE" & $hdisk	& " 0 512 makebt\bs_temp\usb_mbr.dat", @ScriptDir, @SW_HIDE)
	GUICtrlSetData($ProgressAll, 30)
	Sleep(3000)

	If DriveStatus($TargetDrive) <> "READY" Or Not $mbrfound Then
		; case of Wiped Drive after Reconnect Or Drive without MBR, require to Refresh Info in OS After Creating MBR
		; Otherwise Drive without MBR will be formatted again without MBR and will be Not bootable
		MsgBox(48, "STOP - MBR Update Disconnect ", " First Disconnect and Reconnect USB-stick " & @CRLF _
		& " After Reconnect Click OK to Continue ", 0)
		Sleep(5000)
		; Repeat MBRWiz to determine $hdisk, which can have changed when previously USB-device with lower Harddisk Number was removed
		_MBRWiz()
		If $hpart <> 1 Or $hdisk = 0 Or $hdisk <> $inst_disk Or $hdisk="" Then
			MsgBox(16, "ERROR - Unable to Format Drive ", " Please Select Drive for Partition 1 of USB-stick ", 0)
			Exit
		EndIf
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Formatting Target USB-stick " & $TargetDrive & " - Wait ... ", 0)
	; Format Twice is used, where first format serves to Update Drive Info in Windows OS, so that second format corresponds to MBR made with dsfi
	
	; in case of old OS like XP begin with FAT32 format
	If @OSVersion = "WIN_VISTA" Or @OSVersion = "WIN_2003" Or @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Or @OSVersion = "WIN_2000" Then
		SystemFileRedirect("On")
		GUICtrlSetData($ProgressAll, 40)
		RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $TargetDrive & " /FS:FAT32 /Q /X /v:USB_BOOT /backup /force", "", @SW_HIDE)
		GUICtrlSetData($ProgressAll, 55)
		RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $TargetDrive & " /FS:FAT32 /Q /X /v:USB_BOOT /backup /force", "", @SW_HIDE)
		GUICtrlSetData($ProgressAll, 70)
		SystemFileRedirect("Off")
		Sleep(5000)
		
		If $FSbox = "FAT32" Then 
			_GUICtrlStatusBar_SetText($hStatus," BootSect.exe makes BOOTMGR-type BootSector - Wait ... ", 0)
			RunWait(@ComSpec & " /c makebt\BootSect.exe /nt60 " & $TargetDrive & " /force", @ScriptDir, @SW_HIDE)
			Sleep(5000)
			; Reset MBR to make FAT32 FileSystem byte = 0C (LBA) at offset 0x1C2 in MBR, after format it was 0B (CHS) and not bootable
			RunWait(@ComSpec & " /c makebt\dsfi.exe \\.\PHYSICALDRIVE" & $hdisk & " 0 512 makebt\bs_temp\usb_mbr.dat", @ScriptDir, @SW_HIDE)
			; BootSector at Offset 2048 * 512 = 1048576 bytes
			RunWait(@ComSpec & " /c makebt\dsfo.exe \\.\PHYSICALDRIVE" & $hdisk & " 1048576 512 makebt\bs_temp\usb_fat32.bin", @ScriptDir, @SW_HIDE)
			; drive-id patch 0x80 at offset 0x40 = 64 for FAT32 Bootsector and Backup Bootsector
			RunWait(@ComSpec & " /c makebt\dsfi.exe makebt\bs_temp\usb_fat32.bin" & " 64 1 makebt\p_x80.bin", @ScriptDir, @SW_HIDE)
			; BootSector at Offset 2048 * 512 = 1048576 bytes
			RunWait(@ComSpec & " /c makebt\dsfi.exe \\.\PHYSICALDRIVE" & $hdisk & " 1048576 512 makebt\bs_temp\usb_fat32.bin", @ScriptDir, @SW_HIDE)
			; Offset 6 * 512 = 3072 bytes for backup BootSector at Offset 2048 * 512 + 3072 = 1051648 bytes
			RunWait(@ComSpec & " /c makebt\dsfi.exe \\.\PHYSICALDRIVE" & $hdisk & " 1051648 512 makebt\bs_temp\usb_fat32.bin", @ScriptDir, @SW_HIDE)
		EndIf
		GUICtrlSetData($ProgressAll, 80)
		If $FSbox = "NTFS" Then
			SystemFileRedirect("On")
			_GUICtrlStatusBar_SetText($hStatus," Convert to NTFS - Wait ... ", 0)
			RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\convert.exe " & $TargetDrive & " /FS:NTFS", "", @SW_HIDE)
			SystemFileRedirect("Off")
			Sleep(5000)
			_GUICtrlStatusBar_SetText($hStatus," BootSect.exe makes BOOTMGR-type BootSector - Wait ... ", 0)
			RunWait(@ComSpec & " /c makebt\BootSect.exe /nt60 " & $TargetDrive & " /force", @ScriptDir, @SW_HIDE)
			Sleep(5000)
		Else
			; Disconnect needed to preserve BootSector 0x80 byte at offset 0x40 for FAT32 and offset 0x24 for FAT FileSystem
			; Otherwise Windows OS will make the drive-id byte 00 again so that USB-stick is Not Bootable
			;		MsgBox(48, "STOP - Bootsector Update Disconnect ", " First Disconnect and Reconnect USB-stick " & @CRLF _
			;		& " After Reconnect Click OK to Continue ", 0)
			;		Sleep(5000)
			; touchdrv can do the same but needs extra space before DriveLetter
			; RunWait('"' & @ScriptDir & "\makebt\touchdrv.exe " & '"' & " " & $TargetDrive, "", @SW_HIDE)
			RunWait("makebt\touchdrv.exe  " & $TargetDrive, @ScriptDir, @SW_HIDE)
		EndIf
		Sleep(3000)
		$BootLoader = GUICtrlRead($ComboBoot)
		If $BootLoader = "Grub4dos" Then
			_GUICtrlStatusBar_SetText($hStatus," Install Grub4dos in MBR BootCode - Wait ... ", 0)
			Sleep(3000)
			RunWait(@ComSpec & " /c makebt\grubinst.exe --skip-mbr-test (hd" & $hdisk & ")", @ScriptDir, @SW_HIDE)
			Sleep(3000)
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
		EndIf	
	Else
		GUICtrlSetData($ProgressAll, 40)
		If $FSbox = "FAT32" Then 
			SystemFileRedirect("On")
			RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $TargetDrive & " /FS:FAT32 /Q /X /v:USB_BOOT /backup /force", "", @SW_HIDE)
			GUICtrlSetData($ProgressAll, 55)
			RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $TargetDrive & " /FS:FAT32 /Q /X /v:USB_BOOT /backup /force", "", @SW_HIDE)
			SystemFileRedirect("Off")
			Sleep(2000)
			; Reset MBR to make FAT32 FileSystem byte = 0C (LBA) at offset 0x1C2 in MBR, after format it was 0B (CHS) and not bootable
			RunWait(@ComSpec & " /c makebt\dsfi.exe \\.\PHYSICALDRIVE" & $hdisk & " 0 512 makebt\bs_temp\usb_mbr.dat", @ScriptDir, @SW_HIDE)
		Else
			SystemFileRedirect("On")
			RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $TargetDrive & " /FS:NTFS /Q /X /v:USB_BOOT /backup /force", "", @SW_HIDE)
			GUICtrlSetData($ProgressAll, 55)
			RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\format.com " & $TargetDrive & " /FS:NTFS /Q /X /v:USB_BOOT /backup /force", "", @SW_HIDE)
			SystemFileRedirect("Off")
		EndIf
		GUICtrlSetData($ProgressAll, 70)
		Sleep(5000)
		$BootLoader = GUICtrlRead($ComboBoot)
		If $BootLoader = "Grub4dos" Then
			_GUICtrlStatusBar_SetText($hStatus," Install Grub4dos in MBR BootCode - Wait ... ", 0)
			Sleep(3000)
			RunWait(@ComSpec & " /c makebt\grubinst.exe --skip-mbr-test (hd" & $hdisk & ")", @ScriptDir, @SW_HIDE)
			Sleep(3000)
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
		EndIf
		If $TargetDrive <> "" And GUICtrlRead($Bootmgr_Menu) = $GUI_CHECKED Then
			SystemFileRedirect("On")
			If @OSVersion = "WIN_8" And @OSArch <> "X86" Then
				_GUICtrlStatusBar_SetText($hStatus," Win8 - Make Boot Manager Menu on USB Drive " & $TargetDrive & " - wait .... ", 0)
				$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdboot.exe " & @WindowsDir & " /s " & $TargetDrive & " /f ALL", @ScriptDir, @SW_HIDE)
			Else
				_GUICtrlStatusBar_SetText($hStatus," Make Boot Manager Menu on USB Drive " & $TargetDrive & " - wait .... ", 0)
				$val = RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdboot.exe " & @WindowsDir & " /s " & $TargetDrive, @ScriptDir, @SW_HIDE)
			EndIf
			Sleep(2000)
			; to get Win 8 Boot Manager Menu displayed and waiting for User Selection
			If FileExists($TargetDrive & "\EFI\Microsoft\Boot\BCD") And FileExists(@WindowsDir & "\system32\bcdedit.exe") Then
				RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
				& $TargetDrive & "\EFI\Microsoft\Boot\BCD" & " /set {default} bootmenupolicy legacy", $TargetDrive & "\", @SW_HIDE)
				RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
				& $TargetDrive & "\EFI\Microsoft\Boot\BCD" & " /set {default} detecthal on", $TargetDrive & "\", @SW_HIDE)
				If FileExists(@WindowsDir & "\SysWOW64") Then
					RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
					& $TargetDrive & "\EFI\Microsoft\Boot\BCD" & " /set {default} testsigning on", $TargetDrive & "\", @SW_HIDE)
					RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
					& $TargetDrive & "\EFI\Microsoft\Boot\BCD" & " /set {bootmgr} nointegritychecks on", $TargetDrive & "\", @SW_HIDE)
				EndIf
				RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
				& $TargetDrive & "\EFI\Microsoft\Boot\BCD" & " /bootems {emssettings} ON", $TargetDrive & "\", @SW_HIDE)
			EndIf
			If FileExists($TargetDrive & "\Boot\BCD") And FileExists(@WindowsDir & "\system32\bcdedit.exe") Then
				RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
				& $TargetDrive & "\Boot\BCD" & " /set {default} bootmenupolicy legacy", $TargetDrive & "\", @SW_HIDE)
				RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
				& $TargetDrive & "\Boot\BCD" & " /set {default} detecthal on", $TargetDrive & "\", @SW_HIDE)
				If FileExists(@WindowsDir & "\SysWOW64") Then
					RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
					& $TargetDrive & "\Boot\BCD" & " /set {default} testsigning on", $TargetDrive & "\", @SW_HIDE)
					RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
					& $TargetDrive & "\Boot\BCD" & " /set {bootmgr} nointegritychecks on", $TargetDrive & "\", @SW_HIDE)
				EndIf
				RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\bcdedit.exe" & " /store " _
				& $TargetDrive & "\Boot\BCD" & " /bootems {emssettings} ON", $TargetDrive & "\", @SW_HIDE)
			EndIf
			If Not FileExists($TargetDrive & "\boot.ini") Then
				IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
				"Default=C:\grldr")
				IniWriteSection($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr=" & '"GRUB4DOS Menu"')
				If Not FileExists($TargetDrive & "\grldr") Then	FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
				If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
			Else
				FileSetAttrib($TargetDrive & "\boot.ini", "-RSH")
				FileWriteLine($TargetDrive & "\boot.ini", "C:\grldr=" & '"GRUB4DOS Menu"')
			EndIf
			SystemFileRedirect("Off")
			Sleep(3000)
		EndIf	
	EndIf
	
	$FSvar = DriveGetFileSystem($TargetDrive)
	GUICtrlSetData($Target, $TargetDrive)
	GUICtrlSetData($TargetSize, $FSvar & "     " & Round(DriveSpaceTotal($TargetDrive) / 1024, 1) & " GB")
	GUICtrlSetData($TargetFree, "FREE  =  " & Round(DriveSpaceFree($TargetDrive) / 1024, 1) & " GB")
	GUICtrlSetData($ProgressAll, 90)
		
	_GUICtrlStatusBar_SetText($hStatus," Finishing - Wait 3 seconds ....", 0)
	Sleep(3000)
	_GUICtrlStatusBar_SetText($hStatus," Formatting Target USB-stick - Ready ", 0)
	GUICtrlSetData($ProgressAll, 100)
	MsgBox(64, "FORMAT - Ready", "Formatting Target USB-stick - Ready", 0)
	Exit

EndFunc ;==> _FormatUSB
;===================================================================================================
Func _MBRWiz()
	Local $file, $line, $linesplit, $dsk="", $dSize, $dCyl, $dHds, $dSec
	Local $count, $rg, $numreplace

	IF FileExists(@ScriptDir & "\makebt\dpusb.txt") Then
		FileCopy(@ScriptDir & "\makebt\dpusb.txt", @ScriptDir & "\makebt\dpusb_bak.txt", 1)
		FileDelete(@ScriptDir & "\makebt\dpusb.txt")
	EndIf
	
	IF @OSArch = "X86" Then 
		RunWait(@ComSpec & " /c makebt\MBRWiz.exe /list > makebt\dpusb.txt", @ScriptDir, @SW_HIDE)
	Else
		RunWait(@ComSpec & " /c makebt\MBRWiz64.exe /list > makebt\dpusb.txt", @ScriptDir, @SW_HIDE)
	EndIf
	
	If Not FileExists(@ScriptDir & "\makebt\dpusb.txt") Then
		MsgBox(16, "STOP - MBRWiz Failed ", "MBRWiz Failed to make File dpusb.txt" & "Missing File " & @ScriptDir & "\makebt\dpusb.txt", 0)
		Exit
	EndIf

	$file = FileOpen(@ScriptDir & "\makebt\dpusb.txt", 0)
	If $file = -1 Then
		MsgBox(16, "ERROR - File NOT Open", "Unable to open - File Handle = " & $file & @CRLF & @ScriptDir & "\makebt\dpusb.txt", 0)
		Exit
	EndIf

	$count = 0
	$numreplace = 0
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		If $line <> "" Then
			$count = $count + 1
			$line = StringStripWS($line, 3)
			Do 
				$line = StringReplace($line, "  ", " ")
				$numreplace = @extended
			Until $numreplace = 0
			$linesplit = StringSplit($line, " ")
			; _ArrayDisplay($linesplit)
			If $linesplit[1] = "Disk:" Then
				$dsk = $linesplit[2]
				If $linesplit[3] = "Size:" Then
					$dSize = $linesplit[4]
					$dCyl = $linesplit[6]
					$dHds = $linesplit[7]
					$dSec = $linesplit[8]
				EndIf
				$rg = $count + 3
			EndIf
			If $count=$rg Then
				$rg = $rg + 1
				If $linesplit[9] = $TargetDrive Then
					$hpart = $linesplit[1] + 1
					$mbrndx = $linesplit[2]
					$act = $linesplit[5]
					$hdisk = $dsk
					$TSize = $dSize
					$TCyl = $dCyl
					$THds = $dHds
					$TSec = $dSec
				EndIf
			EndIf
		EndIf
	Wend

	FileClose($file)
EndFunc ;==> __MBRWiz
;===================================================================================================

#RequireAdmin
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1 + file SciTEUser.properties in your UserProfile e.g. C:\Documents and Settings\UserXP Or C:\Users\User-7
 
 Author:        WIMB  -  April 15, 2014

 Program:       BOOT_IMG.exe  - Version 8.5 in rule 145
	can be used to Install IMG or ISO Files as Boot Option on Harddisk or USB-drive
	part of IMG_XP Package 
	 
	Running in XP or Vista / Windows 7 / 8 Environment and in LiveXP PE or 7PE Environment

 Script Function:
	Install Boot IMAGE File on Harddisk or USB-Drive
	Enables to Launch Boot Image from GRUB4DOS menu.lst
	Useful as Escape Boot Option for System Backup and Restore with Ghost
	or to boot with PE to prepare your Harddisk for Install of Windows XP or Windows 7

	Install as Boot Option on Harddisk or USB-Drive of: 
	- BartPE / UBCD4Win / LiveXP - IMG or ISO files booting from RAMDISK
	- Parted Magic - Acronis - LiveXP_RAM - CD - ISO File
	- Superfloppy Image files e.g. to boot 15 MB FreeDOS or 25 MB MS-DOS floppy images
	- XP Recovery Console Image RECONS.img booting from RAMDISK
	- 7pe_x86_E.iso - Win7 PE booting from RAMDISK
	- XP*.vhd - XP VHD Image file booting as FILEDISK or RAMDISK using WinVBlock or FiraDisk driver
	- W7*.vhd - Win7 VHD file booting as FILEDISK or RAMDISK using WinVBlock or FiraDisk driver
	- W8*.vhd - Win8 VHD file booting as FILEDISK or RAMDISK using WinVBlock or FiraDisk driver
	
 Credits:
 	Sha0 for creating WinVBlock driver which enables to boot XP from RAMDISK loaded with XP Image file or from FILEDISK on USB drive
	karyonix for creating FiraDisk RAMDISK driver and Olof Lagerkvist for ImDisk virtual disk driver and strarc

	Nuno Brito, Peter Schlang - psc , Galapo and allanf and many others of Reboot Forum for Creating WinBuilder 
	amalux for his Ready to use LiveXP Projects and his excellent Tutorial http://www.boot-land.net/forums/index.php?showtopic=4111
	ilko_t, jaclaz and cdob from MSFN forum for their continuous help 
	as well as everyone, who contributed to the project with ideas, requests or feedback.

	Thanks to ilko_t and to SmOke_N and ezzetabi from AutoIt forum for their excellent AutoIt script examples, parts of which were used.

	The program is released "as is" and is free for redistribution and use as long as original author, 
	credits part and link to the 911cd Or Reboot support forum are clearly mentioned:
	
	IMG_XP - Universal HDD Image files for XP and Windows 7 - http://www.911cd.net/forums//index.php?showtopic=23553
	
	Make_PE3 Program to Create Portable Windows 7 PE - http://www.911cd.net/forums//index.php?showtopic=23931
	
	U_XP_SET -Install from USB AFTER Booting with PE - http://www.911cd.net/forums//index.php?showtopic=21883

	WinVBlock of Sha0 http://reboot.pro/8168/
	FiraDisk of karyonix http://reboot.pro/8804/ and http://reboot.pro/forum/94/

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
Global $TargetDrive="", $ProgressAll, $Paused, $g4d_vista=0, $mk_bcd=0, $ntfs_bs=1, $bs_valid=0, $g4d_w7vhd_flag=1, $SysWOW64=0
Global $btimgfile="", $pe_nr=1, $hStatus, $pausecopy=0, $TargetSpaceAvail=0, $TargetSize, $TargetFree, $FSvar_WinDrvDrive="", $g4d=0, $bm_flag = 0, $g4dmbr=0
Global $hGuiParent, $GO, $EXIT, $SourceDir, $Source, $TargetSel, $Target, $image_file="", $img_fext="", $grldrUpd, $g4d_bcd, $xp_bcd
Global $OldIMGSize=0, $BTIMGSize=0, $IMG_File, $IMG_FileSelect, $ImageType, $ImageSize, $NTLDR_BS=1, $bcdedit="", $Menu_Type, $bcd_flag = 0
Global $DriveType="Fixed", $usbfix=0, $IMG_Path = "", $NoVirtDrives, $FixedDrives, $driver_flag=2, $bootsdi = ""

Global $WinFol="\Windows"

Global $w7drive="", $WinDrv, $WinDrvSel, $WinDrvSize, $WinDrvFree, $WinDrvFileSys, $WinDrvSpaceAvail=0, $WinDrvDrive=""

Global $OS_drive = StringLeft(@WindowsDir, 2)

Global $str = "", $bt_files[5] = ["\makebt\dsfo.exe", "\makebt\listusbdrives\ListUsbDrives.exe", "\makebt\grldr.mbr", "\makebt\grldr", "\makebt\menu.lst"]

For $str In $bt_files
	If Not FileExists(@ScriptDir & $str) Then
		MsgBox(48, "ERROR - Missing File", "File " & $str & " NOT Found ")
		Exit
	EndIf
Next

If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")
	
If Not FileExists(@ScriptDir & "\makebt\Boot_XP") Then DirCreate(@ScriptDir & "\makebt\Boot_XP")

SystemFileRedirect("On")
If Not FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
	If FileExists(@WindowsDir & "\system32\bcdedit.exe") And @OSArch = "X86" Then
		FileCopy(@WindowsDir & "\system32\bcdedit.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf
SystemFileRedirect("Off")

If Not FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then
	If FileExists($OS_drive & "\BOOTFONT.BIN") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
		FileCopy($OS_drive & "\BOOTFONT.BIN", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", "-RSH")
	EndIf
EndIf
		
If Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") Then
	If FileExists($OS_drive & "\NTDETECT.COM") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
		FileCopy($OS_drive & "\NTDETECT.COM", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", "-RSH")
	EndIf
EndIf
		
If Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then
	If FileExists($OS_drive & "\NTLDR") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
		FileCopy($OS_drive & "\NTLDR", @ScriptDir & "\makebt\Boot_XP\", 1)
		FileSetAttrib(@ScriptDir & "\makebt\Boot_XP\NTLDR", "-RSH")
	EndIf
EndIf

If Not FileExists(@ScriptDir & "\makebt\xcopy.exe") Then
	If FileExists(@WindowsDir & "\system32\xcopy.exe") And @OSVersion = "WIN_XP" And @OSArch = "X86" Then
		FileCopy(@WindowsDir & "\system32\xcopy.exe", @ScriptDir & "\makebt\", 1)
	EndIf
EndIf

; HotKeySet("{PAUSE}", "TogglePause")
; HotKeySet("{ESC}", "TogglePause")

; Creating GUI and controls
$hGuiParent = GUICreate(" BOOT_IMG - Make Boot Menu for VHD ISO or WIM", 400, 430, 100, 40, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")


GUICtrlCreateGroup("Source   - Version 8.5 ", 18, 10, 364, 235)

$ImageType = GUICtrlCreateLabel( "", 270, 29, 110, 15, $ES_READONLY)
$ImageSize = GUICtrlCreateLabel( "", 210, 29, 50, 15, $ES_READONLY)

GUICtrlCreateLabel( "Boot Image - VHD IMG ISO or WIM", 32, 29)
$IMG_File = GUICtrlCreateInput("", 32, 45, 303, 20, $ES_READONLY)
$IMG_FileSelect = GUICtrlCreateButton("...", 341, 46, 26, 18)
GUICtrlSetTip(-1, " Make entry in Grub4dos Menu on Boot Drive for VHD IMG or ISO file " & @CRLF _
& " Make entry in Boot Manager Menu on Boot Drive for VHD or WIM file " & @CRLF _
& " Will Copy IMG ISO or WIM to Boot Drive and VHD to System Drive e.g. " & @CRLF _
& " BTFRDOS.img or BTMSDOS.img SuperFLoppy IMG " & @CRLF _
& " BartPE.iso or RECONS.img booting from RAMDISK " & @CRLF _
& " WinBuilder\ISO\Ram\I386\BootSDI.img - LiveXP " & @CRLF _
& " WinBuilder\ISO\LiveXP_WIM.iso - CD - ISO " & @CRLF _
& " Win 7PE - 7pe_x86_E.iso - WinPE - ISO " & @CRLF _
& " ubcd50b12.iso or pmagic-x.iso - CD - ISO " & @CRLF _
& " XP*.vhd - WinVBlock or FiraDisk - VHD - IMG" & @CRLF _
& " W7*.vhd - WinVBlock or FiraDisk - VHD - IMG" & @CRLF _
& " boot.wim - 7/8 Recovery or 7/8 PE - WinPE - WIM")

GUICtrlSetOnEvent($IMG_FileSelect, "_img_fsel")

GUICtrlCreateLabel( "Grub4dos and Boot Manager Menu are made on FAT32 Boot Drive", 32, 78)

GUICtrlCreateLabel( "VHD is copied to NTFS System Drive and ISO or WIM to Boot Drive", 32, 103)


; GUICtrlCreateGroup("Settings", 18, 130, 364, 115)

GUICtrlCreateLabel( "VHD", 32, 136, 30, 15)

$Menu_Type = GUICtrlCreateCombo("", 66, 131, 105, 24, $CBS_DROPDOWNLIST)
GUICtrlSetData($Menu_Type,"XP - WinVBlock|XP - FiraDisk|W7 - WinVBlock|W7 - FiraDisk", "XP - WinVBlock")
GUICtrlSetTip($Menu_Type, " Select Boot Menu Type for VHD - IMG file " & @CRLF _
& " Make Grub4dos Menu on Boot Drive for XP or Win7 Image " & @CRLF _
& " with WinVBlock or FiraDisk as FileDisk Driver ")

$grldrUpd = GUICtrlCreateCheckbox("", 224, 188, 17, 17)
GUICtrlSetTip($grldrUpd, " Update Grub4dos grldr Version on Boot Drive " & @CRLF _
& " Forces Update grldr.mbr and Add Grub4dos to Boot Manager Menu ")
GUICtrlCreateLabel( "Update Grub4dos grldr", 248, 190)

$g4d_bcd = GUICtrlCreateCheckbox("", 32, 188, 17, 17)
GUICtrlSetTip($g4d_bcd, " Add Grub4dos to Boot Manager Menu " & @CRLF _
& " Always done when grldr.mbr is not found on Boot Drive " & @CRLF _
& " Requires User Account Control = OFF ")
GUICtrlCreateLabel( "Add G4d to Boot Manager", 56, 190)

$xp_bcd = GUICtrlCreateCheckbox("", 32, 213, 17, 17)
GUICtrlSetTip($xp_bcd, " Add Start XP to Boot Manager Menu " & @CRLF _
& " Boot Drive booting with bootmgr " & @CRLF _
& " Requires User Account Control = OFF ")
GUICtrlCreateLabel( "Add XP  to Boot Manager", 56, 215, 130, 15)

GUICtrlCreateGroup("Target", 18, 252, 364, 89)

GUICtrlCreateLabel( "Boot Drive", 32, 273)
$Target = GUICtrlCreateInput("", 110, 270, 95, 20, $ES_READONLY)
$TargetSel = GUICtrlCreateButton("...", 211, 271, 26, 18)
GUICtrlSetTip(-1, " Select your Boot Drive - Active Drive for Boot and ISO or WIM Files " & @CRLF _
& " Folder Name images  Max = 8 chars  is allowed as Target for ISO or WIM " & @CRLF _
& " Make entry in Grub4dos Boot Menu for VHD IMG or ISO file ")
GUICtrlSetOnEvent($TargetSel, "_target_drive")
$TargetSize = GUICtrlCreateLabel( "", 253, 264, 100, 15, $ES_READONLY)
$TargetFree = GUICtrlCreateLabel( "", 253, 281, 100, 15, $ES_READONLY)

GUICtrlCreateLabel( "System Drive", 32, 315)
$WinDrv = GUICtrlCreateInput("", 110, 312, 95, 20, $ES_READONLY)
$WinDrvSel = GUICtrlCreateButton("...", 211, 313, 26, 18)
GUICtrlSetTip(-1, " Select your System Drive - NTFS for VHD Image files " & @CRLF _
& " GO will Copy XP or Win7 VHD file to System Drive and " & @CRLF _
& " Make entry for VHD or IMG in Grub4dos Menu on Boot Drive ")
GUICtrlSetOnEvent($WinDrvSel, "_WinDrv_drive")
$WinDrvSize = GUICtrlCreateLabel( "", 253, 306, 100, 15, $ES_READONLY)
$WinDrvFree = GUICtrlCreateLabel( "", 253, 323, 100, 15, $ES_READONLY)

$GO = GUICtrlCreateButton("GO", 235, 360, 70, 30)
GUICtrlSetTip($GO, " GO will Make entry in Boot Manager Menu on Boot Drive for WIM file " & @CRLF _
& " Make entry in Grub4dos Menu on Boot Drive for VHD IMG or ISO file " & @CRLF _
& " Will Copy IMG ISO or WIM to Boot Drive and VHD to System Drive ")

$EXIT = GUICtrlCreateButton("EXIT", 320, 360, 60, 30)
GUICtrlSetState($GO, $GUI_DISABLE)
GUICtrlSetOnEvent($GO, "_Go")
GUICtrlSetOnEvent($EXIT, "_Quit")

$ProgressAll = GUICtrlCreateProgress(16, 368, 203, 16, $PBS_SMOOTH)

$hStatus = _GUICtrlStatusBar_Create($hGuiParent, -1, "", $SBARS_TOOLTIPS)
Global $aParts[3] = [310, 350, -1]
_GUICtrlStatusBar_SetParts($hStatus, $aParts)

_GUICtrlStatusBar_SetText($hStatus," Select Source file and Target Drives", 0)

DisableMenus(1)

GUICtrlSetState($grldrUpd, $GUI_UNCHECKED + $GUI_ENABLE)

GUICtrlSetState($g4d_bcd, $GUI_UNCHECKED + $GUI_DISABLE)
GUICtrlSetState($xp_bcd, $GUI_UNCHECKED + $GUI_DISABLE)

GUICtrlSetState($IMG_FileSelect, $GUI_ENABLE)
GUICtrlSetState($TargetSel, $GUI_ENABLE)
; GUICtrlSetState($WinDrvSel, $GUI_ENABLE)

GUICtrlSetState($Menu_Type, $GUI_DISABLE)

GUISetState(@SW_SHOW)

;===================================================================================================
While 1
	CheckGo()
    Sleep(300)
WEnd   ;==> Loop
;===================================================================================================
Func CheckGo()

	If $btimgfile <> "" And $IMG_Path <> "" Then
		If GUICtrlRead($ImageType) = "VHD - IMG" Then
			If $WinDrvDrive <> "" Then
				GUICtrlSetState($GO, $GUI_ENABLE)
				_GUICtrlStatusBar_SetText($hStatus," Use GO to Install Image file in Boot Menu", 0)
			Else
				If GUICtrlRead($GO) = $GUI_ENABLE Then
					GUICtrlSetState($GO, $GUI_DISABLE)
					_GUICtrlStatusBar_SetText($hStatus," Select Source file and Target Drives", 0)
				EndIf
			EndIf
		Else
			GUICtrlSetState($GO, $GUI_ENABLE)
			_GUICtrlStatusBar_SetText($hStatus," Use GO to Install Image file in Boot Menu", 0)
		EndIf
	Else
		If GUICtrlRead($GO) = $GUI_ENABLE Then
			GUICtrlSetState($GO, $GUI_DISABLE)
			_GUICtrlStatusBar_SetText($hStatus," Select Source file and Target Drives", 0)
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
				DisableMenus(0)
				; GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
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
Func _img_fsel()
	Local $len, $pos, $img_fname="", $btpos, $valid=0, $pos3=0, $pos4=0, $pos5=0, $noxpmbr = 0, $pos1=0, $pos2=0

	DisableMenus(1)
	_GUICtrlStatusBar_SetText($hStatus," Select Source file and Target Drives", 0)
	GUICtrlSetData($ImageType, "")
	GUICtrlSetData($ImageSize, "")
	GUICtrlSetData($IMG_File, "")
	$btimgfile = ""
	$image_file=""
	$img_fext=""
	$bootsdi = ""
	$BTIMGSize=0
	If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")
		
	$WinDrvDrive = ""
	GUICtrlSetData($WinDrv, "")
	GUICtrlSetData($WinDrvFileSys, "")			
	GUICtrlSetData($WinDrvSize, "")
	GUICtrlSetData($WinDrvFree, "")

	$btimgfile = FileOpenDialog("Select Boot Image File for Install on Target Drive", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Boot Image Files ( *.vhd; *.wim; *.img; *.ima; *.iso; *.is_; *.im_; )")
	If @error Then
		$btimgfile = ""
		DisableMenus(0)
		Return
	EndIf
	
	$pos = StringInStr($btimgfile, " ", 0, -1)
	If $pos Then
		MsgBox(48,"ERROR - Image Path Invalid", "Image Path Invalid - Space Found" & @CRLF & @CRLF & "Selected Image = " & $btimgfile & @CRLF & @CRLF _
		& "Solution - Use simple Image Path without Spaces ")
		;	$btimgfile = ""
		;	DisableMenus(0)
		;	Return
	EndIf

	$len = StringLen($btimgfile)
	$pos = StringInStr($btimgfile, "\", 0, -1)
	$image_file = StringRight($btimgfile, $len-$pos)
	$len = StringLen($image_file)
	$pos = StringInStr($image_file, ".", 0, -1)
	$img_fext = StringRight($image_file, $len-$pos)
	$img_fname = StringLeft($image_file, $pos-1)
	If $img_fext = "iso" Or $img_fext = "is_" Then
		If $len > 30 Or StringRegExp($img_fname, "[^A-Z0-9a-z-_.]") Or StringRegExp($img_fext, "[^A-Za-z_]") Then
			MsgBox(48, " FileName NOT Valid ", "Selected = " & $image_file & @CRLF & @CRLF & "Max 26.3 FileName with  " & @CRLF & "Characters 0-9 A-Z a-z - _  ")
			$btimgfile = ""
			DisableMenus(0)
			Return
		EndIf
	ElseIf $img_fext = "img" Or $img_fext = "im_" Or $img_fext = "ima" Then
		If $len > 12 Or StringRegExp($img_fname, "[^A-Z0-9a-z-_]") Or StringRegExp($img_fext, "[^A-Za-z_]") Then
			MsgBox(48, " File or FileName NOT Valid ", "Selected = " & $image_file & @CRLF & @CRLF _
			& "IMG FileNames must be conform DOS 8.3 " & @CRLF & "Allowed Characters 0-9 A-Z a-z - _  ")
			$btimgfile = ""
			DisableMenus(0)
			Return
		EndIf
	Else
	EndIf
	$BTIMGSize = FileGetSize($btimgfile)
	$BTIMGSize = Round($BTIMGSize / 1024 / 1024)
	GUICtrlSetData($ImageSize, $BTIMGSize & " MB")
	
	If $img_fext = "iso" Or $img_fext = "is_" Then
		RunWait(@ComSpec & " /c makebt\dsfo.exe " & '"' & $btimgfile & '"' & " 43008 512 makebt\bs_temp\iso_43008_512.bs", @ScriptDir, @SW_HIDE)
		$pos3 = HexSearch(@ScriptDir & "\makebt\bs_temp\iso_43008_512.bs", "WINSXS", 16, 0)
		If $pos3 Then
			GUICtrlSetData($ImageType, "BartPE - ISO")
			If $BTIMGSize < 500 Then $valid = 1
		Else	
			$pos4 = HexSearch(@ScriptDir & "\makebt\bs_temp\iso_43008_512.bs", "SOURCES", 16, 0)
			; $pos5 = HexSearch(@ScriptDir & "\makebt\bs_temp\iso_43008_512.bs", "BOOT", 16, 0)
			; If $pos4 Or $pos5 Then
			If $pos4 Then
				GUICtrlSetData($ImageType, "WinPE - ISO")
				If $BTIMGSize < 700 Then $valid = 1
			Else
				GUICtrlSetData($ImageType, "CD - ISO")
				If $BTIMGSize < 700 Then $valid = 1
			EndIf
		EndIf
	ElseIf $img_fext = "wim" Then
		SystemFileRedirect("On")
		If FileExists(@WindowsDir & "\system32\bcdedit.exe") Then
			$bcdedit = @WindowsDir & "\system32\bcdedit.exe"
		; 32-bits makebt\bcdedit.exe can be used in any case
		;	ElseIf FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
		;		$bcdedit = @ScriptDir & "\makebt\bcdedit.exe"
		Else
			GUICtrlSetData($ImageType, "")
			GUICtrlSetData($ImageSize, "")
			GUICtrlSetData($IMG_File, "")
			$btimgfile = ""
			$image_file=""
			$img_fext=""
			$bootsdi = ""
			$BTIMGSize=0
			SystemFileRedirect("Off")
			MsgBox(48, "WARNING - bcdedit.exe is missing ", "Unable to Add WIM to Boot Manager Menu " & @CRLF & @CRLF _
			& "Need Windows 7 / 8 Or 7/8 PE to Add WIM to Boot Manager " & @CRLF & @CRLF & " Boot with Windows 7 / 8 or 7/8 PE ", 5)
			DisableMenus(0)
			Return
		EndIf
		MsgBox(48, " Info - Boot\boot.sdi Ramdisk File is needed", "Continue with OK and use the FileSelector " & @CRLF & @CRLF _
		& "Select your Boot\boot.sdi Ramdisk File for Copy to Boot Drive " & @CRLF & @CRLF _
		& "For Cancel then Windows\Boot\DVD\PCAT\boot.sdi is used if needed ", 0)
		$bootsdi = FileOpenDialog("Select Boot\boot.sdi Ramdisk File for Copy to Boot Drive", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "RAMDISK Boot\boot.sdi File ( *.sdi; )")
		If @error Then
			If FileExists(@WindowsDir & "\Boot\DVD\PCAT\boot.sdi") Then
				$bootsdi = @WindowsDir & "\Boot\DVD\PCAT\boot.sdi"
			ElseIf FileExists(@WindowsDir & "\system32\boot.sdi") Then
				$bootsdi = @WindowsDir & "\system32\boot.sdi"
			Else
				MsgBox(48, "WARNING - boot.sdi Not found ", "Boot\boot.sdi Ramdisk File may be needed " & @CRLF & @CRLF _
				& " Next time Boot with Windows 7 / 8 or 7 PE ")
			EndIf
		EndIf
		SystemFileRedirect("Off")
		$valid = 1
		GUICtrlSetData($ImageType, "WinPE - WIM")
	Else
		RunWait(@ComSpec & " /c makebt\dsfo.exe " & '"' & $btimgfile & '"' & " 0 512 makebt\bs_temp\img_512.bs", @ScriptDir, @SW_HIDE)
		$pos1 = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "NTFS", 16, 0)
		$pos2 = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "FAT", 16, 0)
		If $pos1 Or $pos2 Then
			If $BTIMGSize >= 500 And $BTIMGSize < 3600 Then 
				$valid = 0
				MsgBox(48, " WARNING - SuperFloppy Image - MBR is missing ", "Selected = " & $btimgfile & @CRLF & @CRLF _
					& "Image Size = " & $BTIMGSize & " MB " & @CRLF & @CRLF _
					& "SuperFloppy Image - NTFS or FAT in BootSector Found " & @CRLF & @CRLF _
					& "Image Not Bootable from FiraDisk RAMDISK ", 0)
				$btimgfile = ""
				GUICtrlSetData($ImageType, "")
				GUICtrlSetData($ImageSize, "")
				DisableMenus(0)
				Return
			EndIf
			; FAT BootSector
			If $pos2 = 55 Then
				$btpos = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "NTLDR", 16, 0)
				If $btpos = 418 And $BTIMGSize < 16 Then 
					GUICtrlSetData($ImageType, "XP Rec Cons - IMG")
					$valid = 1
				EndIf
				$btpos = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "SETUPLDRBIN", 16, 0)
				If $btpos = 418 And $BTIMGSize < 16 Then 
					GUICtrlSetData($ImageType, "XP Rec Cons - IMG")
					$valid = 1
				EndIf
				$btpos = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "KERNEL  SYS", 16, 0)
				If $btpos = 498 And $BTIMGSize < 16 Then 
					GUICtrlSetData($ImageType, "FreeDOS - IMG")
					$valid = 1
				EndIf
				$btpos = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "IO      SYS", 16, 0)
				If $btpos = 473 And $BTIMGSize < 26 Then 
					GUICtrlSetData($ImageType, "MS-DOS - IMG")
					$valid = 1
				EndIf
			EndIf
			; NTFS BootSector
			If $pos1 = 4 And Not $valid Then
				GUICtrlSetData($ImageType, "LiveXP BootSDI - IMG")
				If $BTIMGSize < 500 Then $valid = 1
			EndIf
		Else
			; HDD Image - WinVBlock or FiraDisk driver
			; Vista MBR and NTFS Bootsector contain 33C08ED0BC007C whereas XP MBR has 33C08ED0BC007CFB50
	;		$noxpmbr = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "33C08ED0BC007CFB50", 16, 1)
			$noxpmbr = HexSearch(@ScriptDir & "\makebt\bs_temp\img_512.bs", "33C08ED0BC007C", 16, 1)
	;		MsgBox(48, "INFO - Search MBR BootCode", "MBR BootCode at pos = " & $noxpmbr, 0)
			If $noxpmbr <> 1 Then
				$valid = 0
				MsgBox(48, " WARNING - MBR BootCode NOT Found ", "Selected = " & $btimgfile & @CRLF & @CRLF _
					& "Image Size = " & $BTIMGSize & " MB " & @CRLF & @CRLF _
					& "MBR BootCode and valid BootSector NOT Found " & @CRLF & @CRLF _
					& "Image Not Bootable ", 0)
				$btimgfile = ""
				GUICtrlSetData($ImageType, "")
				GUICtrlSetData($ImageSize, "")
				DisableMenus(0)
				Return
			EndIf
			$valid = 1
			GUICtrlSetData($ImageType, "VHD - IMG")
			If StringLeft($image_file, 2) = "XP" Then
				GUICtrlSetData($Menu_Type,"XP - WinVBlock")
			Else
				GUICtrlSetData($Menu_Type,"W7 - FiraDisk")
			EndIf
		EndIf
	EndIf
	
	If GUICtrlRead($ImageType) = "LiveXP BootSDI - IMG" Or GUICtrlRead($ImageType) = "BartPE - ISO" Or GUICtrlRead($ImageType) = "XP Rec Cons - IMG" Then
		If Not FileExists(@ScriptDir & "\makebt\srsp1\setupldr.bin") Then
			MsgBox(48, "WARNING - Missing Server 2003 SP1 Files setupldr.bin", "Files \makebt\srsp1\setupldr.bin NOT Found " _
			& @CRLF & @CRLF & "Copy File Winbuilder\Workbench\Common\BootSDI\setupldr.bin " _
			& @CRLF & @CRLF & "And ramdisk.sys to makebt\srsp1 folder ")
			$valid = 0
			GUICtrlSetData($ImageSize, "")
			GUICtrlSetData($ImageType, "")
			$btimgfile = ""
			DisableMenus(0)
			Return
		EndIf
	EndIf

	If GUICtrlRead($ImageType) = "LiveXP BootSDI - IMG" Then
		$pos2 = StringInStr($btimgfile, "\", 0, -2)
		If $pos2 Then
			If FileExists(StringLeft($btimgfile, $pos2) & "WIMs") Then
				MsgBox(48, " WIMs Folder Found - BootSDI.img NOT Valid as RAMBOOT IMAGE ", "Selected Image = " & $btimgfile & @CRLF & @CRLF _
				& "Use LiveXP_RAM.iso File containing WIMs as RAMBOOT IMAGE " & @CRLF & @CRLF _
				& "Or Make BootSDI.img without using WimPack in WinBuilder ")
				$valid = 0
				GUICtrlSetData($ImageSize, "")
				GUICtrlSetData($ImageType, "")
				$btimgfile = ""
				DisableMenus(0)
				Return
			EndIf
		EndIf
		If $BTIMGSize < 5 Then $valid = 0
	EndIf
		
	If $valid Then
		GUICtrlSetData($IMG_File, $btimgfile)
		GUICtrlSetData($ImageSize, $BTIMGSize & " MB")
	Else
		MsgBox(48, " Image File NOT Supported ", "Selected = " & $image_file & @CRLF & @CRLF _
		& "Image Size = " & $BTIMGSize & " MB " & @CRLF & @CRLF _
		& "Incompatible Image Type ")
		GUICtrlSetData($ImageSize, "")
		GUICtrlSetData($ImageType, "")
		GUICtrlSetData($IMG_File, "")
		$btimgfile = ""
	EndIf
	DisableMenus(0)
EndFunc   ;==> _img_fsel
;===================================================================================================
Func _target_drive()
	Local $TargetSelect, $Tdrive, $FSvar, $valid = 0, $ValidDrives, $RemDrives
	Local $NoDrive[3] = ["A:", "B:", "X:"], $FileSys[3] = ["NTFS", "FAT32", "FAT"]
	Local $pos, $fs_ok=0

	$DriveType="Fixed"
	DisableMenus(1)
	GUICtrlSetState($GO, $GUI_DISABLE)
	$IMG_Path = ""
	$ValidDrives = DriveGetDrive( "FIXED" )
	_ArrayPush($ValidDrives, "")
	_ArrayPop($ValidDrives)
	$RemDrives = DriveGetDrive( "REMOVABLE" )
	_ArrayPush($RemDrives, "")
	_ArrayPop($RemDrives)
	_ArrayConcatenate($ValidDrives, $RemDrives)
	; _ArrayDisplay($ValidDrives)
	
	_GUICtrlStatusBar_SetText($hStatus," Select Source file and Target Drives", 0)
	$TargetDrive = ""
	$FSvar=""
	$TargetSpaceAvail = 0
	GUICtrlSetData($Target, "")
	GUICtrlSetData($TargetSize, "")
	GUICtrlSetData($TargetFree, "")
	GUICtrlSetState($g4d_bcd, $GUI_UNCHECKED + $GUI_DISABLE)
	GUICtrlSetState($xp_bcd, $GUI_UNCHECKED + $GUI_DISABLE)
	$bm_flag = 0
	
	$TargetSelect = FileSelectFolder("Select your Target Boot Drive - Active Drive for Boot and ISO or WIM Files", "")
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
			MsgBox(48, "WARNING - Invalid FileSystem", "NTFS - FAT32 or FAT FileSystem NOT Found" & @CRLF _
			& @CRLF & "Continue and First Format Target Drive ", 3)
			 DisableMenus(0)
			Return
		EndIf
	EndIf
	If $valid Then
		$IMG_Path = $TargetSelect
	;	$TargetDrive = $Tdrive
		$TargetDrive = StringLeft($IMG_Path, 2)
		
		If StringLen($IMG_Path) < 12 Then
			If StringLen($IMG_Path) = 3 Then
				$IMG_Path = $TargetDrive
			Else
				$pos = StringInStr(StringMid($IMG_Path, 4), "\", 0, -1)
				If $pos <> 0 Then
					$IMG_Path = $TargetDrive
				EndIf
			EndIf
		Else
			$IMG_Path = $TargetDrive
		EndIf
		GUICtrlSetData($Target, $IMG_Path)
		$TargetSpaceAvail = Round(DriveSpaceFree($TargetDrive))
		GUICtrlSetData($TargetSize, $FSvar & "     " & Round(DriveSpaceTotal($TargetDrive) / 1024, 1) & " GB")
		GUICtrlSetData($TargetFree, "FREE  = " & Round(DriveSpaceFree($TargetDrive) / 1024, 1) & " GB")
		If Not FileExists($TargetDrive & "\bootmgr") Or Not FileExists($TargetDrive & "\Boot\BCD") Then
			$bm_flag = 0
			GUICtrlSetState($g4d_bcd, $GUI_UNCHECKED + $GUI_DISABLE)
			GUICtrlSetState($xp_bcd, $GUI_UNCHECKED + $GUI_DISABLE)
		Else
			$bm_flag = 1
			GUICtrlSetState($g4d_bcd, $GUI_ENABLE)
			GUICtrlSetState($xp_bcd, $GUI_ENABLE)
		EndIf

		;	If $FSvar <> "FAT32" Then
		;		MsgBox(48, "WARNING - UEFI needs FAT32 Boot Drive", "FAT32 FileSystem NOT Found" & @CRLF _
		;		& @CRLF & "UEFI Firmware needs FAT32 Boot Drive")
		;	EndIf
	EndIf
	DisableMenus(0)
EndFunc   ;==> _target_drive
;===================================================================================================
Func _WinDrv_drive()
	Local $WinDrvSelect, $Tdrive, $FSvar, $valid = 0, $ValidDrives, $RemDrives
	Local $NoDrive[3] = ["A:", "B:", "X:"], $FileSys[2] = ["NTFS", "FAT32"]
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
	
	_GUICtrlStatusBar_SetText($hStatus," Select Source file and Target Drives", 0)
	$WinDrvDrive = ""
	GUICtrlSetData($WinDrv, "")
	GUICtrlSetData($WinDrvFileSys, "")			
	GUICtrlSetData($WinDrvSize, "")
	GUICtrlSetData($WinDrvFree, "")
	
	$WinDrvSelect = FileSelectFolder("Select your Target System Drive - NTFS for VHD Image files", "")
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
			MsgBox(48, "ERROR - Invalid FileSystem", " NTFS or FAT32 FileSystem NOT Found ", 3)
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
		;	If $FSvar <> "NTFS" Then
		;		MsgBox(48, "WARNING - Target System Drive is NOT NTFS ", "Target System Drive has " & $FSvar & " FileSystem " & @CRLF _
		;		& @CRLF & "OK for USB-Stick booting WIM or ISO " & @CRLF _
		;		& @CRLF & "VHD needs NTFS Target System Drive ")
		;	EndIf
	EndIf
	DisableMenus(0)
EndFunc   ;==> _WinDrv_drive
;===================================================================================================
Func _wim_menu()
	Local $val=0, $store, $len, $pos, $img_fname="", $sdi_file = ""
	Local $guid, $guid_def = "", $pos1, $pos2, $ramdisk_guid = "", $pe_guid = "", $efi_pe_guid = "", $efi_ramdisk_guid = ""
	Local $file, $line
	
	SystemFileRedirect("On")

	If FileExists(@WindowsDir & "\system32\bcdedit.exe") Then
		$bcdedit = @WindowsDir & "\system32\bcdedit.exe"
	; 32-bits makebt\bcdedit.exe can be used in any case
	;	ElseIf FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
	;		$bcdedit = @ScriptDir & "\makebt\bcdedit.exe"
	Else
		SystemFileRedirect("Off")
		MsgBox(48, "WARNING - bcdedit.exe is missing ", "Unable to Add WIM to Boot Manager Menu " & @CRLF & @CRLF _
		& "Need Windows 7 / 8 Or 7/8 PE to Add WIM to Boot Manager " & @CRLF & @CRLF & " Boot with Windows 7 / 8 or 7/8 PE ", 5)
		Return
	EndIf

	$len = StringLen($image_file)
	$pos = StringInStr($image_file, ".", 0, -1)
	; $img_fext = StringRight($image_file, $len-$pos)
	$img_fname = StringLeft($image_file, $pos-1)

	If Not FileExists($IMG_Path & "\" & $image_file) Then
		; SystemFileRedirect("Off")
		MsgBox(48, "ERROR - WIM File Not Found ", $IMG_Path & "\" & $image_file & " File Not Found ", 5)
		; Return
	EndIf

	If $bootsdi = "" Then
		$sdi_file = "boot.sdi"
	Else
		$len = StringLen($bootsdi)
		$pos = StringInStr($bootsdi, "\", 0, -1)
		$sdi_file = StringRight($bootsdi, $len-$pos)
	EndIf

	; save deault bcd setting in $guid_def
	If FileExists($TargetDrive & "\Boot\BCD") Then 
		$store = $TargetDrive & "\Boot\BCD"
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
		& $store & " /enum {default} /v > makebt\bs_temp\bcd_default_out.txt", @ScriptDir, @SW_HIDE)
		$file = FileOpen(@ScriptDir & "\makebt\bs_temp\bcd_default_out.txt", 0)
		$line = FileReadLine($file, 4)
		FileClose($file)
		$pos1 = StringInStr($line, "{")
		$pos2 = StringInStr($line, "}")
		If $pos2-$pos1=37 Then
			$guid_def = StringMid($line, $pos1, $pos2-$pos1+1)
		EndIf
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Add boot.wim to Boot Manager on Boot Drive " & $TargetDrive & " - wait .... ", 0)
	sleep(2000)
	
	$store = $TargetDrive & "\Boot\BCD"
	If Not FileExists($TargetDrive & "\Boot\BCD") Then
		If Not FileExists($TargetDrive & "\Boot") Then DirCreate($TargetDrive & "\Boot")
		If Not FileExists($TargetDrive & "\Boot\Fonts") Then DirCreate($TargetDrive & "\Boot\Fonts")
		sleep(3000)
		If Not FileExists($TargetDrive & "\bootmgr") Then
			If FileExists(@WindowsDir & "\Boot\PCAT\bootmgr") Then
				FileCopy(@WindowsDir & "\Boot\PCAT\bootmgr", $TargetDrive & "\", 1)
			ElseIf FileExists($OS_drive & "\bootmgr") Then
				FileCopy($OS_drive & "\bootmgr", $TargetDrive & "\", 1)
			Else
				; bootmgr is missing
			EndIf
		EndIf
		; win8 boot fonts
		If Not FileExists($TargetDrive & "\Boot\Fonts\segmono_boot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\segmono_boot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\segmono_boot.ttf", $TargetDrive & "\Boot\Fonts", 1)
			EndIf
		EndIf
		If Not FileExists($TargetDrive & "\Boot\Fonts\segoe_slboot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\segoe_slboot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\segoe_slboot.ttf", $TargetDrive & "\Boot\Fonts", 1)
			EndIf
		EndIf
		If Not FileExists($TargetDrive & "\Boot\Fonts\segoen_slboot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\segoen_slboot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\segoen_slboot.ttf", $TargetDrive & "\Boot\Fonts", 1)
			EndIf
		EndIf
		If Not FileExists($TargetDrive & "\Boot\Fonts\wgl4_boot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\wgl4_boot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\wgl4_boot.ttf", $TargetDrive & "\Boot\Fonts", 1)
			EndIf
		EndIf
		RunWait(@ComSpec & " /c " & $bcdedit & " /createstore " & $store, $TargetDrive & "\", @SW_HIDE)
		sleep(3000)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create {bootmgr}", $TargetDrive & "\", @SW_HIDE)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} description " & '"' & "Boot Manager" & '"', $TargetDrive & "\", @SW_HIDE)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} device boot", $TargetDrive & "\", @SW_HIDE)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} timeout 20", $TargetDrive & "\", @SW_HIDE)
		sleep(1000)
	EndIf
	If FileExists($TargetDrive & "\Boot\BCD") Then
		If Not FileExists($TargetDrive & "\Boot\" & $sdi_file) And $bootsdi <> "" Then FileCopy($bootsdi, $TargetDrive & "\Boot\", 1)
		; RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /enum all", $TargetDrive & "\", @SW_HIDE)
		sleep(2000)
		; RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create {ramdiskoptions}", @ScriptDir, @SW_HIDE)
		; $ramdisk_guid = "{ramdiskoptions}"
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create /device > makebt\bs_temp\sdi_guid.txt", @ScriptDir, @SW_HIDE)
		$file = FileOpen(@ScriptDir & "\makebt\bs_temp\sdi_guid.txt", 0)
		$line = FileReadLine($file)
		FileClose($file)
		$pos1 = StringInStr($line, "{")
		$pos2 = StringInStr($line, "}")
		If $pos2-$pos1=37 Then
			$ramdisk_guid = StringMid($line, $pos1, $pos2-$pos1+1)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $ramdisk_guid & " ramdisksdidevice boot", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $ramdisk_guid & " ramdisksdipath \Boot\" & $sdi_file, $TargetDrive & "\", @SW_HIDE)
		EndIf
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create /application osloader > makebt\bs_temp\pe_guid.txt", @ScriptDir, @SW_HIDE)
		$file = FileOpen(@ScriptDir & "\makebt\bs_temp\pe_guid.txt", 0)
		$line = FileReadLine($file)
		FileClose($file)
		$pos1 = StringInStr($line, "{")
		$pos2 = StringInStr($line, "}")
		If $pos2-$pos1=37 And $ramdisk_guid <> "" Then
			$pe_guid = StringMid($line, $pos1, $pos2-$pos1+1)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $pe_guid & " DESCRIPTION " & $img_fname & "-WIM", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $pe_guid & " device ramdisk=[boot]" & StringMid($IMG_Path,3) & "\" & $image_file & "," & $ramdisk_guid, $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $pe_guid & " osdevice ramdisk=[boot]" & StringMid($IMG_Path,3) & "\" & $image_file & "," & $ramdisk_guid, $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $pe_guid & " systemroot \Windows", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $pe_guid & " detecthal on", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $pe_guid & " winpe Yes", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /displayorder " & $pe_guid & " /addlast", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $pe_guid & " testsigning on", $TargetDrive & "\", @SW_HIDE)
			; reset original default always
			sleep(2000)
			If $guid_def <> "" Then
				RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /default " & $guid_def, $TargetDrive & "\", @SW_HIDE)
			EndIf
		EndIf
		If $DriveType="Removable" Or $usbfix Then
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} nointegritychecks on", $TargetDrive & "\", @SW_HIDE)
		EndIf
		; to get PE ProgressBar and Win 8 Boot Manager Menu displayed and waiting for User Selection
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
		& $store & " /bootems {emssettings} ON", $TargetDrive & "\", @SW_HIDE)
	EndIf
	
	; and for efi
	$store = $TargetDrive & "\efi\microsoft\boot\BCD"
	If Not FileExists($TargetDrive & "\efi\microsoft\boot\BCD") Then
		If Not FileExists($TargetDrive & "\efi\boot") Then DirCreate($TargetDrive & "\efi\boot")
		If Not FileExists($TargetDrive & "\efi\microsoft\boot") Then DirCreate($TargetDrive & "\efi\microsoft\boot")
		If Not FileExists($TargetDrive & "\efi\microsoft\boot\fonts") Then DirCreate($TargetDrive & "\efi\microsoft\boot\fonts")
		sleep(3000)
		If Not FileExists($TargetDrive & "\efi\boot\bootx64.efi")  And @OSArch = "X64" Then
			If FileExists(@WindowsDir & "\Boot\EFI\bootmgfw.efi") Then
				FileCopy(@WindowsDir & "\Boot\EFI\bootmgfw.efi", $TargetDrive & "\efi\boot\", 1)
				FileMove($TargetDrive & "\efi\boot\bootmgfw.efi", $TargetDrive & "\efi\boot\bootx64.efi", 1)
			EndIf
		Else
			; efi\Boot\bootx64.efi is missing
		EndIf
		; win8 boot fonts
		If Not FileExists($TargetDrive & "\efi\microsoft\boot\fonts\segmono_boot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\segmono_boot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\segmono_boot.ttf", $TargetDrive & "\efi\microsoft\boot\fonts", 1)
			EndIf
		EndIf
		If Not FileExists($TargetDrive & "\efi\microsoft\boot\fonts\segoe_slboot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\segoe_slboot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\segoe_slboot.ttf", $TargetDrive & "\efi\microsoft\boot\fonts", 1)
			EndIf
		EndIf
		If Not FileExists($TargetDrive & "\efi\microsoft\boot\fonts\segoen_slboot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\segoen_slboot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\segoen_slboot.ttf", $TargetDrive & "\efi\microsoft\boot\fonts", 1)
			EndIf
		EndIf
		If Not FileExists($TargetDrive & "\efi\microsoft\boot\fonts\wgl4_boot.ttf") Then
			If FileExists(@WindowsDir & "\Boot\Fonts\wgl4_boot.ttf") Then
				FileCopy(@WindowsDir & "\Boot\Fonts\wgl4_boot.ttf", $TargetDrive & "\efi\microsoft\boot\fonts", 1)
			EndIf
		EndIf
		RunWait(@ComSpec & " /c " & $bcdedit & " /createstore " & $store, $TargetDrive & "\", @SW_HIDE)
		sleep(3000)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create {bootmgr}", $TargetDrive & "\", @SW_HIDE)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} description " & '"' & "Boot Manager" & '"', $TargetDrive & "\", @SW_HIDE)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} device boot", $TargetDrive & "\", @SW_HIDE)
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} timeout 20", $TargetDrive & "\", @SW_HIDE)
		sleep(1000)
	EndIf
	If FileExists($TargetDrive & "\efi\Microsoft\Boot\BCD") Then
		; RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create {ramdiskoptions}", @ScriptDir, @SW_HIDE)
		; efi_ramdisk_guid = "{ramdiskoptions}"
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create /device > makebt\bs_temp\efi_sdi_guid.txt", @ScriptDir, @SW_HIDE)
		$file = FileOpen(@ScriptDir & "\makebt\bs_temp\efi_sdi_guid.txt", 0)
		$line = FileReadLine($file)
		FileClose($file)
		$pos1 = StringInStr($line, "{")
		$pos2 = StringInStr($line, "}")
		If $pos2-$pos1=37 Then
			$efi_ramdisk_guid = StringMid($line, $pos1, $pos2-$pos1+1)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_ramdisk_guid & " ramdisksdidevice boot", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_ramdisk_guid & " ramdisksdipath \Boot\" & $sdi_file, $TargetDrive & "\", @SW_HIDE)
		EndIf
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /create /application osloader > makebt\bs_temp\efi_pe_guid.txt", @ScriptDir, @SW_HIDE)
		$file = FileOpen(@ScriptDir & "\makebt\bs_temp\efi_pe_guid.txt", 0)
		$line = FileReadLine($file)
		FileClose($file)
		$pos1 = StringInStr($line, "{")
		$pos2 = StringInStr($line, "}")
		If $pos2-$pos1=37 Then
			$efi_pe_guid = StringMid($line, $pos1, $pos2-$pos1+1)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_pe_guid & " DESCRIPTION " & $img_fname & "-WIM", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_pe_guid & " device ramdisk=[boot]" & StringMid($IMG_Path,3) & "\" & $image_file & "," & $efi_ramdisk_guid, $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_pe_guid & " osdevice ramdisk=[boot]" & StringMid($IMG_Path,3) & "\" & $image_file & "," & $efi_ramdisk_guid, $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_pe_guid & " systemroot \Windows", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_pe_guid & " detecthal on", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_pe_guid & " winpe Yes", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /displayorder " & $efi_pe_guid & " /addlast", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set " & $efi_pe_guid & " testsigning on", $TargetDrive & "\", @SW_HIDE)
		EndIf
		If $DriveType="Removable" Or $usbfix Then
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " & $store & " /set {bootmgr} nointegritychecks on", $TargetDrive & "\", @SW_HIDE)
		EndIf
		; to get PE ProgressBar and Win 8 Boot Manager Menu displayed and waiting for User Selection
		RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
		& $store & " /bootems {emssettings} ON", $TargetDrive & "\", @SW_HIDE)
	EndIf
	sleep(2000)
	
	SystemFileRedirect("Off")

EndFunc   ;==> _wim_menu
;===================================================================================================
Func _Go()
	Local $len, $pos, $ikey, $mkimg_err = 0
	
	Local $inst_valid=0, $fhan, $mbrsrc
	
	Local $file, $line, $linesplit[20], $inst_disk="", $inst_part="", $mptarget=0
	Local $notactiv=0, $xpmbr=0, $count, $activebyte = "00"
	

	_GUICtrlStatusBar_SetText($hStatus," Initial Checking Drives - wait  ....", 0)
	GUICtrlSetData($ProgressAll, 5)
	DisableMenus(1)


	If GUICtrlRead($ImageType) = "LiveXP BootSDI - IMG" Or GUICtrlRead($ImageType) = "BartPE - ISO" Or GUICtrlRead($ImageType) = "XP Rec Cons - IMG" Then
		If Not FileExists(@ScriptDir & "\makebt\srsp1\setupldr.bin") Then
			MsgBox(48, "STOP - Missing Server 2003 SP1 Files setupldr.bin", "Files \makebt\srsp1\setupldr.bin NOT Found " _
			& @CRLF & @CRLF & "Copy File Winbuilder\Workbench\Common\BootSDI\setupldr.bin " _
			& @CRLF & @CRLF & "And ramdisk.sys to USB_XP_Setup\makebt\srsp1 folder ")
			GUICtrlSetData($ProgressAll, 0)
			DisableMenus(0)
			_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
			Return
		EndIf
		If Not FileExists($TargetDrive & "\NTDETECT.COM") And Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") And Not FileExists(@ScriptDir & "\makebt\ntdetect.com") Then
			MsgBox(48, "STOP - File NTDETECT.COM Needed ", "Solution - Run BOOT_IMG once in XP OS " & @CRLF & @CRLF _
				& "Or Copy modified ntdetect.com to makebt folder ", 0)
			GUICtrlSetData($ProgressAll, 0)
			DisableMenus(0)
			_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
			Return
		EndIf
	EndIf
	
	If GUICtrlRead($ImageType) = "LiveXP BootSDI - IMG" Or GUICtrlRead($ImageType) = "BartPE - ISO" Then 
		For $i = 1 To 9
			If Not FileExists($TargetDrive & "\RMLD" & $i) Then 
				$pe_nr = $i
				ExitLoop
			EndIf
			If $i = 9 Then
				MsgBox(48, "Error - Return", " Too many RAMBOOT Image Files on Target Drive, Max = 9 " & @CRLF _
				&  " Remove Some RAMBOOT Loader File RMLDx from your Target Drive " &  $TargetDrive)
				GUICtrlSetData($ProgressAll, 0)
				DisableMenus(0)
				_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
				Return
			EndIf
		Next
	EndIf

	If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")
	
	GUICtrlSetData($ProgressAll, 10)
	
	$BTIMGSize = FileGetSize($btimgfile)
	$BTIMGSize = Round($BTIMGSize / 1024 / 1024)
	$len = StringLen($btimgfile)
	$pos = StringInStr($btimgfile, "\", 0, -1)
	$image_file = StringRight($btimgfile, $len-$pos)
	$OldIMGSize = 0
	
	If GUICtrlRead($ImageType) = "VHD - IMG" Then
		If FileExists($WinDrvDrive & "\" & $image_file) And $btimgfile <> $WinDrvDrive & "\" & $image_file Then
			$ikey = MsgBox(256+48+4, "WARNING - Boot Image File Exists on Target Drive", $WinDrvDrive & "\" & $image_file & "  File already Exists" & @CRLF _
			& @CRLF & "Overwrite Existing Boot Image File ? - No = STOP - Return")
			If $ikey = 7 Then
				GUICtrlSetData($IMG_File, "")
				$btimgfile = ""
				GUICtrlSetData($ProgressAll, 0)
				DisableMenus(0)
				GUICtrlSetState($IMG_FileSelect, $GUI_ENABLE + $GUI_FOCUS)
				_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
				Return
			Else
				FileSetAttrib($WinDrvDrive & "\" & $image_file, "-RSH")
				$OldIMGSize = FileGetSize($WinDrvDrive & "\" & $image_file)
				$OldIMGSize = Round($OldIMGSize / 1024 / 1024)
			EndIf			
		EndIf
	Else 
		If FileExists($IMG_Path & "\" & $image_file) And $btimgfile <> $IMG_Path & "\" & $image_file Then
			$ikey = MsgBox(256+48+4, "WARNING - Boot Image File Exists on Target Drive", $IMG_Path & "\" & $image_file & "  File already Exists" & @CRLF _
			& @CRLF & "Overwrite Existing Boot Image File ? - No = STOP - Return")
			If $ikey = 7 Then
				GUICtrlSetData($IMG_File, "")
				$btimgfile = ""
				GUICtrlSetData($ProgressAll, 0)
				DisableMenus(0)
				GUICtrlSetState($IMG_FileSelect, $GUI_ENABLE + $GUI_FOCUS)
				_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
				Return
			Else
				FileSetAttrib($IMG_Path & "\" & $image_file, "-RSH")
				$OldIMGSize = FileGetSize($IMG_Path & "\" & $image_file)
				$OldIMGSize = Round($OldIMGSize / 1024 / 1024)
			EndIf			
		EndIf
	EndIf

	;	If $TargetSpaceAvail + $OldIMGSize < $BTIMGSize * 1.05 Then
	;		MsgBox(48, "ERROR - OverFlow on Target Drive", " Image Size = " & $BTIMGSize & " MB" & @CRLF & " Free Space = " & $TargetSpaceAvail & " MB")
	;		GUICtrlSetData($IMG_File, "")
	;		$btimgfile = ""
	;		$BTIMGSize = 0
	;		$OldIMGSize = 0
	;		DisableMenus(0)
	;		GUICtrlSetState($TargetSel, $GUI_FOCUS)
	;		_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
	;		Return
	;	Endif
	
	If Not CheckSize() Then
		MsgBox(48, "ERROR - OverFlow ", " Boot  Image  File = " & $BTIMGSize & " MB" & @CRLF _ 
		& " Boot   Drive Free = " & $TargetSpaceAvail & " MB" & @CRLF _
		& " System Drive Free = " & $WinDrvSpaceAvail & " MB" & @CRLF)
		GUICtrlSetData($ProgressAll, 0)
		DisableMenus(0)
		GUICtrlSetState($TargetSel, $GUI_FOCUS)
		_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
		Return
	Endif
	
	Sleep(2000)

	; Better use ListUsbDrives.exe because MBRWiz.exe can give wrong $inst_disk nr when USB-drives are disconnected
	
	GUICtrlSetData($ProgressAll, 20)
	_GUICtrlStatusBar_SetText($hStatus," List USB Drives - wait ...", 0)
	
	$DriveType=DriveGetType($TargetDrive)

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
		
	GUICtrlSetData($ProgressAll, 30)
	; MsgBox(0, "TargetDrive - OK", $TargetDrive & "\" & " Drive was found " & @CRLF & "Device Number = " & $inst_disk & @CRLF & "Partition Number = " & $inst_part, 0)

	If $inst_disk = "" Or $inst_part = "" Then
		$inst_valid=0
		MsgBox(48, "WARNING - Target Drive may be NOT Valid", "Device Number NOT Found in makebt\usblist.txt" & @CRLF & @CRLF & _
		"Target Drive = " & $TargetDrive & "   HDD = " & $inst_disk & "   PART = " & $inst_part)
	Else
		; _GUICtrlStatusBar_SetText($hStatus," Checking Install Drive - wait ...", 0)
		If $inst_valid <> 2 Then $inst_valid=1

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

	_GUICtrlStatusBar_SetText($hStatus," Check BootSector Target Boot Drive " & $TargetDrive & " - Please Wait ... ", 0)
	Sleep(2000)

	_Copy_BS()
	If $bs_valid = 0 Then
		GUICtrlSetData($ProgressAll, 0)
		DisableMenus(0)
		_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
		Return
	EndIf
	
	If GUICtrlRead($ImageType) = "LiveXP BootSDI - IMG" Or GUICtrlRead($ImageType) = "BartPE - ISO" Or GUICtrlRead($ImageType) = "XP Rec Cons - IMG" Then
		If $g4d_vista And Not FileExists($TargetDrive & "\BOOTFONT.BIN") And Not FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then
			MsgBox(48, "STOP - XP File BOOTFONT.BIN Needed ", "Solution - Run BOOT_IMG once in XP OS " & @CRLF & @CRLF _
			& " Or add BOOTFONT.BIN manually to makebt\Boot_XP folder ", 0)
			GUICtrlSetData($ProgressAll, 0)
			DisableMenus(0)
			_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
			Return
		EndIf
	EndIf

	GUICtrlSetData($ProgressAll, 40)

	GUICtrlSetData($ProgressAll, 50)
	_GUICtrlStatusBar_SetText($hStatus," Checking Boot Files - Please Wait ... ", 0)

	; Update existing grldr
	If GUICtrlRead($grldrUpd) = $GUI_CHECKED And FileExists($TargetDrive & "\grldr") Then
		FileSetAttrib($TargetDrive & "\grldr", "-RSH")
		FileCopy($TargetDrive & "\grldr", $TargetDrive & "\grldr_old")
		FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
		If FileExists($TargetDrive & "\grldr.mbr") Then FileCopy(@ScriptDir & "\makebt\grldr.mbr", $TargetDrive & "\", 1)
		; If FileExists(@ScriptDir & "\makebt\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
	EndIf
		
	If $g4d Or $g4dmbr <> 0 Then
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		Sleep(2000)
	EndIf
		
	If Not $g4d_vista And Not FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") Then
		If Not FileExists($TargetDrive & "\NTDETECT.COM") And Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM") And Not FileExists(@ScriptDir & "\makebt\ntdetect.com") Then
			MsgBox(48, "WARNING - File NTDETECT.COM Needed ", " Missing File makebt\Boot_XP\NTDETECT.COM " & @CRLF & @CRLF _
			& " Solution - Run BOOT_IMG once in XP OS " & @CRLF & @CRLF _
			& " Or add NTDETECT.COM manually to makebt\Boot_XP folder ", 0)
			GUICtrlSetData($ProgressAll, 0)
			DisableMenus(0)
			_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
			Return
		EndIf
		If Not FileExists($TargetDrive & "\NTLDR") And Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then
			MsgBox(48, "WARNING - File NTLDR Needed ", " Missing File makebt\Boot_XP\NTLDR " & @CRLF & @CRLF _
			& " Solution - Run BOOT_IMG once in XP OS " & @CRLF & @CRLF _
			& " Or add NTLDR manually to makebt\Boot_XP folder ", 0)
			GUICtrlSetData($ProgressAll, 0)
			DisableMenus(0)
			_GUICtrlStatusBar_SetText($hStatus," Please Select Source and Target Drive", 0)
			Return
		EndIf
	EndIf
	
	If $g4d_vista And GUICtrlRead($xp_bcd) = $GUI_CHECKED Then
		If Not FileExists($TargetDrive & "\NTLDR") And Not FileExists(@ScriptDir & "\makebt\Boot_XP\NTLDR") Then
			MsgBox(48, "WARNING - XP Boot Files Needed ", " Missing File makebt\Boot_XP\NTLDR " & @CRLF & @CRLF _
			& " Solution - Run BOOT_IMG once in XP OS Or Manually " & @CRLF & @CRLF _
			& " Add ntldr + NTDETECT.COM and Bootfont.bin to makebt\Boot_XP folder ", 0)
		EndIf
	EndIf
	
	Sleep(2000)
	

	GUICtrlSetData($ProgressAll, 60)

	If GUICtrlRead($ImageType) = "VHD - IMG" Then
		If $btimgfile <> $WinDrvDrive & "\" & $image_file Then
			_GUICtrlStatusBar_SetText($hStatus,"Copying " & $image_file & " to " & $WinDrvDrive & " - wait ....", 0)
			FileCopy($btimgfile, $WinDrvDrive & "\", 1)
		EndIf
	Else
		If $btimgfile <> $IMG_Path & "\" & $image_file Then
			_GUICtrlStatusBar_SetText($hStatus,"Copying " & $image_file & " to " & $IMG_Path & " - wait ....", 0)
			FileCopy($btimgfile, $IMG_Path & "\", 1)
		EndIf
	EndIf

	GUICtrlSetData($ProgressAll, 70)


	If GUICtrlRead($ImageType) = "XP Rec Cons - IMG" Then
		_GUICtrlStatusBar_SetText($hStatus," Making  Entry in Grub4dos Boot Menu - Please wait ....", 0)
		_RC_IMG()
	ElseIf GUICtrlRead($ImageType) = "FreeDOS - IMG" Or GUICtrlRead($ImageType) = "MS-DOS - IMG" Then
		_GUICtrlStatusBar_SetText($hStatus," Making  Entry in Grub4dos Boot Menu - Please wait ....", 0)
		_SF_IMG()
	ElseIf GUICtrlRead($ImageType) = "LiveXP BootSDI - IMG" Or GUICtrlRead($ImageType) = "BartPE - ISO" Then
		_GUICtrlStatusBar_SetText($hStatus," Making  Entry in Grub4dos Boot Menu - Please wait ....", 0)
		_BT_IMG()
	ElseIf GUICtrlRead($ImageType) = "CD - ISO" Or GUICtrlRead($ImageType) = "WinPE - ISO" Then
		_GUICtrlStatusBar_SetText($hStatus," Making  Entry in Grub4dos Boot Menu - Please wait ....", 0)
		_CD_ISO()
	ElseIf GUICtrlRead($ImageType) = "WinPE - WIM" Then
		$mk_bcd = 1
		_wim_menu()
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_bcd_menu()
	Else
		_GUICtrlStatusBar_SetText($hStatus," Making  Entry in Grub4dos Boot Menu - Please wait ....", 0)
		If GUICtrlRead($ImageType) = "VHD - IMG" Then
			$FSvar_WinDrvDrive = DriveGetFileSystem($WinDrvDrive)
			_HDD_IMG()
		EndIf
	EndIf

	Sleep(1000)
	
	GUICtrlSetData($ProgressAll, 80)
	
	If $inst_valid <> 0 And $xpmbr = 0 And $g4dmbr = 0 Then
		_GUICtrlStatusBar_SetText($hStatus," WARNING - MBR BootCode may be Invalid ", 0)
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
		_GUICtrlStatusBar_SetText($hStatus," WARNING - Target Boot Drive is NOT Active ", 0)
		$inst_valid=2
		MsgBox(48, "WARNING - Target Boot Drive is NOT Active", "Booting with Image file needs Activ Target Boot Drive " & @CRLF & @CRLF & _
		"Use Disk Management and R-mouse to Set Target Boot Drive Active " & @CRLF & @CRLF & _
		"Target Drive = " & $TargetDrive & "   HDD = " & $inst_disk & "   PART = " & $inst_part)
		;	SystemFileRedirect("On")
		;	RunWait(@ComSpec & " /c " & @WindowsDir & "\system32\diskmgmt.msc", @ScriptDir, @SW_HIDE)
		;	SystemFileRedirect("Off")
	EndIf

	_GUICtrlStatusBar_SetText($hStatus," Finishing - Wait 2 seconds ....", 0)

	Sleep(2000)
	GUICtrlSetData($ProgressAll, 100)
	
	; efi\boot\bootx64.efi is missing
	If GUICtrlRead($ImageType) = "WinPE - WIM" And Not FileExists($TargetDrive & "\efi\boot\bootx64.efi") Then
		_GUICtrlStatusBar_SetText($hStatus," WARNING - UEFI needs file bootx64.efi ", 0)
		MsgBox(64, " WARNING - UEFI needs file bootx64.efi ", " BIOS boot OK, but UEFI needs file efi\boot\bootx64.efi " & @CRLF & @CRLF _
		& $TargetDrive & "\efi\boot\bootx64.efi is missing on Target Boot Drive " & @CRLF & @CRLF _
		& " Get from Win8 x64 OS file Windows\Boot\EFI\bootmgfw.efi " & @CRLF & @CRLF _
		& " Copy file bootmgfw.efi as bootx64.efi in " & $TargetDrive & "\efi\boot" )
	EndIf
		
	If $mk_bcd = 1  Then
		If Not FileExists($TargetDrive & "\bootmgr") Then
			_GUICtrlStatusBar_SetText($hStatus," End of Program - WARNING", 0)
			MsgBox(64, " END OF PROGRAM - WARNING ", $TargetDrive & "\bootmgr is missing on Target Boot Drive " & @CRLF & @CRLF _
			& " Manually add file bootmgr from Win 7/8 to Drive " & $TargetDrive & @CRLF _
			& @CRLF & " After Reboot Select Boot Image from Menu ")
		Else
			_GUICtrlStatusBar_SetText($hStatus," End of Program - OK", 0)
			MsgBox(64, " END OF PROGRAM - OK ", " After Reboot Select Boot Image from Menu " & @CRLF & @CRLF _
			& "To Remove GRUB4DOS Use EasyBCD Add / Remove Entries Menu ")
		EndIf
	ElseIf $mk_bcd = 2  Then
		If GUICtrlRead($g4d_bcd) = $GUI_CHECKED Or Not FileExists($TargetDrive & "\grldr.mbr") Then
			_GUICtrlStatusBar_SetText($hStatus," End of Program - WARNING", 0)
			MsgBox(64, " END OF PROGRAM - WARNING ", @CRLF _
			& " Unable to make GRUB4DOS entry in Boot Manager BCD Menu " & @CRLF & @CRLF _
			& " Manually use bcdedit to Install GRUB4DOS in Boot Manager BCD Menu ")
		Else
			_GUICtrlStatusBar_SetText($hStatus," End of Program - OK", 0)
			MsgBox(64, " END OF PROGRAM - OK ", " After Reboot Select GRUB4DOS and Boot Image from Menu ")
		EndIf
	Else
		_GUICtrlStatusBar_SetText($hStatus," End of Program - OK", 0)
		MsgBox(64, " END OF PROGRAM - OK ", " End of Program  - OK " & @CRLF _
		& @CRLF & " After Reboot Select GRUB4DOS and Boot Image from Menu ")
	EndIf
	Exit

EndFunc ;==> _Go
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
Func _BT_IMG()
	Local $len, $pos, $hd_cd
	Local $path_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$path_image_file = StringMid($IMG_Path, 4) & "\" &  $image_file
	Else
		$path_image_file = $image_file
	EndIf

	$len = StringLen($image_file)
	$pos = StringInStr($image_file, ".", 0, -1)
	$img_fext = StringRight($image_file, $len-$pos)

	$hd_cd = "/rdexportashd"
	If $img_fext = "iso" Then $hd_cd = "/rdexportascd"
	If $img_fext = "is_" Then $hd_cd = "/rdexportascd"


	If FileExists($TargetDrive & "\RMLD" & $pe_nr) Then	FileSetAttrib($TargetDrive & "\RMLD" & $pe_nr, "-RSH")
	If FileExists($TargetDrive & "\ramx" & $pe_nr & ".sif") Then FileSetAttrib($TargetDrive & "\ramx" & $pe_nr & ".sif", "-RSH")
	FileCopy(@ScriptDir & "\makebt\srsp1\setupldr.bin", $TargetDrive & "\RMLD" & $pe_nr, 1) 
	FileSetAttrib($TargetDrive & "\RMLD" & $pe_nr, "-RSH")
	HexReplace($TargetDrive & "\RMLD" & $pe_nr, "46DA7403", "46DAEB1A", 0, 16, 1)
	HexReplace($TargetDrive & "\RMLD" & $pe_nr, "winnt.sif", "ramx" & $pe_nr & ".sif", 0, 16, 0)
	IniWriteSection($TargetDrive & "\ramx" & $pe_nr & ".sif", "SetupData", 'BootDevice="ramdisk(0)"' _
	& @LF & 'BootPath="\i386\System32\"' & @LF & "OsLoadOptions=" _
	& '"' & "/noguiboot /fastdetect /minint " & $hd_cd & " /rdpath=" & $path_image_file & '"')

	If Not FileExists($TargetDrive & "\BOOTFONT.BIN") Then
		If FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then FileCopy(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", $TargetDrive & "\", 1)
	EndIf

;	use modified ntdetect if exists in makebt folder
	If Not FileExists($TargetDrive & "\NTDETECT.COM") Then 
		IF FileExists(@ScriptDir & "\makebt\ntdetect.com") Then
			FileCopy(@ScriptDir & "\makebt\ntdetect.com", $TargetDrive & "\", 1)
		Else
			FileCopy(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", $TargetDrive & "\", 1)
		EndIf
	EndIf
		
	; GUICtrlSetData($ProgressAll, 80)

	If GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
		If $g4d Or $g4dmbr <> 0 Then
			_g4d_bt_img_menu()
			Return
		EndIf
	EndIf
	If FileExists($TargetDrive & "\grldr") And FileExists($TargetDrive & "\menu.lst") Then
		If $g4d_vista = 0 And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_bt_img_menu()
			Return
		EndIf
		If $g4d_vista And FileExists($TargetDrive & "\grldr.mbr") And FileExists($TargetDrive & "\bootmgr") And FileExists($TargetDrive & "\Boot\BCD") And GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_bt_img_menu()
			Return
		EndIf
	EndIf

	If $g4d_vista = 0 Then
		If FileExists($TargetDrive & "\boot.ini") Then
			FileSetAttrib($TargetDrive & "\boot.ini", "-RSH")
			FileCopy($TargetDrive & "\boot.ini", $TargetDrive & "\boot_ini.txt", 1)
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
			IniWrite($TargetDrive & "\boot.ini", "Boot Loader", "Timeout", 20)
		Else
			IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
			"Default=C:\grldr")
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
		EndIf

		If Not FileExists($TargetDrive & "\ntldr") Then
			FileCopy(@ScriptDir & "\makebt\Boot_XP\NTLDR", $TargetDrive & "\", 1)
		EndIf				
			
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_g4d_bt_img_menu()
	Else
		$mk_bcd = 1
		If Not FileExists($TargetDrive & "\BOOTFONT.BIN") Or Not FileExists($TargetDrive & "\NTDETECT.COM") Then 
			MsgBox(48, "WARNING - Missing File on Target Drive", " BOOTFONT.BIN Or NTDETECT.COM Not Found " & @CRLF & @CRLF _
			& " Solution: Manually Add NTDETECT.COM to Target Drive ", 0)
		EndIf
		;	If FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then 
		;		$mk_bcd = 2
		;		MsgBox(48, "WARNING - SUSPECT CONFIG ERROR ", " grldr found without menu.lst " & @CRLF & @CRLF _
		;		& " Unable to Add Grub4dos to BootManager Menu" & @CRLF & @CRLF _
		;		& " Checkbox can Enable to Update Grub4dos grldr Version ", 0)
		;		Return
		;	EndIf
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_g4d_bt_img_menu()
		_bcd_menu()
	EndIf
EndFunc   ;==> _BT_IMG
;===================================================================================================
Func _RC_IMG()
	Local $len, $pos, $hd_cd
	Local $path_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$path_image_file = StringMid($IMG_Path, 4) & "\" &  $image_file
	Else
		$path_image_file = $image_file
	EndIf

	$len = StringLen($image_file)
	$pos = StringInStr($image_file, ".", 0, -1)
	$img_fext = StringRight($image_file, $len-$pos)
	$hd_cd = "/rdexportashd"
;	If $img_fext = "iso" Then $hd_cd = "/rdexportascd"
;	If $img_fext = "is_" Then $hd_cd = "/rdexportascd"


	If FileExists($TargetDrive & "\RCLDR") Then	FileSetAttrib($TargetDrive & "\RCLDR", "-RSH")
	If FileExists($TargetDrive & "\rcons.sif") Then FileSetAttrib($TargetDrive & "\rcons.sif", "-RSH")
	FileCopy(@ScriptDir & "\makebt\srsp1\setupldr.bin", $TargetDrive & "\RCLDR", 1) 
	FileSetAttrib($TargetDrive & "\RCLDR", "-RSH")
	HexReplace($TargetDrive & "\RCLDR", "46DA7403", "46DAEB1A", 0, 16, 1)
	HexReplace($TargetDrive & "\RCLDR", "winnt.sif", "rcons.sif", 0, 16, 0)
	IniWriteSection($TargetDrive & "\rcons.sif", "SetupData", 'BootDevice="ramdisk(0)"' _
	& @LF & 'BootPath="\i386\"' & @LF & "OsLoadOptions=" _
	& '"' & "/noguiboot /fastdetect " & $hd_cd & " /rdpath=" & $path_image_file & '"' _
	& @LF & 'SetupSourceDevice = \device\harddisk0\partition1')

	If Not FileExists($TargetDrive & "\BOOTFONT.BIN") Then
		If FileExists(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN") Then FileCopy(@ScriptDir & "\makebt\Boot_XP\BOOTFONT.BIN", $TargetDrive & "\", 1)
	EndIf

;	use modified ntdetect if exists in makebt folder
	If Not FileExists($TargetDrive & "\NTDETECT.COM") Then 
		IF FileExists(@ScriptDir & "\makebt\ntdetect.com") Then
			FileCopy(@ScriptDir & "\makebt\ntdetect.com", $TargetDrive & "\", 1)
		Else
			FileCopy(@ScriptDir & "\makebt\Boot_XP\NTDETECT.COM", $TargetDrive & "\", 1)
		EndIf
	EndIf
	
	If FileExists(@ScriptDir & "\makebt\CATCH22") Then DirCopy(@ScriptDir & "\makebt\CATCH22", $TargetDrive & "\CATCH22", 1)
		
	; GUICtrlSetData($ProgressAll, 80)

	If GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
		If $g4d Or $g4dmbr <> 0 Then
			_g4d_rc_img_menu()
			Return
		EndIf
	EndIf
	If FileExists($TargetDrive & "\grldr") And FileExists($TargetDrive & "\menu.lst") Then
		If $g4d_vista = 0 And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_rc_img_menu()
			Return
		EndIf
		If $g4d_vista And FileExists($TargetDrive & "\grldr.mbr") And FileExists($TargetDrive & "\bootmgr") And FileExists($TargetDrive & "\Boot\BCD") And GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_rc_img_menu()
			Return
		EndIf
	EndIf

	If $g4d_vista = 0 Then
		If FileExists($TargetDrive & "\boot.ini") Then
			FileSetAttrib($TargetDrive & "\boot.ini", "-RSH")
			FileCopy($TargetDrive & "\boot.ini", $TargetDrive & "\boot_ini.txt", 1)
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
			IniWrite($TargetDrive & "\boot.ini", "Boot Loader", "Timeout", 20)
		Else
			IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
			"Default=C:\grldr")
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
		EndIf
		
		If Not FileExists($TargetDrive & "\ntldr") Then
			FileCopy(@ScriptDir & "\makebt\Boot_XP\NTLDR", $TargetDrive & "\", 1)
		EndIf				
			
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_g4d_rc_img_menu()
	Else
		$mk_bcd = 1
		If Not FileExists($TargetDrive & "\BOOTFONT.BIN") Or Not FileExists($TargetDrive & "\NTDETECT.COM") Then 
			MsgBox(48, "WARNING - Missing File on Target Drive", " BOOTFONT.BIN Or NTDETECT.COM Not Found " & @CRLF & @CRLF _
			& " Solution: Manually Add NTDETECT.COM to Target Drive ", 0)
		EndIf
		;	If FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then 
		;		$mk_bcd = 2
		;		MsgBox(48, "WARNING - SUSPECT CONFIG ERROR ", " grldr found without menu.lst " & @CRLF & @CRLF _
		;		& " Unable to Add Grub4dos to BootManager Menu" & @CRLF & @CRLF _
		;		& " Checkbox can Enable to Update Grub4dos grldr Version ", 0)
		;		Return
		;	EndIf
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_g4d_rc_img_menu()
		_bcd_menu()
	EndIf
EndFunc   ;==> _RC_IMG
;===================================================================================================
Func _SF_IMG()

	If GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
		If $g4d Or $g4dmbr <> 0 Then
			_g4d_sf_img_menu()
			Return
		EndIf
	EndIf

	If FileExists($TargetDrive & "\grldr") And FileExists($TargetDrive & "\menu.lst") Then
		If $g4d_vista = 0 And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_sf_img_menu()
			Return
		EndIf
		If $g4d_vista And FileExists($TargetDrive & "\grldr.mbr") And FileExists($TargetDrive & "\bootmgr") And FileExists($TargetDrive & "\Boot\BCD") And GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_sf_img_menu()
			Return
		EndIf
	EndIf
			
	; GUICtrlSetData($ProgressAll, 80)
		
	If $g4d_vista = 0 Then
		If FileExists($TargetDrive & "\boot.ini") Then
			FileSetAttrib($TargetDrive & "\boot.ini", "-RSH")
			FileCopy($TargetDrive & "\boot.ini", $TargetDrive & "\boot_ini.txt", 1)
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
			IniWrite($TargetDrive & "\boot.ini", "Boot Loader", "Timeout", 20)
		Else
			IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
			"Default=C:\grldr")
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
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
		_g4d_sf_img_menu()
	Else
		$mk_bcd = 1
		;	If FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then 
		;		$mk_bcd = 2
		;		MsgBox(48, "WARNING - SUSPECT CONFIG ERROR ", " grldr found without menu.lst " & @CRLF & @CRLF _
		;		& " Unable to Add Grub4dos to BootManager Menu" & @CRLF & @CRLF _
		;		& " Checkbox can Enable to Update Grub4dos grldr Version ", 0)
		;		Return
		;	EndIf
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_g4d_sf_img_menu()
		_bcd_menu()
	EndIf
EndFunc   ;==> _SF_IMG
;===================================================================================================
Func _CD_ISO()

	$DriveType=DriveGetType($TargetDrive)

	If GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
		If $g4d Or $g4dmbr <> 0 Then
			_g4d_cd_iso_menu()
			Return
		EndIf
	EndIf

	If FileExists($TargetDrive & "\grldr") And FileExists($TargetDrive & "\menu.lst") Then
		If $g4d_vista = 0 And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_cd_iso_menu()
			Return
		EndIf
		If $g4d_vista And FileExists($TargetDrive & "\grldr.mbr") And FileExists($TargetDrive & "\bootmgr") And FileExists($TargetDrive & "\Boot\BCD") And GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_cd_iso_menu()
			Return
		EndIf
	EndIf

	; GUICtrlSetData($ProgressAll, 80)
		
	If $g4d_vista = 0 Then
		If FileExists($TargetDrive & "\boot.ini") Then
			FileSetAttrib($TargetDrive & "\boot.ini", "-RSH")
			FileCopy($TargetDrive & "\boot.ini", $TargetDrive & "\boot_ini.txt", 1)
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
			IniWrite($TargetDrive & "\boot.ini", "Boot Loader", "Timeout", 20)
		Else
			IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
			"Default=C:\grldr")
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
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
		_g4d_cd_iso_menu()
	Else
		$mk_bcd = 1
		;	If FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then 
		;		$mk_bcd = 2
		;		MsgBox(48, "WARNING - SUSPECT CONFIG ERROR ", " grldr found without menu.lst " & @CRLF & @CRLF _
		;		& " Unable to Add Grub4dos to BootManager Menu" & @CRLF & @CRLF _
		;		& " Checkbox can Enable to Update Grub4dos grldr Version ", 0)
		;		Return
		;	EndIf
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_g4d_cd_iso_menu()
		_bcd_menu()
	EndIf
EndFunc   ;==> _CD_ISO
;===================================================================================================
Func _HDD_IMG()

	If GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
		If $g4d Or $g4dmbr <> 0 Then
			_g4d_hdd_img_menu()
			Return
		EndIf
	EndIf

	If FileExists($TargetDrive & "\grldr") And FileExists($TargetDrive & "\menu.lst") Then
		If $g4d_vista = 0 And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_hdd_img_menu()
			Return
		EndIf
		If $g4d_vista And FileExists($TargetDrive & "\grldr.mbr") And FileExists($TargetDrive & "\bootmgr") And FileExists($TargetDrive & "\Boot\BCD") And GUICtrlRead($g4d_bcd) = $GUI_UNCHECKED And GUICtrlRead($xp_bcd) = $GUI_UNCHECKED And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then
			FileSetAttrib($TargetDrive & "\menu.lst", "-RSH")
			_g4d_hdd_img_menu()
			Return
		EndIf
	EndIf
	
	; GUICtrlSetData($ProgressAll, 80)
		
	If $g4d_vista = 0 Then
		If FileExists($TargetDrive & "\boot.ini") Then
			FileSetAttrib($TargetDrive & "\boot.ini", "-RSH")
			FileCopy($TargetDrive & "\boot.ini", $TargetDrive & "\boot_ini.txt", 1)
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
			IniWrite($TargetDrive & "\boot.ini", "Boot Loader", "Timeout", 20)
		Else
			IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
			"Default=C:\grldr")
			IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "C:\grldr", '"Start GRUB4DOS - XP Menu"')
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
		If Not FileExists($TargetDrive & "\menu.lst") Then
			FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
			If FileExists($TargetDrive & "\bootmgr")  And FileExists($TargetDrive & "\Boot\BCD") Then
				$bcd_flag = 1
			EndIf
		EndIf
		_g4d_hdd_img_menu()
		If $bcd_flag = 1 Then
			FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title Boot Manager Menu - Win VHD")
			FileWriteLine($TargetDrive & "\menu.lst", "chainloader /bootmgr")
		EndIf
	Else
		$mk_bcd = 1
		;	If FileExists($TargetDrive & "\grldr") And Not FileExists($TargetDrive & "\menu.lst") And GUICtrlRead($grldrUpd) = $GUI_UNCHECKED Then 
		;		$mk_bcd = 2
		;		MsgBox(48, "WARNING - SUSPECT CONFIG ERROR ", " grldr found without menu.lst " & @CRLF & @CRLF _
		;		& " Unable to Add Grub4dos to BootManager Menu" & @CRLF & @CRLF _
		;		& " Checkbox can Enable to Update Grub4dos grldr Version ", 0)
		;		Return
		;	EndIf
		If Not FileExists($TargetDrive & "\grldr") Then
			FileCopy(@ScriptDir & "\makebt\grldr", $TargetDrive & "\", 1)
			; If FileExists(@ScriptDir & "\makebt\RUN") And Not FileExists($TargetDrive & "\RUN") Then FileCopy(@ScriptDir & "\makebt\RUN", $TargetDrive & "\", 1)
		EndIf			
		If Not FileExists($TargetDrive & "\menu.lst") Then FileCopy(@ScriptDir & "\makebt\menu.lst", $TargetDrive & "\", 1)
		_g4d_hdd_img_menu()
		_bcd_menu()
	EndIf
EndFunc   ;==> _HDD_IMG
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
	
	GUICtrlSetState($IMG_FileSelect, $endis)
	GUICtrlSetState($IMG_File, $endis)
	
	If $btimgfile <> "" And GUICtrlRead($ImageType) = "VHD - IMG" Then
		GUICtrlSetState($WinDrvSel, $endis)
		GUICtrlSetState($WinDrv, $endis)
	Else
		GUICtrlSetState($WinDrvSel, $GUI_DISABLE)
		GUICtrlSetState($WinDrv, $GUI_DISABLE)
	EndIf
	
	GUICtrlSetState($grldrUpd, $endis)
	
	If $bm_flag Then
		GUICtrlSetState($g4d_bcd, $endis)
		GUICtrlSetState($xp_bcd, $endis)
	Else
		GUICtrlSetState($g4d_bcd, $GUI_UNCHECKED + $GUI_DISABLE)
		GUICtrlSetState($xp_bcd, $GUI_UNCHECKED + $GUI_DISABLE)
	EndIf

	If GUICtrlRead($ImageType) = "VHD - IMG" Then
		GUICtrlSetState($Menu_Type, $endis)
	Else
		GUICtrlSetState($Menu_Type, $GUI_DISABLE)
	EndIf
	
	GUICtrlSetState($TargetSel, $endis)
	GUICtrlSetState($Target, $endis)
	
	GUICtrlSetState($GO, $GUI_DISABLE)
	
	GUICtrlSetData($IMG_File, $btimgfile)
	GUICtrlSetData($Target, $IMG_Path)
	GUICtrlSetData($WinDrv, $WinDrvDrive)

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
Func _g4d_bt_img_menu()
	Local $entry_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	Else
		$entry_image_file = $image_file
	EndIf

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title PE " & $pe_nr & " - " & $entry_image_file & " - RAMDISK - " & $BTIMGSize & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /RMLD" & $pe_nr)
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /RMLD" & $pe_nr)
EndFunc   ;==> _g4d_bt_img_menu
;===================================================================================================
Func _g4d_rc_img_menu()
	Local $entry_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	Else
		$entry_image_file = $image_file
	EndIf

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title XP Recovery Console - " & $entry_image_file & " - RAMDISK - " & $BTIMGSize & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /RCLDR")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader /RCLDR")
	FileWriteLine($TargetDrive & "\menu.lst", "#####################################################################")
	FileWriteLine($TargetDrive & "\menu.lst", "# write string cmdcons to memory 0000:7C03 in 2 steps:")
	FileWriteLine($TargetDrive & "\menu.lst", "#####################################################################")
	FileWriteLine($TargetDrive & "\menu.lst", "# step 1. Write 4 chars cmdc at 0000:7C03")
	FileWriteLine($TargetDrive & "\menu.lst", "write 0x7C03 0x63646D63")
	FileWriteLine($TargetDrive & "\menu.lst", "# step 2. Write 3 chars ons and an ending null at 0000:7C07")
	FileWriteLine($TargetDrive & "\menu.lst", "write 0x7C07 0x00736E6F")
EndFunc   ;==> _g4d_rc_img_menu
;===================================================================================================
Func _g4d_sf_img_menu()
	Local $entry_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	Else
		$entry_image_file = $image_file
	EndIf

	FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title SuperFLoppy Image - " & $entry_image_file & " - " & $BTIMGSize & " MB")
	FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
	FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_image_file & " (fd0)")
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "chainloader (fd0)+1")
	FileWriteLine($TargetDrive & "\menu.lst", "rootnoverify (fd0)")
EndFunc   ;==> _g4d_sf_img_menu
;===================================================================================================
Func _g4d_cd_iso_menu()
	Local $entry_image_file=""

	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	Else
		$entry_image_file = $image_file
	EndIf

	If $DriveType="Removable" Or GUICtrlRead($ImageType) = "WinPE - ISO" Then 
		FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - ISO - " & $BTIMGSize & " MB")
		FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
		FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (0xff)")
	Else
		FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - ISO or ISO from RAM - " & $BTIMGSize & " MB")
		FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
		FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (0xff) || map --mem /" & $entry_image_file & " (0xff)")
	EndIf
	FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
	FileWriteLine($TargetDrive & "\menu.lst", "root (0xff)")
	If GUICtrlRead($ImageType) = "WinPE - ISO" Then 
		FileWriteLine($TargetDrive & "\menu.lst", "chainloader (0xff)/BOOTMGR || chainloader (0xff)/bootmgr")
	Else
		FileWriteLine($TargetDrive & "\menu.lst", "chainloader (0xff)")
	EndIf
EndFunc   ;==> _g4d_cd_iso_menu
;===================================================================================================
Func _g4d_hdd_img_menu()
	Local $entry_image_file=""

	;	If StringLen($IMG_Path) > 3 And StringLen($IMG_Path) < 12 Then
	;		$entry_image_file = StringMid($IMG_Path, 4) & "/" &  $image_file
	;	Else
		$entry_image_file = $image_file
	;	EndIf

	; $entry_image_file= $image_file
	
	If GUICtrlRead($Menu_Type) = "XP - WinVBlock" Or GUICtrlRead($Menu_Type) = "W7 - WinVBlock" Then

		If $FSvar_WinDrvDrive="NTFS" Or GUICtrlRead($Menu_Type) = "XP - WinVBlock" Then
			FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - WinVBlock FILEDISK - " & $BTIMGSize & " MB")
			FileWriteLine($TargetDrive & "\menu.lst", "# Sector-mapped disk")
			FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
			FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
			FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
			FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
			If GUICtrlRead($Menu_Type) = "XP - WinVBlock" Then
				FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")
			Else
				FileWriteLine($TargetDrive & "\menu.lst", "chainloader /bootmgr")
			EndIf
		EndIf
		
		FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - WinVBlock RAMDISK  - " & $BTIMGSize & " MB")
		FileWriteLine($TargetDrive & "\menu.lst", "# Sector-mapped disk")
		FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
		FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_image_file & " (hd0)")
		FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
		FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
		If GUICtrlRead($Menu_Type) = "XP - WinVBlock" Then
			FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")
		Else
			FileWriteLine($TargetDrive & "\menu.lst", "chainloader /bootmgr")
		EndIf

	Else 
		
		If $FSvar_WinDrvDrive="NTFS" Or GUICtrlRead($Menu_Type) = "XP - FiraDisk" Then
			FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - FiraDisk  FILEDISK - " & $BTIMGSize & " MB")
			FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
			FileWriteLine($TargetDrive & "\menu.lst", "map --heads=2 --sectors-per-track=18 --mem (md)0x800+4 (99)")
			FileWriteLine($TargetDrive & "\menu.lst", "map /" & $entry_image_file & " (hd0)")
			FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
			FileWriteLine($TargetDrive & "\menu.lst", "write (99) [FiraDisk]\nStartOptions=disk,vmem=find:/" & $entry_image_file & ",boot;\n\0")
			FileWriteLine($TargetDrive & "\menu.lst", "rootnoverify (hd0,0)")
			If GUICtrlRead($Menu_Type) = "XP - FiraDisk" Then
				FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")
			Else
				FileWriteLine($TargetDrive & "\menu.lst", "chainloader /bootmgr")
			EndIf
			FileWriteLine($TargetDrive & "\menu.lst", "map --status")
			FileWriteLine($TargetDrive & "\menu.lst", "pause Press any key . . .")
		EndIf
	
		FileWriteLine($TargetDrive & "\menu.lst",@CRLF & "title " & $entry_image_file & " - FiraDisk  RAMDISK  - " & $BTIMGSize & " MB")
		FileWriteLine($TargetDrive & "\menu.lst", "find --set-root --ignore-floppies /" & $entry_image_file)
		FileWriteLine($TargetDrive & "\menu.lst", "map --mem /" & $entry_image_file & " (hd0)")
		FileWriteLine($TargetDrive & "\menu.lst", "map --hook")
		FileWriteLine($TargetDrive & "\menu.lst", "root (hd0,0)")
		If GUICtrlRead($Menu_Type) = "XP - FiraDisk" Then
			FileWriteLine($TargetDrive & "\menu.lst", "chainloader /ntldr")
		Else
			FileWriteLine($TargetDrive & "\menu.lst", "chainloader /bootmgr")
		EndIf
		
	EndIf 
EndFunc   ;==> _g4d_hdd_img_menu
;===================================================================================================
Func _bcd_menu()
	Local $file, $line, $store, $guid, $pos1, $pos2

	; If Not FileExists($TargetDrive & "\bootmgr") Then $mk_bcd = 2
	If Not FileExists($TargetDrive & "\Boot\BCD") Then $mk_bcd = 2
	
	SystemFileRedirect("On")
	
	If FileExists(@WindowsDir & "\system32\bcdedit.exe") Then
		$bcdedit = @WindowsDir & "\system32\bcdedit.exe"
	; Removed - In x86 OS with Target x64 W7 gives bcdedit is not valid 32-bits 
	;	ElseIf FileExists($TargetDrive & "\Windows\System32\bcdedit.exe") Then
	;		$bcdedit = $TargetDrive & "\Windows\System32\bcdedit.exe"
		;	If Not FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
		;		FileCopy($TargetDrive & "\Windows\System32\bcdedit.exe", @ScriptDir & "\makebt\", 1)
		;	EndIf
	; 32-bits makebt\bcdedit.exe can be used in any case
	;	ElseIf FileExists(@ScriptDir & "\makebt\bcdedit.exe") Then
	;		$bcdedit = @ScriptDir & "\makebt\bcdedit.exe"
	Else
		$mk_bcd = 2
	EndIf
	If $mk_bcd = 1 And $bcdedit <> "" Then
		$store = $TargetDrive & "\Boot\BCD"
		
		If GUICtrlRead($g4d_bcd) = $GUI_CHECKED Or Not FileExists($TargetDrive & "\grldr.mbr") Then
			_GUICtrlStatusBar_SetText($hStatus," Making  Grub4dos Entry in Boot Manager Menu - wait ....", 0)
			If Not FileExists($TargetDrive & "\grldr.mbr") Or GUICtrlRead($grldrUpd) = $GUI_CHECKED Then FileCopy(@ScriptDir & "\makebt\grldr.mbr", $TargetDrive & "\", 1)
			
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
					RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
					& $store & " /default " & $guid, $TargetDrive & "\", @SW_HIDE)
				EndIf
				;		MsgBox(0, "BOOTMGR - GRUB4DOS ENTRY in BCD OK ", "GRUB4DOS Boot Entry was made in Store " & $TargetDrive & "\Boot\BCD " & @CRLF & @CRLF _
				;		& "Grub4Dos GUID in BCD Store = " & $guid, 3)
				;	Else
				;		MsgBox(48, "ERROR - GRUB4DOS GUID NOT Valid", "GRUB4DOS GUID NOT Found in Boot Manager Menu", 3)
			EndIf
		EndIf
		
		If GUICtrlRead($xp_bcd) = $GUI_CHECKED Then
			_GUICtrlStatusBar_SetText($hStatus," Making  XP Entry in Boot Manager Menu - wait ....", 0)
			If Not FileExists($TargetDrive & "\boot.ini") Then
				IniWriteSection($TargetDrive & "\boot.ini", "Boot Loader", "Timeout=20" & @LF & _
				"Default=multi(0)disk(0)rdisk(0)partition(2)" & $WinFol)
				IniWriteSection($TargetDrive & "\boot.ini", "Operating Systems", _
				"multi(0)disk(0)rdisk(0)partition(1)" & $WinFol & "=" & '"Start Windows XP HD-0 Partition 1"' & " /noexecute=optin /fastdetect")
				IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "multi(0)disk(0)rdisk(0)partition(2)" & $WinFol, _ 
				'"Start Windows XP HD-0 Partition 2"' & " /noexecute=optin /fastdetect")
				IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "multi(0)disk(0)rdisk(1)partition(1)" & $WinFol, _ 
				'"Start Windows XP HD-1 Partition 1"' & " /noexecute=optin /fastdetect")
				IniWrite($TargetDrive & "\boot.ini", "Operating Systems", "multi(0)disk(0)rdisk(1)partition(2)" & $WinFol, _ 
				'"Start Windows XP HD-1 Partition 2"' & " /noexecute=optin /fastdetect")
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
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /create {ntldr} /d " & '"' & "Start Windows XP" & '"', $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set {ntldr} device boot", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /set {ntldr} path \ntldr", $TargetDrive & "\", @SW_HIDE)
			RunWait(@ComSpec & " /c " & $bcdedit & " /store " _
			& $store & " /displayorder {ntldr} /addlast", $TargetDrive & "\", @SW_HIDE)
			; MsgBox(0, "BOOTMGR - XP NTLDR  ENTRY in BCD OK ", "XP NTLDR  Boot Entry was made in Store " & $TargetDrive & "\Boot\BCD ", 3)
		EndIf
	Else
		If GUICtrlRead($g4d_bcd) = $GUI_CHECKED Or GUICtrlRead($xp_bcd) = $GUI_CHECKED Then 
			MsgBox(48, "CONFIG ERROR Or Missing File", "Unable to Add to Boot Manager Menu" & @CRLF & @CRLF _
				& " Missing bcdedit.exe Or Boot\BCD file ", 5)
		EndIf
	EndIf
	
	SystemFileRedirect("Off")
	
EndFunc   ;==> _bcd_menu
;===================================================================================================
Func CheckSize()
	_GUICtrlStatusBar_SetText($hStatus," Measuring Source and Target Size - Wait... ", 0)

	If $TargetDrive <> "" Then
		$TargetSpaceAvail = Round(DriveSpaceFree($TargetDrive))
	Else
		$TargetSpaceAvail = 0
	EndIf
	If $WinDrvDrive <> "" Then
		$WinDrvSpaceAvail = Round(DriveSpaceFree($WinDrvDrive))
	Else
		$WinDrvSpaceAvail = 0
	EndIf
	
	If $btimgfile <> "" Then
		$BTIMGSize = FileGetSize($btimgfile)
		$BTIMGSize = Round($BTIMGSize / 1024 / 1024)
	Else
		$BTIMGSize = 0
	EndIf

	If GUICtrlRead($ImageType) = "VHD - IMG" Then
		If $btimgfile <> $WinDrvDrive & "\" & $image_file Then
			If $WinDrvSpaceAvail + $OldIMGSize < $BTIMGSize * 1.05 Then Return 0
		EndIf
	Else
		If $btimgfile <> $IMG_Path & "\" & $image_file Then
			If $TargetSpaceAvail + $OldIMGSize < $BTIMGSize * 1.05 Then Return 0
		EndIf
	EndIf

	Return 1
EndFunc ;==>_CheckSize()
;===================================================================================================

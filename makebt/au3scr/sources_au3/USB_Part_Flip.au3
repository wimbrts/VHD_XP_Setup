#RequireAdmin
#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.8.1
 Author:        WIMB  -  November 08, 2013

 Program:       USB_Part_Flip.exe - part of IMG_XP Package - Version 8.0 in rule 72
 
 Script Function:
	When applied to USB-stick with two primary partitions, it allows to change which primary partition of the USB-stick is visible in Windows
	The first primary partition entry in the MBR partition table is the USB-stick partition that will be visible in Windows
	Optionally the program can be used on USB-harddisks to make similar change in the partition table e.g. reverse the sequence of 1st and 2nd entry in the partition table
	
 Credits:
	Thanks to webwolf for starting the subject and to jaclaz for his continuous help 

	The program is released "as is" and is free for redistribution, use or changes as long as original author, 
	credits part and link to the 911cd.net support forum are clearly mentioned:

	Install from USB AFTER Booting with PE
	http://www.911cd.net/forums//index.php?showtopic=21883
	http://www.911cd.net/forums//index.php?showforum=37
	webwolf - http://www.911cd.net/forums//index.php?showtopic=24392

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
Global $hStatus, $TargetSpaceAvail=0, $TargetSize, $TargetFree, $FSvar="", $TargetFileSys
Global $hGuiParent, $GO, $EXIT, $TargetSel, $Target, $usb_fixed
Global $DriveType="Removable", $usbfix=0

Global $OS_drive = StringLeft(@WindowsDir, 2)

Global $str = "", $bt_files[3] = ["\makebt\dsfo.exe", "\makebt\dsfi.exe", "\makebt\listusbdrives\ListUsbDrives.exe"]

For $str In $bt_files
	If Not FileExists(@ScriptDir & $str) Then
		MsgBox(48, "ERROR - Missing File", "File " & $str & " NOT Found ")
		Exit
	EndIf
Next

If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")
	
; Creating GUI and controls
$hGuiParent = GUICreate(" USB_Part_Flip - Partition Flip for USB-stick ", 400, 430, 100, _
		40, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")

GUICtrlCreateGroup(" Version 4.6 ", 18, 10, 364, 110)

GUICtrlCreateGroup("Settings", 18, 130, 364, 150)

$usb_fixed = GUICtrlCreateCheckbox("", 32, 155, 17, 17)
GUICtrlSetTip($usb_fixed, " Allow to Select Fixed USB drives ")
GUICtrlCreateLabel( "Allow to Select Fixed USB drives", 56, 155)

GUICtrlCreateGroup("Target Drive", 18, 290, 265, 54)
$Target = GUICtrlCreateInput($TargetSel, 32, 312, 95, 20, $ES_READONLY)
$TargetSel = GUICtrlCreateButton("...", 133, 313, 26, 18)
GUICtrlSetTip(-1, " Select Target Drive of USB-Stick " & @CRLF _
& " GO will make other primary partition visible ")
GUICtrlSetOnEvent($TargetSel, "_target_drive")
$TargetSize = GUICtrlCreateLabel( "", 175, 306, 100, 15, $ES_READONLY)
$TargetFree = GUICtrlCreateLabel( "", 175, 323, 100, 15, $ES_READONLY)
GUICtrlSetOnEvent($TargetSel, "_target_drive")

GUICtrlCreateGroup("", 295, 290, 87, 54)

$GO = GUICtrlCreateButton("GO", 235, 360, 70, 30)
GUICtrlSetTip($GO, " GO will make other Primary Partition visible " & @CRLF _
& " Program will Exchange Partition Table Entries ")
$EXIT = GUICtrlCreateButton("EXIT", 320, 360, 60, 30)
GUICtrlSetState($GO, $GUI_DISABLE)
GUICtrlSetOnEvent($GO, "_Go")
GUICtrlSetOnEvent($EXIT, "_Quit")

$ProgressAll = GUICtrlCreateProgress(16, 368, 203, 16, $PBS_SMOOTH)

$hStatus = _GUICtrlStatusBar_Create($hGuiParent, -1, "", $SBARS_TOOLTIPS)
Global $aParts[3] = [310, 350, -1]
_GUICtrlStatusBar_SetParts($hStatus, $aParts)

_GUICtrlStatusBar_SetText($hStatus," Select Target Drive of USB-stick ", 0)

DisableMenus(1)

GUICtrlSetState($usb_fixed, $GUI_ENABLE)
GUICtrlSetState($TargetSel, $GUI_ENABLE)

GUISetState(@SW_SHOW)

;===================================================================================================
While 1
	CheckGo()
    Sleep(300)
WEnd   ;==> Loop
;===================================================================================================
Func CheckGo()
	If $TargetDrive <> "" Then 
		GUICtrlSetState($GO, $GUI_ENABLE)
		_GUICtrlStatusBar_SetText($hStatus," GO will Exchange Partition Table Entries ", 0)
	Else
		If GUICtrlRead($GO) = $GUI_ENABLE Then
			GUICtrlSetState($GO, $GUI_DISABLE)
			_GUICtrlStatusBar_SetText($hStatus," Select Target Drive of USB-stick ", 0)
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
Func _target_drive()
	Local $TargetSelect, $Tdrive, $FSvar, $valid = 0, $ValidDrives, $RemDrives
	Local $NoDrive[3] = ["A:", "B:", "X:"], $FileSys[3] = ["NTFS", "FAT32", "FAT"]
	Local $pos

	DisableMenus(1)
	
	If GUICtrlRead($usb_fixed) = $GUI_CHECKED  Then
		$ValidDrives = DriveGetDrive( "FIXED" )
		_ArrayPush($ValidDrives, "")
		_ArrayPop($ValidDrives)
		$RemDrives = DriveGetDrive( "REMOVABLE" )
		_ArrayPush($RemDrives, "")
		_ArrayPop($RemDrives)
		_ArrayConcatenate($ValidDrives, $RemDrives)
	Else
		$ValidDrives = DriveGetDrive( "REMOVABLE" )
	EndIf
	; _ArrayDisplay($ValidDrives)
	
	$TargetDrive = ""
	GUICtrlSetData($Target, "")
	GUICtrlSetData($TargetFileSys, "")			
	GUICtrlSetData($TargetSize, "")
	GUICtrlSetData($TargetFree, "")

	$TargetSelect = FileSelectFolder("Select Target Drive of USB-stick", "")
	If @error Then
		DisableMenus(0)
		Return
	EndIf
	
	$pos = StringInStr($TargetSelect, "\", 0, -1)
	If $pos = 0 Then
		MsgBox(48,"ERROR - Drive Invalid", "Drive Invalid - No Backslash Found" & @CRLF & @CRLF & "Selected Path = " & $TargetSelect & @CRLF & @CRLF _
		& " Please Select Removable Drive of USB-stick ", 3)
		DisableMenus(0)
		Return
	EndIf
	
	$pos = StringInStr($TargetSelect, " ", 0, -1)
	If $pos Then
		MsgBox(48,"ERROR - Drive Invalid", "Drive Invalid - Space Found" & @CRLF & @CRLF & "Selected = " & $TargetSelect & @CRLF & @CRLF _
		& " Please Select Removable Drive of USB-stick ", 3)
		DisableMenus(0)
		Return
	EndIf

	$pos = StringInStr($TargetSelect, ":", 0, 1)
	If $pos <> 2 Then
		MsgBox(48,"ERROR - Drive Invalid", "Drive Invalid - : Not found" & @CRLF & @CRLF & "Selected = " & $TargetSelect & @CRLF & @CRLF _
		& " Please Select Removable Drive of USB-stick ", 3)
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
			MsgBox(48, "ERROR - Drive NOT Valid", " Drive A: B: and X: " & @CRLF & @CRLF & " Please Select Removable Drive of USB-stick ", 3)
			DisableMenus(0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	NEXT
	If $valid And DriveStatus($Tdrive) <> "READY" Then 
		$valid = 0
		MsgBox(48, "ERROR - Drive NOT Ready", "Drive NOT READY" & @CRLF & @CRLF & " Please Select Removable Drive of USB-stick ", 3)
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
			MsgBox(48, "ERROR - Invalid FileSystem", " NTFS - FAT32 or FAT FileSystem NOT Found ", 3)
			DisableMenus(0)
			GUICtrlSetState($TargetSel, $GUI_ENABLE + $GUI_FOCUS)
			Return
		EndIf
	EndIf
	If $valid Then
		$TargetDrive = $Tdrive
		
		GUICtrlSetData($Target, $TargetDrive)
		$TargetSpaceAvail = Round(DriveSpaceFree($TargetDrive))
		GUICtrlSetData($TargetSize, $FSvar & "     " & Round(DriveSpaceTotal($TargetDrive) / 1024, 1) & " GB")
		GUICtrlSetData($TargetFree, "FREE  =  " & Round(DriveSpaceFree($TargetDrive) / 1024, 1) & " GB")
	Else
		MsgBox(48, "Drive NOT Valid", " Please Select Removable Drive of USB-stick ")
	EndIf
	DisableMenus(0)
EndFunc   ;==> _target_drive
;===================================================================================================
Func _Go()
	Local $file, $line, $linesplit[20], $inst_disk="", $inst_part="", $mptarget=0, $count
	
	Local $partab_1, $partab_2
	Local $file_rd, $fhan_rd, $rd_mbr, $file_wr, $fhan_wr, $wr_mbr

	_GUICtrlStatusBar_SetText($hStatus," wait 2 seconds ....", 0)
	GUICtrlSetData($ProgressAll, 5)
	DisableMenus(1)

	$DriveType=DriveGetType($TargetDrive)
	If $DriveType <> "Removable" And GUICtrlRead($usb_fixed) = $GUI_UNCHECKED Then
		MsgBox(16, "Invalid Drive", " Drive is NOT Removable USB-stick ", 0)
		Exit
	EndIf

	If FileExists(@ScriptDir & "\makebt\bs_temp") Then DirRemove(@ScriptDir & "\makebt\bs_temp",1)
	If Not FileExists(@ScriptDir & "\makebt\bs_temp") Then DirCreate(@ScriptDir & "\makebt\bs_temp")
	
	GUICtrlSetData($ProgressAll, 10)
		
	; Better use ListUsbDrives.exe because MBRWiz.exe can give wrong $inst_disk nr when USB-drives are disconnected
	
	Sleep(2000)

	GUICtrlSetData($ProgressAll, 20)
	_GUICtrlStatusBar_SetText($hStatus," List USB Drives - Please wait  .... ", 0)
	
	$DriveType=DriveGetType($TargetDrive)

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
	
	; MsgBox(0, "TargetDrive - OK", "Target Drive = " & $TargetDrive & @CRLF & "Device Number = " & $inst_disk & @CRLF & "Partition Number = " & $inst_part, 0)

	If $inst_disk = "" Or $inst_part = "" Then
		MsgBox(48, "ERROR - Target Drive NOT Valid", "Device Number NOT Found in makebt\usblist.txt" & @CRLF & @CRLF & _
		"Target Drive = " & $TargetDrive & "   HDD = " & $inst_disk & "   PART = " & $inst_part)
		Exit
	EndIf
	
	If $usbfix = 0 Then
		MsgBox(48, "ERROR - Target Drive NOT Valid", " Drive is NOT USB-disk " & @CRLF & @CRLF & _
		"Target Drive = " & $TargetDrive & "   HDD = " & $inst_disk & "   PART = " & $inst_part)
		Exit
	EndIf

	Sleep(2000)

	_GUICtrlStatusBar_SetText($hStatus," Copy MBR of Disk " & $inst_disk & " - wait ...", 0)

	RunWait(@ComSpec & " /c makebt\dsfo.exe \\.\PHYSICALDRIVE" & $inst_disk & " 0 512 makebt\bs_temp\hd_" & $inst_disk & ".mbr", @ScriptDir, @SW_HIDE)

	GUICtrlSetData($ProgressAll, 40)
	Sleep(1000)
	
	GUICtrlSetData($ProgressAll, 50)
	_GUICtrlStatusBar_SetText($hStatus," Flip Partitions in MBR of Disk " & $inst_disk & " - wait ...", 0)

	$file_rd = @ScriptDir & "\makebt\bs_temp\hd_" & $inst_disk & ".mbr"
	$file_wr = @ScriptDir & "\makebt\bs_temp\usb_flip.mbr"

	$fhan_rd = FileOpen($file_rd, 16)
	If $fhan_rd = -1 Then
		MsgBox(48, "WARNING - MBR NOT FOUND", "Unable to open file makebt\bs_temp\hd_" & $inst_disk & ".mbr")
		Exit
	EndIf
	$rd_mbr = FileRead($fhan_rd)
	FileClose($fhan_rd)
	
	$partab_1 = StringMid($rd_mbr, 895, 32)
	$partab_2 = StringMid($rd_mbr, 927, 32)

	; Cut at 894
	$wr_mbr = StringLeft($rd_mbr, 894) & $partab_2 & $partab_1 & StringRight($rd_mbr, 68)

	$fhan_wr = FileOpen($file_wr, 16 + 2)
	If $fhan_wr = -1 Then
		MsgBox(48, "ERROR - File NOT Open", "Unable to Write - File Handle = " & $fhan_wr & @CRLF & $file_wr, 0)
		Exit
	EndIf
	
	FileWrite($fhan_wr , $wr_mbr)
	FileClose($fhan_wr)
	
	Sleep(3000)

	GUICtrlSetData($ProgressAll, 60)
	_GUICtrlStatusBar_SetText($hStatus," Write MBR of Disk " & $inst_disk & " - wait ...", 0)
	
	If FileExists(@ScriptDir & "\makebt\bs_temp\usb_flip.mbr") Then
		RunWait(@ComSpec & " /c makebt\dsfi.exe  \\.\PHYSICALDRIVE" & $inst_disk & " 0 512 makebt\bs_temp\usb_flip.mbr", @ScriptDir, @SW_HIDE)
		Sleep(3000)
	Else
		MsgBox(48, "ERROR - File NOT Found", "Unable to Write MBR File makebt\bs_temp\usb_flip.mbr", 0)
		Exit
	EndIf

	GUICtrlSetData($ProgressAll, 70)
	_GUICtrlStatusBar_SetText($hStatus," Disconnect and Reconnect USB-stick ", 0)
	
	MsgBox(48, "STOP - MBR Update Disconnect ", " First Disconnect and Reconnect USB-stick " & @CRLF _
	& " After Reconnect Click OK to Continue ", 0)

	GUICtrlSetData($ProgressAll, 80)
	
	_GUICtrlStatusBar_SetText($hStatus," Wait 3 seconds ....", 0)
	Sleep(3000)
	
	$FSvar = DriveGetFileSystem($TargetDrive)
	GUICtrlSetData($Target, $TargetDrive)
	GUICtrlSetData($TargetSize, $FSvar & "     " & Round(DriveSpaceTotal($TargetDrive) / 1024, 1) & " GB")
	GUICtrlSetData($TargetFree, "FREE  =  " & Round(DriveSpaceFree($TargetDrive) / 1024, 1) & " GB")
	
	GUICtrlSetData($ProgressAll, 90)

	Sleep(1000)
	
	GUICtrlSetData($ProgressAll, 100)
	_GUICtrlStatusBar_SetText($hStatus," End of Program - OK", 0)
	
	MsgBox(64, " END OF PROGRAM - OK ", " End of Program  - OK ")
	Exit

EndFunc ;==> _Go
;===================================================================================================
Func DisableMenus($endis)
	If $endis = 0 Then 
		$endis = $GUI_ENABLE
	Else
		$endis = $GUI_DISABLE
	EndIf
	
	GUICtrlSetState($usb_fixed, $endis)
	GUICtrlSetState($TargetSel, $endis)
	GUICtrlSetState($Target, $endis)
	GUICtrlSetState($GO, $GUI_DISABLE)
	GUICtrlSetData($Target, $TargetDrive)
EndFunc ;==>DisableMenus
;===================================================================================================

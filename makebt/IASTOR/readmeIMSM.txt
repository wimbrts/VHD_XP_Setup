************************************************************
************************************************************
*  Installation Readme for Intel(R) Matrix Storage Manager.
*
*  Refer to the system requirements for the operating 
*  systems supported by Intel(R) Matrix Storage Manager.
*
*  This document makes references to products developed by
*  Intel. There are some restrictions on how these products
*  may be used, and what information may be disclosed to
*  others. Please read the Disclaimer section at the bottom
*  of this document, and contact your Intel field
*  representative if you would like more information.
*
************************************************************
************************************************************

************************************************************
*  Intel is making no claims of usability, efficacy or 
*  warranty. The INTEL SOFTWARE LICENSE AGREEMENT contained
*  herein completely defines the license and use of this 
*  software.
************************************************************


************************************************************
*  CONTENTS OF THIS DOCUMENT
************************************************************

This document contains the following sections:

1.  Overview
2.  System Requirements
3.  Language Support
4.  Determining the System Mode
5.  Installing the Software
6.  Verifying Installation of the Software
7.  Advanced Installation Instructions
8.  Identifying the Software Version Number
9.  Uninstalling the Software
10. Entering the Option ROM User Interface
11. Option ROM RAID Volume Management
12. Options to RESET the RAID volume in Option ROM
13. Verifying the Version of the Option ROM Software   


************************************************************
* 1.  OVERVIEW
************************************************************

The Intel(R) Matrix Storage Manager is designed to provide 
functionality for the following Storage Controllers:
    RAID Controllers:
    - Intel(R) ICH8M-E/ICH9M-E/PCHM SATA RAID Controller    
    - Intel(R) ICH8R/ICH9R/ICH10R/DO/PCH SATA RAID Controller 
    - Intel(R) ESB2 SATA RAID Controller  
    - Intel(R) ICH7MDH SATA RAID Controller
    - Intel(R) ICH7R/DH SATA RAID Controller   
       
    AHCI Controllers:
    - Intel(R) PCH SATA AHCI Controller
    - Intel(R) PCHM SATA AHCI Controller 4 Port
    - Intel(R) PCHM SATA AHCI Controller 6 Port   
    - Intel(R) ICH10D/DO SATA AHCI Controller 
    - Intel(R) ICH10R SATA AHCI Controller
    - Intel(R) EP80579 SATA AHCI Controller
    - Intel(R) ICH9M-E/M SATA AHCI Controller
    - Intel(R) ICH9R/DO/DH SATA AHCI Controller
    - Intel(R) ICH8M-E/M SATA AHCI Controller
    - Intel(R) ICH8R/DH/DO SATA AHCI Controller
    - Intel(R) ESB2 SATA AHCI Controller
    - Intel(R) ICH7M/MDH SATA AHCI Controller
    - Intel(R) ICH7R/DH SATA AHCI Controller
    
************************************************************
* 2.  SYSTEM REQUIREMENTS
************************************************************

1.  The system must contain an Intel(R) Core(TM)2 Duo or
    Intel(R) Core(TM)2 Extreme or Intel(R) Pentium(R) Processor
    or Intel(R) Xeon(R) Processor and one of the following
    Intel products listed in section 1 above.    
    

2.  The system must be running on one of the following
    operating systems:
    - Microsoft* Windows* 7
    - Microsoft* Windows* 7 x64 Edition (NOTE 1)
    - Microsoft* Vista*
    - Microsoft* Vista* x64 Edition (NOTE 1)    
    - Microsoft* Windows* Server 2008
    - Microsoft* Windows* Server 2008 x64 Edition (Note 1)
    - Microsoft* Windows* XP Home Edition
    - Microsoft* Windows* XP Professional
    - Microsoft* Windows* XP x64 Edition (NOTE 1)
    - Microsoft* Windows* Server 2003
    - Microsoft* Windows* Server 2003, 
      Web x64 Edition (NOTE 1)
    - Microsoft* Windows* Server 2003, 
      Standard x64 Edition (NOTE 1)
    - Microsoft* Windows* Server 2003, 
      Enterprise x64 Edition (NOTE 1)
    - Microsoft* Windows* Media Center Edition

NOTE 1: If the system is running Windows* 64-bit version, 
        the Intel(R) Matrix Storage Manager driver supporting 
        64-bit should be used.

3.  The following operating systems are not supported:

    Any version of the following Microsoft operating systems:
    - MS-DOS
    - Windows 3.1
    - Windows NT 3.51
    - Windows 95
    - Windows 98
    - Windows Millennium Edition (Me)
    - Windows NT 4.0
    - Windows 2000 Datacenter Server
    - Windows 2000 Professional
    - Windows 2000 Advanced Server

    Any version of the following operating systems:
    - Linux
    - UNIX
    - BeOS
    - MacOS
    - OS/2

4.  The system should contain at least the minimum system 
    memory required by the operating system.

5.  The 'Intel(R) Chipset Software Installation Utility'
    must be installed prior to installing the 
    Intel(R) Matrix Storage Manager.



************************************************************
* 3.  LANGUAGE SUPPORT
************************************************************

Below is a list of the languages (and their abbreviations)
for which the Intel(R) Matrix Storage Manager software has 
been localized. The language code is listed in parentheses 
after each language.

ARA -> Arabic (Saudi Arabia)   (0401)
CHS -> Chinese (Simplified)    (0804)
CHT -> Chinese (Traditional)   (0404)
CSY -> Czech                   (0405)
DAN -> Danish                  (0406)
NLD -> Dutch                   (0413)
ENU -> English (United States) (0409)
FIN -> Finnish                 (040B)
FRA -> French (International)  (040C)
DEU -> German                  (0407)
ELL -> Greek                   (0408)
HEB -> Hebrew                  (040D)
HUN -> Hungarian               (040E)
ITA -> Italian                 (0410)
JPN -> Japanese                (0411)
KOR -> Korean                  (0412)
NOR -> Norwegian               (0414)
PLK -> Polish                  (0415)
PTB -> Portuguese (Brazil)     (0416)
PTG -> Portuguese (Standard)   (0816)
RUS -> Russian                 (0419)
ESP -> Spanish                 (0C0A)
SVE -> Swedish                 (041D)
THA -> Thai                    (041E)
TRK -> Turkish                 (041F)


************************************************************
* 4.  DETERMINING THE SYSTEM MODE
************************************************************

To use this Readme effectively, you will need to know what 
mode your system is in. The easiest way to determine the 
mode is to identify how the Serial ATA controller is 
presented within the Device Manager. The following 
procedure will guide you through determining the mode.

1.  On the Start menu:
    1a. For Windows* Vista or later operating systems,
        select Control Panel.

2.  Open the 'System' applet (you may first 
    have to select 'Switch to Classic View').

3.  Select the 'Hardware' tab. 

4.  Select the 'Device Manager' button.

5.  From the Device Manager, look for an entry named 
    'Storage Controllers' for Windows Vista and 
    'SCSI and RAID Controllers' for Windows XP and later
    operating systems.If this entry is present, 
    expand it and look for one of the controllers listed 
    in the Overview Section1. If the controller identified is 
    a RAID controller, then the system is in RAID mode. 
    
    If none of the controllers above are shown, 
    then the system is not running in RAID mode and 
    you should continue with step 6 below.

6.  From the Device Manager, look for an entry named 
    'IDE ATA/ATAPI controllers'. If this entry is present, 
    expand it and look for one of the controllers listed 
    in the Overview Section1. If an AHCI controller is 
    identified, then the system is in AHCI mode.

    If none of the controllers above are shown, then 
    your system is not in AHCI mode. No other modes are  
    supported by the Intel(R) Matrix Storage Manager 
    software and you should continue with step 7 below.

7.  Your system does not appear to be running in RAID or 
    AHCI mode. If you feel that your system is running in 
    RAID or AHCI mode and you do not see any of the 
    controllers listed above, you may choose to contact 
    your system manufacturer or place of purchase for 
    assistance.


************************************************************
* 5.  INSTALLING THE SOFTWARE
************************************************************

5.1 General Installation Notes

1.  If you are installing the operating system on a system
    configured for RAID or AHCI mode, you must pre-install 
    the Intel(R) Matrix Storage Manager driver using the 
    F6 installation method described in section 5.3.

2.  The 'Intel(R) Chipset Software Installation Utility' 
    must be installed on the system after a supported 
    Microsoft* Windows* operating system has been installed.

3.  To install the Intel(R) Matrix Storage Manager, 
    double-click on the self-extracting and self-installing 
    setup file and answer all prompts presented.

4.  By default, all installed files (readme.txt, help, etc.) 
    are copied to the following path: 
    
    <bootdrive>\Program Files\Intel\Intel(R) Matrix Storage Manager

	
5.2 Windows Automated Installer* Installation from Hard 
    Drive or CD-ROM
    
Note: This method is applicable to systems configured for 
      RAID or AHCI mode.

1.  Download the Intel(R) Matrix Storage Manager setup file
    and double-click to self-extract and to begin the setup 
    process.

2.  The 'Welcome' window appears. Click Next to continue.

3.  The 'Uninstallation Warning' window appears. Click Next 
    to continue.

4.  The 'Software License Agreement' window appears. If you 
    agree to these terms, click Yes to continue.

5.  The 'Readme File Information' window appears. Click Next
    to continue.

6.  The 'Choose Destination Location' window appears.
    Click Next to continue.

7.  The 'Select Program Folder' window appears.  Click Next 
    to continue installing the driver.

8.  If the Windows Automated Installer* Wizard Complete window 
    is shown without a prompt to restart the system, click 
    Finish and proceed to step 8. If it is shown with a 
    prompt to restart the system, click Yes, I want to 
    restart my computer now. (the default selection) and 
    click Finish. Once the system has restarted,
    proceed to step 8.

9.  To verify that the driver was loaded correctly, refer 
    to section 6.


5.3 Pre-Installation Using the F6 Method. 

Note: The Steps 1 and 2 can be skipped if you use the F6 Floppy
      disk utility provided by Intel. These methods 
      are applicable to systems configured for RAID or 
      AHCI mode.

1.  Extract all driver files from the installation package.
    See section 7.2 for instructions on extracting the 
    files.

2.  Create a floppy* containing the following files in the root 
    directory:
    iaAhci.inf, iaAhci.cat,
    iaStor.inf, iaStor.cat,
    iaStor.sys, and 
    TxtSetup.oem. 

    * Note: For Windows Vista you can use a floppy, CD/DVD or USB.

3.  For Windows XP or later operating systems:

    - At the beginning of the operating system installation,
     press F6 to install a third party SCSI or RAID driver.

    - When prompted, select 'S' to Specify Additional Device.

    - Continue to step 5.

4.  For Windows Vista:

    - During the operating system installation, after selecting the 
     location to install Vista, click Load Driver to 
install a third 
     party SCSI or RAID driver.

    - Continue to step 5.

5.  When prompted, insert the media (floppy, CD/DVD
 or USB) you 
    created in step 2 and press Enter.

6.  At this point you should be presented with a selection
    for one of the controllers listed in the Overview (Section 1) 
    of this document depending on your hardware version and 
    configuration.

7.  Highlight the selection that is appropriate for the 
    hardware in your system and press Enter.

8.  Press Enter again to continue. Leave the floppy disk in 
    the system until the next reboot as the software will 
    need to be copied from the floppy disk again when setup
    is copying files.


************************************************************
* 6.  VERIFYING INSTALLATION OF THE SOFTWARE
************************************************************

6.1 Verifying Have Disk, F6, or Unattended Installation: 
    depending on your system configuration, refer to the 
    appropriate sub-topic below:


6.1a Systems Configured for RAID Mode:

1.  On the Start menu:
    1a. For Windows* XP or later operating systems,
        select Control Panel.
2.  Open the 'System' applet (you may first 
    have to select 'Switch to Classic View').
3.  Select the 'Hardware' tab in Windows* XP or Windows* 
    Server 2003.
4.  Select the 'Device Manager' button.
5.  Expand the 'Storage Controllers' (for Windows Vista) or 
    'SCSI and RAID Controllers' (for Windows XP and later
    operating systems) entry.
6.  Right-click on Intel(R) SATA RAID Controller.    
7.  Select 'Properties'.
8.  Select the 'Driver' tab.
9.  Select the 'Driver Details' button.
10. If the 'iaStor.sys' file is displayed, the installation 
    was successful.


6.1b Systems Configured for AHCI Mode:

1.  On the Start menu:
    1a. For Windows* XP or later operating systems, 
        select Control Panel.
2.  Open the 'System' applet (you may first 
    have to select 'Switch to Classic View').
3.  Select the 'Hardware' tab in Windows* XP or Windows* 
    Server 2003.
4.  Select the 'Device Manager' button.
5.  Expand the 'IDE ATA/ATAPI controllers' entry.
6.  Right-click on Intel(R) SATA AHCI Controller.
7.  Select 'Properties'.
8.  Select the 'Driver' tab.
9.  Select the 'Driver Details' button.
10. If the 'iaStor.sys' file is displayed, the installation 
    was successful.


6.2 Verifying Windows Automated Installer* or 'Package for 
    the Web' Installations:

1.  Click Start.
2.  Find the 'Intel(R) Matrix Storage Manager' 
    program group.
3.  Select the 'Intel(R) Matrix Storage Console' entry
4.  The 'Intel(R) Matrix Storage Console' application should 
    launch.
5.  If this application does not launch, the Intel(R) 
    Matrix Storage Manager driver was not installed 
    properly and setup needs to be run. 

************************************************************
* 7.  ADVANCED INSTALLATION INSTRUCTIONS
************************************************************

7.1 Available Setup Flags:

    -?             The installer presents a dialog showing
                   all the supported setup flags (shown 
                   here) and their usage. 
    -A             Extracts all files (does not install 
                   driver) to <path> if -P is also 
                   supplied; otherwise, the files are
                   extracted to the default location.
    -B             Forces a system reboot after installation.
    -O<name>       Allows for the customization of the 
                   program folder name for the Intel(R) 
                   Matrix Storage Console, which will appear 
                   in the Start, 'All Programs' menu.
    -P<path>       Supplies target path when using -A flag.
    -N             Installs all components except driver.
    -NoGUI         Installs only the driver; the Intel(R) 
                   Matrix Storage Console, Event Monitor, 
                   and Tray icon applet are not installed.
    -NoMon         Disables the Event Monitor which
                   consists of the Disk Monitor Service and
                   the System Tray icon applet.
    -S             Silent install (no user prompts).
    -BUILD         Displays build information.		
    -G <number>     Forces a particular language install 
                   (See section 3 for a table mapping 
                   <number> to language). 
    -f2<path\name> Creates a log file in <existing path> 
                   with <name>; this is to be used during 
                   silent installation. There cannot be 
                   a space between -f2 and <path\name>, 
                   and the path must exist prior to 
                   installation.

Notes:  Flags and their parameters are not case-sensitive.
        Flags may be supplied in any order, with the 
        exception of the -S and -G, which must be 
        supplied last. When using the -A flag, a target 
        path may be specified via the -P flag, and the -O, 
        -G, -S, and -N flags are ignored. When using the 
        -P, -O, and -f2 flags there should be no space 
        between the flag and the argument. When using the -f2 
        flag, a log file name and path must be specified, and 
        the path must exist prior to the installation.

7.2 Use one of the following command examples to extract the 
    driver files from the different package types:

      c:\iata_cd.exe -a -a -pc:\<path>
      c:\iata_enu.exe -a -a -pc:\<path>
      c:\setup.exe -a -pc:\<path>

    When the command is run, the installation process begins; 
    simply click through the dialogs as prompted. This will not 
    install the driver, it will only extract the driver files to 
    <path>. After the extraction is completed, the driver 
    files can be found in <path>\Driver.


7.3 To install the RAID driver on Windows* XP, as outlined in the Microsoft
    document 'Deployment Guide Automating Windows NT Setup', 
    use the supplied TXTSETUP.OEM file included in this 
    package and insert the lines shown in step 7.3a and 
    7.3b below into the UNATTEND.TXT file. This method is 
    available for Microsoft* Windows* XP and
    Windows Server 2003. Before you begin, iaAhci.inf, 
    iaAhci.cat, iaStor.inf, iaStor.cat, iaStor.sys, and 
    Txtsetup.oem files will need to be extracted from the 
    setup files. To extract these files, use the method 
    described in section 7.2 above.

7.3a Systems Configured for RAID Mode
    Note: An example is shown below. Depending upon your system
    hardware configuration, please update the text 
    with the correct RAID controller name using the list in the 
    Overview (Section 1) of this document. 
    
    // Insert the lines below into the UNATTEND.TXT file
      
    [MassStorageDrivers]
    "Intel(R) 82801IR/IO SATA RAID Controller" = OEM
 
    [OEMBootFiles]
    iaStor.inf
    iaStor.sys
    iaStor.cat
    Txtsetup.oem


7.3b Systems Configured for AHCI Mode

Note: An example is shown below. Depending upon your system
    hardware configuration, please update the text 
    with the correct AHCI controller name using the list in the 
    Overview (Section 1) of this document. 

    // Insert the lines below into the UNATTEND.TXT file

    [MassStorageDrivers]
    "Intel(R) 82801IR/IO SATA AHCI Controller" = OEM
 
    [OEMBootFiles]
    iaAhci.inf
    iaStor.sys
    iaAhci.cat
    Txtsetup.oem

************************************************************
* 8.  IDENTIFYING THE SOFTWARE VERSION NUMBER
************************************************************

8.1 Use the following steps to identify the software version 
    number following a Have Disk, F6, or unattended 
    installation.


8.1a Systems Configured for RAID Mode:

1.  On the Start menu:
    1a. For Windows* XP or later operating systems, 
        select Control Panel.
2.  Open the 'System' applet (you may first 
    have to select 'Switch to Classic View').
3.  Select the 'Hardware' tab in Windows* XP or 
    Windows* Server 2003.
4.  Select the 'Device Manager' button.
5.  Expand the 'SCSI and RAID Controllers' entry.
6.  Right-click on Intel(R) RAID Controller present
7.  Select 'Properties'.
8.  Select the 'Driver' tab.
9.  The software version should be displayed after
    'Driver Version:'.


8.1b Systems Configured for AHCI Mode:

1.  On the Start menu:
    1a.For Windows* XP or later operating systems, 
        select Control Panel.
2.  Open on the 'System' applet (you may first 
    have to select 'Switch to Classic View').
3.  Select the 'Hardware' tab in Windows* XP or Windows* 
    Server 2003.
4.  Select the 'Device Manager' button.
5.  Expand the 'IDE ATA/ATAPI controllers' entry.
6.  Right-click on the Intel(R) SATA AHCI Controller present.     
7.  Select 'Properties'.
8.  Select the 'Driver' tab.
9.  The software version is displayed after
    'Driver Version:'.


8.2 Identify the software version for Windows Automated 
    Installer* or 'Package for the Web' Installations:

1.  Click Start and All Programs. 
2.  Find the 'Intel(R) Matrix Storage Manager' program 
    group.
3.  Select the 'Intel(R) Matrix Storage Console' item.
4.  The 'Intel(R) Matrix Storage Console' application will 
    be shown, with the version shown in the splash screen. 
    The version can also be viewed by selecting 'About' 
    from within the 'Help' menu.


************************************************************
* 9.  UNINSTALLING THE SOFTWARE
************************************************************

9a. UNINSTALLATION OF NON-DRIVER COMPONENTS
The removal of this software from the system will render any 
Serial ATA hard drives inaccessible by the operating system;
therefore, uninstallation procedure will only uninstall 
non-critical components of this software (user interface, 
start menu links, etc.). To remove critical components, see
section 9b. 

Use the following procedure to uninstall the software:

1. Select 'Uninstall' from the following Start menu folder:

   * All Programs -> Intel(R) Matrix Storage Manager

2. The uninstall program will start. Click through the
   options for the uninstallation.

9b. UNINSTALLATION OF DRIVER COMPONENTS
The removal of this software from the system will render any 
Serial ATA hard drives inaccessible by the operating system.
Back up any important data before completing these steps.
 
1) If the system is in RAID mode, delete any RAID volumes
using the Intel(R) Matrix Storage Manager option ROM
user interface.
2) Reboot the system.
3) Enter the system BIOS (usually done by pressing a key 
such as 'F2' or 'Delete' during system boot).
4) Disable 'Intel(R) RAID Technology' and 'SATA AHCI mode'.
5) Reinstall the operating system.
 
Note: If you experience any difficulties making these 
changes to the system BIOS, please contact the motherboard
manufacturer or your place of purchase for assistance.
 
************************************************************
* 10.  ENTERING THE OPTION ROM USER INTERFACE
************************************************************

Use the following steps to enter the Intel(R) Matrix Storage 
Manager option ROM user interface:

1. Boot the System.
2. Press CTRL-I when the 
   'Intel(R) Matrix Storage Manager option ROM vX.y.w.zzzz' 
   banner screen appears.

************************************************************
* 11.  OPTION ROM RAID VOLUME MANAGEMENT
************************************************************
The Intel(R) Matrix Storage Manager option ROM provides 
pre-OS RAID volume management which enables the following:

1. Create RAID Volume
   Use this option to create one or two RAID volumes.

2. Delete RAID Volume
   Use this option to delete a RAID volume.

3. Reset Disks to Non-RAID 
   Use this option to reset a RAID configuration to a 
   non-RAID configuration.

4. Recovery Volume Options
   If a recovery volume is present, use this option to 
        a. Disable Continuous Update
        b. Enable Only Recovery Disk
        c. Enable Only Master Disk


************************************************************
* 12.  OPTIONS TO RESET THE RAID VOLUME IN OPTION ROM
************************************************************
Intel(R) Matrix Storage option ROM user interface provides 
two methods for resetting the RAID volume:
1. Delete RAID Volume
2. Reset Disks to Non-RAID
   Differences between the options are noted below. Users are 
   advised to select the option based on the situation.

12.1 Delete RAID Volume

     When a RAID volume is deleted, RAID metadata on the 
     participating disks is erased and sector zero is cleared,
     that is partition table and file system related data are 
     reset. Windows installer will not see any invalid data 
     at the time of OS installation. This is the recommended 
     method for reconfiguring the RAID volume and installing OS 
     on it.

12.2 Reset Disks to Non-RAID

     This option is used to reset the metadata on the disk which 
     participates in more than one RAID volume in single 
     operation.It should be used if 'Delete RAID Volume' option 
     fails for any reason and to reset a disk that has been 
     marked as Spare and offline member. When a disk in the RAID 
     volume is reset to non-RAID, RAID metadata is erased. 
     However, partition table and file system related data still 
     exists, which may be invalid. This might cause Windows 
     installer to misinterpret the information available on the 
     'reset disk' at the time of installation. This could result 
     in unexpected behavior in OS installation.


************************************************************
* 13.  VERIFYING THE VERSION OF THE OPTION ROM SOFTWARE
************************************************************

1. Use the following steps to identify the version number of
   the Intel(R) Matrix Storage option ROM:

   - Enter the Intel(R) Matrix Storage option ROM user 
     interface using the steps detailed in section 10.
   - The software version will be displayed in the user 
     interface banner:
     'Intel(R) Matrix Storage Manager option ROM vX.y.w.zzzz'

     X.y.w.zzzz is the version number of the option ROM 
     installed on your system.
     X.y.w - Product release number
     X     - Major number
     y     - Minor number
     w     - Hotfix number
     zzzz  - Build number

************************************************************
* DISCLAIMER
************************************************************

Information in this document is provided in connection with
Intel products. Except as expressly stated in the INTEL
SOFTWARE LICENSE AGREEMENT contained herein, no license,
express or implied, by estoppel or otherwise, to any
intellectual property rights is granted by this document.
Except as provided in Intel's Terms and Conditions of Sale
for such products, Intel assumes no liability whatsoever,
and Intel disclaims any express or implied warranty,
relating to sale and/or use of Intel products, including
liability or warranties relating to fitness for a particular
purpose, merchantability or infringement of any patent,
copyright or other intellectual property right. Intel
products are not intended for use in medical, lifesaving,
or life sustaining applications.

************************************************************
* Intel Corporation disclaims all warranties and liabilities
* for the use of this document, the software and the
* information contained herein, and assumes no
* responsibility for any errors which may appear in this
* document or the software, nor does Intel make a commitment
* to update the information or software contained herein.
* Intel reserves the right to make changes to this document
* or software at any time, without notice.
************************************************************

* Third-party brands and names may be claimed as the 
  property of others.

Copyright (c) Intel Corporation, 2001-2009
*******************************************************************************
* INTEL SOFTWARE LICENSE AGREEMENT
*******************************************************************************

INTEL SOFTWARE LICENSE AGREEMENT (Alpha / Beta, Organizational Use)

IMPORTANT - READ BEFORE COPYING, INSTALLING OR USING. 

Do not use or load this software and any associated materials (collectively, the "Software") until you have carefully read the following terms and conditions. By loading or using the Software, you agree to the terms of this Agreement. If you do not wish to so agree, do not install or use the Software.

The Software contains pre-release "alpha" or "beta" code, which may not be fully functional and which Intel Corporation ("Intel") may substantially modify in producing any "final" version of the Software.  Intel can provide no assurance that it will ever produce or make generally available a "final" version of this Software.

LICENSE. This Software is licensed for use only in conjunction with Intel component products.  Use of the Software in conjunction with non-Intel component products is not licensed hereunder. You may copy the Software onto your organization's computers for your organization's use, and you may make a reasonable number of back-up copies of the Software, subject to these conditions: 
1. You may not copy, modify, rent, sell, distribute or transfer any part of the Software, except as provided in this Agreement, and you agree to prevent unauthorized copying of the Software.
2. You may not reverse engineer, decompile or disassemble the Software. 
3. You may not sublicense the Software.
4. The Software may contain the software or other property of third party suppliers, some of which may be identified in, and licensed in accordance with, an enclosed "license.txt" file or other text or file. 

OWNERSHIP OF SOFTWARE AND COPYRIGHTS. Title to all copies of the Software remains with Intel or its suppliers. The Software is copyrighted and protected by the laws of the United States and other countries, and international treaty provisions. You may not remove any copyright notices from the Software.  Intel may make changes to the Software, or to items referenced therein, at any time and without notice, but is not obligated to support or update the Software. Except as otherwise expressly provided, Intel grants no express or implied right under Intel patents, copyrights, trademarks or other intellectual property rights. You may transfer the Software only if the recipient agrees to be fully bound by these terms and if you retain no copies of the Software.

LIMITED MEDIA WARRANTY.  If the Software has been delivered by Intel on physical media, Intel warrants the media to be free from material physical defects for a period of (90) ninety days after delivery by Intel. If such a defect is found, return the media to Intel for replacement or alternate delivery of the Software, as Intel may select.

EXCLUSION OF OTHER WARRANTIES. EXCEPT AS PROVIDED ABOVE, THE SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY EXPRESS OR IMPLIED WARRANTY OF ANY KIND, INCLUDING WARRANTIES OF MERCHANTABILITY, NONINFRINGEMENT OR FITNESS FOR A PARTICULAR PURPOSE.  Intel does not warrant or assume responsibility for the accuracy or completeness of any information, text, graphics, links or other items contained within the Software.

LIMITATION OF LIABILITY. IN NO EVENT SHALL INTEL OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, LOST PROFITS, BUSINESS INTERRUPTION OR LOST INFORMATION) ARISING OUT OF THE USE OF OR THE INABILITY TO USE THE SOFTWARE, EVEN IF INTEL HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS PROHIBIT EXCLUSION OR LIMITATION OF LIABILITY FOR IMPLIED WARRANTIES OR CONSEQUENTIAL OR INCIDENTAL DAMAGES, SO THE ABOVE LIMITATION MAY NOT APPLY TO YOU. YOU MAY ALSO HAVE OTHER LEGAL RIGHTS THAT VARY FROM JURISDICTION TO JURISDICTION. 

TERMINATION OF THIS AGREEMENT. Intel may terminate this Agreement at any time if you violate its terms. Upon termination, you will immediately destroy the Software or return all copies of the Software to Intel.
 
APPLICABLE LAWS. Claims arising under this Agreement shall be governed by the laws of California, excluding its principles of conflict of laws and the United Nations Convention on Contracts for the Sale of Goods. You may not export the Software in violation of applicable export laws and regulations. Intel is not obligated under any other agreements, unless they are in writing and signed by an authorized representative of Intel.

GOVERNMENT RESTRICTED RIGHTS. The Software is provided with "RESTRICTED RIGHTS." Use, duplication or disclosure by the Government is subject to restrictions as set forth in FAR52.227-14 and DFAR252.227-7013 et seq. or their successors. Use of the Software by the Government constitutes acknowledgment of Intel's proprietary rights therein. Contractor or Manufacturer is Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95052.
SLA-ALPHABETA-ORG.DOC/RBK/01-21-00

INTEL SOFTWARE LICENSE AGREEMENT (OEM / IHV / ISV Distribution & Single User)

IMPORTANT - READ BEFORE COPYING, INSTALLING OR USING. 
Do not use or load this software and any associated materials (collectively, the "Software") until you have carefully read the following terms and conditions. By loading or using the Software, you agree to the terms of this Agreement. If you do not wish to so agree, do not install or use the Software.

Please Also Note:
* If you are an Original Equipment Manufacturer (OEM), Independent Hardware Vendor (IHV), or Independent Software Vendor (ISV), this complete LICENSE AGREEMENT applies;
* If you are an End-User, then only Exhibit A, the INTEL SOFTWARE LICENSE AGREEMENT, applies.

For OEMs, IHVs, and ISVs:

LICENSE. This Software is licensed for use only in conjunction with Intel component products.  Use of the Software in conjunction with non-Intel component products is not licensed hereunder. Subject to the terms of this Agreement, Intel grants to you a nonexclusive, nontransferable, worldwide, fully paid-up license under Intel's copyrights to:
	a) use, modify and copy Software internally for your own development and maintenance purposes; and
	b) modify, copy and distribute Software, including derivative works of the Software, to your end-users, but only under a license agreement with terms at least as restrictive as those contained in Intel's Final, Single User License Agreement, attached as Exhibit A; and
	c) modify, copy and distribute the end-user documentation which may accompany the Software, but only in association with the Software.

If you are not the final manufacturer or vendor of a computer system or software program incorporating the Software, then you may transfer a copy of the Software, including derivative works of the Software (and related end-user documentation) to your recipient for use in accordance with the terms of this Agreement, provided such recipient agrees to be fully bound by the terms hereof.  You shall not otherwise assign, sublicense, lease, or in any other way transfer or disclose Software to any third party. You shall not reverse- compile, disassemble or otherwise reverse-engineer the Software.

Except as expressly stated in this Agreement, no license or right is granted to you directly or by implication, inducement, estoppel or otherwise.  Intel shall have the right to inspect or have an independent auditor inspect your relevant records to verify your compliance with the terms and conditions of this Agreement.

CONFIDENTIALITY. If you wish to have a third party consultant or subcontractor ("Contractor") perform work on your behalf which involves access to or use of Software, you shall obtain a written confidentiality agreement from the Contractor which contains terms and obligations with respect to access to or use of Software no less restrictive than those set forth in this Agreement and excluding any distribution rights, and use for any other purpose.
Otherwise, you shall not disclose the terms or existence of this Agreement or use Intel's name in any publications, advertisements, or other announcements without Intel's prior written consent.  You do not have any rights to use any Intel trademarks or logos.

OWNERSHIP OF SOFTWARE AND COPYRIGHTS. Title to all copies of the Software remains with Intel or its suppliers. The Software is copyrighted and protected by the laws of the United States and other countries, and international treaty provisions. You may not remove any copyright notices from the Software. Intel may make changes to the Software, or to items referenced therein, at any time and without notice, but is not obligated to support or update the Software. Except as otherwise expressly provided, Intel grants no express or implied right under Intel patents, copyrights, trademarks, or other intellectual property rights. You may transfer the Software only if the recipient agrees to be fully bound by these terms and if you retain no copies of the Software.

LIMITED MEDIA WARRANTY. If the Software has been delivered by Intel on physical media, Intel warrants the media to be free from material physical defects for a period of ninety (90) days after delivery by Intel. If such a defect is found, return the media to Intel for replacement or alternate delivery of the Software as Intel may select.

EXCLUSION OF OTHER WARRANTIES. EXCEPT AS PROVIDED ABOVE, THE SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY EXPRESS OR IMPLIED WARRANTY OF ANY KIND, INCLUDING WARRANTIES OF MERCHANTABILITY, NONINFRINGEMENT, OR FITNESS FOR A PARTICULAR PURPOSE.  Intel does not warrant or assume responsibility for the accuracy or completeness of any information, text, graphics, links or other items contained within the Software.

LIMITATION OF LIABILITY. IN NO EVENT SHALL INTEL OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, LOST PROFITS, BUSINESS INTERRUPTION OR LOST INFORMATION) ARISING OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF INTEL HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS PROHIBIT EXCLUSION OR LIMITATION OF LIABILITY FOR IMPLIED WARRANTIES OR CONSEQUENTIAL OR INCIDENTAL DAMAGES, SO THE ABOVE LIMITATION MAY NOT APPLY TO YOU. YOU MAY ALSO HAVE OTHER LEGAL RIGHTS THAT VARY FROM JURISDICTION TO JURISDICTION. 

TERMINATION OF THIS AGREEMENT. Intel may terminate this Agreement at any time if you violate its terms. Upon termination, you will immediately destroy the Software or return all copies of the Software to Intel.
 
APPLICABLE LAWS. Claims arising under this Agreement shall be governed by the laws of California, excluding its principles of conflict of laws and the United Nations Convention on Contracts for the Sale of Goods. You may not export the Software in violation of applicable export laws and regulations. Intel is not obligated under any other agreements unless they are in writing and signed by an authorized representative of Intel.

GOVERNMENT RESTRICTED RIGHTS. The Software is provided with "RESTRICTED RIGHTS." Use, duplication, or disclosure by the Government is subject to restrictions as set forth in FAR52.227-14 and DFAR252.227-7013 et seq. or their successors. Use of the Software by the Government constitutes acknowledgment of Intel's proprietary rights therein. Contractor or Manufacturer is Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95052.


EXHIBIT "A" 
INTEL SOFTWARE LICENSE AGREEMENT (Final, Single User)

IMPORTANT - READ BEFORE COPYING, INSTALLING OR USING. 
Do not use or load this software and any associated materials (collectively, the "Software") until you have carefully read the following terms and conditions. By loading or using the Software, you agree to the terms of this Agreement. If you do not wish to so agree, do not install or use the Software.

LICENSE. You may copy the Software onto a single computer for your personal, noncommercial use, and you may make one back-up copy of the Software, subject to these conditions: 
1. This Software is licensed for use only in conjunction with Intel component products.  Use of the Software in conjunction with non-Intel component products is not licensed hereunder. 
2. You may not copy, modify, rent, sell, distribute or transfer any part of the Software except as provided in this Agreement, and you agree to prevent unauthorized copying of the Software.
3. You may not reverse engineer, decompile, or disassemble the Software. 
4. You may not sublicense or permit simultaneous use of the Software by more than one user.
5. The Software may contain the software or other property of third party suppliers, some of which may be identified in, and licensed in accordance with, any enclosed "license.txt" file or other text or file. 

OWNERSHIP OF SOFTWARE AND COPYRIGHTS. Title to all copies of the Software remains with Intel or its suppliers. The Software is copyrighted and protected by the laws of the United States and other countries, and international treaty provisions. You may not remove any copyright notices from the Software. Intel may make changes to the Software, or to items referenced therein, at any time without notice, but is not obligated to support or update the Software. Except as otherwise expressly provided, Intel grants no express or implied right under Intel patents, copyrights, trademarks, or other intellectual property rights. You may transfer the Software only if the recipient agrees to be fully bound by these terms and if you retain no copies of the Software.

LIMITED MEDIA WARRANTY. If the Software has been delivered by Intel on physical media, Intel warrants the media to be free from material physical defects for a period of ninety (90) days after delivery by Intel. If such a defect is found, return the media to Intel for replacement or alternate delivery of the Software as Intel may select.

EXCLUSION OF OTHER WARRANTIES EXCEPT AS PROVIDED ABOVE, THE SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY EXPRESS OR IMPLIED WARRANTY OF ANY KIND INCLUDING WARRANTIES OF MERCHANTABILITY, NONINFRINGEMENT, OR FITNESS FOR A PARTICULAR PURPOSE.  Intel does not warrant or assume responsibility for the accuracy or completeness of any information, text, graphics, links or other items contained within the Software.

LIMITATION OF LIABILITY.  IN NO EVENT SHALL INTEL OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, LOST PROFITS, BUSINESS INTERRUPTION, OR LOST INFORMATION) ARISING OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF INTEL HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS PROHIBIT EXCLUSION OR LIMITATION OF LIABILITY FOR IMPLIED WARRANTIES OR CONSEQUENTIAL OR INCIDENTAL DAMAGES, SO THE ABOVE LIMITATION MAY NOT APPLY TO YOU. YOU MAY ALSO HAVE OTHER LEGAL RIGHTS THAT VARY FROM JURISDICTION TO JURISDICTION. 

TERMINATION OF THIS AGREEMENT. Intel may terminate this Agreement at any time if you violate its terms. Upon termination, you will immediately destroy the Software or return all copies of the Software to Intel.
 
APPLICABLE LAWS. Claims arising under this Agreement shall be governed by the laws of California, excluding its principles of conflict of laws and the United Nations Convention on Contracts for the Sale of Goods. You may not export the Software in violation of applicable export laws and regulations. Intel is not obligated under any other agreements unless they are in writing and signed by an authorized representative of Intel.

GOVERNMENT RESTRICTED RIGHTS. The Software is provided with "RESTRICTED RIGHTS." Use, duplication, or disclosure by the Government is subject to restrictions as set forth in FAR52.227-14 and DFAR252.227-7013 et seq. or their successors. Use of the Software by the Government constitutes acknowledgment of Intel's proprietary rights therein. Contractor or Manufacturer is Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95052.
 
SLAOEMISV1/RBK/01-21-00

LANGUAGE; TRANSLATIONS.  In the event that the English language version of this Agreement is accompanied by any other version translated into any other language, such translated version is provided for convenience purposes only and the English language version shall control.


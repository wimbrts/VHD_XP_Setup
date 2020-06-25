************************************************************
************************************************************
* Fichier Readme pour l'installation d'Intel(R) Matrix 
* Storage Manager.
*
* Reportez-vous √† la configuration requise pour une liste
* des syst√®mes d'exploitation pris en charge par Intel(R) 
* Matrix Storage Manager.
*
* Ce document contient des r√©f√©rences √† des produits
* d√©velopp√©s par Intel. Certaines restrictions
* d'utilisation de ces produits existent, de m√™me que des
* restrictions de divulgation des informations √† des tiers. 
* Veuillez lire la section Avis de non-responsabilit√© au
* bas de ce document et contactez votre repr√©sentant Intel
* si vous souhaitez obtenir des informations suppl√©mentaires.
*
************************************************************
************************************************************

************************************************************
* Intel n'√©met aucune d√©claration de facilit√© d'utilisation, 
* d'efficacit√© ou de garantie. Le CONTRAT DE LICENCE DU 
* LOGICIEL INTEL contenu dans ce document d√©finit, de fa√ßon 
* compl√®te, la licence et l'utilisation de ce logiciel.
************************************************************


************************************************************
* CONTENU DE CE DOCUMENT
************************************************************

Ce document contient les sections suivantes :

1.  Pr√©sentation
2.  Configuration requise
3.  Langues prises en charge
4.  D√©termination du mode syst√®me
5.  Installation du logiciel
6.  V√©rification de l'installation du logiciel
7.  Instructions d'installation avanc√©es
8.  Identification du num√©ro de version du logiciel
9.  D√©sinstallation du logiciel
10. Ouverture de l'interface utilisateur Option ROM
11. Gestion des volumes RAID dans l'Option ROM
12. Options de r√©initialisation du volume RAID dans 
    l'Option ROM
13. V√©rification de la version du logiciel Option ROM


************************************************************
* 1.  PR√âSENTATION
************************************************************

Intel(R) Matrix Storage Manager est con√ßu pour fournir
une fonctionnalit√© aux contr√¥leurs de stockage suivants :
    Contr√¥leurs RAID :
    - Intel(R) ICH8M-E/ICH9M-E SATA RAID Controller    
    - Intel(R) ICH8R/ICH9R/ICH10R/DO SATA RAID Controller   
    - Intel(R) ESB2 SATA RAID Controller  
    - Intel(R) ICH7MDH SATA RAID Controller
    - Intel(R) ICH7R/DH SATA RAID Controller  

    Contr√¥leurs AHCI :
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
* 2.  CONFIGURATION REQUISE
************************************************************

1.  Le syst√®me doit contenir un processeur Intel(R) Core(TM)2 
    Duo ou Intel(R) Core(TM)2 Extreme ou Intel(R) Pentium(R) 
    Processor ou Intel(R) Xeon(R) Processor et un des
    produits Intel compris dans la section 1 ci-dessus.


2.  Le syst√®me doit ex√©cuter un des syst√®mes d'exploitation
    suivants :
    - Microsoft* Vista*
    - Microsoft* Vista* x64 Edition (REMPARQUE 1)    
    - Microsoft* Windows* Server 2008
    - Microsoft* Windows* Server 2008 x64 Edition (REMARQUE 1)
    - Microsoft* Windows* XP Home Edition
    - Microsoft* Windows* XP Professional
    - Microsoft* Windows* XP x64 Edition (REMPARQUE 1)
    - Microsoft* Windows* Server 2003
    - Microsoft* Windows* Server 2003, 
      Web x64 Edition (REMARQUE 1)
    - Microsoft* Windows* Server 2003, 
      Standard x64 Edition (REMARQUE 1)
    - Microsoft* Windows* Server 2003, 
      Enterprise x64 Edition (REMARQUE 1)
    - Microsoft* Windows* Media Center Edition

REMARQUE 1 : Si le syst√®me ex√©cute une version Windows 64 bits,
	     le pilote Intel(R) Matrix Storage Manager prenant 
	     en charge 64 bits doit √™tre utilis√©.

3.  Les syst√®mes d'exploitation suivants ne sont pas pris 
    en charge :

    Toute version des syst√®mes d'exploitation Microsoft suivants :
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

    Toute version des syst√®mes d'exploitation suivants :
    - Linux
    - UNIX
    - BeOS
    - MacOS
    - OS/2

4.  Le syst√®me doit contenir au minimum la m√©moire syst√®me
    requise par le syst√®me d'exploitation.

5.  L'Utilitaire d'installation du logiciel pour les jeux de 
    composants Intel(R) doit √™tre install√© avant d'installer
    Intel(R) Matrix Storage Manager.


************************************************************
* 3.  LANGUES PRISES EN CHARGE
************************************************************

Vous trouverez ci-dessous la liste des langues (et leur 
abr√©viation) disponibles pour le logiciel Intel(R) Matrix 
Storage Manager. Le code de langue est affich√© entre 
parenth√®ses apr√®s chaque langue.

ARA -> Arabe (Arabie saoudite) 	(0401)
CHS -> Chinois (simplifi√©) 	(0804)
CHT -> Chinois (traditionnel)	(0404)
CSY -> Tch√®que 			(0405)
DAN -> Danois 			(0406)
NLD -> N√©erlandais 		(0413)
ENU -> Anglais (√âtats-Unis) 	(0409)
FIN -> Finnois 			(040B)
FRA -> Fran√ßais (international) (040C)
DEU -> Allemand 		(0407)
ELL -> Grec 			(0408)
HEB -> H√©breu 			(040D)
HUN -> Hongrois 		(040E)
ITA -> Italien			(0410)
JPN -> Japonais 		(0411)
KOR -> Cor√©en 			(0412)
NOR -> Norv√©gien 		(0414)
PLK -> Polonais 		(0415)
PTB -> Portugais (Br√©sil) 	(0416)
PTG -> Portugais (standard) 	(0816)
RUS -> Russe 			(0419)
ESP -> Espagnol 		(040A)
SVE -> Su√©dois 			(041D)
THA -> Tha√Ø 			(041E)
TRK -> Turc 			(041F)


************************************************************
* 4.  D√âTERMINATION DU MODE SYST√àME
************************************************************

Pour utiliser ce fichier Readme efficacement, vous devez
d√©terminer le mode de votre syst√®me. Le moyen le plus facile
de d√©terminer le mode consiste √† identifier la fa√ßon dont le
contr√¥leur est pr√©sent√© dans le Gestionnaire de p√©riph√©riques.
La proc√©dure suivante vous guidera pas √† pas afin de 
d√©terminer le mode.

1.  Dans le menu D√©marrer :
    1a. Sous Windows* Vista ou les syst√®mes d'exploitation 
        ult√©rieurs, s√©lectionnez Panneau de configuration.

2.  Ouvrez l'applet "Syst√®me" (vous devrez peut-√™tre 
    d'abord s√©lectionner "Basculer vers l'affichage 
    classique").

3.  S√©lectionnez l'onglet "Mat√©riel". 

4.  S√©lectionnez le bouton "Gestionnaire de p√©riph√©riques".

5.  Dans le Gestionnaire de p√©riph√©riques, recherchez une
    entr√©e intitul√©e "Contr√¥leurs de stockage" sous Windows  
    Vista et "Contr√¥leurs SCSI et RAID" sous Windows XP et 
    des syst√®mes d'exploitation ult√©rieurs. Si cette entr√©e  
    existe, d√©veloppez-la et recherchez un des contr√¥leurs
    figurant dans la pr√©sentation (section 1). Si le contr√¥leur
    identifi√© est un contr√¥leur RAID, alors le syst√®me est en
    mode RAID.
 
    Si aucun des contr√¥leurs ci-dessus n'est affich√©,
    le syst√®me n'est pas en mode RAID et vous devez
    passer √† l'√©tape 6 ci-dessous.

6.  Dans le Gestionnaire de p√©riph√©riques, recherchez une
    entr√©e "Contr√¥leurs IDE ATA/ATAPI". Si cette entr√©e  
    existe, d√©veloppez-la et recherchez un des contr√¥leurs
    figurant dans la pr√©sentation (section 1). Si le contr√¥leur
    identifi√© est un contr√¥leur AHCI, alors le syst√®me est en
    mode AHCI.

    Si aucun des contr√¥leurs ci-dessus n'est affich√©,
    le syst√®me n'est pas en mode AHCI. Aucun autre mode
    n'est pris en charge par le logiciel Intel(R) Matrix 
    Storage Manager et vous devez passer √† l'√©tape 7 
    ci-dessous.

7.  Votre syst√®me ne semble pas fonctionner en mode RAID
    ou AHCI. Si vous pensez que votre syst√®me fonctionne
    en mode RAID ou AHCI et qu'aucun des contr√¥leurs
    ci-dessus n'est pr√©sent, contactez le fabricant de
    votre syst√®me ou le lieu d'achat pour obtenir
    de l'assistance.


************************************************************
* 5.  INSTALLATION DU LOGICIEL
************************************************************

5.1 Notes d'installation

1.  Si vous installez le syst√®me d'exploitation sur un 
    syst√®me configur√© en mode RAID ou AHCI, vous devez 
    pr√©installer le pilote Intel(R) Matrix Storage Manager
    en utilisant la m√©thode d'installation F6 d√©crite dans
    la section 5.3.

2.  L'Utilitaire d'installation du logiciel pour les jeux de 
    composants Intel(R) doit √™tre install√© sur le syst√®me 
    apr√®s l'installation d'un syst√®me d'exploitation 
    Microsoft* Windows* pris en charge.

3.  Pour installer Intel(R) Matrix Storage Manager,
    cliquez sur le fichier d'installation auto-extractible 
    et √† installation automatique et suivez les invites qui 
    s'affichent.

4.  Par d√©faut, tous les fichiers install√©s (readme.txt, 
    aide, etc.) sont copi√©s √† l'emplacement suivant : 
    
    <disque de d√©marrage>\Programmes\Intel\Intel(R) 
    Matrix Storage Manager

	
5.2 Installation Windows Automated Installer* √† partir du
    disque dur ou du CD-ROM
    
REMARQUE : Cette m√©thode s'applique aux syst√®mes 
      	   configur√©s pour le mode RAID ou AHCI.

1.  T√©l√©chargez le fichier d'installation Intel(R) Matrix 
    Storage Manager et double-cliquez sur ce fichier
    pour extraire automatiquement les fichiers et lancer le
    processus d'installation.

2.  La fen√™tre de bienvenue s'affiche. Cliquez sur 
    Suivant pour continuer.

3.  La fen√™tre d'avertissement de d√©sinstallation s'affiche. 
    Cliquez sur Suivant pour continuer.

4.  La fen√™tre de l'Accord de licence du logiciel s'affiche. 
    Si vous acceptez les termes de cet accord, cliquez sur
    Oui pour continuer.

5.  La fen√™tre d'information sur le fichier Readme/Lisez-moi
    s'affiche. Cliquez sur Suivant pour continuer.

6.  La fen√™tre de s√©lection de l'emplacement de destination
    s'affiche. Cliquez sur Suivant pour continuer.

7.  La fen√™tre de s√©lection du dossier de programme s'affiche.  
    Cliquez sur Suivant pour continuer √† installer
    le pilote.

8.  Si la fen√™tre indiquant que l'assistant Windows Automated 
    Installer* est termin√© s'affiche sans vous inviter √† 
    red√©marrer le syst√®me, cliquez sur Terminer et passez √† 
    l'√©tape 8. Si une invite vous demande de red√©marrer le 
    syst√®me, cliquez sur Oui, je veux red√©marrer mon ordinateur 
    maintenant (s√©lection par d√©faut) et cliquez sur 
    Terminer. Apr√®s le red√©marrage du syst√®me, passez √† l'√©tape 8.

9.  Pour v√©rifier si le pilote est correctement charg√©,
    reportez-vous √† la section 6.


5.3 Pr√©installation en utilisant la m√©thode F6 

REMARQUE : Les √©tapes 1 et 2 peuvent √™tre ignor√©es si vous
      	   utilisez l'utilitaire de disquette F6 fourni par Intel.
           Ces m√©thodes sont applicables aux 
	   syst√®mes configur√©s pour le mode RAID ou AHCI.

1.  Extrayez tous les fichiers de pilote du package d'installation.
    Reportez-vous √† la section 7.2 pour obtenir des
    instructions sur l'extraction des fichiers.

2.  Cr√©ez une disquette* contenant les fichiers suivants dans le
    r√©pertoire racine :
    iaAhci.inf, iaAhci.cat,
    iaStor.inf, iaStor.cat,
    iaStor.sys et
    TxtSetup.oem. 

* REMARQUE : Pour Windows Vista vous pouvez utiliser une 
	     disquette, un CD/DVD ou un bus USB.

3.  Sous Windows XP ou les syst√®mes d'exploitation ult√©rieurs,

    - Au d√©but de l'installation du syst√®me d'exploitation, appuyez
      sur F6 pour installer un pilote SCSI ou RAID tiers.

    - √Ä l'invite, s√©lectionnez "S" pour sp√©cifier un p√©riph√©rique 
      suppl√©mentaire.

    - Passez √† l'√©tape 5.

4.  Sous Windows Vista :

    - Pendant l'installation du syst√®me d'exploitation, s√©lectionnez
      l'emplacement o√π vous souhaitez installer Vista, ensuite 
      cliquez sur Charger le pilote afin d'installer 
      un pilote SCSI ou RAID tiers.

    - Passez √† l'√©tape 5.

5.  √Ä l'invite, ins√©rez la disquette, CD/DVD ou USB cr√©√© lors de 
    l'√©tape 2 et appuyez sur Entr√©e.

6.  Une s√©lection devrait maintenant s'afficher, vous
    permettant de s√©lectionner un des contr√¥leurs figurant
    dans la pr√©sentation (section 1) de ce document
    en fonction de la version mat√©rielle et de la configuration.

7.  Mettez en surbrillance la s√©lection appropri√©e pour
    le mat√©riel de votre syst√®me et appuyez sur Entr√©e.

8.  Appuyez de nouveau sur Entr√©e pour continuer. 
    Laissez la disquette dans le syst√®me jusqu'au prochain
    red√©marrage car le logiciel devra √™tre √† nouveau copi√©
    de la disquette lorsque le programme d'installation
    copiera les fichiers.


************************************************************
* 6.  V√âRIFICATION DE L'INSTALLATION DU LOGICIEL
************************************************************

6.1 V√©rification des installations Disquette fournie, F6 ou 
    sans assistance. 
    En fonction de la configuration de votre syst√®me,
    reportez-vous √† la sous-rubrique appropri√©e ci-dessous :


6.1a Syst√®mes configur√©s pour le mode RAID :

1.  Dans le menu D√©marrer :
    1a. Sous Windows* XP ou les syst√®mes d'exploitation 
        ult√©rieurs, s√©lectionnez Panneau de configuration.
2.  Ouvrez l'applet "Syst√®me" (vous devrez peut-√™tre d'abord
    s√©lectionner "Basculer vers l'affichage classique").
3.  S√©lectionnez l'onglet "Mat√©riel" sous Windows* XP ou
    Windows* Server 2003.
4.  S√©lectionnez le bouton "Gestionnaire de p√©riph√©riques".
5.  D√©veloppez l'entr√©e "Contr√¥leurs de stockage" (sous Windows 
    Vista) ou "Contr√¥leurs SCSI et RAID" (sous Windows XP et 
    les syst√®mes d'exploitation ult√©rieurs).
6.  Cliquez avec le bouton droit sur "Intel(R) SATA 
    RAID Controller".
7.  S√©lectionnez "Propri√©t√©s".
8.  S√©lectionnez l'onglet "Pilote".
9.  S√©lectionnez le bouton "D√©tails du pilote".
10. Si le fichier "iaStor.sys" est affich√©, l'installation
    est r√©ussie.


6.1b Syst√®mes configur√©s pour le mode AHCI :

1.  Dans le menu D√©marrer :
    Sous Windows* XP ou les syst√®mes d'exploitation 
    ult√©rieurs, s√©lectionnez Panneau de configuration.
2.  Ouvrez l'applet "Syst√®me" (vous devrez peut-√™tre d'abord
    s√©lectionner "Basculer vers l'affichage classique").
3.  S√©lectionnez l'onglet "Mat√©riel" sous Windows* XP ou
    Windows* Server 2003.
4.  S√©lectionnez le bouton "Gestionnaire de p√©riph√©riques".
5.  D√©veloppez l'entr√©e "Contr√¥leurs IDE ATA/ATAPI".
6.  Cliquez avec le bouton droit sur "Intel(R) SATA AHCI Controller".
7.  S√©lectionnez "Propri√©t√©s".
8.  S√©lectionnez l'onglet "Pilote".
9.  S√©lectionnez le bouton "D√©tails du pilote".
10. Si le fichier "iaStor.sys" est affich√©, l'installation
    est r√©ussie.


6.2 V√©rification des installations Windows Automated 
    Installer* ou "Package pour le Web" :

1.  Cliquez sur D√©marrer.
2.  Recherchez le groupe de programmes "Intel(R) Matrix
    Storage Manager".
3.  S√©lectionnez l'entr√©e "Intel(R) Matrix Storage Console".
4.  L'application "Intel(R) Matrix Storage Console" doit
    d√©marrer.
5.  Si cette application ne d√©marre pas, le pilote
    Intel(R) Matrix Storage Manager n'est pas install√©
    correctement et le programme d'installation doit √™tre 
    ex√©cut√©. 

************************************************************
* 7.  INSTRUCTIONS D'INSTALLATION AVANC√âES
************************************************************

7.1 Indicateurs d'installation disponibles :

    -?             Le programme d'installation affiche une bo√Æte
		   de dialogue contenant tous les indicateurs 
		   d'installation pris en charge (affich√©s ici)
		   ainsi que leur utilisation.
    -A 		   Extrait tous les fichiers (n'installe pas le 
		   pilote) sous <chemin> si -P est √©galement
                   fourni ; sinon, les fichiers sont extraits 
                   vers l'emplacement par d√©faut. 
    -B 		   Force un red√©marrage du syst√®me apr√®s 
		   l'installation.
    -O <nom> 	   Permet de personnaliser le nom du dossier du 
                   programme pour Intel(R) Matrix Storage Console,
                   qui appara√Æt dans le menu D√©marrer, "Tous les 
		   programmes".
    -P <chemin>    Fournit le chemin cible lorsqu'un indicateur 
		   -A est utilis√©.
    -N 		   Installe tous les composants √† l'exception du 
		   pilote.
    -NoGUI 	   Installe uniquement le pilote ; Intel(R) Matrix 
                   Storage Console, l'Observateur des √©v√©nements et 
                   l'ic√¥ne de la barre d'√©tat syst√®me ne sont pas 
		   install√©s.
    -NoMon  	   D√©sactive l'Observateur des √©v√©nements qui est 
                   constitu√© du service de surveillance de disque
                   et de l'application de l'ic√¥ne de la barre d'√©tat 
		   syst√®me.
    -S 		   Installation en mode silencieux (aucune 
		   invite utilisateur).
    -BUILD         Affiche les informations de version.		
    -G <num√©ro> 	   Force l'installation d'une langue particuli√®re
		   (voir la section 3 pour la table de correspondance 
		   des <num√©ros> et des langues).
    -f2<chemin\nom> Cr√©√© un fichier journal sous le <chemin existant>
                   avec le <nom> ; √† utiliser durant une installation
                   en mode silencieux. Les espaces ne sont pas 
                   autoris√©s entre -f2 et <chemin\nom> et le
		   chemin doit exister avant l'installation.

REMARQUE :  Les indicateurs et leurs param√®tres ne sont pas 
	    sensibles √† la casse.
            Les indicateurs peuvent √™tre entr√©s dans n'importe
	    quel ordre, √† l'exception de -S et -G qui doivent √™tre
	    entr√©s en dernier. Si vous utilisez l'indicateur -A,
	    un chemin cible peut √™tre sp√©cifi√© via l'indicateur -P,
	    et les indicateurs -O, -G, -S et -N sont ignor√©s.
	    Lorsque vous utilisez les indicateurs -P, -O, -G et -f2,
	    aucun espace n'est autoris√© entre l'indicateur et l'argument. 
	    Lorsque vous utilisez l'indicateur -f2, un nom de fichier 
	    journal et un chemin doivent √™tre sp√©cifi√©s, et le chemin 
	    doit exister avant l'installation.

7.2 Utilisez un des exemples de commande suivants pour
    extraire les fichiers de pilote des diff√©rents types 
    de package :

      c:\iata_cd.exe -a -a -pc:\<chemin>
      c:\iata_enu.exe -a -a -pc:\<chemin>
      c:\setup.exe -a -pc:\<chemin>

    L'ex√©cution de ces commandes lance le processus 
    d'installation ; cliquez simplement dans les bo√Ætes de 
    dialogue lorsque vous y √™tes invit√©.
    Cette op√©ration n'installe pas le pilote ; elle ne fait 
    qu'extraire les fichiers du pilote dans <chemin>. 
    Lorsque l'extraction est termin√©e, les fichiers du pilote 
    sont disponibles sous <chemin>\Driver.

7.3 Pour installer le pilote RAID sous Windows* XP, comme d√©crit
    dans le document Microsoft "Deployment Guide Automating
    Windows NT Setup", utilisez le fichier TXTSETUP.OEM inclus 
    dans ce package et ins√©rez les lignes comme indiqu√© dans les
    √©tapes 7.3a et 7.3b dans le fichier UNATTEND.TXT. 
    Cette m√©thode est disponible pour Microsoft* Windows* XP,
    Windows 2000 et Windows Server 2003. Avant de commencer,
    les fichiers iaAhci.inf, iaAhci.cat, iaStor.inf, iaStor.cat,
    iaStor.sys et Txtsetup.oem doivent √™tre extraits des fichiers
    d'installation. Pour extraire ces fichiers, utilisez la
    m√©thode d√©crite dans la section 7.2 ci-dessus.

7.3a Syst√®mes configur√©s pour le mode RAID :
    REMARQUE : Un exemple est montr√© ci-dessous. En fonction de
    votre version mat√©rielle, veuillez mettre le texte √† jour avec
    le nom exact du contr√¥leur RAID en utilisant la liste dans
    la pr√©sentation (section 1) de ce document.

    // Ins√©rez les lignes suivantes dans le fichier UNATTEND.TXT
  
    [MassStorageDrivers]
    "Intel(R) 82801IR/IO SATA RAID Controller" = OEM
 
    [OEMBootFiles]
    iaStor.inf
    iaStor.sys
    iaStor.cat
    Txtsetup.oem


7.3b Syst√®mes configur√©s pour le mode AHCI :

    REMARQUE : Un exemple est montr√© ci-dessous. En fonction de
    votre version mat√©rielle, veuillez mettre le texte √† jour avec
    le nom exact du contr√¥leur AHCI en utilisant la liste dans
    la pr√©sentation (section 1) de ce document.

    // Ins√©rez les lignes suivantes dans le fichier UNATTEND.TXT

    [MassStorageDrivers]
    "Intel(R) 82801IR/IO SATA AHCI Controller" = OEM
 
    [OEMBootFiles]
    iaAhci.inf
    iaStor.sys
    iaAhci.cat
    Txtsetup.oem


************************************************************
* 8.  IDENTIFICATION DU NUM√âRO DE VERSION DU LOGICIEL
************************************************************

8.1 Suivez les √©tapes ci-dessous pour identifier le num√©ro
    de version du logiciel √† la suite d'une installation
    Disquette fournie, F6 ou sans assistance.


8.1a Syst√®mes configur√©s pour le mode RAID :

1.  Dans le menu D√©marrer :
    1a. Sous Windows* XP ou les syst√®mes d'exploitation 
        ult√©rieurs, s√©lectionnez Panneau de configuration.
2.  Ouvrez l'applet "Syst√®me" (vous devrez peut-√™tre d'abord
    s√©lectionner "Basculer vers l'affichage classique").
3.  S√©lectionnez l'onglet "Mat√©riel" sous Windows* XP ou
    Windows* Server 2003.
4.  S√©lectionnez le bouton "Gestionnaire de p√©riph√©riques".
5.  D√©veloppez l'entr√©e "Contr√¥leurs SCSI et RAID".
6.  Cliquez avec le bouton droit sur "Intel(R) RAID Controller".
7.  S√©lectionnez "Propri√©t√©s".
8.  S√©lectionnez l'onglet "Pilote".
9.  La version du logiciel est affich√©e apr√®s
    "Version du pilote".


8.1b Syst√®mes configur√©s pour le mode AHCI :

1.  Dans le menu D√©marrer :
    1a. Sous Windows* XP ou les syst√®mes d'exploitation 
        ult√©rieurs, s√©lectionnez Panneau de configuration.
2.  Ouvrez l'applet "Syst√®me" (vous devrez peut-√™tre d'abord
    s√©lectionner "Basculer vers l'affichage classique").
3.  S√©lectionnez l'onglet "Mat√©riel" sous Windows* XP ou
    Windows* Server 2003.
4.  S√©lectionnez le bouton "Gestionnaire de p√©riph√©riques".
5.  D√©veloppez l'entr√©e "Contr√¥leurs IDE ATA/ATAPI".
6.  Cliquez avec le bouton droit sur "Intel(R) SATA AHCI Controller".
7.  S√©lectionnez "Propri√©t√©s".
8.  S√©lectionnez l'onglet "Pilote".
9.  La version du logiciel est affich√©e apr√®s
    "Version du pilote".


8.2 Identifiez la version du logiciel pour les installations
    Windows Automated Installer* ou "Package pour le Web" :

1.  Cliquez sur D√©marrer, puis sur Tous les programmes.
2.  Recherchez le groupe de programmes "Intel(R) Matrix
    Storage Manager".
3.  S√©lectionnez l'√©l√©ment "Intel(R) Matrix Storage Console".
4.  L'application "Intel(R) Matrix Storage Console" d√©marre,
    en affichant la version sur l'√©cran de d√©marrage. 
    La version peut √©galement √™tre affich√©e en s√©lectionnant
    "√Ä propos de" dans le menu "Aide".


************************************************************
* 9.  D√âSINSTALLATION DU LOGICIEL
************************************************************

9a. D√âSINSTALLATION DES COMPOSANTS NON-PILOTE
Si vous supprimez ce logiciel du syst√®me, tous les disques
durs Serial ATA seront inaccessibles au syst√®me  
d'exploitation. Par cons√©quent, la d√©sinstallation sera 
seulement pour les composants moins essentiels de ce logiciel
(l'interface utilisateur, liens dans le menu D√©marrer, etc.). 
Pour d√©sinstaller les composants essentiels, reportez-vous √† 
la section 9b. 

Utilisez la proc√©dure suivante pour d√©sinstaller le logiciel :

1. S√©lectionnez "D√©sinstaller" dans le dossier du menu 
   D√©marrer suivant :

   * Tous les programmes -> Intel(R) Matrix Storage Manager

2. Le programme de d√©sinstallation d√©marre. Cliquez sur les
   options appropri√©es pour d√©terminer la d√©sinstallation.

9b. D√âSINSTALLATION DES COMPOSANTS PILOTE
Si vous supprimez ce logiciel du syst√®me, tous les disques
durs Serial ATA seront inaccessibles au syst√®me d'exploitation.
Par cons√©quent, il est conseill√© de faire une copie de 
sauvegarde de vos donn√©es avant d'ex√©cuter cette √©tape.
 
1) Si le syst√®me se trouve en mode RAID, supprimez les volumes
RAID, avec l'interface utilisateur d'Intel(R) Matrix
Storage Manager option ROM.
2) Red√©marrez le syst√®me.
3) Entrez dans le BIOS du syst√®me (en appuyant sur "F2" ou
"Supprimer" pendant le d√©marrage du syst√®me).
4) D√©sactivez "Intel(R) RAID Technology" et "SATA AHCI mode".
5) R√©installez le syst√®me d'exploitation.
 
REMARQUE : Si vous √©prouvez des difficult√©s √† modifier le BIOS
du syst√®me, contactez le fabricant de la carte m√®re pour 
obtenir de l'aide.
 
************************************************************
* 10.  OUVERTURE DE l'INTERFACE UTILISATEUR OPTION ROM
************************************************************

Suivez les √©tapes ci-dessous pour ouvrir l'interface 
utilisateur d'Intel(R) Matrix Storage Manager option ROM :

1. D√©marrez le syst√®me.
2. Appuyez sur CTRL-I lorsque l'√©cran d'√©tat
   "Intel(R) Matrix Storage Manager option 
   ROM vX.y.w.zzzz" s'affiche.

************************************************************
* 11.  GESTION DES VOLUMES RAID DANS L'OPTION ROM
************************************************************
Le composant Intel(R) Matrix Storage Manager option ROM 
permet de g√©rer les volumes RAID avant d'installer le syst√®me 
d'exploitation. L'interface utilisateur offre les options 
de gestion des volumes RAID suivantes :

1. Create RAID Volume (Cr√©er un volume RAID)
   Utilisez cette option pour cr√©er un ou deux 
   volumes RAID. 

2. Delete RAID Volume (Supprimer un volume RAID)
   Utilisez cette option pour supprimer un volume RAID.

3. Reset Disks to Non-RAID (R√©initialiser les disques durs sur Non RAID)
   Utilisez cette option pour r√©initialiser une
   configuration RAID avec une configuration non RAID.

4. Recovery Volume Options (Options du volume de reprise)
   Si le syst√®me comporte un volume de reprise, utilisez 
   cette option pour :
        a. Disable Continuous Update (D√©sactiver la mise √† jour continue)
        b. Enable Only Recovery Disk (D√©marrer sur un disque de reprise)
        c. Enable Only Master Disk (D√©marrer sur un disque ma√Ætre)

************************************************************
* 12.  OPTIONS DE R√âINITIALISATION DU VOLUME RAID DANS L'OPTION ROM
************************************************************
L'interface utilisateur d'Intel(R) Matrix Storage option ROM 
propose deux m√©thodes pour r√©initialiser les volumes RAID :
1. Delete RAID Volume (Supprimer un volume RAID)
2. Reset Disks to Non-RAID (R√©initialiser les disques durs sur Non RAID)
   Les diff√©rences entre les options sont not√©es ci-dessous. 
   Les utilisateurs sont conseill√©s de choisir l'option en
   fonction de la situation.

12.1 Suppression d'un volume RAID

     Quand un volume RAID est supprim√©, les m√©tadonn√©es sur le
     disque sont effac√©es et le secteur z√©ro est supprim√©, ce
     qui signifie que les donn√©es de la table de partition et du
     syst√®me de fichiers sont effac√©es. L'installateur de Windows 
     ne trouvera aucune donn√©e inadmissible pendant 
     l'installation du syst√®me d'exploitation. C'est la m√©thode 
     recommand√©e pour modifier le volume RAID et installer le
     syst√®me d'exploitation.

12.2 R√©initialisation du disque sur Non RAID

     Cette option est employ√©e pour r√©initialiser les m√©tadonn√©es
     sur le disque qui participe √† plus d'un volume RAID dans une 
     seule op√©ration. Il devrait √™tre employ√© si l'option
     "Effacer le volume RAID'" √©choue pour une raison ou une autre
     et pour r√©initialiser un disque qui a √©t√© marqu√© Disponible et 
     en diff√©r√©. Quand un disque en volume RAID est r√©initialis√©
     comme non-RAID, les m√©tadonn√©es RAID sont effac√©es. 
     Cependant, les donn√©es de la table de partition et du syst√®me 
     de fichiers existent toujours, ce qui peut √™tre inadmissible. 
     L'installateur de Windows pourrait mal interpr√©ter l'information
     disponible sur le "disque de r√©installation" au moment de 
     l'installation. Ceci peut avoir comme cons√©quence un comportement 
     inattendu dans l'installation du syst√®me d'exploitation.

************************************************************
* 13.  V√âRIFICATION DE LA VERSION DU LOGICIEL OPTION ROM
************************************************************

1. Suivez les √©tapes ci-dessous pour identifier le num√©ro de
   version de l'interface utilisateur RAID option ROM :

   - Ouvrez l'interface utilisateur RAID option ROM en
     suivant les √©tapes d√©crites dans la section 10.
   - La version du logiciel sera affich√©e dans la banni√®re 
     de l'interface utilisateur :
     "Intel(R) Matrix Storage Manager option ROM vX.y.w.zzzz".

     "X.y.w.zzzz" - correspond au num√©ro de version de 
     l'interface utilisateur d'Intel(R) Matrix Storage option ROM
     install√©e sur votre syst√®me :
     "X.y.w" - Num√©ro de lancement du produit
     "X" - Num√©ro majeur
     "y" - Num√©ro mineur
     "w" - Num√©ro de correction √† chaud
     "zzzz" - Num√©ro de compilation

************************************************************
* AVIS DE NON-RESPONSABILIT√â
************************************************************

Les informations de ce document sont fournies en relation
avec les produits Intel. Sauf disposition express√©ment
stipul√©e dans le CONTRAT DE LICENCE DU LOGICIEL INTEL
contenu dans ce document, aucune licence n'est accord√©e, 
express√©ment ou implicitement, par estoppel ou autre,
sur un droit de propri√©t√© intellectuelle quel qu'il soit.
Sauf disposition express√©ment stipul√©e par Intel dans les 
Modalit√©s et conditions de vente de ces produits, Intel
d√©cline toute responsabilit√© quelle qu'elle soit et exclut
toute garantie expresse ou implicite relative √† la vente
et/ou √† l'utilisation de produits Intel, y compris toute
responsabilit√© ou garantie relative √† l'adaptation √† un
usage particulier, √† la qualit√© marchande ou au respect
d'un brevet, d'un droit d'auteur ou de tout autre droit 
de propri√©t√© intellectuelle. Les produits Intel ne sont pas 
con√ßus pour √™tre utilis√©s dans des applications m√©dicales, 
de secours ou de r√©animation.

************************************************************
* Intel Corporation exclut toutes garanties et
* responsabilit√©s relatives √† l'utilisation de ce document,
* au logiciel et aux informations contenues dans ce
* document, et d√©cline toute responsabilit√© dans le cas
* o√π des erreurs appara√Ætraient dans ce document ou dans le
* logiciel, et Intel ne s'engage aucunement √† mettre √† jour 
* les informations ou le logiciel contenu dans ce document.
* Intel se r√©serve le droit de modifier le pr√©sent document
* ou le logiciel √† tout moment et sans pr√©avis.
************************************************************

* D'autres noms et marques peuvent appartenir √† leurs
  propri√©taires respectifs.

Copyright (c) Intel Corporation, 2001-2008
************************************************************
* CONTRAT DE LICENCE DU LOGICIEL INTEL
************************************************************
ACCORD DE LICENCE DU LOGICIEL INTEL (distribution OEM /IHV/ ISV et mono-utilisateur)

IMPORTANT - ¿ LIRE AVANT DE COPIER, D'INSTALLER OU D'UTILISER LE LOGICIEL
Lisez attentivement les termes et conditions du prÈsent contrat de licence avant d'utiliser ou de charger le prÈsent logiciel et tout le matÈriel associÈ (appelÈs collectivement le "logiciel"). L'utilisation ou le chargement du logiciel constitue une acceptation des termes du prÈsent contrat. En cas de refus de ces termes, n'installez pas le logiciel et ne l'utilisez pas.

Autre remarque importante :
* Si vous Ítes fabricant de matÈriel d'origine (OEM), fournisseur de matÈriel indÈpendant (IHV) ou fournisseur de logiciel indÈpendant (ISV), l'ensemble du prÈsent CONTRAT DE LICENCE s'applique.
* Si vous Ítes utilisateur final, seul le document A, ACCORD DE LICENCE DU LOGICIEL INTEL, s'applique.

Pour OEM, IHV et ISV:

LICENCE. La licence de ce logiciel est accordÈe pour une utilisation exclusive de ce dernier avec des composants Intel. L'utilisation de ce logiciel avec des composants n'appartenant pas ‡ Intel n'est pas couverte par la prÈsente licence. Sous rÈserve des modalitÈs de cet accord, Intel vous concËde une licence non exclusive, incessible, valide dans le monde entier et entiËrement payÈe vous autorisant ‡:
	a) utiliser, modifier et copier le logiciel en interne, ‡ vos propres fins de dÈveloppement et de maintenance ;
	b) modifier, copier et distribuer le logiciel, y compris les travaux qui en sont dÈrivÈs, ‡ vos utilisateurs finals, mais uniquement en vertu d'un accord de licence dont les modalitÈs sont au moins aussi restrictives que celles de l'accord de licence de l'utilisateur final Intel, ci-joint ‡ titre de document A ; et
	c) modifier, copier et distribuer la documentation de l'utilisateur final qui peut accompagner le logiciel, mais uniquement avec le logiciel.

Si vous n'Ítes pas le fabricant ou fournisseur final d'un systËme informatique ou d'un programme intÈgrant le logiciel, vous pouvez transfÈrer une copie du logiciel, y compris les travaux qui en sont dÈrivÈs (et la documentation connexe de l'utilisateur final), ‡ une tierce partie qui pourra l'utiliser conformÈment aux modalitÈs du prÈsent accord, ‡ condition qu'elle accepte pleinement d'Ítre liÈe par celles-ci. Sauf dans le cas prÈsentÈ prÈcÈdemment, vous n'Ítes pas habilitÈ ‡ cÈder, concÈder en vertu d'une sous-licence, louer, transfÈrer ni divulguer le logiciel ‡ un tiers quelconque. Vous ne pouvez pas dÈcompiler, ou dÈsassembler le logiciel ou le soumettre ‡ un processus d'ingÈnierie ‡ rebours.

Sauf mention expresse dans le prÈsent accord, aucun droit ni licence ne vous est accordÈ de maniËre directe ou tacite, par incitation, par forclusion ou autrement. Intel se rÈserve le droit d'inspecter ou de faire inspecter par un vÈrificateur indÈpendant tous vos dossiers pertinents afin de vÈrifier si vous respectez les modalitÈs et conditions du prÈsent accord.

CONFIDENTIALIT…. Si vous dÈsirez qu'un conseiller ou sous-traitant tiers (ci-aprËs dÈnommÈ "entrepreneur") exÈcute pour vous des travaux nÈcessitant l'utilisation du logiciel ou l'accËs ‡ ce dernier, vous devez obtenir de l'entrepreneur une convention Ècrite de confidentialitÈ dont les modalitÈs et les obligations relatives ‡ l'accËs au logiciel et ‡ son utilisation sont au moins aussi restrictives que celles du prÈsent accord, et qui excluent tout droit de distribution et d'utilisation ‡ d'autres fins.
Par ailleurs, vous n'Ítes pas habilitÈ ‡ divulguer les modalitÈs ou l'existence de cet accord ni ‡ utiliser le nom Intel dans des publications, des publicitÈs ou d'autres annonces sans obtenir l'autorisation Ècrite prÈalable d'Intel. Vous ne pouvez pas utiliser les marques commerciales d'Intel.

PROPRI…T… DU LOGICIEL ET DROITS D'AUTEUR. Les droits sur toutes les copies du logiciel demeurent la propriÈtÈ d'Intel ou de ses fournisseurs. Le logiciel est soumis ‡ droits d'auteur et protÈgÈ par les lois des …tats-Unis et d'autres pays ainsi que par les dispositions de traitÈs internationaux. Vous n'Ítes pas autorisÈ ‡ Ùter les mentions de droit d'auteur du logiciel. Intel peut modifier, ‡ tout moment et sans prÈavis, le logiciel ou les ÈlÈments qui y sont mentionnÈs, mais n'est pas tenu ‡ des services d'assistance relatifs au logiciel ou ‡ la mise ‡ jour de ce dernier. Sauf stipulation contraire expresse, Intel n'accorde aucun droit exprËs ou tacite en vertu des brevets, droits d'auteur, marques commerciales ou autres droits de propriÈtÈ intellectuelle d'Intel. Vous ne pouvez transfÈrer le logiciel que si le destinataire convient d'Ítre entiËrement liÈ par les dispositions du prÈsent accord et si vous ne conservez aucune copie du logiciel.

GARANTIE LIMIT…E DES SUPPORTS. Si le logiciel a ÈtÈ livrÈ par Intel sur des supports physiques, Intel garantit que ces derniers sont exempts de vices matÈriels pendant une pÈriode de quatre-vingt-dix (90) jours ‡ compter de la date de livraison par Intel. En cas de dÈfaut de support, vous Ítes invitÈ ‡ renvoyer ce dernier ‡ Intel pour un remplacement ou une autre livraison du logiciel, ‡ la discrÈtion d'Intel.

EXCLUSION DES AUTRES GARANTIES. ¿ L'EXCEPTION DES GARANTIES QUI PR…C»DENT, LE LOGICIEL EST FOURNI "EN L'…TAT", SANS GARANTIE EXPRESSE OU TACITE DE QUELQUE NATURE QUE CE SOIT, Y COMPRIS LES GARANTIES CONCERNANT LA VALEUR MARCHANDE, L'ABSENCE DE CONTREFA«ON OU L'AD…QUATION ¿ UN USAGE PARTICULIER. Intel ne garantit pas l'exactitude ni l'exhaustivitÈ des informations, textes, graphiques, liens et autres ÈlÈments intÈgrÈs ‡ ce logiciel et n'assume aucune responsabilitÈ ‡ cet Ègard.

LIMITATION DE LA RESPONSABILIT…. INTEL OU SES FOURNISSEURS NE SONT EN AUCUN CAS RESPONSABLES DE QUELQUE DOMMAGE QUE CE SOIT (Y COMPRIS, MAIS SANS QUE CETTE …NUM…RATION SOIT LIMITATIVE, LES PERTES DE B…N…FICES, LES INTERRUPTIONS D'ACTIVIT…S OU LES PERTES D'INFORMATIONS) D…RIVANT DE L'UTILISATION DE CE PRODUIT OU DE L'INCAPACIT… DE L'UTILISER, M ME SI INTEL A …T… NOTIFI… DE LA POSSIBILIT… D'UN TEL DOMMAGE. CERTAINS RESSORTS INTERDISENT L'EXCLUSION OU LA LIMITATION DE LA RESPONSABILIT… POUR LES GARANTIES TACITES OU LES DOMMAGES INDIRECTS OU ACCESSOIRES. IL SE PEUT PAR CONS…QUENT QUE LES LIMITATIONS SUSMENTIONN…ES NE S'APPLIQUENT PAS DANS VOTRE CAS. LES AUTRES DROITS DONT VOUS JOUISSEZ PEUVENT VARIER D'UN RESSORT ¿ L'AUTRE.

R…SILIATION DU PR…SENT ACCORD. Intel peut dÈnoncer le prÈsent accord ‡ tout moment en cas de violation des dispositions qu'il contient. Le cas ÈchÈant, vous Ítes tenu de procÈder ‡ la destruction immÈdiate du logiciel ou d'en renvoyer tous les exemplaires ‡ Intel.
 
DROIT APPLICABLE. Les litiges nÈs du prÈsent accord sont rÈgis par les lois de l'…tat de Californie, sans tenir compte des principes de conflit de lois et de la Convention des Nations Unies sur les accords de vente de marchandises. Vous ne pouvez pas exporter le logiciel en contravention des lois et rËglements en vigueur sur l'exportation. Intel n'est liÈ par aucun autre accord, ‡ moins que ce dernier soit sous forme Ècrite et signÈ par un reprÈsentant agrÈÈ d'Intel.

LIMITATION DES DROITS DU GOUVERNEMENT. Le logiciel est fourni avec des "DROITS LIMIT…S". L'utilisation, la reproduction ou la publication par le gouvernement est soumise aux restrictions dÈfinies dans les articles FAR52.227-14 et DFAR252.227-7013 et suivants, ou leurs successeurs. L'utilisation du logiciel par le gouvernement constitue une reconnaissance des droits de propriÈtÈ y affÈrents d'Intel. L'entrepreneur ou le fabricant est Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95052, USA.


DOCUMENT A

ACCORD DE LICENCE DU LOGICIEL INTEL (version finale, mono-utilisateur)

IMPORTANT - ¿ LIRE AVANT DE COPIER, D'INSTALLER OU D'UTILISER LE LOGICIEL
Lisez attentivement les termes et conditions du prÈsent accord de licence avant d'utiliser ou de charger le prÈsent logiciel et tout le matÈriel associÈ (appelÈs collectivement le "logiciel"). L'utilisation ou le chargement du logiciel constitue une acceptation des termes du prÈsent accord. En cas de refus de ces termes, n'installez pas le logiciel et ne l'utilisez pas.

LICENCE. Vous pouvez copier le logiciel sur un seul ordinateur pour une utilisation personnelle et non commerciale et en effectuer une copie de sauvegarde, sous rÈserve des conditions suivantes :

1. La licence de ce logiciel est accordÈe pour une utilisation exclusive de ce dernier avec des composants Intel. L'utilisation de ce logiciel avec des composants n'appartenant pas ‡ Intel n'est pas couverte par la prÈsente licence.
2. Vous ne pouvez pas copier, modifier, louer, vendre, distribuer ou transfÈrer aucune partie du logiciel, sauf tel qu'il est stipulÈ aux prÈsentes, et vous vous engagez ‡ empÍcher toute reproduction non autorisÈe du logiciel.
3. Vous ne pouvez pas dÈcompiler ni dÈsassembler le logiciel. 
4. Vous ne pouvez pas concÈder le logiciel en vertu d'une sous-licence ni en autoriser l'utilisation simultanÈe par plusieurs utilisateurs.
5. Le logiciel peut contenir des programmes et autres ÈlÈments qui sont la propriÈtÈ de tiers fournisseurs, dont certains peuvent Ítre identifiÈs dans un fichier "license.txt" ou d'autres textes ou fichiers inclus et concÈdÈs sous licence en vertu de ceux-ci.

PROPRI…T… DU LOGICIEL ET DROITS D'AUTEUR. Les droits sur toutes les copies du logiciel demeurent la propriÈtÈ d'Intel ou de ses fournisseurs. Le logiciel est soumis ‡ droits d'auteur et protÈgÈ par les lois des …tats-Unis et d'autres pays ainsi que par les dispositions de traitÈs internationaux. Vous n'Ítes pas autorisÈ ‡ Ùter les mentions de droit d'auteur du logiciel. Intel peut modifier, ‡ tout moment et sans prÈavis, le logiciel ou les ÈlÈments qui y sont mentionnÈs, mais n'est pas tenu ‡ des services d'assistance relatifs au logiciel ou ‡ la mise ‡ jour de ce dernier. Sauf stipulation contraire expresse, Intel n'accorde aucun droit exprËs ou tacite en vertu des brevets, droits d'auteur, marques commerciales ou autres droits de propriÈtÈ intellectuelle d'Intel. Vous ne pouvez transfÈrer le logiciel que si le destinataire convient d'Ítre entiËrement liÈ par les dispositions du prÈsent accord et si vous ne conservez aucune copie du logiciel.

GARANTIE LIMIT…E DES SUPPORTS. Si le logiciel a ÈtÈ livrÈ par Intel sur des supports physiques, Intel garantit que ces supports sont exempts de vices matÈriels pendant une pÈriode de quatre-vingt-dix (90) jours ‡ compter de la date de livraison par Intel. En cas de dÈfaut de support, vous Ítes invitÈ ‡ renvoyer ce dernier ‡ Intel pour un remplacement ou une autre livraison du logiciel, ‡ la discrÈtion d'Intel.

EXCLUSION DES AUTRES GARANTIES. ¿ L'EXCEPTION DES GARANTIES QUI PR…C»DENT, LE LOGICIEL EST FOURNI "EN L'…TAT", SANS GARANTIE EXPRESSE OU TACITE DE QUELQUE NATURE QUE CE SOIT, Y COMPRIS LES GARANTIES CONCERNANT LA VALEUR MARCHANDE, L'ABSENCE DE CONTREFA«ON OU L'AD…QUATION ¿ UN USAGE PARTICULIER. Intel ne garantit pas ni l'exactitude ni l'exhaustivitÈ des informations, textes, graphiques, liaisons et autres ÈlÈments intÈgrÈs ‡ ce logiciel et n'assume aucune responsabilitÈ ‡ cet Ègard.

LIMITATION DE LA RESPONSABILIT…. INTEL OU SES FOURNISSEURS NE SONT EN AUCUN CAS RESPONSABLES DE QUELQUE DOMMAGE QUE CE SOIT (Y COMPRIS, MAIS SANS QUE CETTE …NUM…RATION SOIT LIMITATIVE, LES PERTES DE B…N…FICE, LES INTERRUPTIONS D'ACTIVIT…S OU LES PERTES D'INFORMATIONS) D…RIVANT DE L'UTILISATION DE CE PRODUIT OU DE L'INCAPACIT… DE L'UTILISER, M ME SI INTEL A …T… NOTIFI… DE LA POSSIBILIT… D'UN TEL DOMMAGE. CERTAINS RESSORTS INTERDISENT L'EXCLUSION OU LA LIMITATION DE LA RESPONSABILIT… POUR LES GARANTIES TACITES OU DES DOMMAGES INDIRECTS OU ACCESSOIRES. IL SE PEUT PAR CONS…QUENT QUE LES LIMITATIONS SUSMENTIONN…ES NE S'APPLIQUENT PAS DANS VOTRE CAS. LES AUTRES DROITS L…GAUX DONT VOUS JOUISSEZ PEUVENT VARIER D'UN RESSORT ¿ L'AUTRE.

R…SILIATION DU PR…SENT ACCORD. Intel peut dÈnoncer le prÈsent accord ‡ tout moment en cas de violation des dispositions qu'il contient. Le cas ÈchÈant, vous Ítes tenu de procÈder ‡ la destruction immÈdiate du logiciel ou d'en renvoyer tous les exemplaires ‡ Intel.
 
DROIT APPLICABLE. Les litiges nÈs du prÈsent accord sont rÈgis par les lois de l'…tat de Californie, sans tenir compte des principes de conflit de lois et de la Convention des Nations Unies sur les accords de vente de marchandises. Vous ne pouvez pas exporter le logiciel en contravention des lois et rËglements en vigueur sur l'exportation. Intel n'est liÈ par aucun autre accord, ‡ moins que ce dernier soit sous forme Ècrite et signÈ par un reprÈsentant agrÈÈ d'Intel.

LIMITATION DES DROITS DU GOUVERNEMENT. Le logiciel est fourni avec des "DROITS LIMIT…S". L'utilisation, la reproduction ou la publication par le gouvernement est soumise aux restrictions dÈfinies dans les articles FAR52.227-14 et DFAR252.227-7013 et suivants, ou leurs successeurs. L'utilisation du logiciel par le gouvernement constitue une reconnaissance des droits de propriÈtÈ y affÈrents d'Intel. L'entrepreneur ou fabricant est Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95052, USA.
SLAOEMISV1/RBK/01-21-22

LANGUE ; TRADUCTIONS.  Au cas o˘ la version anglaise du prÈsent Accord est accompagnÈe d'une version traduite dans une autre langue, la version traduite est fournie ‡ titre d'information uniquement et la version anglaise constituera la version de rÈfÈrence.



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



************************************************************
************************************************************
*  Intel(R) Matrix Storage Manager インストールの Readme
*
*  Intel(R) Matrix Storage Manager 対応オペレーティング システムのシステム要件を
*  参照してください。
*
*  本書はインテルによって開発された製品について説明します。これらの製品の使い方および他者に開示できる
*  情報に関して、制限事項がいくつかあります。詳細については、本書の免責条項をお読みになるか、インテル
*  のフィールドサービス担当者にお問い合わせください。
*
************************************************************
************************************************************

************************************************************
*  インテルはユーザビリティ、有効性、保証に関して何ら責任を負うものではありません。本書に記載されている　
*  インテル ソフトウェア使用許諾契約は、このソフトウェアの使用許諾と使用について完全に規定しています。
************************************************************


************************************************************
*  本書の内容
************************************************************

本書には以下のセクションがあります。

1.  概要
2.  システム要件
3.  言語サポート
4.  システムモードの判定
5.  ソフトウェアのインストール
6.  ソフトウェアのインストールの確認
7.  詳細インストール手順
8.  ソフトウェア バージョン番号の識別
9.  ソフトウェアのアンインストール
10. Option ROM のユーザー インターフェイスの使用
11. Option ROM の RAID ボリューム管理
12. Option ROM で RAID ボリュームをリセットするオプション
13. Option ROM ソフトウェアのバージョンの確認   


************************************************************
* 1.  概要
************************************************************

Intel(R) Matrix Storage Manager は、以下のストレージ コントローラの機能を提供する
設計となっています。

    RAID コントローラ:
    - Intel(R) ICH8M-E/ICH9M-E SATA RAID Controller    
    - Intel(R) ICH8R/ICH9R/ICH10R/DO SATA RAID Controller   
    - Intel(R) ESB2 SATA RAID Controller  
    - Intel(R) ICH7MDH SATA RAID Controller
    - Intel(R) ICH7R/DH SATA RAID Controller   
       
    AHCI コントローラ:
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
* 2.  システム要件
************************************************************

1.  システムには、インテル(R) Core(TM)2 Duo プロセッサー、インテル(R) Core(TM)2 
    Extreme プロセッサー、インテル(R) Pentium(R) プロセッサー、またはインテル(R) 
    Xeon(R) プロセッサーと上記のセッション 1 に記載されているインテル製品が搭載されていることが
    必要です。    

2.  システムは以下のオペレーティング システムのいずれかを実行している必要があります。
    - Microsoft* Vista*
    - Microsoft* Vista* x64 Edition (注 1)    
    - Microsoft* Windows* Server 2008
    - Microsoft* Windows* Server 2008 x64 Edition (注 1)
    - Microsoft* Windows* XP Home Edition
    - Microsoft* Windows* XP Professional
    - Microsoft* Windows* XP x64 Edition (注 1)
    - Microsoft* Windows* Server 2003
    - Microsoft* Windows* Server 2003, 
      Web x64 Edition (注 1)
    - Microsoft* Windows* Server 2003, 
      Standard x64 Edition (注 1)
    - Microsoft* Windows* Server 2003, 
      Enterprise x64 Edition (注 1)
    - Microsoft* Windows* Media Center Edition

注 1: システムが Windows* 64 ビット バージョンを実行している場合は、64 ビット対応の 
     Intel(R) Matrix Storage Manager ドライバを使用してください。

3.  以下のオペレーティング システムには対応していません。

    以下の Microsoft オペレーティング システムのすべてのバージョン
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

    以下のオペレーティング システムのすべてのバージョン
    - Linux
    - UNIX
    - BeOS
    - MacOS
    - OS/2

4.  システムには、オペレーティング システムで最小限必要なメモリー容量が必要です。

5.  Intel(R) Matrix Storage Manager をインストールする前に Intel(R) 
    チップセット・ソフトウェア・インストール・ユーティリティをインストールする必要があります。


************************************************************
* 3.  言語サポート
************************************************************

以下に、Intel(R) Matrix Storage Manager ソフトウェアがローカライズされている言語（と
その略語）を掲載します。言語コードが各言語の後に括弧で囲んで示されています。

ARA -> アラビア語 （サウジアラビア）	(0401)
CHS -> 中国語 （簡体字）	(0804)
CHT -> 中国語 （繁体字）	(0404)
CSY -> チェコ語		(0405)
DAN -> デンマーク語    	(0406)
NLD -> オランダ語      	(0413)
ENU -> 英語 （米国）    	(0409)
FIN -> フィンランド語     	(040B)
FRA -> フランス語 （国際）  	(040C)
DEU -> ドイツ語		(0407)
ELL -> ギリシア語		(0408)
HEB -> ヘブライ語		(040D)
HUN -> ハンガリア語		(040E)
ITA -> イタリア語		(0410)
JPN -> 日本語		(0411)
KOR -> 韓国語		(0412)
NOR -> ノルウェー語		(0414)
PLK -> ポーランド語		(0415)
PTB -> ポルトガル語 （ブラジル）	(0416)
PTB -> ポルトガル語 （標準）	(0816)
RUS -> ロシア語		(0419)
ESP -> スペイン語		(0C0A)
SVE -> スウェーデン語		(041D)
THA -> タイ語		(041E)
TRK -> トルコ語		(041F)


************************************************************
* 4.  システム モードの判定
************************************************************

この Readme を効果的に使用するためには、システムがどのモードになっているかを知る必要があります。システ
ムのモードを判定する最も簡単な方法は、デバイス　マネージャでのシリアル ATA コントローラの表示を見る方法
です。モードの判定は、以下の手順で行います。

1.  [スタート] メニューで：
    1a.Windows* Vista 以降のオペレーティング システムでは、コントロール パネルを選択します。

2.  [システム] を開きます（まず [クラシック表示に切り替える] を選択）。

3.  [ハードウェア] タブを選択します。 

4.  [デバイス マネージャ] ボタンを選択します。

5.  デバイス マネージャで、Windows Vista では　[ストレージ コントローラ] を、Windows 
    XP 以降では [SCSI と RAID コントローラ] を開きます。このエントリがある場合は、展開して
    セクション 1 概要にリストされているコントローラを見つけます。見つけられたコントローラが　RAID　
    コントローラの場合、システムは RAID　モードです。
    
    いずれの　RAID　コントローラも表示されていない場合は、RAID モードで実行されていないのでステッ
    プ 6 に進んでください。

6.  デバイス マネージャで　「IDE ATA/ATAPI controllers」　というエントリを探します。この
    エントリがある場合は、展開してセクション 1　概要にリストされている　AHCI コントローラを見つけます。
    見つけられたコントローラが　AHCI　コントローラの場合、システムは　AHCI　モードです。
    
    いずれの　AHCI　コントローラも表示されていない場合、システムは AHCI モードでもありません。 
    Intel(R) Matrix Storage Manager ソフトウェアではその他のモードはサポート
    されていないので、次のステップ 7 に進んでください。

7.  システムは RAID モードでも AHCI モードでもないようです。
    システムが RAID モードまたは AHCI モードであると思われるのに上記のコントローラが表示されて
    いない場合は、システムの製造元または販売店にお問い合わせください。


************************************************************
* 5.  ソフトウェアのインストール
************************************************************

5.1 インストールに関する一般的な注意事項

1.  RAID または AHCI　モード用に設定したシステムにオペレーティング システムをインストールする場合 
    は、セクション 5.3 で説明する F6 インストール方法を使って Intel(R) Matrix 
    Storage Manager ドライバをプリインストールする必要があります。

2.  サポートされている Microsoft* Windows* オペレーティング システムをインストールした後、
    Intel(R) Chipset Software Installation Utility　をインストール
    する必要があります。

3.  Intel(R) Matrix Storage Manager をインストールするには、自己解凍、自己
    インストール式のセットアップ ファイルをダブルクリックしてから表示されるすべての質問に答えます。

4.  インストールされたファイル（readme.txt、helpなど）はすべてデフォルトで次のパスにコピーされます。 
    
    <ブートドライブ>\Program Files\Intel\Intel(R) Matrix Storage Manager

	
5.2 ハードドライブまたは CD-ROM から Windows Automated Installer* をインス
    トールする
    
注： この方法は、RAID または AHCI モード用に設定されたシステムに適用します。

1.  Intel(R) Matrix Storage Manager セットアップ ファイルをダウンロードし、ダブル
    クリックして、自己解凍することで、セットアップ プロセスを開始します。

2.  「ようこそ」ウィンドウが開きます。[次へ] をクリックして、先に進みます。

3.  「アンインストールの警告」ウィンドウが開きます。[次へ] をクリックして、先に進みます。

4.  「ソフトウェア使用許諾契約」ウィンドウが開きます。契約条項に同意する場合は、[はい] をクリックして
    先に進みます。

5.  「Readme ファイルの情報」ウィンドウが開きます。[次へ] をクリックして、先に進みます。

6.  「インストール場所の選択」ウィンドウが開きます。[次へ] をクリックして、先に進みます。

7.  「プログラム フォルダの選択」ウィンドウが開きます。[次へ] をクリックして、ドライバのインストールを続けます。

8.  システムの再起動を指示しない「Windows Automated Installer* ウィザードの完了」
    ウィンドウが開いたら、 [完了] をクリックして、ステップ 8 に進みます。システムを再起動するように指示
    された場合は、[今すぐ再起動] （デフォルト）をクリックしてから [完了]をクリックします。システムが 
    再起動したら、ステップ 8 に進みます。

9.  ドライバが正しくロードされていることを確認するには、セクション 6 を参照してください。


5.3 F6 方法を使用したプリインストール 

注：  インテル提供の F6 フロッピーディスク ユーティリティを使用する場合は、ステップ 1 と 2 をスキップ
    してください。これらの方法は、RAID または　AHCI モード用に設定されたシステムに適用します。

1.  インストール パッケージからすべてのドライバ ファイルを抽出します。ファイルの抽出手順は、セクション  
    7.2 を参照してください。

2.  以下のファイルをルート ディレクトリに保存するフロッピーディスク* を作成します。
    iaAhci.inf, iaAhci.cat
    iaStor.inf, iaStor.cat
    iaStor.sys 
    TxtSetup.oem 

* 注： Windows Vista では、フロッピーディスク、CD/DVD、または USB を使用できます。

3.  Windows XP 以降のオペレーティング システムの場合：

    - サード パーティ製の SCSI または RAID ドライバをインストールするよう、オペレーティング 
      システムのインストールを開始するときにF6 を押します。

    - プロンプトが表示されたら、「S」を選択して追加のデバイスを指定します。

    - ステップ 5 に進みます。

4.  Windows Vista の場合:

    - オペレーティング システムのインストール中、Vista のインストール場所を選択した後、 サード 
      パーティ製の SCSI または RAID ドライバをインストールするため [ドライバのロード] を
      クリックします。

    - ステップ 5 に進みます。

5.  プロンプトが表示されたら、ステップ 2 で作成したメディア （フロッピーディスク、CD/DVD、または 
    USB） を挿入して「Enter」　を押します。

6.  表示される項目はハードウェアのバージョンと設定によって異なりますが、この時点では、本書の概要　（セク
    ション　1） にリストされているコントローラのいずれかが選択されているはずです。

7.  システムのハードウェアに適した項目をハイライトしてから「Enter」を押します。

8.  もう一度「Enter」を押して、先に進みます。セットアップがファイルをコピーするときにフロッピーディスクから
    コピーする必要があるので、フロッピーディスクは次の再起動まで入れたままにしておきます。


************************************************************
* 6.  ソフトウェアのインストールの確認
************************************************************

6.1 「ディスクを使用」、F6、または無人インストールの確認： 
    システム設定に応じて、以下の該当するトピックを参照してください。


6.1a RAID モード用システム設定の場合：

1.  [スタート] メニューで：
    1a.Windows* XP 以降のオペレーティング システムでは、コントロール パネルを選択します。
2.  [システム] を開きます（まず [クラシック表示に切り替える] を選択）。
3.  Windows* XP または Windows* Server 2003 で [ハードウェア] タブを選択します。
4.  [デバイス マネージャ] ボタンを選択します。
5.  [ストレージ コントローラ] （Windows Vista の場合）、または [SCSI と RAID コント
    ローラ] （Windows XP 以降の場合）を開きます。
6.  Intel(R) SATA RAID Controller を右クリックします。    
7.  [プロパティ] を選択します。
8.  [ドライバ] タブを選択します。
9.  [ドライバの詳細] ボタンを選択します。
10. iaStor.sys ファイルが表示されたら、インストールが正常に完了したことを示します。


6.1b AHCI モード用システム設定の場合：

1.  [スタート] メニューで：
    1a. Windows* 2000 では、[設定] を選択してから [コントロール パネル] を選択します。
    1b.Windows* XP 以降のオペレーティング システムでは、コントロール パネルを選択します。
2.  [システム] を開きます（まず [クラシック表示に切り替える] を選択）。
3.  Windows* XP または Windows* Server 2003 で [ハードウェア] タブを選択します。
4.  [デバイス マネージャ] ボタンを選択します。
5.  「IDE ATA/ATAPI controllers」エントリを展開します。
6.  Intel(R) SATA AHCI Controller を右クリックします。
7.  [プロパティ] を選択します。
8.  [ドライバ] タブを選択します。
9.  [ドライバの詳細] ボタンを選択します。
10. iaStor.sys ファイルが表示されたら、インストールが正常に完了したことを示します。


6.2 Windows Automated Installer* または「Package for the Web」イン
    ストールの確認

1.  [スタート] をクリックします。
2.  「Intel(R) Matrix Storage Manager」プログラム グループを見つけます。
3.  「Intel(R) Matrix Storage Console」エントリを選択します。
4.  「Intel(R) Matrix Storage Console」アプリケーションが起動します。
5.  このアプリケーションが起動しない場合は、Intel(R) Matrix Storage Manager 
    ドライバが正しくインストールされていないので、セットアップを実行する必要があります。 

************************************************************
* 7.  詳細インストール手順
************************************************************

7.1 使用可能なセットアップ フラグ:

    -?             インストーラでは、サポートされているすべてのセットアップ フラグ（以下に表示）
                   とその用法を示すダイアログが表示されます。 
    -A             -P も指定されている場合はすべてのファイルを <パス> に抽出します 
                   （ドライバのインストールは行いません）。-P が指定されていない場合は、
                   ファイルはデフォルト場所に抽出されます。
    -B             インストール後にシステムの再起動を強制的に行います。
    -O<名前>        Intel(R) Matrix Storage Console をインストールす
                   るプログラム フォルダ名をカスタマイズできます。このフォルダ名は [スタート]  
                   の [すべてのプログラム] メニューに表示されます。
    -P<パス>         -A フラグの使用時にターゲットパスを指定します。
    -N             ドライバ以外のコンポーネントをすべてインストールします。
    -NoGUI         ドライバのみをインストールします。Intel(R) Matrix Storage
                   Console、イベント モニタ、トレイ アイコンはインストールされません。
    -NoMon         Disk Monitor Service とシステム トレイ アイコンから成る 
                   イベント モニタを無効にします。
    -S             サイレント インストール（ユーザー プロンプトなし）。
    -BUILD         ビルド情報を表示します。		
    -G <番号>　　　　　　　　　特定の言語を強制的にインストールします（<番号> と言語を記載した表は
                   セクション 3 を参照）。
    -f2<パス\名前>     <既存のパス> に <名前> のログ ファイルを作成します。これはサイレ
                   ント インストールで使用します。-f2 と <パス\名前> の間には空白を
                   入れないでください。パスはインストール前に存在しているパスでなければなり
                   ません。

注：  フラグとパラメータでは、大文字と小文字の区別がなされません。
    フラグの指定順は-S と -G 以外は任意です。-S と -G は最後に指定してください。-A フラグを
    使用するとき、ターゲット パスを -P フラグで指定でき、-O、-G、-S、-N フラグは無視されます。
    -P、-O、-G、-f2 フラグを使用するとき、フラグと引数の間に空白を入れてはいけません。-f2 
    フラグを使用するときは、ログ ファイルの名前とパスを指定する必要があり、パスはインストール前に存在して
    いるものでなければなりません。

7.2 別のパッケージ タイプからドライバ ファイルを抽出する場合は、以下のコマンド例をご使用ください。

      c:\iata_cd.exe -a -a -pc:\<パス>
      c:\iata_enu.exe -a -a -pc:\<パス>
      c:\setup.exe -a -pc:\<パス>

    コマンドを実行すると、インストール プロセスが開始されます。表示される指示に従って先に進んでください。
    このプロセスではドライバはインストールされません。ドライバ ファイルを <パス> に抽出のみ行います。
    抽出が完了したら、ドライバ ファイルは <パス>\Driver に表示されます。


7.3 RAID ドライバを Windows* XP にインストールするには、Microsoft 提供の
    『Deployment Guide Automating Windows NT Setup』に概説されている
    ように、このパッケージに同梱の TXTSETUP.OEM ファイルを使って、下のステップ 7.3a と 
    7.3b に書かれている行を UNATTEND.TXT ファイルに挿入します。この方法は  
    Microsoft* Windows* XP と Windows Server 2003 で使用できます。
    開始する前に、セットアップ ファイルから iaAhci.inf、iaAhci.cat、iaStor.inf、
    iaStor.cat、iaStor.sys、Txtsetup.oem ファイルを抽出する必要があります。
    これらのファイルを抽出するには、上のセクション 7.2 で説明されている方法を使用します。

7.3a RAID モード用システム設定の場合：

注： 　次に例を挙げています。システムのハードウェアの設定によって異なりますが、英語の引用符で囲まれた
    テキストを本書の概要（セクション　1）にリストされている適当な　RAID　コントローラの名前に置き
    変えてください。

    // 下の行を UNATTEND.TXT ファイルに挿入してください。
  
    [MassStorageDrivers]
    "Intel(R) 82801IR/IO SATA RAID Controller" = OEM
 
    [OEMBootFiles]
    iaStor.inf
    iaStor.sys
    iaStor.cat
    Txtsetup.oem


7.3b AHCI モード用システム設定の場合：

注： 　次に例を挙げています。システムのハードウェアの設定によって異なりますが、英語の引用符で囲まれたテキ
    ストを本書の概要（セクション　1）にリストされている適当な　AHCI　コントローラの名前に置き変えて
    ください。

    // 下の行を UNATTEND.TXT ファイルに挿入してください。

    [MassStorageDrivers]
    "Intel(R) 82801IR/IO SATA AHCI Controller" = OEM
 
    [OEMBootFiles]
    iaAhci.inf
    iaStor.sys
    iaAhci.cat
    Txtsetup.oem

************************************************************
* 8.  ソフトウェア バージョン番号の識別
************************************************************

8.1 以下の手順で、「ディスクを使用」、F6、または無人インストール後のソフトウェア バージョンを識別します。


8.1a RAID モード用システム設定の場合：

1.  [スタート] メニューで：
    1a.Windows* XP 以降のオペレーティング システムでは、コントロール パネルを選択します。
2.  [システム] を開きます（まず [クラシック表示に切り替える] を選択）。
3.  Windows* XP または Windows* Server 2003 で [ハードウェア] タブを選択します。 
4.  [デバイス マネージャ] ボタンを選択します。
5.  「SCSI and RAID Controllers」エントリを展開します。
6.  Intel(R) RAID Controller を右クリックします。
7.  [プロパティ] を選択します。
8.  [ドライバ] タブを選択します。
9.  ソフトウェア バージョンが [ドライバ バージョン:] に表示されます。


8.1b AHCI モード用システム設定の場合：

1.  [スタート] メニューで：
    1a.Windows* XP 以降のオペレーティング システムでは、コントロール パネルを選択します。
2.  [システム] を開きます（まず [クラシック表示に切り替える] を選択）。
3.  Windows* XP または Windows* Server 2003 で [ハードウェア] タブを選択します。   
4.  [デバイス マネージャ] ボタンを選択します。
5.  「IDE ATA/ATAPI controllers」エントリを展開します。
6.  Intel(R) SATA AHCI Controller を右クリックします。     
7.  [プロパティ] を選択します。
8.  [ドライバ] タブを選択します。
9.  ソフトウェア バージョンが [ドライバ バージョン:] に
    表示されます。


8.2 Windows Automated Installer* または「Package for the Web」に
    よってインストールされたソフトウェア バージョンの識別

1.  [スタート]、[すべてのプログラム] の順にクリックします。 
2.  「Intel(R) Matrix Storage Manager」プログラム グループを見つけます。
3.  「Intel(R) Matrix Storage Console」エントリを選択します。
4.  「Intel(R) Matrix Storage Console」アプリケーションがバージョン番号を表記した
    スプラッシュ画面と共に表示されます。バージョン番号は [ヘルプ] メニューの [バージョン情報] を
    選択しても表示できます。


************************************************************
* 9.  ソフトウェアのアンインストール
************************************************************

9a.ドライバ以外のコンポーネントのアンインストール
このソフトウェアをシステムから削除すると、オペレーティング システムからシリアル ATA ハードドライブにアクセス
できなくなります。このため、アンインストール手順ではこのソフトウェアの非重要コンポーネントのみがアンインストール
されます（ユーザー インターフェイス、[スタート] メニュー リンクなど）。重要なコンポーネントを削除する場合は、
セクション 9b を参照してください。 

ソフトウェアをアンインストールするには、次の手順に従います。

1. 次の [スタート] メニュー フォルダから [アンインストール] を選択します。

   * すべてのプログラム -> Intel(R) Matrix Storage Manager

2. アンインストール プログラムが起動します。アンインストールのオプションを順に選択します。

9b.　ドライバ コンポーネントのアンインストール
このソフトウェアをシステムから削除すると、オペレーティング システムからシリアル ATA ハードドライブにアクセス
できなくなります。これらの手順を追える前に重要データをバックアップしてください。
 
1) システムが RAID モードであれば、Intel(R) Matrix Storage Manager 
Option ROM ユーザー インターフェイスを使って RAID ボリュームを削除します。
2) システムを再起動します。
3) システム BIOS を開きます(通常、システム起動中に F2 や Del キーを押すことで行います）。
4) 「Intel(R) RAID Technology」と「SATA AHCIモード」を無効にします。
5) オペレーティング システムを再インストールします。
 
注： システム BIOS への移行でお困りの場合は、マザーボードの製造元または販売店にお問い合わせください。
 
************************************************************
* 10.  Option ROM のユーザー インターフェイスの使用
************************************************************

Intel(R) Matrix Storage Manager Option ROM のユーザーインター フェイスを
使用するには、次の手順に従います。

1. システムを起動します。
2. 「Intel(R) Matrix Storage Manager option ROM vX.y.w.zzzz」
   バナー画面が現れたとき「Ctrl」と「I」を押します。

************************************************************
* 11.  Option ROM の RAID ボリューム管理
************************************************************
Intel(R) Matrix Storage Manager Option ROM を使用すると、次のような OS 
前の RAID ボリューム管理作業が可能になります。

1. Create RAID Volume
   このオプションを使って、1 つまたは 2 つの RAID ボリュームを作成します。

2. Delete RAID Volume
   このオプションを使って、RAID ボリュームを削除します。

3. Reset Disks to Non-RAID 
   このオプションを使って、RAID 設定を非 RAID 設定にリセットします。

4. Recovery Volume Options
   復元ボリュームがある場合は、このオプションを使って以下を行うことができます。 
        a. 継続更新を無効にする
        b. 復元ディスクだけを有効にする
        c. マスター ディスクだけを有効にする


************************************************************
* 12.  Option ROM で RAID ボリュームをリセットするオプション
************************************************************
Intel(R) Matrix Storage Option ROM ユーザー インターフェイスは、RAID ボリュー
ムをリセットするために次の 2 つの方法を提供します。
1. Delete RAID Volume
2. Reset Disks to Non-RAID
   これらのオプション間の違いを以下に記載します。ユーザーは状況に応じていずれかのオプションを選択してくだ
   さい。

12.1 Delete RAID Volume

     RAID ボリュームを削除すると、その RAID ボリュームに使用されていたディスク上の RAID メタ
     データは消去され、セクター ゼロはクリアされます。つまり、パーティション テーブルとファイル システムに
     関するデータはリセットされます。Windows インストーラーは OS インストール時に無効なデータを
     認識しません。これは、RAID ボリュームを再構成し、その上に OS をインストールする際に推奨さ
     れる方法です。

12.2 Reset Disks to Non-RAID

     このオプションは、1 度の操作で複数 RAID ボリュームによって使用されるディスク上のメタデータの
     リセットに使用します。これは、[Delete RAID Volume] オプションが何らかの理由で失敗
     したときに、「スペア」とマークされており、オフライン メンバーであるディスクをリセットする場合に使用します。
     RAID ボリューム内のディスクが非 RAID にリセットされた場合、RAID メタデータは消去されます。
     パーティション テーブルとファイル システム関連のデータは残りますが、無効である可能性があります。この
     ため Windows インストーラーは、インストール時に「リセットされたディスク」上にある情報を誤解釈
     する可能性があります。その結果、OS インストールで予期されない動作が起きる可能性があります。


************************************************************
* 13.  Option ROM ソフトウェアのバージョンの確認
************************************************************

1. Intel(R) Matrix Storage Manager Option ROM のバージョン番号を識別
   するには、次の手順に従います。

   - セクション 10 で詳しく説明されている手順を使って、Intel(R) Matrix Storage 
     Option ROM のユーザー インターフェイスを開きます。
   - ソフトウェアのバージョン番号は、ユーザー インターフェイス バナーに表示されます。
     「Intel(R) Matrix Storage Manager option ROM vX.y.w.zzzz」

     X.y.w.zzzz は、システムに実装されている Option ROM のバージョン番号です。
     X.y.w - 製品リリース番号
     X     - メジャー番号
     y     - マイナー番号
     w     - ホットフィックス番号
     zzzz  - ビルド番号

************************************************************
* 免責条項
************************************************************

本書の記載内容はインテル製品に関するものです。ここに掲載されているインテル ソフトウェア使用許諾契約書にに
明示的規定されている条項を除き、明示たると黙示たるとを問わず、禁反言か否かにかかわらず、本書によりいかなる
のライセンスも許諾されるものではありません。この製品に関するインテルの販売条件に規定されている内容を除き、
インテルは知的所有権へ何ら責任を負わないものとし、インテルはインテル製品の販売および使用に関し、特定の
目的への適合性、商品性、特許、著作権その他の知的所有権の侵害を含む明示たると黙示たるとを問わず
保証は一切しないものとします。インテル製品は医療、救命、生命維持用途での使用を意図していません。

************************************************************
* インテル コーポレーションは、本書、ソフトウェア、および本書の記載内容の使用に関して何ら保証もせず、
* 責任も負うものではなく、本書またはソフトウェアに含まれているかもしれないエラーに関して何ら義務を負うもの
* ではありません。また、インテルは本書の記載内容およびソフトウェアを更新する義務も負いません。インテルは
* 随時予告なく本書およびソフトウェアを変更する権利を保有します。
* 
*************************************************************

* サード パーティのブランドや社名はその所有会社に帰属します。

Copyright (c) Intel Corporation, 2001-2008
************************************************************
* インテル ソフトウェア使用許諾契約書
************************************************************
インテル ソフトウェア使用許諾契約書 （OEM / IHV / ISV 配布 および シングル ユーザ用）

重要 - コピー、インストール、使用の前にお読みください。 
以下の条件を注意深くお読みになるまで、ソフトウェアおよび関連資料 (以下、総称して「本ソフトウェア」といいます)を使用またはロードしないでください。本ソフトウェアの使用またはロードによって、お客様は本契約の条件に同意したこととなります。同意されない場合は、本ソフトウェアをインストールまたは使用しないでください。

注意事項：

* 使用許諾契約書の全規定は、正規機器製造元 (OEM) 、インディペンデント ハードウェア ベンダ(IHV)、およびインディペンデント ソフトウェア ベンダ(ISV) に適用します。
* エンドユーザの場合、契約物件Aのインテル ソフトウェア使用許諾契約書のみが適用されます。

正規機器製造元 (OEM)、インディペンデント ハードウェア ベンダ(IHV)、およびインディペンデント　ソフトウェア ベンダ(ISV) 対象：

使用許諾 本ソフトウェアはインテル コンポーネント 製品との組み合わせにのみを対象としてライセンスが付与されています。サードパーティ コンポーネント 製品との組み合わせによる本ソフトウェアの使用は以下のライセンス対象となりません。本契約の規定に基づき、インテルは、以下の著作権条件の下に非限定的、譲渡不可能な全世界共通の完全支払済み契約書を付与いたします。
a)契約ユーザ個人の開発および維持管理の目的で本ソフトウェアを内部的に使用、複製する場合、さらに
b)派生作業も含め、本ソフトウェアを修正、複製およびエンドユーザへ配布する場合。ただし使用許諾諸契約書の規定が契約物件Aとして添付されたインテル最終シングル ユーザ使用許諾諸契約書と同等かそれ以上の限定力を持つものとする。しかも
c)本ソフトウェアに付属する文書の修正、複製、およびユーザへ同文書を配布する場合。ただし文書は本ソフトウェアに関連するものとする。

お客様が本ソフトウェアを搭載するコンピュータ システムまたはソフトウェア プログラムの最終製造元あるいは製造供給元ではない場合、ソフトウェアの派生作業とそれに関連するエンドユーザ文書も含め、ソフトウェアのコピーを譲渡できます。ただし譲受人はこの条件に完全に拘束されることに合意し、本契約書の規定に基づいてソフトウェアを使用するものとします。さもなくば、サードパーティへのソフトウェアの割り当て、再使用許諾、貸与、またはいかなる方法における譲渡、公開も禁じます。お客様は、本ソフトウェアを逆コンパイル、逆アセンブル、リバース エンジニアすることはできません。

本契約に明示されている場合を除き、黙示的、誘発的、禁反言、その他を問わず、直接お客様に契約書を付与するものではありません。インテルは本契約の規定と条件に適合しているか確認するため、関連記録物件を監査、または他の監査業者を派遣して監査を実行する権利を所有するものとします。

機密保持 サードパーティ コンサルタントまたはサブコントラクタ (「コントラクタ」) に作業を依頼する際、ソフトウェアの使用あるいはソフトウェアへのアクセスが必要となる場合、お客様はソフトウェアの使用とアクセスに関し、いかなる配布権利およびその他の目的で使用することを禁じる条項も含め、本契約書と同等かそれ以上の限定力を持つ条件と責任を明示する機密保持同意書をコントラクタから取得するものとします。
さもなくば、本契約の存在または規定の公開、さらにインテルの書面同意なしにいかなる出版物、広告、その他の通知にもインテルの名前を使用することを禁じます。お客様にはインテルの商標を使用する権利はありません。

ソフトウェアの所有権および著作権 ソフトウェアおよびそのすべてのコピーに関する権利の一切は、インテルまたはその納入業者に帰属します。ソフトウェアは著作権が登録されており、アメリカ合衆国および諸外国の著作権法、また国際条約によって保護されています。ソフトウェアの著作権表示を抹消することはできせん。インテルは予告なしにいつでもソフトウェアまたはソフトウェア内の参照項目を変更する権利がありますが、ソフトウェアのサポートまたは更新の義務は持ちません。本契約に明確規定する場合を除き、インテルの特許、著作権、商標、その他の知的財産権の下、明示的または黙示的な権利を一切付与いたしません。受け取り人が本契約の既定に完全に準拠することに同意し、受け渡し人がソフトウェアのコピーを保持しない場合にのみソフトウェアを譲渡することができます。

記憶媒体の限定保証 本ソフトウェアが物理的な記憶媒体によってインテルから提供された場合、インテルはその記憶媒体に物理的な欠陥がないことを、配達日から 90 日間保証します。もしこのような欠陥が見つかった場合、その記憶媒体をインテルに返送してください。記憶媒体の交換またはインテルが選択したソフトウェアをお届けします。

その他の保証の除外 上記に定める場合を除き、本ソフトウェアは、商品性についての保証、権利を侵害していないという保障、特定目的への適合性についての保証等、明示たると黙示たるとを問わず一切の保証がされていません。インテルは、本ソフトウェアに含まれる情報、テキスト、グラフィック、リンク、その他について、正確性または完全性を保証するものではなく、責任を負うものではありません。

責任の制限 インテルまたはその許諾者は、損害の可能性について知らされていた場合でも、本ソフトウェアの使用または使用不能から生じるいかなる損害 (損失利益、利益の損失、業務の中断、情報の損失・消失など) について責任を負いません。国または地域によっては、黙示の保証、間接的な損害、付随的な損害の除外または制限を禁じている場合があります。この場合は、上記の制限が適用されません。国または地域によりお客様は他の法的な権利を有する場合があります。 

本契約の終了 お客様が本契約の条項に違反した場合、インテルは直ちに本契約を解約することができます。本契約が終了した場合、お客様は直ちに本ソフトウェアを処分するか、すべてのコピーをインテルに返却するものとします。
 
準拠法 本契約から生ずる請求は、抵触法の原則および国際物品売買契約に関する国連条約を除き、アメリカ合衆国のカリフォルニア州の法律を適用します。お客様は、適用のある輸出に関する法及び規則に反して本ソフトウェアを輸出することはできません。インテルは、インテルの権限のある代表者の署名のある書面によらなければ、その他の契約の義務を負いません。

政府よる制約 ソフトウェアには 「限定権利」 が付随します。政府による使用、複製、開示については、FAR52.227-14、DFAR252.227-7013 et seq.またはその継承規定により一定の制限が加えられます。政府によるソフトウェアの使用は付随するインテルの財産権を認知したものとします。契約者または製造業者： Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95052 USA.


契約物件 "A"
インテル ソフトウェア使用許諾契約書 (最終、シングル ユーザ用)

重要 - コピー、インストール、または使用の前にお読みください。 
以下の条件を注意深くお読みになるまで、ソフトウェアおよび関連資料 (以下、総称して「本ソフトウェア」といいます) を使用またはロードしないでください。本ソフトウェアの使用またはロードによって、お客様は本契約の条件に同意したこととなります。同意されない場合は、本ソフトウェアをインストールまたは使用しないでください。

使用許諾 お客様は、本ソフトウェアを非営利目的でお客様の利用のために、一台のコンピュータに複製することができます。以下の条件に従う場合、本ソフトウェアのバックアップ コピーを一部作成することができます。 
1. 本ソフトウェアはインテル コンポーネント 製品との組み合わせにのみを対象としてライセンスが付与されています。サードパーティ コンポーネント 製品との組み合わせによる本ソフトウェアの使用は以下のライセンス対象となりません。 
2. 本契約において特に認められた場合を除き、お客様は、本ソフトウェアをいかなる部分も複製、修正、貸与、販売、頒布、譲渡することはできません。また、お客様は、本ソフトウェアの無許諾の複製を防止するものとします。
3. お客様は、本ソフトウェアをリバース エンジニア、逆コンパイル、逆アセンブルすることはできません。 
4. お客様は本ソフトウェアを再許諾することができません。またお客様は、複数のものによる本ソフトウェアの同時使用を認めることができません。
5. 本ソフトウェアには、サードパーティのソフトウェアまたはプロパティが含まれていることがあり、その一部は同封された [license.txt] ファイルまたはその他のテキストやファイルに準じて認識され、ライセンスが付与されることがあります。 

ソフトウェアの所有権および著作権 ソフトウェアおよびそのすべてのコピーに関する権利の一切は、インテルまたはその納入業者に帰属します。ソフトウェアは著作権が登録されており、アメリカ合衆国および諸外国の著作権法、また国際条約によって保護されています。ソフトウェアの著作権表示を抹消することはできせん。インテルは予告なしにいつでもソフトウェアまたはソフトウェア内の参照項目を変更する権利がありますが、ソフトウェアのサポートまたは更新の義務は持ちません。本契約に明確規定する場合を除き、インテルの特許、著作権、商標、その他の知的財産権の下、明示的または黙示的な権利を一切付与いたしません。受け取り人が本契約の既定に完全に準拠することに同意し、受け渡し人がソフトウェアのコピーを保持しない場合にのみソフトウェアを譲渡することができます。

記憶媒体の限定保証 本ソフトウェアが物理的な記憶媒体によってインテルから提供された場合、インテルはその記憶媒体に物理的な欠陥がないことを、配達日から 90 日間保証します。もしこのような欠陥が見つかった場合、その記憶媒体をインテルに返送してください。記憶媒体の交換またはインテルが選択したソフトウェアをお届けします。

その他の保証の除外 上記に定める場合を除き、本ソフトウェアは、商品性についての保証、権利を侵害していないという保障、特定目的への適合性についての保証等、明示たると黙示たるとを問わず一切の保証がされていません。インテルは、本ソフトウェアに含まれる情報、テキスト、グラフィック、リンク、その他について、正確性または完全性を保証するものではなく、責任を負うものではありません。

責任の制限 インテルまたはその許諾者は、損害の可能性について知らされていた場合でも、本ソフトウェアの使用または使用不能から生じるいかなる損害 (損失利益、利益の損失、業務の中断、情報の損失・消失など) について責任を負いません。国または地域によっては、黙示の保証、間接的な損害、付随的な損害の除外または制限を禁じている場合があります。この場合は、上記の制限が適用されません。国または地域によりお客様は他の法的な権利を有する場合があります。 

本契約の終了 お客様が本契約の条項に違反した場合、インテルは直ちに本契約を解約することができます。本契約が終了した場合、お客様は直ちに本ソフトウェアを処分するか、すべてのコピーをインテルに返却するものとします。
 
準拠法 本契約から生ずる請求は、抵触法の原則および国際物品売買契約に関する国連条約を除き、アメリカ合衆国のカリフォルニア州の法律を適用します。お客様は、適用のある輸出に関する法及び規則に反して本ソフトウェアを輸出することはできません。インテルは、インテルの権限のある代表者の署名のある書面によらなければ、その他の契約の義務を負いません。

政府よる制約 ソフトウェアには 「限定権利」 が付随します。政府による使用、複製、開示については、FAR52.227-14、DFAR252.227-7013 et seq. またはその継承規定により一定の制限が加えられます。政府によるソフトウェアの使用は付随するインテルの財産権を認知したものとします。契約者または製造業者： Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95052 USA.
SLAOEMISV1/RBK/01-21-00

言語、翻訳  この契約の英語版に、他国語への翻訳版が付随している場合、その翻訳版はお客様の便宜を図って提供されているだけのものであり、英語版が優先されます。




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


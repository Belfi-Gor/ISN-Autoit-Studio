;---------------------------------------------------
;  _____  _____ _   _                 _       _____ _      _____ _             _ _
; |_   _|/ ____| \ | |     /\        | |     |_   _| |    / ____| |           | (_)
;   | | | (___ |  \| |    /  \  _   _| |_ ___  | | | |_  | (___ | |_ _   _  __| |_  ___
;   | |  \___ \| . ` |   / /\ \| | | | __/ _ \ | | | __|  \___ \| __| | | |/ _` | |/ _ \
;  _| |_ ____) | |\  |  / ____ \ |_| | || (_) || |_| |_   ____) | |_| |_| | (_| | | (_) |
; |_____|_____/|_| \_| /_/    \_\__,_|\__\___/_____|\__| |_____/ \__|\__,_|\__,_|_|\___/
;
;
; by ISI360 (Christian Faderl)
;---------------------------------------------------

;Versions Info
Global $VersionBuild = "20181027" ;YEAR|MON|DAY
Global $Studioversion = "1.08"
Global $ERSTELLUNGSTAG = "27.10.2018 (" & $VersionBuild & ")"

;Autoit Wrapper
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
	#AutoIt3Wrapper_Res_Description=ISN AutoIt Studio
	#AutoIt3Wrapper_Res_Fileversion=1.0.8
	#AutoIt3Wrapper_Res_ProductVersion=1.08
	#AutoIt3Wrapper_Res_LegalCopyright=ISI360
	#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
	#AutoIt3Wrapper_Res_Field=ProductName|ISN AutoIt Studio
	#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
	#AutoIt3Wrapper_UseUpx=n
	#AutoIt3Wrapper_Run_Tidy=y
	#AutoIt3Wrapper_Res_HiDpi=Y
	#AutoIt3Wrapper_Run_AU3Check=Y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;Autoit Options
#NoTrayIcon
Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 1) ;Can close every GUI with ESC
Opt("WinTextMatchMode", 1) ;1=complete, 2=quick
Opt("WinTitleMatchMode", 3) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
Opt("GUIResizeMode", 802)

;Autoit Includes 1/2 (Nur die wichtigsten Startupincludes)
#include <String.au3>
#include <WinAPIDlg.au3>
#include <WinAPI.au3>
#include <IE.au3>
#include <Sound.au3>
#include <GUIConstants.au3>
#include <Array.au3>
#include <FileConstants.au3>
#include <FontConstants.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <file.au3>
#include <Crypt.au3>
#include "includes\ISN_UDF_RDC.au3"
#include "includes\ISN_UDF_Icons.au3"
#include "includes\ISN_Addon_Scintilla_Pixmaps.au3"
#include "includes\ISN_UDF_iniEx.au3"
#include "includes\ISN_UDF_ZLIB.au3"
#include "includes\ISN_UDF_IniVirtual.au3"
#include "includes\ISN_Studio_Declarations.au3"
#include "includes\ISN_UDF_AdlibEnhance.au3"
#include "includes\ISN_Addon_DPI_Scaling.au3"
#include "includes\ISN_UDF_Scintilla_Declarations.au3"
#include "includes\ISN_UDF_HotKey_21b.au3"
#include "includes\ISN_UDF_RunWithReducedPrivileges.au3"
#include "includes\ISN_UDF_Curl.au3"
#include "includes\ISN_UDF_USkin.au3"
#include "includes\ISN_UDF_Copy.au3"
#include "includes\ISN_UDF_Zip32.au3"
#include "includes\ISN_UDF_GUIScrollbars_Ex.au3"



;Prüfe ob eine Instanz von ISN AutoIt Studio läuft...falls ja übergebe die zu öffnende Datei an das bereits gestartete Studio
If $CmdLine[0] > 0 Then
	Opt("WinTitleMatchMode", 2)
	$Other_Studio_Handle = WinGetHandle("[TITLE:ISN AutoIt Studio; CLASS:AutoIt v3 GUI]")
	If Not @error Then
		For $parameter_count = 1 To $CmdLine[0]
			If StringInStr($CmdLine[$parameter_count], ".icp") And Not StringInStr($CmdLine[$parameter_count], "/") Then
				_ISN_Send_Message_to_Plugin($Other_Studio_Handle, "callfunc_in_ISN" & $Plugin_System_Delimiter & "_Import_ICP_Plugin_CMD" & $Plugin_System_Delimiter & FileGetLongName($CmdLine[$parameter_count]), 1)
				WinActivate($Other_Studio_Handle)
				Exit
			EndIf
		Next
	EndIf
	Opt("WinTitleMatchMode", 3)
	$Editormode_Studio_Handle = WinGetHandle(_Get_langstr(1) & " - " & _Get_langstr(661))
	If Not @error Then
		For $parameter_count = 1 To $CmdLine[0]
			If StringInStr($CmdLine[$parameter_count], ".au3") And Not StringInStr($CmdLine[$parameter_count], "/") Then _ISN_Send_Message_to_Plugin($Editormode_Studio_Handle, "callfunc_in_ISN" & $Plugin_System_Delimiter & "_Try_to_open_file" & $Plugin_System_Delimiter & FileGetLongName($CmdLine[$parameter_count]), 1)
		Next
		WinActivate($Editormode_Studio_Handle)
		Exit
	EndIf
EndIf




_GetMonitors() ;Lese Monitore ($__MonitorList wird dadurch befüllt)
_Set_Proxyserver() ;Setze Proxy Server

;Prüfung ob ISN auf einem Komprimiertem Laufwerk gestartet wird und zeige Infomeldung an
If StringInStr(FileGetAttrib(StringTrimRight(@AutoItExe, StringLen(@AutoItExe) - StringInStr(@AutoItExe, "\"))), "C") Then
	$res = MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(442), 0)
	If $res = 7 Then Exit
EndIf

;Initialisiere skin
_Uskin_LoadDLL(@ScriptDir & "\Data\USkin.dll")
If Not FileExists(@ScriptDir & "\Data\Skins\" & $skin) Then $skin = "#none#"
$pfad = @ScriptDir & "\Data\Skins\" & $skin & "\skin.msstyles"
If $skin <> "#none#" Then
	_USkin_Init($pfad) ;skin zuweisen
EndIf

;Prüfe encoding...falls ansi gib warnhinweis aus
If IniRead($Configfile, "warnings", "confirmencoding", "0") = "0" And $autoit_editor_encoding = "1" Then
	$antwort = MsgBox(4 + 48 + 262144, _Get_langstr(394), _Get_langstr(1137), 0)
	If @error Or $antwort = 7 Then
		IniWrite($Configfile, "warnings", "confirmencoding", "1")
	EndIf

	If $antwort = 6 Then
		_Write_in_Config("autoit_editor_encoding", "2")
		IniWrite($Configfile, "warnings", "confirmencoding", "1")
		$autoit_editor_encoding = "2"
	EndIf
EndIf

;Set LowLevelHooksTimeout Reg Key (if it does not exists)
;If this regkey does not exist, the hotkey UDF does not work 100%. The windows default value is 5000 (dec)
;A windows restart is required to take effect of this key.
RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "LowLevelHooksTimeout")
If @error Then RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "LowLevelHooksTimeout", "REG_DWORD", 0x00001388) ;Set to 5000ms (windows default)


;Startup Logo
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING_STARTUP") ;Register Boot WINDOWPOSCHANGING
_GDIPlus_Startup()
$pngX = @ScriptDir & "\Data\startup.png"
Global $hImagestartup = _GDIPlus_ImageLoadFromFile($pngX)
$hImagestartup = _GDIPlus_ImageScale($hImagestartup, $DPI, $DPI, $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC) ;Scale the Logo to DPI Values
$width = _GDIPlus_ImageGetWidth($hImagestartup)
$height = _GDIPlus_ImageGetHeight($hImagestartup)
Global $Logo_PNG = GUICreate("", $width, $height, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOOLWINDOW))
SetBitmap($Logo_PNG, $hImagestartup, 0)
GUISetState()
WinSetOnTop($Logo_PNG, "", 1)
Global $controlGui_startup = GUICreate("", $width, $height, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD, $WS_EX_TOOLWINDOW), $Logo_PNG)
GUISetBkColor(0xFFFFFF) ; => hintergrund ebenfalls durchsichtig, damit die buttons direkt auf das Hintergrundbild gesetzt werden
_WinAPI_SetLayeredWindowAttributes($controlGui_startup, 0xFFFFFF)
$startup_progress = GUICtrlCreateProgress(450, 298, 100, 10)
_Control_set_DPI_Scaling($startup_progress)
$String_Size_Startup_array = _StringSize("Version " & $Studioversion & @CRLF & "Build " & $VersionBuild, 8.5, 800, 0, "Arial")
If IsArray($String_Size_Startup_array) Then
	GUICtrlCreateLabel("Version " & $Studioversion & @CRLF & "Build " & $VersionBuild, 253, 285 - $String_Size_Startup_array[1], 295, $String_Size_Startup_array[1], 2, -1)
	_Control_set_DPI_Scaling(-1)
	GUICtrlSetFont(-1, 8.5, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xC8C8C8)
EndIf
$startup_text = GUICtrlCreateLabel("", 90, 296, 360, 25, -1, -1)
_Control_set_DPI_Scaling($startup_text)
GUICtrlSetFont(-1, 8.5, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x4B4B4B)
GUICtrlSetData($startup_text, _Get_langstr(461))

_CenterOnMonitor($Logo_PNG, "", _ISN_Gui_Size_Saving_Get_Gui_Monitor_by_Keyname("mainwindow"))
;Startup Animation
SetBitmap($Logo_PNG, $hImagestartup, 0)
If $enablelogo = "true" Then
	$alpha = 0
	While 1
		$alpha = $alpha + 20
		If $alpha > 255 Then
			$alpha = 255
			ExitLoop
		EndIf
		SetBitmap($Logo_PNG, $hImagestartup, $alpha)
	WEnd
	SetBitmap($Logo_PNG, $hImagestartup, 255)
	GUISetState(@SW_SHOW, $controlGui_startup)
Else
	GUISetState(@SW_HIDE, $Logo_PNG)
	GUISetState(@SW_HIDE, $controlGui_startup)
EndIf

;Autoit Includes 2/2
#include <GuiToolbar.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <APIConstants.au3>
#include <GuiSlider.au3>
#include <Process.au3>
;~ #include "includes\WinAPIEx.au3>
#include <WinAPIEx.au3>
;~ #include "includes\mod_GuiRichEdit.au3> ;old Version from Autoit 3.3.6.1 (3.3.8.0 is not working)
#include <GuiRichEdit.au3> ;neue Version funktioniert wieder
#include <GuiReBar.au3>
#include <Constants.au3>
#include <GuiEdit.au3>
#include <ClipBoard.au3>
#include <WinAPISys.au3>
#include <TabConstants.au3>
#include <Memory.au3>
#include <InetConstants.au3>
#include <ComboConstants.au3>
#include <Inet.au3>
#include <GuiTab.au3>
#include <StructureConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>
#include <ProgressConstants.au3>
#include <ButtonConstants.au3>
#include <Color.au3>
#include <ScrollBarConstants.au3>
#include <GuiToolTip.au3>
#include <Timers.au3>
#include <GUIComboBox.au3>
#include <GUIListBox.au3>
#include <Date.au3>
#include <SendMessage.au3>
#include <GuiStatusBar.au3>
#include <GuiMenu.au3>
#include <String.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include <GuiListView.au3>
#include <Math.au3>
#include "includes\ISN_UDF_ModernMenuRaw.au3"
#include "includes\ISN_UDF_ChatBox.au3"
#include "includes\ISN_Addon_DebugConsole.au3"
#include "includes\ISN_UDF_Json.au3"
#include "includes\ISN_UDF_TristateTreeViewLib.au3"
#include "includes\ISN_UDF_SciLexer.au3"
#include "includes\ISN_UDF_ColorChooser.au3"
#include "includes\ISN_UDF_TVExplorer.au3"
;End Includes

_Write_ISN_Debug_Console("Welcome to the ISN AutoIt Studio version " & $Studioversion & " (build " & $VersionBuild & ")" & "!", 0)
If $Save_Mode = "true" Then _Write_ISN_Debug_Console("SAFEMODE ACTIVE!", 3, 1, 1, 1)
_Write_ISN_Debug_Console("ISN AutoIt Studio starting up...", 1)

GUICtrlSetData($startup_progress, 10)

;-> -> -> Abzweigung zur Erstkonfiguration
#include "Forms\ISN_Ersteinrichtung_Sprache.isf"
If Not FileExists(RegRead("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Configfile")) And FileExists(@ScriptDir & "\portable.dat") = 0 Then
	_Load_Languages()
	GUISetState(@SW_HIDE, $Logo_PNG)
	GUISetState(@SW_HIDE, $controlGui_startup)
	SetBitmap($Logo_PNG, $hImagestartup, 0)
	GUISetState(@SW_SHOW, $Sprache_Ersteinrichtung_GUI)
	While 1
		$state = WinGetState($Sprache_Ersteinrichtung_GUI, "")
		$i = 0
		If BitAND($state, 2) Then $i = 1
		If $i = 0 Then ExitLoop
		Sleep(200)
	WEnd
EndIf

#include "includes\ISN_Studio_Firstconfig.au3"
If Not FileExists(RegRead("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Configfile")) And FileExists(@ScriptDir & "\portable.dat") = 0 Then _Show_Firstconfig() ;Falls keine Konfiguration gefunden wurde -> Zeige Erstkonfiguration

;Config.ini auf UTF-16 (LE) umstellen (neu seit 1.04)
_Datei_nach_UTF16_konvertieren($Configfile, "false")

;Daten und Ordner prüfen -> zb. alte Ordner umbenennen oder löschen
_ISN_AutoIt_Studio_Dateien_und_Ordner_reorganisieren()


;After Upgrade Bereich
;Das ISN wird nach einem Update mit "/finishupdate" gestartet und zb. Plugins upzudaten oder die Ordner zu reorganisieren
#include "Forms\ISN_Update_wird_Abgeschlossen.isf"
If IsArray($CmdLine) Then
	For $x = 1 To $CmdLine[0]
		;/finishupdate
		If StringInStr($CmdLine[$x], "/finishupdate") Then
			GUISetState(@SW_HIDE, $console_GUI)
			GUISetState(@SW_HIDE, $Logo_PNG)
			GUISetState(@SW_HIDE, $controlGui_startup)
			SetBitmap($Logo_PNG, $hImagestartup, 0)
			GUISetState(@SW_SHOW, $Update_wird_Abgeschlossen_GUI)
			Sleep(500)
			If _ISN_Update_Installer_aus_Package_installieren() <> 1 Then MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1332), 0) ;Installer selbst Updaten
			Sleep(1000)
			_RunWithReducedPrivileges(@ScriptDir & "\Autoit_Studio.exe", '', @ScriptDir)
			_USkin_Exit()
			Exit

		EndIf
	Next
EndIf


;Command Line für .isn Dateien
Global $CommandLine = ""
If $CmdLine[0] > 1 Then
	Global $CommandLine = $CmdLine[2]
	FileChangeDir(@ScriptDir)
EndIf

;Erstelle Verzeichnisse
If Not FileExists($Arbeitsverzeichnis) Then DirCreate($Arbeitsverzeichnis)
If Not FileExists($Arbeitsverzeichnis & "\Data\Cache") Then DirCreate($Arbeitsverzeichnis & "\Data\Cache")
If Not FileExists($Arbeitsverzeichnis & "\Data\Api") Then DirCreate($Arbeitsverzeichnis & "\Data\Api")
If Not FileExists($Arbeitsverzeichnis & "\Data\Properties") Then DirCreate($Arbeitsverzeichnis & "\Data\Properties")
If Not FileExists(_ISN_Variablen_aufloesen($Projectfolder)) Then DirCreate(_ISN_Variablen_aufloesen($Projectfolder))
If Not FileExists(_ISN_Variablen_aufloesen($templatefolder)) Then DirCreate(_ISN_Variablen_aufloesen($templatefolder))
;~ If Not FileExists(_ISN_Variablen_aufloesen($Standardordner_UDFs)) Then DirCreate(_ISN_Variablen_aufloesen($Standardordner_UDFs))

;Include Pfade in Registry übernehmen (falls aktiv)
_Pfade_fuer_Weitere_Includes_in_Registrierung_uebernehmen()

;Hole die aktuelle Auflösung des Monitors und erstelle daraus das Hauptfenster
$Monitor_Aufloesung = _Get_Monitor_Resolution($Runonmonitor)
If $Monitor_Aufloesung[0] = "" Then
	$Monitor_Aufloesung[0] = @DesktopWidth
	$Monitor_Aufloesung[1] = @DesktopHeight
EndIf


Global $StudioFenster = GUICreate(_Get_langstr(1), $Monitor_Aufloesung[0], $Monitor_Aufloesung[1], -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_DLGFRAME, $WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX), $WS_EX_ACCEPTFILES) ;$WS_MINIMIZEBOX,$WS_MAXIMIZEBOX
_GUISetIcon($StudioFenster, @ScriptDir & "\autoitstudioicon.ico", 0)
GUICtrlCreateLabel("ISN_MAIN_GUI", 0, 0, 0, 0) ;This makes finding the ISN main Window with WinGetHandle a lot easier
GUICtrlSetState(-1, $GUI_HIDE)
Global $hToolTip_StudioFenster = _GUIToolTip_Create($StudioFenster)
_ISN_Enable_Gui_Size_Saving($StudioFenster, "mainwindow")


;Fenster Hotkeys
Global $Minus_am_Nummernblock_Dummykey = GUICtrlCreateDummy()
GUICtrlSetOnEvent($Minus_am_Nummernblock_Dummykey, "_comment_out")
Global $Studiofenster_AccelKeys[1][2] = [["{NUMPADSUB}", $Minus_am_Nummernblock_Dummykey]]


;------------------------

_CenterOnMonitor($StudioFenster, "", $Runonmonitor)


If $ISN_Dark_Mode = "true" Then DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
$Status_bar = _GUICtrlStatusBar_Create($StudioFenster, -1, "", $SBARS_TOOLTIPS)
If $ISN_Dark_Mode = "true" Then DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 3)

Global $Studio_ToolTip = _GUIToolTip_Create($StudioFenster, BitOR($_TT_ghTTDefaultStyle, $TTS_BALLOON, $TTS_CLOSE))

;~ Global $Statusbar_progress = GUICtrlCreateProgress(0, 0, 100, 13)
;~ _Status_bar_aktualisiere_Parts()
;~ _GUICtrlStatusBar_SetText($Status_bar, "")

GUISetFont(8.5, 400, 0, "Segoe UI", $StudioFenster)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Try_to_Exit", $StudioFenster)
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, '_PRIMARYdown', $StudioFenster)
GUISetOnEvent($GUI_EVENT_RESTORE, "_Resize_with_no_tabrefresh", $StudioFenster)
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "_Resize_with_no_tabrefresh", $StudioFenster)
GUISetOnEvent($GUI_EVENT_RESIZED, "_Resize_with_no_tabrefresh", $StudioFenster)
GUICtrlSetData($startup_progress, 20)

Global $size1 = WinGetClientSize($StudioFenster, "")
Global $size = WinGetPos($StudioFenster)

;Menü Datei
$FileMenu = GUICtrlCreateMenu(_Get_langstr(39)) ;_GUICtrlCreateODTopMenu(_Get_langstr(39),$StudioFenster)
$StudioFenster_MenuHandle = _GUICtrlMenu_GetMenu($StudioFenster)
$nSideItem1 = _CreateSideMenu($FileMenu)
_SetSideMenuText($nSideItem1, _Get_langstr(1) & " " & $Studioversion)
_SetSideMenuColor($nSideItem1, 0xFFFFFF) ; default color - white
_SetSideMenuBkColor($nSideItem1, 0x921801) ; bottom start color - dark blue
_SetSideMenuBkGradColor($nSideItem1, 0xFBCE92) ; top end color - light blue


If $ISN_Dark_Mode = "true" Then
	;Setze Farben für Dark Mode
	_SetMenuBkColor(0x414141)
	_SetMenuIconBkColor(0x7f7f7f)
;~         _SetMenuIconBkGrdColor(0x5566BB)
;~         _SetMenuSelectBkColor(0x70A0C0)
;~         _SetMenuSelectRectColor(0x854240)
;~         _SetMenuSelectTextColor(0x000000)
	_SetMenuTextColor(0xFFFFFF)
;~         _GUIMenuBarSetBkColor($StudioFenster,$nMenuBkClr)
	_SetSideMenuBkColor($nSideItem1, 0x404040) ; bottom start color - dark blue
	_SetSideMenuBkGradColor($nSideItem1, 0x909090) ; top end color - light blue
EndIf



$FileMenu_item1 = _GUICtrlCreateODMenuItem(_Get_langstr(9) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern), $FileMenu) ;save
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1302)

$FileMenu_item1c = _GUICtrlCreateODMenuItem(_Get_langstr(725) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern_unter), $FileMenu) ;Speichern unter
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1302)

$FileMenu_item1b = _GUICtrlCreateODMenuItem(_Get_langstr(650) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern_Alle_Tabs), $FileMenu) ;save all
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 286)

$FileMenu_UndockTab = _GUICtrlCreateODMenuItem(_Get_langstr(1364), $FileMenu) ;Undock tab
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 808 + 1)

$FileMenu_TabSchliessen = _GUICtrlCreateODMenuItem(_Get_langstr(31) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_tab_schliessen), $FileMenu) ;Aktuellen Tab schliessen
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1918)

$FileMenu_item1d = _GUICtrlCreateODMenuItem(_Get_langstr(806) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern_Alle_Tabs), $FileMenu) ;close all
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1804)

$Dateimenue_Drucken = _GUICtrlCreateODMenuItem(_Get_langstr(882), $FileMenu) ;Drucken
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1293)


_GUICtrlCreateODMenuItem("", $FileMenu) ;seperator

$Dateimenue_Oeffnen = _GUICtrlCreateODMenuItem(_Get_langstr(509) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Oeffnen), $FileMenu) ;open external file
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1287)

$FileMenu_zuletzt_verwendete_Dateien = _GUICtrlCreateODMenu(_Get_langstr(723), $FileMenu) ;Zuletzt verwendeten Dateien
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 531)

$FileMenu_zuletzt_verwendete_Dateien_Slot1 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot1
$FileMenu_zuletzt_verwendete_Dateien_Slot2 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot2
$FileMenu_zuletzt_verwendete_Dateien_Slot3 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot3
$FileMenu_zuletzt_verwendete_Dateien_Slot4 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot4
$FileMenu_zuletzt_verwendete_Dateien_Slot5 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot5
$FileMenu_zuletzt_verwendete_Dateien_Slot6 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot6
$FileMenu_zuletzt_verwendete_Dateien_Slot7 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot7
$FileMenu_zuletzt_verwendete_Dateien_Slot8 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot8
$FileMenu_zuletzt_verwendete_Dateien_Slot9 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot9
$FileMenu_zuletzt_verwendete_Dateien_Slot10 = _GUICtrlCreateODMenuItem(_Get_langstr(722), $FileMenu_zuletzt_verwendete_Dateien, "", 0, 1) ;Zuletzt verwendeten Dateien, Slot10




_GUICtrlCreateODMenuItem("", $FileMenu)
$FileMenu_item2 = _GUICtrlCreateODMenu(_Get_langstr(70) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Neue_Datei), $FileMenu) ;new file
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1283)
$FileMenu_item2a = _GUICtrlCreateODMenuItem(_Get_langstr(154), $FileMenu_item2, "", 0, 1) ;au3 file
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1788)
$FileMenu_Neue_Datei_temp_au3file = _GUICtrlCreateODMenuItem(_Get_langstr(1094) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Create_Temp_Au3_Script), $FileMenu_item2, "", 0, 1) ;temp au3 file
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1788)
$FileMenu_item2b = _GUICtrlCreateODMenuItem(_Get_langstr(153), $FileMenu_item2, "", 0, 1) ;isf file
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 781)
$FileMenu_item2c = _GUICtrlCreateODMenuItem(_Get_langstr(155), $FileMenu_item2, "", 0, 1) ;ini file
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1177)
$FileMenu_item2d = _GUICtrlCreateODMenuItem(_Get_langstr(156), $FileMenu_item2, "", 0, 1) ;txt file
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1178)
$FileMenu_item3 = _GUICtrlCreateODMenuItem(_Get_langstr(71), $FileMenu) ;new folder
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1344)
$FileMenu_item7 = _GUICtrlCreateODMenuItem(_Get_langstr(74) & @TAB & "Del", $FileMenu) ;delete
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1174)
$FileMenu_item8 = _GUICtrlCreateODMenuItem(_Get_langstr(75), $FileMenu) ;rename
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 824)
$FileMenu_item9 = _GUICtrlCreateODMenuItem(_Get_langstr(76), $FileMenu) ;move
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1090)
$FileMenu_item14 = _GUICtrlCreateODMenuItem(_Get_langstr(371), $FileMenu) ;kopie erstellen
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 512)
_GUICtrlCreateODMenuItem("", $FileMenu)
$FileMenu_item4 = _GUICtrlCreateODMenuItem(_Get_langstr(72), $FileMenu) ;import
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 378)
$FileMenu_item5 = _GUICtrlCreateODMenuItem(_Get_langstr(455), $FileMenu) ;import folder
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1090)
$FileMenu_item6 = _GUICtrlCreateODMenuItem(_Get_langstr(73), $FileMenu) ;export
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 416)
_GUICtrlCreateODMenuItem("", $FileMenu)
$FileMenu_item10 = _GUICtrlCreateODMenuItem(_Get_langstr(42), $FileMenu) ;Setup
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1081)
_GUICtrlCreateODMenuItem("", $FileMenu)
$FileMenu_item12 = _GUICtrlCreateODMenuItem(_Get_langstr(40) & @TAB & "Alt+F4", $FileMenu) ;exit
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 923)

;Menü Projekt
$ProjectMenu = GUICtrlCreateMenu(_Get_langstr(69)) ;_GUICtrlCreateODTopMenu(_Get_langstr(69),$Studiofenster)

$ProjectMenu_item1 = _GUICtrlCreateODMenuItem(_Get_langstr(4), $ProjectMenu) ;New project
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1412)
$ProjectMenu_item2 = _GUICtrlCreateODMenuItem(_Get_langstr(355), $ProjectMenu) ;projectmanager
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1096)
$ProjectMenu_item3 = _GUICtrlCreateODMenuItem(_Get_langstr(41) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Close_project), $ProjectMenu) ;Close project
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1095)
_GUICtrlCreateODMenuItem("", $ProjectMenu)

$ProjectMenu_aenderungsprotokolle = _GUICtrlCreateODMenuItem(_Get_langstr(911) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Aenderungsprotokolle), $ProjectMenu) ;Änderungsprotokolle
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1725)
$ProjectMenu_backup_durchfuehren = _GUICtrlCreateODMenuItem(_Get_langstr(893) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Automatisches_Backup), $ProjectMenu) ;Backup
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 324)
$ProjectMenu_item12 = _GUICtrlCreateODMenuItem(_Get_langstr(53), $ProjectMenu) ;refresh projecttree
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 998)
$ProjectMenu_item13 = _GUICtrlCreateODMenuItem(_Get_langstr(519), $ProjectMenu) ;Projektregeln
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1549)
$ProjectMenu_todo_liste = _GUICtrlCreateODMenuItem(_Get_langstr(1262) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_ToDo_Liste), $ProjectMenu) ;ToDo Liste
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1798)



$ProjectMenu_projekteinstellungen = _GUICtrlCreateODMenuItem(_Get_langstr(1078), $ProjectMenu) ;Projekteinstellungen
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1083)
_GUICtrlCreateODMenuItem("", $ProjectMenu)

$ProjectMenu_item8 = _GUICtrlCreateODMenu(_Get_langstr(489), $ProjectMenu) ;testproject
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 221)
$ProjectMenu_item8a = _GUICtrlCreateODMenuItem(_Get_langstr(50) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt), $ProjectMenu_item8, "", 0, 1) ;testproject
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 221)
$ProjectMenu_item8b = _GUICtrlCreateODMenuItem(_Get_langstr(488) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter), $ProjectMenu_item8, "", 0, 1) ;test without parammeters
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 221)
_GUICtrlCreateODMenuItem("", $ProjectMenu_item8)
$ProjectMenu_item8c = _GUICtrlCreateODMenuItem(_Get_langstr(490), $ProjectMenu_item8, "", 0, 1) ;config parameters
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1377)
$ProjectMenu_item9 = _GUICtrlCreateODMenuItem(_Get_langstr(82) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_testeskript), $ProjectMenu) ;testscript
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 14)
$ProjectMenu_item10 = _GUICtrlCreateODMenuItem(_Get_langstr(106), $ProjectMenu) ;stop
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 535)
$ProjectMenu_item11 = _GUICtrlCreateODMenu(_Get_langstr(52), $ProjectMenu) ;compile
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 528)

$ProjectMenu_item11a = _GUICtrlCreateODMenuItem(_Get_langstr(52) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile), $ProjectMenu_item11) ;compile
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 528)
$ProjectMenu_Kompilieren_Daten_auswaehlen = _GUICtrlCreateODMenuItem(_Get_langstr(1063), $ProjectMenu_item11) ;Daten zum Kompilieren auswählen
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 530)
$ProjectMenu_item11b = _GUICtrlCreateODMenuItem(_Get_langstr(563) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile_Settings), $ProjectMenu_item11) ;compile settings
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 530)


;Menü Bearbeiten
$EditMenu = GUICtrlCreateMenu(_Get_langstr(109)) ;_GUICtrlCreateODTopMenu(_Get_langstr(109),$Studiofenster)
$EditMenu_item1 = _GUICtrlCreateODMenuItem(_Get_langstr(55) & @TAB & "Ctrl+Z", $EditMenu) ;Undo
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 728)
$EditMenu_item2 = _GUICtrlCreateODMenuItem(_Get_langstr(56) & @TAB & "Ctrl+Y", $EditMenu) ;redo
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 194)
_GUICtrlCreateODMenuItem("", $EditMenu)
$EditMenu_select_all = _GUICtrlCreateODMenuItem(_Get_langstr(1341) & @TAB & "Ctrl+A", $EditMenu) ;Select all
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 311)
$EditMenu_item3 = _GUICtrlCreateODMenuItem(_Get_langstr(110) & @TAB & "Ctrl+X", $EditMenu) ;Cut
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1129)
$EditMenu_item4 = _GUICtrlCreateODMenuItem(_Get_langstr(111) & @TAB & "Ctrl+C", $EditMenu) ;Copy
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1088)
$EditMenu_item5 = _GUICtrlCreateODMenuItem(_Get_langstr(112) & @TAB & "Ctrl+V", $EditMenu) ;Paste
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 9)
$EditMenu_item6 = _GUICtrlCreateODMenuItem(_Get_langstr(113) & @TAB & "Del", $EditMenu) ;delete
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1180)
_GUICtrlCreateODMenuItem("", $EditMenu)





$EditMenu_Zeilen_nach_oben_verschieben = _GUICtrlCreateODMenuItem(_Get_langstr(1170) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_oben_verschieben), $EditMenu) ;Zeile(n) nach oben verschieben
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 830)
$EditMenu_Zeilen_nach_unten_verschieben = _GUICtrlCreateODMenuItem(_Get_langstr(1171) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_unten_verschieben), $EditMenu) ;Zeile(n) nach unten verschieben
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 834)
$EditMenu_zeile_duplizieren = _GUICtrlCreateODMenuItem(_Get_langstr(739) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_zeile_duplizieren), $EditMenu) ;duplizieren
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 840)
$EditMenu_item11 = _GUICtrlCreateODMenuItem(_Get_langstr(328) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_auskommentieren), $EditMenu) ;commentout
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1508)
$EditMenu_TestSelectedCode = _GUICtrlCreateODMenuItem(_Get_langstr(1375) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Test_selected_Code), $EditMenu) ;Test selected Code
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 715)
$EditMenu_ShowCallTip = _GUICtrlCreateODMenuItem(_Get_langstr(1377) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Show_CallTip), $EditMenu) ;Show call tip
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1603 + 1)



;Menu Search
$Studiofenster_SearchMenu = GUICtrlCreateMenu(_Get_langstr(1376))
$EditMenu_item7 = _GUICtrlCreateODMenuItem(_Get_langstr(115) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Suche), $Studiofenster_SearchMenu) ;search
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 858)
$Tools_menu_In_Dateien_suchen = _GUICtrlCreateODMenuItem(_Get_langstr(1189) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_In_Dateien_Suchen), $Studiofenster_SearchMenu) ;In Dateien Suchen
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 858)

_GUICtrlCreateODMenuItem("", $Studiofenster_SearchMenu)

$EditMenu_zeile_bookmarken_Main = _GUICtrlCreateODMenu(_Get_langstr(1307), $Studiofenster_SearchMenu) ;Zeile Bookmarken (Main)
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 69)
$EditMenu_zeile_bookmarken = _GUICtrlCreateODMenuItem(_Get_langstr(1203) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken), $EditMenu_zeile_bookmarken_Main) ;Zeile Bookmarken
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 69)
$EditMenu_zeile_bookmarken_naechste_Zeile = _GUICtrlCreateODMenuItem(_Get_langstr(1308) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Naechstes_Bookmark), $EditMenu_zeile_bookmarken_Main) ;Nächste Bookmarkzeile
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 69)
$EditMenu_zeile_bookmarken_vorherige_Zeile = _GUICtrlCreateODMenuItem(_Get_langstr(1309) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark), $EditMenu_zeile_bookmarken_Main) ;Vorherige Bookmarkzeile
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 69)
$EditMenu_zeile_bookmarken_Alle_Entfernen = _GUICtrlCreateODMenuItem(_Get_langstr(1310) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_alle_loeschen), $EditMenu_zeile_bookmarken_Main) ;Alle Bookmarks entfernen
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 69)

$EditMenu_item9 = _GUICtrlCreateODMenuItem(_Get_langstr(116) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_springezuzeile), $Studiofenster_SearchMenu) ;gotoline
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 532)
$EditMenu_springe_zu_func = _GUICtrlCreateODMenuItem(_Get_langstr(1106) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Springe_zu_Func), $Studiofenster_SearchMenu) ;Springe zu Func
If $ISN_Dark_Mode = "true" Then
	_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1394)
Else
	_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1807)
EndIf


;Menü Ansicht
$AnsichtMenu = GUICtrlCreateMenu(_Get_langstr(1014)) ;_GUICtrlCreateODTopMenu(_Get_langstr(1014),$Studiofenster)
$FileMenu_item11 = _GUICtrlCreateODMenuItem(_Get_langstr(457) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_vollbild), $AnsichtMenu) ;Fullscreenmode
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 447)
$AnsichtMenu_reset_Views = _GUICtrlCreateODMenuItem(_Get_langstr(1371), $AnsichtMenu) ;Reset views
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 170)
_GUICtrlCreateODMenuItem("", $AnsichtMenu)
$AnsichtMenu_fenster_links_umschalten = _GUICtrlCreateODMenuItem(_Get_langstr(1015) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_linkes_fenster_umschalten), $AnsichtMenu) ;Fenster links umschalten
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 584)
$AnsichtMenu_fenster_rechts_umschalten = _GUICtrlCreateODMenuItem(_Get_langstr(1016) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_rechtes_fenster_umschalten), $AnsichtMenu) ;Fenster rechts umschalten
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 586)
$AnsichtMenu_fenster_unten_umschalten = _GUICtrlCreateODMenuItem(_Get_langstr(1011) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_unteres_fenster_umschalten), $AnsichtMenu) ;Fenster unten umschalten
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 627)
_GUICtrlCreateODMenuItem("", $AnsichtMenu) ;sep



$EditMenu_Fold_Main = _GUICtrlCreateODMenu(_Get_langstr(1400), $AnsichtMenu) ;Fold Main
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 64)
$ViewMenu_Expand_Codesegments = _GUICtrlCreateODMenuItem(_Get_langstr(1395) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Expand_AllCodesegments), $EditMenu_Fold_Main) ;Expand all code segments
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 64)
$ViewMenu_Contract_Codesegments = _GUICtrlCreateODMenuItem(_Get_langstr(1394) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Contract_AllCodesegments), $EditMenu_Fold_Main) ;contract all code segments
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 64)
_GUICtrlCreateODMenuItem("", $EditMenu_Fold_Main) ;sep
$ViewMenu_Expand_Regions = _GUICtrlCreateODMenuItem(_Get_langstr(1402) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Expand_Regions), $EditMenu_Fold_Main) ;Expand all regions
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 64)
$ViewMenu_Contract_Regions = _GUICtrlCreateODMenuItem(_Get_langstr(1401) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Contract_Regions), $EditMenu_Fold_Main) ;contract all regions
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 64)

$EditMenu_Kommentare_ausblenden = _GUICtrlCreateODMenuItem(_Get_langstr(1172) & @TAB & _Keycode_zu_Text($Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden), $AnsichtMenu) ;Kommentare ausblenden / einblenden
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1524)
$ViewMenu_ScriptEditor_DisplayIndentationGuides = _GUICtrlCreateODMenuItem(_Get_langstr(1382), $AnsichtMenu, "", 0)
$ViewMenu_ShowLineNumbers = _GUICtrlCreateODMenuItem(_Get_langstr(203), $AnsichtMenu, "", 0)
$ViewMenu_ScriptEditor_FoldMargin = _GUICtrlCreateODMenuItem(_Get_langstr(1378), $AnsichtMenu, "", 0)
$ViewMenu_ScriptEditor_BookmarkMargin = _GUICtrlCreateODMenuItem(_Get_langstr(1379), $AnsichtMenu, "", 0)
$ViewMenu_ScriptEditor_DisplayWhitespace = _GUICtrlCreateODMenuItem(_Get_langstr(1380), $AnsichtMenu, "", 0)
$ViewMenu_ScriptEditor_DisplayEndofLine = _GUICtrlCreateODMenuItem(_Get_langstr(1381), $AnsichtMenu, "", 0)






;Menü Tools
$ToolsMenu = GUICtrlCreateMenu(_Get_langstr(607)) ;_GUICtrlCreateODTopMenu(_Get_langstr(607),$Studiofenster)
$EditMenu_item8 = _GUICtrlCreateODMenuItem(_Get_langstr(108) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_syntaxcheck), $ToolsMenu) ;syntax
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1238)
$EditMenu_item10 = _GUICtrlCreateODMenuItem(_Get_langstr(327) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Tidy), $ToolsMenu) ;tidysource
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1375)
$Tools_menu_debugging = _GUICtrlCreateODMenu(_Get_langstr(728), $ToolsMenu) ;Debugging
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1791)
$Tools_menu_debugging_erweitertes_debugging = _GUICtrlCreateODMenu(_Get_langstr(800), $Tools_menu_debugging, $smallIconsdll, 1791) ;Erweitertes_Debugging
$Tools_menu_debugging_erweitertes_debugging_aktivieren = _GUICtrlCreateODMenuItem(_Get_langstr(801), $Tools_menu_debugging_erweitertes_debugging, "", 0) ;Erweitertes_Debugging Aktivieren
$Tools_menu_debugging_erweitertes_debugging_deaktivieren = _GUICtrlCreateODMenuItem(_Get_langstr(802), $Tools_menu_debugging_erweitertes_debugging, "", 0) ;Erweitertes_Debugging Deaktivieren
GUICtrlSetState(-1, $GUI_CHECKED)
_GUICtrlCreateODMenuItem("", $Tools_menu_debugging)
$Tools_menu_debugging_debugtoMsgBox = _GUICtrlCreateODMenuItem(_Get_langstr(727) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox), $Tools_menu_debugging, $smallIconsdll, 1791) ;DebugToMsgbox
$Tools_menu_debugging_debugtoConsole = _GUICtrlCreateODMenuItem(_Get_langstr(729) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole), $Tools_menu_debugging, $smallIconsdll, 1791) ;DebugToConsole

$Tools_menu_item1 = _GUICtrlCreateODMenuItem(_Get_langstr(608) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_msgBoxGenerator), $ToolsMenu) ;msgboxgenerator
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 819)
$Tools_menu_item2 = _GUICtrlCreateODMenuItem(_Get_langstr(609) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Fensterinfotool), $ToolsMenu) ;window info tool
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 745)
$Tools_menu_item8 = _GUICtrlCreateODMenuItem(_Get_langstr(651) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Farbtoolbox), $ToolsMenu) ;colour picker
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1509)
$Tools_menu_createUDFheader = _GUICtrlCreateODMenuItem(_Get_langstr(730) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_erstelleUDFheader), $ToolsMenu) ;erstelle UDF-Header
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1457)
;~ $Tools_menu_organizeincludes = _GUICtrlCreateODMenuItem(_Get_langstr(796) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_organizeincludes), $ToolsMenu) ;organizeincludes
;~ _GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1280)
$Tools_menu_AutoIt3Wrapper_GUI = _GUICtrlCreateODMenuItem(_Get_langstr(751) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_AutoIt3WrapperGUI), $ToolsMenu) ;AutoIt3Wrapper_GUI
_GUICtrlODMenuItemSetIcon(-1, @ScriptDir & "\Data\AutoIt3Wrapper\AutoIt3Wrapper.ico", 0)

If $Tools_Bitrechner_aktiviert = "true" Then
	$Tools_menu_bitrechner = _GUICtrlCreateODMenuItem(_Get_langstr(813) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_bitrechner), $ToolsMenu) ;Bitrechner
	_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1898)
Else
	$Tools_menu_bitrechner = "" ;Bitrechner
EndIf

If $Tools_Parameter_Editor_aktiviert = "true" Then
	$Tools_menu_ParameterEditor = _GUICtrlCreateODMenuItem(_Get_langstr(1037) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor), $ToolsMenu) ;Parameter Editor
	_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1615)
Else
	$Tools_menu_ParameterEditor = "" ;Parameter Editor
EndIf

If $Tools_PELock_Obfuscator_aktiviert = "true" Then
	$Tools_menu_PELock_Obfuscator = _GUICtrlCreateODMenuItem(_Get_langstr(1206) & @TAB & _Keycode_zu_Text($Hotkey_PElock_Obfuscator), $ToolsMenu) ;PELock_Obfuscator
	_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1926)
Else
	$Tools_menu_PELock_Obfuscator = "" ;PELock_Obfuscator
EndIf


_GUICtrlCreateODMenuItem("", $ToolsMenu)

$Tools_menu_item3 = _GUICtrlCreateODMenuItem(_Get_langstr(611) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot1), $ToolsMenu) ;makroslot 1
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 0)
$Tools_menu_item4 = _GUICtrlCreateODMenuItem(_Get_langstr(612) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot2), $ToolsMenu) ;makroslot 2
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 909)
$Tools_menu_item5 = _GUICtrlCreateODMenuItem(_Get_langstr(613) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot3), $ToolsMenu) ;makroslot 3
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1020)
$Tools_menu_item6 = _GUICtrlCreateODMenuItem(_Get_langstr(614) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot4), $ToolsMenu) ;makroslot 4
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1130)
$Tools_menu_item7 = _GUICtrlCreateODMenuItem(_Get_langstr(615) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot5), $ToolsMenu) ;makroslot 5
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1241)

$Tools_menu_item9 = _GUICtrlCreateODMenuItem(_Get_langstr(906) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot6), $ToolsMenu) ;makroslot 6
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1345)
$Tools_menu_item10 = _GUICtrlCreateODMenuItem(_Get_langstr(907) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot7), $ToolsMenu) ;makroslot 7
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1456)



;Menü Help
$HelpMenu = GUICtrlCreateMenu(_Get_langstr(606)) ;_GUICtrlCreateODTopMenu(_Get_langstr(606),$Studiofenster)
$HelpMenu_item1 = _GUICtrlCreateODMenuItem(_Get_langstr(174) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe), $HelpMenu) ;autoithelp
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1400)
$HelpMenu_item2 = _GUICtrlCreateODMenuItem(_Get_langstr(175), $HelpMenu) ;isn help
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1400)
_GUICtrlCreateODMenuItem("", $HelpMenu)

$HelpMenu_item6 = _GUICtrlCreateODMenuItem(_Get_langstr(434), $HelpMenu) ;Bugtracker
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1790)
$HelpMenu_Forum = _GUICtrlCreateODMenuItem(_Get_langstr(963), $HelpMenu) ;Forum
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1270)
$HelpMenu_spenden = _GUICtrlCreateODMenuItem(_Get_langstr(666), $HelpMenu) ;Spenden
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1503)
$HelpMenu_item3 = _GUICtrlCreateODMenuItem(_Get_langstr(261), $HelpMenu) ;trophys
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1914)
$HelpMenu_item7 = _GUICtrlCreateODMenuItem(_Get_langstr(350), $HelpMenu) ;search updates
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 763)
_GUICtrlCreateODMenuItem("", $HelpMenu) ;sep
$HelpMenu_item4 = _GUICtrlCreateODMenuItem(_Get_langstr(176) & " " & _Get_langstr(1), $HelpMenu) ;Über
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1597)
$HelpMenu_item5 = _GUICtrlCreateODMenuItem(_Get_langstr(178), $HelpMenu) ;Version Information
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1491)



Global $hImage = _GUIImageList_Create(16, 16, 5, 1)
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1343) ;ordner
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1282) ;file
_GUIImageList_AddIcon($hImage, $smallIconsdll, 707) ;movie
_GUIImageList_AddIcon($hImage, $smallIconsdll, 705) ;sound
_GUIImageList_AddIcon($hImage, $smallIconsdll, 818) ;exe
_GUIImageList_AddIcon($hImage, $smallIconsdll, 652) ;the projectroot
_GUIImageList_AddIcon($hImage, $smallIconsdll, 30) ;image
_GUIImageList_AddIcon($hImage, $smallIconsdll, 728) ;doc
_GUIImageList_AddIcon($hImage, $smallIconsdll, 729) ;ppt
_GUIImageList_AddIcon($hImage, $smallIconsdll, 730) ;xls
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1788) ;au3
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1177) ;txt
_GUIImageList_AddIcon($hImage, $smallIconsdll, 780) ;isf
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1176) ;ini|inf|isn
_GUIImageList_AddIcon($hImage, $smallIconsdll, 786) ;isn
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1699) ;dll
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1057) ;ico
_GUIImageList_AddIcon($hImage, $smallIconsdll, 818) ;bat
If $ISN_Dark_Mode = "true" Then
	_GUIImageList_AddIcon($hImage, $smallIconsdll, 1634) ;global variables (dark)
	_GUIImageList_AddIcon($hImage, $smallIconsdll, 1393) ;funcs (dark) ;19
Else
	_GUIImageList_AddIcon($hImage, $smallIconsdll, 1096) ;global variables (while)
	_GUIImageList_AddIcon($hImage, $smallIconsdll, 1806) ;funcs (while) ;19
EndIf
;controls
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1794) ;button
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1813) ;label
_GUIImageList_AddIcon($hImage, $smallIconsdll, 795) ;input
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1360) ;checkbox
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1174) ;radio
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1818) ;image
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1824) ;slider
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1819) ;progress
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1163) ;updown
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1081) ;icon
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1798) ;combo
_GUIImageList_AddIcon($hImage, $smallIconsdll, 91) ;edit
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1809) ;group
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1814) ;listbox
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1077) ;tab
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1802) ;date
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1795) ;calendar
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1815) ;listview
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1279) ;include ;38
_GUIImageList_AddIcon($hImage, @ScriptDir & "\autoitstudioicon.ico", 0) ;isn icon

;config & diverses
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1785) ;au3
_GUIImageList_AddIcon($hImage, $smallIconsdll, 323) ;backup
_GUIImageList_AddIcon($hImage, $smallIconsdll, 202) ;pfade
_GUIImageList_AddIcon($hImage, $smallIconsdll, 192) ;plugins
_GUIImageList_AddIcon($hImage, $smallIconsdll, 762) ;sprache

_GUIImageList_AddIcon($hImage, $smallIconsdll, 117) ;regions
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1031) ;darstellung ;46
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1432) ;ip
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1189) ;softbutton
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1085) ;skin
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1914) ;erweitert
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1716) ;treeview ;51

_GUIImageList_AddIcon($hImage, $smallIconsdll, 1548) ;macro
_GUIImageList_AddIcon($hImage, $smallIconsdll, 303) ;trigger
_GUIImageList_AddIcon($hImage, $smallIconsdll, 337) ;action
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1911) ;hotkeys
_GUIImageList_AddIcon($hImage, $smallIconsdll, 398) ;update ;56
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1910) ;Farben
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1913) ;Trophy
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1915) ;menu
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1920) ;toolbar ;60
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1374) ;tidySource

;Für Hotkeys
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1286) ;Datei öffnen
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1301) ;Speichern
_GUIImageList_AddIcon($hImage, $smallIconsdll, 285) ;Alle Speichern
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1917) ;Tab schließen
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1563) ;vorheriger Tab
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1564) ;nächster Tab
_GUIImageList_AddIcon($hImage, $smallIconsdll, 446) ;vollbild
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1507) ;auskommentieren
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1399) ;hilfe ;70
_GUIImageList_AddIcon($hImage, $smallIconsdll, 531) ;Springe zu Zeile
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1237) ;Syntax Check
_GUIImageList_AddIcon($hImage, $smallIconsdll, 527) ;compile
_GUIImageList_AddIcon($hImage, $smallIconsdll, 529) ;compile Einstellungen
_GUIImageList_AddIcon($hImage, $smallIconsdll, 13) ;Skript testen
_GUIImageList_AddIcon($hImage, $smallIconsdll, 220) ;Projekt testen
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1282) ;Neue Datei
_GUIImageList_AddIcon($hImage, $smallIconsdll, 857) ;Suche
_GUIImageList_AddIcon($hImage, $smallIconsdll, 0) ;Makroslot1
_GUIImageList_AddIcon($hImage, $smallIconsdll, 908) ;Makroslot2 ;80
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1019) ;Makroslot3
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1129) ;Makroslot4
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1240) ;Makroslot5
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1344) ;Makroslot6
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1455) ;Makroslot7
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1790) ;Debug MSGBox & Console
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1456) ;UDF Header
_GUIImageList_AddIcon($hImage, @ScriptDir & "\Data\AutoIt3Wrapper\AutoIt3Wrapper.ico", 0) ;au3 wrapper
_GUIImageList_AddIcon($hImage, $smallIconsdll, 818) ;MsgBoxGenerator
_GUIImageList_AddIcon($hImage, $smallIconsdll, 839) ;Zeile Duplizieren ;90
_GUIImageList_AddIcon($hImage, $smallIconsdll, 744) ;Fenster Info Tool
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1897) ;Bitrechner
_GUIImageList_AddIcon($hImage, $smallIconsdll, 824) ;Umbenennen
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1724) ;Änderungsprotokolle
_GUIImageList_AddIcon($hImage, $smallIconsdll, 626) ;Fenster unten umschalten
_GUIImageList_AddIcon($hImage, $smallIconsdll, 583) ;Fenster links umschalten
_GUIImageList_AddIcon($hImage, $smallIconsdll, 585) ;Fenster rechts umschalten
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1614) ;Parameter Editor
_GUIImageList_AddIcon($hImage, $smallIconsdll, 10) ;Projekteigenschaften
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1393) ;Springe zur Funk ;100
_GUIImageList_AddIcon($hImage, $smallIconsdll, 231) ;Dateitypen
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1405) ;APIs
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1523) ;Kommentare ausblenden
_GUIImageList_AddIcon($hImage, $smallIconsdll, 829) ;Zeile nach oben verschieben
_GUIImageList_AddIcon($hImage, $smallIconsdll, 833) ;Zeile nach unten verschieben
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1923) ;Ordner (Grau)
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1785) ;AutoIt Pfade
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1176) ;Com
_GUIImageList_AddIcon($hImage, $smallIconsdll, 590) ;Dummy
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1919) ;Toolbar
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1920) ;Statusbar
_GUIImageList_AddIcon($hImage, $smallIconsdll, 471) ;Graphic
_GUIImageList_AddIcon($hImage, $smallIconsdll, 743) ;Tools ;113
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1925) ;PELock Obfuscator
_GUIImageList_AddIcon($hImage, $smallIconsdll, 68) ;Zeilen markieren
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1797) ;ToDo Liste
_GUIImageList_AddIcon($hImage, $smallIconsdll, 394) ;notes
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1827) ;Log
_GUIImageList_AddIcon($hImage, $smallIconsdll, 791) ;Quickview
_GUIImageList_AddIcon($hImage, $smallIconsdll, 446) ;display and windows ;120
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1603) ;show calltip
_GUIImageList_AddIcon($hImage, $smallIconsdll, 63) ;expand code segments
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1094) ;close project
_GUIImageList_AddIcon($hImage, $smallIconsdll, 1788) ;udf-explorer
_GUIImageList_AddIcon($hImage, $smallIconsdll, 714) ;test selected code




_GUICtrlTreeView_SetNormalImageList($hTreeview, $hImage)

Global $QuickView_title = GUICtrlCreateLabel(" " & _Get_langstr(1204), 2, 85, 300 * $DPI, 19 * $DPI, $SS_SUNKEN + $SS_CENTER)
GUICtrlSetOnEvent(-1, "_Toggle_hide_leftbar")
GUICtrlSetBkColor(-1, $Skriptbaum_Header_Hintergrundfarbe)
GUICtrlSetColor(-1, $Skriptbaum_Header_Schriftfarbe)
If $DPI = 1 Then
	GUICtrlSetFont($QuickView_title, 8, 400, 0, "Arial")
Else
	GUICtrlSetFont($QuickView_title, Default, 400, 0, "Arial")
EndIf


$htemp = ControlGetPos($StudioFenster, "", $hTreeview)
Global $QuickView_Dummy_Control = GUICtrlCreateLabel("", 2, 100, 100, 100)
GUICtrlSetState($QuickView_Dummy_Control, $GUI_Disable)
GUICtrlSetState($QuickView_Dummy_Control, $GUI_HIDE)


; create the rebar control
$ISNReBar = _GUICtrlRebar_Create($StudioFenster, BitOR($CCS_TOP, $WS_BORDER, $RBS_VARHEIGHT, $RBS_AUTOSIZE, $CCS_VERT, $RBS_FIXEDORDER))

;##TOOLBAR##
If $ISN_Use_Vertical_Toolbar = "false" Then
	Global $hToolbar = _GUICtrlToolbar_Create($StudioFenster)
Else
	Global $hToolbar = _GUICtrlToolbar_Create($StudioFenster, $TBSTYLE_WRAPABLE)
EndIf
_ISN_Toolbar_Set_IconSize()
;Tooltip für Toolbar
Global $Toolbar_ToolTip = _GUIToolTip_Create($hToolbar)
_GUICtrlToolbar_SetToolTips($hToolbar, $Toolbar_ToolTip)

$Toolbar_Size = _GUICtrlToolbar_GetButtonSize($hToolbar)
If Not IsArray($Toolbar_Size) Then Exit




Global $hTreeview = GUICtrlCreateTreeView(2, $Toolbar_Size[0] + ((30 + $Titel_DPI_Dif)), 300, ($size[3] - 80) - 200)
GUICtrlSetStyle(-1, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS), BitOR($WS_EX_COMPOSITED, $WS_EX_CLIENTEDGE))
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetFont($hTreeview, $treefont_size, 400, 0, $treefont_font)
GUICtrlSetColor($hTreeview, $treefont_colour)
Global $hWndTreeview = GUICtrlGetHandle($hTreeview)
GUICtrlSetData($startup_progress, 30)

Global $Projecttree_title = GUICtrlCreateLabel(" " & _Get_langstr(468), 2, 35, 300 * $DPI, 19 * $DPI, $SS_SUNKEN + $SS_CENTER)
GUICtrlSetOnEvent($Projecttree_title, "_Toggle_hide_leftbar")
GUICtrlSetBkColor($Projecttree_title, $Skriptbaum_Header_Hintergrundfarbe)
GUICtrlSetColor($Projecttree_title, $Skriptbaum_Header_Schriftfarbe)
If $DPI = 1 Then
	GUICtrlSetFont($Projecttree_title, 8, 400, 0, "Arial")
Else
	GUICtrlSetFont($Projecttree_title, Default, 400, 0, "Arial")
EndIf



; Add Icons from system DLL shell32.dll to ImageList
If $DPI > 1.49 Then ;Ab 150% DPI skalierung die Icons in der Toolbar vergrößern (Auch wenn es nicht schön aussieht)
	$hToolbarImageListNorm = _GUIImageList_Create(24, 24, 5, 3)
Else
	$hToolbarImageListNorm = _GUIImageList_Create(16, 16, 5, 3)
EndIf

;~ _GUIImageList_AddMasked($hImage, _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 0xfcfcfc,110))


_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1282) ;neue datei
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1343) ;newfolder
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 377) ;import
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1089) ;importfolder
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 415) ;export
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1173) ;delete
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 997) ;projecttree
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 220) ;testproject
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 527) ;compile
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 10) ;egenschaften
If $ISN_Use_Vertical_Toolbar = "false" Then
	_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1918) ;seperator
Else
	_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1934) ;seperator (vertical)
EndIf
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1301) ;save ;11
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 727) ;undo
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 193) ;redo
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1917) ;closetab
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 13) ;testscript
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 857) ;search
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 534) ;stopproject
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1237) ;syntaxcheck
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1374) ;tidySource
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 446) ;fullscreenmode ;20
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1507) ;commentout
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1548) ;rule
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 744) ;infotool
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 0) ;custom rule 1
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 908) ;custom rule 2
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1019) ;custom rule 3
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1129) ;custom rule 4
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1240) ;custom rule 5
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 285) ;save all tabs
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1344) ;custom rule 6 ;30
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1455) ;custom rule 7
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1724) ;änderungsprotokolle
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1080) ;Programmeinstellungen
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1910) ;Farben
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1094) ;Close Project
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1082) ;Projekteinstellungen
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1797) ;to-do
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1827) ;log
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 192) ;plugin
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 394) ;notes 40
_GUIImageList_AddIcon($hToolbarImageListNorm, $smallIconsdll, 1788) ;udf-explorer
_GUIImageList_SetBkColor($hToolbarImageListNorm, 0xFF0000)








If $Save_Mode = "false" Then
	GUICtrlSetData($startup_text, _Get_langstr(463))
	_Write_ISN_Debug_Console("|--> Loading Plugins...", 1, 0)
	_Plugins_ordner_pruefen()
	_Load_Plugins()
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
	GUICtrlSetData($startup_progress, 80)
Else
	_Write_ISN_Debug_Console("|--> Loading Plugins...", 1, 0)
	_Write_ISN_Debug_Console("ERROR (SAFEMODE)", 3, 1, 1, 1)
EndIf

GUICtrlSetData($startup_text, _Get_langstr(462))
_Write_ISN_Debug_Console("|--> Draw GUI...", 1, 0)
_Toolbar_nach_layout_anordnen() ;Draw the toolbar

$Abgrenzung_nach_toolbar_Y = $Toolbar_Size[0] + 3
If $ISN_Use_Vertical_Toolbar = "true" Then $Abgrenzung_nach_toolbar_Y = 3

$Abgrenzung_nach_toolbar = GUICtrlCreateLabel("", -10, $Abgrenzung_nach_toolbar_Y, 9999, 2, -1, $SS_BLACKFRAME) ;Abgrenzungslinie nach der Toolbar
GUICtrlSetState(-1, $GUI_HIDE)
$Abgrenzung_vor_statusbar = GUICtrlCreateLabel("", -10, $size[3] - 80, 9999, 2, -1, $SS_BLACKFRAME) ;Abgrenzungslinie vor der Statusbar
;~ GUICtrlSetState(-1,$GUI_HIDE)



;##TOOLBAR_END##
GUICtrlSetData($startup_progress, 40)
;~ Global $Debug_log =_ChatBoxCreate($StudioFenster, "", 2, 100, 100, 100, 0xFFFFFF, true)

Global $Debug_log = Sci_CreateEditor($StudioFenster, 400, 600, 200, 300)
_Sci_DebugWindowStyle($Debug_log)
SendMessage($Debug_log, $SCI_SETREADONLY, False, 0)

If $Skin_is_used = "true" Then
	Global $Debug_Log_Undo_Button = GUICtrlCreateButton("", 150, 53, 20, 20, $BS_ICON)
	_GUICtrlButton_SetImage($Debug_Log_Undo_Button, $smallIconsdll, 727, False)
Else
	Global $Debug_Log_Undo_Button = GUICtrlCreateButton("", 1150, 53, 20, 20)
	Button_AddIcon(-1, $smallIconsdll, 727, 4)
EndIf
GUICtrlSetOnEvent(-1, "_Debug_log_try_undo")
_GUIToolTip_AddTool($hToolTip_StudioFenster, 0, _Get_langstr(1029), GUICtrlGetHandle($Debug_Log_Undo_Button))

If $Skin_is_used = "true" Then
	Global $Debug_Log_Redo_Button = GUICtrlCreateButton("", 1150, 53, 20, 20, $BS_ICON)
	_GUICtrlButton_SetImage($Debug_Log_Redo_Button, $smallIconsdll, 193, False)
Else
	Global $Debug_Log_Redo_Button = GUICtrlCreateButton("", 1150, 53, 20, 20)
	Button_AddIcon(-1, $smallIconsdll, 193, 4)
EndIf
GUICtrlSetOnEvent(-1, "_Debug_log_try_redo")
_GUIToolTip_AddTool($hToolTip_StudioFenster, 0, _Get_langstr(1030), GUICtrlGetHandle($Debug_Log_Redo_Button))



If $Skin_is_used = "true" Then
	Global $Debug_Log_Zwischenablage_Button = GUICtrlCreateButton("", 1150, 53, 20, 20, $BS_ICON)
	_GUICtrlButton_SetImage($Debug_Log_Zwischenablage_Button, $smallIconsdll, 1087, False)
Else
	Global $Debug_Log_Zwischenablage_Button = GUICtrlCreateButton("", 1150, 53, 20, 20)
	Button_AddIcon(-1, $smallIconsdll, 1087, 4)
EndIf
GUICtrlSetOnEvent(-1, "_Debug_Inahlt_in_Zwischenablage")
_GUIToolTip_AddTool($hToolTip_StudioFenster, 0, _Get_langstr(1031), GUICtrlGetHandle($Debug_Log_Zwischenablage_Button))


Global $Left_Splitter_X = GUICtrlCreateLabel("", 30, 30, $Splitter_Breite, $size[3] - 80, -1, $SS_BLACKFRAME) ;Links X

GUICtrlSetCursor(-1, 13)
GUICtrlSetOnEvent($Left_Splitter_X, "_move_Splitter")

Global $htab = GUICtrlCreateTab(400, 29, 400, $size[3] - 80 - 200)
GUICtrlSetBkColor(-1, 0xFF0000)
GUICtrlSetFont(-1, $Default_font_size, $Default_font)
GUICtrlSetOnEvent(-1, "_Editor_Switch_Tab")
_GUICtrlTab_SetImageList($htab, $hImage)
_GUIToolTip_AddTool($hToolTip_StudioFenster, 0, "", GUICtrlGetHandle($htab))



$tabsize = ControlGetPos($StudioFenster, "", $htab)
GUICtrlSetPos($htab, $tabsize[0], 29)




;Info Controls for undocked Tabs
$ISN_Undocked_Tab_Info_Label = GUICtrlCreateLabel(_Get_langstr(1366), -1000, -1000, 200, 32)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 16, 400, 0, $Default_font)
GUICtrlSetColor(-1, $Titel_Schriftfarbe)
GUICtrlSetState($ISN_Undocked_Tab_Info_Label, $GUI_HIDE)
$ISN_Undocked_Tab_Info_Icon = GUICtrlCreatePic("", -1000, -1000, 32, 32)
_SetIconAlpha($ISN_Undocked_Tab_Info_Icon, $bigiconsdll, 70 + 1, 32, 32)
GUICtrlSetState($ISN_Undocked_Tab_Info_Icon, $GUI_HIDE + $GUI_DISABLE)
$ISN_Undocked_Tab_Info_ReDock_Button = GUICtrlCreateButton(_Get_langstr(1365), -1000, -1000, 450, 35)
Button_AddIcon(-1, $smallIconsdll, 928, 0)
GUICtrlSetOnEvent(-1, "_ISN_ReDock_Current_Tab")


;Tabmenu
$TabContextMenu = GUICtrlCreateContextMenu($htab)
$TabContextMenu_Item1 = _GUICtrlCreateODMenuItem(_Get_langstr(9) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern), $TabContextMenu, $smallIconsdll, 1302) ;Save
$TabContextMenu_UndockTab = _GUICtrlCreateODMenuItem(_Get_langstr(1364), $TabContextMenu, $smallIconsdll, 808 + 1) ;undock tab
$TabContextMenu_Item2 = _GUICtrlCreateODMenuItem(_Get_langstr(80) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_tab_schliessen), $TabContextMenu, $smallIconsdll, 1918) ;Closetab
$TabContextMenu_Item5 = _GUICtrlCreateODMenuItem(_Get_langstr(806), $TabContextMenu, $smallIconsdll, 1804) ;Close all  tabs
_GUICtrlCreateODMenuItem("", $TabContextMenu)
$TabContextMenu_Item3 = _GUICtrlCreateODMenuItem(_Get_langstr(398), $TabContextMenu, $smallIconsdll, 1265) ;showinexplorer
$TabContextMenu_Item4 = _GUICtrlCreateODMenuItem(_Get_langstr(68), $TabContextMenu, $smallIconsdll, 11) ;eigenschaften

;Full Skripteditor contextmenu
$ScripteditorContextMenu_dummy = GUICtrlCreateDummy()
$ScripteditorContextMenu = GUICtrlCreateContextMenu($ScripteditorContextMenu_dummy)
$SCI_EDITOR_CONTEXT_speichern = _GUICtrlCreateODMenuItem(_Get_langstr(9) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern), $ScripteditorContextMenu, $smallIconsdll, 1302) ;save
_GUICtrlCreateODMenuItem("", $ScripteditorContextMenu) ;sep
$SCI_EDITOR_CONTEXT_suche = _GUICtrlCreateODMenuItem(_Get_langstr(115) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Suche), $ScripteditorContextMenu, $smallIconsdll, 858) ;Suche
$SCI_EDITOR_CONTEXT_oeffneHilfe = _GUICtrlCreateODMenuItem(_Get_langstr(648) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe), $ScripteditorContextMenu, $smallIconsdll, 1400) ;show help
$SCI_EDITOR_CONTEXT_oeffneInclude = _GUICtrlCreateODMenuItem(_Get_langstr(508) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Oeffne_Include), $ScripteditorContextMenu, $smallIconsdll, 1280) ;openinclude
If $Tools_Parameter_Editor_aktiviert = "true" Then
	$SCI_EDITOR_CONTEXT_ParameterEditor = _GUICtrlCreateODMenuItem(_Get_langstr(1037) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor), $ScripteditorContextMenu, $smallIconsdll, 1615) ;ParameterEditor
Else
	$SCI_EDITOR_CONTEXT_ParameterEditor = "" ;ParameterEditor
EndIf
_GUICtrlCreateODMenuItem("", $ScripteditorContextMenu) ;sep
$SCI_EDITOR_CONTEXT_rueckgaengig = _GUICtrlCreateODMenuItem(_Get_langstr(55) & @TAB & "Ctrl+Z", $ScripteditorContextMenu, $smallIconsdll, 728) ;Rückgängig
$SCI_EDITOR_CONTEXT_wiederholen = _GUICtrlCreateODMenuItem(_Get_langstr(56) & @TAB & "Ctrl+Y", $ScripteditorContextMenu, $smallIconsdll, 194) ;Wiederholen
_GUICtrlCreateODMenuItem("", $ScripteditorContextMenu) ;sep
$SCI_EDITOR_CONTEXT_select_all = _GUICtrlCreateODMenuItem(_Get_langstr(1341) & @TAB & "Ctrl+A", $ScripteditorContextMenu, $smallIconsdll, 311) ;Alles auswählen
$SCI_EDITOR_CONTEXT_ausschneiden = _GUICtrlCreateODMenuItem(_Get_langstr(110) & @TAB & "Ctrl+X", $ScripteditorContextMenu, $smallIconsdll, 1129) ;Ausschneiden
$SCI_EDITOR_CONTEXT_kopieren = _GUICtrlCreateODMenuItem(_Get_langstr(111) & @TAB & "Ctrl+C", $ScripteditorContextMenu, $smallIconsdll, 1088) ;Kopieren
$SCI_EDITOR_CONTEXT_einfuegen = _GUICtrlCreateODMenuItem(_Get_langstr(112) & @TAB & "Ctrl+V", $ScripteditorContextMenu, $smallIconsdll, 9) ;Einfügen
$SCI_EDITOR_CONTEXT_loeschen = _GUICtrlCreateODMenuItem(_Get_langstr(113) & @TAB & "Del", $ScripteditorContextMenu, $smallIconsdll, 1180) ;Löschen
_GUICtrlCreateODMenuItem("", $ScripteditorContextMenu) ;sep

$SCI_EDITOR_CONTEXT_testselectedcode = _GUICtrlCreateODMenuItem(_Get_langstr(1375) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Test_selected_Code), $ScripteditorContextMenu, $smallIconsdll, 715) ;Test selected code
$SCI_EDITOR_CONTEXT_debug = _GUICtrlCreateODMenu(_Get_langstr(728), $ScripteditorContextMenu) ;Debugging
_GUICtrlODMenuItemSetIcon(-1, $smallIconsdll, 1791)
$SCI_EDITOR_CONTEXT_debugtoMsgBox = _GUICtrlCreateODMenuItem(_Get_langstr(727) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox), $SCI_EDITOR_CONTEXT_debug, $smallIconsdll, 1791) ;DebugToMsgbox
$SCI_EDITOR_CONTEXT_debugtoConsole = _GUICtrlCreateODMenuItem(_Get_langstr(729) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole), $SCI_EDITOR_CONTEXT_debug, $smallIconsdll, 1791) ;DebugToConsole
$SCI_EDITOR_CONTEXT_drucken = _GUICtrlCreateODMenuItem(_Get_langstr(882), $ScripteditorContextMenu, $smallIconsdll, 1293) ;Drucken

$SCI_EDITOR_CONTEXT_Auskommentieren = _GUICtrlCreateODMenuItem(_Get_langstr(328) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_auskommentieren), $ScripteditorContextMenu, $smallIconsdll, 1508) ;comment out
_Erstelle_Kontextmenu_fuer_Projektbaum()

;Default Skripteditor contextmenu
$ScripteditorDefaultContextMenu_dummy = GUICtrlCreateDummy()
$ScripteditorDefaultContextMenu = GUICtrlCreateContextMenu($ScripteditorDefaultContextMenu_dummy)
$ScripteditorDefaultContextMenu_undo = _GUICtrlCreateODMenuItem(_Get_langstr(55) & @TAB & "Ctrl+Z", $ScripteditorDefaultContextMenu, $smallIconsdll, 728) ;Rückgängig
$ScripteditorDefaultContextMenu_redo = _GUICtrlCreateODMenuItem(_Get_langstr(56) & @TAB & "Ctrl+Y", $ScripteditorDefaultContextMenu, $smallIconsdll, 194) ;Wiederholen
_GUICtrlCreateODMenuItem("", $ScripteditorDefaultContextMenu) ;sep
$ScripteditorDefaultContextMenu_select_all = _GUICtrlCreateODMenuItem(_Get_langstr(1341) & @TAB & "Ctrl+A", $ScripteditorDefaultContextMenu, $smallIconsdll, 311) ;Alles auswählen
$ScripteditorDefaultContextMenu_cut = _GUICtrlCreateODMenuItem(_Get_langstr(110) & @TAB & "Ctrl+X", $ScripteditorDefaultContextMenu, $smallIconsdll, 1129) ;Ausschneiden
$ScripteditorDefaultContextMenu_copy = _GUICtrlCreateODMenuItem(_Get_langstr(111) & @TAB & "Ctrl+C", $ScripteditorDefaultContextMenu, $smallIconsdll, 1088) ;Kopieren
$ScripteditorDefaultContextMenu_paste = _GUICtrlCreateODMenuItem(_Get_langstr(112) & @TAB & "Ctrl+V", $ScripteditorDefaultContextMenu, $smallIconsdll, 9) ;Einfügen
$ScripteditorDefaultContextMenu_delete = _GUICtrlCreateODMenuItem(_Get_langstr(113) & @TAB & "Del", $ScripteditorDefaultContextMenu, $smallIconsdll, 1180) ;Löschen






Global $Right_Splitter_X = GUICtrlCreateLabel("", 60, 30, $Splitter_Breite, $size[3] - 80, -1, $SS_BLACKFRAME) ;Rechts X
GUICtrlSetResizing(-1, $GUI_DOCKALL)
If $hidefunctionstree = "true" Then GUICtrlSetPos($Right_Splitter_X, $size[2] - 5, 25, 4, $size[3] - 80)
GUICtrlSetCursor(-1, 13)
GUICtrlSetOnEvent($Right_Splitter_X, "_move_Splitter")


Global $hTreeview2 = GUICtrlCreateLabel("", 1100, $Toolbar_Size[0] + 56 + ($Titel_DPI_Dif + $Titel_DPI_Dif) * $DPI, 300, $size[3] - (78 + 32))
Global $hWndTreeview2 = GUICtrlGetHandle($hTreeview2)
GUICtrlSetBkColor($hTreeview2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState($hTreeview2, $GUI_DISABLE)
GUICtrlSetState($hTreeview2, $GUI_HIDE)


;~ Global $hTreeview2 = GUICtrlCreateTreeView(1100, $Toolbar_Size[0] + 56 + ($Titel_DPI_Dif + $Titel_DPI_Dif) * $DPI, 300, $size[3] - (78 + 32))
;~ If $Skin_is_used = "false" And Not _WinAPI_GetVersion() < '6.0' Then _WinAPI_SetWindowTheme(GUICtrlGetHandle($hTreeview2), 'Explorer')
;~ GUICtrlSetFont($hTreeview2, $treefont_size, 400, 0, $treefont_font)
;~ GUICtrlSetColor($hTreeview2, $treefont_colour)
;~ Global $hWndTreeview2 = GUICtrlGetHandle($hTreeview2)
;~ GUICtrlSetStyle($hTreeview2, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS), BitOR($WS_EX_COMPOSITED, $WS_EX_CLIENTEDGE))
;~ _GUICtrlTreeView_SetNormalImageList($hTreeview2, $hImage)


Global $Skriptbaum_Aktualisieren_Button = GUICtrlCreateLabel("", 1050, 53, 20, 20)
GUICtrlSetBkColor($Skriptbaum_Aktualisieren_Button, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_HIDE)
GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_DISABLE)

Global $Skriptbaum_Einstellungen_Button = GUICtrlCreateButton("", 1150, 53, 20, 20)
GUICtrlSetBkColor($Skriptbaum_Einstellungen_Button, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_HIDE)
GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_DISABLE)

Global $hTreeview2_searchinput = GUICtrlCreateLabel("", 1100, $Toolbar_Size[0] + ((30 + $Titel_DPI_Dif)), 200, 23 * $DPI)
GUICtrlSetBkColor($hTreeview2_searchinput, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState($hTreeview2_searchinput, $GUI_DISABLE)

Global $Scripttree_title = GUICtrlCreateLabel(" " & _Get_langstr(469), 1100, 35, 200, 19, $SS_SUNKEN + $SS_CENTER)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetOnEvent(-1, "_Toggle_hide_rightbar")
GUICtrlSetBkColor(-1, $Skriptbaum_Header_Hintergrundfarbe)
GUICtrlSetColor(-1, $Skriptbaum_Header_Schriftfarbe)
If $DPI = 1 Then
	GUICtrlSetFont($Scripttree_title, 8, 400, 0, "Arial")
Else
	GUICtrlSetFont($Scripttree_title, Default, 400, 0, "Arial")
EndIf

Global $Middle_Splitter_Y = GUICtrlCreateLabel("", 268, 30, 200, $Splitter_Breite, -1, $SS_BLACKFRAME) ;mitte Y
GUICtrlSetOnEvent(-1, "_move_Splitter")
GUICtrlSetResizing(-1, $GUI_DOCKALL)
If $hidedebug = "true" Then GUICtrlSetPos($Middle_Splitter_Y, 268, $size1[1] - 20, 200, 5)
GUICtrlSetCursor($Middle_Splitter_Y, 11)



Global $Left_Splitter_Y = GUICtrlCreateLabel("", 2, 30, 200, $Splitter_Breite, -1, $SS_BLACKFRAME) ;links Y
GUICtrlSetOnEvent(-1, "_move_Splitter")
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetCursor($Left_Splitter_Y, 11)

$HD_Logo = GUICtrlCreatePic(@ScriptDir & "\Data\wintop.jpg", 400, 28, 400, $size[3] - 80 - 200)
_SetImage(-1, @ScriptDir & "\Data\isn_logo_xl.png")
GUICtrlSetOnEvent(-1, "_topSec")
GUICtrlSetState($HD_Logo, $GUI_HIDE)

GUICtrlSetData($startup_progress, 55)
_Write_ISN_Debug_Console("done", 1, 1, 1, 1)

;Custom Includes
_Write_ISN_Debug_Console("|--> Loading Includes...", 1, 0)

_GDIPlus_Startup() ;GDI Plus starten
#include "includes\ISN_UDF_ButtonHover.au3"
#include "includes\ISN_Studio_Forms.au3"
#include "includes\ISN_Addon_Projectmanager.au3"
#include "includes\ISN_Addon_Macros.au3"
#include "includes\ISN_Addon_Macroeditor.au3"
#include "includes\ISN_Studio_Settings.au3"
#include "includes\ISN_Addon_Credits.au3"
#include "includes\ISN_Studio_Addons.au3"
#include "includes\ISN_Studio_WindowMessages.au3"
#include "includes\ISN_Addon_Projectsettings.au3"
#include "includes\ISN_Addon_Scintilla_Editor.au3"
#include "includes\ISN_Addon_Pluginsystem.au3"
#include "includes\ISN_Addon_Trophies.au3"
#include "includes\ISN_UDF_PDH_PerformanceCounters.au3"
#include "includes\ISN_UDF_WinTimeFunctions.au3" ; needed for certain value adjustments in retrieving Counter Values
#include "includes\ISN_UDF_WinAPI_GetSystemInfo.au3" ; _WinAPI_GetSystemInfo_ISN(6) -> CPU count
#include "includes\ISN_UDF_PDH_ObjectBaseCounters.au3"
#include "includes\ISN_UDF_PDH_ProcessCounters.au3"
#include <GuiDateTimePicker.au3>
#include "includes\ISN_Addon_AutoItObfuscator_WebAPI.au3"

If FileExists(@ScriptDir & "\portable.dat") Or $Pfade_bei_Programmstart_automatisch_suchen = "true" Then
	_Automatische_Suche_der_AutoIt_Ordner() ;Falls Portable Modus aktiv ist suche die AU3 Ordner bei jedem start automatisch neu
EndIf

_ISN_Gui_Size_Saving_Restore_Settings_by_Keyname("mainwindow")
_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
_PDH_Init()


;Registriere Dateitypen beim Programmstart
_ISN_Register_Filetypes()

If $runbefore <> "" Then
	GUICtrlSetData($startup_text, _Get_langstr(404))
	_Write_ISN_Debug_Console("|--> Run before start...", 1, 0)
	_Run_Beforstart()
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
EndIf

GUICtrlSetData($startup_text, _Get_langstr(464))
_Load_Projectlist()
GUICtrlSetData($startup_progress, 80)

;Run needed helper threads
GUIRegisterMsg(0x004A, "_ISN_Studio_Message_Handler") ;Register _WM_COPYDATA für Plugins
GUICtrlSetData($startup_text, _Get_langstr(1342))
_Write_ISN_Debug_Console("|--> Starting needed ISN helper threads...", 1)
_ISN_AutoIt_Studio_start_Scripttree_Helper_Thread()
Sleep(1000) ;Give helper some time to start...
GUICtrlSetData($startup_progress, 100)
GUICtrlSetData($startup_text, _Get_langstr(23))


;Auto-Konvertierung des "Default Templates" auf UTF-16
If FileExists(_ISN_Variablen_aufloesen($templatefolder & "\default")) Then
	$Template_Projektdatei = _Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\default"))
	If FileExists($Template_Projektdatei) Then _Datei_nach_UTF16_konvertieren($Template_Projektdatei, "false")
EndIf

_Write_ISN_Debug_Console("|--> Loading RDC DLL...", 1, 0)
_RDC_OpenDll()
If @error Then
	_Write_ISN_Debug_Console("ERROR (CODE: " & @error & ")", $ISN_Debug_Console_Errorlevel_Critical, 1, 1, 1)
Else
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
EndIf


;~ If $Alte_Fensterposition_verwenden = "true" Then
;~ 	;Studiofenster an Position schieben
;~ 	WinMove($StudioFenster, "", $Studiofenster_X, $Studiofenster_Y)
;~ EndIf

;~ If $Alte_Fensterposition_verwenden = "true" Then
;~ 	If _Config_Read("studio_maximized", "false") = "true" Then WinSetState($StudioFenster, "", @SW_MAXIMIZE) ;Im Fenstermodus Maximierung wiederherstellen
;~ Else
;~ 	WinSetState($StudioFenster, "", @SW_MAXIMIZE)
;~ EndIf

;Draw the QuickView Area
_QuickView_Refresh_Layout()

;Registriere die Msg Handles
_ISN_AutoIt_Studio_activate_GUI_Messages()

;Restore Window Positions and states
_ISN_Gui_Size_Saving_Restore_All_GUI_Settings()
If $fullscreenmode = "true" Then _Toggle_Fulscreen()

;Splitter Laden
$size1 = WinGetClientSize($StudioFenster, "")
GUICtrlSetPos($Middle_Splitter_Y, 268, ($size1[1] / 100) * Number(_Config_Read("Middle_Splitter_Y", $Mittlerer_Splitter_Y_default)))
GUICtrlSetPos($Left_Splitter_Y, 2, ($size1[1] / 100) * Number(_Config_Read("Left_Splitter_Y", $Linker_Splitter_Y_default)))
GUICtrlSetPos($Left_Splitter_X, ($size1[0] / 100) * Number(_Config_Read("Left_Splitter_X", $Linker_Splitter_X_default)))
GUICtrlSetPos($Right_Splitter_X, ($size1[0] / 100) * Number(_Config_Read("Right_Splitter_X", $Rechter_Splitter_X_default)))



_GUICtrlStatusBar_Resize($Status_bar)
_GUICtrlStatusBar_SetIcon($Status_bar, 1, _WinAPI_ShellExtractIcons($smallIconsdll, 913, 16, 16))
If $ISN_Dark_Mode = "true" Then _GUICtrlStatusBar_SetBkColor($Status_bar, 0x626262)
_HIDE_FENSTER_RECHTS("true") ;Verstecke Skriptbaum
_HIDE_FENSTER_UNTEN("true") ;Verstecke Debugfenster
$tpos = ControlGetPos($StudioFenster, "", $htab)
GUICtrlSetPos($HD_Logo, $tpos[0] + ($tpos[2] / 2) - 200, $tpos[1] + ($tpos[3] / 2) - 200, 400, 400)
GUICtrlSetState($HD_Logo, $GUI_SHOW)



If $allowcommentout = "true" Then
	GUISetAccelerators($Studiofenster_AccelKeys, $StudioFenster) ;Wird aktuell nur für Minus am Nummernblock verwendet
	GUISetAccelerators($Studiofenster_AccelKeys, $QuickView_GUI) ;Wird aktuell nur für Minus am Nummernblock verwendet
	GUISetAccelerators($Studiofenster_AccelKeys, $Codeausschnitt_GUI) ;Wird aktuell nur für Minus am Nummernblock verwendet
	GUISetAccelerators($Studiofenster_AccelKeys, $Makro_Codeausschnitt_GUI) ;Wird aktuell nur für Minus am Nummernblock verwendet
EndIf






_Aktualisiere_Splittercontrols()
_Rezize()
_Elemente_an_Fesntergroesse_anpassen_Startup()
_QuickView_Tab_Event()
_QuickView_GUI_Resize()
_Write_ISN_Debug_Console("|--> ISN AutoIt Studio startup successfully! ;)", 1)
_Write_ISN_Debug_Console("", 0)


;Show the main gui ($Studiofenster)
GUISetState(@SW_DISABLE, $StudioFenster)
Switch $ISN_Save_Positions_mode

	Case "0"
		;mode 0: no position or size saving. Just center and maximize it
		GUISetState(@SW_MAXIMIZE, $StudioFenster)

	Case "1", "2"
		;mode 1: if no position is found, maximize it. Otherwise simply show the window
		If IniRead($Configfile, "positions", "mainwindow", "") = "" Then
			GUISetState(@SW_MAXIMIZE, $StudioFenster)
		Else
			GUISetState(@SW_SHOW, $StudioFenster)
		EndIf


EndSwitch
GUISetState(@SW_SHOWNOACTIVATE, $QuickView_GUI)

If $CmdLine[0] = 1 Then
	If StringInStr($CmdLine[1], "." & $Autoitextension) Then _oeffne_Editormodus(FileGetLongName($CmdLine[1]))
	If StringInStr($CmdLine[1], ".isn") Then _Load_Project_by_Foldername(FileGetLongName(StringTrimRight($CmdLine[1], StringLen($CmdLine[1]) - StringInStr($CmdLine[1], "\", 0, -1) + 1)))
	If StringInStr($CmdLine[1], ".isp") Then _Import_Project_CMD($CmdLine[1])
	If StringInStr($CmdLine[1], ".icp") Then _Import_ICP_Plugin_CMD($CmdLine[1])
EndIf



If $CmdLine[0] = 2 Then
	If StringInStr($CmdLine[2], "." & $Autoitextension) Then _oeffne_Editormodus(FileGetLongName($CmdLine[2]))
EndIf


If $CommandLine = "" And $CmdLine[0] <> 1 Then
	If $Autoload = "true" And Not $LastProject = "" And FileExists(_ISN_Variablen_aufloesen($LastProject)) Then
		_Fadeout_logo()
		If _ISN_Variablen_aufloesen($LastProject) = $Arbeitsverzeichnis & "\Data\Editormode" Then
			_oeffne_Editormodus("")
		Else
			_Load_Project_by_Foldername(_ISN_Variablen_aufloesen($LastProject))
		EndIf
	Else
		GUISetState(@SW_SHOW, $Welcome_GUI)
		WinActivate($Welcome_GUI)
	EndIf
Else
	If StringTrimLeft($CommandLine, StringInStr($CommandLine, ".", 0, -1)) = "isn" Then
		_Fadeout_logo()
		$tempp = IniReadSection($CommandLine, "ISNAUTOITSTUDIO")
		If @error Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(476), 0, $StudioFenster)
			GUISetState(@SW_SHOW, $Welcome_GUI)
			WinActivate($Welcome_GUI)
		Else

			$CommandLine = FileGetLongName(StringTrimRight($CommandLine, StringLen($CommandLine) - StringInStr($CommandLine, "\", 0, -1) + 1))
			_show_Loading(_Get_langstr(34), _Get_langstr(23))
			_Loading_Progress(30)
			_Load_Project($CommandLine)
			$History_Projekte_Array = _fuege_in_History_ein($History_Projekte_Array, $CommandLine)
			_Loading_Progress(100)
			GUISetState(@SW_ENABLE, $StudioFenster)
			_Hide_Loading()
			_Check_tabs_for_changes()
		EndIf
	EndIf

	If StringTrimLeft($CommandLine, StringInStr($CommandLine, ".", 0, -1)) = "isp" Then
		_Fadeout_logo()
		_Show_Projectman()
		_Import_project($CommandLine)
	EndIf
EndIf


;Starts des ISN´s mitzählen
$startups = Number(IniRead($Configfile, "config", "startups", 0))
IniWrite($Configfile, "config", "startups", $startups + 1)
If $startups > 149 Then _Earn_trophy(8, 2) ;Gibt eine Trophäe bei 150 Starts

;Ram bereinigung
_Adlib_ISN_Ram_bereinigen() ;Startup bereinigung
AdlibRegister("_Adlib_ISN_Ram_bereinigen", _Config_Read("isn_cleanup_memory_after_ms", 1800000)) ;Alle 30 Minuten RAM bereinigen
AdlibRegister("_Reregister_Hotkeys", _Config_Read("isn_reregister_hotkeys_after_ms", 60000)) ;Alle 60 Sekunden Hotkeys aktivieren (sofern Fenster Aktiv)
AdlibRegister("_ISN_Helper_Thread_Adlib", 500) ;Prüft alle 500ms zwecks Helper Nachrichten



;Hotkeys aktivieren
_ISN_aktualisiere_Hotkeys()


Sleep(300)
_Fadeout_logo() ;Logo ausblenden

;Setze Timer für AutoUpdate
$Auto_Update_Timer_Handle = _Timer_SetTimer($StudioFenster, 60000, "_Pruefe_nach_Onlineupdates_AUTO") ;nach 1 min prüfe online Update




; #FUNCTION# ;===============================================================================
;
; Name...........: _Check_Plugin_Signals
; Description ...: Empfängt Nachrichten von Plugins die über die jewailigen Fenstertitel ausgetauscht werden
; Syntax.........: _Check_Plugin_Signals()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird durch eine AdlibRegister Funktion aufgerufen
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Check_Plugin_Signals($msg = "")
	AdlibUnRegister("_Check_Plugin_Signals")
	Local $Nachricht = $msg
	If $Nachricht = "" Then Return
	If $SHOW_DEBUG_CONSOLE = "true" Then
		Local $Console_Message = $msg
		If StringLen(_Pluginstring_get_element($Console_Message, 3)) > 200 Then $Console_Message = StringReplace($Console_Message, _Pluginstring_get_element($Console_Message, 3), "<DATA IS TOO LONG FOR CONSOLE OUTPUT>")
		If StringLen(_Pluginstring_get_element($Console_Message, 4)) > 200 Then $Console_Message = StringReplace($Console_Message, _Pluginstring_get_element($Console_Message, 4), "<DATA IS TOO LONG FOR CONSOLE OUTPUT>")
		_Write_ISN_Debug_Console("ISN received a message from a plugin: " & $Console_Message, $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title, $ISN_Debug_Console_Category_Plugin)
	EndIf
	Switch _Pluginstring_get_element($Nachricht, 1)

		Case "listfuncs"
			If $Offenes_Projekt <> "" Then _List_Funcs()

		Case "listpictures"
			If $Offenes_Projekt <> "" Then _Choose_File("*.jpg;*.jpeg;*.bmp;*.ico;*.ani;*.dll;")

		Case "listguis"
			If $Offenes_Projekt <> "" Then _List_Guis()

		Case "selectfolder"
			If $Offenes_Projekt <> "" Then _Select_folder_plugin()

		Case "execute_in_ISN"
			$result = Execute(_Pluginstring_get_element($Nachricht, 2))
			_ISN_Send_Message_to_Plugin(_Pluginstring_get_element($Nachricht, 0), "execute_in_ISN" & $Plugin_System_Delimiter & _Pluginstring_get_element($Nachricht, 2) & $Plugin_System_Delimiter & $result) ;Ergebnis ans Plugin zurücksenden senden

		Case "showextracode"
			If $Offenes_Projekt <> "" Then _SCI_Zeige_Extracode(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3), _Pluginstring_get_element($Nachricht, 4))

		Case "callfunc_in_ISN", "callfunc_async_in_ISN"
			If _Pluginstring_get_element($Nachricht, 3) = "" Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2))
			EndIf

			If (_Pluginstring_get_element($Nachricht, 3) <> "") And (_Pluginstring_get_element($Nachricht, 4) = "") And (_Pluginstring_get_element($Nachricht, 5) = "") And (_Pluginstring_get_element($Nachricht, 6) = "") And (_Pluginstring_get_element($Nachricht, 7) = "") And (_Pluginstring_get_element($Nachricht, 8) = "") And (_Pluginstring_get_element($Nachricht, 9) = "") Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3))
			EndIf

			If (_Pluginstring_get_element($Nachricht, 3) <> "") And (_Pluginstring_get_element($Nachricht, 4) <> "") And (_Pluginstring_get_element($Nachricht, 5) = "") And (_Pluginstring_get_element($Nachricht, 6) = "") And (_Pluginstring_get_element($Nachricht, 7) = "") And (_Pluginstring_get_element($Nachricht, 8) = "") And (_Pluginstring_get_element($Nachricht, 9) = "") Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3), _Pluginstring_get_element($Nachricht, 4))
			EndIf

			If (_Pluginstring_get_element($Nachricht, 3) <> "") And (_Pluginstring_get_element($Nachricht, 4) <> "") And (_Pluginstring_get_element($Nachricht, 5) <> "") And (_Pluginstring_get_element($Nachricht, 6) = "") And (_Pluginstring_get_element($Nachricht, 7) = "") And (_Pluginstring_get_element($Nachricht, 8) = "") And (_Pluginstring_get_element($Nachricht, 9) = "") Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3), _Pluginstring_get_element($Nachricht, 4), _Pluginstring_get_element($Nachricht, 5))
			EndIf

			If (_Pluginstring_get_element($Nachricht, 3) <> "") And (_Pluginstring_get_element($Nachricht, 4) <> "") And (_Pluginstring_get_element($Nachricht, 5) <> "") And (_Pluginstring_get_element($Nachricht, 6) <> "") And (_Pluginstring_get_element($Nachricht, 7) = "") And (_Pluginstring_get_element($Nachricht, 8) = "") And (_Pluginstring_get_element($Nachricht, 9) = "") Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3), _Pluginstring_get_element($Nachricht, 4), _Pluginstring_get_element($Nachricht, 5), _Pluginstring_get_element($Nachricht, 6))
			EndIf

			If (_Pluginstring_get_element($Nachricht, 3) <> "") And (_Pluginstring_get_element($Nachricht, 4) <> "") And (_Pluginstring_get_element($Nachricht, 5) <> "") And (_Pluginstring_get_element($Nachricht, 6) <> "") And (_Pluginstring_get_element($Nachricht, 7) <> "") And (_Pluginstring_get_element($Nachricht, 8) = "") And (_Pluginstring_get_element($Nachricht, 9) = "") Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3), _Pluginstring_get_element($Nachricht, 4), _Pluginstring_get_element($Nachricht, 5), _Pluginstring_get_element($Nachricht, 6), _Pluginstring_get_element($Nachricht, 7))
			EndIf

			If (_Pluginstring_get_element($Nachricht, 3) <> "") And (_Pluginstring_get_element($Nachricht, 4) <> "") And (_Pluginstring_get_element($Nachricht, 5) <> "") And (_Pluginstring_get_element($Nachricht, 6) <> "") And (_Pluginstring_get_element($Nachricht, 7) <> "") And (_Pluginstring_get_element($Nachricht, 8) <> "") And (_Pluginstring_get_element($Nachricht, 9) = "") Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3), _Pluginstring_get_element($Nachricht, 4), _Pluginstring_get_element($Nachricht, 5), _Pluginstring_get_element($Nachricht, 6), _Pluginstring_get_element($Nachricht, 7), _Pluginstring_get_element($Nachricht, 8))
			EndIf

			If (_Pluginstring_get_element($Nachricht, 3) <> "") And (_Pluginstring_get_element($Nachricht, 4) <> "") And (_Pluginstring_get_element($Nachricht, 5) <> "") And (_Pluginstring_get_element($Nachricht, 6) <> "") And (_Pluginstring_get_element($Nachricht, 7) <> "") And (_Pluginstring_get_element($Nachricht, 8) <> "") And (_Pluginstring_get_element($Nachricht, 9) <> "") Then
				$result = Call(_Pluginstring_get_element($Nachricht, 2), _Pluginstring_get_element($Nachricht, 3), _Pluginstring_get_element($Nachricht, 4), _Pluginstring_get_element($Nachricht, 5), _Pluginstring_get_element($Nachricht, 6), _Pluginstring_get_element($Nachricht, 7), _Pluginstring_get_element($Nachricht, 8), _Pluginstring_get_element($Nachricht, 9))
			EndIf
			If _Pluginstring_get_element($Nachricht, 1) = "callfunc_in_ISN" Then _ISN_Send_Message_to_Plugin(_Pluginstring_get_element($Nachricht, 0), "callfunc_in_ISN" & $Plugin_System_Delimiter & _Pluginstring_get_element($Nachricht, 2) & $Plugin_System_Delimiter & $result) ;Ergebnis ans Plugin zurücksenden senden


		Case "isn_plugin_request_var" ;Plugin fragt nach einer Variable
			$return_var = Execute(_Pluginstring_get_element($Nachricht, 2))
			If IsArray($return_var) Then $return_var = _ArrayToString($return_var, ":rowdelim:", Default, Default, ":coldelim:")
			_ISN_Send_Message_to_Plugin(_Pluginstring_get_element($Nachricht, 0), "isn_plugin_request_var" & $Plugin_System_Delimiter & _Pluginstring_get_element($Nachricht, 2) & $Plugin_System_Delimiter & $return_var & $Plugin_System_Delimiter & _Pluginstring_get_element($Nachricht, 3))


		Case "isn_plugin_set_var" ;Plugin möchte eine Variable im ISN setzen
			;Prüfe ob der Empfangene String ein ArrayString ist
			Local $result = ""
			If StringInStr(_Pluginstring_get_element($Nachricht, 3), ":rowdelim:") Or StringInStr(_Pluginstring_get_element($Nachricht, 3), ":coldelim:") Then
				;Array
				$result = Assign(StringReplace(_Pluginstring_get_element($Nachricht, 2), "$", ""), _ISNPlugin_ArrayStringToArray(_Pluginstring_get_element($Nachricht, 3)), 2)
			Else
				;Variable
				$result = Assign(StringReplace(_Pluginstring_get_element($Nachricht, 2), "$", ""), _Pluginstring_get_element($Nachricht, 3), 2)
			EndIf
			_ISN_Send_Message_to_Plugin(_Pluginstring_get_element($Nachricht, 0), "isn_plugin_set_var" & $Plugin_System_Delimiter & _Pluginstring_get_element($Nachricht, 2) & $Plugin_System_Delimiter & $result) ;Ergebnis ans Plugin zurücksenden senden

	EndSwitch


EndFunc   ;==>_Check_Plugin_Signals




Func _Reregister_Hotkeys()
	If $ISN_Hotkey_Hook_aktiv = 1 Then
		_Write_ISN_Debug_Console("ISN hotkey hook reregistered!", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title, $ISN_Debug_Console_Category_Hotkey)
		_HotKey_Enable() ;Reregister the Hotkey every 60 Secounds
	EndIf
EndFunc   ;==>_Reregister_Hotkeys


Func _ISN_Helper_Thread_Adlib()

	;Updater
	If $ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] <> "" Then
		If ProcessExists($ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID]) Then
			If Not BitAND(GUICtrlGetState($willkommen_update_suchen_button), $GUI_DISABLE) = $GUI_DISABLE Then
				GUICtrlSetData($willkommen_update_suchen_button, _Get_langstr(337))
				GUICtrlSetState($willkommen_update_suchen_button, $GUI_DISABLE)
			EndIf



		Else
			If Not BitAND(GUICtrlGetState($willkommen_update_suchen_button), $GUI_ENABLE) = $GUI_ENABLE Then
				GUICtrlSetData($willkommen_update_suchen_button, _Get_langstr(350))
				GUICtrlSetState($willkommen_update_suchen_button, $GUI_ENABLE)
			EndIf
			$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_Handle] = ""
			$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] = ""
		EndIf

	EndIf


	;Testscript
	If $Offenes_Projekt <> "" Then
		If $ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_PID] <> "" Then
			If ProcessExists($ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_PID]) Then
				If $SKRIPT_LAUEFT = 0 Then
					$SKRIPT_LAUEFT = 1
					_Check_Buttons(0)
				EndIf
			Else
				If $SKRIPT_LAUEFT = 1 Then
					$SKRIPT_LAUEFT = 0
					_Check_Buttons(0)
					$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_Handle] = ""
					$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_PID] = ""
				EndIf
			EndIf
		EndIf
	EndIf

	;Scripttree
	If $ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_PID] <> "" Then
		If Not ProcessExists($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_PID]) Then
			_Write_ISN_Debug_Console("Looks like the ISN helper thread 'scripttree' has crashed! Let´s restart them...", 3)
			$ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_PID] = ""
			_ISN_AutoIt_Studio_start_Scripttree_Helper_Thread()
		EndIf
	EndIf

EndFunc   ;==>_ISN_Helper_Thread_Adlib



While 1

	;Check hover on hyperlinks in the project settings
	$Projekteinstellungen_GUI_WinState = WinGetState($Projekteinstellungen_GUI, "")
	If BitAND($Projekteinstellungen_GUI_WinState, 2) Then _Projekteinstellungen_Hyperlinks_preufen()

	;Check hover on hyperlinks in the info gui
	$ISN_Ueber_GUI_WinState = WinGetState($ISN_Ueber_GUI, "")
	If BitAND($ISN_Ueber_GUI_WinState, 2) Then _Info_GUI_Check_Hyperlinks()

	;Check hover on hyperlinks in the settings gui
	$config_GUI_WinState = WinGetState($config_GUI, "")
	If BitAND($config_GUI_WinState, 2) Then _Config_GUI_Check_Hyperlinks()

	;Hover bei den zuletzt geöffneten Projekten am Startbildschrim prüfen
	$Welcome_GUI_WinState = WinGetState($Welcome_GUI, "")
	If BitAND($Welcome_GUI_WinState, 2) Then _CheckHoverAndPressed($Welcome_GUI)

	Global $size1 = WinGetClientSize($StudioFenster, "")
	Global $size = WinGetPos($StudioFenster)


	If WinActive($StudioFenster) And $Offenes_Projekt <> "" Then
		If _IsPressed("04", $user32) Then AdlibRegister("_MIDDLEdown") ;Mittlere Maustaste (kann nicht geändert werden)

		;Hotkeys für diverse Controls (zb. den Projektbaum (Enter, Entf usw)
		Switch _WinAPI_GetFocus()

			Case $hWndTreeview
				If $Projektbaum_ist_bereit = 1 Then
					If _IsPressed("0D", $user32) Then
						If _GUICtrlTreeView_GetSelection($hTreeview) = 0 Then ContinueCase
						If StringInStr(_GUICtrlTreeView_GetTree($hTreeview, _GUICtrlTreeView_GetSelection($hTreeview)), ".", 1, -1) = 0 Then ContinueCase
						Try_to_opten_file(StringReplace($Offenes_Projekt & "\" & StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview, _GUICtrlTreeView_GetSelection($hTreeview)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview, _GUICtrlTreeView_GetSelection($hTreeview)), "|")), $Delim1, $Delim))
					EndIf

					If _IsPressed("2E", $user32) Then _Show_Delete_file_GUI()
					If _IsPressed("71", $user32) Then _Rename_File()

				EndIf


		EndSwitch


	EndIf


	If _GUICtrlTab_GetItemCount($htab) > 0 And _GUICtrlTab_GetCurFocus($htab) <> -1 And IsDeclared("hTab") And $Offenes_Projekt <> "" Then

		If _GUICtrlTab_GetItemCount($htab) > 0 Then
			$statet = WinGetState($StudioFenster, "")
			If BitAND($statet, 4) Then
				GUISetState(@SW_ENABLE, $QuickView_GUI)
			Else
				GUISetState(@SW_DISABLE, $QuickView_GUI)
			EndIf



			If _hit_win(_WinAPI_GetFocus()) And _WinAPI_GetClassName(_WinAPI_GetFocus()) = "Scintilla" And BitAND($statet, 2) Then
				GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU_EDITOR")
			Else
				GUIRegisterMsg($WM_CONTEXTMENU, "")
				If Not _hit_win(_WinAPI_GetFocus()) Then
					_Detailinfos_ausblenden()
				EndIf
			EndIf
		EndIf
	EndIf

	If WinActive($console_GUI) Then
		If _IsPressed("0D", $user32) Then _Send_consolCommand()
	EndIf


	If _WinAPI_GetAncestor(WinGetHandle("[ACTIVE]"), $GA_ROOTOWNER) = $StudioFenster Or WinGetHandle("[ACTIVE]") = $Codeausschnitt_GUI Or WinGetHandle("[ACTIVE]") = $console_GUI Or _istPluginfensteraktiv() Or AutoIt_Fenster_ist_aktiv() Then

		;Wenn Idle Timer über 60 Sekunden -> Pausiere Projekttimer
		If Int($Idle_Timer) > 60000 Then
			_Projekt_timer_Pausieren()
		Else
			_Projekt_Timer_fortsetzen()
		EndIf


		;Hotkey Hook registrieren (falls noch nicht geschehen)
		If $ISN_Hotkey_Hook_aktiv = 0 Then
			$ISN_Hotkey_Hook_aktiv = 1
;~ 			$hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hStub_KeyProc), $hmod)
			_HotKey_Enable()
			_Write_ISN_Debug_Console("ISN hotkey hook procedure enabled.", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title, $ISN_Debug_Console_Category_Hotkey)
		EndIf


		If _IsPressed("01", $user32) = 0 Then
			$size_before_resize = WinGetClientSize($StudioFenster, "")
;~ 	if IsArray($size_before_resize) then ConsoleWrite($size_before_resize[1]&@crlf)
		EndIf

		;Logo -> Falls kein Tab geöffnet ist zeige das ISN Logo
		If _GUICtrlTab_GetItemCount($htab) = 0 Then
			If BitAND(GUICtrlGetState($HD_Logo), $GUI_HIDE) = $GUI_HIDE Then
				_HIDE_FENSTER_RECHTS("true")
				_HIDE_FENSTER_UNTEN("true")
				_Repos_HD_Logo()
				GUICtrlSetState($HD_Logo, $GUI_SHOW)
				_ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "_Scripttree_Switch_Tab", "-1")
			EndIf
		Else
			If BitAND(GUICtrlGetState($HD_Logo), $GUI_SHOW) = $GUI_SHOW Then GUICtrlSetState($HD_Logo, $GUI_HIDE)
		EndIf
	Else
		_Projekt_timer_Pausieren()

		;Hotkey Hook deregistrieren (wird nicht benötigt wenn das ISN nicht aktiv ist -> Verhindert auch konflikte mit anderen Apps die ein Hook verwenden)
		If $ISN_Hotkey_Hook_aktiv = 1 Then
			$ISN_Hotkey_Hook_aktiv = 0
;~ 			_WinAPI_UnhookWindowsHookEx($hHook)
			_HotKey_Disable()
			_Write_ISN_Debug_Console("ISN hotkey hook procedure disabled.", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title, $ISN_Debug_Console_Category_Hotkey)
		EndIf
	EndIf

	Sleep(50)

WEnd


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Receive_Message
; Description ...: The Message Function for WM_COPYDATA. Messages from the ISN AutoIt Studio are received by this function.
; Author ........: ISI360 (Based on code from Yashied)
; Remarks .......: This Function will be registered with the function "_ISNPlugin_initialize".
;				   This function calls "_ISNPlugin_Processing_Userdefined_Messages" for custom messages. (Like Exit or Save commands) For more, see Info at the top of this UDF.
; ===============================================================================================================================
Func _ISN_Studio_Message_Handler($hWnd, $msgID, $wParam, $lParam) ;WM_COPYDATA
	Local $tCOPYDATA = DllStructCreate("dword;dword;ptr", $lParam)
	Local $tMsg = DllStructCreate("char[" & DllStructGetData($tCOPYDATA, 2) & "]", DllStructGetData($tCOPYDATA, 3))
	$Received_Message = BinaryToString(DllStructGetData($tMsg, 1), 4)
	$ISN_Studio_Plugin_Last_Received_Message = $Received_Message ;Set latest Received Message
	_Check_Plugin_Signals($ISN_Studio_Plugin_Last_Received_Message)
;~ 	AdlibRegister("_Check_Plugin_Signals",1)
	Return 0
EndFunc   ;==>_ISN_Studio_Message_Handler


#preproc Res_AppInfo(FileVersion, 1.10.0.0)
#Au3Stripper_Ignore_Funcs=Dbug DBG_Set DBG_ArrayDisplayEx DBG_PreSet DBG_GetExtErr
#Au3Stripper_Ignore_Variables=$DBG_Error $DBG_Extended $___SrcFullPath $___SrcName $dbg_NotifyFunc $dbg_CommandFunc
#Au3Stripper_Ignore_Variables=$DBG_LineFun $DBG_ExistLines $DBG_FunVarsOrg $DBG_FunVars

#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1 - 3.3.14.0
	Script version: 2018.05.24
	Author        : Heron
	Customized by : valdemar1977
	Mod           : asdf8

	Link          : https://www.autoitscript.com/forum/topic/103142-another-debugger-for-autoit/

#ce ----------------------------------------------------------------------------

#Region    ************ Includes ************
#Include-Once
#Include <ButtonConstants.au3>
#Include <StaticConstants.au3>
#Include <GUIConstantsEx.au3>
#Include <GUIListView.au3>
#Include <GUIEdit.au3>
#Include <WindowsConstants.au3>
#Include <Misc.au3>
#Include <GUIToolTip.au3>
#Include <WinAPISysWin.au3>
#EndRegion ************ Includes ************

; Opt('MustDeclareVars', 1)
#Region PreSet
Global $DBG_CommonStepMode       = True  ; pause at start
Global $DBG_CommonJumpTo         = True  ; jump to line with breakpoint
Global $DBG_CommonSetOnTop       = True  ; debugger window on top
Global $DBG_CommonAutoUpdateList = True  ; automatically update expressions list
Global $DBG_CommonExtInfo        = False ; extended information
Global $DBG_CommonPauseReset     = True  ; pause resets the remaining breakpoints
Global $DBG_Version              = "2018.05.24"
#EndRegion


#Region global variables declaration
Global $DBG_RedrawProc = True
Global $DBG_user32 = DllOpen("user32.dll")
Global $DBG_StepMode, $DBG_JumpTo, $DBG_SetOnTop, $DBG_AutoUpdateList, $DBG_ExtInfo, $DBG_aLabStat[6], $DBG_CommonINI
Global $DBG_chkStep, $DBG_chkJumpTo, $DBG_chkOnTop, $DBG_chkUpdList, $DBG_chkExtInfo, $DBG_chkPauseReset
Global $DBG_Block, $DBG_OnEventMode, $DBG_CurrentGUI, $DBG_ident, $DBG_hSci, $DBG_BreakFun, $DBG_BreakLine, $DBG_timer
Global $DBG_LineFun[1], $DBG_PrevVar, $DBG_CtrlEnd
Global $DBG_FunVars[1][2], $DBG_FunVarsOrg[1][2]
Global $DBG_GUI, $DBG_txtCommand, $DBG_btnRun, $DBG_btnRunCursor, $DBG_btnStep, $DBG_btnStepOver, $DBG_txtResult, $DBG_txtBreakPoint, $DBG_btnClear, $DBG_ListView, $DBG_lblStat, $DBG_btnEdit, $DBG_chkSetOnTop, $DBG_hWndArrayRange
Global $DBG_btnBreak, $DBG_btnToggle, $DBG_btnJumpTo, $DBG_btnAddFromList, $DBG_hTAB, $DBG_btnClearList, $DBG_btnInsert, $DBG_btnDelete, $DBG_chkExtendedInfo, $DBG_btnOriginal, $DBG_chkPauseAtStart
Global $DBG_btnClearCmd, $DBG_btnExecute, $DBG_btnClearResults, $DBG_btnLoad, $DBG_btnStore, $DBG_btnExit, $DBG_tabHlp, $DBG_editHlp, $DBG_editInfo, $DBG_editConsole
Global $DBG_FirstRun= True, $DBG_EndRun = False, $DBG_WINDOW_WIDTH = 440, $DBG_WINDOW_HEIGHT = 400
Global $DBG_hListView, $DBG_Tmp, $DBG_i, $DBG_ColSort = 0, $DBG_SelVal, $dbg_NoActivate = True
Global $dbg_NotifyFunc, $dbg_CommandFunc, $DBG_ExistLines, $DBG_ExitLines = 1, $DBG_AllCalls = 0, $DBG_Error = 0, $DBG_Extended = 0, $DBG_BrkReason = 0
Global $dbg_pNotify = DllStructGetPtr(DllStructCreate("BYTE[256]"))
Global $dbg_IdCommand, $dbg_NotifyCheck, $DBG_btnLoadList, $DBG_btnStoreList, $DBG_Img, $DBG_d = Chr(166), $DBG_ArrayCounter, $DBG_ArMaxOut = 50
Global $___SrcFullPath = EnvGet('___SrcFullPath')
Global $___SrcName = StringRegExpReplace($___SrcFullPath, '.+\\(.+)', '\1')
Global $DBG_INI = @ScriptDir & "\dbug" & StringRegExpReplace($___SrcName, '^(.+)\.[^.]+$', '_\1') & ".ini"
#EndRegion

; if called for the first time (no arguments) then create shadow script,
; start it and exit (if the original script contains a 'Execute(dbug())' statement then continue (debug line mode)
; else (called second time) get the original script name and run it (debug script mode)
If Not $___SrcFullPath Then
	DBG_CreateAndRun()
	Exit
EndIf

if WinGetTitle("[TITLE:ISN AutoIt Studio - Ed; CLASS:AutoIt v3 GUI;]","") = 0 Then
$title = WinGetTitle("[TITLE: - ISN AutoIt Studio; CLASS:AutoIt v3 GUI;]","")
Else
$title = WinGetTitle("[TITLE:ISN AutoIt Studio - Ed; CLASS:AutoIt v3 GUI;]","")
endif

If Execute('DBG_PreSet()') Then ;get variables for each function
	Opt('WinTitleMatchMode', 1)
;~ 	$DBG_hSci = HWnd(EnvGet('SciteEdit'))
;~ 	If Not $DBG_hSci Then $DBG_hSci = ControlGetHandle("[Class:SciTEWindow]", "", "[CLASS:Scintilla;INSTANCE:1]") ;Scintilla handle
	$DBG_hSci = ControlGetHandle($title,"",ptr(RegRead("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_Sci_Handle")))	;ISN AutoIt Studio Modification: get Scintilla handle
	DBG_InstallImg()
	ObjEvent("AutoIt.Error", "DBG_ErrFunc")
	$DBG_CommonINI = StringRegExpReplace($DBG_Img, '[^\\]+$', 'dbug.ini')
	If IniRead($DBG_CommonINI, "Settings", "StepMode", String($DBG_CommonStepMode)) <> String($DBG_CommonStepMode) Then $DBG_CommonStepMode = Not $DBG_CommonStepMode
	If IniRead($DBG_CommonINI, "Settings", "JumpTo", String($DBG_CommonJumpTo)) <> String($DBG_CommonJumpTo) Then $DBG_CommonJumpTo = Not $DBG_CommonJumpTo
	If IniRead($DBG_CommonINI, "Settings", "SetOnTop", String($DBG_CommonSetOnTop)) <> String($DBG_CommonSetOnTop) Then $DBG_CommonSetOnTop = Not $DBG_CommonSetOnTop
	If IniRead($DBG_CommonINI, "Settings", "AutoUpdateList", String($DBG_CommonAutoUpdateList)) <> String($DBG_CommonAutoUpdateList) Then $DBG_CommonAutoUpdateList = Not $DBG_CommonAutoUpdateList
	If IniRead($DBG_CommonINI, "Settings", "ExtInfo", String($DBG_CommonExtInfo)) <> String($DBG_CommonExtInfo) Then $DBG_CommonExtInfo = Not $DBG_CommonExtInfo
	$DBG_StepMode       = $DBG_CommonStepMode
	$DBG_JumpTo         = $DBG_CommonJumpTo
	$DBG_SetOnTop       = $DBG_CommonSetOnTop
	$DBG_AutoUpdateList = $DBG_CommonAutoUpdateList
	$DBG_ExtInfo        = $DBG_CommonExtInfo
	If IniRead($DBG_INI, "Settings", "StepMode", String($DBG_StepMode)) <> String($DBG_StepMode) Then $DBG_StepMode = Not $DBG_StepMode
	If IniRead($DBG_INI, "Settings", "JumpTo", String($DBG_JumpTo)) <> String($DBG_JumpTo) Then $DBG_JumpTo = Not $DBG_JumpTo
	If IniRead($DBG_INI, "Settings", "ClearList", String(Not $DBG_AutoUpdateList)) <> String(Not $DBG_AutoUpdateList) Then $DBG_AutoUpdateList = Not $DBG_AutoUpdateList
Else
	MsgBox(16 + 4096, 'DBUG Error', 'Not found debug data:' & @CRLF & @ScriptFullPath & @CRLF)
	If Not @Compiled And FileExists(@ScriptFullPath) Then FileDelete(@ScriptFullPath)
	Exit
EndIf

;DBUG GUI
#Region ### START Koda GUI section ### Form=frmdbug.kxf
$DBG_GUI = GUICreate('DBUG ver. ' & $DBG_Version & ' - ' & $___SrcName, $DBG_WINDOW_WIDTH, $DBG_WINDOW_HEIGHT, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_SYSMENU, $WS_CAPTION), $WS_EX_TOPMOST)
GUISetIcon($DBG_Img, 21, $DBG_GUI)
GUISetBkColor(0xECE9D8, $DBG_GUI)
For $DBG_i = 0 To 4
	$DBG_aLabStat[$DBG_i] = GUICtrlCreateLabel("", 4 + $DBG_i * 32, 1, 32, 30)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
	GUICtrlSetState(-1, $GUI_DISABLE)
Next
$DBG_aLabStat[5] = $DBG_aLabStat[3]
$DBG_aLabStat[3] = $DBG_aLabStat[4]
$DBG_aLabStat[4] = $DBG_aLabStat[5]
GUICtrlSetTip($DBG_aLabStat[4], "Pause (F4)")
$DBG_aLabStat[5] = GUICtrlCreateLabel("", 276, 1, 32, 30)
GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip($DBG_aLabStat[0], "Step Into (F7)")
GUICtrlSetTip($DBG_aLabStat[1], "Step Over Scope (F8)")
GUICtrlSetTip($DBG_aLabStat[2], "Run To Cursor (F9)")
GUICtrlSetTip($DBG_aLabStat[3], "Run (F5)")
$DBG_btnStep = GUICtrlCreateCheckbox("Step", 4, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP, $BS_ICON)) ; valdemar1977
GUICtrlSetImage(-1, $DBG_Img, -11, 0)
GUICtrlSetTip(-1, "Step Into (F7)")
$DBG_btnStepOver = GUICtrlCreateCheckbox("Over", 36, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetTip(-1, "Step Over Scope (F8)")
$DBG_btnRunCursor = GUICtrlCreateCheckbox("Curs", 68, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetTip(-1, "Run To Cursor (F9)")
$DBG_btnBreak = GUICtrlCreateCheckbox("Brk", 100, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetTip(-1, "Pause (F4)")
$DBG_btnRun = GUICtrlCreateCheckbox("Run", 132, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP, $BS_ICON)) ; valdemar1977
If $DBG_StepMode Then
	GUICtrlSetImage(-1, $DBG_Img, -20, 0)
	GUICtrlSetTip(-1, "Run (F5)")
Else
	GUICtrlSetImage(-1, $DBG_Img, -13, 0)
	GUICtrlSetTip(-1, "Resume (F5)")
	WinSetTitle($DBG_GUI, 0, 'DBUG ver. ' & $DBG_Version & ' - Running ' & $___SrcName) ;set GUI things
EndIf
$DBG_btnToggle = GUICtrlCreateButton("Set", 276, 4, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -9, 0)
GUICtrlSetTip(-1, "Set/Reset Breakpoint Line (Ctrl+F2)")
$DBG_btnJumpTo = GUICtrlCreateCheckbox("Jmp", 308, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP)) ; valdemar1977
GUICtrlSetTip(-1, "Jump to Line with" & @CRLF & "Breakpoint automatically")
If $DBG_JumpTo Then GUICtrlSetState(-1, $GUI_CHECKED)
$DBG_txtBreakPoint = GUICtrlCreateInput("", 6, 61, 364, 21)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Conditional breakpoint expression")
$DBG_btnAddFromList = GUICtrlCreateButton("+", 372, 60, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetTip(-1, "Add from expressions list")
$DBG_btnClear = GUICtrlCreateButton("X", 404, 60, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -4, 0)
GUICtrlSetTip(-1, "Clear conditional expression")
$DBG_chkPauseAtStart = GUICtrlCreateCheckbox("Pause", 340, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetTip(-1, "Pause at start")
If $DBG_StepMode Then GUICtrlSetState(-1, $GUI_CHECKED)
$DBG_chkSetOnTop = GUICtrlCreateCheckbox("Top", 372, 4, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetTip(-1, "Set On Top")
If $DBG_SetOnTop Then
	GUICtrlSetState(-1, $GUI_CHECKED)
Else
	WinSetOnTop($DBG_GUI, '', 0)
EndIf
$DBG_lblStat = GUICtrlCreateLabel("<status script " & $___SrcName & "> line(1)", 7, 84, 428, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetTip(-1, "Currently executing Function(line)")
GUICtrlSetCursor(-1, 0)
#Region TAB Watch
$DBG_hTAB = GUICtrlCreateTab(1, 104, $DBG_WINDOW_WIDTH - 1, $DBG_WINDOW_HEIGHT - 104)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlCreateTabItem("Watch")
$DBG_btnClearList = GUICtrlCreateCheckbox("Clear", 164, 32, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP))
If Not $DBG_AutoUpdateList Then GUICtrlSetState(-1, $GUI_CHECKED)
$DBG_btnInsert = GUICtrlCreateButton("Ins", 100, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -17, 0)
GUICtrlSetTip(-1, "Insert new expression")
$DBG_btnDelete = GUICtrlCreateButton("Del", 132, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -18, 0)
GUICtrlSetTip(-1, "Delete selected expression(s)")
$DBG_btnEdit = GUICtrlCreateButton("[::]", 4, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetTip(-1, "Array table view")
$DBG_chkExtendedInfo = GUICtrlCreateCheckbox("[..]", 36, 32, 32, 24, BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $WS_TABSTOP)) ; valdemar1977
If $DBG_ExtInfo Then GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Extended information") ; valdemar1977
$DBG_btnOriginal = GUICtrlCreateButton("Org", 68, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -16, 0)
$DBG_Tmp = "Restore original list" & @CRLF & @CRLF
$DBG_Tmp &= 'Pressing "Ctrl" restore rules for all scopes'
GUICtrlSetTip(-1, $DBG_Tmp)
$DBG_btnLoadList = GUICtrlCreateButton("Load", 196, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -12, 0)
GUICtrlSetTip(-1, "Load saved list state")
$DBG_btnStoreList = GUICtrlCreateButton("Store", 228, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -10, 0)
GUICtrlSetTip(-1, "Save list state")

$DBG_ListView = GUICtrlCreateListView("var|scope|type|value", 3, 128, $DBG_WINDOW_WIDTH - 7, $DBG_WINDOW_HEIGHT - 132, BitOR($LVS_REPORT, $LVS_EDITLABELS, $LVS_SHOWSELALWAYS))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 50)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
If @Compiled Then GUICtrlSetColor(-1, 0x0000FF)
$DBG_hListView = GUICtrlGetHandle($DBG_ListView)
_GUICtrlListView_SetExtendedListViewStyle($DBG_hListView, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $WS_EX_CLIENTEDGE, $LVS_EX_INFOTIP))
$DBG_Tmp = _GUICtrlListView_GetToolTips($DBG_hListView)
If IsHWnd($DBG_Tmp) Then WinSetOnTop($DBG_Tmp, "", 1)

#EndRegion TAB Watch
#Region Commands
GUICtrlCreateTabItem("Commands")
$DBG_txtCommand = GUICtrlCreateEdit("", 3, 128, $DBG_WINDOW_WIDTH - 7, ($DBG_WINDOW_HEIGHT - 140) / 2, BitOR($ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL), $WS_EX_OVERLAPPEDWINDOW)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Select the line with the command to execute (Ctrl+Enter)")
$DBG_txtResult = GUICtrlCreateEdit("", 3, 130 + ($DBG_WINDOW_HEIGHT - 140) / 2, $DBG_WINDOW_WIDTH - 7, $DBG_WINDOW_HEIGHT - 134 - ($DBG_WINDOW_HEIGHT - 140) / 2, $ES_READONLY, $WS_EX_OVERLAPPEDWINDOW)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSetTip(-1, "Display results")
$DBG_btnClearCmd = GUICtrlCreateButton("Clear", 68, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -4, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Clear commands")
$DBG_btnExecute = GUICtrlCreateButton("Exe", 4, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -20, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Execute command (Ctrl+Enter)")
$DBG_btnClearResults = GUICtrlCreateButton("Clear", 100, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -4, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Clear results")
#EndRegion Commands
#Region Info
GUICtrlCreateTabItem("Info")
$DBG_editInfo = GUICtrlCreateEdit("", 3, 128, $DBG_WINDOW_WIDTH - 7, ($DBG_WINDOW_HEIGHT - 140) / 2, $ES_READONLY + $ES_AUTOVSCROLL + $ES_AUTOHSCROLL + $WS_HSCROLL + $WS_VSCROLL, $WS_EX_OVERLAPPEDWINDOW)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
$DBG_editConsole = GUICtrlCreateEdit("", 3, 130 + ($DBG_WINDOW_HEIGHT - 140) / 2, $DBG_WINDOW_WIDTH - 7, $DBG_WINDOW_HEIGHT - 134 - ($DBG_WINDOW_HEIGHT - 140) / 2, -1, $WS_EX_OVERLAPPEDWINDOW)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSetTip(-1, "Console output")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetLimit(-1, 1048576)
#EndRegion
$DBG_tabSet = GUICtrlCreateTabItem("Settings")
#Region Help
$DBG_tabHlp = GUICtrlCreateTabItem("Help")
#Region CreateEdit
$DBG_editHlp = GUICtrlCreateEdit("~~~DBUG help~~~" & @CRLF _
		& @CRLF & "1. Hotkeys list:" _
		& @CRLF & "Ctrl+F2 - set/reset breakpoint line" _
		& @CRLF & "F4 - pause execution" _
		& @CRLF & "F5 - run/resume execution" _
		& @CRLF & "F6 - activate main DBUG window" _
		& @CRLF & "F7 - step into" _
		& @CRLF & "F8 - step over" _
		& @CRLF & "F9 - run to cursor" _
		& @CRLF & "Ctrl+Enter - execute command" _
		& @CRLF & "Ctrl+F10 - quit from DBUG" & @CRLF _
		& @CRLF & "2. Tips:" _
		& @CRLF & "Background list is painted in yellow, if the list is different" _
		& @CRLF & "from the original (have been added or removed items in the list)." _
		& @CRLF & "#... STOP DBUG - start region with no debug" _
		& @CRLF & "#... START DBUG - end region with no debug" _
		& @CRLF & "#... DBUG FOR COMPILE - create a script debugger to compile." _
		& @CRLF & "#pragma Compile(Console, True) - debugging with OEM-console." & @CRLF _
		& @CRLF & "3. Example conditional breakpoint expression:" _
		& @CRLF & '(IsDeclared("iIndex") And $iIndex = 18) Or (IsDeclared("sText") And StringInStr($sText, "Error")) Or @Error' & @CRLF _
		& @CRLF & '4. Processing GUIRegisterMsg' _
		& @CRLF & 'WM_NOTIFY and WM_COMMAND hook to prevent interference with possible message handlers.' & @CRLF _
		& @CRLF & 'To automatically hook WM_NOTIFY messages GUIRegisterMsg function' _
		& @CRLF & 'the first parameter must be specified by a constant $WM_NOTIFY,' _
		& @CRLF & 'but the function itself is located in the current script.' _
		& @CRLF & 'If these conditions are not met, it is possible to replace' _
		& @CRLF & 'the function GUIRegisterMsg following code ("MY_WM_NOTIFY" - as an example):' _
		& @CRLF & '   If IsDeclared("dbg_NotifyFunc") Then' _
		& @CRLF & '      Assign("dbg_NotifyFunc", "MY_WM_NOTIFY")' _
		& @CRLF & '   Else' _
		& @CRLF & '      GUIRegisterMsg(0x004E, "MY_WM_NOTIFY")' _
		& @CRLF & '   EndIf' _
		& @CRLF & 'or during the debugging execute the command ("MY_WM_NOTIFY" - as an example):' _
		& @CRLF & '   $dbg_NotifyFunc = "MY_WM_NOTIFY"' & @CRLF _
		& @CRLF & 'To automatically hook WM_COMMAND messages GUIRegisterMsg function' _
		& @CRLF & 'the first parameter must be specified by a constant $WM_COMMAND,' _
		& @CRLF & 'but the function itself is located in the current script.' _
		& @CRLF & 'If these conditions are not met, it is possible to replace' _
		& @CRLF & 'the function GUIRegisterMsg following code ("MY_WM_COMMAND" - as an example):' _
		& @CRLF & '   If IsDeclared("dbg_CommandFunc") Then' _
		& @CRLF & '      Assign("dbg_CommandFunc", "MY_WM_COMMAND")' _
		& @CRLF & '   Else' _
		& @CRLF & '      GUIRegisterMsg(0x0111, "MY_WM_COMMAND")' _
		& @CRLF & '   EndIf' _
		& @CRLF & 'or during the debugging execute the command ("MY_WM_COMMAND" - as an example):' _
		& @CRLF & '   $dbg_CommandFunc = "MY_WM_COMMAND"' & @CRLF & @CRLF _
		, 3, 128, $DBG_WINDOW_WIDTH - 7, $DBG_WINDOW_HEIGHT - 132, $ES_READONLY + $ES_AUTOVSCROLL + $ES_AUTOHSCROLL + $WS_HSCROLL + $WS_VSCROLL + $ES_NOHIDESEL, $WS_EX_STATICEDGE)
#EndRegion
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
#EndRegion Help
GUICtrlCreateTabItem("")

$DBG_btnLoad = GUICtrlCreateButton("Load", 372, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -12, 0)
GUICtrlSetTip(-1, "Load saved Commands and Conditional expression")
$DBG_btnStore = GUICtrlCreateButton("Store", 404, 32, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -10, 0)
GUICtrlSetTip(-1, "Save Commands and Conditional expression")
$DBG_btnExit = GUICtrlCreateButton("Exit", 404, 4, 32, 24, BitOR($BS_ICON, $WS_GROUP))
GUICtrlSetImage(-1, $DBG_Img, -15, 0)
GUICtrlSetTip(-1, "Quit (Ctrl+F10)")

#Region
For $DBG_i = $DBG_btnStep To $DBG_btnStoreList
	GUICtrlSetResizing($DBG_i, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
Next
GUICtrlSetResizing($DBG_btnToggle, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_btnJumpTo, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_txtBreakPoint, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_btnAddFromList, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_btnLoad, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_btnStore, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_btnClear, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_chkSetOnTop, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_btnExit, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_hTAB, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSetResizing($DBG_lblStat, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetResizing($DBG_chkPauseAtStart, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKRIGHT)

If Not FileExists($DBG_Img) Then GUICtrlSetData($DBG_txtResult, "No button images found in " & $DBG_Img)

GUICtrlSetStyle($DBG_chkSetOnTop, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP))
GUICtrlSetStyle($DBG_btnJumpTo, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP)) ; valdemar1977
GUICtrlSetStyle($DBG_chkExtendedInfo, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP))
GUICtrlSetStyle($DBG_btnBreak, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP))
GUICtrlSetStyle($DBG_btnStepOver, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP))
GUICtrlSetStyle($DBG_btnRunCursor, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP))
GUICtrlSetStyle($DBG_btnClearList, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP))
GUICtrlSetStyle($DBG_chkPauseAtStart, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP))
GUICtrlSetStyle($DBG_btnRun, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_ICON, $WS_TABSTOP)) ; valdemar1977

GUICtrlSetImage($DBG_btnBreak, $DBG_Img, -7, 0)
GUICtrlSetImage($DBG_chkSetOnTop, $DBG_Img, -14, 0)
GUICtrlSetImage($DBG_btnJumpTo, $DBG_Img, -1, 0)
GUICtrlSetImage($DBG_chkExtendedInfo, $DBG_Img, -5, 0)
GUICtrlSetImage($DBG_btnEdit, $DBG_Img, -6, 0)
GUICtrlSetImage($DBG_btnAddFromList, $DBG_Img, -8, 0)
GUICtrlSetImage($DBG_btnStepOver, $DBG_Img, -3, 0)
GUICtrlSetImage($DBG_btnRunCursor, $DBG_Img, -2, 0)
GUICtrlSetImage($DBG_btnClearList, $DBG_Img, -19, 0)
GUICtrlSetImage($DBG_chkPauseAtStart, $DBG_Img, -22, 0)

GUISwitch($DBG_GUI, $DBG_tabSet)
$DBG_chkStep       = GUICtrlCreateCheckbox("pause at start", 28, 144, 193, 17)
$DBG_chkJumpTo     = GUICtrlCreateCheckbox("jump to line with breakpoint", 28, 168, 193, 17)
$DBG_chkOnTop      = GUICtrlCreateCheckbox("debugger window on top", 28, 192, 193, 17)
$DBG_chkUpdList    = GUICtrlCreateCheckbox("automatically update expressions list", 28, 216, 193, 17)
$DBG_chkExtInfo    = GUICtrlCreateCheckbox("extended information", 28, 244, 193, 17)
$DBG_chkPauseReset = GUICtrlCreateCheckbox("pause resets the remaining breakpoints", 28, 272, 193, 17)
$DBG_CtrlEnd = GUICtrlCreateLabel("*  These settings are used when you start debugging for scripts that have not set individual settings (use the buttons in the control panel)", 12, 304, 420, 57)
GUICtrlSetColor(-1, 0xB40404)
GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
For $DBG_i = $DBG_chkStep To $DBG_chkPauseReset
	GUICtrlSetResizing($DBG_i, $GUI_DOCKSIZE + $GUI_DOCKTOP + $GUI_DOCKLEFT)
Next
If $DBG_CommonStepMode Then GUICtrlSetState($DBG_chkStep, $GUI_CHECKED)
If $DBG_CommonJumpTo Then GUICtrlSetState($DBG_chkJumpTo, $GUI_CHECKED)
If $DBG_CommonSetOnTop Then GUICtrlSetState($DBG_chkOnTop, $GUI_CHECKED)
If $DBG_CommonAutoUpdateList Then GUICtrlSetState($DBG_chkUpdList, $GUI_CHECKED)
If $DBG_CommonExtInfo Then GUICtrlSetState($DBG_chkExtInfo, $GUI_CHECKED)
If $DBG_CommonPauseReset Then GUICtrlSetState($DBG_chkPauseReset, $GUI_CHECKED)
#EndRegion
#EndRegion ### END Koda GUI section ###

#Region after koda save GUISetState and GUISetAccelerators lines in Koda GUI section
Dim $DBG_GUI_AccelTable[8][2] = [["{F5}", $DBG_btnRun], _
		["{F7}", $DBG_btnStep], _
		["{F8}", $DBG_btnStepOver], _
		["^{F10}", $DBG_btnExit], _
		["^{F2}", $DBG_btnToggle], _
		["^{ENTER}", $DBG_btnExecute], _
		["{F4}", $DBG_btnBreak], _
		["{F9}", $DBG_btnRunCursor]]
$DBG_Tmp = "Debug script      : " & $___SrcName & @CRLF
$DBG_Tmp &= "Shadow script     : " & @ScriptName & @CRLF
$DBG_Tmp &= "Working directory : " & @WorkingDir & @CRLF
$DBG_Tmp &= "AutoIt executable : " & @AutoItExe & @CRLF
$DBG_Tmp &= "Version of AutoIt : " & @AutoItVersion & @CRLF
$DBG_Tmp &= "Running under x64 : " & @AutoItX64 & @CRLF
$DBG_Tmp &= "Current PID       : " & @AutoItPID & @CRLF
$DBG_Tmp &= "Added GUI Controls: " & $DBG_CtrlEnd & @CRLF
$DBG_Tmp &= "$CmdLineRaw       : " & $CmdLineRaw & @CRLF
$DBG_Tmp &= "$CmdLine[0]       : " & $CmdLine[0] & @CRLF
If $CmdLine[0] > 0 Then
	For $DBG_i = 1 To $CmdLine[0]
		$DBG_Tmp &= "$CmdLine[" & $DBG_i & "]       : " & $CmdLine[$DBG_i] & @CRLF
	Next
EndIf
GUICtrlSetData($DBG_editInfo, $DBG_Tmp)
If @Compiled Then
	$___SrcFullPath = @ScriptFullPath
	$___SrcName     = @ScriptName
EndIf
_GUICtrlListView_RegisterSortCallBack($DBG_hListView)
_GUICtrlListView_SortItems($DBG_hListView, $DBG_ColSort)
_GUICtrlListView_SortItems($DBG_hListView, $DBG_ColSort)
$DBG_Tmp = DllCall('User32.dll', 'hwnd', 'GetSystemMenu', 'hwnd', $DBG_GUI, 'int', False)
If Not @Error Then DllCall('User32.dll', 'bool', 'EnableMenuItem', 'handle', $DBG_Tmp[0], 'uint', 0xF060, 'uint', 1)
If $DBG_StepMode Then
	DBG_StateButtons($GUI_DISABLE, 1)
	GUICtrlSetState($DBG_btnRun, $GUI_ENABLE)
	GUICtrlSetState($DBG_btnRun, $GUI_FOCUS)
Else
	DBG_StateButtons($GUI_DISABLE)
	$DBG_FirstRun = False
	GUICtrlSetData($DBG_lblStat, '')
	GUICtrlSetState($DBG_btnRun, $GUI_CHECKED)
	For $DBG_i = 0 To 3
		GUICtrlSetState($DBG_aLabStat[$DBG_i], $GUI_ENABLE)
	Next
EndIf
DBG_Show()
If $DBG_StepMode Then
	GUICtrlSetState($DBG_btnRun, $GUI_DISABLE)
	If $DBG_RedrawProc Then _SendMessage($DBG_GUI, $WM_SETREDRAW, False, 0)
EndIf
HotKeySet('{F6}', 'DBG_Show') ;activate DBUG GUI
HotKeySet('^{F10}', 'DBG_Exit') ;exit
HotKeySet('{F4}', 'DBG_btnBreak')
HotKeySet('{F5}', 'DBG_btnRun')
HotKeySet('{F7}', 'DBG_btnStep')
HotKeySet('{F8}', 'DBG_btnStepOver')
HotKeySet('{F9}', 'DBG_btnRunCursor')
GUISetAccelerators($DBG_GUI_AccelTable, $DBG_GUI)

OnAutoItExitRegister('DBG__Exit')
GUICtrlSetData($DBG_txtBreakPoint, BinaryToString(IniRead($DBG_INI, "Conditions", "Expression", "")))
GUICtrlSetData($DBG_txtCommand, BinaryToString(IniRead($DBG_INI, "Command", "Text", "")))
GUIRegisterMsg($WM_COMMAND, "DBG_CommandHook")
GUIRegisterMsg($WM_NOTIFY, "DBG_NotifyHook")

DBG_LoadList()
#EndRegion

$DBG_timer = TimerInit()
Execute(Dbug(1))

Func Dbug($lnr = @ScriptLineNumber, $case = -5, $exp = 0, $exp2 = 0) ;main function
	Local $Msg, $brk, $sel, $editActive = False, $in, $out, $var, $val, $hEdit, $items, $fx, $CurExpr, $max, $item, $scope, $vname, $text, $aTmp
	Switch $case
		Case -9 ;loop
			#Region prepare buttons
			DBG_ChkWmMsg($lnr)
			$val = @CRLF & 'in scope : ' & $DBG_LineFun[$lnr]
			GUICtrlSetTip($DBG_ListView, "Display expressions" & $val)
			GUICtrlSetTip($DBG_btnInsert, "Insert new expression" & $val & @CRLF & @CRLF & 'Pressing "ESC" for cancel the editing of expression.')
			GUICtrlSetTip($DBG_btnDelete, "Delete selected expression(s)" & $val)
			GUICtrlSetTip($DBG_btnOriginal, "Restore original list" & $val & @CRLF & @CRLF & 'Pressing "Ctrl" restore rules for all scopes.')
			If GUICtrlRead($DBG_btnClearList) = $GUI_CHECKED Then
				GUICtrlSetTip($DBG_ListView, 'To automatically update expressions list,' & @CRLF & 'toggle button "Clear expressions list"')
				GUICtrlSetTip($DBG_btnClearList, "Clear expressions list")
			Else
				GUICtrlSetTip($DBG_ListView, "Display expressions" & $val)
				GUICtrlSetTip($DBG_btnClearList, "Clear expressions list" & $val & @CRLF & @CRLF & "To disable updates expressions list," & @CRLF & 'click the button while holding down "Ctrl"')
			EndIf
			For $i = 0 To 3
				GUICtrlSetState($DBG_aLabStat[$i], $GUI_DISABLE)
			Next
			GUICtrlSetState($DBG_aLabStat[4], $GUI_ENABLE)
			GUICtrlSetState($DBG_btnBreak, $GUI_UNCHECKED)
			DBG_StateButtons()
			If $DBG_EndRun Then
				For $i = $DBG_btnStep To $DBG_btnRun
					GUICtrlSetState($i, $GUI_HIDE)
				Next
				For $i = 0 To 5
					GUICtrlSetState($DBG_aLabStat[$i], $GUI_HIDE)
				Next
				GUICtrlSetData($DBG_lblStat, StringFormat('Finished: %s calls, last from %s (%s)', $DBG_AllCalls, $DBG_LineFun[$DBG_ExitLines], $DBG_ExitLines))
				GUICtrlSetBkColor($DBG_txtBreakPoint, 0xFFFFFF)
				GUICtrlSetBkColor($DBG_lblStat, 0x7FFF00)
				GUICtrlSetTip($DBG_lblStat, "")
			EndIf
			_SendMessage($DBG_GUI, $WM_SETREDRAW, True, 0)
			If ($DBG_FirstRun Or Not $dbg_NoActivate) And $DBG_RedrawProc Then
				_WinAPI_InvalidateRect($DBG_GUI)
			EndIf
			If Not $DBG_FirstRun And Not $dbg_NoActivate Then
				DBG_Show()
			EndIf
			$dbg_NoActivate = False
			Opt('GUIOnEventMode', 0)
			GUIRegisterMsg($WM_GETMINMAXINFO, 'DBG_WM_GETMINMAXINFO')
			#EndRegion
			While True
				$DBG_Block = True
				$Msg       = GUIGetMsg()
				Switch $Msg
					Case $DBG_btnClear ;clear conditional breakpoint
						GUICtrlSetData($DBG_txtBreakPoint, "")
						ControlFocus($DBG_GUI, "", $DBG_txtBreakPoint)
					Case $DBG_btnClearCmd
						GUICtrlSetData($DBG_txtCommand, "")
						ControlFocus($DBG_GUI, "", $DBG_txtCommand)
					Case $DBG_btnClearResults
						GUICtrlSetData($DBG_txtResult, "")
						ControlFocus($DBG_GUI, "", $DBG_txtResult)
					Case $DBG_btnClearList
						GUICtrlSetBkColor($DBG_ListView, 0xFFFFFF)
						If _IsPressed("11", $DBG_user32) Then ; is pressed Ctrl
							GUICtrlSetState($DBG_btnClearList, $GUI_CHECKED)
							GUICtrlSetTip($DBG_btnClearList, "Clear expressions list")
							GUICtrlSetTip($DBG_ListView, 'To automatically update expressions list,' & @CRLF & 'toggle button "Clear expressions list"')
							IniWrite($DBG_INI, "Settings", "ClearList", "true")
							GUICtrlSetState($DBG_btnInsert, $GUI_DISABLE)
							GUICtrlSetState($DBG_btnDelete, $GUI_DISABLE)
							GUICtrlSetState($DBG_btnOriginal, $GUI_DISABLE)
							_GUICtrlListView_DeleteAllItems($DBG_hListView)
							ControlFocus($DBG_GUI, "", $DBG_ListView)
						Else
							GUICtrlSetState($DBG_btnClearList, $GUI_UNCHECKED)
							$val  = "Clear expressions list." & @CRLF & 'in scope : ' & $DBG_LineFun[$lnr] & @CRLF & @CRLF
							$val &= "To disable updates expressions list," & @CRLF
							$val &= 'click the button while holding down "Ctrl"'
							GUICtrlSetTip($DBG_btnClearList, $val)
							GUICtrlSetTip($DBG_ListView, "Display expressions" & @CRLF & 'in scope : ' & $DBG_LineFun[$lnr])
							_GUICtrlListView_DeleteAllItems($DBG_hListView)
							ControlFocus($DBG_GUI, "", $DBG_ListView)
							If BitAND(GUICtrlGetState($DBG_btnOriginal), $GUI_ENABLE) Then
								DBG_SaveListItems($lnr)
							Else
								GUICtrlSetState($DBG_btnInsert, $GUI_ENABLE)
								GUICtrlSetState($DBG_btnDelete, $GUI_ENABLE)
								GUICtrlSetState($DBG_btnOriginal, $GUI_ENABLE)
								IniWrite($DBG_INI, "Settings", "ClearList", "false")
								DBG_PopulateListView($lnr)
								Return StringFormat('Execute(Dbug(%s,-1))', $lnr) ;do refresh
							EndIf
						EndIf
					Case $DBG_chkSetOnTop ;set on top
						WinSetOnTop($DBG_GUI, '', 0)
						If GUICtrlRead($DBG_chkSetOnTop) = $GUI_CHECKED Then WinSetOnTop($DBG_GUI, '', 1)
					Case $DBG_chkExtendedInfo ; valdemar1977
						$DBG_ExtInfo = True ; valdemar1977
						If GUICtrlRead($DBG_chkExtendedInfo) = $GUI_UNCHECKED Then $DBG_ExtInfo = False ; valdemar1977
						If GUICtrlRead($DBG_btnClearList) <> $GUI_CHECKED Then
							DBG_StateButtons($GUI_DISABLE, 1)
							Return StringFormat('Execute(Dbug(%s,-1))', $lnr) ; valdemar1977
						EndIf
					Case $DBG_btnJumpTo
						If Not IsHWnd($DBG_hSci) Then $DBG_hSci = ControlGetHandle("[Class:SciTEWindow]", "", "[CLASS:Scintilla;INSTANCE:1]") ;Scintilla handle
						If GUICtrlRead($DBG_btnJumpTo) = $GUI_CHECKED Then
							IniWrite($DBG_INI, "Settings", "JumpTo", "true")
						Else
							IniWrite($DBG_INI, "Settings", "JumpTo", "false")
						EndIf
					Case $DBG_chkPauseAtStart
						If GUICtrlRead($DBG_chkPauseAtStart) = $GUI_CHECKED Then
							IniWrite($DBG_INI, "Settings", "StepMode", "true")
						Else
							IniWrite($DBG_INI, "Settings", "StepMode", "false")
						EndIf
					Case $DBG_btnRun, $DBG_btnStep, $DBG_btnRunCursor, $DBG_btnStepOver ;handle debug command
						If $DBG_EndRun Then ContinueLoop
						GUICtrlSetBkColor($DBG_txtBreakPoint, 0xFFFFFF)
						For $i = 0 To 5
							GUICtrlSetBkColor($DBG_aLabStat[$i], 0xECE9D8)
						Next
						If $Msg = $DBG_btnRun Then
							GUICtrlSetState($DBG_btnRun, $GUI_CHECKED)
						Else
							GUICtrlSetState($DBG_btnRun, $GUI_UNCHECKED)
						EndIf
						GUICtrlSetTip($DBG_lblStat, "Currently executing Function(line)")
						If $DBG_FirstRun Then
							$DBG_FirstRun = False
							WinSetTitle($DBG_GUI, 0, 'DBUG ver. ' & $DBG_Version & ' - Running ' & $___SrcName) ;set GUI things
							GUICtrlSetImage($DBG_btnRun, $DBG_Img, -13, 0)
							GUICtrlSetTip($DBG_btnRun, "Resume (F5)")
							GUICtrlSetTip($DBG_aLabStat[3], "Resume (F5)")
						EndIf
						$sel = DBG_SCISendMessage(2009) ;get anchor
;~ 						$sel = DBG_SCISendMessage(2166, $sel) + 1 ;linefromposition
						$sel = DBG_SCISendMessage(2166, $sel) + 2 ;ISN AutoIt Studio Modification: linefromposition offset

						Switch $Msg
							Case $DBG_btnRunCursor
								If GUICtrlRead($DBG_btnRunCursor) = $GUI_CHECKED Then
									If Not IsHWnd($DBG_hSci) Or $sel > UBound($DBG_LineFun) - 1 Then
										GUICtrlSetBkColor($DBG_lblStat, 0xFF0000)
										Sleep(200)
										GUICtrlSetBkColor($DBG_lblStat, 0xECE9D8)
										GUICtrlSetState($DBG_btnRunCursor, $GUI_UNCHECKED)
										ContinueLoop
									ElseIf Not StringInStr($DBG_ExistLines, ' ' & $sel & ' ') Then
										GUICtrlSetData($DBG_lblStat, '')
										$DBG_timer = TimerInit()
										GUICtrlSetBkColor($DBG_lblStat, 0xFF0000)
										$text = 'Not debugging information'
										$aTmp = StringRegExp($DBG_ExistLines, '(?<=\s)(\d{' & StringLen(String($sel)) & ',})\s', 3)
										If IsArray($aTmp) Then
											For $i = 0 To UBound($aTmp) - 1
												If Number($aTmp[$i]) >= $sel Then
													$text &= ', next line (' & $aTmp[$i] & ')'
													ExitLoop
												EndIf
											Next
										EndIf
										GUICtrlSetData($DBG_lblStat, $text)
										While TimerDiff($DBG_timer) < 250
											Sleep(20)
										WEnd
										GUICtrlSetBkColor($DBG_lblStat, 0xECE9D8)
										GUICtrlSetState($DBG_btnRunCursor, $GUI_UNCHECKED)
										ContinueLoop
									EndIf
									$DBG_BreakLine = $sel
									GUICtrlSetTip($DBG_btnRunCursor, "Run To Line <" & $DBG_BreakLine & "> (F9)")
									GUICtrlSetTip($DBG_aLabStat[2],  "Run To Line <" & $DBG_BreakLine & "> (F9)")
								Else
									$DBG_BreakLine = 0
									GUICtrlSetTip($DBG_btnRunCursor, "Run To Cursor (F9)")
									GUICtrlSetTip($DBG_aLabStat[2], "Run To Cursor (F9)")
									ContinueLoop
								EndIf
							Case $DBG_btnStepOver
								If GUICtrlRead($DBG_btnStepOver) = $GUI_CHECKED Then
									$DBG_BreakFun = $DBG_LineFun[$lnr]
									GUICtrlSetTip($DBG_btnStepOver, "Step Over Scope <" & $DBG_BreakFun & "> (F8)")
									GUICtrlSetTip($DBG_aLabStat[1], "Step Over Scope <" & $DBG_BreakFun & "> (F8)")
								Else
									$DBG_BreakFun = ''
									GUICtrlSetTip($DBG_btnStepOver, "Step Over Scope (F8)")
									GUICtrlSetTip($DBG_aLabStat[1], "Step Over Scope (F8)")
									ContinueLoop
								EndIf
						EndSwitch

						$DBG_StepMode   = False ;set run/step mode things
						$DBG_LineFun[0] = 0
						If $Msg = $DBG_btnStep Then $DBG_StepMode = True

						$max = GUICtrlSendMsg($DBG_ListView, $LVM_GETITEMCOUNT, 0, 0)
						If $max > 0 Then
							For $item = 0 To $max
								If GUICtrlSendMsg($DBG_ListView, $LVM_GETITEMSTATE, $item, $LVIS_SELECTED) Then
									$DBG_SelVal = _GUICtrlListView_GetItemText($DBG_hListView, $item)
									ExitLoop
								EndIf
							Next
							_GUICtrlListView_DeleteAllItems($DBG_hListView)
						EndIf

						DBG_SCISendMessage(2045, 3) ;delete markers
						Opt('GUIOnEventMode', $DBG_OnEventMode) ;restore previous OnEventMode
						GUISwitch($DBG_CurrentGUI) ;restore previous GUI
						$DBG_Block = False ;release just before return

						If $DBG_StepMode Then
							DBG_StateButtons($GUI_DISABLE, 1) ; valdemar1977
							If $DBG_RedrawProc Then _SendMessage($DBG_GUI, $WM_SETREDRAW, False, 0)
						Else
							$var = WinList()
							If IsArray($var) And $var[0][0] > 0 Then
								For $i = 1 To $var[0][0]
									If $DBG_GUI <> $var[$i][1] And BitAND(WinGetState($var[$i][1]), 2) And Not BitAND(WinGetState($var[$i][1]), 16) Then
										WinActivate($var[$i][1])
										Sleep(100)
										ExitLoop
									EndIf
								Next
							EndIf
						EndIf
						For $i = 0 To 3
							GUICtrlSetState($DBG_aLabStat[$i], $GUI_ENABLE)
						Next
						GUICtrlSetState($DBG_aLabStat[4], $GUI_DISABLE)
						DBG_StateButtons($GUI_DISABLE)
						Return
					Case $DBG_btnToggle ;set/reset breakpoint line
						$sel = DBG_SCISendMessage(2009) ;get anchor
						$sel = DBG_SCISendMessage(2166, $sel) + 1 ;linefromposition

						$val = DBG_SCISendMessage(2046, $sel - 1) ;markerget
						If BitAND($val, 0x0002) Then
							DBG_SCISendMessage(2044, $sel - 1, 1) ;delete marker
						Else
							DBG_SCISendMessage(2043, $sel - 1, 1) ;add marker
						    DBG_SCISendMessage(2042, 1, 0x0000FF) ;ISN AutoIt Studio Modification: NEUE ZEILE - set markNum 1 background to red
						    DBG_SCISendMessage(2040, 1, 21) ;ISN AutoIt Studio Modification: NEUE ZEILE - set markNum 1 auf Typ 21 (Circleminusconnected);~
						EndIf
					Case $DBG_btnEdit
						Local $aArrayHeaderForView = StringSplit(_GUICtrlListView_GetItemTextString($DBG_hListView, -1), "|")
						Local $sArrayHeaderForView = $aArrayHeaderForView[1] & StringTrimLeft($aArrayHeaderForView[3], 5)
						If StringInStr($aArrayHeaderForView[3], "Array", 1) Then
							DBG_StateButtons($GUI_DISABLE, 1)
							Return StringFormat('Execute(Dbug(%s, -1, Execute("%s"), @error))', $lnr, "DBG_ArrayDisplayEx(" & $aArrayHeaderForView[1] & ",'DBUG Array: " & $sArrayHeaderForView & "','" & $DBG_LineFun[$lnr] & "')")
						EndIf
					Case $DBG_btnInsert ;insert listview item
						$sel = _GUICtrlListView_GetNextItem($DBG_hListView, -1, 0, 8)
						If $sel = -1 Then $sel = 0
						_GUICtrlListView_InsertItem($DBG_hListView, "<expression>", Int($sel))
						_GUICtrlListView_SetItemSelected($DBG_ListView, $sel, True)
						_GUICtrlListView_EditLabel($DBG_hListView, Int($sel))
						$editActive = True
					Case $DBG_btnDelete ;delete selected listview items
						$val = _GUICtrlListView_GetSelectedIndices($DBG_hListView, True)
						For $sel = UBound($val) - 1 To 1 Step -1
							_GUICtrlListView_DeleteItem($DBG_hListView, $val[$sel])
						Next
						_GUICtrlListView_SetItemSelected($DBG_ListView, $val[1], True)
						ControlFocus($DBG_GUI, "", $DBG_ListView)
						DBG_SaveListItems($lnr)
					Case $DBG_btnAddFromList
						$sel = _GUICtrlListView_GetSelectedIndices($DBG_hListView)
						If $sel Then
							$sel  = Int($sel)
							$text = _GUICtrlListView_GetItemText($DBG_hListView, $sel)
							If StringLeft($text, 1) = '$' Then
								If _GUICtrlListView_GetItemText($DBG_hListView, $sel, 1) = 'G' Then
									$text = '(' & $text & ' = )'
								Else
									$text = '(IsDeclared("' & StringTrimLeft($text, 1) & '") And ' & $text & ' = )'
								EndIf
							ElseIf StringLeft($text, 1) = '@' Then
								$text = '(' & $text & ' = )'
							EndIf
							If $text Then
								$var = GUICtrlRead($DBG_txtBreakPoint)
								If $var Then $text = $var & ' Or ' & $text
								GUICtrlSetData($DBG_txtBreakPoint, $text)
								$var = StringLen($text) - 1
								GUICtrlSendMsg($DBG_txtBreakPoint, $EM_SETSEL, $var, $var)
							EndIf
							ControlFocus($DBG_GUI, "", $DBG_txtBreakPoint)
						EndIf
					Case $DBG_btnOriginal ;restore original list
						If _IsPressed("11", $DBG_user32) Then ; is pressed Ctrl
							$DBG_FunVars = $DBG_FunVarsOrg
						Else
							$fx = _ArraySearch($DBG_FunVars, $DBG_LineFun[$lnr])
							$DBG_FunVars[$fx][1] = $DBG_FunVarsOrg[$fx][1]
						EndIf
						DBG_PopulateListView($lnr)
						Return StringFormat('Execute(Dbug(%s,-1))', $lnr) ;do refresh
					Case $DBG_btnLoadList
						DBG_LoadList()
						If GUICtrlRead($DBG_btnClearList) <> $GUI_CHECKED Then
							DBG_PopulateListView($lnr)
							Return StringFormat('Execute(Dbug(%s,-1))', $lnr) ;do refresh
						EndIf
					Case $DBG_btnStoreList
						GUISetState(@SW_DISABLE, $DBG_GUI)
						IniDelete($DBG_INI, "ListState")
						For $i = 0 To UBound($DBG_FunVarsOrg) - 1
							If $DBG_FunVarsOrg[$i][0] = $DBG_FunVars[$i][0] And $DBG_FunVarsOrg[$i][1] <> $DBG_FunVars[$i][1] Then
								IniWrite($DBG_INI, "ListState", $DBG_FunVars[$i][0], $DBG_FunVars[$i][1])
							EndIf
						Next
						GUISetState(@SW_ENABLE, $DBG_GUI)
					Case $DBG_btnStore ;save state
						IniWrite($DBG_INI, "Conditions", "Expression", StringToBinary(GUICtrlRead($DBG_txtBreakPoint)))
						IniWrite($DBG_INI, "Command", "Text", StringToBinary(GUICtrlRead($DBG_txtCommand)))
					Case $DBG_btnLoad ;restore state
						GUICtrlSetData($DBG_txtBreakPoint, BinaryToString(IniRead($DBG_INI, "Conditions", "Expression", "")))
						GUICtrlSetData($DBG_txtCommand, BinaryToString(IniRead($DBG_INI, "Command", "Text", "")))
					Case $DBG_btnExecute ;execute expression
						$in  = GUICtrlRead($DBG_txtCommand)
						$sel = _GUICtrlEdit_GetSel($DBG_txtCommand)
						If IsArray($sel) Then
							$sel = $sel[1]
							If $sel < 1 Then $sel = 1
						Else
							$sel = 1
						EndIf
						$in = StringRegExpReplace($in, '(?s)^(.{' & $sel & '}[^\r\n]*)[\r\n].*$', '\1')
						Dim $sel[2] = [0, StringLen($in)]
						$in     = StringRegExpReplace($in, '(?s)^.*[\r\n]', '')
						$sel[0] = $sel[1] - StringLen($in)
						_GUICtrlEdit_SetSel($DBG_txtCommand, $sel[0], $sel[1])
						$in = StringRegExpReplace($in, '(?i)@(Error|Extended)', '$DBG_\1')
						$in = DBG_StringEscape($in) ;deal with escaping quotes
						If $DBG_RedrawProc Then _SendMessage($DBG_GUI, $WM_SETREDRAW, False, 0)
						DBG_StateButtons($GUI_DISABLE, 1)
						$aTmp = StringRegExp($in, '^[ \t]*(\$\w[^="'']*?)[ \t]*=[ \t]*(.*?)[ \t]*$', 3)
						If IsArray($aTmp) Then ;do assignment
							Return StringFormat('Execute(Dbug(%s, -3, Execute("DBG_Set(%s, %s)"), @error))', $lnr, $aTmp[0], $aTmp[1])
						Else ;do expression
							$in = StringRegExpReplace($in, '(?i)(?<![\w\$])ConsoleWrite(?=[ \t]*\()', 'DBG_ConsoleWrite')
							$aTmp = StringRegExp($in, '(?i)(?<![\w\$])(SetError|SetExtended)[ \t]*\([ \t]*(-?\d+)(.*)', 3)
							If IsArray($aTmp) Then
								$aTmp[1] = Number($aTmp[1])
								If $aTmp[0] = 'SetExtended' Then
									$DBG_Extended = $aTmp[1]
								Else
									$DBG_Error = $aTmp[1]
									$aTmp = StringRegExp($aTmp[2], '(?i)^[ \t]*,[ \t]*(-?\d+)', 3)
									If IsArray($aTmp) Then $DBG_Extended = Number($aTmp[0])
								EndIf
							EndIf
							Return StringFormat('Execute(Dbug(%s, -6, Execute("%s"), @error))', $lnr, $in)
						EndIf
					Case $DBG_ListView
						$DBG_ColSort = GUICtrlGetState($DBG_ListView)
						_GUICtrlListView_SortItems($DBG_hListView, $DBG_ColSort) ; valdemar1977
					Case $DBG_btnExit
						DBG_Exit()
					Case $DBG_lblStat
						If Not IsHWnd($DBG_hSci) Then $DBG_hSci = ControlGetHandle("[Class:SciTEWindow]", "", "[CLASS:Scintilla;INSTANCE:1]") ;Scintilla handle
						$text = StringRegExp(GUICtrlRead($DBG_lblStat), '\((\d+)\)$', 3)
						If IsArray($text) Then
							$text = Number($text[0])
							DBG_SCISendMessage(2024, $text - 1) ; gotoline
							DBG_SCISendMessage(2232, $text - 1) ; $SCI_ENSUREVISIBLE = 2232
						EndIf
					Case $DBG_chkStep
						IniWrite($DBG_CommonINI, "Settings", "StepMode", String(GUICtrlRead($DBG_chkStep) = $GUI_CHECKED))
					Case $DBG_chkJumpTo
						IniWrite($DBG_CommonINI, "Settings", "JumpTo", String(GUICtrlRead($DBG_chkJumpTo) = $GUI_CHECKED))
					Case $DBG_chkOnTop
						IniWrite($DBG_CommonINI, "Settings", "SetOnTop", String(GUICtrlRead($DBG_chkOnTop) = $GUI_CHECKED))
					Case $DBG_chkUpdList
						IniWrite($DBG_CommonINI, "Settings", "AutoUpdateList", String(GUICtrlRead($DBG_chkUpdList) = $GUI_CHECKED))
					Case $DBG_chkExtInfo
						IniWrite($DBG_CommonINI, "Settings", "ExtInfo", String(GUICtrlRead($DBG_chkExtInfo) = $GUI_CHECKED))
					Case $DBG_chkPauseReset
						$DBG_CommonPauseReset = (GUICtrlRead($DBG_chkPauseReset) = $GUI_CHECKED)
						IniWrite($DBG_CommonINI, "Settings", "PauseReset", String($DBG_CommonPauseReset))
				EndSwitch

				;check for edit label end
				$hEdit = _GUICtrlListView_GetEditControl($DBG_hListView)
				If $hEdit Then ;store text during editing
					Local $iListIndex = _GUICtrlListView_GetNextItem($DBG_hListView, -1, 0, 4) ; valdemar1977
					$item = _GUICtrlEdit_GetText(HWnd($hEdit))
					$text = $item
					DBG_StateButtons($GUI_DISABLE, 1)
					GUICtrlSetState($DBG_txtBreakPoint, $GUI_DISABLE)
					While True
						Sleep(20)
						If _IsPressed("1B", $DBG_user32) Then ; if ESC is pressed cancel the editing
							$text = ''
							_GUICtrlListView_CancelEditLabel($hEdit)
							ExitLoop
						EndIf
						If IsHWnd($hEdit) Then
							$text = _GUICtrlEdit_GetText(HWnd($hEdit))
						Else
							ExitLoop
						EndIf
					WEnd
					DBG_StateButtons($GUI_ENABLE)
					GUICtrlSetState($DBG_txtBreakPoint, $GUI_ENABLE)
					$text = StringStripWS($text, 3)
					If StringRegExp($text, '^\s*<|>\s*$') Then $text = ''
					If $editActive Or $text Then $item = $text
					_GUICtrlListView_SetItemText($DBG_hListView, $iListIndex, $item)
					DBG_SaveListItems($lnr)
					Sleep(100) ; valdemar1977
					If $DBG_RedrawProc Then _SendMessage($DBG_GUI, $WM_SETREDRAW, False, 0)
					DBG_PopulateListView($lnr)
					Return StringFormat('Execute(Dbug(%s,-1))', $lnr) ;do refresh
				EndIf

				;dynamic variable display
				If TimerDiff($DBG_timer) > 100 Then ;update calling function display every 250ms
					$DBG_timer = TimerInit()

					$var = DBG_SCIGetCurWord()
					If $var <> $DBG_PrevVar Then
						$DBG_PrevVar = $var
						If StringLeft($var, 1) = "$" Then ;display variable
							Return StringFormat('Execute(Dbug(%s, -7, Execute("%s"), IsDeclared("%s")))', $lnr, $var, StringTrimLeft($var, 1))
						ElseIf StringLeft($var, 1) = "@" Then ;display macro
							Switch $var
								Case '@ScriptFullPath'
									$var = '$___SrcFullPath'
								Case '@ScriptName'
									$var = '$___SrcName'
								Case '@Error'
									$var = '$DBG_Error'
								Case '@Extended'
									$var = '$DBG_Extended'
							EndSwitch
							Return StringFormat('Execute(Dbug(%s, -7, Execute("%s"), -2))', $lnr, $var)
						ElseIf StringRegExp($var, "^[-+x0-9a-fA-F]+$") Then ;display number
							$val = Number($var)
							If VarGetType($val) = "Int32" Then ToolTip(StringFormat("Int\t%s\r\nHex\t0x%s", Int($val), Hex($val, 4)))
							If VarGetType($val) = "Int64" Then ToolTip(StringFormat("Int\t%s\r\nHex\t0x%s", Int($val), Hex($val, 8)))
						Else
							ToolTip("")
						EndIf
					EndIf
				EndIf
			WEnd
		Case -7 ;dynamic variable display
			ToolTip(DBG_Scope($exp2) & " " & DBG_Type($exp) & ' = ' & DBG_Value($exp, True))
			$dbg_NoActivate = True
			If $DBG_RedrawProc Then _SendMessage($DBG_GUI, $WM_SETREDRAW, False, 0)
			Return StringFormat('Execute(Dbug(%s, -9))', $lnr) ;do loop
		Case -6 ;get expression result
			$Msg = StringFormat('-@%s ', $exp2)
			$out = $Msg & DBG_Type($exp) & ' = ' & DBG_Value($exp, True)
			GUICtrlSetData($DBG_txtResult, $out)
			If $exp = "" And $exp2 <> 0 Then GUICtrlSetData($DBG_txtResult, "Error: " & $exp2)
			Return StringFormat('Execute(Dbug(%s,-1))', $lnr) ;do refresh
		Case -5 ;set breakpoint check
			$DBG_ExitLines = $lnr
			$DBG_AllCalls += 1
			$DBG_LineFun[0] += 1 ;counter
			If Not $DBG_FirstRun And TimerDiff($DBG_timer) > 100 Then ;update calling function display every 250ms
				If $DBG_Block Then
					GUICtrlSetData($DBG_lblStat, StringFormat('%s calls, last from %s(%s) %s', $DBG_LineFun[0], $DBG_LineFun[$lnr], $lnr, StringRegExpReplace(GUICtrlRead($DBG_lblStat), '^.*(Break in)', '\1')))
				Else
					GUICtrlSetData($DBG_lblStat, StringFormat('%s calls, last from %s(%s)', $DBG_LineFun[0], $DBG_LineFun[$lnr], $lnr))
				EndIf
				While 1
					Sleep(10)
					Local $stdout = StdoutRead(@AutoItPID)
					If @Error Then
						ExitLoop
					EndIf
					If @Extended Then
						DBG_ConsoleWrite($stdout)
					EndIf
				WEnd
				$DBG_timer = TimerInit()

				If GUICtrlRead($DBG_btnExit) = $GUI_CHECKED Then DBG_Exit()
			EndIf

			If $DBG_Block Then Return ;no re-entry

			$DBG_BrkReason = 0
			If GUICtrlRead($DBG_btnBreak) = $GUI_CHECKED Then
				GUICtrlSetState($DBG_btnBreak, $GUI_UNCHECKED)
				If $DBG_CommonPauseReset Then
					GUICtrlSetState($DBG_btnRunCursor, $GUI_UNCHECKED) ; valdemar1977
					GUICtrlSetState($DBG_btnStepOver, $GUI_UNCHECKED) ; valdemar1977
					GUICtrlSetState($DBG_btnRun, $GUI_UNCHECKED) ; valdemar1977
					GUICtrlSetState($DBG_btnStep, $GUI_UNCHECKED) ; valdemar1977
					GUICtrlSetTip($DBG_btnStepOver, "Step Over Scope (F8)")
					GUICtrlSetTip($DBG_btnRunCursor, "Run To Cursor (F9)")
					GUICtrlSetTip($DBG_aLabStat[1], "Step Over Scope (F8)")
					GUICtrlSetTip($DBG_aLabStat[2], "Run To Cursor (F9)")
					$DBG_BreakFun = ''
					$DBG_BreakLine = 0
				EndIf
				$DBG_BrkReason += 1
				$brk = True
			EndIf
			If $DBG_StepMode Then
				$DBG_BrkReason += 2
				$brk = True
			EndIf
;~ 			If BitAND(DBG_SCISendMessage(2046, $lnr - 1), 2) Then ;markerget
			If BitAND(DBG_SCISendMessage(2046, $lnr - 2), 2) Then ;ISN AutoIt Studio Modification: markerget linefix
				$DBG_BrkReason += 4
				$brk = True
			EndIf
			If $lnr = $DBG_BreakLine Then
				$DBG_BreakLine = 0
				If GUICtrlRead($DBG_btnRunCursor) = $GUI_CHECKED Then
					GUICtrlSetState($DBG_btnRunCursor, $GUI_UNCHECKED)
					GUICtrlSetTip($DBG_btnRunCursor, "Run To Cursor (F9)")
					GUICtrlSetTip($DBG_aLabStat[2], "Run To Cursor (F9)")
					$DBG_BrkReason += 8
					$brk = True
				EndIf
			EndIf
			If $DBG_BreakFun And $DBG_LineFun[$lnr] <> $DBG_BreakFun Then
				$DBG_BreakFun = ''
				If GUICtrlRead($DBG_btnStepOver) = $GUI_CHECKED Then
					GUICtrlSetState($DBG_btnStepOver, $GUI_UNCHECKED)
					GUICtrlSetTip($DBG_btnStepOver, "Step Over Scope (F8)")
					GUICtrlSetTip($DBG_aLabStat[1], "Step Over Scope (F8)")
					$DBG_BrkReason += 16
					$brk = True
				EndIf
			EndIf
			If Not $brk Then ;test conditional breakpoint
				$text = StringStripWS(GUICtrlRead($DBG_txtBreakPoint), 3)
				If $text Then
					$text = '1 And ' & StringRegExpReplace($text, '(?i)@(Error|Extended)', '$DBG_\1')
					$text = DBG_StringEscape($text)
					$DBG_BrkReason += 32
					$brk = $text
				EndIf
			EndIf

			Return 'Execute(Dbug(' & $lnr & ', -2, Execute("' & $brk & '"), 0))' ;do init
		Case -3 ;get assignment result
			$Msg = StringFormat('=@%s ', $exp2)
			$out = $Msg & DBG_Type($exp) & ' = ' & DBG_Value($exp, True)
			GUICtrlSetData($DBG_txtResult, $out)

			If $exp <> '' Or $exp2 = 0 Then ;assignment succesfull -> do refresh
				Return StringFormat('Execute(Dbug(%s,-1))', $lnr)
			EndIf

			$in = GUICtrlRead($DBG_txtCommand)
			$in = DBG_StringEscape($in) ;deal with escaping quotes
			Return StringFormat('Execute(Dbug(%s, -6, Execute("%s"), @error))', $lnr, $in) ;assignment failed -> do expression
		Case -2 ;init
			If Not $exp Then Return ;no breakpoint

			$DBG_Block       = True ;prevent re-entry
			$DBG_OnEventMode = Opt('GUIOnEventMode') ;save GUIOnEventMode
			$DBG_CurrentGUI  = GUISwitch($DBG_GUI) ;save current GUI
			$DBG_PrevVar     = "" ;reset dynamic variable display
;~ 			If GUICtrlRead($DBG_btnJumpTo) = $GUI_CHECKED Then
;~ 				DBG_SCISendMessage(2024, $lnr - 1) ;gotoline
;~ 				DBG_SCISendMessage(2232, $lnr - 1) ; $SCI_ENSUREVISIBLE = 2232
;~ 			EndIf
			DBG_SCISendMessage(2045, 3) ;delete markers
;~ 			DBG_SCISendMessage(2043, $lnr - 1, 3) ;add marker

			;ISN AutoIt Studio Modification:LineBugfix
			Local $tmp = $lnr-2
			if $tmp < 0 then $tmp = 0
			DBG_SCISendMessage(2043, $tmp, 3) ;add marker
			If GUICtrlRead($DBG_btnJumpTo) = $GUI_CHECKED Then
			   	DBG_SCISendMessage(2403, 0x08+0x04) ;$SCI_SETYCARETPOLICY, $CARET_EVEN+$CARET_STRICT
			    DBG_SCISendMessage(2402, 0x08+0x04) ;$SCI_SETXCARETPOLICY, $CARET_EVEN+$CARET_STRICT

				DBG_SCISendMessage(2024, $tmp) ;gotoline
				DBG_SCISendMessage(2232, $tmp) ; $SCI_ENSUREVISIBLE = 2232

			   DBG_SCISendMessage(2403, 0) ;$SCI_SETYCARETPOLICY
			   DBG_SCISendMessage(2402, 0) ;$SCI_SETXCARETPOLICY
			EndIf
			;ISN Edit End


			If Not $DBG_FirstRun Then GUICtrlSetData($DBG_lblStat, StringFormat('Break in %s(%s)', $DBG_LineFun[$lnr], $lnr))
			;(debug line mode) or (breakpoint) or (STEP) or (STEP OVER) or (RUN to CURSOR)
			$text = ""
			If $DBG_BrkReason = 32 Then
				$text = "CONDITIONAL BREAKPOINT" & @CRLF
				GUICtrlSetBkColor($DBG_txtBreakPoint, 0xFF8000)
			Else
				If BitAND($DBG_BrkReason, 1) Then
					$text &= "PAUSE" & @CRLF
					GUICtrlSetBkColor($DBG_aLabStat[4], 0xFF8000)
				EndIf
				If BitAND($DBG_BrkReason, 2) Then
					$text &= "STEP" & @CRLF
					GUICtrlSetBkColor($DBG_aLabStat[0], 0xFF8000)
				EndIf
				If BitAND($DBG_BrkReason, 4) Then
					$text &= "BREAKPOINT" & @CRLF
					GUICtrlSetBkColor($DBG_aLabStat[5], 0xFF8000)
				EndIf
				If BitAND($DBG_BrkReason, 8) Then
					$text &= "RUN TO CURSOR" & @CRLF
					GUICtrlSetBkColor($DBG_aLabStat[2], 0xFF8000)
				EndIf
				If BitAND($DBG_BrkReason, 16) Then
					$text &= "STEP OVER" & @CRLF
					GUICtrlSetBkColor($DBG_aLabStat[1], 0xFF8000)
				EndIf
				If Not $text Then $text = "N/D" & @CRLF
			EndIf
			If IsHWnd($DBG_hSci) Then $text &= @CRLF & "* click to go to the line " & $lnr
			GUICtrlSetTip($DBG_lblStat, $text, "Reason for stop", 1, 1)
			DBG_ToolTipOpt()
			$DBG_BrkReason = 0

			If GUICtrlRead($DBG_btnClearList) = $GUI_CHECKED Then
				Return StringFormat('Execute(Dbug(%s, -9))', $lnr) ;do loop
			EndIf

			DBG_PopulateListView($lnr)

			Return StringFormat('Execute(Dbug(%s, -1))', $lnr) ;do refresh
		Case -1 To 1000 ;read
			If $case >= 0 Then ;read expression
				_GUICtrlListView_SetItemText($DBG_hListView, $case, DBG_Scope($exp2), 1)
				If _GUICtrlListView_GetItemText($DBG_hListView, $case) <> '' And $exp2 Then
					_GUICtrlListView_SetItemText($DBG_hListView, $case, DBG_Type($exp), 2)
					_GUICtrlListView_SetItemText($DBG_hListView, $case, DBG_Value($exp), 3)
				Else
					_GUICtrlListView_SetItemText($DBG_hListView, $case, '', 2)
					_GUICtrlListView_SetItemText($DBG_hListView, $case, '', 3)
				EndIf
			EndIf

			If $case >= 1000 Or $case >= _GUICtrlListView_GetItemCount($DBG_hListView) Then ;all expressions read
				For $c = 0 To _GUICtrlListView_GetColumnCount($DBG_hListView) - 1
					_GUICtrlListView_SetColumnWidth($DBG_hListView, $c, $LVSCW_AUTOSIZE_USEHEADER)
				Next

				Local $hHeader, $iFormat
				$hHeader = _GUICtrlListView_GetHeader($DBG_hListView)
				If $hHeader Then
					$val     = 0
					$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $DBG_ColSort)
					If BitAND($iFormat, $HDF_SORTDOWN) Then
						$val = 1
					ElseIf BitAND($iFormat, $HDF_SORTUP) Then
						$val = 2
					EndIf
					_GUICtrlListView_SortItems($DBG_hListView, $DBG_ColSort)
					$var     = 0
					$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $DBG_ColSort)
					If BitAND($iFormat, $HDF_SORTDOWN) Then
						$var = 1
					ElseIf BitAND($iFormat, $HDF_SORTUP) Then
						$var = 2
					EndIf
					If $var <> $val Then
						_GUICtrlListView_SortItems($DBG_hListView, $DBG_ColSort)
					EndIf
				EndIf
				If Not $DBG_FirstRun And $DBG_SelVal Then
					For $item = 0 To $case
						If _GUICtrlListView_GetItemText($DBG_hListView, $item) == $DBG_SelVal Then
							_GUICtrlListView_SetItemSelected($DBG_hListView, $item)
							_GUICtrlListView_EnsureVisible($DBG_hListView, $item)
							ExitLoop
						EndIf
					Next
				EndIf
				_GUICtrlListView_EndUpdate($DBG_hListView)
				Return StringFormat('Execute(Dbug(%s, -9))', $lnr) ;do loop
			EndIf

			;prepare next expression read
			$case += 1
			$var = _GUICtrlListView_GetItemText($DBG_hListView, $case)
			$var = StringReplace($var, '"', '''') ;escape "

			$scope = -2
			$vname = StringRegExp($var, '\$(\w{1,50})', 1)
			If IsArray($vname) Then $scope = StringFormat('IsDeclared("%s")', $vname[0])

			Switch $var
				Case '@ScriptFullPath'
					$var = '$___SrcFullPath'
				Case '@ScriptName'
					$var = '$___SrcName'
				Case '@Error'
					$var = '$DBG_Error'
				Case '@Extended'
					$var = '$DBG_Extended'
			EndSwitch

			$exp = StringFormat('Execute("%s")', $var)
			Return 'Execute(Dbug(' & $lnr & ', ' & $case & ', ' & $exp & ', ' & $scope & '))' ;do read
	EndSwitch
EndFunc

#Region internal func
Func DBG_GetExtErr($iErrDbg = @Error, $iExtDbg = @Extended)
	$DBG_Error    = $iErrDbg
	$DBG_Extended = $iExtDbg
EndFunc

Func DBG_Set(ByRef $x, $y) ;variable assignment
	$x = $y
	Return $x
EndFunc

Func DBG_Scope($res) ;return scope indication
	Switch $res
		Case -1
			Return "L" ;local
		Case 0
			Return "N/D" ;not defined
		Case 1
			Return "G" ;global
		Case -2
			Return "F" ;fixed (macro or literal)
	EndSwitch
EndFunc

Func DBG_Type($var) ;return type of $var
	Local $type, $size

	$type = VarGetType($var)

	Switch $type
		Case 'String'
			$type &= '[' & StringLen($var) & ']'
		Case 'Binary'
			$type &= '[' & BinaryLen($var) & ']'
		Case 'Array'
			For $i = 1 To UBound($var, 0)
				$size &= "[" & UBound($var, $i) & "]"
			Next
			$type &= $size
		Case 'DllStruct'
			$type &= '[' & DllStructGetSize($var) & ']'
		Case 'Ptr'
			If IsHWnd($var) Then $type = 'hWnd'
	EndSwitch
	Return $type
EndFunc

Func DBG_Value($var, $ext = $DBG_ExtInfo) ;return value of $var ($ext=true gives extended information)
	Local $val, $res
	If $ext And (IsArray($var) Or IsDllStruct($var) Or IsObj($var)) Then $DBG_ident &= '    '

	Select
		Case IsString($var)
			If StringLen($var) > 1000 Then $var = StringLeft($var, 1000) & ' ...'
			$val = "'" & $var & "'"
		Case IsArray($var)
			$DBG_ArrayCounter = 0
			If Not $ext Then
				Local $svar = "[" & DBG_ArrayToString($var, " ", Default, Default, "][") & "]" ; valdemar1977
				If $svar = "[-1]" Then
					Return $var ; valdemar1977
				ElseIf $DBG_ArrayCounter > $DBG_ArMaxOut Then
					$svar &= ' ...'
				EndIf
				Return $svar ; valdemar1977
			EndIf ; valdemar1977

			If $DBG_RedrawProc Then _SendMessage($DBG_GUI, $WM_SETREDRAW, False, 0)
			DBG_DispArr($var, $val)
			While GUIGetMsg()
			WEnd
		Case IsDllStruct($var)
			$val = '*' & DllStructGetPtr($var)
			If Not $ext Then Return $val

			For $e = 1 To 200 ;max elements, should be enough
				$res = DllStructGetData($var, $e)
				If @Error Then ExitLoop
				$val &= @CRLF & StringTrimLeft($DBG_ident, 4) & '[' & $e & '] '
				If IsString($res) Or IsBinary($res) Then
					$val &= DBG_Type($res) & @TAB & DBG_Value($res)
				Else
					For $i = 1 To 1000 ;max indexes, should be enough
						$res = DllStructGetData($var, $e, $i)
						If @Error Then
							ExitLoop
						ElseIf $i = 1 Then
							$val &= DBG_Type($res) & ' = ' & @TAB & DBG_Value($res)
						Else
							$val &= ', ' & DBG_Value($res)
						EndIf
					Next
				EndIf
			Next
		Case IsObj($var)
			If ObjName($var, 1) Then $val &= ObjName($var, 1)
			If Not $ext Then Return $val

			If ObjName($var, 2) Then $val &= @CRLF & StringTrimLeft($DBG_ident, 4) & "Desc: " & ObjName($var, 2)
			If ObjName($var, 3) Then $val &= @CRLF & StringTrimLeft($DBG_ident, 4) & "ID  : " & ObjName($var, 3)
			If ObjName($var, 4) Then $val &= @CRLF & StringTrimLeft($DBG_ident, 4) & "DLL : " & ObjName($var, 4)
			If ObjName($var, 5) Then $val &= @CRLF & StringTrimLeft($DBG_ident, 4) & "Icon: " & ObjName($var, 5)
		Case IsHWnd($var) Or IsPtr($var)
			$val = '*' & $var
		Case Else
			$val = $var
	EndSelect

	If $ext And (IsArray($var) Or IsDllStruct($var) Or IsObj($var)) Then $DBG_ident = StringTrimLeft($DBG_ident, 4)

	Return $val
EndFunc

Func DBG_DispArr(ByRef $ar, ByRef $out, $d = 0, $cnt = 0) ;display values of n-dimension array
	Local $res, $tmp
	If $cnt = 0 Then Dim $cnt[UBound($ar, 0)]

	For $i = 0 To UBound($ar, $d + 1)
		If $i = UBound($ar, $d + 1) Then Return $d - 1
		$cnt[$d] = $i
		If $d < UBound($ar, 0) - 1 Then $d = DBG_DispArr($ar, $out, $d + 1, $cnt) ;recursive call
		If $d = UBound($ar, 0) - 1 Then
			$tmp = $DBG_ArrayCounter
			$DBG_ArrayCounter = 0
			$res = Execute("$ar[" & DBG_ArrayToString($cnt, "][") & "]")
			$DBG_ArrayCounter = 0
			$out &= @CRLF & StringTrimLeft($DBG_ident, 4) & " [" & DBG_ArrayToString($cnt, "][") & "]" & DBG_Type($res) & '=' & @TAB & DBG_Value($res, True) ; valdemar1977
			$DBG_ArrayCounter = $tmp
		EndIf
		$DBG_ArrayCounter += 1
		If $DBG_ArrayCounter > $DBG_ArMaxOut Then
			$out &= @CRLF & ' ...'
			ExitLoop
		EndIf
	Next
EndFunc

Func DBG_SCISendMessage($i_msg, $wParam = 0, $lParam = 0, $s_t1 = "int", $s_t2 = "int") ;function and idea stolen from Martin
	If Not IsHWnd($DBG_hSci) Then Return 0
	Local $ret = DllCall($DBG_user32, "long", "SendMessageA", "long", $DBG_hSci, "int", $i_msg, $s_t1, $wParam, $s_t2, $lParam)
	If IsArray ($ret) Then Return $ret[0]
EndFunc

Func DBG_SCIGetCurWord() ;get current word under cursor from Scite
	Local $pos[2], $line, $sta, $end, $text, $char
	Local $tpoint ;= DllStructCreate("int X;int Y")

	$tpoint = _WinAPI_GetMousePos()
	If Not $DBG_hSci Or _WinAPI_WindowFromPoint($tpoint) <> $DBG_hSci Then Return ""

	$tpoint = _WinAPI_GetMousePos(True, $DBG_hSci)
	$pos[0] = DllStructGetData($tpoint, "X")
	$pos[1] = DllStructGetData($tpoint, "Y")

	$pos  = DBG_SCISendMessage(2022, $pos[0], $pos[1])
	$line = DBG_SCISendMessage(2166, $pos)
	$sta  = DBG_SCISendMessage(2167, $line)
	$end  = DBG_SCISendMessage(2136, $line)

	$text = ""
	For $c = $pos To $sta Step -1
		$char = Chr(DBG_SCISendMessage(2007, $c, 0))
		If Not StringRegExp($char, "[-@$_a-zA-Z0-9]") Then ExitLoop
		$text = $char & $text
	Next
	For $c = $pos + 1 To $end
		$char = Chr(DBG_SCISendMessage(2007, $c, 0))
		If Not StringRegExp($char, "[-@$_a-zA-Z0-9]") Then ExitLoop
		$text &= $char
	Next

	Switch $text
		Case '@ScriptFullPath'
			$text = '$___SrcFullPath'
		Case '@ScriptName'
			$text = '$___SrcName'
	EndSwitch

	Return $text
EndFunc

Func DBG_SaveListItems($lnr) ;save expression list for current line
	Local $items = '', $fx, $tmp
	For $i = 0 To _GUICtrlListView_GetItemCount($DBG_hListView) - 1
		$tmp = StringStripWS(_GUICtrlListView_GetItemText($DBG_hListView, $i), 3)
		If $tmp And Not StringRegExp($tmp, '^\s*<|>\s*$') Then $items &= $tmp & $DBG_d
	Next
	$tmp = StringRegExp($items, '([^' & $DBG_d & ']+)', 3)
	If IsArray($tmp) Then
		$items = ''
		_ArraySort($tmp)
		For $i = 0 To UBound($tmp) - 1
			$items &= $tmp[$i] & $DBG_d
		Next
	EndIf
	$fx = _ArraySearch($DBG_FunVars, $DBG_LineFun[$lnr])
	$DBG_FunVars[$fx][1] = StringTrimRight($items, 1)
	If $DBG_FunVars[$fx][1] = $DBG_FunVarsOrg[$fx][1] Then
		GUICtrlSetBkColor($DBG_ListView, 0xFFFFFF)
	Else
		GUICtrlSetBkColor($DBG_ListView, 0xFFFF80)
	EndIf
EndFunc

Func DBG_PopulateListView($lnr) ;populate listview
	Local $fx, $CurExpr, $i
	_GUICtrlListView_BeginUpdate($DBG_hListView)
	$fx = _ArraySearch($DBG_FunVars, $DBG_LineFun[$lnr])
	_GUICtrlListView_DeleteAllItems($DBG_hListView)
	$CurExpr = StringRegExp($DBG_FunVars[$fx][1], '([^' & $DBG_d & ']+)', 3)
	If IsArray($CurExpr) Then
		For $i = 0 To UBound($CurExpr) - 1
			If $CurExpr[$i] And $CurExpr[$i] <> '-1' Then _GUICtrlListView_AddItem($DBG_hListView, $CurExpr[$i]) ; valdemar1977
		Next
	EndIf
	If $DBG_FunVars[$fx][1] = $DBG_FunVarsOrg[$fx][1] Then
		GUICtrlSetBkColor($DBG_ListView, 0xFFFFFF)
	Else
		GUICtrlSetBkColor($DBG_ListView, 0xFFFF80)
	EndIf
EndFunc

Func DBG_StringEscape($in) ;try to get the quotes right
	Local $res
	$res = StringRegExp($in, '"|''', 2)
	If IsArray($res) Then
		If $res[0] = '"' Then
			$in = StringReplace($in, "'", "''")
			$in = StringReplace($in, '"', "'")
		Else
			$in = StringReplace($in, '"', "''")
		EndIf
	EndIf
	Return $in
EndFunc

Func DBG_LoadList()
	GUISetState(@SW_DISABLE, $DBG_GUI)
	$DBG_FunVars = $DBG_FunVarsOrg
	Local $val
	For $i = 0 To UBound($DBG_FunVarsOrg) - 1
		$val = IniRead($DBG_INI, "ListState", $DBG_FunVarsOrg[$i][0], Chr(7))
		If $val <> Chr(7) Then
			$DBG_FunVars[$i][1] = StringStripWS($val, 3)
		EndIf
	Next
	GUISetState(@SW_ENABLE, $DBG_GUI)
EndFunc

Func DBG_ChkWmMsg($lnr)
	Local $var = 0
	If $DBG_LineFun[$lnr] <> $dbg_NotifyFunc Then
		$dbg_NotifyCheck = 0
		DllCall($DBG_user32, "long", "SendMessageA", "long", $DBG_GUI, "int", $WM_NOTIFY, "int", 0, "ptr", $dbg_pNotify)
		If Not $dbg_NotifyCheck Then
			GUIRegisterMsg($WM_NOTIFY, "DBG_NotifyHook")
			$var = 1
		EndIf
	EndIf
	If Not $var And $DBG_LineFun[$lnr] <> $dbg_CommandFunc Then
		$dbg_IdCommand = 0
		DllCall($DBG_user32, "long", "SendMessageA", "long", $DBG_GUI, "int", $WM_COMMAND, "int", BitOR(0x02000000, $DBG_txtBreakPoint), "hwnd", GUICtrlGetHandle($DBG_txtBreakPoint))
		If Not $dbg_IdCommand Then
			$var = 2
			GUIRegisterMsg($WM_COMMAND, "DBG_CommandHook")
		EndIf
	EndIf

	If Not $var Then Return

	_SendMessage($DBG_GUI, $WM_SETREDRAW, True, 0)
	GUICtrlSetBkColor($DBG_lblStat, 0xFF0000)
	GUICtrlSetState($DBG_tabHlp, $GUI_SHOW)
	GUICtrlSetState($DBG_editHlp, $GUI_FOCUS)
	If $var = 1 Then
		$var = '\$dbg_NotifyFunc'
	Else
		$var = '\$dbg_CommandFunc'
	EndIf
	$var = StringRegExp(GUICtrlRead($DBG_editHlp), '(?is)^(.*\r\n\r\n)([^\r\n].*?' & $var & '[^\w].*?)\r\n\r\n', 3)
	If IsArray($var) Then
		$var[0] = StringLen($var[0])
		$var[1] = $var[0] + StringLen($var[1])
		GUICtrlSendMsg($DBG_editHlp, $EM_SETSEL, $var[0], $var[1])
		GUICtrlSendMsg($DBG_editHlp, $EM_SCROLLCARET, 0, 0)
		GUICtrlSendMsg($DBG_editHlp, $EM_SETSEL, $var[0], $var[1])
		GUICtrlSetState($DBG_editHlp, $GUI_SHOW)
	EndIf
EndFunc

Func DBG_NotifyHook($hWnd, $Msg, $wParam, $lParam) ;check if WM_NOTIFY not from dbug GUI
	Local $ret
	If $hWnd = $DBG_GUI Then
		If $lParam = $dbg_pNotify Then
			$dbg_NotifyCheck = 1
			Return 0
		EndIf
	ElseIf $dbg_NotifyFunc Then
		$ret = Call($dbg_NotifyFunc, $hWnd, $Msg, $wParam, $lParam) ;re-post notify message
		If @Error <> 0xDEAD And @Extended <> 0xBEEF Then Return $ret
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc

Func DBG_CommandHook($hWnd, $Msg, $wParam, $lParam) ;check if WM_COMMAND not from dbug GUI
	Local $ret
	If $hWnd = $DBG_GUI Then
		If $wParam = BitOR(0x02000000, $DBG_txtBreakPoint) Then
			$dbg_IdCommand = 1
		ElseIf BitAND($wParam, 0x0000FFFF) = $DBG_btnExit Then
			AdlibRegister('DBG_Exit', 10)
		EndIf
	ElseIf $dbg_CommandFunc Then
		$ret = Call($dbg_CommandFunc, $hWnd, $Msg, $wParam, $lParam) ;re-post notify message
		If @Error <> 0xDEAD And @Extended <> 0xBEEF Then Return $ret
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc

Func DBG_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam) ; valdemar1977
	If $hWnd = $DBG_GUI Then
		Local $Maximum = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
		DllStructSetData($Maximum, 7, 336) ; min X
		DllStructSetData($Maximum, 8, 380) ; min Y
		Return 0
	ElseIf $hWnd = $DBG_hWndArrayRange Then
		Local $Maximum = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam) ; valdemar1977
		DllStructSetData($Maximum, 7, 250)
		DllStructSetData($Maximum, 8, 116)
		Return 0
	EndIf
EndFunc

Func DBG_Show() ;let's show the thing
	If BitAND(WinGetState($DBG_GUI), 16) Then
		GUISetState(@SW_RESTORE, $DBG_GUI)
	EndIf
	If Not BitAND(WinGetState($DBG_GUI), 2) Then
		Local $res = WinGetClientSize($DBG_GUI)
		WinMove($DBG_GUI, '', @DesktopWidth - $res[0] - 24, 100)
	EndIf
	If $dbg_NoActivate Then
		GUISetState(@SW_SHOWNA, $DBG_GUI)
	Else
		GUISetState(@SW_SHOW, $DBG_GUI)
		WinActivate($DBG_GUI)
	EndIf
EndFunc

Func DBG_Exit() ;seen enough now
	AdlibUnRegister('DBG_Exit')
	_GUICtrlListView_UnRegisterSortCallBack($DBG_hListView) ; valdemar1977
	DBG_SCISendMessage(2045, 3) ;delete markers
	If Not @Compiled And FileExists(@ScriptFullPath) Then FileDelete(@ScriptFullPath)
	OnAutoItExitUnRegister('DBG__Exit')
	GUIDelete($DBG_GUI)
	DllClose($DBG_user32)
	If IsHWnd($DBG_hSci) Then
		$DBG_Tmp = WinGetHandle("[Class:SciTEWindow]")
		If $DBG_Tmp And WinGetProcess($DBG_hSci) = WinGetProcess($DBG_Tmp) And Not BitAND(WinGetState($DBG_Tmp), 16) Then
			WinActivate($DBG_Tmp)
		EndIf
	EndIf
	Exit
EndFunc

Func DBG__Exit()
	$DBG_EndRun = True
	Execute(Dbug($DBG_ExitLines, -2, 1))
EndFunc

Func DBG_btnRun()
	If GUICtrlGetState($DBG_btnBreak) <> $GUI_SHOW + $GUI_ENABLE Then ; valdemar1977
		GUICtrlSendMsg($DBG_btnRun, $BM_CLICK, 0, 0) ; valdemar1977
	EndIf
EndFunc

Func DBG_btnStep()
	If GUICtrlGetState($DBG_btnBreak) <> $GUI_SHOW + $GUI_ENABLE Then ; valdemar1977
		GUICtrlSendMsg($DBG_btnStep, $BM_CLICK, 0, 0) ; valdemar1977
	EndIf
EndFunc

Func DBG_btnStepOver()
	If GUICtrlGetState($DBG_btnBreak) <> $GUI_SHOW + $GUI_ENABLE Then ; valdemar1977
		GUICtrlSendMsg($DBG_btnStepOver, $BM_CLICK, 0, 0) ; valdemar1977
	EndIf
EndFunc

Func DBG_btnRunCursor()
	If GUICtrlGetState($DBG_btnBreak) <> $GUI_SHOW + $GUI_ENABLE Then ; valdemar1977
		GUICtrlSendMsg($DBG_btnRunCursor, $BM_CLICK, 0, 0) ; valdemar1977
	EndIf
EndFunc

Func DBG_btnBreak()
	If GUICtrlGetState($DBG_btnBreak) = $GUI_SHOW + $GUI_ENABLE Then ; valdemar1977
		GUICtrlSendMsg($DBG_btnBreak, $BM_CLICK, 0, 0)
	EndIf
EndFunc

Func DBG_ErrFunc()
	DllCall($DBG_user32, "bool", "MessageBeep", "uint", 64)
	Return 1
EndFunc

Func DBG_ConsoleWrite($sText)
	If $sText = '' Then Return
	Local $iLength = GUICtrlSendMsg($DBG_editConsole, 0x0E, 0, 0)
	If $iLength > 800000 Then
		GUICtrlSetData($DBG_editConsole, StringTrimLeft(GUICtrlRead($DBG_editConsole), 200000) & $sText)
	Else
		GUICtrlSendMsg($DBG_editConsole, 0xB1, $iLength, $iLength)
		GUICtrlSendMsg($DBG_editConsole, 0xC2, True, $sText)
	EndIf
	ConsoleWrite($sText)
EndFunc

Func DBG_ToolTipOpt()
	Local $aWin = WinList('[Class:tooltips_class32]')
	If IsArray($aWin) And $aWin[0][0] > 0 Then
		For $i = 1 To $aWin[0][0]
			If WinGetProcess($aWin[$i][1]) = @AutoItPID And Not BitAND(DBG_GetWindowLong($aWin[$i][1], 0xFFFFFFF0), $WS_BORDER) Then ; $GWL_STYLE = 0xFFFFFFF0
				_GUIToolTip_SetDelayTime($aWin[$i][1], 1, 50)
				_GUIToolTip_SetDelayTime($aWin[$i][1], 2, 30000)
				_GUIToolTip_SetDelayTime($aWin[$i][1], 3, 50)
			EndIf
		Next
	EndIf
EndFunc

Func DBG_GetWindowLong($hWnd, $iIndex)
	Local $sFuncName = "GetWindowLongW"
	If @AutoItX64 Then $sFuncName = "GetWindowLongPtrW"
	Local $aResult = DllCall($DBG_user32, "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex)
	If @Error Or Not $aResult[0] Then Return SetError(@Error + 10, @Extended, 0)
	Return $aResult[0]
EndFunc

Func DBG_StateButtons($iState = $GUI_ENABLE, $isDisableAll = 0)
	If $iState = $GUI_ENABLE Then
		For $i = 1 To 25 ;disable buttons
			ControlEnable($DBG_GUI, "", "[CLASS:Button;INSTANCE:" & $i & "]")
		Next
		GUICtrlSetState($DBG_btnBreak, $GUI_DISABLE)
		If GUICtrlRead($DBG_btnClearList) = $GUI_CHECKED Then
			GUICtrlSetState($DBG_btnInsert, $GUI_DISABLE)
			GUICtrlSetState($DBG_btnDelete, $GUI_DISABLE)
			GUICtrlSetState($DBG_btnOriginal, $GUI_DISABLE)
		EndIf
	Else
		For $i = 1 To 25 ;disable buttons
			ControlDisable($DBG_GUI, "", "[CLASS:Button;INSTANCE:" & $i & "]")
		Next
		If Not $isDisableAll Then
			GUICtrlSetState($DBG_btnBreak, $GUI_ENABLE)
			GUICtrlSetState($DBG_btnExit, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc

Func DBG_ArrayToString(Const ByRef $avArray, $sDelim_Item = "|", $iStart_Row = 0, $iEnd_Row = 0, $sDelim_Row = @CRLF, $iStart_Col = 0, $iEnd_Col = 0)
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iStart_Row = Default Then $iStart_Row = 0
	If $iEnd_Row = Default Then $iEnd_Row = 0
	If $iStart_Col = Default Then $iStart_Col = 0
	If $iEnd_Col = Default Then $iEnd_Col = 0
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($avArray, 1) - 1
	If $iEnd_Row = 0 Then $iEnd_Row = $iDim_1
	If $iStart_Row < 0 Or $iEnd_Row < 0 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, "")
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
	Local $sRet = ""
	Switch UBound($avArray, 0)
		Case 1
			For $i = $iStart_Row To $iEnd_Row
				$DBG_ArrayCounter += 1
				If $DBG_ArrayCounter > $DBG_ArMaxOut Then
					$sRet &= ' ...' & $sDelim_Item
					ExitLoop
				EndIf
				$sRet &= $avArray[$i] & $sDelim_Item
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Item))
		Case 2
			Local $iDim_2 = UBound($avArray, 2) - 1
			If $iEnd_Col = 0 Then $iEnd_Col = $iDim_2
			If $iStart_Col < 0 Or $iEnd_Col < 0 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
			For $i = $iStart_Row To $iEnd_Row
				For $j = $iStart_Col To $iEnd_Col
					$DBG_ArrayCounter += 1
					If $DBG_ArrayCounter > $DBG_ArMaxOut Then
						$sRet &= ' ...' & $sDelim_Row
						ExitLoop 2
					EndIf
					$sRet &= $avArray[$i][$j] & $sDelim_Item
				Next
				$sRet = StringTrimRight($sRet, StringLen($sDelim_Item)) & $sDelim_Row
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Row))
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return 1
EndFunc

; http://autoit-script.ru/index.php?topic=5443.0
Func DBG_ArrayDisplayEx(Const ByRef $avArray, $sTitle = "Array: ListView Display", $sScope = "Global", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "", $sReplace = "|", $sHeader = "")
	If Not IsArray($avArray) Then
; 		ConsoleWrite("! No array variable passed to function" & @CRLF)
		Return SetError(1, 0, 0)
	EndIf
	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then
; 		ConsoleWrite("! Larger than 2D array passed to function" & @CRLF)
		Return SetError(2, 0, 0)
	EndIf
	If $iUBound < 0 Or $iDimension < 1 Then Return SetError(3, 0, 0)

	; Separator handling
	If $sSeparator = "" Then $sSeparator = Chr(124)

	; Declare variables
	Local $vTmp, $tmp, $iBuffer = 64
	Local $iColLimit = 255
	Local $iOnEventMode = Opt("GUIOnEventMode", 0)
	Local $hGUI, $iStart = 0, $iColStart = 0
	_SendMessage($DBG_GUI, $WM_SETREDRAW, True, 0)

	If $iUBound > 99 Or $iSubMax > 19 Then
		Local $r1, $r2, $c1, $c2, $sNameAr = StringRegExpReplace($sTitle, '^[^\$]+', '')

		$tmp = StringRegExp(IniRead($DBG_INI, "Arrays", $sScope & " " & StringRegExpReplace($sNameAr, '\G([^>]*?)\[[^][]*\]', '\1[n]'), "-1,-1,-1,-1"), '(-?\d+)', 3)
		If IsArray($tmp) Then
			ReDim $tmp[4]
		Else
			Dim $tmp[4] = [-1, -1, -1, -1]
		EndIf
		$r1 = Number($tmp[0])
		If $tmp[1] = '' Then
			$r2 = -1
		Else
			$r2 = Number($tmp[1])
		EndIf
		$c1 = Number($tmp[2])
		If $tmp[3] = '' Then
			$c2 = -1
		Else
			$c2 = Number($tmp[3])
		EndIf
		If $r1 < 0 Then $r1 = 0
		If $r2 < 0 Then
			$r2 = $iUBound
			If $r2 < 0 Then $r2 = 0
		EndIf
		If $c1 < 0 Then $c1 = 0
		If $c2 < 0 Then
			$c2 = $iSubMax
			If $c2 < 0 Then $c2 = 0
		EndIf

		Local $Inp_r1, $Inp_r2, $Inp_c1, $Inp_c2, $ButOK, $ButCancel, $nMsg, $iFlag
		#Region ### START Koda GUI section ### Form=
		$hGUI = GUICreate("  Set range for array", 325, 129, -1, -1, 0, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
		GUISetIcon($DBG_Img, 21, $hGUI)
		GUISetFont(9, 400, 0, "Courier New", $hGUI)
		GUICtrlCreateLabel("Array : " & $sNameAr, 8, 8, 304, 17)
		GUICtrlSetTip(-1, "Array : " & $sNameAr)
		GUICtrlCreateGroup("Rows", 4, 28, 117, 73)
		GUICtrlCreateLabel("From", 8, 48, 32, 19, $SS_RIGHT)
		$Inp_r1 = GUICtrlCreateInput($r1, 44, 44, 69, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlCreateLabel("To", 8, 72, 32, 19, $SS_RIGHT)
		$Inp_r2 = GUICtrlCreateInput($r2, 44, 72, 69, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUICtrlCreateGroup("Columns", 128, 28, 117, 73)
		GUICtrlCreateLabel("From", 132, 48, 32, 19, $SS_RIGHT)
		$Inp_c1 = GUICtrlCreateInput($c1, 168, 44, 69, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlCreateLabel("To", 132, 72, 32, 19, $SS_RIGHT)
		$Inp_c2 = GUICtrlCreateInput($c2, 168, 72, 69, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$ButOK = GUICtrlCreateButton("Show", 254, 76, 59, 25, $BS_DEFPUSHBUTTON)
		GUICtrlSetTip(-1, 'Max' & @CRLF & 65536 & '  rows' & @CRLF & ($iColLimit + 1) & ' columns')
		$ButCancel = GUICtrlCreateButton("Cancel", 254, 36, 59, 25, 0)
		If $iUBound < 2 Then
			GUICtrlSetState($Inp_r1, $GUI_DISABLE)
			GUICtrlSetState($Inp_r2, $GUI_DISABLE)
		EndIf
		If $iSubMax < 2 Then
			GUICtrlSetState($Inp_c1, $GUI_DISABLE)
			GUICtrlSetState($Inp_c2, $GUI_DISABLE)
		EndIf
		GUICtrlSetState($ButOK, $GUI_FOCUS)
		GUISetState(@SW_SHOW, $hGUI)
		#EndRegion ### END Koda GUI section ###

		While True
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $ButCancel
					GUIDelete($hGUI)
					Return
				Case $ButOK
					$r1 = Number(GUICtrlRead($Inp_r1))
					$r2 = Number(GUICtrlRead($Inp_r2))
					$c1 = Number(GUICtrlRead($Inp_c1))
					$c2 = Number(GUICtrlRead($Inp_c2))
					If $r1 < 0 Then $r1 = 0
					If $r2 < 0 Then
						$r2 = $iUBound
						If $r2 < 0 Then $r2 = 0
					EndIf
					If $c1 < 0 Then $c1 = 0
					If $c2 < 0 Then
						$c2 = $iSubMax
						If $c2 < 0 Then $c2 = 0
					EndIf
					$iFlag = 1
					Select
						Case $r2 > $iUBound And $iUBound >= 0
							GUICtrlSetBkColor($Inp_r2, 0xFF0000)
						Case $r1 > $r2 Or $r2 - $r1 > 65536
							GUICtrlSetBkColor($Inp_r1, 0xFF0000)
							GUICtrlSetBkColor($Inp_r2, 0xFF0000)
						Case $c2 > $iSubMax And $iSubMax >= 0
							GUICtrlSetBkColor($Inp_c2, 0xFF0000)
						Case $c1 > $c2 Or $c2 - $c1 > $iColLimit
							GUICtrlSetBkColor($Inp_c1, 0xFF0000)
							GUICtrlSetBkColor($Inp_c2, 0xFF0000)
						Case Else
							$iFlag = 0
					EndSelect
					If $iFlag Then
						Sleep(250)
						If BitAND(GUICtrlGetState($Inp_r1), $GUI_ENABLE) Then
							GUICtrlSetBkColor($Inp_r1, 0xFFFFFF)
							GUICtrlSetBkColor($Inp_r2, 0xFFFFFF)
						EndIf
						If BitAND(GUICtrlGetState($Inp_c1), $GUI_ENABLE) Then
							GUICtrlSetBkColor($Inp_c1, 0xFFFFFF)
							GUICtrlSetBkColor($Inp_c2, 0xFFFFFF)
						EndIf
						ContinueLoop
					EndIf
					$iStart    = $r1
					$iUBound   = $r2
					$iColStart = $c1
					$iSubMax   = $c2
					If $r2 = UBound($avArray, 1) - 1 Then $r2 = -1
					If $c2 = UBound($avArray, 2) - 1 Then $c2 = -1
					IniWrite($DBG_INI, "Arrays", $sScope & " " & StringRegExpReplace($sNameAr, '\G([^>]*?)\[[^][]*\]', '\1[n]'), $r1 & ',' & $r2 & ',' & $c1 & ',' & $c2)
					Local $aPos = WinGetPos($hGUI)
					ToolTip('Wait ...', $aPos[0], $aPos[1], 'DBUG Array', 1)
					GUIDelete($hGUI)
					ExitLoop
			EndSwitch
		WEnd
	EndIf

	; Swap dimensions if transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp    = $iUBound
		$iUBound = $iSubMax
		$iSubMax = $vTmp
	EndIf

	; Set limits for dimensions
	If $iSubMax - $iColStart > $iColLimit Then $iSubMax = $iColStart + $iColLimit
; 	If $iItemLimit < 1 Then $iItemLimit = $iUBound
; 	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit

	;  Check the separator to make sure it's not used literally in the array
	Local $tmp = ''
	For $i = $iStart To $iUBound
		For $j = $iColStart To $iSubMax
			$tmp &= $avArray[$i][$j]
		Next
	Next
	If StringInStr($tmp, $sSeparator, 1) Then
		For $i = 1 To 255
			If $i >= 32 And $i <= 127 Then ContinueLoop
			If Not StringInStr($tmp, Chr($i), 1) Then
				$sSeparator = Chr($i)
				ExitLoop
			EndIf
		Next
	EndIf

	Local $sDataSeparatorChar = Opt("GUIDataSeparatorChar", $sSeparator)

	; Set header up
	If $sHeader = "" Then
		$sHeader = "Row  " ; blanks added to adjust column size for big number of rows
		For $i = $iColStart To $iSubMax
			$sHeader &= $sSeparator & "Col " & $i
		Next
	EndIf

	; Convert array into text for listview
	Local $avArrayText[$iUBound + 1]
	For $i = $iStart To $iUBound
		$avArrayText[$i] = "[" & $i & "]"
		For $j = $iColStart To $iSubMax
			; Get current item
			; Visibility of an array or object in the list
			; Editing: Garrett
			If $iDimension = 1 Then
				If $iTranspose Then
					$vTmp = $avArray[$j]
				Else
					$vTmp = $avArray[$i]
				EndIf
			Else
				If $iTranspose Then
					$vTmp = $avArray[$j][$i]
				Else
					$vTmp = $avArray[$i][$j]
				EndIf
			EndIf

			If IsArray($vTmp) Then
				$vTmp = '#Array(' & UBound($vTmp, 0) & '-D)'
			ElseIf IsObj($vTmp) Then
				$vTmp = '#Object(' & ObjName($vTmp) & ')'
			ElseIf IsDllStruct($vTmp) Then
				$vTmp = '#DllStruct(' & DllStructGetSize($vTmp) & ')'
			EndIf

			; Add to text array
			$vTmp = StringReplace($vTmp, $sSeparator, $sReplace, 0, 1)
			$avArrayText[$i] &= $sSeparator & $vTmp

			; Set max buffer size
			$vTmp = StringLen($vTmp)
			If $vTmp > $iBuffer Then $iBuffer = $vTmp
		Next
	Next

	#Region GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS              = 0x66
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM               = 0x40
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT               = 0x0200
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT                 = 0x2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT                = 0x4
	Local Const $_ARRAYCONSTANT_GUI_DOCKSIZE                 = 768
	Local Const $_ARRAYCONSTANT_GUI_DOCKHCENTER              = 8
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE              = -3
	Local Const $_ARRAYCONSTANT_LVIF_PARAM                   = 0x4
	Local Const $_ARRAYCONSTANT_LVIF_TEXT                    = 0x1
	Local Const $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH           = (0x1000 + 29)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT             = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE             = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_INSERTITEMW              = (0x1000 + 77)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVM_SETITEMW                 = (0x1000 + 76)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT         = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES             = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS            = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE             = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX               = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX               = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX                   = 0x00040000
	Local Const $_ARRAYCONSTANT_tagLVITEM                    = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"

	Local $iAddMask = BitOR($_ARRAYCONSTANT_LVIF_TEXT, $_ARRAYCONSTANT_LVIF_PARAM)
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", 0)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)
	#EndRegion

	#Region Set interface up
	Local $iWidth = 640, $iHeight = 240, $iExStyle = 0
	If GUICtrlRead($DBG_chkSetOnTop) = $GUI_CHECKED Then $iExStyle = $WS_EX_TOPMOST
	$tmp = $sTitle
	If $iStart <> 0 Or $iUBound <> UBound($avArray, 1) - 1 Then
		$tmp &= '  Rows:' & $iStart & '-' & $iUBound
	EndIf
	If $iDimension > 1 Then
		If $iColStart <> 0 Or $iSubMax <> UBound($avArray, 2) - 1 Then
			$tmp &= '  Columns:' & $iColStart & '-' & $iSubMax
		EndIf
	EndIf
	$hGUI = GUICreate($tmp, $iWidth, $iHeight, Default, Default, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX), $iExStyle)
	GUISetIcon($DBG_Img, 6, $hGUI)
	Local $aiGUISize = WinGetClientSize($hGUI)
	Local $hListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - 26, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	Local $hCopy     = GUICtrlCreateButton("Copy Selected", ($aiGUISize[0] / 2) - 120, $aiGUISize[1] - 23, 100, 20)
	Local $hDisplay  = GUICtrlCreateButton("Display SubArray", ($aiGUISize[0] / 2) + 20, $aiGUISize[1] - 23, 100, 20)
	GUICtrlSetResizing($hListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($hCopy, $_ARRAYCONSTANT_GUI_DOCKHCENTER + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKSIZE)
	GUICtrlSetResizing($hDisplay, $_ARRAYCONSTANT_GUI_DOCKHCENTER + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKSIZE)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)
	#EndRegion

	; Fill listview
	Local $aItem
	For $i = $iStart To $iUBound
		If GUICtrlCreateListViewItem($avArrayText[$i], $hListView) = 0 Then
			; use GUICtrlSendMsg() to overcome AutoIt limitation
			$aItem = StringSplit($avArrayText[$i], $sSeparator)
			DllStructSetData($tBuffer, "Text", $aItem[1])

			; Add listview item
			DllStructSetData($tItem, "Item", $i)
			DllStructSetData($tItem, "SubItem", 0)
			DllStructSetData($tItem, "Mask", $iAddMask)
			GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_INSERTITEMW, 0, $pItem)

			; Set listview subitem text
			DllStructSetData($tItem, "Mask", $_ARRAYCONSTANT_LVIF_TEXT)
			For $j = 2 To $aItem[0]
				DllStructSetData($tBuffer, "Text", $aItem[$j])
				DllStructSetData($tItem, "SubItem", $j - 1)
				GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMW, 0, $pItem)
			Next
		EndIf
	Next

	; adjust window width
	$iWidth = 0
	For $i = 0 To $iSubMax - $iColStart + 1
		$iWidth += GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i, 0)
	Next

	If $iWidth < 250 Then $iWidth = 220
	$iWidth += 30

	If $iWidth > @DesktopWidth -50 Then $iWidth = @DesktopWidth -100

	ToolTip('')
	; Show dialog
	WinSetTrans($hGUI, "", 0)
	GUISetState(@SW_SHOW, $hGUI)
	WinMove($hGUI, "", (@DesktopWidth - $iWidth) / 2, Default, $iWidth)
	WinSetTrans($hGUI, "", 255)
	$DBG_hWndArrayRange = $hGUI

	While 1
		Switch GUIGetMsg()
			Case $_ARRAYCONSTANT_GUI_EVENT_CLOSE
				ExitLoop
			Case $hCopy
				Local $sClip = ""

				; Get selected indices [ _GUICtrlListView_GetSelectedIndices($hListView, True) ]
				Local $aiCurItems[1] = [0]

				For $i = 0 To GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0)
					If GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, 0x2) Then
						$aiCurItems[0] += 1
						ReDim $aiCurItems[$aiCurItems[0] + 1]
						$aiCurItems[$aiCurItems[0]] = $i
					EndIf
				Next

				; Generate clipboard text
				If Not $aiCurItems[0] Then
					For $sItem In $avArrayText
						$sClip &= $sItem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aiCurItems) - 1
						$sClip &= $avArrayText[$aiCurItems[$i]] & @CRLF
					Next
				EndIf

				ClipPut($sClip)
			Case $hDisplay
				Local $iSelItem = -1

				For $i = 0 To GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0)
					If GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, 0x2) Then
						$iSelItem = $i
						ExitLoop
					EndIf
				Next

				If $iSelItem <> -1 Then
					$iSelItem += $iStart
					GUISetState(@SW_DISABLE, $hGUI)

					If $iDimension = 1 Then
						If IsArray($avArray[$iSelItem]) Then
							DBG_ArrayDisplayEx($avArray[$iSelItem], $sTitle & ">[" & $iSelItem & "]", $sScope)
						EndIf
					Else
						For $j = 0 To $iSubMax
							If IsArray($avArray[$iSelItem][$j]) Then
								DBG_ArrayDisplayEx($avArray[$iSelItem][$j], $sTitle & ">[" & $iSelItem & "][" & $j & "]", $sScope)
							EndIf
						Next
					EndIf

					$DBG_hWndArrayRange = $hGUI
					GUISetState(@SW_ENABLE, $hGUI)
					WinActivate($hGUI)
				EndIf
		EndSwitch
	WEnd

	GUIDelete($hGUI)

	Opt("GUIOnEventMode", $iOnEventMode)
	Opt("GUIDataSeparatorChar", $sDataSeparatorChar)

	Return 1
EndFunc

#Region InstallImg
Func DBG_InstallImg()
	If @TempDir And FileExists(@TempDir & "\") Then
		$DBG_Img = @TempDir & "\dbug.icl"
	Else
		$DBG_Img = @AppDataDir & "\AutoIt v3\dbug.icl"
	EndIf
	If FileExists($DBG_Img) And FileGetSize($DBG_Img) = 28160 Then Return
	Local $file = FileOpen($DBG_Img, 2 + 8 + 16)
	If $file <> -1 Then
		FileWrite($file, DBG_BinFile())
		FileClose($file)
	Else
		FileDelete($DBG_Img)
	EndIf
	If Not FileExists($DBG_Img) Then
		ConsoleWrite('! Debugger can not find the icons library: ' & $DBG_Img & @CRLF)
	EndIf
EndFunc

Func DBG_BinFile()
	Local $s = ''
	$s &= 'kbUATVqQAAMAAACCBAAw//8AALgAOBZAABghAOAADOsvkAAAVGhpcyBwcgBvZ3JhbSBjYQBubm90IGJlIABydW4gaW4gRABPUyBtb2RlIAAAuAFMzSG+BAAAtAkuigSEwAB07zPbsw8zyQBBzRBGM9u0AwDNEEK0As0Q6wDgut8A0VbzCADQ2KCns/iWVAB7SOdllD5mKAApzjcozKvoAQCmMZe1chYh4QCkUlhYn+mx6iDRiv1uCRWjUEUgAABMAQEMtw8BKgsFE2wIDAKEAQCgng6FBYGLAQCFAwBugwtINTQBAANABYIMED8BDAACggMGAwsAgBmua4MkrEAALnJzcmOAA3+COYFlgXOCbQcAgPMC9fgU1RbELAPCgigAAFSADsAB6MABLYBJqEgBAIDLCRYAQU/A28AFgRTYwAHBDfDAAcFJkAgCAIAARgAgwAFqBsABOMABB8FiwAEIncABaMABAWwAD4AKwAGqmMABC8ABsMAB'
	$s &= 'DMABusjAAQ3BacABwSH4wAGiD8FVAwCAwR8owAFWEcEvwAESwAFYwAETVcABcMABFMABiMABFWtBccABFsABuMAB0S/Qe8AFwS/owAHBL4Bywi8Y28ABwS8wwAHBL0jAAcEvtmDAAcEveMABwS+QwAFtwS+owAHBL8DAAcEv2JvAAcEv8MABwS8IBcMvtiDAAcEfOMABwS9QwAG9wS9owAHBLwAdwi+YwAFtwS+wwAHBL8jAAcsvAdXCL+DQBQkAMPgBL9AFVggBM9AFGPQCKPQCOFX0Akj0Alj0Amj0AnhV9AKI9AKY9AKo9AK4VfQCyPQC2PQC6PQC+F30AgiBSPEv9AIo9AI4VfQCSPQCWPQCaPQCeFX0Aoj0Apj0Aqj0ArhV9ALI9ALY9ALo9AL4XfQCCIF38S/0Aij0AjhV9AJI9AJY9AJo9AJ4VfQCiPQCmPQCqPQCuPXgAsgAl2iG2rBOAEr5ACaYAEn5AAAY+wBoHEn7ANAg'
	$s &= '+wA4JfsAoJIp+wAILvsAcDL7ACTYNvsAQDv7AKg/SfsAEET7AHhI+wDgkkz7AEhR+wCwVfsAJBha+wCAXvsA6GLp+wBQZ/sAuHB3sVwFAKrM/ADg/AD0/AAI8HpV+QAc/AAw/ABE/ABYVfwAbPwAgPwAlPwAqFX8ALz8AND8AOT8APip/AAMbfsAIPwANPwAqkj8AFz8AHDwAD74AP8wizIuYChQLlEAMCP5KwwAACwsDGUqKguHDz8APwCxAv0DODgXgoL/CgD+//7+/TAAIPz//f37MAD6/wj8/PjwAPn/NDSEE0L9A0lJJnv/A4f/A/8DAwBUVC93/wPH/wP/A/QhWDN2MQP/A0f/A/8D8BhcN3TxAhpAGpn/xsbm8AL8h7IAPwAzAB0dncD5AxBhYTpysQZDQ7Yw/ygorDIHcQBeXh73PwAwALEB+QNlZT4CcTEDMjK5/8nJOumwCvmyAD8AMwAxMUK4+gdpaUJvMQ76APr2//j4'
	$s &= '9P/3APfy//b28P/1APXu//T07P/xQPHn/+zs37AA5Yb/sQL9D21tRW3xEQO/A7cD6OjZ//PzDOL/sQL9A3FxSGwY/Pz3vwO4A+bm1WD/8vLh/7EC/QN0wHRMa/v79r8DuAM45eXU8gOxAv0Dd3dgTmn6+vS/A7QDpISkkzYASUklfP0DgHp6UWj6+vO/A/F0B7a2pVIlcQIwANBgAQsAfX1TZ/z89dD/+fnvMAzqchaxEsPxCjEAwsKx/zECMABDvgMBAH9/VU0wAGbrPwA6ACR9A8CAvj4AwLTvNgD/ATMAMIXAMHJ/Rn9Gfw8ADwAPAA8AAABhxqHBGX8wACHBIVBxAGHBEHlyARq/dAAxAWHFIccFAPEAJjAAJdB1ABB4ACdxAHM6QAKkmE0CzDEANrkATScCgJhNAswBATBzOgKhAAAABhwAGAYAnVIGrnYIPgVcDEzM/7kTIP/mnAjzASzmm8AG8/+3Df8BFglOIQEAo1gLzAEG'
	$s &= 'pFlCDAaGolcKmQEm1ACKDub9thL/1DiKDeYBDwEXDT+qX0AQzPfDTf8BB6uEYBEGQ6dcDTMBE3jzsSUCGwEPDTsBALEAZhbM6rJG//CIwl//AQuyZxcGQ3EBD+erOoILkR0BALkAbhzM7Lln/9eAmD3/7cJv/4EHGLpvHYIhgQXdpk4DggmVH8J3Isz0xQB5/+mtYf/YnDhQ/+yABYEJhQ3apgZahgcRAMp/KMz1AMd7/+6zZ//7iNiM/4EHyX4ngj8BgQXcq1//y4EqAs6VH9KHLsz4zECA//3ekv+BBdGMhi2Gf4EH9sh8wgUB1Q/ZjjPM/+OXIv/BAdiNM8YO3JHENjPBBPnQhMIGwQMh0Q/glTjMwQDflEI4xg7hljmZwQTugLJe5v7ckP/BAYfBA8EFzQ/lmjyuwAADyp/AA8z/4JT/+QjNffPBAvnNfPNw/9+T/8EC1TEJAOkonkCZwADMwQDonTw/ZsUCwQXhDyEA//8QAACA'
	$s &= 'AcMAzgMABADGwADDBwAAwfCPAADAyADBA8EFwQetwQn+wADBDijAEBDAAAogwAABQgEAAEAEq/8lEAAKYAAXYAAZ5ADqE2AAD2AADeQA4QHhAloaYAAY5AFhAwZBEymAFQEpj0gCoeGHoeEAJRMBOeACHuQFQeEAJlIqAmLhA1FYKQJj4QFkDQxgAAIAnlMHm8+SP+gA/rkd/9SOFehD4QGJE3c/BkhgAsxw/74i/+EA4QHpA6UEWgziY/OxQv/7GL0w/+EBZQOmWw0CSOEB+78y//mu4Aj/+7ws4gPhAmUEAKxhEpvZpVfowvdgZNihTejhAeECEK1iE0hgAczyviBM/+qkHWYA8LgcQv/hAuED4QS0aRegG7VqGJtgAMzhACHhAbZrGUjhAey/AGb/46xL/96iAD//2Zk0/92hAD7/4ahH/+azjFf/4QPhBM+ELO5mALxyHpm9cx/MAWEAtGkYzNuoWqD/zZFD/+AU/+UCh2EA4QRg'
	$s &= 'VsXmmz1hKgEOALdsGia6dSYA1OCsYP/RlkoA/9unW/rGeyUWtmkE4HaY4GaD3pMuNyBPBwDgCwNgFIPZAKJT5fbEeP/2gMJ2/+u3Z+zgFQKN6QTWizE54pcEOszgB4PXjDImFeADB2AMJuAHg8yOgDzZ+c2A/PlgjKHhAN6bQ9PgBTXtFAFgB3nimj/P3ZkAQdPRiDDO0I4AOtTir17m/NIYhfz94IvhAOqvWC7d4QTxHOAPCmAYeeoAqE3T98t47P0I2oz54Ir+/NaIAPn3yHXs6qdNrtPhA+EE/II1YACNYAD6tmAAyeQA4QFuFh8AHwCvHwAfAGGFBQAH4IgGoDhWBGCOAQB4YAA+YAIcNWAAAGAAgKB5YQDgP/fjBv+MCgAJtD9xPfE7sUB1cUEVMAASZARxQTEWCK0wAAUwADElAvQDEbE/AAkJCUgKCgpmAAUFBWYDAwNm8AEBAWYhB7RCcQUxBg4O9AYxBPUDAB4eHgAvICAg'
	$s &= 'Zt/f37D/zs7ONgC0BC8vCwEHAEhISC89PT0AZvDw8P/h4eEBMgC/v7//wMDAAP/R0dH/Dw8PIz8ECABYWFiyA+PjAuM6AMLCwv/ExGDE/9TU1D8ECABjRGNj8gPm5uY+AMYAxsb/yMjI/9gA2Nj/JycnZhoEGkU+BGtray9pAGlpZvHx8f/pBOnpPgDKysr/zADMzP/c3Nz/NoA2NmYgA5dEPQQAcnJyL3BwcGaA8/Pz/+zs7D4AAbEU0NDQ/5+O4wD/IQKblSECmgJDPQR4eHgvdnYAdmb09PT/7+8C7z4Ajn3S/5B/INT/o5LnMASdkhAhApxCPQR/f38AL319fWb29vYQ//Ly8jYArp3oAP+wn+n/koHWAP+Ug9j/ppXqAP8iAp+QIgKeAkE9BIWFhS+DgwCDZvj4+P/19QL1tgOyoen/s6IA6v+VhNn/l4ag2/+pmO0wBKE6SwEFAIqKii+IiIgQZsGw+boDtaTrAP+2pez/mIfc'
	$s &= 'AP+qme7/IwKlhorfAwMAJQKwOTAAEH/Es/u6A7in7AD/yrn+/yQCqWCGIwKoPZ8DOQSyQTAEsX7Gtfy8A61ggSQCrDsfAw8AJQgCszgwAHzJuP3DsgPxBCUCrzqfAg8AAQUAJgK1NyYCtOB7JQK0fPEEygExRc3xjH9wAPBDAB/UgXFFVVA+wLAB4OAA8DAA+FUwAPwwAP4wAf/xjIcff0Z/Rg8ADwALAAZtAOCZBWkAzHEAaQEwAA4WdEo/ADgAC4AA0TAr3xr/cQA0AwYLgAsLaA0NDYc/AAE4AGEE0A59AuchMQA94iz/tQALX0ACsR0dHX+xOMUMxcU/ADQANJ8o/whS50E+ABGIBOYQLS0teLFASkpKEP8/Pz8yAE1ISAD/Vk5O/1lRUQD/W1NT/zWDJRD/IY8RMgBm61UA/yGRE/83pigA/xt4EMkyMjIQdsvLy3IDTExMAv9wT/9VT0//aQBcXP94eVv/cgBjY/92ZWX/dwBm'
	$s &= 'Zv8olxT/dYDuZP8jlBH/MQNhsQM3Nzd0cUDxA1EV8AZOcAdLsAhwc1UA/7vdZv92eFoA/3BhYf9uYGAA/zSJJP8mmhMw/y2EHrJDsQM8PAA8ctLS0v9zhABI/6C5YP+ElUZZcgMxAHV1WHIAYABWVv+jumH/zADmgP/u97P/XBhUVP8xA7EDQEBAAHDW1tb/R0dHAv8wU/+On2P/WSpZMwRU8AxxdAiRnIBg/2pdXf9vcAgwWFBQ/zEDsQNERGBEbtra2vITMFP/OmZwDmHwCvID8AxQSQBJ/1ZNTf9cUghS/2JwCGdaWv8eU3AFMQOxA/ASbN7eAt6yE3Fxcf9tbSRt/3BX/6awnF9fqF//U7AGTbAJU/AF+llwFV/wGPEAMQOxA3ADGmqxZU0wBnBS/3R0BHT/MFf/k6Ro/wBnZ2f/YmJi/4JVMANLRUX/T7EZMXAGR0JC8mixA1BQgFBp5OTk/0+wBaMxBDEAS0tL8gxJsAsRcRFG'
	$s &= 'RkaxDv87OIA4/z47O/9OMAQDMQOxA1JSUmjq6mDq/+Xl5T8APwD/cbYQ5eXl/wEw6urqAP9SUlJoVVVVSk0AGGY0GE0APAD/QuM4O/8AACgABxAVAAMgAAMBAgUAAECqBBIuCQADFgADGqwBAYEZCSEhCWkrKwwLh7EBgR06OhiBgPn56f/z8+KqAQOBGYEdTU0pevT0AOT//8xE//7LAEP/7NKG/9raAMn/2NjH/9HRAsCKAc/Pvv/OzsC9/83NvP+BGYEdgFVVMHf19eaCH4j/7ojCD/X17sIA8cEM/Pz6wgDBAsUFwQ8DwQzBDlpaNHX29g7p7h/BDMEOXl44c4j39+vKH/f38cIA+NbWxcYCwQ/FAsEPwQwBwQ5jYzxy+PjuAdIf3d3O/9TUw3D/09PCziLBDMEOZ0BnQHD5+fHKH/n8+fXCAMEfxQLNQsEMwQ6Aa2tEbvv79NIfON7e0NYfwQzBDm9v4Edt/Pz3yh/FGcEfH8kc'
	$s &= 'xQLBP8EMwQ5zc0sQa/39+cYf9c5kAP/r0oX/6dCDAP/nzoH/5cyAAP/ky37/4sl8AP/gx3r/38Z5YP/exXj/wQzBDndAd05q/v78xh/9AMpC//zrhf/7AOqE//jFPf/2AOV///Tjff/zAMA4//Hgev/vgN54/++8NP9hBgFhB3p6UWj///4D5g/iB8lB//rHP4HjB8M8//XCOuMHwL42//C9NeIHYQbhYQd9fVNngAEfABAAoWEHf39VTWAAZn8A/3IA/5QcAP+MHwAfAB8AHwCrBgChExR8mxdgAAb1BwADBnOhAwiZzHFiAAZzpmEG4QBoAqMB+AcACAyfzEQfwP//ORH//2EBZQLAOBD//zIJZwIVAAANEKbMRSL8/zAtBvv/YQFlAjsWA2sCFQAUFq/MUzjA8v82GO3/YQFlAhhJLPBqAhUAGx25AMxgTuj/Pi3dxv9hAWUCVEPlagIVAAAiI8LMbGHj/zBFP9D/YQFlAmFXBt1q'
	$s &= 'AhUAKinMzISAefT/XVnh/2EBAWUCaF/d/0hEzANmAhUAMjDVzIt/wPj/bmrx/2EBZQLofXLsMAXgNgEPAAMAADk23cyWiPv/MIF49/+xADUBk4YHOwEPAAMAPzvkzKeAlP//n47+/7EAOTUBppM7AQ8AAwBEP9TpmTAAzDQAmT8BMwH/DwAPAA8ADwAPAA8ADwA/ickxAMAHMwDhDz8APwAvdwN/Rn9GBAAKsYlyOwAEeJRMBNaNSRwFqP89PwA1ACgoCwBdX0IN0pVVDSDx+bUA/3EAMzM0Dbc4AHc/ADMAdXUATa1xVB3Pw4cAQv//zlH//88AVv+5fTb/wYViQDIA0aRsNnw/AOsC//ADbrV0J/D/DNl0sgM2ANNi///A4Ij/461NfnQxAAP1gPEDlHc9zNmdIFP//+KQ9Ac4/wDZnVX/0pZM/3jgs3u+hPmE8QMxAO8A1Kv/3KBS///85ZlyAPV88XjxfP8H9wMQe3tTbbEA1ruO'
	$s &= 'gP/rr2L/7sH3jCc1APGA/wfr/7EDgoLEWmz1jCKZGj8APwCHMgAxA7EDiIhga/WMgDWsKP9i6lE/AA88AHECMQOxA46OZWrE+vrzjEK5Mj8APwCHMgAxA7EDlJRrafqM/NGFdos1APEP+QD1jLEDMJmZcGn2jLCE9M0IYv/rsIzpzYD/AOfKfv/lyHv/AOTFef/iwnb/AODAdP/fvnL/GN69cPKMsQOennQSaPqMyED2jPnoggHyjPW3L//y4XsZ94ysJPKMsQOionkf8Ij0jPAH8gNwjPrBOUT/+PCL9roy8gPzALMr//GwKP/wHK4m8gMxA7EDpqZ8H/+MDwAPAAAAsQOqqoC6TTAAZj8APwA/AID/jL8PAA8A/4x/Rg8AAQACMAD+DP/TPwA0hbECMQO5iHEBACsaDwBDRCkAAIBaNwCrXTkAvsQxALEAMQGxATACLTAABhg0AwoAUzAATXQARAK/nVsI48SAcg711H0R/TEAH7EA'
	$s &= 'MQGxATEC7wsAAH8ARQBNiE4EzcQAchH20XoS/7YgaBH/0Xo7AMJxwA/2iE0DzbECuQMAhUgAGopNA78AwHIX9sh0Ev+AsmYR/+bm5nIABMh0OwC8bQ/2iRhMAr8xA/UDiUoAAGyoYhPjwHAVEP+tYxHwwt7/4kzi4jIE8QC+bjsAoRhbCeMxA/UDjUsAAKe9dyv1rmQSUP/V1dVwSto6BKggYBH/tGc3AK9lDBH1MQP1A5JNAMQAyIU//de9ov8mtwDV1dX/6+vr/wClXhH/3t7e/wDi4uL/5ubm/0CjXBH/qmEDGK4AZhf9kk0AxAABBACWTwDEy4hCAP2zcCv/+Pj4AP+oZBz/olwSCP+fWguGnlkR/8ShWwCGZRv9AWYFfgCaUQCny4dA9QC+ezb/tXIt/wEBB7l2MP+vbCYQ/6RhHAI/4+PjAP/n5+f/nlsVYP+wayP1ATMFP54AUgBsv3gs48tAiEP/xYI9DgO7CHgz/wEA4sCe'
	$s &= '/wDJhkH/uXIl4wMBMwU/oVMAGqdZAAe/15NL9s+MIEf/zotGjgHBfgI5gh3SjEX2plgcBr+BGYUfAQClVQAATa9hDs3alk4A9tqXUv/Wk05BigHZllH/2YAvrjhgDc2BFYkdBQCoVgAATa1dCL/IfQAv49yXTvXjoABa/eOeWf3blgBO9cd8LuOtXBwHv4ERkR0FAKlWAKAaqlcAbIABpoABdsSEAYEFbIENmR0xAIACAcMA4AcAAMADD8cD1QDBCMEK8A8AAKD//wAAKMAQEMAACiDAAAFCAQAAQAQFkhoSwAAsDQ0NWPASEhKF4QDBCsEMxA4CCcAAFioqKnqzALOz39vb2//WANfX/83Pz//HAMjI/8TExP/FBcAAycAAxru7/6V4mprfwQrBDMQOAgA4ADg4c+np6f+wALCw/4WFhf9+AH9//3h5ef94UHd3/37AAIXAAGYdQADXwBTBCg0xQ0NDEG76+vrCye/w8AD/5+jo/+Dh'
	$s &= '4UD/3d3d/97AAOIBwADXzMz/6NnZBv/BCs0PTU1NXcMAw8Pa0dHR/8gAycn/vsDA/7ZIt7f/wDT/tMAAuYXAAL/AALWpqdrBCgHND1FRUQ1UVFRqWsAAZ9wAWmEFP0AA4ABWYSEfYQA/BQ8AAGyCAFxvjQHTcG+NANNhAT8GBwBxAIgEXHSTBtSUANQp/43VE/91B2ABYQI/BwAAdpAKAFx6mg7UmNM6AP+J1An/hNAAAP+Q1B7/epkMBtRhA3pemhFcgqEAF9Wjz1j/ns4ATv+RzCP/h8oACP+UzS7/ms3AP/+BoBTUYQT1BwCEoRaPhaEXuAFkAMyfxVL/i7k8H/9hAeUCYQS/GAAAAI6rHsypx2f/cJWzOP9hAT8GCwCUALQkq7DNc9WqaMVQ1WABqj8GCwCaALwqarHQeIStOMpZhWEBPwYLAKDCAC4zstJ9QLHRPGhAYQH9BeGHaQD+f4AAAPw/AAD4oE//YYphi2EAYQJpAP+M'
	$s &= 'CgAglWYAoQMgCQALYAAgCwDqE2AAF2AAGWAA4ahhAPVhARRgAA5kBeEG5QfhAVXhZxVgAB5gACZgAC0FYAAyYAAzczoCplhkMwLhg0ETG2QFAkM/JgMAnVIGzGEAdgw+Bf9dEACjWAvMEP+5E//hAKRZDAFuCK5jEwGrYBGgQqpfEJowAMEwAArKMADMOQD/tw7/cP+6GP+xALACNgSzAGgXAbFmFm7AAHkh1emqLvD6ALgk/P+8Hv//BLsb8AIZ//+5FwD//7gV//+1CgD//7IB//+8H0L/8ALMsmcXMgS6AG8dQsaBLdX0ALc4+/auEP/2DKwMPwA8APi7Lv8IuW4c8i/CdyKaAOm2aPDur0z/COmkJDAAIv/tryA0//C2QDIA77UAPf/vtDz/66sALf/oox//8LuES/8wA8zBdiHyBwDKfyjB9MV5/ADusmb/7LBf/wDruWD51pU92VDMgirOsAHMNQDkgK5O/+y+ZP+xAAjJfif2'
	$s &= 'D9KHLsoI98yAsAZq//TCAHb/3Z5I2dGGYC1hzoMrdmQwAsxw7cZ5/3EAsAH6F9kAjjPM+tKG//UAwHT/+dGF/9rAkDbO14wytgM1AhExANiNM74b4JU4AMz92Iz/+st/Dv9xAPEAPQLflDiZBzAAvyMAAOWaPMz/gOCU///bj/9xAA/xAF8CDwAFAOmeQJn1MADMOACZXwIPAA8ADwB/DwAPAA8ADwAPALRdNAD/+scwAMMwRnGLeAFyjHAB8oHwAYPPMAAwjDEAsYz//4x/Rv+M/4w/AP+M/4z/jP//jP+M/4z/jP+M/4z/jP+M//+M/4z/jP+M/4z/jD8A/4wDDwAAAF90QACCz+BQAHrCULIADwAPAAEJAGd+bgCJ2IrwAH/GirIADwAPAEqNAIqgAJblyACHdM3IsACfDwIPAAoAegCYxQCm8vcAlxzV97IADwAPAIanmRAAhKbMNQAOqu/g/wCj2v85ATICDwABRIizSACOtMwj'
	$s &= 'ALP5/yKy+P8KALX1/wCs4f8EgK/v/wGs7P+xAQcyAg8ABwCYwUgAmQDDzCix+f8SvQD9/wfA/v8auDz7/zEBsgEPAA8Aoc0ASACjz8wxrfj4/yqzsAOwADIBDwAPAAEFAKfXSACl18yfMgCxAA8ADwCO3Nw+MgD/DwD/jPyMfYv1jLGNMY4xAT8xj39Gf0YPAA8ADQCet6oAUwAQAAYWAAYZAAZWGhAGATYSAAYNAAYHBQADAww/ICFzA6PQHWQDcwALMwkDABegph1lA3AACyMEXwoOAAMFDYAwnwjMYQEDJHgGXCEXDQA0gKYNzCD/EP+BA5g1pw6GFYIH/yiOCwENADuvFMwr9hgg/zf3J/+BBTywBhWCFYEFOPco/1UM+UqKCw0AQbkbzABL5Db/QOAp/xBf607/gQdCuhwiXIEDWOhGggt79QZwhguNH0jCIsxnQNhQ/1zPQIIBfBjobf+BCYEBcuBeAP9o20z/fOpgMP+X/JDC'
	$s &= 'Bc0PTswAKcxy3Fz/Yc1ARf+E63j/wQNNCMsoXMEBi/N5/4CD72j/mf6UxgUBzQ9U1TDMkvqCicAXj//BAlPUL8IIAcECk/qG/5v/lwPKBQ0AWt02zJr/xJX/wQFa3DbGCMEDGJv/mc4FDQBf5DtyzMIA4zvKCNUFDQBi+Ok/mcAAzgjVBT8APwBpAQD//8MAgEDUwQDHAB8AAMMPAADBfUDZwMADxQDBA8EFwQfPqj/nBiiEdyBgAAGiAPAAAEAEUg2gB+Z74QCqF2AAFWAAE2AAEeQD1eF7C2AACGAABmAAIQkFYX0BYAAeBAQEiVACAgJPYAExYAAu1WAAKmAAJmAAIuED5ApbYQpBEgzkCGF9AgEQA4ADAy1MTEyd4AgeTOAIbYgfAAEJAgJB0Kenp8tgCGZgAOEWQQAAnUgAAJlgYpVCmf0HAQEBA2AAVRDX19f34BF7AgIAU2kAAKDMVVU67qAple5qFADhJGfEBMTEYAaozEtL'
	$s &= '3ND/T0/oYAGW/wcGAABbYQAAscxycgDr/zY2zv9BQbLY4Aecyf8GAQC84B0AuMybm/7/YGAA7v9JSdz/R0dy1eAHqcRgGGADHQC/AMyoqP//jo7/AP+Ghvz/dnbyAP9dXez/WlrkCWAImct9CAEB5YEFYACrYwDjrQEB25CwnJz/aAilxmMZN+Eh/xHgCDxhCWUIQ0MA1f9MTOT/VlYG738qagjer4CA+UFgMeH/VFTc5CGbBke/B2UI462Njf8A/5OT/P8BAcdguAEBuEO/BmoQq+PhKuEhAQHQoHQfAPEg8AEB4j2/BQ8ADwAPAKqHUBHCkAnAMADgMABW8HEAMEXg0D/gUD7+VTAA/zEAgzAAhzAAj/d/Rn9GCgAJ9IJ/hD8APYYrsQNwhg6wg0oQCF28/zAA8B8/ADgAMAKxAjEDMooBAABtcwgIk90QgBDM+RER2f8/AAE3AA8PzPkHB5IG3TEDJwx9uhYWy+2wA9EwAjEAtnQA'
	$s &= 'OQA3ATAPD8j5MQP3A4TMKBwczrAByDAAsv843NzccgDzADMB7u4O7joBMQP3A4nMIiIBcQG+/9HR0f/WFNbWNAStMgDq6uqD8gMzBL7/EhK+8AOCifgDjcw0NMdwAQq08AG0OgTi4uL/OObm5jIEsQExABQUCrbwA434A5LMRkagzv8mJrWwAaswAo6qPgQxATUAGBiw8AMCkvgDlsxKStL/ADMzu/8uLrj/gBMTn//Ozs68DIqeMAChMgAdHax8PgCazFBQ2P83N0C//yMjq/8BAPcA9/f/6Ojo/94A3t7/29vb/90E3d2wA5v/FhagUP8rK7XwA5r4A54AzFpa4v9CQsoPsgMFAPEAPwHK/05OCtbwA574A6LMYmJ66nBE1zIAAQC1AD8B1xUwT+LwA6L4A6W6YIBg7PlbW+P/PwBRPwBbW+fwI6X4I6gAcyoqx91jY+9g+W1t9f8/ADMAbABs9P9iYu75KVQpxfArqPgrqbB3qvXw'
	$s &= 'AKowBapwCT8AOAAxAv+wAjEDDwAPAA8ADwCwjDBE/z8APwA5AH9Gf0YIAHHEsYt/cYz/RD8AcYmxjbKIAAAcAHM6AqJkMwJyAXHKKhYCRG44AgCAk0sCq5hNAgLNMADBkEkCkmeANQJiIREBO7SOQzEEdoucUQXMNACEAKNYBr/JhBrjAOqnH/X8uSD/ATAA8eqmH8/HggAZpqNZCXh2PQYEMZIKAKJXCsz5CL9A/3EA97Uq/wD2rxz/97Ef/6j4tScxAPGwANYwAQC0+Lo0kKxjEDBfo1gL8ZVXIl0OAMzxszn/87hEIP/uqCT/sQDDfgwj3HEBMADBwn4iALvnqTey76sqAJDzuENtrWMSMEKpXg9xnQIAr2QAFMzrsEj/5qPANP/ut1L/8QAwAEKU9QGuYxNK8ACIAOSnRJHoqDttMMqIMU7wADYItmsAGczruGH/57BCVzIA7r9q/zEBtwRsGva2tWoZMscAhDB446hOa9wookxU'
	$s &= '8AEltQG9csAemb5zH8w9AHEBA3kOMAEz5bBhQOc4tGY/sAFDIQAAxnsAJiDpuG8/5rTgbEDFeiXxXwYAsAE6mTABzD0AcQE1As2CACol5rFmVOi1AHBr2JhEeM6DhCsytQHMgSlc8AEAzPPNhP/svXdhMgDwxX7/MQE1AtQAiTAZ4qdUTu2AvHZt7r90kfAAoIjVijFK+AGUMAAEzPQwBOq3cv/xB/AD8QD1AdqPNAbdAJU6QvjSiW30AMV9kPTHerLlgKhSu9uQNMEwAADM5qhS3PfOhAD/8sJ6//nTiQL/sQDJtSDbkDTMAAgA4JUAORnknkNf/NgAjpD6z4S0+9BAhtb81InxAAz/BQAs/wBM//vTif+A4ZY5zP7dkgIcAwl+AQDlmj0i558AQ3jxuWSm+s/AgM/+2o7xAAYAdgCB9fK7ZePnntRCvwBGhAAGzAEGDT8BAQDonT8Q6Z5Aqk0AA4wAA8EAA8wAA2qnAANsABsaASMA'
	$s &= 'C1wtAAOZET8uAAGDAYAHTYABA4ABgAWBgYADwaGAAeEAAIeAB4OFCRWAA8CAAeCAAfAJAEAA//8AACgAHxANgAEgAiOBAgAAQAT1ljYKgAEXgAGBY6UBgRcBgRsAISEJaSsrHAuHrQGBG4EfOjoYAIH5+en/8/PiD6YBwQvBDcEPTU0pegD09OT//8xE/wD+y0P/7NKG/wDZ2cj/19fG/wDV1cT/1NTD/wDS0sH/0NC//wDOzr3/zc28/wfBC8ENwQ9VVTB39UT15sIP/+6Iwg/1/PXuxgDBD8kDwQ/BC8ENAcEPWVk0WPb26QD/9tyS//XckQD/7N+z/+Pj1AD/4uLT/+Hh0gD/4ODR/9/f0AD/3t7P/93dzgPCAMELWlo0dSKZABr/OJEmQPf3HOv/wQLlAMELXl44IHM1rCjgwAD/+Ij47v/BAWLqUd4AAcULY2M8ckK5MgD/SaI0QPn58Q7/wQLlAMELZ2dAcAHBP2xsRVL7+/RA'
	$s &= '//rgmf/5wADwAOO6/+fn2//mAOba/+Xl2f/tVO3kwEPYwEPXwEPWCcAA1f/BC2trRG4BwQ9vb0dt/Pz38cpf/Pz6ZgDhL+kB4S8H4QXhBuEHc3NLa/0E/fnmP/XOZP/qANGE/+jPgv/mAM2A/+XMf//jAMp9/+HIe//fgMZ5/97FeP/hBQPhBuEHd3dOav7+AvzmD/3KQv/86wCF//rpg//35gCB//bDO//z4gB8//Hgev/v3sB4/++8NP/hBeEGAeEHenpRaP///gPmD+EH+8hA//nGID7/98Q84gf0wQA5//K/N//wvR414gfhBeEG4Qd9fVM+ZwACHwAMAOEG4Qd/fzRVTWAAZn8AbgBNgP/gB3EACQB1BGEA/4z/jP+M//+M/4z/jP+M/4z/jP+M/4zj/4ztjCEJ7+aMYQF/AMNjAOWMIxP/4GAA4oY54QBrZH8A5QXhjDEm/v/mjGEBfwAzAH9Gf0Z/Rv9/Rn9Gf0Z/Rn9Gf0Z/'
	$s &= 'Rn9G/39Gf0Z/Rn9Gf0Z/Rn9Gf0b/DwAPAH9Gf0Y/AD8Af0Z/Rj9/Rn9Gf0Z/RgIAEJAAFu9/RD8APAAxAwk/Rj8APwA/d0Y/Rj8APwB3RjVGREgA//9DR/7/hoYA7P/Nydr/y8cg2P/EwNE6AMK+AM//wb3O/8C8js12RjVG8QOViP/yAxjw7vUyADED+vr8/zIAsQB1AfEDdUaxQjFD/wc//wf5B3VGsUIxQ/kH8vHi9zIAycXWtgDxA7UAH/EDdUaxQjFD/wfY/9IAzt3/x8PU/8Z8wtO+CHVGsUIxQ/kH9vz1+TIA8Qe1AL0QdUaxQoMxQ/8H2P/T0N7/B/80AHVGNUb5B3UG8Qc5B7UAD/EPdUY1RvUHZGf1/wCGhev/hIPp/wCCgef/gIDl/wB/fuT/fXzi/wB7euD/ennf/zh5eN52RjVG9QdCRgD9/5KF/P+RhAD7/z1B+P+MfwD2/4p99P84PADz/4d68f+FeODv/zQ473ZG'
	$s &= 'NUb1BwHxA0FF/P8/Q/oB8gM8QPb/Oj71AfIDNjrx/zU58P/yA3VGP0YPAA8Ad0Y/Rj8A/z8Ad0bvQA8ADwAHAH9Gf0YDDwAPAMmJjf+pRWBP/8h8ftDYDwAAPGAAfwEEAHEDMQDw5eDk/9u/wbIA/wPwAyM/BLID5bm6MgPcqgCq/+3Y1P+7a0Zv/wOwAya5OToEwkBma//85OQyA+HAoaX/lEVKvwf4Azg1yU82BLEDQEj/+wTr6zIE+djY/9HAmJj/uFJc/wP0AxhC12M6BEAo/5C3AP/09P/CZmv/APzk5P/52Nj/ANyqqv+URUr/AgANAGAA/0/mdwD/Qtdj/zXJT+D/Jrk5/wFMAewBhgj76+sGhuO1tv8YrFJWC4YAVlz0iscGhgEeAVb//v4DAwyHgOW5uv+6Wl4HQ/EAL2D4kAJDAQsBEgEvAwVDEYfnxsj/yYl+jQNDBD8FOwUACUOFQ6+MSU+CPYFBu2tvhh8fjR2RIYEd'
	$s &= 'gT+FX7FZYv+HHxgAgSGBHYEhgR+FIYZfxxwAhR2BX/7v74IdgQn/oR3CTsQ/wQ7BTekOxk/AHjHBAtp0d+IOBQD0rOCu/+CbnMIAwQLRCAD/HwAAfg8AAGo8wAAYwAIAwQDAAgACB8AAAwAACAEAVAAcwAA+wAB/wAD/VcAE/sAG/MAI/sAKKFWACRDAACDAAAFCAQAIAEAE0yMTGR4DEBMlNQIOBhYsBwwAF8AADAARKT4CGBEbJEAcAwAaGhkgRBceIyPFAwYaBC4IgAEkACE+hBAAIj+EwQIEHDLDwQQCABcfJiPBDMUDADMyMYQtLSxmAcECAw4YFQAbMwB2AEWA6QBJiwD/AEyP/wBNiwDpACE7dgMOGR4VwQjBCsEMxQ8vNj0CU8AEkwQQGhMAAC5WpwBGiP8AAFek/wBHnP8AFEujwAKlwBCT/wCAO2qnBBAbE2EFEC42PlPlByM8UwASTUtJ3BIlOhCGAEqWYAWn/woAfM7/'
	$s &= 'AEmg/wAkTqljAUef4AGV/wASK0KGTUpJ3BAhPVgSaSIeMkYAMhBHgvcFb8YA/wNSrv8njtoA/wlUqv8JWbUBYAHZ/wNNpv8FAGzB/xBEfvcfCDVKMm0qDyc/CwAAUKn/J43X/wARX7n/O5vi/4AJV7D/CV27YgEIEVuz4ggAR5v/EBAqQwtpBwkUHgFhER4AUq//PZ0BYAVjv/9Mp+n/gApat/8KYsNgASDo/xFgumAD4/+MAEpgGmAFCBQg5hcAQEtWc0M+OrYAAFS1/2Gx7P8AJXPL/2q69P+AFWTA/xVszWABAPP/JXHG/2GyAu3gMaf/Pzo3thA+SlVzaRAyPEcARABVuf+BxvYA/zuF1f+Gy/sA/yFvyP8hd9ZBYAH6/zuD0WAD9zHgKav/MGEFDAAVMQBLDwBXuv+h2QD9/1eY3/+MywD5/xtvzf8bdwLcYAH6/1eX3P8Aodr+/wBQrv8YFzROIWEGAA0YIgAPHRkXYQNXswD+'
	$s &= 'Spvq/zyQ4gD/UaDp/16q7AD/Xq7y/1Ci6wD/PpDh/0qX5AD/A1Cm/hwZGBBhDRkkZgglJCQAXE5ZZLwfU4gApkWb3/9AoelQ/zqd52oAPuAJRYCa3v8fUYamYQUDYQblB0FLVGo6YgCIDDt0pgEQUQCRfg5quP0MewDR/w57zv8SdwDF/w190/8Oawi4/Q9gAzhxpQEAO2SJDEFMVmoB9YMrZJkVcmljAP93bmn/XldSAP8/NzL/K2edB2JfHwADAD9ddjpDAGSAfzxee38yCFJtOvUEnnkAAACYGQAAkAkAAPaA4IhhAMAge2EA9QFhAHL4YIz8P/+MCACgBgA6BWAACkQG4RkgDwAab2QAYQHhAiARAGGF4TMXV+gD4ZNhAxSkoSlgADEAcFAwpmFFKnQLYQHEEBHkCB1zUjCgnJlsQMTgAJ/1H/CVakDMMQBwBPYcBQAAoXJEtPns2f8wn29As58D9wP/9gzl/3QEOgStfEqkAPPj'
	$s &= 'zv+ndECfAJ1vQIucbkC7gT8AQLv579r/MQQHsQBwAnZJtIRSoPQA5M//q3Y/lagAdECe+/Dd//cE69UwANb/+OzXCP/47TEA2P/26mDT//PozjIEcQKpCHVARvEDuotaoAD15tD/rXc/kACsdz+R9ujS/wDu3cP/79/F/wDv4cf/8OLI/wDx5Mr/8uXL/zjy5sw2BLECMANBvwCSYaH159L/rwB4P4uweD+I9MDl0P/r2L4/BD8EAv/xAsOXaKL26QDT/7F5P4azegA/gPPjzf/p0g64PwQ/BDIExptroAPxDrADgaZzQKPCeKSF/zUAPwQ3BLEDtoB8P3jHmmmYcRIAtXs/fLl9PzTFMABysQHStpp/CDQEB/EBcQLxAsaYZI/4gO7Y/7d8P3fxFBC7fj8xMABs3MIAp//z4s3/9OXEz/8xFfLkzDIEsQOH8QFxAvECxJNdhbEdCLh8P7ZSvX8/L70wAGc5ADEEsQP0AC+1AgDDjlV7'
	$s &= '+vDb/7C6fT9wnyf2BGa0AwZmuQMBAMCHS3L6fPHcMgmfA/cDvwO0AYAAQWr99OH/vH/sP2mfA/YDTb8DugExDVJNNQH8eDAAOIAAGNNUPg8AAIBwAcDwAXECxfIC+ONDAQAQcD1RRv5oEEbhRD0BIUI9AWGKPQHvAUo9AaFJPQEGPwECmD0B/4EMPQGhSj0BoU89AaF8PQGSDD8BAA0/AQAOPwH/YlM9AeFQPQFhUj0BIYE9AT4TPwEiWD0B4Vw9ARYAAANJQ0wBMQEyAAEzATQBNQE2AAE3ATgBOQIxADACMTECMTICADEzAjE0AjE1AAIxNgIxNwIxADgCMTkCMjEC4DIyAjIzryEPAA8AAw8ACAA='
	Return DBG_DecompressData($s)
EndFunc

Func DBG_DecompressData(ByRef $iData, $iOnlyDecode = 0)
	Local $Ret, $iRet, $iDecode = 0, $tInput, $tBuffer, $tOutput
	If IsString($iData) Then
		If StringLeft($iData, 2) = '0x' Then
			$Ret = Binary($iData)
			$iOnlyDecode = 0
		ElseIf StringRight($iData, 1) = Chr(7) Then
			$Ret = StringTrimRight($iData, 1)
			$iDecode  = 1
			$iOnlyDecode = 1
		Else
			$Ret = $iData
			$iDecode = 1
		EndIf
	ElseIf Not IsBinary($iData) Then
		Return SetError(1, 0, 0)
	Else
		$Ret = $iData
	EndIf
	If $iDecode Then
		$iRet = DllCall('crypt32.dll', 'bool', 'CryptStringToBinaryW', 'wstr', $Ret, 'dword', 0, 'dword', 1, 'ptr', 0, 'dword*', 0, 'ptr', 0, 'ptr', 0)
		If @Error Or Not $iRet[0] Then Return SetError(2, 0, 0)
		$tInput = DllStructCreate('byte[' & $iRet[5] & ']')
		$iRet   = DllCall('crypt32.dll', 'bool', 'CryptStringToBinaryW', 'wstr', $Ret, 'dword', 0, 'dword', 1, 'ptr', DllStructGetPtr($tInput), 'dword*', $iRet[5], 'ptr', 0, 'ptr', 0)
		If @Error Or Not $iRet[0] Then Return SetError(3, 0, 0)
		If $iOnlyDecode Then Return DllStructGetData($tInput, 1)
	EndIf
	If Not IsDllStruct($tInput) Then
		$tInput = DllStructCreate("byte[" & BinaryLen($iData) & "]")
		DllStructSetData($tInput, 1, $iData)
	EndIf
	$tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer
	$iRet    = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", "ushort", 2, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"dword*", 0)
	If @Error Or $iRet[0] Then Return SetError(4, 0, '') ; error decompressing
	$tOutput = DllStructCreate("byte[" & $iRet[6] & "]", DllStructGetPtr($tBuffer))
	Return DllStructGetData($tOutput, 1)
EndFunc

Func DBG_BinFile_DebugIco()
	Local $s = ''
	$s &= 'LrNIAAABABAQEAFwIAAAaAQAABYAAHwAKAAYAJAAiAO4AQBAqwBsFAADAAYCEC4HBAZxCgABBgIBVgFmBQBEVQADIwgPCAADJAADhH8EAwELA'
	$s &= 'RMFAAErATMCABCADQ+ECggIZgQOAhUAA3YAOQrpACBEDf8ASAADRAt26QITAxsAASsBMwU/DigXEFOACZMABRMAIA8DpwBBgBldEQD/AFUW/w'
	$s &= 'BcFwD/AF4S/wBMD+D/ACMGp4ERgRWBGQGFHwsjEBIsIiqA3AEEAoYAT4AVAGAY/wCRFP8AUlmAHWIZgwVYgAlOABL/AgsEhiwiQCzcCycREgq'
	$s &= 'UFQAKMgRGFPcAhAGAOWob/xKoJ/8AAGwb/wB3Hv8EEqaABWIa/wB/ABX/BEIT9wgZBAwykKkLAGIY/wATpCf/BH4j/wARxSr/AHIc/4gAfR6C'
	$s &= 'BQV4I4MjgFQW/wIKAwsMHwHBIh4AaBr/EcYAKv8EhCT/Dt8AK/8AeR//AIYAIP8P3Sv/BH/wI/8QyMAUwTTBCsMMAQIAHjEicx8WHgC2AG4c/'
	$s &= 'xXxNAD/Epcz/xz7OgD/B4cn/weUKQD/HPk6/xKSMRD/FfIzwEYZ/xuAExq2HC8gcwogACAVRAByHf80APxN/xmvPf87AP9U/w+TMP8PAKEy/z'
	$s &= 'r/Uv8cAKk9/zT9Tv8AMmTAKB8Uxn4FAAQUAAcPAHMd/1j/AGr/GtRH/z//AFn/C5Yt/wqlADD/QP9b/x3PAkdABGr/AGca/zAFGAkPjA/BA2E'
	$s &= 'AQG8a/g3gOcBANwD/D+M5/xLxOgD/EPk5/w3nNgD/EsU4/xLUPDnAYRj+wgrDDMNeAQEAXClBL7wNUxwAphXHMf8M1ikQ/w3NKMoADNQoAP8W'
	$s &= 'xTL/DVEdDqbBCsEMxk8wIWofAFwrDCF5MQEEAFUWfgN8GP0BAJUX/wKTGP8FAIsZ/wGXGP8DAHwX/QRVFX4egHcwAR9dKwzAXAJqFeMVZyUVU'
	$s &= 'zsAUP9ZQFf/PSwAO/8ZEBj/FWsGJsK+JQAhTSg6JABXLX8fUSh/FwhAHjr1BJ55AAAAmBkAAJAJAAD0gAFjAMAge2EA9QFhAAD4HwAA/D8AAA'
	$s &= '=='
	Return DBG_DecompressData($s)
EndFunc

#EndRegion

#EndRegion

Func DBG_CreateAndRun() ;generate DbugScript.au3
	Opt('TrayIconHide', 1)
	Local $iEncoding, $file, $sInp, $aTmp, $iLenCur, $sTmp, $sOut, $tmp, $res, $line, $isForCompile = False
	If @Compiled Then Return
	$tmp = @ScriptDir & '\Dbug_' & StringRegExpReplace(@ScriptName, '\.[^.]*$', '')
	Local $sOutName = $tmp & '.au3'

	If FileExists($sOutName) Then
		$res = 1
		While 1
			$sOutName = $tmp & "_" & $res & ".au3"
			If Not FileExists($sOutName) Then ExitLoop
			$res += 1
		WEnd
	EndIf

	$iEncoding = FileGetEncoding(@ScriptFullPath)
	If $iEncoding < 1 Then $iEncoding = 512

	$file = FileOpen(@ScriptFullPath, $iEncoding)
	If $file = -1 Then
		ConsoleWrite('! DBUG Error: read error, file:' & @ScriptFullPath & @CRLF)
		Return
	EndIf
	$sInp = FileRead($file)
	FileClose($file)

	Local $oD = ObjCreate("Scripting.Dictionary")
	$oD.CompareMode = 1

	$sInp = StringRegExpReplace($sInp, '(?<=\v|^)((?:[^\v;"'']*["''](?(?<=")[^"\v]*"|[^''\v]*''))*[^\v;"'']*);\V*', '\1')
	$aTmp = StringRegExp($sInp, '(?is)\G(.*?)(((?<=\v|^)\h*#(?:cs|comments-start)(?!\w)\V*\v+)(?>.*?(?=(?3)|(?4))(?(?=(?3))(?2)))*+((?<=\v)\h*#(?:ce|comments-end)(?!\w)\V*\v*))', 3)
	If IsArray($aTmp) Then
		$iLenCur = StringLen($sInp)
		$sTmp    = ''
		For $i = 0 To UBound($aTmp) - 1 Step 4
			$iLenCur -= StringLen($aTmp[$i] & $aTmp[$i + 1])
			$sTmp &= $aTmp[$i]
			$sTmp &= StringRegExpReplace($aTmp[$i + 1], '\V+', '')
		Next
		If $iLenCur > 0 Then $sTmp &= StringRight($sInp, $iLenCur)
		$sInp = $sTmp
	EndIf
	$sInp = StringRegExpReplace($sInp, '\h+(?=$|\v)', '')
	$sInp = StringRegExpReplace($sInp, '(?i)(?<=\v|^)((?:[^\v;"'']*["''](?(?<=")[^"\v]*"|[^''\v]*''))*[^\v;"'']*)(?<!\w|\$)GUIRegisterMsg\s*\(\h*\$WM_COMMAND[^,()\v]*,\h*([^\v\)]+)\)', '\1$dbg_CommandFunc = \2')
	$sInp = StringRegExpReplace($sInp, '(?i)(?<=\v|^)((?:[^\v;"'']*["''](?(?<=")[^"\v]*"|[^''\v]*''))*[^\v;"'']*)(?<!\w|\$)GUIRegisterMsg\s*\(\h*\$WM_NOTIFY[^,()\v]*,\h*([^\v\)]+)\)', '\1$dbg_NotifyFunc = \2')

	$sInp = StringReplace($sInp, '@ScriptFullPath', '$___SrcFullPath')
	$sInp = StringReplace($sInp, '@ScriptName', '$___SrcName')
	$sInp = StringRegExpReplace($sInp, '(?i)(?<!\w)(ConsoleWrite)(?=[ \t]*\()', 'DBG_\1')
	$sInp = StringReplace($sInp, '@ScriptLineNumber', "''")

	$aTmp = StringRegExp($sInp, '\G(\V*)(?>\r\n|\n|\r|$)', 3)
	If Not IsArray($aTmp) Then
		ConsoleWrite('! DBUG Error: emty file:' & @ScriptFullPath & @CRLF)
		Return
	EndIf

	Local $isDebug = 1, $iNumLn = 3, $sNumLnDbg = ' ', $iNumScope = 1, $iIDX = 0, $aDataLine[UBound($aTmp) + 1][2]
	$aDataLine[0][0] = 'Global' ; CurScope
	$aDataLine[0][1] = ''
	$sOut  = '#Include-Once' & @CRLF
	$sOut &= 'EnvSet("___SrcFullPath", "' & @ScriptFullPath & '")' & @CRLF

	For $i = 0 To UBound($aTmp) - 1
		$aDataLine[$i + 1][0] = $aDataLine[0][0]
		If StringRegExp($aTmp[$i], '^\h*#') Then
			If StringRegExp($aTmp[$i], '(?i)^\h*#Include') Then
				If StringRegExp($aTmp[$i], '(?i)^\s*#Include\s.+?Dbug\.au3[''">]') And $sNumLnDbg <> ' ' Then
					ConsoleWrite('! Debug Error: Before the line : ' & String($i + 1) & ' : ' & $aTmp[$i] & @CRLF)
					ConsoleWrite('! should not be the source code!' & @CRLF)
					Return
				EndIf
			ElseIf StringRegExp($aTmp[$i], '(?i)(?<!\w)STOP DBUG') Then
				$isDebug = 0
			ElseIf StringRegExp($aTmp[$i], '(?i)(?<!\w)START DBUG') Then
				$isDebug = 1
			EndIf
		ElseIf $aTmp[$i] Then
			$tmp = StringRegExp($aTmp[$i], '(?i)^[ \t]*(?:Volatile[ \t]+)?Func[ \t]+(\w+)', 3)
			If IsArray($tmp) Then
				$aDataLine[0][0] = $tmp[0]
				$aDataLine[$i + 1][0] = $aDataLine[0][0]
				$iIDX = $i + 1
				$iNumScope += 1
			ElseIf StringRegExp($aTmp[$i], '(?i)^[ \t]*EndFunc') Then
				$aDataLine[0][0] = 'Global'
				$iIDX = 0
			ElseIf StringRegExp($aTmp[$i], '(?i)^[ \t]*Execute\(Dbug') Then
				ConsoleWrite('! Debug Error: line : ' & String($i + 1) & ' : ' & $aTmp[$i] & @CRLF)
				Return
			EndIf

			If $isDebug Then
				$tmp = StringRegExp(StringRegExpReplace($aTmp[$i], '[''"](?(?<=")[^"]*"|[^'']*'')', '""'), '(?i)(\$\w+|@(?!CR|LF|TAB)\w+)', 3)
				If IsArray($tmp) Then
					For $j = 0 To UBound($tmp) - 1
						Switch $tmp[$j]
							Case '$___SrcFullPath'
								$tmp[$j] = '@ScriptFullPath'
							Case '$___SrcName'
								$tmp[$j] = '@ScriptName'
						EndSwitch
						$aDataLine[$iIDX][1] &= $tmp[$j] & $DBG_d
					Next
				EndIf
				If Not StringRegExp($aTmp[$i], '(?i)^\s*(Volatile\s|Func\s|case\W)') And ($i = 0 Or Not StringRegExp($aTmp[$i - 1], '[ \t]_(;\d+)?$')) Then
					$sOut &= 'DBG_GetExtErr()' & @CRLF
					$sOut &= 'Execute(Dbug(' & ($i + 1) & '))' & @CRLF
					$sOut &= 'SetError($DBG_Error, $DBG_Extended)' & @CRLF
					$iNumLn += 3
					$sNumLnDbg &= String($i + 1) & ' '
				EndIf
			EndIf
		EndIf
		$sOut &= $aTmp[$i] & @CRLF
		$oD.Item($iNumLn) = $i + 1
		$iNumLn += 1
	Next

	$sOut &= @CRLF & 'Func DBG_PreSet()' & @CRLF
	$sOut &= '	Local $tmp' & @CRLF
	$sOut &= DBG_LinePreSet('$DBG_ExistLines', $sNumLnDbg)
	$sOut &= '	Dim $DBG_FunVars[' & $iNumScope & '][2]' & @CRLF
	$aDataLine[0][0] = 'Global'
	$iNumScope = 0
	$sNumLnDbg = ''
	For $i = 0 To UBound($aDataLine) - 1
		$sNumLnDbg &= $aDataLine[$i][0] & ' '
		If $i = 0 Or ($aDataLine[$i][0] <> 'Global' And $aDataLine[$i][0] <> $aDataLine[$i - 1][0]) Then
			$sOut &= '	$DBG_FunVars[' & $iNumScope & '][0] = "' & $aDataLine[$i][0] & '"' & @CRLF
			$tmp  = ''
			$aTmp = StringRegExp($aDataLine[$i][1], '([@\w\$]+)', 3)
			If IsArray($aTmp) Then
				If $oD.Count() Then $oD.RemoveAll()
				For $j = 0 To UBound($aTmp) - 1
					$oD.Item($aTmp[$j]) = 0
				Next
				$aTmp = $oD.Keys()
				_ArraySort($aTmp)
				For $j = 0 To UBound($aTmp) - 1
					$tmp &= $aTmp[$j] & $DBG_d
				Next
				$tmp = StringTrimRight($tmp, 1)
			EndIf
			$sOut &= DBG_LinePreSet('$DBG_FunVars[' & $iNumScope & '][1]', $tmp)
			$iNumScope += 1
		EndIf
	Next

	$sOut &= DBG_LinePreSet('$tmp', $sNumLnDbg)
	$sOut &= '	$DBG_LineFun = StringRegExp($tmp, "(\S+)", 3)' & @CRLF
	$sOut &= '	$DBG_LineFun[0] = 0' & @CRLF
	$sOut &= '	$DBG_FunVarsOrg = $DBG_FunVars' & @CRLF
	$sOut &= '	Return 1' & @CRLF
	$sOut &= 'EndFunc' & @CRLF

	If StringRegExp($sInp, '(?im)^[ \t]*#\V*(?<!\w)DBUG FOR COMPILE') Then
		$isForCompile = True
		$aTmp = StringRegExp($sOut, '(?im)^[ \t]*(#pragma[ \t]+\w[^\r\n]+)', 3)
		If IsArray($aTmp) Then
			$tmp = ''
			For $i = 0 To UBound($aTmp) - 1
				$tmp &= $aTmp[$i] & @CRLF
			Next
			$sOut = $tmp & StringRegExpReplace($sOut, '(?im)^[ \t]*#pragma[ \t]+\w[^\r\n]+(\r\n)?', '')
		EndIf
	EndIf

	$file = FileOpen($sOutName, 2 + $iEncoding)
	If $file = -1 Then
		ConsoleWrite('! DBUG Error: write error, file:' & $sOutName & @CRLF)
		Return
	EndIf
	FileWrite($file, $sOut)
	FileClose($file)

	If $isForCompile Then
		ConsoleWrite('+ DBUG shadow script for compilation generated.' & @CRLF)
		ConsoleWrite('"' & $sOutName & '" (1) :ready' & @CRLF)
		Return
	ElseIf StringRegExp($sInp, '(?im)^[ \t]*#pragma[ \t]+compile[ \t]*\([ \t]*Console[ \t]*,[ \t]*true') Then
		$sTmp = StringRegExpReplace(@AutoItExe, '[^\\]+$', '\1Aut2Exe\\Aut2exe.exe')
		If Not FileExists($sTmp) Then
			ConsoleWrite('! DBUG Error: not found compilator: ' & $sTmp & @CRLF)
			Exit
		EndIf
		EnvSet('_AutoItExe', @AutoItExe)
		EnvSet('_ScriptFullPath', $sOutName)
		EnvSet('_CmdLineRaw', StringRegExpReplace($CmdLineRaw, '^[^"]*"[^"]+"', ' '))
		$sOutName = @ScriptDir & '\DbgConsole.exe'
		If FileExists($sOutName) Then
			$res = 1
			While 1
				$sOutName = @ScriptDir & "\DbgConsole_" & $res & ".exe"
				If Not FileExists($sOutName) Then ExitLoop
				$res += 1
			WEnd
		EndIf
		$tmp = @ScriptDir & '\DbgConsole.au3'
		If FileExists($tmp) Then
			$res = 1
			While 1
				$tmp = @ScriptDir & "\DbgConsole_" & $res & ".au3"
				If Not FileExists($tmp) Then ExitLoop
				$res += 1
			WEnd
		EndIf
		$file = FileOpen($tmp, 2 + 8)
		If $file = -1 Then
			ConsoleWrite('! DBUG Error: write error, file:' & $sTmp & @CRLF)
			Exit
		EndIf
		#Region
		$sOut  = "#NoTrayIcon" & @CRLF
		$sOut &= "$AutoItExe = EnvGet('_AutoItExe')" & @CRLF
		$sOut &= "$ScriptFullPath = EnvGet('_ScriptFullPath')" & @CRLF
		$sOut &= "$CmdLineRaw = EnvGet('_CmdLineRaw')" & @CRLF
		$sOut &= "$sErr = ''" & @CRLF
		$sOut &= "If Not $AutoItExe Or Not FileExists($AutoItExe) Then" & @CRLF
		$sOut &= "$sErr = 'Not found AutoItExe:' & @CRLF & $AutoItExe & @CRLF" & @CRLF
		$sOut &= "ElseIf Not $ScriptFullPath Or Not FileExists($ScriptFullPath) Then" & @CRLF
		$sOut &= "$sErr = 'Not found ScriptFullPath:' & @CRLF & $ScriptFullPath & @CRLF" & @CRLF
		$sOut &= "EndIf" & @CRLF
		$sOut &= "If $sErr Then" & @CRLF
		$sOut &= "ConsoleWrite($sErr & @CRLF)" & @CRLF
		$sOut &= "Sleep(5000)" & @CRLF
		$sOut &= "Exit 1" & @CRLF
		$sOut &= "EndIf" & @CRLF
		$sOut &= "$hWnd = WinGetHandle(@ScriptFullPath)" & @CRLF
		$sOut &= "$hMenu = DllCall('User32.dll', 'hwnd', 'GetSystemMenu', 'hwnd', $hWnd, 'int', False)" & @CRLF
		$sOut &= "If Not @Error Then DllCall('User32.dll', 'bool', 'EnableMenuItem', 'handle', $hMenu[0], 'uint', 0xF060, 'uint', 1)" & @CRLF
		$sOut &= "WinSetState($hWnd, '', @SW_SHOW)" & @CRLF
		$sOut &= "WinSetOnTop($hWnd, '', 1)" & @CRLF
		$sOut &= "If $CmdLineRaw Then $CmdLineRaw = ' ' & $CmdLineRaw" & @CRLF
		$sOut &= "$res = StringFormat('""%s"" /ErrorStdOut ""%s""%s', $AutoItExe, $ScriptFullPath, $CmdLineRaw)" & @CRLF
		$sOut &= "$res = Run($res, @ScriptDir, Default, 1+8)" & @CRLF
		$sOut &= "WinSetTitle($hWnd, '', 'DBUG Console PID : ' & $res)" & @CRLF
		$sOut &= "While $res" & @CRLF
		$sOut &= "$line = StdoutRead($res)" & @CRLF
		$sOut &= "If @Error Then" & @CRLF
		$sOut &= "ConsoleWrite($line)" & @CRLF
		$sOut &= "Sleep(250)" & @CRLF
		$sOut &= "ConsoleWrite(StdoutRead($res) & @CRLF)" & @CRLF
		$sOut &= "ExitLoop" & @CRLF
		$sOut &= "ElseIf @Extended Then" & @CRLF
		$sOut &= "ConsoleWrite($line)" & @CRLF
		$sOut &= "Else" & @CRLF
		$sOut &= "Sleep(10)" & @CRLF
		$sOut &= "EndIf" & @CRLF
		$sOut &= "WEnd" & @CRLF
		$sOut &= "WinSetTitle($hWnd, '', 'DBUG process [PID:' & $res & '] completed. Exiting...')" & @CRLF
		$sOut &= "Sleep(1000)" & @CRLF
		#EndRegion
		FileWrite($file, $sOut)
		FileClose($file)

		Local $sIco = @ScriptDir & '\DbgConsole.ico'
		$file = FileOpen($sIco, 2 + 8 + 16)
		If $file <> -1 Then
			FileWrite($file, DBG_BinFile_DebugIco())
			FileClose($file)
		EndIf

		$sTmp = '"' & $sTmp & '" /in "' & StringRegExpReplace($tmp, '.+\\(.+)', '\1') & '" /out "' & StringRegExpReplace($sOutName, '.+\\(.+)', '\1') & '" /nopack /console /icon DbgConsole.ico'
		RunWait($sTmp, @ScriptDir)
		FileDelete($tmp)
		;FileDelete($sIco) ;ISN AutoIt Studio Modification: Do not delete the DbgConsole.ico..so the ISN can easily know the oem console was used. The ISN will delete this file.
		If Not FileExists($sOutName) Then
			ConsoleWrite('! DBUG Error: compile error, file:' & $sOutName & @CRLF)
			Exit
		EndIf

		ConsoleWrite('+ Debugging with OEM-console.' & @CRLF)

		$res = Run($sOutName, @ScriptDir)
		ProcessWaitClose($res)
		FileDelete($sOutName)
		Exit
	EndIf

	$res = StringFormat('"%s" /ErrorStdOut "%s"', @AutoItExe, $sOutName)
	If $CmdLine[0] Then $res &= StringRegExpReplace($CmdLineRaw, '^[^"]*"[^"]+"', ' ')

    Exit ;ISN AutoIt Studio Modification: We run the new created script using the ISN (and its output console). We can exit here.

	$res = Run($res, @ScriptDir, Default, 0x2) ;run the shadow script (with scriptname and -directory passed as arguments)
	ConsoleWrite('+ DBUG started [PID:' & $res & '].' & @CRLF & 'Press F6 for activate DBUG window. "#... STOP DBUG" and "#... START DBUG" - stop and resume debug below this line.' & @CRLF) ; valdemar1977
	While $res
		$line = StdoutRead($res)
		If @Error Then
			ConsoleWrite($line)
			Sleep(250)
			ConsoleWrite(StdoutRead($res) & @CRLF)
			ExitLoop
		ElseIf @Extended Then
			ConsoleWrite($line)
		EndIf
		Sleep(10)
	WEnd
	Exit
EndFunc

Func DBG_LinePreSet($sNameVar, $sVal)
	Local $ret = '', $aTmp
	If StringLen($sVal) <= 256 Then
		$ret = @TAB & $sNameVar & ' = "' & $sVal & '"' & @CRLF
	Else
		$aTmp = StringRegExp($sVal, '\G(.{1,200}(?!\w))', 3)
		If IsArray($aTmp) Then
			For $i = 0 To UBound($aTmp) - 1
				$ret &= @TAB & $sNameVar & ' '
				If $i Then $ret &= '&'
				$ret &= '= "' & $aTmp[$i] & '"' & @CRLF
			Next
		Else
			$ret = @TAB & $sNameVar & ' = "' & $sVal & '"' & @CRLF
		EndIf
	EndIf
	Return $ret
EndFunc


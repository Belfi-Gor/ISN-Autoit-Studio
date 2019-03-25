;Globale Variablen

Func _ISN_Skript_Testen()

	GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST_Testscript")
	GUIRegisterMsg($WM_SIZE, "WM_SIZE_Testscript")
	GUIRegisterMsg($WM_WINDOWPOSCHANGING, "_WM_WINDOWPOSCHANGING_Testscript")
	_PDH_Init()


	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($Testscript_file, $szDrive, $szDir, $szFName, $szExt)
	$starttime = _Timer_Init()
	GUICtrlSetData($DEBUGGUI_TITLE, $szFName & $szExt & " - " & _Get_langstr(306))
	GUICtrlSetData($ISN_Debug_Erweitert_Titel, $szFName & $szExt & " - " & _Get_langstr(306))




	If $starte_Skripts_mit_au3Wrapper = "false" Then
		_Show_DebugGUI()
		$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $Testscript_file & '" ' & $Testscript_file_parameter, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	Else
		$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /run /prod /ErrorStdOut /in "' & $Testscript_file & '" /UserParams ' & $Testscript_file_parameter, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	EndIf

   _ISN_Testscript_Advanced_Debugging_CleanUp()


	_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio("$Console_Bluemode", 1)
	_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_Write_debug", @CRLF & $szFName & $szExt & " -> Exit Code: " & $Data[1] & @TAB & "(" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)")
	_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio("$Console_Bluemode", 0)
	WinActivate($ISN_AutoIt_Studio_Mainwindow_Handle)
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Reregister_Hotkeys")
	_ISNHelper_testscript_exit()


EndFunc   ;==>_ISN_Skript_Testen

Func _ISN_Testscript_Advanced_Debugging_CleanUp()

	If $Erweitertes_debugging = "true" Then
		;Aufräumen nach erweitertem Debuggin
	  Dim $szDrive, $szDir, $szFName, $szExt
	 $TestPath = _PathSplit($Testscript_file, $szDrive, $szDir, $szFName, $szExt)

		If FileExists($szDrive & $szDir & $szFName & $szExt) Then FileDelete($szDrive & $szDir & $szFName & $szExt)
		If FileExists($szDrive & $szDir & $szFName & ".txt") Then FileDelete($szDrive & $szDir & $szFName & ".txt")
		If FileExists($szDrive & $szDir & $szFName & "_debug.au3") Then FileDelete($szDrive & $szDir & $szFName & "_debug.au3")
		If FileExists($szDrive & $szDir & "Dbug_" & $szFName & "_tmp" & $szExt) Then FileDelete($szDrive & $szDir & "Dbug_" & $szFName & "_tmp" & $szExt)
   EndIf
EndFunc


Func _ISNThread_initialize($Use_Watch_Guard = "1")
	$hGUI = GUICreate("", 450, 100)

	GUIRegisterMsg(0x004A, "_ISNPlugin_Receive_Message") ;Register _WM_COPYDATA

	Local $Plugin_Timer = 100 ;Wait about 10 Secounds to received an "unlock" command, otherwise it will crash with @error -1

	$GUI_old_Title = WinGetTitle($hGUI) ;Save old Window Title
	WinSetTitle($hGUI, "", "_ISNTHREAD_STARTUP_") ;Set new Title to the Windows, so the ISN AutoIt Studio can find it easily
	GUISetState(@SW_ENABLE, $hGUI) ;Enables the GUI. This also "fixes" the resizing problems at the startup of a plugin. I don´t know why ^^

	For $Timer = 0 To $Plugin_Timer
		Sleep(100)
		If $ISNPlugin_Status <> "locked" Then
			;The plugin is unlocked and can start!

			WinSetTitle($hGUI, "", "ISN_THREAD_" & $hGUI)

			;Set Plugin Variables
			$ISNPlugin_Message_Window_Handle = $hGUI
			$ISN_AutoIt_Studio_Mainwindow_Handle = Ptr(_ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 0)) ;Set the Mainwindow Handle
			$ISN_AutoIt_Studio_PID = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 2) ;Set the ISN AutoIt Studio PID
			$ISN_AutoIt_Studio_EXE_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 3) ;Set the ISN AutoIt Studio EXE Path
			$ISN_AutoIt_Studio_Config_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 4) ;Set the ISN AutoIt Studio config.ini Path
			$ISN_AutoIt_Studio_Languagefile_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 5) ;Set the ISN AutoIt Studio language file Path
			$ISN_AutoIt_Studio_opened_project_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 6) ;Set the path to the currently opened project
			$ISN_AutoIt_Studio_opened_project_Name = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 7) ;Set the name to the currently opened project
			$ISN_AutoIt_Studio_Data_Directory = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 8) ;Set the data directory path
			$ISN_AutoIt_Studio_ISN_file_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 9) ;Set the path to the project file of the current project

			;...and the LEGACY stuff
			$ISN_AutoIt_Studio_Fensterhandle = $ISN_AutoIt_Studio_Mainwindow_Handle
			$ISN_AutoIt_Studio_Projektpfad = $ISN_AutoIt_Studio_opened_project_Path
			$ISN_AutoIt_Studio_Konfigurationsdatei_Pfad = $ISN_AutoIt_Studio_Config_Path

			;Register the Watch Guard. If the ISN AutoIt Studio crashes, also close the Plugin (check every 60 seconds)
			If $Use_Watch_Guard = "1" Then AdlibRegister("_ISNPlugin_watch_guard", 60 * 1000)

			;Sends the ISN the "unlocked" message
			_ISNPlugin_send_message_to_ISN("unlocked")
			Return 1
		EndIf
	Next

	WinSetTitle($hGUI, "", "") ;Restore old Window Title
	GUIRegisterMsg(0x004A, "") ;Remove MsgRegister

	;No "unlock" command received
	SetError(-1)
	Return -1
EndFunc   ;==>_ISNThread_initialize


Func SetBitmap($hGUI, $hImage, $iOpacity)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)

	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap


Func _Get_langstr($str)
	$encoding = FileGetEncoding($ISN_AutoIt_Studio_Languagefile_Path)
	If $encoding = $FO_UTF8_NOBOM Or $encoding = $FO_UTF8 Then
		$get = _IniReadEx($ISN_AutoIt_Studio_Languagefile_Path, "ISNAUTOITSTUDIO", "str" & $str, IniRead(@ScriptDir & "\data\language\english.lng", "ISNAUTOITSTUDIO", "str" & $str, "#error#" & $str))
	Else
		$get = IniRead($ISN_AutoIt_Studio_Languagefile_Path, "ISNAUTOITSTUDIO", "str" & $str, IniRead(@ScriptDir & "\data\language\english.lng", "ISNAUTOITSTUDIO", "str" & $str, "#error#" & $str))
	EndIf
	$get = StringReplace($get, "[BREAK]", @CRLF)
	Return $get
EndFunc   ;==>_Get_langstr



Func ExtractIconEx($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall('shell32.dll', 'int', 'ExtractIconEx', _
			'str', $sIconFile, _
			'int', $nIconID, _
			'ptr', $ptrIconLarge, _
			'ptr', $ptrIconSmall, _
			'int', $nIcons)
	Return $nCount[0]
EndFunc   ;==>ExtractIconEx




Func Button_AddIcon($nID, $sIconFile, $nIconID, $nAlign)
;~ 	$sIconFile = $smallIconsdll
	Local $hIL = ImageList_Create(16, 16, BitOR($ILC_MASK, $ILC_COLOR32), 0, 1)
	Local $stIcon = DllStructCreate("int")
	ExtractIconEx($sIconFile, $nIconID, DllStructGetPtr($stIcon), 0, 1)
	ImageList_AddIcon($hIL, DllStructGetData($stIcon, 1))
	DestroyIcon(DllStructGetData($stIcon, 1))
	Local $stBIL = DllStructCreate("dword;int[4];uint")
	DllStructSetData($stBIL, 1, $hIL)
	DllStructSetData($stBIL, 2, 1, 1)
	DllStructSetData($stBIL, 2, 1, 2)
	DllStructSetData($stBIL, 2, 1, 3)
	DllStructSetData($stBIL, 2, 1, 4)
	DllStructSetData($stBIL, 3, $nAlign)
	GUICtrlSendMsg($nID, $BCM_SETIMAGELIST, 0, DllStructGetPtr($stBIL))
EndFunc   ;==>Button_AddIcon



Func _WinAPI_ShellExtractIcons($icon, $Index, $width, $height)
	Local $Ret = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $icon, 'int', $Index, 'int', $width, 'int', $height, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
	If @error Or $Ret[0] = 0 Or $Ret[5] = Ptr(0) Then Return SetError(1, 0, 0)
	Return $Ret[5]
EndFunc   ;==>_WinAPI_ShellExtractIcons

Func _SetIconAlpha($hWnd, $sIcon, $iIndex, $iWidth, $iHeight)

	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $iIndex <> 0 Then $iIndex = $iIndex - 1
	Local $hIcon = _WinAPI_ShellExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)

	If $hIcon = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hBitmap, $hObj, $hDC, $hMem, $hSv

	$hDC = _WinAPI_GetDC($hWnd)
	$hMem = _WinAPI_CreateCompatibleDC($hDC)
	$hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
	$hSv = _WinAPI_SelectObject($hMem, $hBitmap)
	_WinAPI_DrawIconEx($hMem, 0, 0, $hIcon, $iWidth, $iHeight, 0, 0, 2)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	_WinAPI_SelectObject($hMem, $hSv)
	_WinAPI_DeleteDC($hMem)
	_WinAPI_DestroyIcon($hIcon)
	_WinAPI_DeleteObject(_SendMessage($hWnd, 0x0172, 0, 0))
	_SendMessage($hWnd, 0x0172, 0, $hBitmap)
	$hObj = _SendMessage($hWnd, 0x0173)
	If $hObj <> $hBitmap Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	Return 1
EndFunc   ;==>_SetIconAlpha


Func WM_NCHITTEST_Testscript($hWnd, $iMsg, $iwParam, $ilParam)
	If IsDeclared("minidebug_GUI_sec") Then
		If $hWnd = $minidebug_GUI_sec And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
	EndIf

	If IsDeclared("minidebug_GUI_main") Then
		If $hWnd = $minidebug_GUI_main And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
	EndIf



EndFunc   ;==>WM_NCHITTEST_Testscript

Func _Testscript_Resize()
	_Testscript_Resize_Labels()
	GUISwitch($Debug_GUI_Extended)
	$ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_Prozess_CPU_Rahmen)
	If IsArray($ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array) Then
		$x = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[0] + (60 - 8)
		$y = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[1] + (85 - 52)
		$w = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[2] - (343 - 8 - 270) - 8
		$h = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[3] - (171 - 52 - 110) - 52

		_MG_Graph_optionen_position(1, $Debug_GUI_Extended, Int($x), Int($y), Int($w), Int($h))
		_MG_Graph_Achse_links(1, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30 * $DPI, 0.5)
		_MG_Graph_optionen_allgemein(1, Int($w / 3), 0, 110, 0x000000, 2)
		_MG_Graph_clear(1)
	EndIf

	$ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen)
	If IsArray($ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array) Then
		$x = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[0] + (60 - 8)
		$y = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[1] + (85 - 52)
		$w = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[2] - (343 - 8 - 270) - 8
		$h = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[3] - (171 - 52 - 110) - 52

		_MG_Graph_optionen_position(2, $Debug_GUI_Extended, Int($x), Int($y), Int($w), Int($h))
		_MG_Graph_Achse_links(2, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30 * $DPI, 0.5)
		_MG_Graph_optionen_allgemein(2, Int($w / 3), 0, 110, 0x000000, 2)
		_MG_Graph_clear(2)

	EndIf

	$ISN_Debug_Erweitert_RAM_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_RAM_Rahmen)
	If IsArray($ISN_Debug_Erweitert_RAM_Rahmen_Array) Then
		$x = $ISN_Debug_Erweitert_RAM_Rahmen_Array[0] + (70 - 8)
		$y = $ISN_Debug_Erweitert_RAM_Rahmen_Array[1] + (85 - 52)
		$w = $ISN_Debug_Erweitert_RAM_Rahmen_Array[2] - (343 - 8 - 260) - 8
		$h = $ISN_Debug_Erweitert_RAM_Rahmen_Array[3] - (171 - 52 - 110) - 52

		_MG_Graph_optionen_position(3, $Debug_GUI_Extended, Int($x), Int($y), Int($w), Int($h))
		_MG_Graph_Achse_links(3, True, 0, 220, 0, " MB", $Schriftfarbe, Default, 9, 40 * $DPI, 0.5)
		_MG_Graph_optionen_allgemein(3, Int($w / 3), 0, 220, 0x000000, 2)
		_MG_Graph_clear(3)

	EndIf

EndFunc   ;==>_Testscript_Resize

Func _Testscript_Resize_Labels()

	$ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_Prozess_CPU_Rahmen)
	If IsArray($ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array) Then
		GUICtrlSetPos($Debug_GUI_Prozess_CPU_Label, $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[0], ($ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[1] + $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[3]) - (22 * $DPI), $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[2], 22 * $DPI)
	EndIf

	$ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen)
	If IsArray($ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array) Then
		GUICtrlSetPos($Debug_GUI_CPU_Label, $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[0], ($ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[1] + $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[3]) - (22 * $DPI), $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[2], 22 * $DPI)
	EndIf

	$ISN_Debug_Erweitert_RAM_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_RAM_Rahmen)
	If IsArray($ISN_Debug_Erweitert_RAM_Rahmen_Array) Then
		GUICtrlSetPos($Debug_GUI_Prozess_RAM_Label, $ISN_Debug_Erweitert_RAM_Rahmen_Array[0], ($ISN_Debug_Erweitert_RAM_Rahmen_Array[1] + $ISN_Debug_Erweitert_RAM_Rahmen_Array[3]) - (22 * $DPI), $ISN_Debug_Erweitert_RAM_Rahmen_Array[2], 22 * $DPI)
	EndIf

EndFunc   ;==>_Testscript_Resize_Labels


Func WM_SIZE_Testscript($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $Debug_GUI_Extended
			_Testscript_Resize_Labels()


	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE_Testscript

Func _ISNHelper_testscript_exit()
   _ISN_Testscript_Advanced_Debugging_CleanUp()
	_HIDE_DebugGUI()
	_GDIPlus_Shutdown()
	_PDH_ProcessObjectDestroy($poCounter)
	_PDH_UnInit()
	_USkin_Exit()
	Exit
EndFunc   ;==>_ISNHelper_testscript_exit


;===============================================================================
;
; Function Name:   _RunReadStd()
;
; Description::    Run a specified command, and return the Exitcode, StdOut text and
;                  StdErr text from from it. StdOut and StdErr are @tab delimited,
;                  with blank lines removed.
;
; Parameter(s):    $doscmd: the actual command to run, same as used with Run command
;                  $timeoutSeconds: maximum execution time in seconds, optional, default: 0 (wait forever),
;                  $workingdir: directory in which to execute $doscmd, optional, default: @ScriptDir
;                  $flag: show/hide flag, optional, default: @SW_HIDE
;                  $sDelim: stdOut and stdErr output deliminter, optional, default: @TAB
;                  $nRetVal: return single item from function instead of array, optional, default: -1 (return array)
;
; Requirement(s):  AutoIt 3.2.10.0
;
; Return Value(s): An array with three values, Exit Code, StdOut and StdErr
;
; Author(s):       lod3n
;                  (Thanks to mrRevoked for delimiter choice and non array return selection)
;                  (Thanks to mHZ for _ProcessOpenHandle() and _ProcessGetExitCode())
;                  (MetaThanks to DaveF for posting these DllCalls in Support Forum)
;                  (MetaThanks to JPM for including CloseHandle as needed)
;
;===============================================================================

Func _RunReadStd($doscmd, $timeoutSeconds = 0, $workingdir = @ScriptDir, $flag = @SW_HIDE, $nRetVal = -1, $sDelim = @TAB)
	Local $aReturn, $i_Pid, $h_Process, $i_ExitCode, $sStdOut, $sStdErr, $runTimer
	Dim $aReturn[3]

	; run process with StdErr and StdOut flags
	$runTimer = TimerInit()
	$i_Pid = Run($doscmd, $workingdir, $flag, 6) ; 6 = $STDERR_CHILD+$STDOUT_CHILD
	$RUNNING_SCRIPT = $i_Pid
	GUICtrlSetData($Debug_gui_PID, _Get_langstr(1302) & " " & $i_Pid)
	$Dateil_Text = _Get_langstr(39) & ":" & @CRLF & $Testscript_file & @CRLF & @CRLF & _
			_Get_langstr(1302) & @CRLF & $i_Pid & @CRLF & @CRLF & _
			_Get_langstr(596) & @CRLF & $Testscript_file_parameter
	GUICtrlSetData($Debug_GUI_Details_Label, $Dateil_Text)
	; Get process handle
	Sleep(100) ; or DllCall may fail - experimental
	$h_Process = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $i_Pid)

	$iProcessID = $i_Pid


	$hPDHQuery = _PDH_GetNewQueryHandle()
	$aCPUCounters = _PDH_GetCPUCounters($hPDHQuery, "")
	$iTotalCPUs = @extended
	; Get the localized name for "Process"
	$sProcessLocal = _PDH_GetCounterNameByIndex(230, "")

	$poCounter = _PDH_ProcessObjectCreate($sProcess, $iProcessID)
;~ 	ConsoleWrite($poCounter & @CRLF)
	_PDH_ProcessObjectAddCounters($poCounter, "6;180") ; "% Processor Time;Working Set"
	_PDH_ProcessObjectCollectQueryData($poCounter)

	; create tab delimited string containing StdOut text from process
	$aReturn[1] = ""
	$sStdOut = ""
	While 1

		_Refresh_Debug($i_Pid)
		Sleep(500)
		$line = StdoutRead($i_Pid)
		If @error Then ExitLoop
		$sStdOut &= $line
		If $line <> "" Then _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_debug", $line) ;Asynchrones starten einer Func
	WEnd

	; fetch exit code and close process handle
	If IsArray($h_Process) Then
		Sleep(100) ; or DllCall may fail - experimental
		$i_ExitCode = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $h_Process[0], 'int*', 0)
		If IsArray($i_ExitCode) Then
			$aReturn[0] = $i_ExitCode[2]
		Else
			$aReturn[0] = -1
		EndIf
		Sleep(100) ; or DllCall may fail - experimental
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $h_Process[0])
	Else
		$aReturn[0] = -2
	EndIf

	$aReturn[0] = $sStdOut
	$aReturn[1] = $i_ExitCode[2]
	$aReturn[2] = $i_Pid
	Return $aReturn

	; return single item if correctly specified with with $nRetVal
	If $nRetVal <> -1 And $nRetVal >= 0 And $nRetVal <= 2 Then Return $aReturn[$nRetVal]

	; return array with exit code, stdout, and stderr
	Return $aReturn
EndFunc   ;==>_RunReadStd


Func _Refresh_Debug($PID)
	If $showdebuggui = "false" Then Return
	If $PID = "" Then Return
	WinSetOnTop($minidebug_GUI_main, "", 1)
	WinSetOnTop($minidebug_GUI_sec, "", 1)
	$secs = Round(_Timer_Diff($starttime) / 1000, 2)
	If ProcessExists($PID) Then
		$array = _ProcessProperties($PID)
		If $array = "0" Then $array = "-" ;Kann Arbeitsspeicher beim Testen über den AutoIt3 Wrapper nicht anzeigen :(
		GUICtrlSetData($DEBUGGUI_TEXT, $array)
	Else
		GUICtrlSetData($DEBUGGUI_TEXT, _Get_langstr(23))
	EndIf
	GUICtrlSetData($Debug_gui_Laufzeit, _Get_langstr(105) & " " & Sec2Time($secs))
	GUICtrlSetData($Debug_GUI_Details_Laufzeit_Label, _Get_langstr(105) & " " & Sec2Time($secs))

EndFunc   ;==>_Refresh_Debug

Func Sec2Time($nr_sec = 0)
	$sec2time_hour = Int($nr_sec / 3600)
	$sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc   ;==>Sec2Time

Func _PDH_GetCPUCounters($hPDHQuery, $sPCName = "")
	; Strip first '\' from PC Name, if passed
	If $sPCName <> "" And StringLeft($sPCName, 2) = "\\" Then $sPCName = StringTrimLeft($sPCName, 1)
	; CPU Usage (per processor) (":238\6\(*)" or English: "\Processor(*)\% Processor Time")
	Local $aCPUsList = _PDH_GetCounterList(":238\6\(*)" & $sPCName)
	If @error Then Return SetError(@error, @extended, "")
	; start at element 1 (element 0 countains count), -1 = to-end-of-array
	Local $aCPUCounters = _PDH_AddCountersByArray($hPDHQuery, $aCPUsList, 1, -1)
	If @error Then Return SetError(@error, @extended, "")
	Return SetExtended($aCPUsList[0], $aCPUCounters)
EndFunc   ;==>_PDH_GetCPUCounters

Func _ProcessProperties($Process = "")
	If $showdebuggui = "false" Then Return
	_PDH_CollectQueryData($hPDHQuery)
	If Not IsArray($aCPUCounters) Then Return
	Local $iCounterValue = _PDH_UpdateCounter($hPDHQuery, $aCPUCounters[UBound($aCPUCounters) - 1][1], 0, True)
	Local $aCounterVals = _PDH_ProcessObjectUpdateCounters($poCounter)
	If @error Then
		If @error = 32 Then $bProcessGone = True
	EndIf

	#cs

		$readram = ProcessGetStats ($pid,0)
		$ram = $readram[0]
		If $ram >= 1048576 Then
		$ram = StringFormat('%.3f', Round($ram / 1048576, 3)) & ' MB'
		Else
		$ram = StringFormat('%.1f', Round($ram/ 1024, 0)) & ' KB'
		EndIf

	#ce

	If IsArray($aCounterVals) Then
		$ram = StringFormat('%.3f', Round(($aCounterVals[1] / 1024) / 1000, 3)) & ' KB'
		$ram = StringReplace($ram, ".", ",")


		_MG_Wert_setzen(1, 1, Round($aCounterVals[0] / $_PDH_iCPUCount))
		_MG_Wert_setzen(2, 1, $iCounterValue)
		_MG_Wert_setzen(3, 1, Round(($aCounterVals[1] / 1024) / 1000, 3))
		_MG_Graph_plotten(1)
		_MG_Graph_plotten(2)
		_MG_Graph_plotten(3)
		GUICtrlSetData($Debug_GUI_Prozess_CPU_Label, _Get_langstr(307) & " " & Round($aCounterVals[0] / $_PDH_iCPUCount) & "%")
		GUICtrlSetData($Debug_GUI_CPU_Label, _Get_langstr(1305) & " " & $iCounterValue & " %")
		GUICtrlSetData($Debug_GUI_Prozess_RAM_Label, _Get_langstr(308) & " " & $ram)

		Return (_Get_langstr(307) & " " & Round($aCounterVals[0] / $_PDH_iCPUCount) & "%" & @CRLF & _Get_langstr(308) & " " & $ram)
	EndIf

	#cs
		$wmi = ObjGet("winmgmts:\\.\root\cimv2")
		Local $refresher = ObjCreate("WbemScripting.SWbemRefresher")
		$cols = $refresher.AddEnum($wmi, "Win32_PerfFormattedData_PerfProc_Process" ).ObjectSet
		Sleep(200)
		$refresher.Refresh
		For $proc In $cols
		If ($proc.IDProcess = $pid ) Then
		$ram = $proc.PrivateBytes
		$cpu = $proc.PercentProcessorTime

		If $ram >= 1048576 Then
		$ram = StringFormat('%.3f', Round($ram / 1048576, 3)) & ' MB'
		Else
		$ram = StringFormat('%.1f', Round($ram/ 1024, 1)) & ' KB'
		EndIf
		return (_Get_langstr(307)&" "&$cpu&"%"&"      "&_Get_langstr(308)&" "&$ram)
		EndIf
		Next
		return (_Get_langstr(23))
	#ce
EndFunc   ;==>_ProcessProperties

Func _Show_DebugGUI()
	If $showdebuggui = "false" Then Return
	$x = _ISNPlugin_Studio_Config_Read_Value("debugguiX", (@DesktopWidth - $width) - 10)
	$y = _ISNPlugin_Studio_Config_Read_Value("debugguiY", (@DesktopHeight - $height) - 40)
	If $x > @DesktopWidth - $width Then $x = (@DesktopWidth - $width) - 10
	If $y > @DesktopHeight - $height Then $y = (@DesktopHeight - $height) - 40
	WinMove($minidebug_GUI_sec, "", $x, $y)
	SetBitmap($minidebug_GUI_sec, $hImagedebug, 255)
	_WinAPI_SetLayeredWindowAttributes($minidebug_GUI_main, 0xFFFFFF)
	GUISetState(@SW_SHOW, $minidebug_GUI_main)
EndFunc   ;==>_Show_DebugGUI


Func _WM_WINDOWPOSCHANGING_Testscript($hWnd, $Msg, $wParam, $lParam)
	if $hWnd = $minidebug_GUI_sec then
	$minidebug_GUI_sec_Pos_Array = WinGetPos($minidebug_GUI_sec)
	if IsArray($minidebug_GUI_sec_Pos_Array) then
		WinMove($minidebug_GUI_main, "", $minidebug_GUI_sec_Pos_Array[0]+7, $minidebug_GUI_sec_Pos_Array[1]+4)
	endif
	endif
EndFunc

Func _HIDE_DebugGUI()
	If $starte_Skripts_mit_au3Wrapper = "true" Then Return
	SetBitmap($minidebug_GUI_sec, $hImagedebug, 0)
	GUISetState(@SW_HIDE, $minidebug_GUI_main)
	$debugpos = WinGetPos($minidebug_GUI_sec)
	If IsArray($debugpos) Then
		_ISNPlugin_Studio_Config_Write_Value("debugguiX", $debugpos[0])
		_ISNPlugin_Studio_Config_Write_Value("debugguiY", $debugpos[1])
	EndIf
EndFunc   ;==>_HIDE_DebugGUI


Func _STOPSCRIPT()
	If $ISN_Helper_running <> 1 Then Return
	$ISN_Helper_running = 0
	ProcessClose($RUNNING_SCRIPT)
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_debug", @CRLF & "> " & _Get_langstr(107) & " (" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)" & @CRLF)
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_log", _Get_langstr(107), "FF0000")
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_run_rule", "#ruletrigger_stopscript#")
	WinActivate($ISN_AutoIt_Studio_Mainwindow_Handle)
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Reregister_Hotkeys")
	_ISNHelper_testscript_exit()
EndFunc   ;==>_STOPSCRIPT

Func _GUISetIcon($hHandle, $sFile, $iName)
	;Edit by isi360
	Return _SendMessage($hHandle, $WM_SETICON, 1, _WinAPI_ShellExtractIcon($sFile, $iName, 16, 16))
EndFunc   ;==>_GUISetIcon

Func _Testscript_Show_Detail_GUI()
	GUISetState(@SW_SHOW, $Debug_GUI_Extended)
	_HIDE_DebugGUI()
EndFunc   ;==>_Testscript_Show_Detail_GUI

Func _Testscript_Hide_Detail_GUI()
	GUISetState(@SW_HIDE, $Debug_GUI_Extended)
	_Show_DebugGUI()
EndFunc   ;==>_Testscript_Hide_Detail_GUI

Func _Testscript_Graph_erstellen($GUI_HANDLE = "")

	; Graph 1 erstellen (Prozess CPU)
	_MG_Graph_erstellen(1, $GUI_HANDLE, Int(60 * $DPI), Int(85 * $DPI), Int(270 * $DPI), Int(110 * $DPI))
	_MG_Graph_optionen_allgemein(1, Int((270 * $DPI) / 3), 0, 110, 0x000000, 2)
	_MG_Graph_optionen_Plottmodus(1, 1, 1, 1, True)
	_MG_Graph_optionen_Rahmen(1, False, 0x494949, 2)
	_MG_Graph_optionen_Hilfsgitterlinien(1, 1, 10, 10, 1, 0x494949, 100)
	_MG_Graph_Achse_links(1, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30 * $DPI, 0.5)
	_MG_Kanal_optionen(1, 1, 1, 2, 0x00FF00, 0)

	; Graph 2 erstellen (Gesamte CPU)
	_MG_Graph_erstellen(2, $GUI_HANDLE, Int(410 * $DPI), Int(85 * $DPI), Int(270 * $DPI), Int(110 * $DPI))
	_MG_Graph_optionen_allgemein(2, 50 * $DPI, 0, 110, 0x000000, 2)
	_MG_Graph_optionen_Plottmodus(2, 1, 1, 1, True)
	_MG_Graph_optionen_Rahmen(2, False, 0x494949, 2)
	_MG_Graph_optionen_Hilfsgitterlinien(2, 1, 10, 10, 1, 0x494949, 100)
	_MG_Graph_Achse_links(2, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30 * $DPI, 0.5)
	_MG_Kanal_optionen(2, 1, 1, 2, 0x00FF00, 0)

	; Graph 2 erstellen (RAM)
	_MG_Graph_erstellen(3, $GUI_HANDLE, Int(70 * $DPI), Int(265 * $DPI), Int(260 * $DPI), Int(110 * $DPI))
	_MG_Graph_optionen_allgemein(3, 50 * $DPI, 0, 220, 0x000000, 2)
	_MG_Graph_optionen_Plottmodus(3, 1, 1, 1, True)
	_MG_Graph_optionen_Rahmen(3, False, 0x494949, 2)
	_MG_Graph_optionen_Hilfsgitterlinien(3, 1, 10, 10, 1, 0x494949, 100)
	_MG_Graph_Achse_links(3, True, 0, 220, 0, " MB", $Schriftfarbe, Default, 9, 40 * $DPI, 0.5)
	_MG_Kanal_optionen(3, 1, 1, 2, 0x00FF00, 0)

	; Graph 2 mit den aktuellen Einstellungen in der GUI darstellen
	_MG_Graph_initialisieren(1)
	_MG_Graph_initialisieren(2)
	_MG_Graph_initialisieren(3)
EndFunc   ;==>_Testscript_Graph_erstellen


;==================================================================================================
; Function Name:   _ShowMonitorInfo()
; Description::    Show the info in $__MonitorList in a msgbox (line 0 is entire screen)
; Parameter(s):    n/a
; Return Value(s): n/a
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _ShowMonitorInfo()
	If $__MonitorList[0][0] == 0 Then
		_GetMonitors()
	EndIf
	Local $msg = ""
	Local $i = 0
	For $i = 0 To $__MonitorList[0][0]
		$msg &= $i & " - L:" & $__MonitorList[$i][1] & ", T:" & $__MonitorList[$i][2]
		$msg &= ", R:" & $__MonitorList[$i][3] & ", B:" & $__MonitorList[$i][4]
		If $i < $__MonitorList[0][0] Then $msg &= @CRLF
	Next
	MsgBox(0, $__MonitorList[0][0] & " Monitors: ", $msg)
EndFunc   ;==>_ShowMonitorInfo

;==================================================================================================
; Function Name:   _MaxOnMonitor($Title[, $Text = ''[, $Monitor = -1]])
; Description::    Maximize a window on a specific monitor (or the monitor the mouse is on)
; Parameter(s):    $Title   The title of the window to Move/Maximize
;     optional:    $Text    The text of the window to Move/Maximize
;     optional:    $Monitor The monitor to move to (1..NumMonitors) defaults to monitor mouse is on
; Note:            Should probably have specified return/error codes but haven't put them in yet
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _MaxOnMonitor($Title, $text = '', $Monitor = -1)
	_CenterOnMonitor($Title, $text, $Monitor)
	WinSetState($Title, $text, @SW_MAXIMIZE)
EndFunc   ;==>_MaxOnMonitor

Func _Get_Monitor_Resolution($Monitor = -1)
	Local $array[2]
	If $Immer_am_primaeren_monitor_starten = "true" Then $Monitor = _get_primary_monitor()
	If $Monitor = -1 Then Return
	If $Monitor > $__MonitorList[0][0] Then $Monitor = 1
	If Not @error Then
		If $Monitor == -1 Then
			$Monitor = _GetMonitorFromPoint()
		ElseIf $__MonitorList[0][0] == 0 Then
			_GetMonitors()
		EndIf
		If ($Monitor > 0) And ($Monitor <= $__MonitorList[0][0]) Then
			Local $width = Int(($__MonitorList[$Monitor][3] - $__MonitorList[$Monitor][1]) / 2) * 2
			Local $height = Int(($__MonitorList[$Monitor][4] - $__MonitorList[$Monitor][2])) + $__MonitorList[$Monitor][2]
			$array[0] = $width
			$array[1] = $height
			Return $array
		EndIf
	EndIf
 EndFunc   ;==>_Get_Monitor_Resolution

;==================================================================================================
; Function Name:   _CenterOnMonitor($Title[, $Text = ''[, $Monitor = -1]])
; Description::    Center a window on a specific monitor (or the monitor the mouse is on)
; Parameter(s):    $Title   The title of the window to Move/Maximize
;     optional:    $Text    The text of the window to Move/Maximize
;     optional:    $Monitor The monitor to move to (1..NumMonitors) defaults to monitor mouse is on
;					$Ignore_primary Ist nur 1 wenn Monitore Identifiziert werden (dadurch wird _get_primary_monitor() übersprungen)
; Note:            Should probably have specified return/error codes but haven't put them in yet
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _CenterOnMonitor($Title, $text = '', $Monitor = -1, $Ignore_primary = 0)
	If $Monitor = -1 Then $Monitor = $Runonmonitor
	If $Immer_am_primaeren_monitor_starten = "true" And $Ignore_primary = 0 Then $Monitor = _get_primary_monitor()
	$hWindow = WinGetHandle($Title, $text)
	If $Monitor > $__MonitorList[0][0] Then $Monitor = 1
	If Not @error Then
		If $Monitor == -1 Then
			$Monitor = _GetMonitorFromPoint()
		ElseIf $__MonitorList[0][0] == 0 Then
			_GetMonitors()
		EndIf
		If ($Monitor > 0) And ($Monitor <= $__MonitorList[0][0]) Then
			; Restore the window if necessary
			Local $WinState = WinGetState($hWindow)
			If BitAND($WinState, 16) Or BitAND($WinState, 32) Then
				WinSetState($hWindow, '', @SW_RESTORE)
			EndIf
			Local $WinSize = WinGetPos($hWindow)
			Local $x = Int(($__MonitorList[$Monitor][3] - $__MonitorList[$Monitor][1] - $WinSize[2]) / 2) + $__MonitorList[$Monitor][1]
			Local $y = Int(($__MonitorList[$Monitor][4] - $__MonitorList[$Monitor][2] - $WinSize[3]) / 2) + $__MonitorList[$Monitor][2]
			WinMove($hWindow, '', $x, $y)
		EndIf
	EndIf
EndFunc   ;==>_CenterOnMonitor

Func _Monitor_Get_Resolution($Monitor = -1)
	Local $array[2]
	If $Monitor = -1 Then Return
	If $Monitor > $__MonitorList[0][0] Then $Monitor = 1
	If Not @error Then
		If $Monitor == -1 Then
			$Monitor = _GetMonitorFromPoint()
		ElseIf $__MonitorList[0][0] == 0 Then
			_GetMonitors()
		EndIf
		If ($Monitor > 0) And ($Monitor <= $__MonitorList[0][0]) Then
			Local $width = Int(($__MonitorList[$Monitor][3] - $__MonitorList[$Monitor][1]) / 2) * 2
			Local $height = Int(($__MonitorList[$Monitor][4] - $__MonitorList[$Monitor][2])) + $__MonitorList[$Monitor][2]
			$array[0] = $width
			$array[1] = $height
			Return $array
		EndIf
	EndIf
EndFunc   ;==>_Get_Monitor_Resolution

;==================================================================================================
; Function Name:   _GetMonitorFromPoint([$XorPoint = -654321[, $Y = 0]])
; Description::    Get a monitor number from an x/y pos or the current mouse position
; Parameter(s):
;     optional:    $XorPoint X Position or Array with X/Y as items 0,1 (ie from MouseGetPos())
;     optional:    $Y        Y Position
; Note:            Should probably have specified return/error codes but haven't put them in yet,
;                  and better checking should be done on passed variables.
;                  Used to use MonitorFromPoint DLL call, but it didn't seem to always work.
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _GetMonitorFromPoint($XorPoint = 0, $y = 0)
	If @NumParams = 0 Then
		Local $MousePos = MouseGetPos()
		Local $myX = $MousePos[0]
		Local $myY = $MousePos[1]
	ElseIf (@NumParams = 1) And IsArray($XorPoint) Then
		Local $myX = $XorPoint[0]
		Local $myY = $XorPoint[1]
	Else
		Local $myX = $XorPoint
		Local $myY = $y
	EndIf
	If $__MonitorList[0][0] == 0 Then
		_GetMonitors()
	EndIf
	Local $i = 0
	Local $Monitor = 0
	For $i = 1 To $__MonitorList[0][0]
		If ($myX >= $__MonitorList[$i][1]) _
				And ($myX < $__MonitorList[$i][3]) _
				And ($myY >= $__MonitorList[$i][2]) _
				And ($myY < $__MonitorList[$i][4]) Then $Monitor = $i
	Next
	Return $Monitor
EndFunc   ;==>_GetMonitorFromPoint

;==================================================================================================
; Function Name:   _GetMonitors()
; Description::    Load monitor positions
; Parameter(s):    n/a
; Return Value(s): 2D Array of Monitors
;                       [0][0] = Number of Monitors
;                       [i][0] = HMONITOR handle of this monitor.
;                       [i][1] = Left Position of Monitor
;                       [i][2] = Top Position of Monitor
;                       [i][3] = Right Position of Monitor
;                       [i][4] = Bottom Position of Monitor
; Note:            [0][1..4] are set to Left,Top,Right,Bottom of entire screen
;                  hMonitor is returned in [i][0], but no longer used by these routines.
;                  Also sets $__MonitorList global variable (for other subs to use)
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _GetMonitors()
	$__MonitorList[0][0] = 0 ;  Added so that the global array is reset if this is called multiple times
	Local $handle = DllCallbackRegister("_MonitorEnumProc", "int", "hwnd;hwnd;ptr;lparam")
	DllCall("user32.dll", "int", "EnumDisplayMonitors", "hwnd", 0, "ptr", 0, "ptr", DllCallbackGetPtr($handle), "lparam", 0)
	DllCallbackFree($handle)
	Local $i = 0
	For $i = 1 To $__MonitorList[0][0]
		If $__MonitorList[$i][1] < $__MonitorList[0][1] Then $__MonitorList[0][1] = $__MonitorList[$i][1]
		If $__MonitorList[$i][2] < $__MonitorList[0][2] Then $__MonitorList[0][2] = $__MonitorList[$i][2]
		If $__MonitorList[$i][3] > $__MonitorList[0][3] Then $__MonitorList[0][3] = $__MonitorList[$i][3]
		If $__MonitorList[$i][4] > $__MonitorList[0][4] Then $__MonitorList[0][4] = $__MonitorList[$i][4]
	Next
	Return $__MonitorList
EndFunc   ;==>_GetMonitors


;============================================================================================== _NumberAndNameMonitors
; Function Name:    _NumberAndNameMonitors ()
; Description:   Provides the first key elements of a multimonitor system, included the Regedit Keys
; Parameter(s):   None
; Return Value(s):   $NumberAndName [][]
;~        [0][0] total number of video devices
;;       [x][1] name of the device
;;       [x][2] name of the adapter
;;       [x][3] monitor flags (value is returned in Hex str -convert in DEC before use with Bitand)
;;       [x][4] registry key of the device
; Remarks:   the flag value [x][3] can be one of the following
;;       DISPLAY_DEVICE_ATTACHED_TO_DESKTOP  0x00000001
;;             DISPLAY_DEVICE_MULTI_DRIVER       0x00000002
;;            DISPLAY_DEVICE_PRIMARY_DEVICE    0x00000004
;;            DISPLAY_DEVICE_VGA               0x00000010
;;        DISPLAY_MIRROR_DEVICE  0X00000008
;;        DISPLAY_REMOVABLE  0X00000020
;
; Author(s):        Hermano
;===========================================================================================================================
Func _get_primary_monitor()
	Local $aScreenResolution = _DesktopDimensions()
	If Not IsArray($aScreenResolution) Then Return 1
	Return _GetMonitorFromPoint(($aScreenResolution[1] / 2), ($aScreenResolution[2] / 2))
EndFunc   ;==>_get_primary_monitor


;==================================================================================================
; Function Name:   _MonitorEnumProc($hMonitor, $hDC, $lRect, $lParam)
; Description::    Enum Callback Function for EnumDisplayMonitors in _GetMonitors
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _MonitorEnumProc($hMonitor, $hDC, $lRect, $lParam)
	Local $Rect = DllStructCreate("int left;int top;int right;int bottom", $lRect)
	$__MonitorList[0][0] += 1
	ReDim $__MonitorList[$__MonitorList[0][0] + 1][5]
	$__MonitorList[$__MonitorList[0][0]][0] = $hMonitor
	$__MonitorList[$__MonitorList[0][0]][1] = DllStructGetData($Rect, "left")
	$__MonitorList[$__MonitorList[0][0]][2] = DllStructGetData($Rect, "top")
	$__MonitorList[$__MonitorList[0][0]][3] = DllStructGetData($Rect, "right")
	$__MonitorList[$__MonitorList[0][0]][4] = DllStructGetData($Rect, "bottom")
	Return 1 ; Return 1 to continue enumeration
EndFunc   ;==>_MonitorEnumProc

; #FUNCTION# ====================================================================================================================
; Name ..........: _DesktopDimensions
; Description ...: Returns an array containing information about the primary and virtual monitors.
; Syntax ........: _DesktopDimensions()
; Return values .: Success - Returns a 6-element array containing the following information:
;                  $aArray[0] = Total number of monitors.
;                  $aArray[1] = Width of the primary monitor.
;                  $aArray[2] = Height of the primary monitor.
;                  $aArray[3] = Total width of the desktop including the width of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[2].
;                  $aArray[4] = Total height of the desktop including the height of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[3].
; Author ........: guinness
; Remarks .......: WinAPI.au3 must be included i.e. #include <WinAPI.au3>
; Related .......: @DesktopWidth, @DesktopHeight, _WinAPI_GetSystemMetrics
; Example .......: Yes
; ===============================================================================================================================
Func _DesktopDimensions()
	Local $aReturn = [_WinAPI_GetSystemMetrics($SM_CMONITORS), _ ; Number of monitors.
			_WinAPI_GetSystemMetrics($SM_CXSCREEN), _ ; Width or Primary monitor.
			_WinAPI_GetSystemMetrics($SM_CYSCREEN), _ ; Height or Primary monitor.
			_WinAPI_GetSystemMetrics($SM_CXVIRTUALSCREEN), _ ; Width of the Virtual screen.
			_WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN)] ; Height of the Virtual screen.
	Return $aReturn
EndFunc   ;==>_DesktopDimensions


Func WM_GETMINMAXINFO($hWnd, $msg, $wParam, $lParam)

	$tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)

	Switch $hWnd


		Case $Changelog_GUI
			DllStructSetData($tagMaxinfo, 7, $Changelog_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $Changelog_GUI_height)

		Case $Update_GUI
			DllStructSetData($tagMaxinfo, 7, $Programmupdate_width)
			DllStructSetData($tagMaxinfo, 8, $Programmupdate_height)

		Case Else
			DllStructSetData($tagMaxinfo, 7, $GUIMINWID) ; min X
			DllStructSetData($tagMaxinfo, 8, $GUIMINHT) ; min Y

	EndSwitch


	Return 0
EndFunc   ;==>WM_GETMINMAXINFO

Func _ISN_Helper_Nach_Updates_Suchen($Mode = "")
	GUICtrlSetData($update_newversion, _Get_langstr(334) & " " & _Get_langstr(335))
	GUICtrlSetData($update_prgressbarlabel, "0 %")
	GUICtrlSetData($update_prgressbar, 0)
	GUICtrlSetData($update_log, "")
	GUICtrlSetData($update_status, _Get_langstr(338))
	GUICtrlSetColor($update_status, $Schriftfarbe)
	GUICtrlSetColor($update_currentversion, $Schriftfarbe)
	GUICtrlSetColor($update_newversion, $Schriftfarbe)
	GUICtrlSetState($update_gobutton, $GUI_DISABLE)
	GUICtrlSetState($update_changelog_button, $GUI_DISABLE)
	GUICtrlSetState($Loading_logo, $GUI_SHOW)
	GUICtrlSetImage($Loading_logo, $Loading2_Ani)
	Button_AddIcon($update_cancelbutton, $smallIconsdll, 1173, 0)
	GUICtrlSetData($update_cancelbutton, _Get_langstr(8))
	GUICtrlSetData($update_currentversion, _Get_langstr(333) & " " & $Studioversion & " (" & $VersionBuild & ")")
	GUICtrlSetData($Update_gefunden_GUI_aktuelle_Version, _Get_langstr(333) & " " & $Studioversion & " (" & $VersionBuild & ")")
	If $Mode = "normal" Then GUISetState(@SW_SHOW, $Update_GUI)

	$result = _Beginne_Suche_nach_updates()
	If $Mode <> "normal" Then
		If $result = 1 Then GUISetState(@SW_SHOW, $Update_gefunden_GUI) ;new update found
		If $result = 2 Or $result = 0 Then _ISNHelper_Updater_exit() ;no new update
	EndIf

EndFunc   ;==>_ISN_Helper_Nach_Updates_Suchen

Func _ISN_Helper_Neues_Update_Gefunden_Show_Update_GUI()
	GUISetState(@SW_HIDE, $Update_gefunden_GUI)
	GUISetState(@SW_SHOW, $Update_GUI)
EndFunc   ;==>_ISN_Helper_Neues_Update_Gefunden_Show_Update_GUI


Func _Directory_Is_Accessible($sPath)
	If Not StringInStr(FileGetAttrib($sPath), "D", 2) Then Return SetError(1, 0, 0)
	Local $iEnum = 0
	While FileExists($sPath & "\_test_" & $iEnum)
		$iEnum += 1
	WEnd
	Local $iSuccess = DirCreate($sPath & "\_test_" & $iEnum)
	Switch $iSuccess
		Case 1
			DirRemove($sPath & "\_test_" & $iEnum)
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>_Directory_Is_Accessible

Func _Debug_zur_ISN_Konsole($String = "", $level = 2, $break = 1, $notime = 0, $notitle = 0, $Category = "")
	If $String = "" Then Return
	Return _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_ISN_Debug_Console", $String, $level, $break, $notime, $notitle, $Category)
EndFunc   ;==>_Debug_zur_ISN_Konsole

Func _Set_Proxyserver()
	If $Use_Proxy = "true" Then
		If $proxy_PW = "" Then
			$pw = ""
		Else
			$pw = BinaryToString(_Crypt_DecryptData($proxy_PW, "Isn_pRoxy_PW", $CALG_RC4))
;~ 			$pw = _StringEncrypt(0, $proxy_PW, "Isn_pRoxy_PW", 2)
		EndIf
		FtpSetProxy(2, $proxy_server & ":" & $proxy_port, $proxy_username, $pw)
		HttpSetProxy(2, $proxy_server & ":" & $proxy_port, $proxy_username, $pw)
	Else
		FtpSetProxy(0)
		HttpSetProxy(0)
	EndIf
EndFunc   ;==>_Set_Proxyserver

Func _ist_windows_vista_oder_hoeher()
	Switch @OSVersion
		Case "WIN_2000", "WIN_2003", "WIN_XP", "WIN_XPe"
			Return 0
	EndSwitch
	Return 1
EndFunc   ;==>_ist_windows_vista_oder_hoeher

Func _Align_Scripttree_GUI_to_ISN_AutoIt_Studio()

	;Check State
	If ControlCommand($ISN_AutoIt_Studio_Mainwindow_Handle, "", $ISN_hTreeview2_searchinput_handle, "IsVisible", "") = "1" Then
		If Not BitAND(WinGetState($ISN_Thread_Scripttree_GUI), 2) Then
			GUISetState(@SW_SHOWNOACTIVATE, $ISN_Thread_Scripttree_GUI)
			_Scripttree_Redraw()
		EndIf
	Else
		If BitAND(WinGetState($ISN_Thread_Scripttree_GUI), 2) Then
		   GUISetState(@SW_HIDE, $ISN_Thread_Scripttree_GUI)
		   _Scripttree_Redraw()
		   endif
		Return
	EndIf

	;Check Pos
	$Scripttree_dummy_Control_pos_Array = ControlGetPos($ISN_AutoIt_Studio_Mainwindow_Handle, "", $Scripttree_dummy_in_ISN)
	$Searchinput_dummy_Control_pos_Array = ControlGetPos($ISN_AutoIt_Studio_Mainwindow_Handle, "", $ISN_hTreeview2_searchinput_handle)
	If Not IsArray($Scripttree_dummy_Control_pos_Array) Then Return
	If Not IsArray($Searchinput_dummy_Control_pos_Array) Then Return

	If $Scripttree_dummy_Control_pos_Array_Old = "" Then ;Startup Pos
		$Scripttree_dummy_Control_pos_Array_Old = $Scripttree_dummy_Control_pos_Array
		_WinAPI_SetWindowPos($ISN_Thread_Scripttree_GUI, $HWND_TOP, $Searchinput_dummy_Control_pos_Array[0], $Searchinput_dummy_Control_pos_Array[1], $Scripttree_dummy_Control_pos_Array[2], $Scripttree_dummy_Control_pos_Array[3] + $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand, $SWP_NOACTIVATE + $SWP_NOZORDER)

		GUICtrlSetPos($ISN_Scripttree, 0, $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand, $Scripttree_dummy_Control_pos_Array[2], $Scripttree_dummy_Control_pos_Array[3])
		GUICtrlSetPos($Scripttree_Settings_Button, $Scripttree_dummy_Control_pos_Array[2] - $Searchinput_dummy_Control_pos_Array[3], 0, $Searchinput_dummy_Control_pos_Array[3], $Searchinput_dummy_Control_pos_Array[3])
		GUICtrlSetPos($Scripttree_Refresh_Button, $Scripttree_dummy_Control_pos_Array[2] - ($Searchinput_dummy_Control_pos_Array[3] + $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand), 0, $Searchinput_dummy_Control_pos_Array[3], $Searchinput_dummy_Control_pos_Array[3])
		GUICtrlSetPos($Scripttree_Search_input, 0, 0, $Scripttree_dummy_Control_pos_Array[2] - ($Searchinput_dummy_Control_pos_Array[3] + $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand + $Splitter_Rand), $Searchinput_dummy_Control_pos_Array[3])

;~ 		if BitAND(GUICtrlGetState($ISN_Scripttree_loading_label), $GUI_SHOW) then
;~ 		GUICtrlSetPos($ISN_Scripttree_loading_icon, (($Scripttree_dummy_Control_pos_Array[2]/2)-((32*$DPI)/2)), ($Scripttree_dummy_Control_pos_Array[3]/2)-((32*$DPI)/2), 32*$DPI,32*$DPI)
;~ 		GUICtrlSetPos($ISN_Scripttree_loading_label, 2, ($Scripttree_dummy_Control_pos_Array[3]/2)+(32*$DPI)-12, $Scripttree_dummy_Control_pos_Array[2]-2)
;~ 		endif

	  _Scripttree_Redraw()

	EndIf



	If Not IsArray($Scripttree_dummy_Control_pos_Array_Old) Then Return
	If $Scripttree_dummy_Control_pos_Array_Old[0] <> $Scripttree_dummy_Control_pos_Array[0] Or $Scripttree_dummy_Control_pos_Array_Old[1] <> $Scripttree_dummy_Control_pos_Array[1] Or $Scripttree_dummy_Control_pos_Array_Old[2] <> $Scripttree_dummy_Control_pos_Array[2] Or $Scripttree_dummy_Control_pos_Array_Old[3] <> $Scripttree_dummy_Control_pos_Array[3] Then
		$Scripttree_dummy_Control_pos_Array_Old = $Scripttree_dummy_Control_pos_Array
		_WinAPI_SetWindowPos($ISN_Thread_Scripttree_GUI, $HWND_TOP, $Searchinput_dummy_Control_pos_Array[0], $Searchinput_dummy_Control_pos_Array[1], $Scripttree_dummy_Control_pos_Array[2], $Scripttree_dummy_Control_pos_Array[3] + $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand, $SWP_NOACTIVATE + $SWP_NOZORDER)
		GUICtrlSetPos($ISN_Scripttree, 0, $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand, $Scripttree_dummy_Control_pos_Array[2], $Scripttree_dummy_Control_pos_Array[3])
		GUICtrlSetPos($Scripttree_Settings_Button, $Scripttree_dummy_Control_pos_Array[2] - $Searchinput_dummy_Control_pos_Array[3], 0, $Searchinput_dummy_Control_pos_Array[3], $Searchinput_dummy_Control_pos_Array[3])
		GUICtrlSetPos($Scripttree_Refresh_Button, $Scripttree_dummy_Control_pos_Array[2] - ($Searchinput_dummy_Control_pos_Array[3] + $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand), 0, $Searchinput_dummy_Control_pos_Array[3], $Searchinput_dummy_Control_pos_Array[3])
		GUICtrlSetPos($Scripttree_Search_input, 0, 0, $Scripttree_dummy_Control_pos_Array[2] - ($Searchinput_dummy_Control_pos_Array[3] + $Searchinput_dummy_Control_pos_Array[3] + $Splitter_Rand + $Splitter_Rand), $Searchinput_dummy_Control_pos_Array[3])
;~ 		if BitAND(GUICtrlGetState($ISN_Scripttree_loading_label), $GUI_SHOW) then
;~ 		GUICtrlSetPos($ISN_Scripttree_loading_icon, (($Scripttree_dummy_Control_pos_Array[2]/2)-((32*$DPI)/2)), ($Scripttree_dummy_Control_pos_Array[3]/2)-((32*$DPI)/2), 32*$DPI,32*$DPI)
;~ 		GUICtrlSetPos($ISN_Scripttree_loading_label, 2, ($Scripttree_dummy_Control_pos_Array[3]/2)+(32*$DPI)-12, $Scripttree_dummy_Control_pos_Array[2]-2)
;~ 		endif

	  _Scripttree_Redraw()
		;
	EndIf



EndFunc   ;==>_Align_Scripttree_GUI_to_ISN_AutoIt_Studio


Func _GuiHole($hWin, $iX, $iY, $iW, $iH)
	Local $pos, $outer_rgn, $inner_rgn, $combined_rgn
	$pos = WinGetPos($hWin)
	$outer_rgn = _WinAPI_CreateRectRgn(0, 0, $pos[2], $pos[3])
	$inner_rgn = _WinAPI_CreateRectRgn($iX, $iY, $iX + $iW, $iY + $iH)
	$combined_rgn = _WinAPI_CreateRectRgn(0, 0, 0, 0)
	_WinAPI_CombineRgn($combined_rgn, $outer_rgn, $inner_rgn, $RGN_DIFF) ; $RGN_DIFF constant in WindowsConstants.au3
	_WinAPI_SetWindowRgn($hWin, $combined_rgn)
EndFunc   ;==>_GuiHole

Func _RGB_to_BGR($colour = "")
	If $colour = "" Then Return 0
	$r = _ColorGetRed($colour)
	$g = _ColorGetGreen($colour)
	$B = _ColorGetBlue($colour)
	$BGR = "0x" & Hex($B, 2) & Hex($g, 2) & Hex($r, 2)
	Return $BGR
EndFunc   ;==>_RGB_to_BGR

Func _BGR_to_RGB($colour = "")
	If $colour = "" Then Return 0
	$r = _ColorGetBlue($colour)
	$g = _ColorGetGreen($colour)
	$B = _ColorGetRed($colour)
	$RGB = "0x" & Hex($r, 2) & Hex($g, 2) & Hex($B, 2)
	Return $RGB
EndFunc   ;==>_BGR_to_RGB

; #FUNCTION# ====================================================================================================================
; Name...........: _ReduceMemory
; Author ........: w_Outer, Rajesh V R, Prog@ndy
; ===============================================================================================================================

Func _ReduceMemory($iPid = -1)
	If $iPid = -1 Or ProcessExists($iPid) = 0 Then
		Local $ai_GetCurrentProcess = DllCall('kernel32.dll', 'ptr', 'GetCurrentProcess')
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'ptr', $ai_GetCurrentProcess[0])
		Return $ai_Return[0]
	EndIf

	Local $ai_Handle = DllCall("kernel32.dll", 'ptr', 'OpenProcess', 'int', 0x1F0FFF, 'int', False, 'int', $iPid)
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'ptr', $ai_Handle[0])
	DllCall('kernel32.dll', 'int', 'CloseHandle', 'ptr', $ai_Handle[0])
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

;==================================================================================================
; Function Name:   _GUICtrlTreeView_ExpandOneLevel($hTreeView [, $hParentItem=0])
; Description::    Ausklappen nur EINER Ebene eines Items, analog zum Mausklick auf '+'
; Parameter(s):    $hTreeView     Handle des TreeView
;                  $hParentItem   Handle des Auszuklappenden Parent-Items
;                                 Standard 0 ==> Handle des ersten Item im TreeView
; Return:          Erfolg         nichts
;                  Fehler         @error 1  -  TreeView enthält kein Item
;                                 @error 2  -  Item hat keine Child-Item
; Note:            Die Funktion sollte zwischen _GUICtrlTreeView_BeginUpdate() und _GUICtrlTreeView_EndUpdate()
;                  ausgeführt werden um ein Flackern zu verhindern
; Author(s):       BugFix (bugfix@autoit.de)
;==================================================================================================

Func _GUICtrlTreeView_ExpandOneLevel($hTreeView, $hParentItem = 0)
	If $hParentItem < 1 Then
		Local $hCurrentItem = _GUICtrlTreeView_GetFirstItem($hTreeView)
	Else
		Local $hCurrentItem = $hParentItem
	EndIf
	If $hCurrentItem = 0 Then Return SetError(1)
	Local $hChild
	Local $countChild = _GUICtrlTreeView_GetChildCount($hTreeView, $hCurrentItem)
	If $countChild = 0 Then Return SetError(2)
	_GUICtrlTreeView_Expand($hTreeView, $hCurrentItem)
	For $i = 1 To $countChild
		If $i = 1 Then
			$hChild = _GUICtrlTreeView_GetFirstChild($hTreeView, $hCurrentItem)
		Else
			$hChild = _GUICtrlTreeView_GetNextSibling($hTreeView, $hChild)
		EndIf
		If _GUICtrlTreeView_GetChildren($hTreeView, $hChild) Then _GUICtrlTreeView_Expand($hTreeView, $hChild, False)
	Next
EndFunc   ;==>_GUICtrlTreeView_ExpandOneLevel


Func _Scripttree_Show_Comment()
	if not IsArray($ISN_Scintilla_Handles) then return
	If $Scripttree_current_tab = -1 Then Return
	Local $ISN_Scripttree_handle = GUICtrlGetHandle($ISN_Scripttree)
	If _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle) = 0 Then Return
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), ".", 1, -1) = 0 Then Return
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(84) Then Return ;Stoppe bei Root von Globalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(416) Then Return ;Stoppe bei Root von Lokalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(83) Then Return ;Stoppe bei Root von Funktionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(433) Then Return ;Stoppe bei Root von Regionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(324) Then Return ;Stoppe bei Root von Includes
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(323) Then Return ;Stoppe bei Root von Forms im Projekt
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(323)) Then Return ;Stoppe bei Subitems von Forms im Projekt

	$Mode = 0
	$name = StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1))
	If StringInStr($name, " {") Then $name = StringTrimRight($name, StringLen($name) - StringInStr($name, " {") + 1) ;Cut Counts
	$name = StringStripWS($name, 3) ;Entferne Leerzeichen am anfang & Ende eines Elements falls vorhanden
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(83)) Then $Mode = "func" ;$str = "func "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(433)) Then $Mode = "region" ;$str = "#region "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(84)) Then $Mode = "global"
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(416)) Then $Mode = "local" ;$str = "global "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(324)) Then $Mode = "include" ;$str = "global "&$str

	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_show_comment_from_scripttree", HWnd($ISN_Scintilla_Handles[$Scripttree_current_tab]), $name, $Mode)

EndFunc   ;==>_Scripttree_Show_Comment


Func _Scripttree_DBLCLK()
	if not IsArray($ISN_Scintilla_Handles) then return
	If $Scripttree_current_tab = -1 Then Return
	Local $ISN_Scripttree_handle = GUICtrlGetHandle($ISN_Scripttree)
	If _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle) = 0 Then Return

	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), ".", 1, -1) = 0 Then Return
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(84) Then Return ;Stoppe bei Root von Globalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(416) Then Return ;Stoppe bei Root von Lokalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(83) Then Return ;Stoppe bei Root von Funktionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(433) Then Return ;Stoppe bei Root von Regionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(324) Then Return ;Stoppe bei Root von Includes
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(323) Then Return ;Stoppe bei Root von Forms im Projekt
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(323)) Then Return ;Stoppe bei Subitems von Forms im Projekt

	$Mode = 0
	$str = StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1))
	If StringInStr($str, " {") Then $str = StringTrimRight($str, StringLen($str) - StringInStr($str, " {") + 1) ;Cut Counts
	$str = StringStripWS($str, 3) ;Entferne Leerzeichen am anfang & Ende eines Elements falls vorhanden
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(83)) Then $Mode = "func" ;$str = "func "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(433)) Then $Mode = "region" ;$str = "#region "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(84)) Then $Mode = "global"
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(416)) Then $Mode = "local" ;$str = "global "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(324)) Then $Mode = "include" ;$str = "global "&$str


	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Scripttree_jump_to_element", HWnd($ISN_Scintilla_Handles[$Scripttree_current_tab]), $str, $Mode)


EndFunc   ;==>_Scripttree_DBLCLK

Func _Scripttree_Show_Code_Snippet()
	if not IsArray($ISN_Scintilla_Handles) then return
	If $Scripttree_current_tab = -1 Then Return
	Local $ISN_Scripttree_handle = GUICtrlGetHandle($ISN_Scripttree)
	If _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle) = 0 Then Return

	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), ".", 1, -1) = 0 Then Return
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(84) Then Return ;Stoppe bei Root von Globalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(416) Then Return ;Stoppe bei Root von Lokalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(83) Then Return ;Stoppe bei Root von Funktionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(433) Then Return ;Stoppe bei Root von Regionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(324) Then Return ;Stoppe bei Root von Includes
	If StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1)) = _Get_langstr(323) Then Return ;Stoppe bei Root von Forms im Projekt
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(323)) Then Return ;Stoppe bei Subitems von Forms im Projekt

	$Mode = 0
	$str = StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), "|", Default, -1))
	If StringInStr($str, " {") Then $str = StringTrimRight($str, StringLen($str) - StringInStr($str, " {") + 1) ;Cut Counts
	$str = StringStripWS($str, 3) ;Entferne Leerzeichen am anfang & Ende eines Elements falls vorhanden
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(83)) Then $Mode = "func" ;$str = "func "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(433)) Then $Mode = "region" ;$str = "#region "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(84)) Then $Mode = "global"
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(416)) Then $Mode = "local" ;$str = "global "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree_handle, _GUICtrlTreeView_GetSelection($ISN_Scripttree_handle)), _Get_langstr(324)) Then $Mode = "include" ;$str = "global "&$str


	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_SCI_Zeige_Code_Schnipsel", HWnd($ISN_Scintilla_Handles[$Scripttree_current_tab]), $str, $Mode)
EndFunc   ;==>_Scripttree_Show_Code_Snippet

Func WM_COMMAND_Scripttree($hWndGUI, $MsgID, $wParam, $lParam)
	$nID = BitAND($wParam, 0x0000FFFF)

	;Check "Enter" in the Scripttree searchbar
	$Class = ControlGetFocus($hWndGUI)
	If ControlGetHandle($hWndGUI, "", "[CLASSNN:" & $Class & "]") = GUICtrlGetHandle($Scripttree_Search_input) And $wParam = 1 Then
		If GUICtrlRead($Scripttree_Search_input) <> "" Then _Scripttree_Search()
		Return $GUI_RUNDEFMSG
	EndIf

	Switch $nID

		Case $Scripttree_contextmenu_open_file
			_Scripttree_Try_to_open_File()

		Case $Scripttree_contextmenu_go_to_element
			_Scripttree_DBLCLK()

		Case $Scripttree_contextmenu_show_comment
			_Scripttree_Show_Comment()

		Case $Scripttree_contextmenu_code_snippet
			_Scripttree_Show_Code_Snippet()

		Case $Skriptbaum_SetupMenu_Filter
			_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Zeige_Skriptbaum_FilterGUI")

		Case $Skriptbaum_SetupMenu_Setup_Scripttree
			_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Zeige_Skriptbaum_Einstellungen")

	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND_Scripttree


Func WM_NOTIFY_Scripttree($hWnd, $iMsg, $wParam, $lParam)
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Local $tInfo
	Switch $hWndFrom
		Case GUICtrlGetHandle($ISN_Scripttree)
			Switch $iCode

				Case $TVN_BEGINDRAGA, $TVN_BEGINDRAGW
					If $Scripttree_current_tab = -1 Then Return
					Local $tInfo = DllStructCreate($tagNMTREEVIEW, $lParam)
					Local $Treeview_Item = DllStructGetData($tInfo, "NewhItem")
					Local $Sci_For_Drag = HWnd($ISN_Scintilla_Handles[$Scripttree_current_tab])
					Local $Treeview_Text = StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree, $Treeview_Item), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree, $Treeview_Item), "|", Default, -1))
					$Treeview_Text = StringRegExpReplace($Treeview_Text, "{\s\d.\s}", "")
					$Treeview_Text = StringRegExpReplace($Treeview_Text, "\((.*)\)", "")
					$Treeview_Text = StringStripWS($Treeview_Text, 3)
					If StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree, $Treeview_Item), _Get_langstr(324)) Then $Treeview_Text = "#include " & $Treeview_Text
					_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Scripttree_Drag_text_to_Scripteditor", $Sci_For_Drag, $Treeview_Text)



				Case $NM_DBLCLK
					Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom, $iX, $iY)
					If $hItem <> 0 Then
						If $hItem = $Scripttree_Projectroot Then Return
						If $hItem = $Scripttree_Scriptroot Then Return
						If $hItem = $functiontree Then Return
						If $hItem = $globalvariablestree Then Return
						If $hItem = $includestree Then Return
						If $hItem = $localvariablestree Then Return
						If $hItem = $regionstree Then Return
						If $hItem = $formstree Then Return
						_Scripttree_DBLCLK()
					EndIf

				Case $NM_RCLICK ; The user has clicked the right mouse button within the control
					Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom, $iX, $iY)
					If $hItem <> 0 Then
						If $hItem = $Scripttree_Projectroot Then Return
						If $hItem = $Scripttree_Scriptroot Then Return
						If $hItem = $functiontree Then Return
						If $hItem = $globalvariablestree Then Return
						If $hItem = $includestree Then Return
						If $hItem = $localvariablestree Then Return
						If $hItem = $regionstree Then Return
						If $hItem = $formstree Then Return

						_GUICtrlTreeView_SelectItem($hWndFrom, $hItem, $TVGN_CARET)
						_GUICtrlTreeView_SelectItem($ISN_Scripttree, $hItem)
						GUICtrlSetState($Scripttree_contextmenu_open_file, $GUI_DISABLE)
						GUICtrlSetState($Scripttree_contextmenu_show_comment, $GUI_ENABLE)
						GUICtrlSetState($Scripttree_contextmenu_go_to_element, $GUI_ENABLE)
						GUICtrlSetState($Scripttree_contextmenu_code_snippet, $GUI_DISABLE)

						If StringInStr(_GUICtrlTreeView_GetTree(GUICtrlGetHandle($ISN_Scripttree), _GUICtrlTreeView_GetSelection(GUICtrlGetHandle($ISN_Scripttree))), _Get_langstr(83)) Then GUICtrlSetState($Scripttree_contextmenu_code_snippet, $GUI_ENABLE)
						If StringInStr(_GUICtrlTreeView_GetTree(GUICtrlGetHandle($ISN_Scripttree), _GUICtrlTreeView_GetSelection(GUICtrlGetHandle($ISN_Scripttree))), _Get_langstr(324)) Then GUICtrlSetState($Scripttree_contextmenu_open_file, $GUI_ENABLE)
						If StringInStr(_GUICtrlTreeView_GetTree(GUICtrlGetHandle($ISN_Scripttree), _GUICtrlTreeView_GetSelection(GUICtrlGetHandle($ISN_Scripttree))), _Get_langstr(323)) Then GUICtrlSetState($Scripttree_contextmenu_go_to_element, $GUI_DISABLE)
						If StringInStr(_GUICtrlTreeView_GetTree(GUICtrlGetHandle($ISN_Scripttree), _GUICtrlTreeView_GetSelection(GUICtrlGetHandle($ISN_Scripttree))), _Get_langstr(323)) Then Return ;No menu in forms

						_GUICtrlMenu_TrackPopupMenu($Scripttree_contextmenu_Handle, $ISN_Thread_Scripttree_GUI) ;default menu
					EndIf

			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY_Scripttree

; #FUNCTION# =========================================================================================================
; Name...........: GUICtrlGetBkColor
; Description ...: Retrieves the RGB value of the control background.
; Syntax.........: GUICtrlGetBkColor($iControlID)
; Parameters ....: $iControlID - A valid control ID.
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns RGB value of the control background.
;                  Failure - Returns 0 & sets @error = 1
; Author ........: guinness & additional information from Yashied for WinAPIEx.
; Example........; Yes
;=====================================================================================================================

Func GUICtrlGetBkColor($iControlID)
	Local $bGetBkColor, $hDC, $hHandle
	$hHandle = GUICtrlGetHandle($iControlID)
	$hDC = _WinAPI_GetDC($hHandle)
	$bGetBkColor = _WinAPI_GetPixel($hDC, 2, 2)
	_WinAPI_ReleaseDC($hHandle, $hDC)
	Return $bGetBkColor
EndFunc   ;==>GUICtrlGetBkColor

Func _Input_Error_FX($Control = "")
	;by ISI360
	If $Control = "" Then Return
	If $Control_Flashes = 1 Then Return
	$Control_Flashes = 1
	$old_bg = "0x" & Hex(GUICtrlGetBkColor($Control), 6)
	$old_red = _ColorGetRed($old_bg)
	$old_green = _ColorGetGreen($old_bg)
	$old_blue = _ColorGetBlue($old_bg)
	GUICtrlSetBkColor($Control, 0xFB6969)
	Sleep(100)
	$new_bg = "0x" & Hex(GUICtrlGetBkColor($Control), 6)
	$new_red = _ColorGetRed($new_bg)
	$new_green = _ColorGetGreen($new_bg)
	$new_blue = _ColorGetBlue($new_bg)
	$steps = 5
	Sleep(300)
	While 1
		$new_red = $new_red - $steps
		If $new_red < $old_red Then $new_red = $old_red
		$new_green = $new_green + $steps
		If $new_green > $old_green Then $new_green = $old_green
		$new_blue = $new_blue + $steps
		If $new_blue > $old_blue Then $new_blue = $old_blue
		$bg = "0x" & Hex($new_red, 2) & Hex($new_green, 2) & Hex($new_blue, 2)
		If $new_red = $old_red And $new_green = $old_green And $new_blue = $old_blue Then ExitLoop
		GUICtrlSetBkColor($Control, $bg)
		Sleep(20)
	WEnd
	GUICtrlSetBkColor($Control, $old_bg)
	$Control_Flashes = 0
EndFunc   ;==>_Input_Error_FX

; Author: Prog@ndy
; If the equal entries are one after the other, delete them :)
Func ArraySortUnique(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	Local $Ret = _ArraySort($avArray, $iDescending, $iStart, $iEnd, $iSubItem)
	If @error Then Return SetError(@error, 0, $Ret)
	If Not IsArray($avArray) Then Return
	Local $ResultIndex = 1, $ResultArray[UBound($avArray)]
	$ResultArray[0] = $avArray[0]
	For $i = 1 To UBound($avArray) - 1
		If Not ($avArray[$i] = $avArray[$i - 1]) Then
			$ResultArray[$ResultIndex] = $avArray[$i]
			$ResultIndex += 1
		EndIf
	Next
	ReDim $ResultArray[$ResultIndex]
	$avArray = $ResultArray
	Return 1
EndFunc   ;==>ArraySortUnique

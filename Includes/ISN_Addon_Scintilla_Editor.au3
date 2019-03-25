
Func _Umlaute_Filtern($str = "")
	If $str = "" Then Return ""

	If StringInStr($str, "Ü", 1) Then $str = StringReplace($str, "Ü", "Ue", 0, 1)
	If StringInStr($str, "Ö", 1) Then $str = StringReplace($str, "Ö", "Oe", 0, 1)
	If StringInStr($str, "Ä", 1) Then $str = StringReplace($str, "Ä", "Ae", 0, 1)

	If StringInStr($str, "ü", 1) Then $str = StringReplace($str, "ü", "ue", 0, 1)
	If StringInStr($str, "ö", 1) Then $str = StringReplace($str, "ö", "oe", 0, 1)
	If StringInStr($str, "ä", 1) Then $str = StringReplace($str, "ä", "ae", 0, 1)

	;Verobtene Zeichen
	If StringInStr($str, "\") Then $str = StringReplace($str, "\", "")
	If StringInStr($str, "/") Then $str = StringReplace($str, "/", "")
	If StringInStr($str, "?") Then $str = StringReplace($str, "?", "")
	If StringInStr($str, ":") Then $str = StringReplace($str, ":", "")
	If StringInStr($str, "|") Then $str = StringReplace($str, "|", "")
	If StringInStr($str, "*") Then $str = StringReplace($str, "*", "")


	Return $str
EndFunc   ;==>_Umlaute_Filtern


Func _Skript_Editor_Pruefe_Dateityp($Dateityp = "")

	Local $Dateitypen = ""

	If $Skript_Editor_Automatische_Dateitypen = "true" Then
		;Dateitypen für Skript Editor werden automatisch verwaltet
		$Dateitypen = $Skript_Editor_Dateitypen_Standard
	Else
		;Dateitypen für Skript Editor werden manuell verwaltet
		$Dateitypen = $Skript_Editor_Dateitypen_Liste
	EndIf



	;Prüfen ob Dateityp mit Skript Editor geöffnet werden soll
	$Dateityp_Array = StringSplit($Dateitypen, "|", 2)
	If Not IsArray($Dateityp_Array) Then Return False

	For $x = 0 To UBound($Dateityp_Array) - 1
		If $Dateityp_Array[$x] = "" Then ContinueLoop
		If $Dateityp_Array[$x] = "|" Then ContinueLoop
		If $Dateityp = $Dateityp_Array[$x] Then Return True
	Next

	Return False
EndFunc   ;==>_Skript_Editor_Pruefe_Dateityp

Func _Mark_line($line, $colour, $handle = "", $ony_row = 0)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $handle = "" Then $handle = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]
	_Remove_Marks($handle)

	If $ony_row = 0 Then
		SendMessage($handle, $SCI_MARKERADD, $line, 2)
		SendMessage($handle, $SCI_MARKERDEFINE, 2, $SC_MARK_SHORTARROW)
		SendMessage($handle, $SCI_MARKERSETFORE, 2, 0x0000FF)
		SendMessage($handle, $SCI_MARKERSETBACK, 2, 0x0000FF)
	EndIf

	;row colour
	SendMessage($handle, $SCI_MARKERDEFINE, 3, $SC_MARK_Background)
	SendMessage($handle, $SCI_MarkerSetBack, 3, $colour)
	$marker_handle = SendMessage($handle, $SCI_MarkerAdd, $line, 3)
	SendMessage($marker_handle, $SCI_MARKERSETALPHA, $line, 100)
EndFunc   ;==>_Mark_line

Func _Remove_Marks($sci = "")
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $sci = "" Then $sci = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MarkerSetBack, 10, 0xFFFFFF)
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MARKERSETALPHA, $marker_handle, 10)
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MARKERDELETE, $marker_handle, 0)
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MARKERDELETEHANDLE, $marker_handle, 0)
	SendMessage($sci, $SCI_MARKERDELETEALL, 2, 0) ;Lösche Marker die mit _Mark_line erstellt wurden (Marker ID 2)
	SendMessage($sci, $SCI_MARKERDELETEALL, 3, 0) ;Lösche Marker die mit _Mark_line erstellt wurden (Marker ID 3)
EndFunc   ;==>_Remove_Marks

Func _Show_Tab($nr = 0, $noresize_of_new_tab = 0)
	If _GUICtrlTab_GetItemCount($htab) < 1 Then Return
	If $nr > UBound($SCE_EDITOR) Then Return
	If $nr < 0 Then Return
	If $Can_switch_tabs = 0 Then Return

	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	$plugsize = WinGetPos($SCE_EDITOR[$nr])

	If Not IsArray($plugsize) Then Return
	If Not IsArray($tabsize) Then Return
	$Aktuell_aktiver_Tab = _GUICtrlTab_GetCurFocus($htab)
	If $Aktuell_aktiver_Tab = -1 Then Return

	$Can_switch_tabs = 0
	_GUICtrlStatusBar_SetText_ISN($Status_bar, "")
	_check_if_file_was_modified_external()

	If StringTrimLeft($Datei_pfad[$Aktuell_aktiver_Tab], StringInStr($Datei_pfad[$Aktuell_aktiver_Tab], ".", 0, -1)) = $Autoitextension Then
		_HIDE_FENSTER_RECHTS("false") ;show
		If $Fenster_unten_durch_toggle_versteckt = 0 Then _HIDE_FENSTER_UNTEN("false") ;show
		If $Tabs_closing = 0 Then _ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "_Scripttree_Switch_Tab", String($nr)) ;Load Scripttree
	Else
		_HIDE_FENSTER_RECHTS("true") ;hide
		_HIDE_FENSTER_UNTEN("true") ;hide
	EndIf

	;Check if the tab is undocked
	If $ISN_Tabs_Additional_Infos_Array[$nr][1] = "1" Then
		_ISN_Undocked_Tab_Info_Set_State("show")
	Else
		_ISN_Undocked_Tab_Info_Set_State("hide")
	EndIf

	SendMessage($SCE_EDITOR[$Aktuell_aktiver_Tab], $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($SCE_EDITOR[$Aktuell_aktiver_Tab]))
	$letztes_Suchwort = ""


	If $nr = -1 Then $nr = $Offene_tabs - 1




	;Verstecke alle Tabs
	For $i = $Offene_tabs To 1 Step -1
		If $nr = $i - 1 Then ContinueLoop
		If $ISN_Tabs_Additional_Infos_Array[$i - 1][1] = "1" Then ContinueLoop
		WinMove($SCE_EDITOR[$i - 1], "", -9900, -9900, Default, Default)
;~ 		_WinAPI_SetWindowPos($SCE_EDITOR[$i - 1], $HWND_NOTOPMOST, -9900, -9900, 1, 1, $SWP_HIDEWINDOW+$SWP_NOZORDER+$SWP_NOOWNERZORDER)
;~ 		 _WinAPI_SetWindowPos($Plugin_Handle[$i - 1], $HWND_NOTOPMOST, -9900, -9900, 1, 1, $SWP_HIDEWINDOW+$SWP_NOZORDER+$SWP_NOOWNERZORDER)
		;WinMove($Plugin_Handle[$i - 1], "", -9900, -9900, Default, Default)
	Next

	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	$htab_wingetpos_array = WinGetPos(GUICtrlGetHandle($htab))
	If Not IsArray($htab_wingetpos_array) Then
		$Can_switch_tabs = 1
		Return
	EndIf

	If $ISN_Tabs_Additional_Infos_Array[$nr][1] <> "1" Then
		If $noresize_of_new_tab <> 1 Then
			;Zeige gewünschten tab
			;Das Plugin bzw. den Skripteditor an die Fenstergröße anpassen

			;Scintilla
			$y = $tabsize[1] + $Tabseite_hoehe
			$x = $tabsize[0] + 4



			If $Plugin_Handle[$nr] <> -1 Then
				_ISN_Send_Message_to_Plugin($Plugin_Handle[$nr], "resize") ;Resize an Plugin senden
			Else
				;Scintilla
				_WinAPI_SetWindowPos($SCE_EDITOR[$nr], $HWND_TOP, $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_SHOWWINDOW)
			EndIf

;~ 	_WinAPI_SetWindowPos($SCE_EDITOR[$nr],  _WinAPI_GetWindow(WinGetHandle($Studiofenster),$GW_HWNDNEXT)  , $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_SHOWWINDOW)
;~ 	$plugsize = WinGetPos($SCE_EDITOR[$nr])
;~    _WinAPI_SetWindowPos($Plugin_Handle[$nr], $HWND_TOPMOST  , 0, 0, $plugsize[2], $plugsize[3],   $SWP_SHOWWINDOW )


		EndIf
;~ 	sleep(50)
;~ 	WinMove($Plugin_Handle[$nr], "", 0, 0, $plugsize[2], $plugsize[3])

		If WinMove($Plugin_Handle[$nr], "", 0, 0) = 0 And $Plugin_Handle[$nr] <> -1 Then
			_Write_ISN_Debug_Console("Plugin with handle " & $Plugin_Handle[$nr] & " crashed!! Tab " & $nr + 1 & " will close now...", 3)
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(79), 0, $StudioFenster)
			$Can_switch_tabs = 1
			try_to_Close_Tab($nr)
			_Write_ISN_Debug_Console("|--> Crashed tab closed!", 1)
			$Can_switch_tabs = 1
			_Aktualisiere_Splittercontrols()
			Return
		EndIf


	    If $Plugin_Handle[$nr] = -1 Then _WinAPI_SetFocus($SCE_EDITOR[$nr])
		_GUICtrlTab_SetCurFocus($htab, $nr)
	Else
		WinActivate($SCE_EDITOR[$nr])
	 EndIf

	$Can_switch_tabs = 1
   _Aktualisiere_Splittercontrols()
EndFunc   ;==>_Show_Tab

Func _ISN_Move_or_Resize_Plugin_Windows($mode = "move")
	Return
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$nr = _GUICtrlTab_GetCurFocus($htab)
	If $Plugin_Handle[$nr] = -1 Then Return

	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	$htab_wingetpos_array = WinGetPos(GUICtrlGetHandle($htab))
	If Not IsArray($htab_wingetpos_array) Then Return
	If Not IsArray($tabsize) Then Return


	;Plugin
	$y = $htab_wingetpos_array[1] + $Tabseite_hoehe
	$x = $htab_wingetpos_array[0] + 4

	_WinAPI_SetWindowPos($SCE_EDITOR[$nr], $HWND_NOTOPMOST, $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_NOZORDER + $SWP_NOACTIVATE)
	If $mode = "resize" Then _ISN_Send_Message_to_Plugin($Plugin_Handle[$nr], "resize") ;Resize an Plugin senden
EndFunc   ;==>_ISN_Move_or_Resize_Plugin_Windows




Func _openscriptfile($file)
	GUISetCursor(1, 0, $studiofenster)
	If _GUICtrlTab_GetCurFocus($htab) <> $Tabswitch_last_Tab Then $Tabswitch_last_Tab = _GUICtrlTab_GetCurFocus($htab)
	_Write_log(_Get_langstr(36) & " " & StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	_GUICtrlTab_InsertItem($htab, $Offene_tabs, StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	$Tab_Rect = _GUICtrlTab_GetItemRect($htab, $Offene_tabs)
	If IsArray($Tab_Rect) Then $Tabseite_hoehe = $Tab_Rect[3] + (4 * $DPI)
	_GUICtrlTab_SetToolTips(-1, _Get_langstr(532))
	$Datei_pfad[$Offene_tabs] = $file
	$winsize = WinGetPos($StudioFenster)

	_GUICtrlTab_SetItemImage($htab, $Offene_tabs, _return_FileIcon(StringTrimLeft($file, StringInStr($file, ".", 1, -1))))
	_GUICtrlTab_ActivateTabX($htab, $Offene_tabs, 0)
	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	GUICtrlSetState($HD_Logo, $GUI_HIDE)

	_ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "_Scripttree_Clear_Array", String($Offene_tabs)) ;Reset Arrays in the thread


	;$SCE_EDITOR[$Offene_tabs] = Sci_CreateEditor($StudioFenster, $tabsize[0]+4, $tabsize[1]+24, $tabsize[2]-9,$tabsize[3]-24-4)
	$SCE_EDITOR[$Offene_tabs] = SCI_CreateEditorAu3($StudioFenster, $tabsize[0] + 4, $tabsize[1] + $Tabseite_hoehe, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4)
	$Last_Used_Scintilla_Control = $SCE_EDITOR[$Offene_tabs]
	_Write_ISN_Debug_Console("Open new script tab with handle " & $SCE_EDITOR[$Offene_tabs] & "...", 1)
	$ext = StringTrimLeft($Datei_pfad[$Offene_tabs], StringInStr($Datei_pfad[$Offene_tabs], ".", 1, -1))

	_Write_ISN_Debug_Console("|--> Setting lexer for " & $ext & "...", 1)
	Switch $ext

		Case $Autoitextension
			;Null

		Case "xml"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_XML, 0)

		Case "html"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_HTML, 0)

		Case "htm"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_HTML, 0)

		Case "txt"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_NULL, 0)

		Case "ini"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_PROPERTIES, 0)

		Case "isn"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_PROPERTIES, 0)

		Case "bat"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_BATCH, 0)

		Case Else
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_NULL, 0)


	EndSwitch

	LoadEditorFile($SCE_EDITOR[$Offene_tabs], FileGetShortName($file))



	$Plugin_Handle[$Offene_tabs] = -1

;~ 	GUISetState(@SW_LOCK,$StudioFenster)



	SendMessageString($SCE_EDITOR[$Offene_tabs], $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessageString($SCE_EDITOR[$Offene_tabs], $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessageString($SCE_EDITOR[$Offene_tabs], $SCI_SETSAVEPOINT, 0, 0)



	$FILE_CACHE[$Offene_tabs] = Sci_GetLines($SCE_EDITOR[$Offene_tabs])
	$Offene_tabs = $Offene_tabs + 1

	_Check_tabs_for_changes()

	_Show_Tab($Offene_tabs - 1)
	_Check_Buttons(0)
	_Editor_Restore_Fold()

;~ 	GUISetState(@SW_UNLOCK,$StudioFenster)
	;SendMessage($SCE_EDITOR[$Offene_tabs - 1], $SCI_DOCUMENTSTART, 0, 0) ;und wieder zurück :P
;~ 	If $hidefunctionstree = "false" Then _Build_Scripttree(StringTrimLeft($file, StringInStr($file, "\", 0, -1)), $Offene_tabs - 1)
	_Write_ISN_Debug_Console("|--> Tab successfully created!", 1)
	$Can_open_new_tab = 1
	_run_rule($Section_Trigger7)
	If Sci_GetLineCount($SCE_EDITOR[$Offene_tabs - 1]) > 4500 And $ext = $Autoitextension Then _Earn_trophy(14, 3)
	_Debug_log_check_redo_undo()
	GUISetCursor(2, 0, $StudioFenster)
EndFunc   ;==>_openscriptfile



Func _ArraySize($aArray)
	SetError(0)

	$index = 0

	Do
		$pop = _ArrayPop($aArray)
		$index = $index + 1
	Until @error = 1

	Return $index - 1
EndFunc   ;==>_ArraySize

Func gotomouspos()
	$p = MouseGetPos()
	$WP = WinGetPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) ;that is for difference of coordinates-Scintilla is in activX window($Sci)
	If @error Then Return
	If IsArray($WP) And IsArray($p) Then
		$p[0] -= $WP[0]
		$p[1] -= $WP[1]
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GOTOPOS, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_POSITIONFROMPOINT, $p[0], $p[1]), 0)
		;SendMessage($Sci,$SCI_POSITIONFROMPOINT,x, y) - heare you get position from x,y
		;SendMessage($Sci,$SCI_GOTOPOS,$pos,0) - heare you go to specific position
		;if you go to an abstract position, use SendMessage($Sci,$SCI_POSITIONFROMPOINTCLOSE, x, y)
		;because it return -1 if no char close to position or the pos is outside window
	EndIf
EndFunc   ;==>gotomouspos

;Used to read a file,assign global data,and populate the Scintilla control

Func LoadEditorFile($editor, $sPath)
;~    msgbox(0,FileGetEncoding ($sPath),FileGetEncoding ($sPath))
	;  $filehandle = FileOpen ($sPath,FileGetEncoding ($sPath))
	Global $G_FileText = FileRead($sPath)

	If StringRight($G_FileText, 1) = Chr(0) Then $G_FileText = StringTrimRight($G_FileText, 1)

	If $autoit_editor_encoding = "2" Then
		If Not _System_benoetigt_double_byte_character_Support() Then
			$G_FileText = _UNICODE2ANSI($G_FileText)
		EndIf
	EndIf

	;Sci_DelLines($editor)


	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SCI_SetText($editor, $G_FileText)
	SendMessage($editor, $SCI_COLOURISE, 0, -1) ;Redraw the lexer
	_ISN_AutoIt_Studio_activate_GUI_Messages()

	;Sci_AddLines($editor, $G_FileText, 0)
;~  	FileClose($filehandle)
	Global $G_CurrentFile = $sPath
EndFunc   ;==>LoadEditorFile



Func _StringIsUTF8Format($sText)
	Local $iAsc, $iExt, $iLen = StringLen($sText)

	For $i = 1 To $iLen
		$iAsc = Asc(StringMid($sText, $i, 1))
		If Not BitAND($iAsc, 0x80) Then
			ContinueLoop
		ElseIf Not BitXOR(BitAND($iAsc, 0xE0), 0xC0) Then
			$iExt = 1
		ElseIf Not (BitXOR(BitAND($iAsc, 0xF0), 0xE0)) Then
			$iExt = 2
		ElseIf Not BitXOR(BitAND($iAsc, 0xF8), 0xF0) Then
			$iExt = 3
		Else
			Return False
		EndIf

		If $i + $iExt > $iLen Then Return False

		For $j = $i + 1 To $i + $iExt
			$iAsc = Asc(StringMid($sText, $j, 1))
			If BitXOR(BitAND($iAsc, 0xC0), 0x80) Then Return False
		Next

		$i += $iExt
	Next
	Return True
EndFunc   ;==>_StringIsUTF8Format


Func _UNICODE2ANSI($sString = "")
	If $autoit_editor_encoding <> "2" Then Return $sString
	If _System_benoetigt_double_byte_character_Support() Then Return $sString
	; Convert UTF8 to ANSI to insert into DB

	; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
	; ProgAndy
	; Make ANSI-string representation out of UTF-8

	Local Const $SF_ANSI = 1
	Local Const $SF_UTF8 = 4
	Return BinaryToString(StringToBinary($sString, $SF_UTF8), $SF_ANSI)
EndFunc   ;==>_UNICODE2ANSI

Func _ANSI2UNICODE($sString = "")
	If $autoit_editor_encoding <> "2" Then Return $sString
	If _System_benoetigt_double_byte_character_Support() Then Return $sString
	; Extract ANSI and convert to UTF8 to display

	; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
	; ProgAndy
	; convert ANSI-UTF8 representation to ANSI/Unicode

	Local Const $SF_ANSI = 1
	Local Const $SF_UTF8 = 4
	Return BinaryToString(StringToBinary($sString, $SF_ANSI), $SF_UTF8)
EndFunc   ;==>_ANSI2UNICODE

Func _WinGetByPID($iPID, $iArray = 0) ; 0 Will Return 1 Base Array & 1 Will Return The First Window.
	Local $aError[1] = [0], $aWinList, $sReturn
	If IsString($iPID) Then
		$iPID = ProcessExists($iPID)
	EndIf
	$aWinList = WinList()
	For $A = 1 To $aWinList[0][0]
		If WinGetProcess($aWinList[$A][1]) = $iPID And BitAND(WinGetState($aWinList[$A][1]), 2) Then
			If $iArray Then
				Return $aWinList[$A][1]
			EndIf
			$sReturn &= $aWinList[$A][1] & Chr(1)
		EndIf
	Next
	If $sReturn Then
		Return StringSplit(StringTrimRight($sReturn, 1), Chr(1))
	EndIf
	Return SetError(1, 0, $aError)
EndFunc   ;==>_WinGetByPID

Func _GetHwndFromPID($PID)
	$hWnd = 0
	$stPID = DllStructCreate("int")
	Do
		$winlist2 = WinList()
		For $i = 1 To $winlist2[0][0]
			If $winlist2[$i][0] <> "" Then
				DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $winlist2[$i][1], "ptr", DllStructGetPtr($stPID))
				If DllStructGetData($stPID, 1) = $PID Then
					$hWnd = $winlist2[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
		Sleep(100)
	Until $hWnd <> 0
	Return $hWnd
EndFunc   ;==>_GetHwndFromPID

Func _Try_to_open_file($file)
	Return Try_to_opten_file($file)
EndFunc   ;==>_Try_to_open_file

Func Try_to_opten_file($file)
	If $Offenes_Projekt = "" Then Return 0
	Dim $szDrive, $szDir, $szFName, $szExt
	If $Can_open_new_tab = 0 Then Return
	If $file = "#ERROR#" Then Return
	If $file = $Offenes_Projekt & "\#ERROR#" Then Return
	If Not FileExists($file) And $Studiomodus = 1 Then
		_Write_ISN_Debug_Console("Can not open file (" & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & ")!", 3)
		_Write_log(StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " " & _Get_langstr(332), "FF0000", "false")
		Return
	EndIf

	If $Offene_tabs > 19 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(123), 0, $StudioFenster)
		Return -1
	EndIf

	$res = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
	$szExt = StringTrimLeft($szExt, 1)

	If $szExt = "lnk" Then ;Verknüpfungen auflösen
		$Shortcut_array = FileGetShortcut($file)
		If IsArray($Shortcut_array) Then
			$file = $Shortcut_array[0]
			$res = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
			$szExt = StringTrimLeft($szExt, 1)
		EndIf
	EndIf

	$attrib = FileGetAttrib(FileGetShortName($file))
	If StringInStr($attrib, "R") Then _Show_Warning("warnreadonly", 513, _Get_langstr(394), _Get_langstr(458), "OK")
	If StringInStr($attrib, "D") Then Return
	$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $file)
		If $res <> -1 Then
			$alreadyopen = $res
		Else
			$alreadyopen = -1
		EndIf
	EndIf
	If $alreadyopen = -1 Then
		$Can_open_new_tab = 0

		;try external plugin
		If Not _IniVirtual_Read($Plugins_Cachefile_Virtual_INI, $szExt, "program", "") = "" Then
			_open_plugintab(_IniVirtual_Read($Plugins_Cachefile_Virtual_INI, $szExt, "program", ""), $file)

			_Add_File_to_Backuplist($file)
			If $szExt = "isf" Then _Earn_trophy(2, 1)
			If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
			_Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
			Return 1
		EndIf

		;Included plugins
		If _Skript_Editor_Pruefe_Dateityp($szExt) Then
			If $szExt = "isn" And $Studiomodus = 2 Then
				;Öffne isn Datein im Editormodus als Projekt
				ShellExecute(@ScriptDir & "\AutoIt_Studio.exe", '"' & $file & '"', @ScriptDir)
				$Can_open_new_tab = 1
				Return 1
			Else
				_openscriptfile($file)
			EndIf
			_Add_File_to_Backuplist($file)
			If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
			$Zuletzt_Verwendete_Dateien_Temp_Array = _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
			Return 1
		EndIf

		If $szExt = "exe" Then
			$i = _Show_Warning("confirmexe", 513, _Get_langstr(394), _Get_langstr(417) & " (" & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & ")", _Get_langstr(429), _Get_langstr(430))
			If $i = 1 Then ShellExecute($file)
			$Can_open_new_tab = 1
			If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
			$Zuletzt_Verwendete_Dateien_Temp_Array = _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
			Return 1
		EndIf

		;or crash with "cannot open file"
		_Write_ISN_Debug_Console("Can not open file (" & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & ")!", 3)
		_Write_log(StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " " & _Get_langstr(673), "000000", "false")
		$Zuletzt_Verwendete_Dateien_Temp_Array = _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
		ShellExecute($file)
		$Can_open_new_tab = 1
		Return -1
	Else
		_GUICtrlTab_ActivateTabX($htab, $alreadyopen)
		_Show_Tab($alreadyopen)
	EndIf

EndFunc   ;==>Try_to_opten_file

Func _Editor_Switch_Tab()
	If $Can_switch_tabs = 0 Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Aktuell_aktiver_Tab <> $Tabswitch_last_Tab Then $Tabswitch_last_Tab = $Aktuell_aktiver_Tab
	_Show_Tab(GUICtrlRead($htab))
	_Check_Buttons()
	_ISN_Send_Message_to_all_Plugins("switchtab")
;~ 	_Redraw_Window($SCE_EDITOR[$Offene_tabs])
EndFunc   ;==>_Editor_Switch_Tab



Func _Close_Tab_Script($nr = 0, $refresh = 1)
	;if $nr = 0 then return
	;check for changes

	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	GUISetCursor(1, 0, $studiofenster)
	_Write_ISN_Debug_Console("Closing script tab " & $nr & " (Handle " & $SCE_EDITOR[$nr] & ")...", 2)
	$Dateipfad = $Datei_pfad[$nr]
	$Can_open_new_tab = 0
	$Data = Sci_GetLines($SCE_EDITOR[$nr])
	$tab_txt = _GUICtrlTab_GetItemText($htab, $nr)
	If StringRight($tab_txt, 2) = " *" Then $tab_txt = StringTrimRight($tab_txt, 2)
	While $Data <> $FILE_CACHE[$nr]
		_GUICtrlTab_ActivateTabX($htab, $nr, 0)
		_Show_Tab($nr)
		$answ = MsgBox(262144 + 3 + 32, _Get_langstr(48), $tab_txt & " " & _Get_langstr(47), 0, $StudioFenster)
		If $answ = 2 Then
			$Can_open_new_tab = 1
			GUISetCursor(2, 0, $studiofenster)
			Return
		EndIf
		If $answ = 7 Then ExitLoop
		If $answ = 6 Then
			Save_File($nr)
			ExitLoop
		EndIf
	WEnd
	;EndFunc
	_Write_log(_Get_langstr(38) & " (" & $tab_txt & ")")

	_WinAPI_DestroyWindow($SCE_EDITOR[$nr]) ;Zerstöre Scintilla Control
	_GUICtrlTab_DeleteItem($htab, $nr)


	For $i = $nr To $Offene_tabs Step +1
;~ 		ConsoleWrite("Rebuild"&random(0,222)&@crlf)
		$SCE_EDITOR[$i] = $SCE_EDITOR[$i + 1]
		$Plugin_Handle[$i] = $Plugin_Handle[$i + 1]
		$Datei_pfad[$i] = $Datei_pfad[$i + 1]
		$FILE_CACHE[$i] = $FILE_CACHE[$i + 1]
	Next

	;Send "Close Tab" to the scripttree
	_ISN_Call_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "_Scripttree_Close_Tab", String($nr)) ;Refresh Scripttree


	$Offene_tabs = $Offene_tabs - 1

	_GUICtrlTab_ActivateTabX($htab, $Offene_tabs - 1, 0)
	_Show_Tab(_GUICtrlTab_GetCurFocus($htab))
	If $refresh = 1 Then _Check_Buttons(1)
	If _GUICtrlTab_GetItemCount($htab) > 0 And $refresh = 1 And _GUICtrlTab_GetCurFocus($htab) <> -1 Then _Redraw_Window($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Can_open_new_tab = 1
	GUISetCursor(2, 0, $studiofenster)
	_Pruefe_ob_sich_Datei_im_Temp_Ordner_befindet($Dateipfad)
	_Write_ISN_Debug_Console("|--> Script tab successfully closed!", 1)
EndFunc   ;==>_Close_Tab_Script


Func try_to_Close_Tab($nr, $refresh = 1)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Can_open_new_tab = 0 Then Return

	If $Plugin_Handle[$nr] = -1 Then
		If _SCE_EDITOR_is_Read_only($SCE_EDITOR[$nr]) Then Return
	EndIf


	_GUICtrlStatusBar_SetText_ISN($Status_bar, "")
	_Detailinfos_ausblenden()
	$nr = Int($nr)
	If $Plugin_Handle[$nr] = -1 Then
		_Close_Tab_Script($nr, $refresh)
	Else
		_Close_Tab_plugin($nr)
	EndIf
	_run_rule($Section_Trigger8)

EndFunc   ;==>try_to_Close_Tab

Func _Check_tabs_for_changes()
	AdlibUnRegister("_Check_tabs_for_changes")
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return

	Local $Can_Undo = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANUNDO, 0, 0)
	Local $Can_Redo = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANREDO, 0, 0)

	;Note: If splitting is needed to avoid redraw error in vertical toolbar

	If $Can_Undo Then
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $EditMenu_item1, False), 4) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $EditMenu_item1, $MFS_DISABLED, False, False)
	Else
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $EditMenu_item1, False), 4) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $EditMenu_item1, $MFS_DISABLED, True, False)
	EndIf

	If $Can_Redo Then
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $EditMenu_item2, False), 4) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $EditMenu_item2, $MFS_DISABLED, False, False)
	Else
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $EditMenu_item2, False), 4) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $EditMenu_item2, $MFS_DISABLED, True, False)
	EndIf

	If $Can_Undo Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id11), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id11, _GUICtrlToolbar_GetButtonState($hToolbar, $id11) + $TBSTATE_ENABLED)
	Else
		If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id11), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id11, _GUICtrlToolbar_GetButtonState($hToolbar, $id11) - $TBSTATE_ENABLED)
	EndIf

	If $Can_Redo Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id12), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id12, _GUICtrlToolbar_GetButtonState($hToolbar, $id12) + $TBSTATE_ENABLED)
	Else
		If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id12), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id12, _GUICtrlToolbar_GetButtonState($hToolbar, $id12) - $TBSTATE_ENABLED)
	EndIf


	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 And Not BitAND(_GUICtrlTab_GetItemState($htab, _GUICtrlTab_GetCurFocus($htab)), $TCIS_HIGHLIGHTED) Then
		$Data = Sci_GetLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		If $Data == $FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] Then
			_GUICtrlTab_HighlightItem($htab, _GUICtrlTab_GetCurFocus($htab), False)
			$tab_txt = _GUICtrlTab_GetItemText($htab, _GUICtrlTab_GetCurFocus($htab))
			If StringRight($tab_txt, 2) = " *" Then _GUICtrlTab_SetItemText($htab, _GUICtrlTab_GetCurFocus($htab), StringTrimRight($tab_txt, 2))
		Else
			_GUICtrlTab_HighlightItem($htab, _GUICtrlTab_GetCurFocus($htab), True)
			$tab_txt = _GUICtrlTab_GetItemText($htab, _GUICtrlTab_GetCurFocus($htab))
			If StringRight($tab_txt, 2) <> " *" Then _GUICtrlTab_SetItemText($htab, _GUICtrlTab_GetCurFocus($htab), $tab_txt & " *")
		EndIf
	EndIf


EndFunc   ;==>_Check_tabs_for_changes


;Saves specified data to the current opened file

Func Save_File($nr = 0, $rebuildtree = 1)
	If $nr = -1 Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	_Write_ISN_Debug_Console("Saving file (" & $Datei_pfad[$nr] & ") ", 1, 0)
	Local $handle = ""
	If FileGetEncoding($Datei_pfad[$nr]) = $FO_ANSI Then
		$handle = FileOpen($Datei_pfad[$nr], 2 + $FO_ANSI)
		_Write_ISN_Debug_Console("[SAVE AS ANSI]...", 0, 0, 1, 1)
	Else
		_Write_ISN_Debug_Console("[SAVE WITH ENCODING VALUE " & FileGetEncoding($Datei_pfad[$nr]) & "]...", 0, 0, 1, 1)
		$handle = FileOpen($Datei_pfad[$nr], 2 + FileGetEncoding($Datei_pfad[$nr]))
	EndIf
	;_Write_log(_Get_langstr(86)&" "&stringtrimleft($Datei_pfad[$nr],stringinstr($Datei_pfad[$nr],"\",0,-1)))
	$Data = Sci_GetLines($SCE_EDITOR[$nr])
	If Not FileWrite($handle, _ANSI2UNICODE($Data)) Then
		FileClose($handle)
		_Write_ISN_Debug_Console("ERROR", 3, 1, 1, 1)
		_Write_log(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)) & " " & _Get_langstr(692), "FF0000")
;~ 		MsgBox(16, _Get_langstr(25), _Get_langstr(151), Default, $StudioFenster)
		Return 0
	EndIf
	FileClose($handle)
	$FILE_CACHE[$nr] = $Data
	_GUICtrlTab_HighlightItem($htab, $nr, False)
	$tab_txt = _GUICtrlTab_GetItemText($htab, $nr)
	If StringRight($tab_txt, 2) = " *" Then _GUICtrlTab_SetItemText($htab, $nr, StringTrimRight($tab_txt, 2))

	SendMessageString($SCE_EDITOR[$nr], $SCI_SETSAVEPOINT, 0, 0)
;~ 	If $rebuildtree = 1 Then _Build_Scripttree(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)), $nr)
	If Sci_GetLineCount($SCE_EDITOR[$nr]) > 4500 Then _Earn_trophy(14, 3)
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
	_Write_log(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)) & " " & _Get_langstr(691), "209B25")
	Return 1

EndFunc   ;==>Save_File

Func _try_to_save_file($nr, $rebuildtree = 1, $Nur_Skript_Tabs_Speichern = 0)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Can_open_new_tab = 0 Then Return
	$Automatische_Speicherung_eingabecounter = 0 ;Eingabecounter resetten
	$Can_open_new_tab = 0
	_QuickView_Save_Notes()
	$ext = StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], ".", 1, -1))
	If $ext = $Autoitextension Then
		GUISetCursor(1, 0, $Studiofenster)
		If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_DISABLE) Then GUICtrlSetState($FileMenu_item1, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_DISABLE) Then GUICtrlSetState($FileMenu_item1b, $GUI_DISABLE)
		If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, _GUICtrlToolbar_GetButtonState($hToolbar, $id10) - $TBSTATE_ENABLED)
		If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, _GUICtrlToolbar_GetButtonState($hToolbar, $id29) - $TBSTATE_ENABLED)
		_Editor_Save_Fold()
		_Remove_Marks()
		_Remove_Marks($Debug_log)
		Save_File($nr, $rebuildtree)
		_run_rule($Section_Trigger3)
		_ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "_Scripttree_Force_Refresh_Silent", String($nr)) ;Refresh Scripttree
		$Can_open_new_tab = 1
		GUISetCursor(2, 0, $Studiofenster)
		If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_ENABLE) Then GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_ENABLE) Then GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, _GUICtrlToolbar_GetButtonState($hToolbar, $id10) + $TBSTATE_ENABLED)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, _GUICtrlToolbar_GetButtonState($hToolbar, $id29) + $TBSTATE_ENABLED)
		Return
	Else
		If $Plugin_Handle[$nr] = -1 Then
			GUISetCursor(1, 0, $Studiofenster)
			If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_DISABLE) Then GUICtrlSetState($FileMenu_item1, $GUI_DISABLE)
			If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_DISABLE) Then GUICtrlSetState($FileMenu_item1b, $GUI_DISABLE)
			If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, _GUICtrlToolbar_GetButtonState($hToolbar, $id10) - $TBSTATE_ENABLED)
			If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, _GUICtrlToolbar_GetButtonState($hToolbar, $id29) - $TBSTATE_ENABLED)
			Save_File($nr, 0)
			_run_rule($Section_Trigger3)
			$Can_open_new_tab = 1
			GUISetCursor(2, 0, $Studiofenster)
			If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_ENABLE) Then GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
			If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_ENABLE) Then GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, _GUICtrlToolbar_GetButtonState($hToolbar, $id10) + $TBSTATE_ENABLED)
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, _GUICtrlToolbar_GetButtonState($hToolbar, $id29) + $TBSTATE_ENABLED)
			Return
		EndIf
	EndIf
	If $Nur_Skript_Tabs_Speichern = 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[$nr], "save")
	_Write_log(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)) & " " & _Get_langstr(691), "209B25")
	_run_rule($Section_Trigger3)
	$Can_open_new_tab = 1
EndFunc   ;==>_try_to_save_file


Func _Debug_log_try_undo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SendMessage($Debug_log, $SCI_UNDO, 0, 0)
	SendMessage($Debug_log, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()
	_Debug_log_check_redo_undo()
EndFunc   ;==>_Debug_log_try_undo

Func _Debug_log_try_redo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SendMessage($Debug_log, $SCI_REDO, 0, 0)
	SendMessage($Debug_log, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()
	_Debug_log_check_redo_undo()

EndFunc   ;==>_Debug_log_try_redo

Func _Debug_clear_redo()
	SendMessage($Debug_log, $SCI_EMPTYUNDOBUFFER, 0, 0)
	_Debug_log_check_redo_undo()
EndFunc   ;==>_Debug_clear_redo

Func _Debug_Inahlt_in_Zwischenablage()
	ClipPut(Sci_GetText($Debug_log))
EndFunc   ;==>_Debug_Inahlt_in_Zwischenablage

Func _Debug_log_check_redo_undo()
	If SendMessage($Debug_log, $SCI_CANUNDO, 0, 0) = 1 Then
		GUICtrlSetState($Debug_Log_Undo_Button, $GUI_ENABLE)
	Else
		GUICtrlSetState($Debug_Log_Undo_Button, $GUI_DISABLE)
	EndIf

	If SendMessage($Debug_log, $SCI_CANREDO, 0, 0) = 1 Then
		GUICtrlSetState($Debug_Log_Redo_Button, $GUI_ENABLE)
	Else
		GUICtrlSetState($Debug_Log_Redo_Button, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Debug_log_check_redo_undo

Func _try_undo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SendMessage($current_Scintilla_Window, $SCI_UNDO, 0, 0)
	SendMessage($current_Scintilla_Window, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()

	_Check_tabs_for_changes()
EndFunc   ;==>_try_undo


Func _Scripteditor_Select_all()
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_SETSEL, 0, -1)
EndFunc   ;==>_Scripteditor_Select_all


Func _try_redo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return

	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SendMessage($current_Scintilla_Window, $SCI_REDO, 0, 0)
	SendMessage($current_Scintilla_Window, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()

	_Check_tabs_for_changes()
EndFunc   ;==>_try_redo

Func _Close_All_Tabs()
	If $Offenes_Projekt = "" Then Return
	If $Tabs_closing = 1 Then Return

	$ParameterEditor_GUI_State = WinGetState($ParameterEditor_GUI, "")
	If BitAND($ParameterEditor_GUI_State, 2) Then
		MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1296), "%1", WinGetTitle($ParameterEditor_GUI)), 0, $studiofenster)
		Return
	EndIf


	$Tabs_closing = 1
	_Write_log(_Get_langstr(81))
	GUISetCursor(1, 0, $studiofenster)
	While $Offene_tabs > 0
		try_to_Close_Tab($Offene_tabs - 1, 0)
;~ 		sleep(10)
	WEnd
	_Check_Buttons(0)
	$Tabs_closing = 0
	GUISetCursor(2, 0, $studiofenster)
EndFunc   ;==>_Close_All_Tabs

Func _Toggle_Search()
	If $Offenes_Projekt = "" Then Return
	$state = WinGetState($fFind1, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $fFind1)
	Else
		GUISetState(@SW_SHOW, $fFind1)
		_WinAPI_SetFocus(ControlGetHandle($fFind1, "", $Search_Combo1))
	EndIf
EndFunc   ;==>_Toggle_Search

Func _Show_Search()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$len = GetSelLength($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If $len > 0 Then
		$Text = DllStructCreate("char[" & $len + 1 & "]")
		DllCall($user32, "int", "SendMessageA", "hwnd", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "int", $SCI_GETSELTEXT, "int", 0, "ptr", DllStructGetPtr($Text))
		$findWhat = DllStructGetData($Text, 1)
		$Text = 0
	EndIf
	GUICtrlSetData($Search_Combo1, _ANSI2UNICODE($findWhat), _ANSI2UNICODE($findWhat))
	FindNext($findWhat, False, $showWarnings, $flags, True)

	GUISetState(@SW_SHOW, $fFind1)
	_WinAPI_SetFocus(ControlGetHandle($fFind1, "", $Search_Combo1))
EndFunc   ;==>_Show_Search


Func btnFindNextClick()
	If GUICtrlRead($Search_Combo1) = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Global $sci, $flags, $findWhat, $findTarget, $wrapFind, $reverseDirection
	$flags = 0

	If GUICtrlRead($cbFindMatchCase) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_MATCHCASE)
	EndIf

	If GUICtrlRead($cbFindWholeWords) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_WHOLEWORD)
	EndIf

	If GUICtrlRead($cbFindRe) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_REGEXP, $SCFIND_POSIX)
	EndIf

	If GUICtrlRead($cbFindWrapAround) == $GUI_CHECKED Then
		$wrapFind = True
	Else
		$wrapFind = False
	EndIf

	If GUICtrlRead($rFindDirectionUp) == $GUI_CHECKED Then
		$reverseDirection = True
	Else
		$reverseDirection = False
	EndIf

	If GUICtrlRead($cbFindShowWarnings) == $GUI_CHECKED Then
		$showWarnings = True
	Else
		$showWarnings = False
	EndIf

	$findWhat = GUICtrlRead($Search_Combo1)
	GUICtrlSetData($Search_Combo1, $findWhat, $findWhat)
	If $autoit_editor_encoding = "2" Then $findWhat = _UNICODE2ANSI($findWhat)


	FindNext($findWhat, $reverseDirection, $showWarnings, $flags, False, 0, _Search_Get_Styles_to_ignore_String())
	_Check_tabs_for_changes()
EndFunc   ;==>btnFindNextClick

Func _Search_Open_Regex_Help()
	ShellExecute("https://www.scintilla.org/SciTERegEx.html")
EndFunc   ;==>_Search_Open_Regex_Help


Func _Search_Get_Styles_to_ignore_String()
	$Ignored_Styles = ","


	If GUICtrlRead($search_whitespace_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_DEFAULT & ","
	EndIf

	If GUICtrlRead($search_commentline_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_COMMENT & ","
	EndIf

	If GUICtrlRead($search_commentBlock_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_COMMENTBLOCK & ","
	EndIf

	If GUICtrlRead($search_number_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_NUMBER & ","
	EndIf

	If GUICtrlRead($search_function_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_FUNCTION & ","
	EndIf

	If GUICtrlRead($search_keyword_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_KEYWORD & ","
	EndIf

	If GUICtrlRead($search_macro_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_MACRO & ","
	EndIf

	If GUICtrlRead($search_string_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_STRING & ","
	EndIf


	If GUICtrlRead($search_operator_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_OPERATOR & ","
	EndIf

	If GUICtrlRead($search_variable_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_VARIABLE & ","
	EndIf

	If GUICtrlRead($search_sentkeys_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_SENT & ","
	EndIf

	If GUICtrlRead($search_preprocessor_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_PREPROCESSOR & ","
	EndIf

	If GUICtrlRead($search_special_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_SPECIAL & ","
	EndIf

	If GUICtrlRead($search_abbrev_checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_EXPAND & ","
	EndIf

	If GUICtrlRead($search_ComObject_Checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_COMOBJ & ","
	EndIf

	If GUICtrlRead($search_ComObject_Checkbox) = $GUI_UNCHECKED Then
		$Ignored_Styles = $Ignored_Styles & $SCE_AU3_UDF & ","
	EndIf

	$SearchGUI_Styles_to_Ignore_Buffer = $Ignored_Styles
	Return $Ignored_Styles
EndFunc   ;==>_Search_Get_Styles_to_ignore_String
Func _Seach_Labels_Set_Code_Style()

	Local $Font = $scripteditor_font

	For $x = 1 To 16
		$Zulesender_String1 = Execute("$SCE_AU3_STYLE" & $x & "a")
		$Zulesender_String2 = Execute("$SCE_AU3_STYLE" & $x & "b")
		If $Zulesender_String1 <> "" And $Zulesender_String2 <> "" Then
			$Split1 = StringSplit($Zulesender_String1, "|", 2)
			$Split2 = StringSplit($Zulesender_String2, "|", 2)
			If UBound($Split1) - 1 = 4 And UBound($Split2) - 1 = 4 Then ;Nur bei korrekter Anzahl an Splits

				If $Split1[2] = 1 Then
					$Bold1 = 800
				Else
					$Bold1 = 400
				EndIf

				If $Split2[2] = 1 Then
					$Bold2 = 800
				Else
					$Bold2 = 400
				EndIf

				$attribute1 = 0
				If $Split1[3] = 1 Then $attribute1 = $attribute1 + 2
				If $Split1[4] = 1 Then $attribute1 = $attribute1 + 4

				$attribute2 = 0
				If $Split2[3] = 1 Then $attribute2 = $attribute2 + 2
				If $Split2[4] = 1 Then $attribute2 = $attribute2 + 4

				$control = ""
				Switch $x

					Case 1
						$control = $search_whitespace_label

					Case 2
						$control = $search_commentline_label

					Case 3
						$control = $search_commentBlock_label

					Case 4
						$control = $search_number_label

					Case 5
						$control = $search_function_label

					Case 6
						$control = $search_keyword_label

					Case 7
						$control = $search_macro_label

					Case 8
						$control = $search_string_label

					Case 9
						$control = $search_operator_label

					Case 10
						$control = $search_variable_label

					Case 11
						$control = $search_sentkeys_label

					Case 12
						$control = $search_preprocessor_label

					Case 13
						$control = $search_special_label

					Case 14
						$control = $search_abbrev_label

					Case 15
						$control = $search_ComObject_label

					Case 16
						$control = $search_UDF_Label

				EndSwitch


				If $use_new_au3_colours = "true" Then
					GUICtrlSetColor($control, _BGR_to_RGB($Split2[0]))
					GUICtrlSetFont($control, $Default_font_size, $Bold2, $attribute2, $Font)
				Else
					GUICtrlSetColor($control, _BGR_to_RGB($Split1[0]))
					GUICtrlSetFont($control, $Default_font_size, $Bold1, $attribute1, $Font)
				EndIf

			EndIf
		EndIf
	Next
EndFunc   ;==>_Seach_Labels_Set_Code_Style


Func _Seach_Where_to_Search_Select_all()
	GUICtrlSetState($search_whitespace_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_commentline_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_commentBlock_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_number_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_function_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_keyword_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_macro_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_string_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_operator_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_variable_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_sentkeys_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_preprocessor_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_special_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_abbrev_checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_ComObject_Checkbox, $GUI_CHECKED)
	GUICtrlSetState($search_UDF_Checkbox, $GUI_CHECKED)
EndFunc   ;==>_Seach_Where_to_Search_Select_all

Func _Seach_Where_to_Search_Select_None()
	GUICtrlSetState($search_whitespace_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_commentline_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_commentBlock_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_number_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_function_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_keyword_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_macro_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_string_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_operator_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_variable_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_sentkeys_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_preprocessor_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_special_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_abbrev_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_ComObject_Checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($search_UDF_Checkbox, $GUI_UNCHECKED)
EndFunc   ;==>_Seach_Where_to_Search_Select_None

Func btnFindReplaceAllClick()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Global $sci, $flags, $findWhat, $findTarget, $wrapFind, $reverseDirection
	$flags = 0

	If GUICtrlRead($cbFindMatchCase) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_MATCHCASE)
	EndIf

	If GUICtrlRead($cbFindWholeWords) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_WHOLEWORD)
	EndIf

	If GUICtrlRead($cbFindRe) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_REGEXP, $SCFIND_POSIX)
	EndIf

	If GUICtrlRead($cbFindWrapAround) == $GUI_CHECKED Then
		$wrapFind = False
	Else
		$wrapFind = False
	EndIf

	If GUICtrlRead($rFindDirectionUp) == $GUI_CHECKED Then
		$reverseDirection = True
	Else
		$reverseDirection = False
	EndIf

	If GUICtrlRead($cbFindShowWarnings) == $GUI_CHECKED Then
		$showWarnings = True
	Else
		$showWarnings = False
	EndIf

	$findWhat = GUICtrlRead($Search_Combo1)
	$ReplaceWith = GUICtrlRead($Search_Combo2)
	GUICtrlSetData($Search_Combo2, $ReplaceWith, $ReplaceWith)
	If $autoit_editor_encoding = "2" Then $findWhat = _UNICODE2ANSI($findWhat)
	Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], 0)
	GUIRegisterMsg($WM_NOTIFY, '')
	While FindNext($findWhat, $reverseDirection, $showWarnings, $flags, False, 0, _Search_Get_Styles_to_ignore_String()) > -1
		SendMessageString($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_REPLACESEL, 0, GUICtrlRead($Search_Combo2))
	WEnd
	GUIRegisterMsg($WM_NOTIFY, '_WM_NOTIFY')
	_Check_tabs_for_changes()
EndFunc   ;==>btnFindReplaceAllClick

Func CloseFind()
	GUISetState(@SW_HIDE, $fFind1)
EndFunc   ;==>CloseFind

Func btnFindReplaceClick()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If GetSelLength($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) > 0 Then
		$ReplaceWith = GUICtrlRead($Search_Combo2)
		GUICtrlSetData($Search_Combo2, $ReplaceWith, $ReplaceWith)
		SendMessageString($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_REPLACESEL, 0, GUICtrlRead($Search_Combo2))
		btnFindNextClick()
	EndIf
	_Check_tabs_for_changes()
EndFunc   ;==>btnFindReplaceClick

Func SetSelection($anchor, $currentPos)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEL, $anchor, $currentPos)
EndFunc   ;==>SetSelection

Func FindNext($findWhat, $reverseDirection = False, $showWarnings = True, $flags = 0, $showgui = False, $reset = 0, $Ignored_Styles = "")

	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Ignored_Styles <> "" Then $Ignored_Styles = "," & $Ignored_Styles & ","
	Global $findTarget, $wrapFind, $replacing
	If ($findWhat == "") Or ($showgui) Then
		If $reverseDirection Then
			GUICtrlSetState($rFindDirectionUp, $GUI_CHECKED)
			GUICtrlSetState($rFindDirectionDown, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($rFindDirectionUp, $GUI_UNCHECKED)
			GUICtrlSetState($rFindDirectionDown, $GUI_CHECKED)

		EndIf
		GUISetState(@SW_SHOW, $fFind1)
		_WinAPI_SetFocus(ControlGetHandle($fFind1, "", $Search_Combo1))
		Return -1
	EndIf

	$findTarget = $findWhat
	$lenFind = StringLen($findTarget)
	If ($lenFind == 0) Then
		Return -1
	EndIf

	$startPosition = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
;~ 	$startPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_GETTARGETEND, 0, 0)

;~
	$endPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0)
	If ($reverseDirection) Then
		$startPosition = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		$endPosition = 0
	EndIf

	;$flags = ($wholeWord ? SCFIND_WHOLEWORD : 0) |
	;            (matchCase ? SCFIND_MATCHCASE : 0) |
	;            (regExp ? SCFIND_REGEXP : 0) |
	;            (props.GetInt("find.replace.regexp.posix") ? SCFIND_POSIX : 0);

	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEARCHFLAGS, $flags, 0) ;
	$posFind = FindInTarget($findTarget, $lenFind, $startPosition, $endPosition, $Ignored_Styles)

	If ($posFind == -1) And ($wrapFind) Then
		If ($reverseDirection) Then
			$startPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0)
			$endPosition = 0 ;
		Else
			$startPosition = 0 ;
			$endPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0)
		EndIf
		$posFind = FindInTarget($findTarget, $lenFind, $startPosition, $endPosition, $Ignored_Styles) ;
		If ($showWarnings) Then
			WarnUser(_Get_langstr(102)) ;
		EndIf
	EndIf
	If ($posFind == -1) Then
		$havefound = False ;
		If ($showWarnings) Then
			WarnUser(_Get_langstr(103) & " '" & $findWhat & "'!") ;
		EndIf
	Else

		$havefound = True ;
		$start = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETTARGETSTART, 0, 0) ;
		$end = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETTARGETEND, 0, 0) ;
		$line = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $start)
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETYCARETPOLICY, $CARET_EVEN + $CARET_STRICT, 0)
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETXCARETPOLICY, $CARET_EVEN + $CARET_STRICT, 0)
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0) ;
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GOTOLINE, $line, 0)
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETYCARETPOLICY, 0, 0)
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETXCARETPOLICY, 0, 0)

		If ($reverseDirection) Then
			Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $start)
			SetSelection($end, $start) ;
		Else
			Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $end)
			SetSelection($start, $end) ;
		EndIf
		EnsureRangeVisible($start, $end) ;


	EndIf
	Return $posFind ;
EndFunc   ;==>FindNext

Func WarnUser($txt)
	Return MsgBox(262144 + 8192, _Get_langstr(61), $txt)
EndFunc   ;==>WarnUser

Func FindInTarget($findWhat, $lenFind, $startPosition, $endPosition, $styles_to_ignore = "")



	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETTARGETSTART, $startPosition, 0)
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETTARGETEND, $endPosition, 0)

	$findWhatPtr = DllStructCreate("char[" & StringLen($findWhat) + 1 & "]")
	DllStructSetData($findWhatPtr, 1, $findWhat)
	$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "int", $SCI_SEARCHINTARGET, "int", StringLen($findWhat), "ptr", DllStructGetPtr($findWhatPtr))
	$posFind = $ret[0]

	$findWhatPtr = 0

	If $styles_to_ignore <> "" Then
		If $posFind <> -1 Then
			$style = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSTYLEAT, $posFind, 0)
			If $endPosition <> 0 Then
				If StringInStr($styles_to_ignore, "," & $style & ",") Then Return FindInTarget($findWhat, $lenFind, $posFind + $lenFind, $endPosition, $styles_to_ignore) ;We do not want this result..search again
			Else
				If StringInStr($styles_to_ignore, "," & $style & ",") Then Return FindInTarget($findWhat, $lenFind, $posFind, $endPosition, $styles_to_ignore) ;We do not want this result..search again
			EndIf
		EndIf
	EndIf


	Return $posFind ;
EndFunc   ;==>FindInTarget

Func EnsureRangeVisible($posStart, $posEnd, $enforcePolicy = False)
	$lineStart = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, _Min($posStart, $posEnd), 0) ;
	$lineEnd = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, _Max($posStart, $posEnd), 0) ;
	For $line = $lineStart To $lineEnd
		If ($enforcePolicy) Then
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0)
		Else
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_ENSUREVISIBLE, $line, 0)

		EndIf
	Next
EndFunc   ;==>EnsureRangeVisible

Func GetSelLength($sci)
	$startPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONSTART, 0, 0)
	$endPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONEND, 0, 0)
	$len = $endPosition - $startPosition
	Return $len
EndFunc   ;==>GetSelLength

Func _Is_Comment($handle = "")
	If $handle = "" Then
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return False
		$handle = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]
	EndIf
	;prüft ob aktuelle Position ein Kommentar ist oder nicht
	$res = SendMessage($handle, $SCI_GETSTYLEAT, Sci_GetCurrentPos($handle), 0)
	If $res = $SCE_AU3_COMMENT Or $res = $SCE_AU3_COMMENTBLOCK Then
;~ ConsoleWrite("COMMENT!"&@crlf)
		Return True
	EndIf
;~ ConsoleWrite("NO COMMENT!"&@crlf)
	Return False
EndFunc   ;==>_Is_Comment

Func _Try_Jump_To_Line($string, $startpos = 0)
	$wrapFind = True
	If $startpos = 0 Then FindNext($string & Random(23043), False, False, $SCFIND_WHOLEWORD, False) ;mache zufallssuche um wieder von oben zu beginnen ^^
	$found = FindNext($string, False, False, $SCFIND_WHOLEWORD, False)
	While 1
		;suche solange bis wieder das element ohne kommentar gefunden wurde...
		If _Is_Comment() = True Then $found = FindNext($string, False, False, $SCFIND_WHOLEWORD, False)
		If _Is_Comment() = False Then ExitLoop
		If $found = -1 Then ExitLoop
	WEnd
	Return $found
EndFunc   ;==>_Try_Jump_To_Line

;~ ConsoleWrite("> " & @ScriptLineNumber & " makes color BLUE" & @CRLF)
;~ ConsoleWrite("! " & @ScriptLineNumber & " makes color RED" & @CRLF)
;~ ConsoleWrite("- " & @ScriptLineNumber & " makes color ORANGE" & @CRLF)
;~ ConsoleWrite("+ " & @ScriptLineNumber & " makes color GREEN" & @CRLF)

Func _Write_debug($str = "")
	$errorfinder = 0
	If $str = "" Then Return

;~ 	if stringinstr($str, "==>") Then
;~ 		_Earn_trophy(3, 1)
;~ 		$str = "[c=#FF0000]" & $str & "[/c] "
;~ 		$errorfinder = 1
;~ 		_run_rule($Section_Trigger11)
;~ 	endif
;~
;~ 	if stringinstr($str, _Get_langstr(107)) Then
;~ 		$str = "[c=#FF0000]" & $str & "[/c] "
;~ 	endif

	;Encoding
	$str = _UNICODE2ANSI($str)
	$startline = Sci_GetLineStartPos($Debug_log, Sci_GetLineCount($Debug_log) - 1)
	Sci_AddLines($Debug_log, $str, Sci_GetLineCount($Debug_log))
	SendMessage($Debug_log, $SCI_DOCUMENTEND, 0, 0)


	If $Console_Bluemode = 1 Then
		SendMessage($Debug_log, $SCI_StartStyling, $startline, 31)
		SendMessage($Debug_log, $SCI_SetStyling, Sci_GetLenght($Debug_log), 4)
	EndIf

	If StringInStr($str, "==>") Then
		_Earn_trophy(3, 1)
		$startline = Sci_Search($Debug_log, "==>", Sci_GetLineStartPos($Debug_log, $startline), 0)
		SendMessage($Debug_log, $SCI_StartStyling, $startline, 31)
		SendMessage($Debug_log, $SCI_SetStyling, Sci_GetLenght($Debug_log), 3)
		$errorfinder = 1
		_run_rule($Section_Trigger11)
	EndIf

	If StringInStr($str, _Get_langstr(107)) Then
		SendMessage($Debug_log, $SCI_StartStyling, $startline, 31)
		SendMessage($Debug_log, $SCI_SetStyling, Sci_GetLenght($Debug_log), 10)
	EndIf

	If $errorfinder = 1 And $Erweitertes_debugging = "false" Then _trytofinderror(1)



	_Debug_log_check_redo_undo()
EndFunc   ;==>_Write_debug

Func _Write_debug_old($str = "")
	$errorfinder = 0
	If $str = "" Then Return
	If $Console_Bluemode = 1 Then
		$str = "[c=#0000FF]" & $str & "[/c] "
	EndIf

	If StringInStr($str, "==>") Then
		_Earn_trophy(3, 1)
		$str = "[c=#FF0000]" & $str & "[/c] "
		$errorfinder = 1
		_run_rule($Section_Trigger11)
	EndIf

	If StringInStr($str, _Get_langstr(107)) Then
		$str = "[c=#FF0000]" & $str & "[/c] "
	EndIf

	_GUICtrlRichEdit_SetFont($Debug_log, 10, "Courier New")
	_ChatBoxAdd($Debug_log, $str)
	If $errorfinder = 1 Then _trytofinderror(1)
EndFunc   ;==>_Write_debug_old

Func _Clear_Debuglog()
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SCI_SetText($Debug_log, "")
	SendMessage($Debug_log, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()
	$F4_Fehler_aktuelle_Zeile = 0
EndFunc   ;==>_Clear_Debuglog

Func _Syntaxcheck($file)
	If Not FileExists($Au3Checkexe) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1169), 0, $studiofenster)
		Return
	EndIf
	_STOPSCRIPT() ;Wenn noch ein Skript läuft -> Stoppen!
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_Syntaxcheck) <> -1 Then Return ;Platzhalter für Plugin
	If BitAND(_GUICtrlTab_GetItemState($htab, _GUICtrlTab_GetCurFocus($htab)), $TCIS_HIGHLIGHTED) Then _try_to_save_file(_GUICtrlTab_GetCurFocus($htab)) ;Nur Speichern wenn in der Datei auch was geändert wurde (Neu seit version 1.03)
	_Clear_Debuglog()
	Global $starttime = _Timer_Init()
	$SKRIPT_LAUEFT = 1
	;_Check_Buttons()
	$var = StringTrimRight($autoitexe, StringLen($autoitexe) - StringInStr($autoitexe, "\", 0, -1) + 1)
	$var = $var & "\Include"
	$Console_Bluemode = 0
	$Data = _RunReadStd('"' & $Au3Checkexe & '" -I "' & $var & '" "' & $file & '"', 0, $Offenes_Projekt, @SW_HIDE, 1)
	$Console_Bluemode = 1
	_Write_debug(@CRLF & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " -> Exit Code: " & $Data[1] & @TAB & "(" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)")
	$Console_Bluemode = 0
	_Timer_KillTimer($studiofenster, $starttime)
	$SKRIPT_LAUEFT = 0
	_run_rule($Section_Trigger5)
	;_Check_Buttons()
EndFunc   ;==>_Syntaxcheck



Func _Run_New_AutoIt_Studio_Helper_Instance($commands = "")

	If Not FileExists($Autoit_Studio_Helper_exe) And Not FileExists(StringReplace($Autoit_Studio_Helper_exe, ".exe", ".au3")) Then
		;Helper nicht gefunden
		MsgBox(262144 + 16, "Error", "Autoit_Studio_Helper.exe not found!" & @CRLF & "Parts of the ISN AutoIt Studio may not work as expected!!!", 0, $Studiofenster)
		SetError(-1)
		Return -1
	EndIf


	Local $Helpfer_exe = $Autoit_Studio_Helper_exe
	If Not FileExists($Helpfer_exe) Then
		$Helpfer_exe = $autoitexe & ' "' & StringReplace($Helpfer_exe, ".exe", ".au3") & '"' ;Wenn exe nicht vorhanden, nutze au3
	EndIf

	$Helper_PID = Run($Helpfer_exe & " " & $commands, @ScriptDir)
	_Write_ISN_Debug_Console("Started new ISN Helper Thread with PID " & $Helper_PID & " and the following commands: " & $commands, $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak)
	Local $Versuche_zum_suchen = 100 ;Wait about 10 Seconds for a thread response
	Local $Helper_WindowHandle
	While 1
		$Versuche_zum_suchen = $Versuche_zum_suchen - 1
		$Helper_WindowHandle = WinGetHandle("_ISNTHREAD_STARTUP_", "")
		If Not @error Then ExitLoop
		;Letzter Versuch
		If $Versuche_zum_suchen < 1 Then
			SetError(-1)
			Return -1
		EndIf
		Sleep(100)
	WEnd
	_ISN_Send_Message_to_Plugin($Helper_WindowHandle, _Plugin_Get_Unlockstring()) ;Sende Unlock Nachricht inkl. wichtige Startvariablen an den Thread
	$Result_Array = $Leeres_Array
	_ArrayAdd($Result_Array, $Helper_WindowHandle)
	_ArrayAdd($Result_Array, $Helper_PID)
	Return $Result_Array
EndFunc   ;==>_Run_New_AutoIt_Studio_Helper_Instance


Func _Testscript($file, $without_param = 0, $Parameter_String = "")
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 And $Studiomodus = 2 Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 And $Studiomodus = 2 Then Return
	If $SKRIPT_LAUEFT = 1 Then Return
	If $file = "" Then Return
	Local $params = ""

	If FileExists($autoitexe) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(300), 0, $studiofenster)
		Return
	EndIf

	If $Erweitertes_debugging = "true" Then Try_to_opten_file($file) ;Zu debuggende Datei sollte auch geöffnet sein

	;Toolbar und Buttons sperren
	If Not BitAND(GUICtrlGetState($ProjectMenu_item9), $GUI_DISABLE) Then GUICtrlSetState($ProjectMenu_item9, $GUI_DISABLE)
	If Not BitAND(GUICtrlGetState($ProjectMenu_item10), $GUI_ENABLE) Then GUICtrlSetState($ProjectMenu_item10, $GUI_ENABLE)
	If Not BitAND(GUICtrlGetState($ProjectMenu_item8), $GUI_DISABLE) Then GUICtrlSetState($ProjectMenu_item8, $GUI_DISABLE)
	If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id14), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id14, _GUICtrlToolbar_GetButtonState($hToolbar, $id14) - $TBSTATE_ENABLED)
	If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id15), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id15, _GUICtrlToolbar_GetButtonState($hToolbar, $id15) + $TBSTATE_ENABLED)
	If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id7), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id7, _GUICtrlToolbar_GetButtonState($hToolbar, $id7) - $TBSTATE_ENABLED)

	_run_rule($Section_Trigger9)


	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
	_Write_log(_Get_langstr(312), "209B25")
	_Save_All_only_script_tabs() ;Alle geöffneten Skripte (au3) Speichern bevor gestartet wird
	_Clear_Debuglog()


	If $without_param = 0 Then
		$params = ""
		If $Parameter_String = "" Then
			$array_params = StringSplit(_IniReadRaw($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "testparam", ""), "#BREAK#", 3)
		Else
			$array_params = StringSplit($Parameter_String, "#BREAK#", 3)
		EndIf
		If IsArray($array_params) Then
			For $x = 0 To UBound($array_params) - 1
				If $array_params[$x] <> "" Then
					If $x = 0 Then
						$params = $array_params[$x]
					Else
						$params = $params & " " & $array_params[$x]
					EndIf
				EndIf
			Next
		EndIf

	Else
		$params = ""
	EndIf

	;Helper Thread resetten
	$ISN_Helper_Threads[0][1] = ""
	$ISN_Helper_Threads[0][2] = ""

	$Console_Bluemode = 1
	_Write_debug(_Get_langstr(104) & " " & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & "..." & @CRLF & @CRLF)
	$Console_Bluemode = 0
	_Write_ISN_Debug_Console("Testing Au3 file (" & $file & ")...", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak)

	If $Erweitertes_debugging = "true" Then ;Falls Debugging aktiv "baue" zuerst das Debug-File
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERDELETEALL, 1, 0) ;Remove all break points

		FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)
		FileCopy($file, $szDrive & $szDir & $szFName & "_tmp" & $szExt, 1)
		_FileWriteToLine($szDrive & $szDir & $szFName & "_tmp" & $szExt, 1, "#Include <" & @ScriptDir & "\Data\Dbug\Dbug.au3>")
		If _GUICtrlTab_GetItemCount($htab) <> 0 Then RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_Sci_Handle", "REG_SZ", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) ;Handle des aktuellen SCI Fensters

		RunWait('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $szDrive & $szDir & $szFName & "_tmp" & $szExt & '" ', $szDrive & $szDir, @SW_HIDE)
		FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)
		$file = $szDrive & $szDir & "Dbug_" & $szFName & "_tmp" & $szExt

		If FileExists($szDrive & $szDir & "\DbgConsole.ico") Then
			FileDelete($szDrive & $szDir & "\DbgConsole.ico")
			_Check_Buttons(0)
			Return ;DBUG was launched with its OEM Console..so we can stop here
		EndIf
	EndIf


	$ISN_Scripttest_helper_Array = _Run_New_AutoIt_Studio_Helper_Instance('"/thread_task testscript" "/testscript_file ' & $file & '" "/testscript_parameter ' & StringReplace($params, '"', "<quote>") & '"')
	If IsArray($ISN_Scripttest_helper_Array) Then
		$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_Handle] = $ISN_Scripttest_helper_Array[0] ;Handle
		$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_PID] = $ISN_Scripttest_helper_Array[1] ;PID
	Else
		_Check_Buttons(0)
		_Write_debug("! Unable to start ISN Helper Thread for script testing!" & @CRLF & @CRLF)
		Return
	EndIf

	$SKRIPT_LAUEFT = 1
EndFunc   ;==>_Testscript

Func _STOPSCRIPT()
	If $SKRIPT_LAUEFT = 0 Then Return
	_ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_Handle], "_STOPSCRIPT")
;~ 	$SKRIPT_LAUEFT = 0
;~ 	_Timer_KillTimer($studiofenster, $starttime)
;~ 	_Check_Buttons(0)
;~ 	_run_rule($Section_Trigger10)
EndFunc   ;==>_STOPSCRIPT

#cs
	Func _TestscriptX($file, $without_param = 0, $Parameter_String = "")

	If _GUICtrlTab_GetItemCount($htab) = 0 And $Studiomodus = 2 Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 And $Studiomodus = 2 Then Return
	If $SKRIPT_LAUEFT = 1 Then Return
	If $file = "" Then Return

	Local $array_params
	If FileExists($autoitexe) = 0 Then
	MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(300), 0, $studiofenster)
	Return
	EndIf
	_run_rule($Section_Trigger9)
	$f = StringTrimLeft($file, StringInStr($file, "\", 0, -1))

	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
	_Write_log(_Get_langstr(312), "209B25")
	GUICtrlSetData($DEBUGGUI_TITLE, $f & " - " & _Get_langstr(306))
	_Show_DebugGUI()

	;~ 	if _GUICtrlTab_GetItemCount($htab) > 0 AND IsArray($Datei_pfad) then
	;~ 		$ext = stringtrimleft($Datei_pfad[_GUICtrlTab_GetCurFocus($hTab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($hTab)], ".", 1, -1))
	;~
	;~ 		if $ext <> "isf" then
	;~ 			_try_to_save_file(_GUICtrlTab_GetCurFocus($hTab), 1) ;falls gerade das formstudio aktiv ist NICHT speichern da sonst die datei schreibgeschützt wird... -> Autoit kann nicht starten
	;~ 		EndIf
	;~ 	endif

	_Save_All_only_script_tabs() ;Alle geöffneten Skripte (au3) Speichern bevor gestartet wird

	_Clear_Debuglog()
	$Console_Bluemode = 1
	_Write_debug(_Get_langstr(104) & " " & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & "..." & @CRLF & @CRLF)
	$Console_Bluemode = 0

	Global $starttime = _Timer_Init()
	$SKRIPT_LAUEFT = 1
	_Check_Buttons(0)
	If $without_param = 0 Then
	$params = ""
	If $Parameter_String = "" Then
	$array_params = StringSplit(_IniReadRaw($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "testparam", ""), "#BREAK#", 3)
	Else
	$array_params = StringSplit($Parameter_String, "#BREAK#", 3)
	EndIf
	If IsArray($array_params) Then
	For $x = 0 To UBound($array_params) - 1
	If $array_params[$x] <> "" Then
	If $x = 0 Then
	$params = $array_params[$x]
	Else
	$params = $params & " " & $array_params[$x]
	EndIf
	EndIf
	Next
	EndIf

	Else
	$params = ""
	EndIf
	;~ 	$data = _RunReadStd(FileGetShortName($autoitexe) & " /ErrorStdOut " & FileGetShortName($file) & " " & $params, 0, $Offenes_Projekt, @SW_SHOW, 1)
	_Write_ISN_Debug_Console("Testing Au3 file (" & $file & ")...", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak)


	If $Erweitertes_debugging = "true" Then ;Falls Debugging aktiv "baue" zuerst das Debug-File
	RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_imagepath", "REG_SZ", @ScriptDir & "\Data\Dbug\IMAGES\") ;Pfad zum Images Ordner für Dbug



	Try_to_opten_file($file) ;Zu debuggende Datei sollte auch geöffnet sein
	sleep(100)
	If _GUICtrlTab_GetItemCount($htab) <> 0 Then RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_Sci_Handle", "REG_SZ", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) ;Handle des aktuellen SCI Fensters


	FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)
	FileCopy($file, $szDrive & $szDir & $szFName & "_tmp" & $szExt)
	_FileWriteToLine($szDrive & $szDir & $szFName & "_tmp" & $szExt, 1, "#Include <" & @ScriptDir & "\Data\Dbug\Dbug.au3>")
	RunWait('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $szDrive & $szDir & $szFName & "_tmp" & $szExt & '" ', $szDrive & $szDir, @SW_HIDE)
	FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)

	Sleep(100)
	$file = FileOpen($szDrive & $szDir & $szFName & "_tmp_debug.txt", 0 + $FO_ANSI)
	; Check if file opened for reading OK
	If $file = -1 Then
	MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(976))
	EndIf
	$params = FileReadLine($file, 1) ;Parameter werden überschrieben
	FileClose($file)


	$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $szDrive & $szDir & $szFName & "_tmp_debug" & $szExt & '" ' & $params, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	;Aufräumen
	If FileExists($szDrive & $szDir & $szFName & "_tmp_debug" & $szExt) Then FileDelete($szDrive & $szDir & $szFName & "_tmp_debug" & $szExt)
	If FileExists($szDrive & $szDir & $szFName & "_tmp_debug.txt") Then FileDelete($szDrive & $szDir & $szFName & "_tmp_debug.txt")
	If FileExists($szDrive & $szDir & $szFName & "_tmp_debug_debug.au3") Then FileDelete($szDrive & $szDir & $szFName & "_tmp_debug_debug.au3")
	Else
	If $starte_Skripts_mit_au3Wrapper = "false" Then
	$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $file & '" ' & $params, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	Else
	$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /run /prod /ErrorStdOut /in "' & $file & '" /UserParams ' & $params, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	EndIf
	EndIf
	$Console_Bluemode = 1
	_Write_debug(@CRLF & $szFName & $szExt & " -> Exit Code: " & $Data[1] & @TAB & "(" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)")
	$Console_Bluemode = 0
	_Timer_KillTimer($studiofenster, $starttime)

	$SKRIPT_LAUEFT = 0
	_HIDE_DebugGUI()
	_Check_Buttons(0)
	WinActivate($Studiofenster)
	EndFunc   ;==>_Testscript
#ce



Func _Toggle_GoToLine_GUI()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$state = WinGetState($JumpToLine_GUI, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $JumpToLine_GUI)
	Else

		Switch _WinAPI_GetActiveWindow()

			Case $Codeausschnitt_GUI
				_WinAPI_SetWindowLong($JumpToLine_GUI, $GWL_HWNDPARENT, $Codeausschnitt_GUI)

			Case $pelock_obfuscator_GUI
				_WinAPI_SetWindowLong($JumpToLine_GUI, $GWL_HWNDPARENT, $pelock_obfuscator_GUI)

			Case $Makro_Codeausschnitt_GUI
				_WinAPI_SetWindowLong($JumpToLine_GUI, $GWL_HWNDPARENT, $Makro_Codeausschnitt_GUI)

			Case $QuickView_GUI
				_WinAPI_SetWindowLong($JumpToLine_GUI, $GWL_HWNDPARENT, $QuickView_GUI)

			Case Else
				_WinAPI_SetWindowLong($JumpToLine_GUI, $GWL_HWNDPARENT, $StudioFenster)

		EndSwitch

		GUISetState(@SW_SHOW, $JumpToLine_GUI)
		GUICtrlSetState($JumpToLine_Combo, $GUI_FOCUS)
		_WinAPI_BringWindowToTop($JumpToLine_GUI)
	EndIf
EndFunc   ;==>_Toggle_GoToLine_GUI

Func _GoToLine_GUI_SelectLine()
	$LineToGo = Number(GUICtrlRead($JumpToLine_Combo))
	If $LineToGo = "" Or $LineToGo = 0 Then Return
	GUISetState(@SW_HIDE, $JumpToLine_GUI)
	$LineToGo = $LineToGo - 1
	GoToLine($LineToGo)
	GUICtrlSetData($JumpToLine_Combo, GUICtrlRead($JumpToLine_Combo), GUICtrlRead($JumpToLine_Combo))
EndFunc   ;==>_GoToLine_GUI_SelectLine

Func GoToLine($line = -1, $handle = "")
	If $Offenes_Projekt = "" Then Return
	If $line = -1 Then Return
	If $handle = "" Then
		$handle = _WinAPI_GetFocus()
		If _WinAPI_GetClassName($handle) <> "Scintilla" Then
			If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
			$handle = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]
		EndIf
	EndIf

	If StringIsInt($line) Then
		SendMessage($handle, $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0) ;
		SendMessage($handle, $SCI_GOTOLINE, $line, 0)
		_WinAPI_SetFocus($handle)
	EndIf
EndFunc   ;==>GoToLine


Func _trytofinderror($find = 0)
	Local $read = ""
	If $find = 0 Then
		$line = Sci_GetLineFromPos($Debug_log, Sci_GetCurrentPos($Debug_log))
		$F4_Fehler_aktuelle_Zeile = $line
		$read = Sci_GetLine($Debug_log, $line)
	Else

		If $F4_Fehler_aktuelle_Zeile <> 0 Then $F4_Fehler_aktuelle_Zeile = Number($F4_Fehler_aktuelle_Zeile) + 1
		If $F4_Fehler_aktuelle_Zeile > Sci_GetLineCount($Debug_log) Then Return
		For $aktuelle_Zeile = $F4_Fehler_aktuelle_Zeile To Sci_GetLineCount($Debug_log) Step +1
			If StringInStr(Sci_GetLine($Debug_log, $aktuelle_Zeile), "==>") Or StringInStr(Sci_GetLine($Debug_log, $aktuelle_Zeile), "error:") Or StringInStr(Sci_GetLine($Debug_log, $aktuelle_Zeile), "warning:") Then
				$F4_Fehler_aktuelle_Zeile = $aktuelle_Zeile
				$read = Sci_GetLine($Debug_log, $aktuelle_Zeile)
				ExitLoop
			EndIf
		Next
	EndIf
	If $read = "" Then Return


	$line = StringReplace($read, "(x86)", "")
	$line = StringReplace($line, '"', "")
	$line = StringTrimLeft($line, StringInStr($line, "("))
	$line = StringTrimRight($line, StringLen($line) - StringInStr($line, ")") + 1)
	If StringInStr($line, ",") Then $line = StringTrimRight($line, StringLen($line) - StringInStr($line, ",") + 1)
	$line = Number($line)

	If $line = "" Then Return

	$Pfad = StringInStr($read, "(")
	$Pfad = $Pfad - 1
	$Pfad = StringTrimRight($read, StringLen($read) - $Pfad + 1)
	$Pfad = StringReplace($Pfad, '"', "")

	$ext = StringTrimLeft($Pfad, StringInStr($Pfad, ".", 1, -1))
	$ext = StringReplace($ext, '"', "")
	$ext = StringReplace($ext, "'", "")




	If _GUICtrlTab_GetItemCount($htab) = 0 Then
		If $ext <> $Autoitextension Then Return
		Try_to_opten_file($Pfad)
	Else
		If $Pfad <> $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] Then
			If $ext <> $Autoitextension Then Return
			Try_to_opten_file($Pfad)
		EndIf
	EndIf



	_Mark_line($F4_Fehler_aktuelle_Zeile, _RGB_to_BGR($scripteditor_rowcolour), $Debug_log, 1)
	SendMessage($Debug_log, $SCI_ENSUREVISIBLEENFORCEPOLICY, $F4_Fehler_aktuelle_Zeile, 0)

	$line -= 1
	GoToLine($line + 1, $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	_Mark_line($line, _RGB_to_BGR($scripteditor_errorcolour), $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])




EndFunc   ;==>_trytofinderror




Func _trytocut()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_CUT, 0, 0)
	_Check_tabs_for_changes()
EndFunc   ;==>_trytocut

Func _trytocopy()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_COPY, 0, 0)
EndFunc   ;==>_trytocopy

Func _trytopaste()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_PASTE, 0, 0)
    _Check_tabs_for_changes()
EndFunc   ;==>_trytopaste

Func _trytodelete()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_CLEAR, 0, 0)
	_Check_tabs_for_changes()
EndFunc   ;==>_trytodelete


Func _open_helpfile_keyword()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then
		_runhelp()
		Return
	EndIf
	If FileExists($helpfile) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(301), 0, $studiofenster)
		Return
	EndIf
	$word = SCI_GetWordFromPos($current_Scintilla_Window, Sci_GetCurrentPos($current_Scintilla_Window))
	If $word = "" Then
		_runhelp()
		Return
	EndIf
	If StringInStr($word, "(") Then
		$word = StringTrimRight($word, StringLen($word) - StringInStr($word, "(") + 1)
	EndIf
	ShellExecute($helpfile, $word)
EndFunc   ;==>_open_helpfile_keyword

Func _comment_out()
	If $Offenes_Projekt = "" Then Return
	Local $sci = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($sci) <> "Scintilla" Then Return
	If $Starte_Auskommentierung = 1 Then Return
	$Starte_Auskommentierung = 1
	GUICtrlSetOnEvent($Minus_am_Nummernblock_Dummykey, "_comment_out_Nummernblock_Ersatzfunktion")
	$firstline = SendMessage($sci, $SCI_LINEFROMPOSITION, SendMessage($sci, $SCI_GETSELECTIONSTART, 0, 0), 0)
	$lastlineline = SendMessage($sci, $SCI_LINEFROMPOSITION, SendMessage($sci, $SCI_GETSELECTIONEND, 0, 0), 0)
	$tempvar = $firstline
	$New_Text = ""
	Sci_SetSelection($sci, Sci_GetLineStartPos($sci, $firstline), Sci_GetLineStartPos($sci, $lastlineline + 1))
	;prepare new text
	While 1
		$linePos = $tempvar
		$Text = Sci_GetLine($sci, $tempvar)
		If StringInStr($Text, ";~ ") Then
			$Text = StringReplace($Text, ";~ ", "")
		Else
			If $Text = @CRLF Then
				$Text = $Text
			Else
				$Text = ";~ " & $Text
			EndIf
		EndIf
		$New_Text = $New_Text & $Text
		$tempvar = $tempvar + 1
		If $tempvar > $lastlineline Then ExitLoop
	WEnd

	;Replace Selected Text
	Sci_ReplaceSel($sci, $New_Text)

;~
;~ 	;delete old lines
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_CLEAR, 0, 0)
;~
;~ 	;Insert new text
;~ 	Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $firstline), $New_text)
;~
	;and select it
	$lastlinelenght = Sci_GetLineLenght($sci, $lastlineline)
	Sci_SetSelection($sci, Sci_GetLineStartPos($sci, $firstline), Sci_GetLineStartPos($sci, $lastlineline) + $lastlinelenght - 1)

	;Sci_InsertText($Sci, $Pos, $Text)
	While _Pruefe_Hotkey($Hotkey_Keycode_auskommentieren)
		Sleep(50)
	WEnd

	While _IsPressed("6D", $user32)
		Sleep(50)
	WEnd


	;Taste wurde losgelassen
	GUICtrlSetOnEvent($Minus_am_Nummernblock_Dummykey, "_comment_out")
	$Starte_Auskommentierung = 0
	_Check_Buttons(0)
EndFunc   ;==>_comment_out

Func _comment_out_Nummernblock_Ersatzfunktion()
	;Hier gibt´s nichts zu sehen
EndFunc   ;==>_comment_out_Nummernblock_Ersatzfunktion

Func _SCE_EDITOR_is_Read_only($handle = "")
	If $handle = "" Then Return False
	If SendMessage($handle, $SCI_GETREADONLY, 0, 0) Then

		$ParameterEditor_GUI_State = WinGetState($ParameterEditor_GUI, "")
		If BitAND($ParameterEditor_GUI_State, 2) Then
			MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1296), "%1", WinGetTitle($ParameterEditor_GUI)), 0, $studiofenster)
			Return True
		EndIf
	EndIf


	Return False
EndFunc   ;==>_SCE_EDITOR_is_Read_only




Func _Tidy($file)
	If Not FileExists($Tidyexe) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1328), 0, $Studiofenster)
		Return
	EndIf

	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	If $Can_open_new_tab = 0 Then Return
	If _SCE_EDITOR_is_Read_only($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) Then Return
	_STOPSCRIPT() ;Wenn noch ein Skript läuft -> Stoppen!
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 1, -1)) = $Autoitextension Then
		If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_TidySource) <> -1 Then Return ;Platzhalter für Plugin
		If BitAND(_GUICtrlTab_GetItemState($htab, _GUICtrlTab_GetCurFocus($htab)), $TCIS_HIGHLIGHTED) Then _try_to_save_file(_GUICtrlTab_GetCurFocus($htab)) ;Nur Speichern wenn in der Datei auch was geändert wurde (Neu seit version 1.03)
		If $Tidy_is_running = 1 Then Return

		GUICtrlSetData($warte_auf_wrapper_GUI_text, _Get_langstr(1343))
		GUISetState(@SW_SHOW, $warte_auf_wrapper_GUI)
		GUISetState(@SW_DISABLE, $Studiofenster)

		$Console_Bluemode = 1
		$Can_open_new_tab = 0
		$Current_sci_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		_Clear_Debuglog()
		_Write_debug(_Get_langstr(424) & @CRLF & @CRLF)
		$Console_Bluemode = 0
		$Tidy_is_running = 1
		;ClipPut($Tidyexe & ' "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"')
;~ 		$Data = _RunReadStd($Tidyexe & ' "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"', 0, @ScriptDir, @SW_HIDE, 1)
		$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /Tidy /in "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"', 0, @ScriptDir, @SW_HIDE, 1)
		LoadEditorFile($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $file)

		_Write_debug(@CRLF & "-> " & _Get_langstr(249))
		_Editor_Restore_Fold()
		Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Current_sci_pos) ;Restore old Pos
		_Check_Buttons(0)
		$FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] = Sci_GetLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])

		GUISetState(@SW_ENABLE, $Studiofenster)
		GUISetState(@SW_HIDE, $warte_auf_wrapper_GUI)

		$Tidy_is_running = 0
		_run_rule($Section_Trigger4)
		Sleep(100)
		_GUICtrlTVExplorer_Expand($hTreeView, $file) ;Restore selection
		$Can_open_new_tab = 1
	EndIf
EndFunc   ;==>_Tidy



Func _ist_nach_istgleichzeichen($line = "", $string = "")
	$pos_istgleich = StringInStr($line, "=")
	If StringInStr($line, $string) > $pos_istgleich Then Return True
	Return False
EndFunc   ;==>_ist_nach_istgleichzeichen

Func _Scripttree_pruefe_element($mode = 0, $found = 0, $searchstring = "")
	;gibt false zurück wenn etwas nicht stimmt
	$txt = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found))
	$txt = StringReplace($txt, @CRLF, "")
;~ ConsoleWrite("HOLE LINE IS:'"&$txt&"' MODE IS:"&$mode&@crlf)

	If $mode <> "region" And $mode <> "include" Then
		;prüfe ob hier nach dem richtigen gesucht wird:
		Local $is_correct = 0
		Local $uList[900]
		$uList = StringSplit($txt, ",", 2)
		$uList = StringSplit(_ArrayToString($uList), "=", 2)
		$uList = StringSplit(_ArrayToString($uList), ";", 2)
		$uList = StringSplit(_ArrayToString($uList), "~", 2)
		$uList = StringSplit(_ArrayToString($uList), "(", 2)
		$uList = StringSplit(_ArrayToString($uList), ")", 2)
		$uList = StringSplit(_ArrayToString($uList), " ", 2)
		$uList = StringSplit(_ArrayToString($uList), "|", 2)
		If Not IsArray($uList) Then Return False
		For $i = 0 To UBound($uList, 1) - 1
			If $uList[$i] = $searchstring Then $is_correct = 1

		Next
		If $is_correct = 0 Then Return False
	EndIf

	If StringInStr($txt, "#cs") Then Return False
	If StringInStr($txt, "#ce") Then Return False

	If $mode = "global" Then
		If StringInStr($txt, "global") Then

			If StringInStr($txt, "=") Then
				If _ist_nach_istgleichzeichen($txt, $searchstring) = True Then
					If StringInStr($txt, "(") = 0 And StringInStr($txt, ")") = 0 And StringInStr($txt, "+") = 0 And StringInStr($txt, "-") = 0 And StringInStr($txt, "if") = 0 Then
						Return True
					Else
						Return False
					EndIf

				EndIf
			EndIf

			Return True
		EndIf
;~ 		if StringInStr($txt, " _") AND StringInStr($txt, "then") = 0 AND StringInStr($txt, "while") = 0 AND StringInStr($txt, "next") = 0 then return true
	EndIf

	If $mode = "local" Then
		If StringInStr($txt, "local") Then
			If StringInStr($txt, "=") Then
				If _ist_nach_istgleichzeichen($txt, $searchstring) = True Then
					If StringInStr($txt, "(") = 0 And StringInStr($txt, ")") = 0 And StringInStr($txt, "+") = 0 And StringInStr($txt, "-") = 0 And StringInStr($txt, "if") = 0 Then
						Return True
					Else
						Return False
					EndIf

				EndIf
			EndIf

			Return True
		EndIf
;~ 		if StringInStr($txt, " _") AND StringInStr($txt, "then") = 0 AND StringInStr($txt, "while") = 0 AND StringInStr($txt, "next") = 0 then return true
	EndIf

	If $mode = "func" Then
		If StringInStr($txt, "func") Then
			If Not StringInStr($txt, "(") Then Return False
			Return True
		EndIf
	EndIf

	If $mode = "include" Then
		If StringInStr($txt, "#include") Then Return True
	EndIf

	If $mode = "region" Then
		If StringInStr($txt, "#region") Then
			If StringInStr($txt, "#endregion") Then Return False
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>_Scripttree_pruefe_element

Func _search_from_Scripttree($string, $startpos = 0, $mode = 0)
	$wrapFind = True
	If $autoit_editor_encoding = "2" Then $string = _UNICODE2ANSI($string)


	If $startpos = 0 Then FindNext($string & Random(23043), False, False, 0, False) ;mache zufallssuche um wieder von oben zu beginnen ^^
	$loops = 0
	While 1
		$loops = $loops + 1
		If $loops > 200 Then Return -1
;~ 		ConsoleWrite("Search: "&$string&" Loop:"&$loops&@crlf)
		;suche solange bis wieder das element ohne kommentar gefunden wurde...
		$wrapFind = True
		$found = FindNext($string, False, False, 0, False)
		If $found <> -1 Then
			If _Is_Comment() = True Then ContinueLoop
			If _Scripttree_pruefe_element($mode, $found, $string) = False Then
;~ 				ConsoleWrite("-> RETURNS FALSE" & @crlf)
				ContinueLoop
			EndIf
			If _Is_Comment() = False Then ExitLoop ;win ;)
		EndIf

		If $found = -1 Then ExitLoop

	WEnd


	Return $found
EndFunc   ;==>_search_from_Scripttree

Func SCI_GetWord_ISN_Special($sci, $onlyWordCharacters = 1)

	Local $currentPos = SCI_GetCurrentPos($sci)
	Local $start = SendMessage($sci, $SCI_WORDSTARTPOSITION, $currentPos, $onlyWordCharacters)
	If Sci_GetChar($sci, $start - 1) = "#" Or Sci_GetChar($sci, $start - 1) = "@" Or Sci_GetChar($sci, $start - 1) = "$" Then
		$start = $start - 1
	EndIf

	;Local $end = SendMessage($sci, $SCI_WORDENDPOSITION, $currentPos, $onlyWordCharacters)
	Return SCI_GetTextRange($sci, $start, $currentPos)

EndFunc   ;==>SCI_GetWord_ISN_Special

Func _ConvertAnsiToUtf8($sText)
	Local $tUnicode = _WBD_WinAPI_MultiByteToWideChar($sText)
	If @error Then Return SetError(@error, 0, "")
	Local $sUtf8 = _WBD_WinAPI_WideCharToMultiByte(DllStructGetPtr($tUnicode), 65001)
	If @error Then Return SetError(@error, 0, "")
	Return SetError(0, 0, $sUtf8)
EndFunc   ;==>_ConvertAnsiToUtf8

Func _WBD_WinAPI_MultiByteToWideChar($sText, $iCodePage = 0, $iFlags = 0)
	Local $iText, $pText, $tText

	$iText = StringLen($sText) + 1
	$tText = DllStructCreate("wchar[" & $iText & "]")
	$pText = DllStructGetPtr($tText)
	DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $iCodePage, "int", $iFlags, "str", $sText, "int", $iText, "ptr", $pText, "int", $iText)
	If @error Then Return SetError(@error, 0, $tText)
	Return $tText
EndFunc   ;==>_WBD_WinAPI_MultiByteToWideChar

Func _WBD_WinAPI_WideCharToMultiByte($pUnicode, $iCodePage = 0)
	Local $aResult, $tText, $pText

	$aResult = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $iCodePage, "int", 0, "ptr", $pUnicode, "int", -1, "ptr", 0, "int", 0, "int", 0, "int", 0)
	If @error Then Return SetError(@error, 0, "")
	$tText = DllStructCreate("char[" & $aResult[0] + 1 & "]")
	$pText = DllStructGetPtr($tText)
	$aResult = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $iCodePage, "int", 0, "ptr", $pUnicode, "int", -1, "ptr", $pText, "int", $aResult[0], "int", 0, "int", 0)
	If @error Then Return SetError(@error, 0, "")
	Return DllStructGetData($tText, 1)
EndFunc   ;==>_WBD_WinAPI_WideCharToMultiByte

Func _Scripttree_DB_Klick()
	If _GUICtrlTreeView_GetSelection($hTreeview2) = 0 Then Return
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), ".", 1, -1) = 0 Then Return
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(84) Then Return ;Stoppe bei Root von Globalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(416) Then Return ;Stoppe bei Root von Lokalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(83) Then Return ;Stoppe bei Root von Funktionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(433) Then Return ;Stoppe bei Root von Regionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(324) Then Return ;Stoppe bei Root von Includes
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(323) Then Return ;Stoppe bei Root von Forms im Projekt
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(323)) Then Return ;Stoppe bei Subitems von Forms im Projekt

	$mode = 0
	$str = StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1))
	If StringInStr($str, " {") Then $str = StringTrimRight($str, StringLen($str) - StringInStr($str, " {") + 1) ;Cut Counts
	$str = StringStripWS($str, 3) ;Entferne Leerzeichen am anfang & Ende eines Elements falls vorhanden
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(83)) Then $mode = "func" ;$str = "func "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(433)) Then $mode = "region" ;$str = "#region "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(84)) Then $mode = "global"
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(416)) Then $mode = "local" ;$str = "global "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(324)) Then $mode = "include" ;$str = "global "&$str


	$Result = _Finde_Element_im_Skript($str, $mode)
	If $Result = -1 Then Return

	;markiere ganze Zeile
	$start = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result))
	$end = Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result))
	SetSelection($start, $end)

EndFunc   ;==>_Scripttree_DB_Klick



Func _Scripttree_jump_to_element($sci = "", $element = "", $mode = 0)
	If $sci = "" Then Return
	If $element = "" Then Return
	$Result = _Finde_Element_im_Skript($element, $mode)
	If $Result = -1 Then Return

	;markiere ganze Zeile
	$line = Sci_GetLineFromPos($sci, $Result)
	$start = Sci_GetLineStartPos($sci, $line)
	$end = Sci_GetLineEndPos($sci, $line)

	SendMessage($sci, $SCI_SETYCARETPOLICY, $CARET_EVEN + $CARET_STRICT, 0)
	SendMessage($sci, $SCI_SETXCARETPOLICY, $CARET_EVEN + $CARET_STRICT, 0)
	SendMessage($sci, $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0) ;
	SendMessage($sci, $SCI_GOTOLINE, $line, 0)
	SendMessage($sci, $SCI_SETYCARETPOLICY, 0, 0)
	SendMessage($sci, $SCI_SETXCARETPOLICY, 0, 0)
	SetSelection($start, $end)

EndFunc   ;==>_Scripttree_jump_to_element








Func _Find_Error_F4()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	_trytofinderror(1)
EndFunc   ;==>_Find_Error_F4


Func _kuerze_Projektname($string)
	If StringInStr($string, "\") Then
		If StringLen($string) > 33 Then
			$string = "..." & StringTrimLeft($string, StringLen($string) - 33)
		EndIf
		Return $string
	Else
		If StringLen($string) > 33 Then
			$string = StringTrimRight($string, StringLen($string) - 33) & "..."
		EndIf
		Return $string
	EndIf
EndFunc   ;==>_kuerze_Projektname

Func _Cleanup_History()
	Local $Found_entries = $Leeres_Array
	Local $Not_Found_entries = $Leeres_Array

	For $count = 1 To 7
		If FileExists(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj" & $count & "path", ""))) Then
			_ArrayAdd($Found_entries, IniRead($Configfile, "history", "pj" & $count & "path", ""))
		Else
			_ArrayAdd($Not_Found_entries, IniRead($Configfile, "history", "pj" & $count & "path", ""))
		EndIf
	Next

	_ArrayConcatenate($Found_entries, $Not_Found_entries)
	For $x = 0 To UBound($Found_entries) - 1
		IniWrite($Configfile, "history", "pj" & ($x + 1) & "path", $Found_entries[$x])
	Next
EndFunc   ;==>_Cleanup_History


Func _Read_Last_4_Projects()
	_Cleanup_History()
	Local $name

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj1path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj1path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_1[1], _kuerze_Projektname($name))
	$History_Projekte_Array[0] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj1path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj2path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj2path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_2[1], _kuerze_Projektname($name))
	$History_Projekte_Array[1] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj2path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj3path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj3path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_3[1], _kuerze_Projektname($name))
	$History_Projekte_Array[2] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj3path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj4path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj4path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_4[1], _kuerze_Projektname($name))
	$History_Projekte_Array[3] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj4path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj5path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj5path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_5[1], _kuerze_Projektname($name))
	$History_Projekte_Array[4] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj5path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj6path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj6path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_6[1], _kuerze_Projektname($name))
	$History_Projekte_Array[5] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj6path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj7path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj7path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_7[1], _kuerze_Projektname($name))
	$History_Projekte_Array[6] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj7path", ""))

	If GUICtrlRead($last_item_1[1]) = "" Then
		GUICtrlSetState($last_item_1[0], $GUI_HIDE)
		GUICtrlSetState($last_item_1[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_1[0], $GUI_SHOW)
		GUICtrlSetState($last_item_1[1], $GUI_SHOW)
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[0], GUICtrlGetHandle($last_item_1[0]))
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[0], GUICtrlGetHandle($last_item_1[1]))
	EndIf

	If GUICtrlRead($last_item_2[1]) = "" Then
		GUICtrlSetState($last_item_2[0], $GUI_HIDE)
		GUICtrlSetState($last_item_2[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_2[0], $GUI_SHOW)
		GUICtrlSetState($last_item_2[1], $GUI_SHOW)
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[1], GUICtrlGetHandle($last_item_2[0]))
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[1], GUICtrlGetHandle($last_item_2[1]))
	EndIf

	If GUICtrlRead($last_item_3[1]) = "" Then
		GUICtrlSetState($last_item_3[0], $GUI_HIDE)
		GUICtrlSetState($last_item_3[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_3[0], $GUI_SHOW)
		GUICtrlSetState($last_item_3[1], $GUI_SHOW)
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[2], GUICtrlGetHandle($last_item_3[0]))
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[2], GUICtrlGetHandle($last_item_3[1]))
	EndIf

	If GUICtrlRead($last_item_4[1]) = "" Then
		GUICtrlSetState($last_item_4[0], $GUI_HIDE)
		GUICtrlSetState($last_item_4[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_4[0], $GUI_SHOW)
		GUICtrlSetState($last_item_4[1], $GUI_SHOW)
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[3], GUICtrlGetHandle($last_item_4[0]))
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[3], GUICtrlGetHandle($last_item_4[1]))
	EndIf

	If GUICtrlRead($last_item_5[1]) = "" Then
		GUICtrlSetState($last_item_5[0], $GUI_HIDE)
		GUICtrlSetState($last_item_5[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_5[0], $GUI_SHOW)
		GUICtrlSetState($last_item_5[1], $GUI_SHOW)
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[4], GUICtrlGetHandle($last_item_5[0]))
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[4], GUICtrlGetHandle($last_item_5[1]))
	EndIf

	If GUICtrlRead($last_item_6[1]) = "" Then
		GUICtrlSetState($last_item_6[0], $GUI_HIDE)
		GUICtrlSetState($last_item_6[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_6[0], $GUI_SHOW)
		GUICtrlSetState($last_item_6[1], $GUI_SHOW)
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[5], GUICtrlGetHandle($last_item_6[0]))
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[5], GUICtrlGetHandle($last_item_6[1]))
	EndIf

	If GUICtrlRead($last_item_7[1]) = "" Then
		GUICtrlSetState($last_item_7[0], $GUI_HIDE)
		GUICtrlSetState($last_item_7[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_7[0], $GUI_SHOW)
		GUICtrlSetState($last_item_7[1], $GUI_SHOW)
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[6], GUICtrlGetHandle($last_item_7[0]))
		_GUIToolTip_AddTool($hToolTip_Welcome_GUI, 0, $History_Projekte_Array[6], GUICtrlGetHandle($last_item_7[1]))
	EndIf
EndFunc   ;==>_Read_Last_4_Projects

Func _Hit_Lastproject_1()
	If $History_Projekte_Array[0] = "" Then Return
	If _IsDir($History_Projekte_Array[0]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[0])
	Else
		If FileExists($History_Projekte_Array[0]) Then _oeffne_Editormodus($History_Projekte_Array[0])
	EndIf
EndFunc   ;==>_Hit_Lastproject_1

Func _Hit_Lastproject_2()
	If $History_Projekte_Array[1] = "" Then Return
	If _IsDir($History_Projekte_Array[1]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[1])
	Else
		If FileExists($History_Projekte_Array[1]) Then _oeffne_Editormodus($History_Projekte_Array[1])
	EndIf
EndFunc   ;==>_Hit_Lastproject_2

Func _Hit_Lastproject_3()
	If $History_Projekte_Array[2] = "" Then Return
	If _IsDir($History_Projekte_Array[2]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[2])
	Else
		If FileExists($History_Projekte_Array[2]) Then _oeffne_Editormodus($History_Projekte_Array[2])
	EndIf
EndFunc   ;==>_Hit_Lastproject_3

Func _Hit_Lastproject_4()
	If $History_Projekte_Array[3] = "" Then Return
	If _IsDir($History_Projekte_Array[3]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[3])
	Else
		If FileExists($History_Projekte_Array[3]) Then _oeffne_Editormodus($History_Projekte_Array[3])
	EndIf
EndFunc   ;==>_Hit_Lastproject_4

Func _Hit_Lastproject_5()
	If $History_Projekte_Array[4] = "" Then Return
	If _IsDir($History_Projekte_Array[4]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[4])
	Else
		If FileExists($History_Projekte_Array[4]) Then _oeffne_Editormodus($History_Projekte_Array[4])
	EndIf
EndFunc   ;==>_Hit_Lastproject_5

Func _Hit_Lastproject_6()
	If $History_Projekte_Array[5] = "" Then Return
	If _IsDir($History_Projekte_Array[5]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[5])
	Else
		If FileExists($History_Projekte_Array[5]) Then _oeffne_Editormodus($History_Projekte_Array[5])
	EndIf
EndFunc   ;==>_Hit_Lastproject_6

Func _Hit_Lastproject_7()
	If $History_Projekte_Array[6] = "" Then Return
	If _IsDir($History_Projekte_Array[6]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[6])
	Else
		If FileExists($History_Projekte_Array[6]) Then _oeffne_Editormodus($History_Projekte_Array[6])
	EndIf
EndFunc   ;==>_Hit_Lastproject_7

; #FUNCTION# ;===============================================================================
;
; Name...........: _fuege_in_History_ein
; Description ...: Fügt einen Dateipfad in eine Liste zuletzt verwendeter Elemente
; Syntax.........: _fuege_in_History_ein($History_Array,$Pfad="")
; Parameters ....: $History_Array			- Das Array indem die Elemente zufinden sind
;                  $Pfad					- Pfad der Eingefügt werden soll
; Return values .: Das Array indem die Elemente zufinden sind
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird für die zuletzt verwendeten Elemente am Startscreen verwendet
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
;
; ;==========================================================================================

Func _fuege_in_History_ein($History_Array, $Pfad = "")
	If $Pfad = "" Then Return
	If Not IsArray($History_Array) Then Return
	$Pfad = FileGetLongName($Pfad)
	;prüfe ob Eintrag schon in der Liste ist
	If _ArraySearch($History_Array, $Pfad) = -1 Then
		;noch nicht in der Liste

		;Rücke alle Einträge 1 nach unten
		For $x = UBound($History_Array) - 1 To 1 Step -1
			$History_Array[$x] = $History_Array[$x - 1]
		Next
		;Füge neues Element ein
		$History_Array[0] = $Pfad

	Else
		;bereits in der Liste

		;Lösche das Element aus der Liste...
		_ArrayDelete($History_Array, _ArraySearch($History_Array, $Pfad))
		_ArrayAdd($History_Array, "")
		;..und füge es neu ein:
		$History_Array = _fuege_in_History_ein($History_Array, $Pfad)
	EndIf

	;Schreibe das Array in die Config
	For $x = 0 To UBound($History_Array) - 1
		IniWrite($Configfile, "history", "pj" & $x + 1 & "path", _ISN_Pfad_durch_Variablen_ersetzen($History_Array[$x], 1))
	Next
	Return $History_Array
EndFunc   ;==>_fuege_in_History_ein

Func _Open_External_Project()
	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(507), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(193) & " (*.isn)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $Welcome_GUI)
	Else
		$var = FileOpenDialog(_Get_langstr(507), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(193) & " (*.isn)", 1 + 2, "", $Welcome_GUI)
	EndIf
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	$var = StringTrimRight($var, StringLen($var) - StringInStr($var, "\", 0, -1) + 1)
	_Load_Project_by_Foldername($var)
EndFunc   ;==>_Open_External_Project

Func _Load_Project_by_Foldername($path)
	If $path = "" Then Return

	If _Pruefe_auf_mehrere_Projektdateien($path) = True Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1104), 0, $Welcome_GUI)
		Return
	EndIf

	If Not FileExists(_Finde_Projektdatei($path)) Then
		GUISetState(@SW_SHOW, $Welcome_GUI)
		Return
	EndIf

	$Pfad_zur_Project_ISN = _Finde_Projektdatei($path)
	$PID_Read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", "")
	$name = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "")
	If ProcessExists($PID_Read) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(331), 0, $Welcome_GUI)
		If $Offenes_Projekt = "" Then GUISetState(@SW_SHOW, $Welcome_GUI)
		Return
	EndIf

	If Not FileExists($path) Then
		MsgBox(262144 + 16, _Get_langstr(25), $path & " " & _Get_langstr(332), 0, $Welcome_GUI)
		Return
	EndIf

	_show_Loading(_Get_langstr(34), _Get_langstr(23))

	GUISetState(@SW_HIDE, $Welcome_GUI)
	GUISetState(@SW_HIDE, $projectmanager)

	_Write_log(_Get_langstr(34) & "(" & $name & ")", "000000", "true", "true")
	GUISetState(@SW_LOCK, $studiofenster)
	GUICtrlSetState($HD_Logo, $GUI_HIDE)

	_Loading_Progress(90)
	$Studiomodus = 1

	_Load_Project($path)
	_Check_tabs_for_changes()

	;_Write_in_Config("lastproject",$name)
	If $Templatemode = 0 And $Tempmode = 0 Then _Write_in_Config("lastproject", _ISN_Pfad_durch_Variablen_ersetzen($path, 1))
	If $Templatemode = 0 And $Tempmode = 0 Then $History_Projekte_Array = _fuege_in_History_ein($History_Projekte_Array, $path)
	If $Templatemode = 0 And $Tempmode = 0 Then _Start_Project_timer()

	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", @AutoItPID)
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "lastopendate", @MDAY & "." & @MON & "." & @YEAR & " " & @HOUR & ":" & @MIN)
	If $Templatemode = 0 And $Tempmode = 0 Then
		If $enablebackup = "true" Then
			AdlibUnRegister("_Backup_Files")
			AdlibRegister("_Backup_Files", $backuptime * 60000)
		Else
			AdlibUnRegister("_Backup_Files")
		EndIf
	EndIf

	If $Automatische_Speicherung_Modus = "1" Then
		AdlibUnRegister("_ISN_Automatische_Speicherung_starten")
		AdlibRegister("_ISN_Automatische_Speicherung_starten", _TimeToTicks($Automatische_Speicherung_Timer_Stunden, $Automatische_Speicherung_Timer_Minuten, $Automatische_Speicherung_Timer_Sekunden))
	Else
		AdlibUnRegister("_ISN_Automatische_Speicherung_Sekundenevent")
		AdlibRegister("_ISN_Automatische_Speicherung_Sekundenevent", 1000)
	EndIf

	_Write_ISN_Debug_Console("Project loaded (" & $Offenes_Projekt_name & ") from " & $Offenes_Projekt, 1)
	_Loading_Progress(100)
	_Check_Buttons(0)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_UNLOCK, $studiofenster)

	If $lade_zuletzt_geoeffnete_Dateien = "true" Then _Oeffne_alte_Tabs(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened_tabs", ""))
	If $autoloadmainfile = "true" Then Try_to_opten_file($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"))

	_Hide_Loading()
	_run_rule($Section_Trigger1)
	_QuickView_Tab_Event()
EndFunc   ;==>_Load_Project_by_Foldername





Func _Toggle_hide_leftbar()
	If $Offenes_Projekt = "" Then Return
	$Pos_VSplitter_1 = ControlGetPos($StudioFenster, "", $Left_Splitter_X)
	$winpos = WinGetClientSize($studiofenster)
	If $Toggle_Leftside = 0 Then
		$Toggle_Leftside = 1
		If $ISN_Use_Vertical_Toolbar = "true" Then
			GUICtrlSetPos($Left_Splitter_X, ($Toolbar_Size[0] + 18 + $Splitter_Breite) * $DPI, Default, $Splitter_Breite)
		Else
			GUICtrlSetPos($Left_Splitter_X, 18 * $DPI, Default, $Splitter_Breite)
		EndIf


		GUICtrlSetState($Left_Splitter_X, $GUI_HIDE)
		GUISetState(@SW_HIDE, $QuickView_GUI)
		GUICtrlSetState($hTreeview, $GUI_DISABLE)
		GUICtrlSetState($hTreeview, $GUI_HIDE)
		GUICtrlSetState($Left_Splitter_Y, $GUI_HIDE)
		GUICtrlSetState($QuickView_title, $GUI_HIDE)
		$tmp = _Get_langstr(468)
		$vertical_string = ""
		$tmp2 = StringLen($tmp)
		For $r = 1 To $tmp2
			$vertical_string = $vertical_string & StringLeft($tmp, 1) & @CRLF
			$tmp = StringTrimLeft($tmp, 1)
		Next

		GUICtrlSetData($Projecttree_title, $vertical_string)
		If $ISN_Use_Vertical_Toolbar = "true" Then
			GUICtrlSetPos($Projecttree_title, $Toolbar_Size[0] + $Splitter_Breite + $Splitter_Breite, $Splitter_Breite, 20 * $DPI, 150 * $DPI)
		Else
			GUICtrlSetPos($Projecttree_title, 3, $Toolbar_Size[0] + 3, 20 * $DPI, 150 * $DPI)
		EndIf
		GUICtrlSetColor($Projecttree_title, $Skriptbaum_Header_Schriftfarbe)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind

	Else
		$Toggle_Leftside = 0
		GUICtrlSetPos($Left_Splitter_X, ($winpos[0] / 100) * Number(_Config_Read("Left_Splitter_X", $Linker_Splitter_X_default)), $Pos_VSplitter_1[1], $Splitter_Breite)
		GUICtrlSetState($Left_Splitter_X, $GUI_SHOW)
		GUICtrlSetState($hTreeview, $GUI_ENABLE)
		GUICtrlSetState($hTreeview, $GUI_SHOW)
		If $hideprogramlog = "false" Then
			GUISetState(@SW_SHOWNOACTIVATE, $QuickView_GUI)
			GUICtrlSetState($Left_Splitter_Y, $GUI_SHOW)
			GUICtrlSetState($QuickView_title, $GUI_SHOW)
		EndIf
		GUICtrlSetData($Projecttree_title, " " & _Get_langstr(468))
		GUICtrlSetColor($Projecttree_title, $Skriptbaum_Header_Schriftfarbe)
		GUICtrlSetPos($Projecttree_title, 2, 30, 300 * $DPI, 19 * $DPI)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	EndIf
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then Return

;~ 	$tabsize = ControlGetPos($StudioFenster, "", $htab)

;~ 	$htab_wingetpos_array = WinGetPos(GUICtrlGetHandle($htab))
;~ 	$y = $htab_wingetpos_array[1] + $Tabseite_hoehe
;~ 	$x = $htab_wingetpos_array[0] + 4

	;resize Plugin correctly
	If $ISN_Tabs_Additional_Infos_Array[_GUICtrlTab_GetCurFocus($htab)][1] <> "1" Then
;~ 		$tabsize = ControlGetPos($StudioFenster, "", $htab)
;~ 		WinMove($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "", $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4)
;~ 		$plugsize = WinGetPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
;~ 		WinMove($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", 0, 0, $plugsize[2], $plugsize[3])
		_ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "resize") ;Resize an Plugin senden
	EndIf




	;end
	_Resize_Elements_to_Window()
	_QuickView_GUI_Resize()

EndFunc   ;==>_Toggle_hide_leftbar

Func _Toggle_hide_rightbar()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$ext = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 1, -1))
	If $ext <> $Autoitextension Then Return
	$Pos_VSplitter_2 = ControlGetPos($StudioFenster, "", $Right_Splitter_X)
	$winpos = WinGetClientSize($studiofenster)
	If $Toggle_rightside = 0 Then
		$Toggle_rightside = 1

		GUICtrlSetPos($Right_Splitter_X, 18, Default)


		GUICtrlSetState($hTreeview2, $GUI_DISABLE)
		GUICtrlSetState($hTreeview2, $GUI_HIDE)
		GUICtrlSetState($Right_Splitter_X, $GUI_HIDE)
		GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_HIDE)
		GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_HIDE)
		GUICtrlSetState($hTreeview2_searchinput, $GUI_HIDE)
		GUICtrlSetPos($Right_Splitter_X, $winpos[0] - (30 * $DPI), $Pos_VSplitter_2[1])
		$tmp = _Get_langstr(469)
		$vertical_string = ""
		$tmp2 = StringLen($tmp)
		For $r = 1 To $tmp2
			$vertical_string = $vertical_string & StringLeft($tmp, 1) & @CRLF
			$tmp = StringTrimLeft($tmp, 1)
		Next
		GUICtrlSetData($Scripttree_title, $vertical_string)
		If $ISN_Use_Vertical_Toolbar = "true" Then
			GUICtrlSetPos($Scripttree_title, $winpos[0] - (28 * $DPI), $Splitter_Breite, 20 * $DPI, 150 * $DPI)
		Else
			GUICtrlSetPos($Scripttree_title, $winpos[0] - (28 * $DPI), $Toolbar_Size[0] + 3, 20 * $DPI, 150 * $DPI)
		EndIf
		GUICtrlSetColor($Scripttree_title, $Skriptbaum_Header_Schriftfarbe)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	Else

		$Toggle_rightside = 0
		GUICtrlSetState($Right_Splitter_X, $GUI_SHOW)
		GUICtrlSetState($hTreeview2, $GUI_ENABLE)
		GUICtrlSetState($hTreeview2, $GUI_SHOW)
;~ 		GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_SHOW)
;~ 		GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_SHOW)
		GUICtrlSetState($hTreeview2_searchinput, $GUI_SHOW)
		GUICtrlSetData($Scripttree_title, " " & _Get_langstr(469))
		GUICtrlSetColor($Scripttree_title, $Skriptbaum_Header_Schriftfarbe)
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		GUICtrlSetPos($Right_Splitter_X, ($winpos[0] / 100) * Number(_Config_Read("Right_Splitter_X", $Rechter_Splitter_X_default)), $Pos_VSplitter_2[1], $Splitter_Breite)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	EndIf
	_Resize_Elements_to_Window()
EndFunc   ;==>_Toggle_hide_rightbar

Func _Editor_Save_Fold()
	If $savefolding = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$section = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 1, -1))
	IniDelete($foldingfile, $section) ;renew
	For $count = 0 To Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETFOLDEXPANDED, $count, 0) = 0 Then
			IniWrite($foldingfile, $section, $count + 1, StringReplace(StringReplace(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $count), @CRLF, ""), @TAB, ""))
		EndIf
	Next
EndFunc   ;==>_Editor_Save_Fold

Func _Editor_Restore_Fold()
	If $savefolding = "false" Then Return
	If Not FileExists($foldingfile) Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$section = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 1, -1))
	$readen_keys = IniReadSection($foldingfile, $section)
	If @error = 1 Then Return ;no folding for this file
	;count for every line...
	For $count = UBound($readen_keys) - 1 To 1 Step -1
		If $readen_keys[$count][1] = StringReplace(StringReplace(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $readen_keys[$count][0] - 1), @CRLF, ""), @TAB, "") Then
			GoToLine($readen_keys[$count][0])
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_TOGGLEFOLD, $readen_keys[$count][0] - 1, 1)
		EndIf
	Next
	GoToLine(1)
EndFunc   ;==>_Editor_Restore_Fold

Func _Try_to_open_include_hotkey()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If $Offenes_Projekt = "" Then Return
	$str = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	_Try_to_open_include($str)
EndFunc   ;==>_Try_to_open_include_hotkey

Func _Try_to_open_include_Adlib($linestring = "")
	$Try_to_open_include_Adlib_tmp = $linestring
	AdlibRegister("_Try_to_open_include_Adlib2")
EndFunc   ;==>_Try_to_open_include_Adlib

Func _Try_to_open_include_Adlib2()
	AdlibUnRegister("_Try_to_open_include_Adlib2")
	_Try_to_open_include($Try_to_open_include_Adlib_tmp)
EndFunc   ;==>_Try_to_open_include_Adlib2

Func _Try_to_open_include($linestring = "")
	If $linestring = "" Then Return

;~ 	if stringinstr($linestring, "#include") then
	;Include
	$linestring = StringStripWS($linestring, 3)
	If StringInStr($linestring, ".") Then
		$file = $linestring
		If StringInStr($file, "<") Then $file = StringTrimLeft($file, StringInStr($file, "<"))
		If StringInStr($file, '"') Then $file = StringTrimLeft($file, StringInStr($file, '"'))
		If StringInStr($file, "'") Then $file = StringTrimLeft($file, StringInStr($file, "'"))

		If StringInStr($file, ">") Then $file = StringTrimRight($file, StringLen($file) - (StringInStr($file, ">") - 1))
		If StringInStr($file, '"') Then $file = StringTrimRight($file, StringLen($file) - (StringInStr($file, '"') - 1))
		If StringInStr($file, "'") Then $file = StringTrimRight($file, StringLen($file) - (StringInStr($file, "'") - 1))
		$file = StringStripWS($file, 3)


		;Prüfe ob Datei im Projekt exestiert
		If FileExists($Offenes_Projekt & "\" & $file) Then
			Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
			Try_to_opten_file($Offenes_Projekt & "\" & $file)
			Return
		EndIf

		;Prüfe ob Datei in den AutoIt Includes exestiert
		If FileExists($autoitexe) Then
			$tmp = $autoitexe
			$tmp = StringTrimRight($tmp, StringLen($tmp) - StringInStr($tmp, "\", 0, -1))
			$path = FileGetShortName($tmp) & "Include\" & $file
			If FileExists($path) Then
				Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
				Try_to_opten_file($path)
				Return
			EndIf
		EndIf


		;Prüfe ob die Datei in den Benutzerdefinierten Includepfaden existiert
		$Pfade = _Config_Read("additional_includes_paths", "")
		$Pfade_Array = StringSplit($Pfade, "|", 2)
		If IsArray($Pfade_Array) Then
			For $x = 0 To UBound($Pfade_Array) - 1
				$Pfad = _ISN_Variablen_aufloesen($Pfade_Array[$x])
				If FileExists(FileGetShortName($Pfad) & "\" & $file) Then
					Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
					Try_to_opten_file($Pfad & "\" & $file)
					Return
				EndIf
			Next
		EndIf








		;Prüfe ob die Datei selbst existiert
		If FileExists($file) Then
			Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
			Try_to_opten_file($file)
			Return
		EndIf



		Return ;or crash
	EndIf
;~ 	Else
	;Datei
;~ 	$array = _StringBetween($linestring, '"', '"', -1)
;~ 	for $u = 0 to ubound($array)-1
;~ 		if FileExists($array[$u]) then
;~ 			Try_to_opten_file($array[$u])
;~ 			return ;open only 1 FileChangeDir
;~ 		endif
;~ 	next

;~ 	$array = _StringBetween($linestring, "'", "'", -1)
;~ 	for $u = 0 to ubound($array)-1
;~ 		if FileExists($array[$u]) then
;~ 			Try_to_opten_file($array[$u])
;~ 			return ;open only 1 FileChangeDir
;~ 		endif
;~ 	next
;~
;~ 	endif
EndFunc   ;==>_Try_to_open_include

; #FUNCTION# ;===============================================================================
; Name...........: _Debug_to_msgbox
; Description ...: Erstellt eine MsgBox im Script mit dem Ergebniss der gewählten Zeile (wie in SCiTE4AutoIt)
; Syntax.........: _Debug_to_msgbox()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: In der gewählten Zeile muss Text vorhanden sein!
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
; ;==========================================================================================

Func _Debug_to_msgbox()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	Local $Fertiger_String = ""
	Local $Text_der_Zeile = ""
	Local $word = ""
	Local $Ist_nach_istgleich = "none"
	$Aktuelle_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	$Pos_Istgleich_zeichen = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1) + (StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1), "="))

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(726), 0, $studiofenster)
		Return
	EndIf

	;Analyse...
	If $Aktuelle_pos > $Pos_Istgleich_zeichen - 1 Then
		$Ist_nach_istgleich = "true"
	Else
		$Ist_nach_istgleich = "false"
	EndIf
	If Not StringInStr($Text_der_Zeile, "=") Then $Ist_nach_istgleich = "none"

	$Text_der_Zeile = StringReplace($Text_der_Zeile, @CRLF, "") ;Lösche Zeilenumbrüche
	If StringInStr($Text_der_Zeile, ";") Then $Text_der_Zeile = StringTrimRight($Text_der_Zeile, StringLen($Text_der_Zeile) - StringInStr($Text_der_Zeile, ";", -1) + 1) ;Lösche Kommentare

	If $Ist_nach_istgleich = "false" Then
		$word = SCI_GetWordFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]))
		If $word = "" Then
			Return
		EndIf
		If StringInStr($word, "(") Then
			$word = StringTrimRight($word, StringLen($word) - StringInStr($word, "(") + 1)
		EndIf
		;Letzte Prüfung
		If StringInStr($Text_der_Zeile, "$" & $word) Then $word = "$" & $word
		$Text_der_Zeile = $word
	EndIf

	If $Ist_nach_istgleich = "true" Then
		$Text_der_Zeile = StringTrimLeft($Text_der_Zeile, StringInStr($Text_der_Zeile, "=", -1) + 1)
	EndIf

	;Makierung
	$Result = Sci_GetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If IsArray($Result) Then
		If $Result[0] <> $Result[1] Then $Text_der_Zeile = SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result[0], $Result[1])
	EndIf

	$Text_der_Zeile = StringStripWS($Text_der_Zeile, 3)
	$Fertiger_String = "MsgBox(262144,'Debug line ~' & @ScriptLineNumber,'Selection:' & @lf & '" & $Text_der_Zeile & "' & @lf & @lf & 'Return:' & @lf &" & $Text_der_Zeile & ") ;### Debug MSGBOX" & @CRLF
	;Sende Text in den Editor
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertiger_String, Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) + 1)
	_Check_Buttons(0)
EndFunc   ;==>_Debug_to_msgbox

; #FUNCTION# ;===============================================================================
; Name...........: _Debug_to_console
; Description ...: Erstellt einen ConsoleWrite Befehl im Script mit dem Ergebniss der gewählten Zeile (wie in SCiTE4AutoIt)
; Syntax.........: _Debug_to_console()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: In der gewählten Zeile muss Text vorhanden sein!
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
; ;==========================================================================================

Func _Debug_to_console()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	Local $Fertiger_String = ""
	Local $Text_der_Zeile = ""
	Local $word = ""
	Local $Ist_nach_istgleich = "none"
	$Aktuelle_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	$Pos_Istgleich_zeichen = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1) + (StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1), "="))

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(726), 0, $studiofenster)
		Return
	EndIf

	;Analyse...
	If $Aktuelle_pos > $Pos_Istgleich_zeichen - 1 Then
		$Ist_nach_istgleich = "true"
	Else
		$Ist_nach_istgleich = "false"
	EndIf
	If Not StringInStr($Text_der_Zeile, "=") Then $Ist_nach_istgleich = "none"

	$Text_der_Zeile = StringReplace($Text_der_Zeile, @CRLF, "") ;Lösche Zeilenumbrüche
	If StringInStr($Text_der_Zeile, ";") Then $Text_der_Zeile = StringTrimRight($Text_der_Zeile, StringLen($Text_der_Zeile) - StringInStr($Text_der_Zeile, ";", -1) + 1) ;Lösche Kommentare

	If $Ist_nach_istgleich = "false" Then
		$word = SCI_GetWordFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]))
		If $word = "" Then
			Return
		EndIf
		If StringInStr($word, "(") Then
			$word = StringTrimRight($word, StringLen($word) - StringInStr($word, "(") + 1)
		EndIf
		;Letzte Prüfung
		If StringInStr($Text_der_Zeile, "$" & $word) Then $word = "$" & $word
		$Text_der_Zeile = $word
	EndIf

	If $Ist_nach_istgleich = "true" Then
		$Text_der_Zeile = StringTrimLeft($Text_der_Zeile, StringInStr($Text_der_Zeile, "=", -1) + 1)
	EndIf

	;Makierung
	$Result = Sci_GetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If IsArray($Result) Then
		If $Result[0] <> $Result[1] Then $Text_der_Zeile = SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result[0], $Result[1])
	EndIf

	$Text_der_Zeile = StringStripWS($Text_der_Zeile, 3)

	$Fertiger_String = "ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : " & $Text_der_Zeile & " = ' & " & $Text_der_Zeile & " & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console" & @CRLF

	;Sende Text in den Editor
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertiger_String, Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) + 1)
	_Check_Buttons(0)
EndFunc   ;==>_Debug_to_console

Func _check_if_file_was_modified_external()
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
	If $protect_files_from_external_modification = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) < 1 Then Return
	If $Tabs_closing = 1 Then Return
	If $Offenes_Projekt = "" Then Return
	$ext = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 1, -1))
	If $ext = $Autoitextension Or $ext = "isn" Or $ext = "ini" Or $ext = "txt" Then
		Local $hFile = FileOpen($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], $FO_READ + FileGetEncoding($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)]))
		Local $new = FileRead($hFile, FileGetSize($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)]))
		FileClose($hFile)
		If $FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] = "" Then Return
		If $new = "" Then Return

		$lokaler_cache = $FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)]
		If Not _System_benoetigt_double_byte_character_Support() Then $lokaler_cache = _ANSI2UNICODE($lokaler_cache)

		If $lokaler_cache <> $new Then ;oje, do hods wos..
			$str = _Get_langstr(548)
			$str = StringReplace($str, "%filename%", StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 0, -1)))
			$answer = MsgBox(262144 + 48 + 4, _Get_langstr(394), $str, 0, $Studiofenster)
			If $answer = 6 Then
				LoadEditorFile($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)])
				$FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] = Sci_GetLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
				_Show_Tab(_GUICtrlTab_GetCurFocus($htab))
			EndIf
			If $answer = 7 Then
				_try_to_save_file(_GUICtrlTab_GetCurFocus($htab), 0)
			EndIf

		EndIf
	EndIf
EndFunc   ;==>_check_if_file_was_modified_external

Func _FileReadToArray2($sFilePath, ByRef $aArray)
	Local $hFile = FileOpen($sFilePath, $FO_READ + FileGetEncoding($sFilePath))
	If $hFile = -1 Then Return SetError(1, 0, 0) ;; unable to open the file
	;; Read the file and remove any trailing white spaces
	Local $aFile = FileRead($hFile, FileGetSize($sFilePath))
;~ 	$aFile = StringStripWS($aFile, 2)
	; remove last line separator if any at the end of the file
;~ 	If StringRight($aFile, 1) = @LF Then $aFile = StringTrimRight($aFile, 1)
;~ 	If StringRight($aFile, 1) = @CR Then $aFile = StringTrimRight($aFile, 1)
	FileClose($hFile)
	If StringInStr($aFile, @LF) Then
		$aArray = StringSplit(StringStripCR($aFile), @LF)
	ElseIf StringInStr($aFile, @CR) Then ;; @LF does not exist so split on the @CR
		$aArray = StringSplit($aFile, @CR)
	Else ;; unable to split the file
		If StringLen($aFile) Then
			Dim $aArray[2] = [1, $aFile]
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_FileReadToArray2

Func _SCI_Toggle_fold()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	For $count = 0 To Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1
		If BitAND(SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETFOLDLEVEL, $count, 0), $SC_FOLDLEVELHEADERFLAG) Then
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_TOGGLEFOLD, $count, 1)
		EndIf
	Next
EndFunc   ;==>_SCI_Toggle_fold

Func _Scintilla_Fold_Expand_all()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	SendMessage($Last_Used_Scintilla_Control, $SCI_FOLDALL, $SC_FOLDACTION_EXPAND, 0)
EndFunc   ;==>_Scintilla_Fold_Expand_all

Func _Scintilla_Fold_Contract_all()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	SendMessage($Last_Used_Scintilla_Control, $SCI_FOLDALL, $SC_FOLDACTION_CONTRACT, 0)
EndFunc   ;==>_Scintilla_Fold_Contract_all

Func _Scintilla_Fold_Contract_all_Regions()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	For $count = 0 To Sci_GetLineCount($Last_Used_Scintilla_Control) - 1
		If StringInStr(Sci_GetLine($Last_Used_Scintilla_Control, $count), "#region ") Then
			SendMessage($Last_Used_Scintilla_Control, $SCI_FOLDLINE, $count, $SC_FOLDACTION_CONTRACT)
		EndIf
	Next
EndFunc   ;==>_Scintilla_Fold_Contract_all_Regions

Func _Scintilla_Fold_Expand_all_Regions()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	For $count = 0 To Sci_GetLineCount($Last_Used_Scintilla_Control) - 1
		If StringInStr(Sci_GetLine($Last_Used_Scintilla_Control, $count), "#region ") Then
			SendMessage($Last_Used_Scintilla_Control, $SCI_FOLDLINE, $count, $SC_FOLDACTION_EXPAND)
		EndIf
	Next
EndFunc   ;==>_Scintilla_Fold_Expand_all_Regions

Func _Save_All_only_script_tabs()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	GUISetCursor(1, 0, $Studiofenster)
	$Rebuild_Tree = 0
	$Can_open_new_tab = 0
	For $x = 0 To $Offene_tabs - 1
		If $Plugin_Handle[$x] = -1 Then
			$Rebuild_Tree = 0
			If $x = _GUICtrlTab_GetCurFocus($htab) Then $Rebuild_Tree = 1
			$ext = StringTrimLeft($Datei_pfad[$x], StringInStr($Datei_pfad[$x], ".", 1, -1))
			If $ext = $Autoitextension Then
				If Not BitAND(_GUICtrlTab_GetItemState($htab, $x), $TCIS_HIGHLIGHTED) Then ContinueLoop ;Nur Speichern wenn in der Datei auch was geändert wurde (Neu seit version 1.03)
				Save_File($x, $Rebuild_Tree) ;Nur bei au3 Datien Speichern
				_Remove_Marks($SCE_EDITOR[$x])
			EndIf
		Else
			;Plugin
		EndIf
	Next
	_Remove_Marks($Debug_log)
	_run_rule($Section_Trigger3)
	GUISetCursor(2, 0, $Studiofenster)
	$Can_open_new_tab = 1
EndFunc   ;==>_Save_All_only_script_tabs


Func _Save_All_tabs($Nur_Skript_Tabs_Speichern = 0, $Allow_Rebuild_Tree = 1)
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_DISABLE) Then GUICtrlSetState($FileMenu_item1, $GUI_DISABLE)
	If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_DISABLE) Then GUICtrlSetState($FileMenu_item1b, $GUI_DISABLE)
	If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, _GUICtrlToolbar_GetButtonState($hToolbar, $id29) - $TBSTATE_ENABLED)
	If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, _GUICtrlToolbar_GetButtonState($hToolbar, $id10) - $TBSTATE_ENABLED)


	GUISetCursor(1, 0, $Studiofenster)
	$Rebuild_Tree = 0
	$Can_open_new_tab = 0
	For $x = 0 To $Offene_tabs - 1
		If $Plugin_Handle[$x] = -1 Then
			$Rebuild_Tree = 0
			If $x = _GUICtrlTab_GetCurFocus($htab) And $Allow_Rebuild_Tree = 1 Then $Rebuild_Tree = 1
			Save_File($x, $Rebuild_Tree) ;script
			_Remove_Marks($SCE_EDITOR[$x])
		Else
			If $Nur_Skript_Tabs_Speichern = 1 Then ContinueLoop
			_ISN_Send_Message_to_Plugin($Plugin_Handle[$x], "save") ;plugin
			_Write_log(StringTrimLeft($Datei_pfad[$x], StringInStr($Datei_pfad[$x], "\", 0, -1)) & " " & _Get_langstr(691), "209B25")
		EndIf
	Next
	_Remove_Marks($Debug_log)
	_run_rule($Section_Trigger3)
	GUISetCursor(2, 0, $Studiofenster)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_ENABLE) Then GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_ENABLE) Then GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, _GUICtrlToolbar_GetButtonState($hToolbar, $id29) + $TBSTATE_ENABLED)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, _GUICtrlToolbar_GetButtonState($hToolbar, $id10) + $TBSTATE_ENABLED)
	EndIf
	$Can_open_new_tab = 1
EndFunc   ;==>_Save_All_tabs

Func _Zeile_Duplizieren()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	Local $Text_der_Zeile = ""
	Local $Current_Line = Sci_GetCurrentLine($current_Scintilla_Window)
	Local $Line_Count = Sci_GetLineCount($current_Scintilla_Window)
	$Text_der_Zeile = Sci_GetLine($current_Scintilla_Window, $Current_Line - 1)
	If $Text_der_Zeile = "" And $Line_Count = $Current_Line Then Return
	If $Line_Count = 1 Or $Line_Count = $Current_Line Then Sci_InsertText($current_Scintilla_Window, Sci_GetLineEndPos($current_Scintilla_Window, $Current_Line), @CRLF)
	Sci_AddLines($current_Scintilla_Window, $Text_der_Zeile, $Current_Line + 1)
	_Check_Buttons(0)
EndFunc   ;==>_Zeile_Duplizieren

Func _Zeile_Bookmarken()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return

	Local $firstline = SendMessage($current_Scintilla_Window, $SCI_LINEFROMPOSITION, SendMessage($current_Scintilla_Window, $SCI_GETSELECTIONSTART, 0, 0), 0)
	Local $lastlineline = SendMessage($current_Scintilla_Window, $SCI_LINEFROMPOSITION, SendMessage($current_Scintilla_Window, $SCI_GETSELECTIONEND, 0, 0), 0)
	Local $count = 0

	For $line = $firstline To $lastlineline
		;Bookmarks mit der Marker ID 5
		If SendMessage($current_Scintilla_Window, $SCI_MARKERGET, $line, 0) = 0 Then
			;Marker setzen
			SendMessage($current_Scintilla_Window, $SCI_MARKERADD, $line, 5)
		Else
			;Marker entfernen
			SendMessage($current_Scintilla_Window, $SCI_MARKERDELETE, $line, 5)
		EndIf
		$count = $count + 1
		If $count > 49 Then ExitLoop ;Max 50 Zeilen, danach abbruch!
	Next

EndFunc   ;==>_Zeile_Bookmarken

Func _Alle_Bookmarks_entfernen()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_MARKERDELETEALL, -1, 0)
EndFunc   ;==>_Alle_Bookmarks_entfernen

Func _Springe_zum_naechsten_Bookmarks()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	$startline = SendMessage($current_Scintilla_Window, $SCI_LINEFROMPOSITION, Sci_GetCurrentPos($current_Scintilla_Window), 0)
	$Next_Bookmark_line = SendMessage($current_Scintilla_Window, $SCI_MARKERNEXT, $startline + 1, 32)
	If $Next_Bookmark_line = -1 Then ;Try "warp around"
		$Next_Bookmark_line = SendMessage($current_Scintilla_Window, $SCI_MARKERNEXT, 1, 32)
		If $Next_Bookmark_line = -1 Then Return
	EndIf
	GoToLine($Next_Bookmark_line, $current_Scintilla_Window)
EndFunc   ;==>_Springe_zum_naechsten_Bookmarks

Func _Springe_zur_vorherigen_Bookmarks()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	$startline = SendMessage($current_Scintilla_Window, $SCI_LINEFROMPOSITION, Sci_GetCurrentPos($current_Scintilla_Window), 0)
	$Prev_Bookmark_line = SendMessage($current_Scintilla_Window, $SCI_MARKERPREVIOUS, $startline - 1, 32)
	If $Prev_Bookmark_line = -1 Then ;Try "warp around"
		$Prev_Bookmark_line = SendMessage($current_Scintilla_Window, $SCI_MARKERPREVIOUS, Sci_GetLineCount($current_Scintilla_Window), 32)
		If $Prev_Bookmark_line = -1 Then Return
	EndIf
	GoToLine($Prev_Bookmark_line, $current_Scintilla_Window)
EndFunc   ;==>_Springe_zur_vorherigen_Bookmarks

Func _SCI_Kommentare_ausblenden_bzw_einblenden()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_STYLEGETVISIBLE, $SCE_AU3_COMMENT, 0) = 1 Then
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_STYLESETVISIBLE, $SCE_AU3_COMMENT, 0)
	Else
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_STYLESETVISIBLE, $SCE_AU3_COMMENT, 1)
	EndIf

EndFunc   ;==>_SCI_Kommentare_ausblenden_bzw_einblenden


Func _Markierte_Zeile_nach_oben_verschieben()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_MOVESELECTEDLINESUP, 0, 0)
EndFunc   ;==>_Markierte_Zeile_nach_oben_verschieben

Func _Markierte_Zeile_nach_unten_verschieben()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	SendMessage($current_Scintilla_Window, $SCI_MOVESELECTEDLINESDOWN, 0, 0)
EndFunc   ;==>_Markierte_Zeile_nach_unten_verschieben

; #FUNCTION# ;===============================================================================
; Name...........: _Erstelle_UDF_Header
; Description ...: Erstellt einen UDF HEader im Script über der gewählten Funktion (wie in SCiTE4AutoIt)
; Syntax.........: _Erstelle_UDF_Header()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: In der gewählten Zeile muss Text vorhanden sein!
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
; ==========================================================================================

Func _Erstelle_UDF_Header()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_UDFHeadererstellen) <> -1 Then Return ;Platzhalter für Plugin
	Local $Fertiger_String = ""
	Local $Text_der_Zeile = ""
	Local $funcname = ""
	Local $Parameters_to_list = ""
	Local $funcname_Parameters = ""
	Local $Description = ""
	Local $temp = ""
	Local $spaces = ""
	Local $x = 0
	Local $y = 0
	Local $str
	Local $optional_count = 0
	Local $temp_array
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(726), 0, $studiofenster)
		Return
	EndIf

	If Not StringInStr($Text_der_Zeile, "func ") Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(731), 0, $studiofenster)
		Return
	EndIf

	;Func Name
	$temp = _StringBetween($Text_der_Zeile, "func ", "(")
	If IsArray($temp) Then $funcname = $temp[0]
	$temp = _StringBetween($Text_der_Zeile, "(", ")")
	If IsArray($temp) Then $funcname_Parameters = $temp[0]

	;Optionale Parameter
	If $funcname_Parameters <> "" Then
		$temp_array = StringSplit($funcname_Parameters, ",", 2)
		If IsArray($temp_array) Then
			$funcname_Parameters = ""
			$optional_count = 0
			For $x = 0 To UBound($temp_array) - 1
				$temp_array[$x] = StringStripWS($temp_array[$x], 3)

				If StringInStr($temp_array[$x], "=") Then ;optional parameter
					$funcname_Parameters = $funcname_Parameters & " [, " & $temp_array[$x]
;~ $funcname_Parameters = $funcname_Parameters&" [, "&StringStripWS (StringTrimRight($temp_array[$x],stringlen($temp_array[$x])-StringInStr($temp_array[$x],"=",0,-1)+1),3)
					$optional_count = $optional_count + 1
				Else
					$funcname_Parameters = $funcname_Parameters & ", " & $temp_array[$x]
				EndIf
			Next
			$str = ""
			For $y = 1 To $optional_count
				$str = $str & "]"
			Next
			$funcname_Parameters = $funcname_Parameters & $str
			If StringTrimRight($funcname_Parameters, StringLen($funcname_Parameters) - 2) = ", " Then $funcname_Parameters = StringTrimLeft($funcname_Parameters, 2)
			$funcname_Parameters = StringStripWS($funcname_Parameters, 3)
		EndIf
	EndIf

	;Parameter auflisten:
	$temp = _StringBetween($Text_der_Zeile, "(", ")")
	If IsArray($temp) Then $Parameters_to_list = $temp[0]
	If $Parameters_to_list <> "" Then
		$temp_array = StringSplit($Parameters_to_list, ",", 2)
		$x = 0
		If IsArray($temp_array) Then

			For $x = 0 To UBound($temp_array) - 1
				$def_value = ""
				If StringInStr($temp_array[$x], "=") Then
					$def_value = StringTrimLeft($temp_array[$x], StringInStr($temp_array[$x], "="))
					$temp_array[$x] = StringTrimRight($temp_array[$x], StringLen($temp_array[$x]) - StringInStr($temp_array[$x], "=", 0, -1) + 1)
				EndIf
				$def_value = StringStripWS($def_value, 3)
				$temp_array[$x] = StringStripWS($temp_array[$x], 3)
				$len1 = StringLen("                     ")
				$len2 = StringLen($temp_array[$x])
				$dif = $len1 - $len2

				;Fülle mit Spaces
				$spaces = ""
				For $y = 1 To $dif
					$spaces = $spaces & " "
				Next

				$type = "An unknown value."
				$gefundener_type = StringTrimRight($temp_array[$x], StringLen($temp_array[$x]) - 2)
				$gefundener_type = StringReplace($gefundener_type, "$", "")
				$gefundener_type = StringLower($gefundener_type)
				Switch $gefundener_type

					Case "a"
						$type = "An array of unknowns."

					Case "h"
						$type = "A handle value."

					Case "t"
						$type = "A dll struct value."

					Case "s"
						$type = "A string value."

					Case "b"
						$type = "A boolean value."

					Case "d"
						$type = "A binary value."

					Case "n"
						$type = "A floating point number value."

					Case "v"
						$type = "A variant value."

					Case "p"
						$type = "A pointer value."

					Case "o"
						$type = "A object value."

					Case "i"
						$type = "A integer value."

					Case "f"
						$type = "A floating point number value."

				EndSwitch

				If StringInStr($temp_array[$x], "id") Then $type = "An AutoIt controlID."
				If StringInStr($temp_array[$x], "tag") Then $type = "Structures definition."

				If $def_value <> "" Then $type = $type & " Default is " & $def_value & "."

				If $def_value <> "" Then
					$temp_array[$x] = $temp_array[$x] & $spaces & "- [optional] " & $type
				Else
					$temp_array[$x] = $temp_array[$x] & $spaces & "- " & $type
				EndIf
			Next

			;Baue fertigen String
			$Parameters_to_list = ""
			For $x = 0 To UBound($temp_array) - 1
				If $x <> UBound($temp_array) - 1 Then
					$Parameters_to_list = $Parameters_to_list & $temp_array[$x] & @CRLF
				Else
					$Parameters_to_list = $Parameters_to_list & $temp_array[$x]
				EndIf
			Next
			$Parameters_to_list = StringReplace($Parameters_to_list, @CRLF, @CRLF & ";                  ") ;Text Einrücken
		EndIf
	EndIf
	If $Parameters_to_list = "" Then $Parameters_to_list = "None"

	$Description = StringReplace(IniRead($Pfad_zur_Project_ISN, $funcname, "comment", ""), "[BREAK]", " ")

	$Fertiger_String = "; #FUNCTION# ====================================================================================================================" & @CRLF & _
			"; Name ..........: " & $funcname & @CRLF & _
			"; Description ...: " & $Description & @CRLF & _
			"; Syntax ........: " & $funcname & "(" & $funcname_Parameters & ")" & @CRLF & _
			"; Parameters ....: " & $Parameters_to_list & @CRLF & _
			"; Return values .: None" & @CRLF & _
			"; Author ........: " & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", "") & @CRLF & _
			"; Modified ......: " & @CRLF & _
			"; Remarks .......: " & @CRLF & _
			"; Related .......: " & @CRLF & _
			"; Link ..........: " & @CRLF & _
			"; Example .......: No" & @CRLF & _
			"; ==============================================================================================================================="
	;Sende Text in den Editor
	If Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) = 1 Then Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], @CRLF, 1)
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertiger_String, Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)

	_Check_Buttons(0)
EndFunc   ;==>_Erstelle_UDF_Header




Func _Springe_zu_Func()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return



	Local $funcname = ""
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then Return


	$Aktuelles_Wort = SCI_GetCurrentWordEx($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Aktuelles_Wort = StringStripWS($Aktuelles_Wort, 3)
	$Aktuelles_Wort = StringReplace($Aktuelles_Wort, "(", "")
	$Aktuelles_Wort = StringReplace($Aktuelles_Wort, ")", "")

	$Springe_zu_Func_Letzte_Pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If $Aktuelles_Wort = "" Then Return

	$wrapFind = True
	FindNext("func " & $Aktuelles_Wort & Random(23043), False, False, 0, False) ;mache zufallssuche um wieder von oben zu beginnen ^^
	$wrapFind = True
	$found = FindNext("func " & $Aktuelles_Wort, False, False, 0, False)
	If $found = -1 Then
		$Springe_zu_Func_Letzte_Suche = ""
		$Springe_zu_Func_Letzte_Pos = 0
		MsgBox(262144 + 16, _Get_langstr(25), $Aktuelles_Wort & " " & _Get_langstr(332), 0, $Studiofenster)
	Else
		$Springe_zu_Func_Letzte_Suche = $Aktuelles_Wort
	EndIf
EndFunc   ;==>_Springe_zu_Func

Func _Springe_zu_Func_zurueck()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return

	If $Springe_zu_Func_Letzte_Suche <> "" Then
		Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Springe_zu_Func_Letzte_Pos)
		$Springe_zu_Func_Letzte_Suche = ""
		$Springe_zu_Func_Letzte_Pos = 0
	EndIf
EndFunc   ;==>_Springe_zu_Func_zurueck

Func _Extracode_Copy_to_Clipboard()
	ClipPut(_ANSI2UNICODE(Sci_GetLines($scintilla_Codeausschnitt)))
EndFunc   ;==>_Extracode_Copy_to_Clipboard

Func _Extracode_Save_AS_Au3()
	_Lock_Plugintabs("lock")
	If $Skin_is_used = "true" Then
		$i = _WinAPI_SaveFileDlg(_Get_langstr(1187), $Offenes_Projekt, "AutoIt Skript (*.au3)", 0, "", '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $Codeausschnitt_GUI)
	Else
		$i = FileSaveDialog(_Get_langstr(1187), $Offenes_Projekt, "AutoIt Skript (*.au3)", 18, "", $Codeausschnitt_GUI)
	EndIf
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If $i = "" Then Return
	$file_handle = FileOpen($i, 2)
	FileWrite($file_handle, _ANSI2UNICODE(Sci_GetLines($scintilla_Codeausschnitt)))
	FileClose($file_handle)
EndFunc   ;==>_Extracode_Save_AS_Au3

Func _SCI_Zeige_Extracode($Code_String = "", $Extracode_Label = "", $Titel2_Label = "", $flags = 0)

	;GUISetState(@SW_LOCK, $Codeausschnitt_GUI)
	SendMessageString($scintilla_Codeausschnitt, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_SETSAVEPOINT, 0, 0)
	$Code_String = StringReplace($Code_String, "[BREAK]", @CRLF)
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SCI_SetText($scintilla_Codeausschnitt, $Code_String)
	SendMessage($scintilla_Codeausschnitt, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()

	GUICtrlSetState($Codeausschnitt_Code_Save_as_au3_Button, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_Code_Kopieren_Button, $GUI_SHOW)
	Switch $flags

		Case 0
			GUISetState(@SW_DISABLE, $StudioFenster)
			GUICtrlSetState($Codeausschnitt_GUI_bereichlabel, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_GUI_Dateilabel, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_Abbrechen_Button, $GUI_SHOW)
			GUICtrlSetOnEvent($Codeausschnitt_OK_Button, "_SCI_Extracode_OK")
			GUICtrlSetOnEvent($Codeausschnitt_Abbrechen_Button, "_SCI_Extracode_Abbrechen")
			GUISetOnEvent($GUI_EVENT_CLOSE, "_SCI_Extracode_Abbrechen", $Codeausschnitt_GUI)

		Case 1
			GUICtrlSetState($Codeausschnitt_Abbrechen_Button, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_GUI_bereichlabel, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_GUI_Dateilabel, $GUI_HIDE)
			GUICtrlSetOnEvent($Codeausschnitt_OK_Button, "_Hide_Codeausschnitt_GUI")
			GUISetOnEvent($GUI_EVENT_CLOSE, "_Hide_Codeausschnitt_GUI", $Codeausschnitt_GUI)



	EndSwitch



	If $Titel2_Label = "" Or $Titel2_Label = " " Then
		GUICtrlSetState($Codeausschnitt_GUI_titel2, $GUI_HIDE)
	Else
		GUICtrlSetState($Codeausschnitt_GUI_titel2, $GUI_SHOW)
	EndIf

	GUICtrlSetData($Codeausschnitt_GUI_titel, $Extracode_Label)
	GUICtrlSetData($Codeausschnitt_GUI_titel2, $Titel2_Label)
	WinSetTitle($Codeausschnitt_GUI, "", $Extracode_Label)
	Codeausschnitt_GUI_Resize()
	;GUISetState(@SW_UNLOCK, $Codeausschnitt_GUI)
	GUISetState(@SW_SHOW, $Codeausschnitt_GUI)

	WinSetOnTop($Codeausschnitt_GUI, "", 1)
	If $flags = 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_DISABLE)
	Return 1
EndFunc   ;==>_SCI_Zeige_Extracode


Func _SCI_Extracode_OK()
	$Text = Sci_GetText($scintilla_Codeausschnitt)
	SendMessage($scintilla_Codeausschnitt, $SCI_CALLTIPCANCEL, 0, 0)
	$Text = StringReplace($Text, Chr(0), "", 0, 1) ;NULL Byte entfernen
	$Text = StringReplace($Text, @CRLF, "[BREAK]")
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "extracodeanswer" & $Plugin_System_Delimiter & $Text)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Codeausschnitt_GUI)
	WinSetOnTop($Codeausschnitt_GUI, "", 0)
EndFunc   ;==>_SCI_Extracode_OK

Func _SCI_Extracode_Abbrechen()
	SendMessage($scintilla_Codeausschnitt, $SCI_CALLTIPCANCEL, 0, 0)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "extracodeanswer" & $Plugin_System_Delimiter & "#error#")
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Codeausschnitt_GUI)
	WinSetOnTop($Codeausschnitt_GUI, "", 0)
EndFunc   ;==>_SCI_Extracode_Abbrechen

Func _SCI_Zeige_Code_Schnipsel($SCE = "", $str = "", $mode = 0)
	If $SCE = "" Then Return
	If $str = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$SCE = HWnd($SCE)

	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], $szDrive, $szDir, $szFName, $szExt)
	If $last_scripttree_jumptosearch <> $str Then
		$begin_from = 0
	Else
		$begin_from = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])))
	EndIf
	$alte_Pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$last_scripttree_jumptosearch = $str
	$found = _search_from_Scripttree($str, $begin_from, $mode)
	If $found = -1 Then $found = _search_from_Scripttree($str, $begin_from, $mode) ;2te Change ;) (komischer bug, but hey it works -.-)
	If $found = -1 Then Return ;falls immer noch nichts gefunden stoppe aktion...

	;markiere ganze Zeile
	$startline = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]))
	Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $alte_Pos)
	If Not StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $startline), "func", 2) Then Return
	;Hole gesamten Text der Func
	Local $Text = ""
	For $x = $startline To Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		$Text = $Text & Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $x)
		If StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $x), "endfunc", 2) Then
			$Text = StringStripWS($Text, 2)
			ExitLoop
		EndIf
	Next
	$Codeausschnitt_Startline = $startline
	$Codeausschnitt_Endline = $x

	SendMessageString($scintilla_Codeausschnitt, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_SETSAVEPOINT, 0, 0)
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SCI_SetText($scintilla_Codeausschnitt, $Text)
	SendMessage($scintilla_Codeausschnitt, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()
	WinSetTitle($Codeausschnitt_GUI, "", _Get_langstr(810))
	GUICtrlSetData($Codeausschnitt_GUI_titel, _Get_langstr(810) & ' "' & $str & '"')
	GUICtrlSetData($Codeausschnitt_GUI_titel2, $szFName & $szExt)
	GUICtrlSetData($Codeausschnitt_GUI_Dateilabel, _Get_langstr(742) & " " & $szDrive & $szDir & $szFName & $szExt)
	GUICtrlSetData($codeausschnitt_Dateipfad, $szDrive & $szDir & $szFName & $szExt)
	GUICtrlSetData($codeausschnitt_Dateipfad, $szDrive & $szDir & $szFName & $szExt)
	GUICtrlSetData($codeausschnitt_vonZEILE, $startline)
	GUICtrlSetData($codeausschnitt_bisZEILE, $x)
	GUICtrlSetState($Codeausschnitt_GUI_titel2, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_GUI_bereichlabel, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_GUI_Dateilabel, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_Code_Save_as_au3_Button, $GUI_HIDE)
	GUICtrlSetState($Codeausschnitt_Abbrechen_Button, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_Code_Kopieren_Button, $GUI_HIDE)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Hide_Codeausschnitt_GUI", $Codeausschnitt_GUI)
	GUICtrlSetOnEvent($Codeausschnitt_Abbrechen_Button, "_Hide_Codeausschnitt_GUI")
	GUICtrlSetOnEvent($Codeausschnitt_OK_Button, "_Codeausschnitt_GUI_OK")
	GUICtrlSetData($Codeausschnitt_GUI_bereichlabel, StringReplace(StringReplace(_Get_langstr(925), "%1", $startline + 1), "%2", $x + 1))
	Codeausschnitt_GUI_Resize()
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_SHOW, $Codeausschnitt_GUI)
;~ 	SetSelection($start, $end)


EndFunc   ;==>_SCI_Zeige_Code_Schnipsel



Func _Codeausschnitt_GUI_OK()
	;Markiere Text im "echten" Editor
	Local $start = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Codeausschnitt_Startline)
	Local $end = Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Codeausschnitt_Endline)
	SetSelection($start, $end)
	;Und ersetze es durch neuen
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	Sci_ReplaceSel($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetText($scintilla_Codeausschnitt))
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_COLOURISE, 0, -1) ;Redraw the lexer
	_ISN_AutoIt_Studio_activate_GUI_Messages()
	_Hide_Codeausschnitt_GUI()
	_Check_tabs_for_changes()
EndFunc   ;==>_Codeausschnitt_GUI_OK


Func _Hide_Codeausschnitt_GUI()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Codeausschnitt_GUI)
EndFunc   ;==>_Hide_Codeausschnitt_GUI


Func _Oeffne_alte_Tabs($string = "")
	If $string = "" Then Return
	$Dateien = StringSplit($string, "|", 2)
	If Not IsArray($Dateien) Then Return
	For $x = 0 To UBound($Dateien) - 1
		If FileExists(_ISN_Variablen_aufloesen($Dateien[$x])) Then Try_to_opten_file(_ISN_Variablen_aufloesen($Dateien[$x]))
	Next
EndFunc   ;==>_Oeffne_alte_Tabs


Func _Skripteditor_hole_Inludes($Hauptdatei = "", $Filter = "")
	If $Hauptdatei = "" Then Return
	Dim $textarray
	Local $Includes_Array[1]
	If $Filter <> "" Then
		If StringInStr($Hauptdatei, $Filter) Then _ArrayAdd($Includes_Array, $Hauptdatei)
	Else
		_ArrayAdd($Includes_Array, $Hauptdatei) ;Hauptdatei ist (fast) immer dabei :P
	EndIf

	_FileReadToArray($Hauptdatei, $textarray)
	If Not IsArray($textarray) Then Return
	;includes
	For $i = 0 To UBound($textarray) - 1
		While StringInStr($textarray[$i], "#include")
			If Not StringInStr($textarray[$i], ".") Then ExitLoop
			If StringInStr($textarray[$i], "-once") Then ExitLoop
			$txt = $textarray[$i]
			If StringInStr($txt, ";") Then ;falls auskommentiert
				If StringInStr($txt, ";") < StringInStr($txt, "#include") Then ExitLoop
			EndIf
			If StringInStr($txt, "<") Then $txt = StringTrimLeft($txt, StringInStr($txt, "<") - 1)
			If StringInStr($txt, "'") Then $txt = StringTrimLeft($txt, StringInStr($txt, "'") - 1)
			If StringInStr($txt, '"') Then $txt = StringTrimLeft($txt, StringInStr($txt, '"') - 1)
			If StringInStr($txt, ">") Then $txt = StringTrimRight($txt, StringLen($txt) - StringInStr($txt, ">"))
			If StringInStr($txt, '"') Then $txt = StringTrimRight($txt, StringLen($txt) - StringInStr($txt, '"', 0, -1))
			If StringInStr($txt, "'") Then $txt = StringTrimRight($txt, StringLen($txt) - StringInStr($txt, "'", 0, -1))
			$txt = StringStripWS($txt, 3)
			$txt = StringReplace($txt, '"', "")
			$txt = StringReplace($txt, "'", "")
			$txt = StringReplace($txt, "<", "")
			$txt = StringReplace($txt, ">", "")

			If StringInStr($txt, "(") Then ExitLoop
			If StringInStr($txt, ")") Then ExitLoop
			If StringInStr($txt, '"') Then ExitLoop
			If StringInStr($txt, "'") Then ExitLoop

			If $txt = "" Then ExitLoop
			If $txt = " " Then ExitLoop

			If $Filter <> "" Then
				If Not StringInStr($txt, $Filter) Then ExitLoop
			EndIf
			$txt = $Offenes_Projekt & "\" & $txt
			If Not FileExists($txt) Then ExitLoop ;Dadurch werden automatisch die AutoIt Include ignoriert, da es diese im Projektverzeichnis ja nicht gibt!
			_ArrayAdd($Includes_Array, $txt)
			ExitLoop
		WEnd
	Next
	$Includes_Array[0] = UBound($Includes_Array) - 1
	Return $Includes_Array
EndFunc   ;==>_Skripteditor_hole_Inludes

Func _Neue_Datei_erstellen_ersetze_Variablen($string = "", $Dateiname = "", $Autor = "", $Proejktkommentar = "", $projektname = "")
	If $string = "" Then Return ""

	$string = StringReplace($string, "%projectname%", $projektname)
	$string = StringReplace($string, "%filename%", $Dateiname)
	$string = StringReplace($string, "%autor%", $Autor)
	$string = StringReplace($string, "%projectcomment%", $Proejktkommentar)
	$string = StringReplace($string, "%studioversion%", $Studioversion)
	$string = StringReplace($string, "%autoitversion%", FileGetVersion($autoitexe))
	$string = StringReplace($string, "%hour%", @HOUR)
	$string = StringReplace($string, "%min%", @MIN)
	$string = StringReplace($string, "%sec%", @SEC)
	$string = StringReplace($string, "%mday%", @MDAY)
	$string = StringReplace($string, "%year%", @YEAR)
	$string = StringReplace($string, "%mon%", @MON)
	$string = StringReplace($string, "%osarch%", @OSArch)
	$string = StringReplace($string, "%username%", @UserName)
	If StringInStr($string, "%langstring(") Then
		$Find_Array = _StringBetween($string, "%langstring(", ")%")
		If IsArray($Find_Array) Then
			For $x = 0 To UBound($Find_Array) - 1
				$string = StringReplace($string, "%langstring(" & $Find_Array[$x] & ")%", _Get_langstr($Find_Array[$x]))
			Next
		EndIf
	EndIf

	Return $string
EndFunc   ;==>_Neue_Datei_erstellen_ersetze_Variablen

Func _Hotkey_vorwaerts_suchen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$Search_Again = 0
	If GUICtrlRead($rFindDirectionUp) = $GUI_Checked Then $Search_Again = 1
	GUICtrlSetState($rFindDirectionUp, $GUI_UNCHECKED)
	GUICtrlSetState($rFindDirectionDown, $GUI_CHECKED)
	btnFindNextClick()
	If $Search_Again = 1 Then btnFindNextClick()
EndFunc   ;==>_Hotkey_vorwaerts_suchen

Func _Hotkey_Rueckwaerts_suchen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$Search_Again = 0
	If GUICtrlRead($rFindDirectionDown) = $GUI_Checked Then $Search_Again = 1
	GUICtrlSetState($rFindDirectionUp, $GUI_CHECKED)
	GUICtrlSetState($rFindDirectionDown, $GUI_UNCHECKED)
	btnFindNextClick()
	If $Search_Again = 1 Then btnFindNextClick()
EndFunc   ;==>_Hotkey_Rueckwaerts_suchen

Func _UDF_Funktionen_aus_Skript_Auslesen_und_zum_Autocomplete_hinzufuegen() ;DELETE ME FROM HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
	$aList = StringRegExp(StringRegExpReplace($FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)], '(?ims)#c[^#]+#c', ''), '(?ims)^\s*Func\s*([^(]*)', 3)
	If Not IsArray($aList) Then Return
	If IsDeclared("SCI_Autocompletelist_backup") Then $SCI_AUTOCLIST = $SCI_Autocompletelist_backup ;Backup wiederherstellen
	For $x = 0 To UBound($aList) - 1
		_Add_item_to_Autocompleteliste($aList[$x])
	Next
	ArraySortUnique($SCI_AUTOCLIST, 0, 1) ;Sortiere Autocomplete List neu
EndFunc   ;==>_UDF_Funktionen_aus_Skript_Auslesen_und_zum_Autocomplete_hinzufuegen

Func _Add_item_to_Autocompleteliste($txt, $Pixmark = "?2")
	If Not IsArray($SCI_AUTOCLIST) Then Return
	_ArrayAdd($SCI_AUTOCLIST, $txt & $Pixmark)
EndFunc   ;==>_Add_item_to_Autocompleteliste


Func _StripCommentLines(ByRef $sData)
	$sData = StringRegExpReplace($sData & @CRLF, "(?s)(?i)(\s*#cs\s*.+?\#ce\s*)(\r\n)", "\2")
	$sData = StringRegExpReplace($sData, "(?s)(?i)" & '("")|(".*?")|' & "('')|('.*?')|" & "(\s*;.*?)(\r\n)", "\1\2\3\4\6")
	$sData = StringRegExpReplace($sData, "(\r\n){2,}", @CRLF)
EndFunc   ;==>_StripCommentLines

Func _StripWhitespace(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\h+(?=\R)', '') ; Trailing whitespace. By DXRW4E.
	$sData = StringRegExpReplace($sData, '\R\h+', @CRLF) ; Strip leading whitespace. By DXRW4E.
EndFunc   ;==>_StripWhitespace

Func _Pruefe_Doppelklickwort_im_Skripteditor($Wort = "", $startpos = "-1")
	If $Tools_Parameter_Editor_aktiviert = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return -1
	If $startpos = "-1" Then Return -1
	If $Wort = "" Then Return -1
	If StringInStr($Wort, "$") Then Return -1
	If StringInStr($Wort, "Global") Then Return -1
	If StringInStr($Wort, "Local") Then Return -1
	If StringInStr($Wort, "Func") Then Return -1
	If StringInStr($Wort, "Dim") Then Return -1
	If StringInStr($Wort, "#include") Then Return -1

	$Zeile_NR = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $startpos)
	$Zeile_Text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR)
	$Zeile_Multibyte_Dif = BinaryLen(StringToBinary($Zeile_Text)) - StringLen($Zeile_Text)
	$Text_Ab_Wort = StringTrimLeft($Zeile_Text, $startpos - Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR))
	$Edit_Startpos = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR) + ($startpos - Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR))



	;Check for multiline parameter
	$Multiline_mode = 0
	$Text_Ab_Wort_Multi = $Text_Ab_Wort
	_StripCommentLines($Text_Ab_Wort_Multi)
	$Text_Ab_Wort_Multi = StringStripWS($Text_Ab_Wort_Multi, 2)
	If StringRight($Text_Ab_Wort_Multi, 1) = "_" Then ;Looks like we have here something with multi lining
		$Multiline_mode = 1
		If StringRight($Text_Ab_Wort_Multi, 3) = "& _" Then $Text_Ab_Wort_Multi = StringReplace($Text_Ab_Wort_Multi, "& _", "[PARALINEBREAK]", -1)
		If StringRight($Text_Ab_Wort_Multi, 2) = "&_" Then $Text_Ab_Wort_Multi = StringReplace($Text_Ab_Wort_Multi, "&_", "[PARALINEBREAK]", -1)
		If StringRight($Text_Ab_Wort_Multi, 2) = ",_" Then $Text_Ab_Wort_Multi = StringReplace($Text_Ab_Wort_Multi, ",_", "[PARABREAK]", -1)
		If StringRight($Text_Ab_Wort_Multi, 3) = ", _" Then $Text_Ab_Wort_Multi = StringReplace($Text_Ab_Wort_Multi, ", _", "[PARABREAK]", -1)


		For $k = $Zeile_NR + 1 To $Zeile_NR + 200 ;Search max 200 lines
			$multiline_tmp3 = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $k)
			$Text_Ab_Wort = $Text_Ab_Wort & $multiline_tmp3
			_StripCommentLines($multiline_tmp3)
			$multiline_tmp3 = StringStripWS($multiline_tmp3, 2)
			$Exit_backup = $multiline_tmp3
			If StringRight($multiline_tmp3, 3) = "& _" Then $multiline_tmp3 = StringReplace($multiline_tmp3, "& _", "[PARALINEBREAK]", -1)
			If StringRight($multiline_tmp3, 2) = "&_" Then $multiline_tmp3 = StringReplace($multiline_tmp3, "&_", "[PARALINEBREAK]", -1)
			If StringRight($multiline_tmp3, 2) = ",_" Then $multiline_tmp3 = StringReplace($multiline_tmp3, ",_", "[PARABREAK]", -1)
			If StringRight($multiline_tmp3, 3) = ", _" Then $multiline_tmp3 = StringReplace($multiline_tmp3, ", _", "[PARABREAK]", -1)

			$Text_Ab_Wort_Multi = $Text_Ab_Wort_Multi & $multiline_tmp3


			If StringRight($Exit_backup, 1) <> "_" Then ExitLoop
		Next


	EndIf


	If $Multiline_mode = 0 Then
		$Text_Ab_Wort = StringReplace($Text_Ab_Wort, @CRLF, "")
		$Text_Ab_Wort = StringReplace($Text_Ab_Wort, @LF, "")
	EndIf

	$Durch_Klammer_Geoeffnet = 0
	$Durch_Klammer_Geschlossen = 0
	$Edit_Endpos = 0

	For $x = 1 To StringLen($Text_Ab_Wort)
		$style = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSTYLEAT, $startpos + ($x - 1), 0)
		If $style = $SCE_AU3_COMMENT Or $style = $SCE_AU3_COMMENTBLOCK Then ContinueLoop ;Bereits bei einem Kommentar


		If StringMid($Text_Ab_Wort, $x, 1) = "(" Then $Durch_Klammer_Geoeffnet = $Durch_Klammer_Geoeffnet + 1
		If StringMid($Text_Ab_Wort, $x, 1) = ")" Then $Durch_Klammer_Geschlossen = $Durch_Klammer_Geschlossen + 1
		If $Durch_Klammer_Geoeffnet = 0 Then ContinueLoop
		If $Durch_Klammer_Geoeffnet = $Durch_Klammer_Geschlossen Then
			$Edit_Endpos = $Edit_Startpos + $x + $Zeile_Multibyte_Dif
			If Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Edit_Endpos) = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Edit_Startpos) Then $Multiline_mode = 0
			ExitLoop
		EndIf
	Next



	If $Durch_Klammer_Geoeffnet = 0 Then Return -1
	If $Durch_Klammer_Geschlossen = 0 Then Return -1

	$Parameter_Editor_Startpos = $Edit_Startpos
	$Parameter_Editor_Endpos = $Edit_Endpos

	If $Parameter_SCE_HANDLE <> "" Then SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, False, 0)
	$Parameter_SCE_HANDLE = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]

	If $autoit_editor_encoding = "2" Then
		If $Multiline_mode = 0 Then
			_Zeige_Parameter_Editor(_ANSI2UNICODE($Wort), _ANSI2UNICODE(SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Edit_Startpos, $Edit_Endpos)))
		Else
			_Zeige_Parameter_Editor(_ANSI2UNICODE($Wort), _ANSI2UNICODE($Text_Ab_Wort_Multi))
		EndIf
	Else
		If $Multiline_mode = 0 Then
			_Zeige_Parameter_Editor($Wort, SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Edit_Startpos, $Edit_Endpos))
		Else
			_Zeige_Parameter_Editor($Wort, $Text_Ab_Wort_Multi)
		EndIf
	EndIf

EndFunc   ;==>_Pruefe_Doppelklickwort_im_Skripteditor


Func _Zeige_Parameter_Editor($funcname = "", $ParameterString = "", $Nur_Kommaanzahl_zurueckgeben = 0)
	If $Tools_Parameter_Editor_aktiviert = "false" Then Return
	If $funcname = "" Then Return

	If $ParameterString = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1042), 0, $Studiofenster)
		Return
	EndIf

	$Parameter_Editor_Laedt_gerade_text = 0
	Local $Calltip_Parameter_Array
	Local $sString = ""
	Local $SCI_sCallTip = _Get_langstr(1038)
	Local $Handle_fuer_listview
	$SCI_Calltipp = ArraySearchAll($SCI_sCallTip_Array, $funcname, 0, 0, 1)
	If IsArray($SCI_Calltipp) Then
		$SCI_sCallTip = $SCI_sCallTip_Array[$SCI_Calltipp[0]]
		$SCI_sCallTip = StringReplace(StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "(.{70,110} )", "$1" & @LF), @LF & @LF, @LF)
	EndIf

	If $Nur_Kommaanzahl_zurueckgeben = 0 Then
		$Handle_fuer_listview = $ParameterEditor_ListView
	Else
		$Handle_fuer_listview = $ParameterEditor_ListView_buffer
	EndIf


	;Parameter in Listview eintragen
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Handle_fuer_listview))


	;Parameterbeschreibung aus Calltip
	If $SCI_sCallTip <> "" And $SCI_sCallTip <> _Get_langstr(1038) Then
		$sString = StringTrimLeft($SCI_sCallTip, StringInStr($SCI_sCallTip, "("))
		$sString = StringTrimRight($sString, StringLen($sString) - (StringInStr($sString, ")", 0, 1) - 1))
		$sString = StringReplace($sString, "[", "")
		$sString = StringReplace($sString, "]", "")
		$sString = StringReplace($sString, '"', "")
		$Calltip_Parameter_Array = StringSplit($sString, ",", 2)
		If IsArray($Calltip_Parameter_Array) Then
			For $c = 0 To UBound($Calltip_Parameter_Array) - 1
				$ItemText = $Calltip_Parameter_Array[$c]
				If StringInStr($ItemText, "=") Then $ItemText = StringTrimRight($ItemText, StringLen($ItemText) - (StringInStr($ItemText, "=") - 1))
				_GUICtrlListView_AddItem($Handle_fuer_listview, StringStripWS($ItemText, 3))
			Next
		EndIf
	EndIf


	$ParameterString = StringStripWS($ParameterString, 3)
	$ParameterString = StringTrimLeft($ParameterString, 1)
	$ParameterString = StringTrimRight($ParameterString, 1)
	$Readen_Parameter_String = $ParameterString
	$Listview_Row = 0
	$durchlauf = 0
	$Parastring = ""
	$Klammer_auf = 0
	$Klammeraufcount = 0
	$Klammerzucount = 0

	;Parameterstring vorbereiten
	If StringInStr($Readen_Parameter_String, @TAB) Then $Readen_Parameter_String = StringReplace($Readen_Parameter_String, @TAB, "[TAB]")
	$array = _StringBetween($Readen_Parameter_String, '"', '"', 1)
	If IsArray($array) Then
		For $d = 0 To UBound($array) - 1
			If StringInStr($array[$d], ",") Then $Readen_Parameter_String = StringReplace($Readen_Parameter_String, $array[$d], StringReplace($array[$d], ",", "[COMMA]"))
		Next
	EndIf

	$array = _StringBetween($Readen_Parameter_String, "'", "'", 1)
	If IsArray($array) Then
		For $d = 0 To UBound($array) - 1
			If StringInStr($array[$d], ",") Then $Readen_Parameter_String = StringReplace($Readen_Parameter_String, $array[$d], StringReplace($array[$d], ",", "[COMMA]"))
		Next
	EndIf


	$Readen_Parameter_String = StringReplace($Readen_Parameter_String, "[PARALINEBREAK]", ",[PARALINEBREAK],")
	$Readen_Parameter_String = StringReplace($Readen_Parameter_String, "[PARABREAK]", ",[PARABREAK],")

	$Split_Array = StringSplit($Readen_Parameter_String, ",", 2)
	If IsArray($Split_Array) Then
		;Bastle Parameterarray


		For $durchlauf = 0 To UBound($Split_Array) - 1

			If $Split_Array[$durchlauf] = "[PARABREAK]" Then
				If _GUICtrlListView_GetItemCount($Handle_fuer_listview) < $Listview_Row + 1 Then _GUICtrlListView_AddItem($Handle_fuer_listview, _Get_langstr(1359))
				_GUICtrlListView_SetItemText($Handle_fuer_listview, $Listview_Row, _Get_langstr(1359), 0)
				$Listview_Row = $Listview_Row + 1
				ContinueLoop
			EndIf

			If $Split_Array[$durchlauf] = "[PARALINEBREAK]" Then
				If _GUICtrlListView_GetItemCount($Handle_fuer_listview) < $Listview_Row + 1 Then _GUICtrlListView_AddItem($Handle_fuer_listview, _Get_langstr(1360))
				_GUICtrlListView_SetItemText($Handle_fuer_listview, $Listview_Row, _Get_langstr(1360), 0)
				$Listview_Row = $Listview_Row + 1
				ContinueLoop
			EndIf

			If StringInStr($Split_Array[$durchlauf], "(") Then
				StringReplace($Split_Array[$durchlauf], "(", "")
				$Klammeraufcount = @extended
				$Klammer_auf = $Klammer_auf + $Klammeraufcount
			EndIf

			If $Klammer_auf = 0 Then
				If _GUICtrlListView_GetItemCount($Handle_fuer_listview) < $Listview_Row + 1 Then _GUICtrlListView_AddItem($Handle_fuer_listview, _Get_langstr(1041) & " " & $Listview_Row + 1)
				$itemtxt = StringReplace($Split_Array[$durchlauf], "[COMMA]", ",")
				$itemtxt = StringStripWS($itemtxt, 3)
				$itemtxt = StringReplace($itemtxt, "[TAB]", @TAB)
				_GUICtrlListView_AddSubItem($Handle_fuer_listview, $Listview_Row, $itemtxt, 1)
				$Listview_Row = $Listview_Row + 1
			Else

				If StringInStr($Split_Array[$durchlauf], ")") Then
					StringReplace($Split_Array[$durchlauf], ")", "")
					$Klammerzucount = @extended
					$Klammer_auf = $Klammer_auf - $Klammerzucount
					If $Klammer_auf = 0 Then
						$Parastring = $Parastring & StringStripWS($Split_Array[$durchlauf], 3)
					Else
						$Parastring = $Parastring & StringStripWS($Split_Array[$durchlauf], 3) & ", "
					EndIf
					If $Klammer_auf = 0 Then
						If _GUICtrlListView_GetItemCount($Handle_fuer_listview) < $Listview_Row + 1 Then _GUICtrlListView_AddItem($Handle_fuer_listview, _Get_langstr(1041) & " " & $Listview_Row + 1)
						$itemtxt = StringReplace($Parastring, "[COMMA]", ",")
						$itemtxt = StringStripWS($itemtxt, 3)
						$itemtxt = StringReplace($itemtxt, "[TAB]", @TAB)
						_GUICtrlListView_AddSubItem($Handle_fuer_listview, $Listview_Row, $itemtxt, 1)
						$Listview_Row = $Listview_Row + 1
						$Parastring = ""
					EndIf
				Else
					$Parastring = $Parastring & StringStripWS($Split_Array[$durchlauf], 3) & ", "
				EndIf

			EndIf
		Next

	EndIf

	;Für den Editor
	If $Nur_Kommaanzahl_zurueckgeben = 1 Then

		Local $Parameter_Listview_als_Array = _GUICtrlListView_CreateArray($Handle_fuer_listview)
		Local $String_fuer_rueckgabe = ""
		If IsArray($Parameter_Listview_als_Array) Then
			For $cnt = 0 To UBound($Parameter_Listview_als_Array) - 1
				$String_fuer_rueckgabe = $String_fuer_rueckgabe & StringReplace($Parameter_Listview_als_Array[$cnt][1], ",", "##") & ","
				If StringInStr($Parameter_Listview_als_Array[$cnt][1], "#-cursor-#") Then ExitLoop ;Loop wird über den cursor hinaus gehen...abbruch!
			Next
		EndIf
		Return UBound($Parameter_Listview_als_Array)
	EndIf


	;Prüfe ob Array korrekt erstellt wurde
	If $Klammer_auf <> 0 Then
		;Syntaxfehler
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1042), 0, $Studiofenster)
		Return
	EndIf

	Sci_DelLines($ParameterEditor_SCIEditor)

	GUICtrlSetData($ParameterEditor_ParameterTitel, $funcname)
	GUICtrlSetData($ParameterEditor_CallTipp_Label, $SCI_sCallTip)
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
	If _GUICtrlListView_GetItemCount($Handle_fuer_listview) <> 0 Then
		_GUICtrlListView_SetItemSelected($Handle_fuer_listview, 0, True, True)
		_GUICtrlListView_SetSelectionMark($Handle_fuer_listview, 0)
		_Parameter_Editor_Listview_select_row()
	EndIf




	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_Parametereditor) <> -1 Then Return ;Platzhalter für Plugin. Falls Plugin mit -1 beendet wird, wird die ausführung hier gestoppt.



	;Setze Scintilla auf ReadOnly (Damit Coursorpositionen gleich bleiben)
	SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, True, 0)


	;properties und APIs setzen
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 0, $au3_keywords_keywords)
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 1, $au3_keywords_functions)
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 2, $au3_keywords_macros)
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 3, $au3_keywords_sendkeys)
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 4, $au3_keywords_preprocessor)
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 5, $special_Keywords)
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 6, $au3_keywords_abbrev)
	SendMessageString($ParameterEditor_SCIEditor, $SCI_SETKEYWORDS, 7, $UDF_Keywords)

	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 0, $au3_keywords_keywords)
	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 1, $au3_keywords_functions)
	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 2, $au3_keywords_macros)
	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 3, $au3_keywords_sendkeys)
	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 4, $au3_keywords_preprocessor)
	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 5, $special_Keywords)
	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 6, $au3_keywords_abbrev)
	SendMessageString($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETKEYWORDS, 7, $UDF_Keywords)


	_Parametereditor_Fenster_anpassen()
	GUISetState(@SW_SHOW, $ParameterEditor_GUI)
EndFunc   ;==>_Zeige_Parameter_Editor

Func _Hide_Parameter_Editor()
	;Scintilla wieder aktivieren
	If $Parameter_SCE_HANDLE <> "" Then SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, False, 0)
	$Parameter_SCE_HANDLE = ""
	GUISetState(@SW_HIDE, $ParameterEditor_GUI)
EndFunc   ;==>_Hide_Parameter_Editor


Func _Parameter_Editor_Listview_select_row()
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	$Parameter_Editor_Laedt_gerade_text = 1
	If _GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 0) <> _Get_langstr(1359) Or _GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 0) <> _Get_langstr(1360) Then SendMessage($ParameterEditor_SCIEditor, $SCI_SETREADONLY, False, 0)
	Sci_DelLines($ParameterEditor_SCIEditor)
	If $autoit_editor_encoding = "2" Then
		SCI_SetText($ParameterEditor_SCIEditor, _UNICODE2ANSI(_GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 1)))
	Else
		SCI_SetText($ParameterEditor_SCIEditor, _GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 1))
	EndIf
	SendMessage($ParameterEditor_SCIEditor, $SCI_COLOURISE, 0, -1) ;Redraw the lexer
	If _GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 0) = _Get_langstr(1359) Or _GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 0) = _Get_langstr(1360) Then SendMessage($ParameterEditor_SCIEditor, $SCI_SETREADONLY, True, 0)
	_WinAPI_SetFocus($ParameterEditor_SCIEditor)
	Sci_SetCurrentPos($ParameterEditor_SCIEditor, SCI_GetTextLen($ParameterEditor_SCIEditor))
	$Parameter_Editor_Laedt_gerade_text = 0
EndFunc   ;==>_Parameter_Editor_Listview_select_row

Func _Parameter_Editor_Listview_select_nextrow()
	If $Offenes_Projekt = "" Then Return
	If SendMessage($ParameterEditor_SCIEditor, $SCI_AUTOCACTIVE, 0, 0) Then Return
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	$Current_Row = _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView)
	$Next_Row = $Current_Row + 1
	If $Next_Row > _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1 Then $Next_Row = 0 ;Von vorne beginnen
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, $Next_Row, True, True)
	_GUICtrlListView_SetSelectionMark($ParameterEditor_ListView, $Next_Row)
	_GUICtrlListView_EnsureVisible($ParameterEditor_ListView, $Next_Row)
	_Parameter_Editor_Listview_select_row()
EndFunc   ;==>_Parameter_Editor_Listview_select_nextrow



Func _Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden($listview = "", $start = 0)
	For $x = $start To _GUICtrlListView_GetItemCount($listview) - 1
		If _GUICtrlListView_GetItemText($listview, $x, 1) <> "" Then Return True
	Next
	Return False
EndFunc   ;==>_Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden


Func _Parameter_Editor_Aktualisiere_Vorschaulabel()
	AdlibUnRegister("_Parameter_Editor_Aktualisiere_Vorschaulabel")
	$Fertige_Parameter = ""
	$Curent_CE_Line = 0

	For $x = 0 To _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1
		If $x = _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) Then
			StringReplace($Fertige_Parameter, @CRLF, "")
			$Curent_CE_Line = @extended
		EndIf
		$Parameter_Abtrennung = ", "
		If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 0) = _Get_langstr(1359) Then
			$Fertige_Parameter = StringStripWS($Fertige_Parameter, 2) & " _" & @CRLF
			ContinueLoop
		EndIf

		If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 0) = _Get_langstr(1360) Then
			$Fertige_Parameter = StringStripWS($Fertige_Parameter, 2) & " & _" & @CRLF
			ContinueLoop
		EndIf

		$Befehl = _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 1)
		If $Befehl = "" Then
			If _Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden($ParameterEditor_ListView, $x) Then
				$Fertige_Parameter = $Fertige_Parameter & "-1" & $Parameter_Abtrennung
				ContinueLoop
			Else
				ContinueLoop
			EndIf
		EndIf

		If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x + 1, 0) = _Get_langstr(1360) Then $Parameter_Abtrennung = ""
		$Fertige_Parameter = $Fertige_Parameter & $Befehl & $Parameter_Abtrennung
	Next
	If StringRight($Fertige_Parameter, 2) = ", " Then $Fertige_Parameter = StringTrimRight($Fertige_Parameter, 2)
;~ $Fertige_Parameter = StringReplace($Fertige_Parameter,@crlf,"")
;~ $Fertige_Parameter = StringReplace($Fertige_Parameter,@lf,"")
;~ $Fertige_Parameter = StringReplace($Fertige_Parameter,@cr,"")
;~ 	GUICtrlSetData($ParameterEditor_Vorschau_Fertiger_Befehl_Label, GUICtrlRead($ParameterEditor_ParameterTitel) & "(" & $Fertige_Parameter & ")")
	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETREADONLY, False, 0)


	If $autoit_editor_encoding = "2" Then
		SCI_SetText($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, _UNICODE2ANSI(GUICtrlRead($ParameterEditor_ParameterTitel) & "(" & $Fertige_Parameter & ")"))
	Else
		SCI_SetText($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, GUICtrlRead($ParameterEditor_ParameterTitel) & "(" & $Fertige_Parameter & ")")
	EndIf
	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_COLOURISE, 0, -1) ;Redraw the lexer
	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETREADONLY, True, 0)

	;Jump to line
;~     if _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) <> -1 Then
;~     $txt = _GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 1)
;~ 	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETSEARCHFLAGS, $SCFIND_REGEXP + $SCFIND_POSIX, 0)
;~ 	$pos = Sci_Search($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $txt, Sci_GetLineStartPos($ParameterEditor_Vorschau_Fertiger_Befehl_SCE,$Curent_CE_Line-1), 0)
;~ 	$line = Sci_GetLineFromPos($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $Pos)
;~ 	$start = SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_GETTARGETSTART, 0, 0) ;
;~     $end = SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_GETTARGETEND, 0, 0)
;~ 	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETYCARETPOLICY, $CARET_EVEN+$CARET_STRICT, 0)
;~ 	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETXCARETPOLICY, $CARET_EVEN+$CARET_STRICT, 0)
;~     SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0) ;
;~ 	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_GOTOLINE, $line, 0)
;~ 	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETYCARETPOLICY, 0, 0)
;~ 	SendMessage($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, $SCI_SETXCARETPOLICY, 0, 0)
;~ 	Endif

EndFunc   ;==>_Parameter_Editor_Aktualisiere_Vorschaulabel

Func _Parameter_Editor_Parameter_hinzufuegen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlListView_GetItemCount($ParameterEditor_ListView) > 249 Then Return ;Max 250 Parameter
	_GUICtrlListView_AddItem($ParameterEditor_ListView, _Get_langstr(1041) & " " & _GUICtrlListView_GetItemCount($ParameterEditor_ListView) + 1)
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1, True, True)
	_GUICtrlListView_SetSelectionMark($ParameterEditor_ListView, _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1)
	_GUICtrlListView_EnsureVisible($ParameterEditor_ListView, _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1)
	_Parameter_Editor_Listview_select_row()
EndFunc   ;==>_Parameter_Editor_Parameter_hinzufuegen

Func _Parameter_Editor_Parameter_add_Parameter_Break()
	If $Offenes_Projekt = "" Then Return
	$index_to_insert = 0
	If _GUICtrlListView_GetItemCount($ParameterEditor_ListView) = 0 Then Return
	If _GUICtrlListView_GetItemCount($ParameterEditor_ListView) > 249 Then Return ;Max 250 Parameter
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) <> -1 Then $index_to_insert = _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView)
	If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert, 0) = _Get_langstr(1359) Or _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert + 1, 0) = _Get_langstr(1359) Or $index_to_insert + 1 = _GUICtrlListView_GetItemCount($ParameterEditor_ListView) Then Return ;No multiple line breaks allowed!
	If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert, 0) = _Get_langstr(1360) Or _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert + 1, 0) = _Get_langstr(1360) Then Return ;No multiple line breaks allowed!
	$new_index = _GUICtrlListView_InsertItem($ParameterEditor_ListView, _Get_langstr(1359), $index_to_insert + 1)
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, $new_index, True, True)
	_GUICtrlListView_SetSelectionMark($ParameterEditor_ListView, $new_index)
	_GUICtrlListView_EnsureVisible($ParameterEditor_ListView, $new_index)
	_Parameter_Editor_Listview_select_row()
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Parameter_add_Parameter_Break

Func _Parameter_Editor_Parameter_add_Line_Break()
	If $Offenes_Projekt = "" Then Return
	$index_to_insert = 0
	If _GUICtrlListView_GetItemCount($ParameterEditor_ListView) = 0 Then Return
	If _GUICtrlListView_GetItemCount($ParameterEditor_ListView) > 249 Then Return ;Max 250 Parameter
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) <> -1 Then $index_to_insert = _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView)
	If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert, 0) = _Get_langstr(1359) Or _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert + 1, 0) = _Get_langstr(1359) Or $index_to_insert + 1 = _GUICtrlListView_GetItemCount($ParameterEditor_ListView) Then Return ;No multiple line breaks allowed!
	If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert, 0) = _Get_langstr(1360) Or _GUICtrlListView_GetItemText($ParameterEditor_ListView, $index_to_insert + 1, 0) = _Get_langstr(1360) Then Return ;No multiple line breaks allowed!
	$new_index = _GUICtrlListView_InsertItem($ParameterEditor_ListView, _Get_langstr(1360), $index_to_insert + 1)
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, $new_index, True, True)
	_GUICtrlListView_SetSelectionMark($ParameterEditor_ListView, $new_index)
	_GUICtrlListView_EnsureVisible($ParameterEditor_ListView, $new_index)
	_Parameter_Editor_Listview_select_row()
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Parameter_add_Line_Break


Func _Parameter_Editor_Markierten_Parameter_leeren()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	_GUICtrlListView_SetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), "", 1)
	SCI_SetText($ParameterEditor_SCIEditor, "")
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Markierten_Parameter_leeren

Func _Parameter_Editor_Parameter_entfernen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	_GUICtrlListView_DeleteItem($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView))
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), True, True)
	_Parameter_Editor_Listview_select_row()
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Parameter_entfernen

Func _Parameter_Editor_Alle_Parameter_leeren()
	If $Offenes_Projekt = "" Then Return
	For $x = 0 To _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1
		_GUICtrlListView_SetItemText($ParameterEditor_ListView, $x, "", 1)
	Next
	SCI_SetText($ParameterEditor_SCIEditor, "")
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Alle_Parameter_leeren

Func _Parameter_Editor_OK()
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If $Parameter_SCE_HANDLE <> "" Then SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, False, 0) ;Editor wieder freigeben
		Sci_SetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Parameter_Editor_Startpos, $Parameter_Editor_Endpos)
		$Fertige_Parameter = ""
		For $x = 0 To _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1
			$Parameter_Abtrennung = ", "
			If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 0) = _Get_langstr(1359) Then
				$Fertige_Parameter = StringStripWS($Fertige_Parameter, 2) & " _" & @CRLF
				ContinueLoop
			EndIf

			If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 0) = _Get_langstr(1360) Then
				$Fertige_Parameter = StringStripWS($Fertige_Parameter, 2) & " & _" & @CRLF
				ContinueLoop
			EndIf


			$Befehl = _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 1)
			If $Befehl = "" Then
				If _Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden($ParameterEditor_ListView, $x) Then
					$Fertige_Parameter = $Fertige_Parameter & "-1" & $Parameter_Abtrennung
					ContinueLoop
				Else
					ContinueLoop
				EndIf
			EndIf

			If _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x + 1, 0) = _Get_langstr(1360) Then $Parameter_Abtrennung = ""
			$Fertige_Parameter = $Fertige_Parameter & $Befehl & $Parameter_Abtrennung
		Next
		If StringRight($Fertige_Parameter, 2) = ", " Then $Fertige_Parameter = StringTrimRight($Fertige_Parameter, 2)
		$Fertige_Parameter = "(" & $Fertige_Parameter & ")"

		If $autoit_editor_encoding = "2" Then
			Sci_ReplaceSel($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], _UNICODE2ANSI($Fertige_Parameter))
		Else
			Sci_ReplaceSel($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertige_Parameter)
		EndIf

	EndIf
	_ISNTooltip_Timer_Hide_Tooltips()
	_Hide_Parameter_Editor()
	_Check_Buttons(0)
EndFunc   ;==>_Parameter_Editor_OK

Func _String_is_unique($str = "")
	If $str = "" Then Return False
	$StringLen = StringLen($str)
	If $StringLen < 2 Then Return False
	$last_char = StringMid($str, 1, 1)
	For $x = 1 To $StringLen
		If StringMid($str, $x, 1) <> $last_char Then Return True
		$last_char = StringMid($str, 1, 1)
	Next
	Return False
EndFunc   ;==>_String_is_unique


Func _Parameter_Editor_Contextmenue()
	If $Offenes_Projekt = "" Then Return
	If $Tools_Parameter_Editor_aktiviert = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return
	$Aktuelles_Wort_Doppelclick = SCI_GetCurrentWordEx($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Aktuelles_Wort_Doppelclick = StringStripWS($Aktuelles_Wort_Doppelclick, 3)
	$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, "(", "")
	$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, ")", "")
	If _Pruefe_Doppelklickwort_im_Skripteditor($Aktuelles_Wort_Doppelclick, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_WORDENDPOSITION, Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), 1)) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1344), 0, $studiofenster)
	EndIf
EndFunc   ;==>_Parameter_Editor_Contextmenue

Func _Kompilieren_Datei_Analysieren_und_Zielpfade_herausfinden($Datei = "")
	If $Datei = "" Then Return
	Dim $Datei_Array
	_FileReadToArray($Datei, $Datei_Array)
	If Not IsArray($Datei_Array) Then Return
	Local $Gefundener_Zielpfad = ""
	For $x = 0 To UBound($Datei_Array) - 1
		$str = $Datei_Array[$x]
		If StringInStr($str, "#AutoIt3Wrapper_Outfile") And $Gefundener_Zielpfad = "" Then $Gefundener_Zielpfad = $Datei_Array[$x]
		If StringInStr($str, "#pragma compile(Out,") Then $Gefundener_Zielpfad = $Datei_Array[$x]
		If $x > 50 Then ExitLoop ;Nur die ersten 50 Zeilen der Datei Analysieren
	Next

	;Pfade richtigstellen
	If StringInStr($Gefundener_Zielpfad, "#pragma compile(Out,") Then ;Pragma
		$Gefundener_Zielpfad = StringReplace($Gefundener_Zielpfad, "#pragma compile(Out,", "")
		If StringRight($Gefundener_Zielpfad, 1) = ")" Then $Gefundener_Zielpfad = StringTrimRight($Gefundener_Zielpfad, 1)
		$Gefundener_Zielpfad = StringStripWS($Gefundener_Zielpfad, 3)
		$Gefundener_Zielpfad = _PathFull($Gefundener_Zielpfad, $Offenes_Projekt)
	EndIf

	If StringInStr($Gefundener_Zielpfad, "#AutoIt3Wrapper_Outfile") Then ;Au3Wrapper

		$Gefundener_Zielpfad = StringTrimLeft($Gefundener_Zielpfad, StringInStr($Gefundener_Zielpfad, "="))
		$Gefundener_Zielpfad = StringStripWS($Gefundener_Zielpfad, 3)
		$Gefundener_Zielpfad = _PathFull($Gefundener_Zielpfad, $Offenes_Projekt)
	EndIf

	Return $Gefundener_Zielpfad
EndFunc   ;==>_Kompilieren_Datei_Analysieren_und_Zielpfade_herausfinden



; #FUNCTION# ====================================================================================================================
; Name ..........: _Finde_Element_im_Skript
; Description ...: Findet Elemente im aktuell geöffnetem Skript. (zb. Funktionen oder Variablen) Wird zb. verwendet beim Doppelklick auf ein Element im Skriptbaum.
;				   Wird die Funktion mit den selben Parametern erneut aufgerufen, wird nach dem nächsten Element gesucht.
; Syntax ........: _Finde_Element_im_Skript([, $name="" [, $mode=""]])
; Parameters ....: $name                - [optional] Name des Elements das gefunden werden soll. (zb. $array)
;                  $mode                - [optional] Type des Elements das gefunden werden soll. (zb. global)
; Return values .: Gibt die Position des gefundenen Elements zurück. -1 wenn nichts gefunden wurde.
; Author ........: ISI360
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Finde_Element_im_Skript($name = "", $mode = "")
	If $mode = "" Then Return
	If $name = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $Startposition_der_Suche = 0
	If $autoit_editor_encoding = "2" Then $name = _UNICODE2ANSI($name)
	$name = StringReplace($name, "\", ".")
	$name = StringReplace($name, "(", "")
	$name = StringReplace($name, "$", "")
	$name = StringStripWS($name, 3)
	If $Finde_Element_im_Skript_letztes_Wort <> $name Then
		$Startposition_der_Suche = 0
		$Finde_Element_im_Skript_letztes_Wort = $name
	Else
		$Startposition_der_Suche = $Finde_Element_im_Skript_letzte_Position
	EndIf

	Switch $mode

		Case "func"
			$name = "func " & $name & "\s*\([^(]"

		Case "global"
			$name = "global[^(]*\<" & $name & "\>"

		Case "local"
			$name = "local[^(]*\<" & $name & "\>"

		Case "region"
			$name = "#region\s*" & $name

		Case "include"
			$name = "#include\s*" & $name

	EndSwitch

	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEARCHFLAGS, $SCFIND_REGEXP + $SCFIND_POSIX, 0) ;Setze Flags für die Suche

	$found = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $name, $Startposition_der_Suche)
	If $found = -1 Then
		$Startposition_der_Suche = 0 ;Reset wenn nicht mehr gefunden wurde
		$Finde_Element_im_Skript_letzte_Position = 0 ;Reset wenn nicht mehr gefunden wurde
		$found = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $name, $Startposition_der_Suche) ;Von vorne beginnen
		If $found = -1 Then Return $found ;falls nichts gefunden stoppe aktion...
	EndIf

	$Finde_Element_im_Skript_letzte_Position = Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found))



	Return $found
EndFunc   ;==>_Finde_Element_im_Skript



Func _Element_im_Skript_besitzt_Kommentar($name = "", $mode = "")

	If $mode = "" Then Return
	If $name = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	;Zuerst suche das Element im Skript
	$Position = _Finde_Element_im_Skript($name, $mode)
	If $Position = -1 Then Return False

	;Text aus Zeile holen
	$Text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position))

	Switch $mode

		Case "func"
			;Prüfe ob ein UDF Header mit Kommentar existiert
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEARCHFLAGS, $SCFIND_REGEXP + $SCFIND_POSIX, 0) ;Setze Flags für die Suche
			$found = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], ";(.*?)Name(.*?)" & $name, 0)
			If $found <> -1 Then
				;Suche Description Bereich
				$found2 = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], ";(.*?)Description(.*?)", $found)
				If $found2 = -1 Then Return False
				$Description_text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2))
				$Description_text = StringRegExpReplace($Description_text, "(.*?):", "")
				$Description_text = StringStripWS($Description_text, 3)
				If $Description_text <> "" Then Return True
			EndIf


		Case Else
			;Prüfen ob ein Kommentar hinter dem Element gefunden wurde
			$res = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSTYLEAT, Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position)) + StringInStr($Text, ";", 0, -1), 0)
			If $res = $SCE_AU3_COMMENT Or $res = $SCE_AU3_COMMENTBLOCK Then Return True
	EndSwitch

	Return False ;Kein Kommentar gefunden
EndFunc   ;==>_Element_im_Skript_besitzt_Kommentar



Func _Pruefe_ob_Richtiger_UDF_Header_gefunden_wurde($startpos = "", $name = "", $handle = "")
	$line = Sci_GetLineFromPos($handle, $startpos)
	While 1
		$Text = Sci_GetLine($handle, $line)
		If StringInStr($Text, "; #FUNCTION#") Then Return False
		If StringInStr($Text, $name) Then Return True
		$line = $line - 1 ;suche nach oben
		If $line < 1 Then ExitLoop
	WEnd
	Return False
EndFunc   ;==>_Pruefe_ob_Richtiger_UDF_Header_gefunden_wurde

Func _show_comment_from_scripttree($SCE = "", $name = "", $mode = 0)
	If $SCE = "" Then Return
	If $name = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$SCE = HWnd($SCE)

	;Suche das Element im Skript
	$Position = _Finde_Element_im_Skript($name, $mode)
	If $Position = -1 Then Return False
	If $autoit_editor_encoding = "2" Then $name = _UNICODE2ANSI($name)
	;Text aus Zeile holen
	$Text = Sci_GetLine($SCE, Sci_GetLineFromPos($SCE, $Position))

	Switch $mode

		Case "func"
			;Prüfe ob ein UDF Header mit Kommentar existiert
			SendMessage($SCE, $SCI_SETSEARCHFLAGS, $SCFIND_REGEXP + $SCFIND_POSIX, 0) ;Setze Flags für die Suche
			$found = Sci_Search($SCE, ";(.*?)Name(.*?)" & $name, 0)
			If $found <> -1 Then
				;Suche Description Bereich
				$found2 = Sci_Search($SCE, ";(.*?)Description(.*?)", $found)
				If $found2 = -1 Then Return False
				If _Pruefe_ob_Richtiger_UDF_Header_gefunden_wurde($found2, $name, $SCE) = False Then
					MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1146), 0, $Studiofenster)
					Return False
				EndIf
				$Description_text = Sci_GetLine($SCE, Sci_GetLineFromPos($SCE, $found2))
				$Description_text = StringRegExpReplace($Description_text, "(.*?):", "")
				$Description_text = StringStripWS($Description_text, 3)
				If $Description_text = "" Then
					Sci_SetCurrentPos($SCE, Sci_GetLineEndPos($SCE, Sci_GetLineFromPos($SCE, $found2)))
				Else
					$startpos = Sci_GetLineStartPos($SCE, Sci_GetLineFromPos($SCE, $found2))
					If StringInStr(Sci_GetLine($SCE, Sci_GetLineFromPos($SCE, $found2)), ": ") Then
						$startpos = $startpos + StringInStr(Sci_GetLine($SCE, Sci_GetLineFromPos($SCE, $found2)), ": ") + 1
					Else
						$startpos = $startpos + StringInStr(Sci_GetLine($SCE, Sci_GetLineFromPos($SCE, $found2)), ":")
					EndIf

					Sci_SetSelection($SCE, $startpos, Sci_GetLineEndPos($SCE, Sci_GetLineFromPos($SCE, $found2)))

				EndIf
				_WinAPI_SetFocus($SCE)
			Else
				$funcname = $name
				If $autoit_editor_encoding = "2" Then $funcname = _ANSI2UNICODE($funcname)
				$res = MsgBox(262144 + 32 + 4, _Get_langstr(25), StringReplace(_Get_langstr(1147), "%1", $funcname), 0, $Studiofenster)
				If @error Then Return
				If $res = 6 Then
					$findfunc = _Finde_Element_im_Skript($funcname, "func")
					If $findfunc <> -1 Then
						Sci_SetCurrentPos($SCE, $findfunc)
						_Erstelle_UDF_Header()
						Sleep(100)
						_show_comment_from_scripttree($SCE, $name, $mode)
					EndIf
					Return
				EndIf
			EndIf


		Case Else
			;Prüfen ob ein Kommentar hinter dem Element gefunden wurde
			$res = SendMessage($SCE, $SCI_GETSTYLEAT, Sci_GetLineStartPos($SCE, Sci_GetLineFromPos($SCE, $Position)) + StringInStr($Text, ";", 0, -1), 0)
			If $res = $SCE_AU3_COMMENT Or $res = $SCE_AU3_COMMENTBLOCK Then
				Sci_SetSelection($SCE, $Position + StringInStr($Text, ";", 0, -1), Sci_GetLineEndPos($SCE, Sci_GetLineFromPos($SCE, $Position)))
				_WinAPI_SetFocus($SCE)
				Return True
			Else
				Sci_SetCurrentPos($SCE, Sci_GetLineEndPos($SCE, Sci_GetLineFromPos($SCE, $Position)))
				_WinAPI_SetFocus($SCE)
				Return True
			EndIf
	EndSwitch


	Return False
EndFunc   ;==>_show_comment_from_scripttree

Func _SCI_Funcname_aus_Position($sci = "")
	If $sci = "" Then Return

	$word = ""
	$Pos = Sci_GetCurrentPos($sci)
	$SCI_TextZeile = Sci_GetLine($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci)))
	$SCI_Startpos = Sci_GetLineStartPos($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci)))
	$Pos_in_Line = $Pos - $SCI_Startpos
	$closecount = 0
	For $count = $Pos_in_Line - 1 To 0 Step -1
		$char = Sci_GetChar($sci, $SCI_Startpos + $count)
		If $char = ")" Then $closecount = $closecount + 1
		If $char = "(" Then
			If $closecount <> 0 Then
				$closecount = $closecount - 1
				ContinueLoop
			EndIf
			$word = SCI_GetWordFromPos($sci, ($SCI_Startpos + $count) - 1, 1)
			$word = StringStripWS($word, 3)
			$_SCI_Funcname_aus_Position_found_pos = SendMessage($sci, $SCI_WORDSTARTPOSITION, ($SCI_Startpos + $count) - 1, 1)
			ExitLoop
		EndIf
	Next

	Return $word
EndFunc   ;==>_SCI_Funcname_aus_Position

Func _Elemente_an_Fesntergroesse_anpassen_Startup()
	_Elemente_an_Fesntergroesse_anpassen("-2")
EndFunc   ;==>_Elemente_an_Fesntergroesse_anpassen_Startup



Func _Elemente_an_Fesntergroesse_anpassen($HWNhandle = "")
	Local $Event_GUI_Handle ;If $Event_GUI_Handle is set to "-2" then every GUI will be resized
	If IsDeclared("HWNhandle") Then
		$Event_GUI_Handle = $HWNhandle
	Else
		$Event_GUI_Handle = @GUI_WinHandle
	EndIf


	;In Dateien Suchen
	If $Event_GUI_Handle = $in_ordner_nach_text_suchen_gui Or $Event_GUI_Handle = "-2" Then
		$in_dateien_suchen_gefundene_elemente_listview_Pos_Array = ControlGetPos($in_ordner_nach_text_suchen_gui, "", $in_dateien_suchen_gefundene_elemente_listview)
		If Not IsArray($in_dateien_suchen_gefundene_elemente_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($in_dateien_suchen_gefundene_elemente_listview, 0, ($in_dateien_suchen_gefundene_elemente_listview_Pos_Array[2] / 100) * 59)
		_GUICtrlListView_SetColumnWidth($in_dateien_suchen_gefundene_elemente_listview, 1, ($in_dateien_suchen_gefundene_elemente_listview_Pos_Array[2] / 100) * 8)
		_GUICtrlListView_SetColumnWidth($in_dateien_suchen_gefundene_elemente_listview, 2, ($in_dateien_suchen_gefundene_elemente_listview_Pos_Array[2] / 100) * 30)
		_CenterOnMonitor($ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft_gui, "", $Runonmonitor)
	EndIf

	;Liste aller Projekte am Startfenster
	If $Event_GUI_Handle = $Welcome_GUI Or $Event_GUI_Handle = "-2" Then
		$Projects_Listview_Pos_Array = ControlGetPos($Welcome_GUI, "", $Projects_Listview)
		If Not IsArray($Projects_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Projects_Listview, 0, ($Projects_Listview_Pos_Array[2] / 100) * 90)
	EndIf

	;Skins Liste in Programmeinstellungen
	If $Event_GUI_Handle = $Config_GUI Or $Event_GUI_Handle = "-2" Then
		_ISNSettings_Repos_Configpage()


		$Skins_Listview_Pos_Array = ControlGetPos($ISNSettings_Skins_Page, "", $config_skin_list)
		If Not IsArray($Skins_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($config_skin_list, 0, ($Skins_Listview_Pos_Array[2] / 100) * 50)
		_GUICtrlListView_SetColumnWidth($config_skin_list, 1, ($Skins_Listview_Pos_Array[2] / 100) * 44)

		;Toolbar Listen in den Programmeinstellungen
		$einstellungen_toolbar_aktiveelemente_listview_Pos_Array = ControlGetPos($ISNSettings_Toolbar_Page, "", $einstellungen_toolbar_aktiveelemente_listview)
		If Not IsArray($einstellungen_toolbar_aktiveelemente_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($einstellungen_toolbar_aktiveelemente_listview, 0, ($einstellungen_toolbar_aktiveelemente_listview_Pos_Array[2] / 100) * 93)

		$einstellungen_toolbar_verfuegbareelemente_listview_Pos_Array = ControlGetPos($ISNSettings_Toolbar_Page, "", $einstellungen_toolbar_verfuegbareelemente_listview)
		If Not IsArray($einstellungen_toolbar_verfuegbareelemente_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($einstellungen_toolbar_verfuegbareelemente_listview, 0, ($einstellungen_toolbar_verfuegbareelemente_listview_Pos_Array[2] / 100) * 93)


		;Includesliste in den Programmeinstellungen
		$Einstellungen_AutoItIncludes_Verwalten_Listview_Pos_Array = ControlGetPos($ISNSettings_Includes_Page, "", $Einstellungen_AutoItIncludes_Verwalten_Listview)
		If Not IsArray($Einstellungen_AutoItIncludes_Verwalten_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Einstellungen_AutoItIncludes_Verwalten_Listview, 0, ($Einstellungen_AutoItIncludes_Verwalten_Listview_Pos_Array[2] / 100) * 96)

		;QuickView Lists
		$settings_quickview_ActiveElements_Listview_Pos_Array = ControlGetPos($ISNSettings_QuickView_Page, "", $settings_quickview_ActiveElements_Listview)
		If Not IsArray($settings_quickview_ActiveElements_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($settings_quickview_ActiveElements_Listview, 0, ($settings_quickview_ActiveElements_Listview_Pos_Array[2] / 100) * 93)

		$settings_quickview_AvailableElements_Listview_Pos_Array = ControlGetPos($ISNSettings_QuickView_Page, "", $settings_quickview_AvailableElements_Listview)
		If Not IsArray($settings_quickview_AvailableElements_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($settings_quickview_AvailableElements_Listview, 0, ($settings_quickview_AvailableElements_Listview_Pos_Array[2] / 100) * 93)


		;Dateitypenliste in den Programmeinstellungen
		$Einstellungen_Skripteditor_Dateitypen_Listview_Pos_Array = ControlGetPos($ISNSettings_FileTypes_Page, "", $Einstellungen_Skripteditor_Dateitypen_Listview)
		If Not IsArray($Einstellungen_Skripteditor_Dateitypen_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Einstellungen_Skripteditor_Dateitypen_Listview, 0, ($Einstellungen_Skripteditor_Dateitypen_Listview_Pos_Array[2] / 100) * 96)


		;APIliste in den Programmeinstellungen
		$Einstellungen_API_Listview_Pos_Array = ControlGetPos($ISNSettings_APIs_Page, "", $Einstellungen_API_Listview)
		If Not IsArray($Einstellungen_API_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Einstellungen_API_Listview, 0, ($Einstellungen_API_Listview_Pos_Array[2] / 100) * 96)

		$Einstellungen_Properties_Listview_Pos_Array = ControlGetPos($ISNSettings_APIs_Page, "", $Einstellungen_Properties_Listview)
		If Not IsArray($Einstellungen_Properties_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Einstellungen_Properties_Listview, 0, ($Einstellungen_Properties_Listview_Pos_Array[2] / 100) * 96)


		;Hotkeysliste in den Programmeinstellungen
		$settings_hotkeylistview_Pos_Array = ControlGetPos($ISNSettings_Hotkeys_Page, "", $settings_hotkeylistview)
		If Not IsArray($settings_hotkeylistview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($settings_hotkeylistview, 0, ($settings_hotkeylistview_Pos_Array[2] / 100) * 53)
		_GUICtrlListView_SetColumnWidth($settings_hotkeylistview, 1, ($settings_hotkeylistview_Pos_Array[2] / 100) * 44)

		;Pluginsliste in den Programmeinstellungen
		$Pugins_Listview_Pos_Array = ControlGetPos($ISNSettings_Plugins_Page, "", $Pugins_Listview)
		If Not IsArray($Pugins_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Pugins_Listview, 0, ($Pugins_Listview_Pos_Array[2] / 100) * 35)
		_GUICtrlListView_SetColumnWidth($Pugins_Listview, 1, ($Pugins_Listview_Pos_Array[2] / 100) * 8)
		_GUICtrlListView_SetColumnWidth($Pugins_Listview, 2, ($Pugins_Listview_Pos_Array[2] / 100) * 42)
		_GUICtrlListView_SetColumnWidth($Pugins_Listview, 3, ($Pugins_Listview_Pos_Array[2] / 100) * 10)

	EndIf



	;Additional program paths in the settings
	If $Event_GUI_Handle = $settings_additional_project_paths_GUI Or $Event_GUI_Handle = "-2" Then
		$settings_additional_project_paths_listview_Pos_Array = ControlGetPos($settings_additional_project_paths_GUI, "", $settings_additional_project_paths_listview)
		If Not IsArray($settings_additional_project_paths_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($settings_additional_project_paths_listview, 0, ($settings_additional_project_paths_listview_Pos_Array[2] / 100) * 94)
	EndIf

	;Listen in der Projektverwaltung
	If $Event_GUI_Handle = $projectmanager Or $Event_GUI_Handle = "-2" Then
		$Projects_Listview_projectman_Pos_Array = ControlGetPos($projectmanager, "", $Projects_Listview_projectman)
		If Not IsArray($Projects_Listview_projectman_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Projects_Listview_projectman, 0, ($Projects_Listview_projectman_Pos_Array[2] / 100) * 45)
		_GUICtrlListView_SetColumnWidth($Projects_Listview_projectman, 1, ($Projects_Listview_projectman_Pos_Array[2] / 100) * 20)
		_GUICtrlListView_SetColumnWidth($Projects_Listview_projectman, 2, ($Projects_Listview_projectman_Pos_Array[2] / 100) * 30)

		$Projektverwaltung_Projektdetails_Listview_Pos_Array = ControlGetPos($projectmanager, "", $Projektverwaltung_Projektdetails_Listview)
		If Not IsArray($Projektverwaltung_Projektdetails_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Projektverwaltung_Projektdetails_Listview, 0, ($Projektverwaltung_Projektdetails_Listview_Pos_Array[2] / 100) * 50)
		_GUICtrlListView_SetColumnWidth($Projektverwaltung_Projektdetails_Listview, 1, ($Projektverwaltung_Projektdetails_Listview_Pos_Array[2] / 100) * 44)

		$vorlagen_Listview_projectman_Pos_Array = ControlGetPos($projectmanager, "", $vorlagen_Listview_projectman)
		If Not IsArray($vorlagen_Listview_projectman_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($vorlagen_Listview_projectman, 0, ($vorlagen_Listview_projectman_Pos_Array[2] / 100) * 45)
		_GUICtrlListView_SetColumnWidth($vorlagen_Listview_projectman, 1, ($vorlagen_Listview_projectman_Pos_Array[2] / 100) * 49)
	EndIf


	;Listen in den Projekteinstellungen
	If $Event_GUI_Handle = $Projekteinstellungen_GUI Or $Event_GUI_Handle = "-2" Then
		$Project_Properties_listview_Pos_Array = ControlGetPos($Projekteinstellungen_GUI, "", $Project_Properties_listview)
		If Not IsArray($Project_Properties_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Project_Properties_listview, 0, ($Project_Properties_listview_Pos_Array[2] / 100) * 40)
		_GUICtrlListView_SetColumnWidth($Project_Properties_listview, 1, ($Project_Properties_listview_Pos_Array[2] / 100) * 56)

		$Projekteinstellungen_API_Listview_Pos_Array = ControlGetPos($Projekteinstellungen_GUI, "", $Projekteinstellungen_API_Listview)
		If Not IsArray($Projekteinstellungen_API_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Projekteinstellungen_API_Listview, 0, ($Projekteinstellungen_API_Listview_Pos_Array[2] / 100) * 96)
		_GUICtrlListView_SetColumnWidth($Projekteinstellungen_Proberties_Listview, 0, ($Projekteinstellungen_API_Listview_Pos_Array[2] / 100) * 96)
	EndIf

	;Liste in Makros
	If $Event_GUI_Handle = $ruleseditor Or $Event_GUI_Handle = "-2" Then
		$listview_projectrules_Pos_Array = ControlGetPos($ruleseditor, "", $listview_projectrules)
		If Not IsArray($listview_projectrules_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($listview_projectrules, 0, ($listview_projectrules_Pos_Array[2] / 100) * 85)
		_GUICtrlListView_SetColumnWidth($listview_projectrules, 1, ($listview_projectrules_Pos_Array[2] / 100) * 11)
	EndIf

	;Weitere Dateien kompilieren
	If $Event_GUI_Handle = $Weitere_Dateien_Kompilieren_GUI Or $Event_GUI_Handle = "-2" Then
		$Weitere_Dateien_Kompilieren_GUI_Listview_Pos_Array = ControlGetPos($Weitere_Dateien_Kompilieren_GUI, "", $Weitere_Dateien_Kompilieren_GUI_Listview)
		If Not IsArray($Weitere_Dateien_Kompilieren_GUI_Listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($Weitere_Dateien_Kompilieren_GUI_Listview, 0, ($Weitere_Dateien_Kompilieren_GUI_Listview_Pos_Array[2] / 100) * 93)

	EndIf

	;Makro auswählen
	If $Event_GUI_Handle = $Makro_auswaehlen_GUI Or $Event_GUI_Handle = "-2" Then
		$makro_auswaehlen_listview_Pos_Array = ControlGetPos($Makro_auswaehlen_GUI, "", $makro_auswaehlen_listview)
		If Not IsArray($makro_auswaehlen_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($makro_auswaehlen_listview, 0, ($makro_auswaehlen_listview_Pos_Array[2] / 100) * 84)
		_GUICtrlListView_SetColumnWidth($makro_auswaehlen_listview, 1, ($makro_auswaehlen_listview_Pos_Array[2] / 100) * 10)
	EndIf

	;Makro bearbeiten
	If $Event_GUI_Handle = $newrule_GUI Or $Event_GUI_Handle = "-2" Then
		$new_rule_triggerlist_Pos_Array = ControlGetPos($newrule_GUI, "", $new_rule_triggerlist)
		If Not IsArray($new_rule_triggerlist_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($new_rule_triggerlist, 0, ($new_rule_triggerlist_Pos_Array[2] / 100) * 90)

		$new_rule_actionlist_Pos_Array = ControlGetPos($newrule_GUI, "", $new_rule_actionlist)
		If Not IsArray($new_rule_actionlist_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($new_rule_actionlist, 0, ($new_rule_actionlist_Pos_Array[2] / 100) * 45)
		_GUICtrlListView_SetColumnWidth($new_rule_actionlist, 1, ($new_rule_actionlist_Pos_Array[2] / 100) * 49)
	EndIf

	;Änderungsprotokolle
	If $Event_GUI_Handle = $aenderungs_manager_GUI Or $Event_GUI_Handle = "-2" Then
		$changelogmanager_listview_Pos_Array = ControlGetPos($aenderungs_manager_GUI, "", $changelogmanager_listview)
		If Not IsArray($changelogmanager_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 0, ($changelogmanager_listview_Pos_Array[2] / 100) * 8)
		_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 1, ($changelogmanager_listview_Pos_Array[2] / 100) * 19)
		_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 2, ($changelogmanager_listview_Pos_Array[2] / 100) * 40)
		_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 3, ($changelogmanager_listview_Pos_Array[2] / 100) * 10)
		_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 4, ($changelogmanager_listview_Pos_Array[2] / 100) * 10)
		_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 5, ($changelogmanager_listview_Pos_Array[2] / 100) * 10)
	EndIf


	;Changelog generieren
	If $Event_GUI_Handle = $changelog_generieren_GUI Or $Event_GUI_Handle = "-2" Then
		$changelogenerieren_listview_Pos_Array = ControlGetPos($changelog_generieren_GUI, "", $changelogenerieren_listview)
		If Not IsArray($changelogenerieren_listview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 0, ($changelogenerieren_listview_Pos_Array[2] / 100) * 16)
		_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 2, ($changelogenerieren_listview_Pos_Array[2] / 100) * 45)
		_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 3, ($changelogenerieren_listview_Pos_Array[2] / 100) * 15)
		_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 5, ($changelogenerieren_listview_Pos_Array[2] / 100) * 18)
	EndIf

	;Funktion auswählen
	If $Event_GUI_Handle = $Funclist_GUI Or $Event_GUI_Handle = "-2" Then
		$FuncListview_Pos_Array = ControlGetPos($Funclist_GUI, "", $FuncListview)
		If Not IsArray($FuncListview_Pos_Array) Then Return
		_GUICtrlListView_SetColumnWidth($FuncListview, 0, ($FuncListview_Pos_Array[2] / 100) * 92)
	EndIf



EndFunc   ;==>_Elemente_an_Fesntergroesse_anpassen

Func _Parametereditor_Fenster_anpassen()
	AdlibUnRegister("_Parametereditor_Fenster_anpassen")
	;Parameter Editor
	$ParameterEditor_ListView_Pos_Array = ControlGetPos($ParameterEditor_GUI, "", $ParameterEditor_ListView)
	If Not IsArray($ParameterEditor_ListView_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($ParameterEditor_ListView, 0, ($ParameterEditor_ListView_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($ParameterEditor_ListView, 1, ($ParameterEditor_ListView_Pos_Array[2] / 100) * 49)

	$ParameterEditor_SCIEditor_dummy_Pos_Array = ControlGetPos($ParameterEditor_GUI, "", $ParameterEditor_SCIEditor_dummy)
	If Not IsArray($ParameterEditor_SCIEditor_dummy_Pos_Array) Then Return
	WinMove($ParameterEditor_SCIEditor, "", $ParameterEditor_SCIEditor_dummy_Pos_Array[0], $ParameterEditor_SCIEditor_dummy_Pos_Array[1], $ParameterEditor_SCIEditor_dummy_Pos_Array[2], $ParameterEditor_SCIEditor_dummy_Pos_Array[3])

	$ParameterEditor_Vorschau_Fertiger_Befehl_Dummy_Array = ControlGetPos($ParameterEditor_GUI, "", $ParameterEditor_Vorschau_Fertiger_Befehl_Dummy)
	If Not IsArray($ParameterEditor_Vorschau_Fertiger_Befehl_Dummy_Array) Then Return
	WinMove($ParameterEditor_Vorschau_Fertiger_Befehl_SCE, "", $ParameterEditor_Vorschau_Fertiger_Befehl_Dummy_Array[0], $ParameterEditor_Vorschau_Fertiger_Befehl_Dummy_Array[1], $ParameterEditor_Vorschau_Fertiger_Befehl_Dummy_Array[2], $ParameterEditor_Vorschau_Fertiger_Befehl_Dummy_Array[3])

EndFunc   ;==>_Parametereditor_Fenster_anpassen


Func _StringSize($sText, $iSize = 8.5, $iWeight = 400, $iAttrib = 0, $sName = "Arial", $iQuality = 2)
	Local Const $LOGPIXELSY = 90
	Local $fItalic = BitAND($iAttrib, 2)
	Local $hDC = _WinAPI_GetDC(0)
	Local $hFont = _WinAPI_CreateFont(-_WinAPI_GetDeviceCaps($hDC, $LOGPIXELSY) * $iSize / 72, 0, 0, 0, $iWeight, $fItalic, BitAND($iAttrib, 4), BitAND($iAttrib, 8), 0, 0, 0, $iQuality, 0, $sName)
	Local $hOldFont = _WinAPI_SelectObject($hDC, $hFont)
	Local $tSIZE
	If $fItalic Then $sText &= " "
	Local $iWidth, $iHeight
	Local $aArrayOfStrings = StringSplit($sText, @LF, 2)
	For $sString In $aArrayOfStrings
		$tSIZE = _WinAPI_GetTextExtentPoint32($hDC, $sString)
		If DllStructGetData($tSIZE, "X") > $iWidth Then $iWidth = DllStructGetData($tSIZE, "X")
		$iHeight += DllStructGetData($tSIZE, "Y")
	Next
	_WinAPI_SelectObject($hDC, $hOldFont)
	_WinAPI_DeleteObject($hFont)
	_WinAPI_ReleaseDC(0, $hDC)
	Local $aOut[2] = [$iWidth, $iHeight]
	Return $aOut
EndFunc   ;==>_StringSize

Func _ISN_Print_current_file()
	If $Offenes_Projekt = "" Then Return
	AdlibRegister("_ISN_Print_current_file_Adlib")
EndFunc   ;==>_ISN_Print_current_file

Func _ISN_Print_current_file_Adlib()
	AdlibUnRegister("_ISN_Print_current_file_Adlib")
	_Drucke_Datei($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)])
EndFunc   ;==>_ISN_Print_current_file_Adlib

Func _Drucke_Datei($SCI_Editor = "", $Dateipfad = "")
	If $SCI_Editor = "" Then Return
	If $Dateipfad = "" Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_SeiteDrucken) <> -1 Then Return ;Platzhalter für Plugin
	Dim $szDrive, $szDir, $szFName, $szExt
	$res = _PathSplit($Dateipfad, $szDrive, $szDir, $szFName, $szExt)

	GUICtrlSetData($Please_Wait_GUI_Title, _Get_langstr(1298))
	GUICtrlSetData($Please_Wait_GUI_Text, _Get_langstr(23))

	GUISetState(@SW_SHOW, $Please_Wait_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)

	If $szExt = "." & $Autoitextension Then
		_HTML_Datei_fuer_Druck_generieren($Arbeitsverzeichnis & "\Data\Cache\print.html", $SCI_Editor, $szFName & $szExt)
	Else
		_HTML_Datei_fuer_Druck_generieren($Arbeitsverzeichnis & "\Data\Cache\print.html", $SCI_Editor, $szFName & $szExt, 1)
	EndIf

	Local $Studiofenster_pos = WinGetPos($Studiofenster)
	If IsArray($Studiofenster_pos) Then WinMove($Druckvorschau_GUI, "", $Studiofenster_pos[0], $Studiofenster_pos[1], $Studiofenster_pos[2], $Studiofenster_pos[3])
	If IsObj($Druckvorschau_oIE) Then _IENavigate($Druckvorschau_oIE, $Arbeitsverzeichnis & "\Data\Cache\print.html")
	If IsObj($Druckvorschau_oIE) Then $Druckvorschau_oIE.execWB(7, 2)

	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $Please_Wait_GUI)


EndFunc   ;==>_Drucke_Datei




Func _HTML_Datei_fuer_Druck_generieren($Zielpfad = "", $SCI_Editor = "", $Dokumenttitel = "ISN AutoIt Studio", $Ohne_Styling = 0)

	Local $HTML_Datei_Inhalt = ""
	Local $Split = ""


	;Header und Styles
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<html xmlns="http://www.w3.org/1999/xhtm">' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<head>' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<title>' & $Dokumenttitel & '</title>' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<meta name="Generator" content="ISN AutoIt Studio - www.isnetwork.at" />' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & @CRLF


	If $Ohne_Styling <> 1 Then
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<style type="text/css">' & @CRLF
		;Style0 - AU3_DEFAULT
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S0 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE1b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE1a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style1 - AU3_COMMENT
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S1 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE2b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE2a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style2 - AU3_COMMENTBLOCK
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S2 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE3b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE3a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style3 - AU3_NUMBER
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S3 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE4b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE4a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style4 - AU3_FUNCTION
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S4 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE5b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE5a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style5 - AU3_KEYWORD
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S5 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE6b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE6a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style6 - AU3_MACRO
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S6 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE7b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE7a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style7 - AU3_STRING
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S7 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE8b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE8a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style8 - AU3_OPERATOR
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S8 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE9b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE9a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style9 - AU3_VARIABLE
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S9 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE10b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE10a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style10 - AU3_SENT
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S10 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE11b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE11a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style11 - AU3_PREPROCESSOR
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S11 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE12b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE12a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style12 - AU3_SPECIAL
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S12 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE13b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE13a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style13 - AU3_EXPAND
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S13 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE14b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE14a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style14 - AU3_COMOBJ
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S14 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE15b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE15a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style15 - AU3_UDF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S15 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE16b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE16a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Span
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & 'span {' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & "	font-family: '" & $scripteditor_font & "';" & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: #000000;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF



		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</style>' & @CRLF
	EndIf
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</head>' & @CRLF

	;HTML Body
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<body bgcolor="#FFFFFF">' & @CRLF


	Local $startpos = 0
	Local $Endpos = 0
	Local $Letzter_Style = ""
	Local $style_at_pos = ""
	$Endpos = Sci_GetLenght($SCI_Editor)


	;Falls im Editor etwas Markiert ist, nur Markierten Text ausgeben
	$startPosition = SendMessage($SCI_Editor, $SCI_GETSELECTIONSTART, 0, 0)
	$endPosition = SendMessage($SCI_Editor, $SCI_GETSELECTIONEND, 0, 0)
	If $startPosition <> $endPosition Then
		$startpos = $startPosition
		$Endpos = $endPosition - 1
	EndIf


	Local $Zeichenlimit = 0

	For $x = $startpos To $Endpos

		$Aktuelles_Zeichen = Sci_GetChar($SCI_Editor, $x)

		$Zeichenlimit = $Zeichenlimit + 1
		If $Zeichenlimit > 50000 Then ;Druck für max. 50.000 Zeichen limitieren
			GUISetState(@SW_ENABLE, $Studiofenster)
			GUISetState(@SW_HIDE, $Please_Wait_GUI)
			MsgBox(48 + 262144, _Get_langstr(394), StringReplace(_Get_langstr(1299), "%1", "50.000"), 0, $Studiofenster)
			ExitLoop
		EndIf



		If $Aktuelles_Zeichen = @CR Then
			If $Letzter_Style <> "" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & "</span> "
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & "<br /> " & @CRLF
			$Letzter_Style = ""
			ContinueLoop
		EndIf
		If $Aktuelles_Zeichen = @LF Then ContinueLoop
		If $Aktuelles_Zeichen = "" Then ContinueLoop
		$Aktuelles_Zeichen_html = Sci_GetChar_HTML($SCI_Editor, $x)


		$style_at_pos = String(SendMessage($SCI_Editor, $SCI_GETSTYLEAT, $x, 0))

		If $style_at_pos <> $Letzter_Style Then

			If $Letzter_Style <> "" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</span>'

			Switch $style_at_pos

				Case $SCE_AU3_DEFAULT
					$Letzter_Style = "0"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S0">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)


				Case $SCE_AU3_COMMENT
					$Letzter_Style = "1"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S1">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_COMMENTBLOCK
					$Letzter_Style = "2"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S2">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_NUMBER
					$Letzter_Style = "3"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S3">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_FUNCTION
					$Letzter_Style = "4"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S4">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_KEYWORD
					$Letzter_Style = "5"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S5">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_MACRO
					$Letzter_Style = "6"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S6">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_STRING
					$Letzter_Style = "7"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S7">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_OPERATOR
					$Letzter_Style = "8"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S8">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_VARIABLE
					$Letzter_Style = "9"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S9">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_SENT
					$Letzter_Style = "10"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S10">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_PREPROCESSOR
					$Letzter_Style = "11"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S11">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_SPECIAL
					$Letzter_Style = "12"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S12">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_EXPAND
					$Letzter_Style = "13"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S13">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_COMOBJ
					$Letzter_Style = "14"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S14">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_UDF
					$Letzter_Style = "15"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S15">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)
			EndSwitch

		Else
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)
		EndIf



		;Prüfe ob letzter Buchstabe ein Multibyte Char war und korrigiere $x
		$binary = _HexToBinaryString(StringToBinary($Aktuelles_Zeichen, 4))
		If StringLeft($binary, 2) = "11" Then $x = $x + 1
		If StringLeft($binary, 3) = "111" Then $x = $x + 1
		If StringLeft($binary, 4) = "1111" Then $x = $x + 1

	Next


	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</body>' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</html>' & @CRLF

	Local $HTML_Datei_Handle = FileOpen($Zielpfad, $FO_OVERWRITE + $FO_UTF8_NOBOM)
	If $HTML_Datei_Handle = -1 Then
		Return
	EndIf
	FileWrite($HTML_Datei_Handle, $HTML_Datei_Inhalt)
	FileClose($HTML_Datei_Handle)

EndFunc   ;==>_HTML_Datei_fuer_Druck_generieren


; Hex To Binary
Func _HexToBinaryString($HexValue)
	Local $Allowed = '0123456789ABCDEF'
	$HexValue = StringReplace($HexValue, "0x", "")
	Local $Test, $n
	Local $Result = ''
	If $HexValue = '' Then
		SetError(-2)
		Return
	EndIf

	$HexValue = StringSplit($HexValue, '')
	For $n = 1 To $HexValue[0]
		If Not StringInStr($Allowed, $HexValue[$n]) Then
			SetError(-1)
			Return 0
		EndIf
	Next

	Local $bits = "0000|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|1101|1110|1111"
	$bits = StringSplit($bits, '|')
	For $n = 1 To $HexValue[0]
		$Result &= $bits[Dec($HexValue[$n]) + 1]
	Next

	Return $Result

EndFunc   ;==>_HexToBinaryString

Func _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($char = "")
	$char = StringReplace($char, " ", "&nbsp;")
	$char = StringReplace($char, "<", "&lt;")
	$char = StringReplace($char, ">", "&gt;")
	$char = StringReplace($char, @TAB, "&emsp;")
	Return $char
EndFunc   ;==>_HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen

Func Sci_GetChar_HTML($sci, $Pos)
	If $autoit_editor_encoding = "1" Then
		Return Sci_GetChar($sci, $Pos)
	EndIf
	$binary = _HexToBinaryString(StringToBinary(Sci_GetChar($sci, $Pos), 4))
	If StringLeft($binary, 2) = "11" Then ;Multibyte Char
		$y = 2
		If StringLeft($binary, 2) = "11" Then $y = 2
		If StringLeft($binary, 3) = "111" Then $y = 3
		If StringLeft($binary, 4) = "1111" Then $y = 4
		Return _ANSI2UNICODE(SCI_GetTextRange($sci, $Pos, $Pos + $y))
	Else
		Return ChrW(SendMessage($sci, $SCI_GETCHARAT, $Pos, 0))
	EndIf
EndFunc   ;==>Sci_GetChar_HTML


Func _ISN_Projekt_Testen()
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 1 Then
		_Testscript($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"))
	Else
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
		If $GUICtrlTab_GetCurFocus = -1 Then Return
		If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then _Testscript($Datei_pfad[$GUICtrlTab_GetCurFocus])
	EndIf

EndFunc   ;==>_ISN_Projekt_Testen

Func _ISN_Skript_Testen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then _Testscript($Datei_pfad[$GUICtrlTab_GetCurFocus]) ;Skript Testen
EndFunc   ;==>_ISN_Skript_Testen

Func _ISN_aktuellen_Tab_schliessen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	try_to_Close_Tab($GUICtrlTab_GetCurFocus) ;Close Tab
EndFunc   ;==>_ISN_aktuellen_Tab_schliessen

Func _ISN_Tidy_aktuellen_Tab()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	_Tidy($Datei_pfad[$GUICtrlTab_GetCurFocus]) ;TidySource
EndFunc   ;==>_ISN_Tidy_aktuellen_Tab

Func _ISN_aktuellen_Tab_speichern()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	_try_to_save_file($GUICtrlTab_GetCurFocus)
EndFunc   ;==>_ISN_aktuellen_Tab_speichern


Func _ISN_Syntaxcheck_aktuellen_Tab()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	_Syntaxcheck($Datei_pfad[$GUICtrlTab_GetCurFocus]) ;syntaxcheck
EndFunc   ;==>_ISN_Syntaxcheck_aktuellen_Tab

Func _ISN_Projekt_Testen_ohne_Parameter()
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 1 Then
		_Testscript($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"), 1)
	Else
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
		If $GUICtrlTab_GetCurFocus = -1 Then Return
		If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then _Testscript($Datei_pfad[$GUICtrlTab_GetCurFocus], 1)
	EndIf
EndFunc   ;==>_ISN_Projekt_Testen_ohne_Parameter

Func _Sci_get_Functionname_from_Position($sci = "")
	If $Bearbeitende_Function_im_skriptbaum_markieren_Freigegeben = "0" Then Return
	If $hidefunctionstree = "true" Then Return
	If $Bearbeitende_Function_im_skriptbaum_markieren = "false" Then Return
	If $showfunctions = "false" Then Return
	If $Offenes_Projekt = "" Then Return
	If $sci = $Debug_log Or $sci = $ParameterEditor_SCIEditor Or $sci = $scintilla_Codeausschnitt Or $sci = $Makro_Codeausschnitt_GUI_scintilla Or $pelock_obfuscator_GUI_Eingabe_scintilla = $sci Or $pelock_obfuscator_GUI_Ausgabe_scintilla = $sci Or $QuickView_Notes_Scintilla = $sci Or $ParameterEditor_Vorschau_Fertiger_Befehl_SCE = $sci Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[$GUICtrlTab_GetCurFocus] <> -1 Then Return
	$startline = SendMessage($SCE_EDITOR[$GUICtrlTab_GetCurFocus], $SCI_LINEFROMPOSITION, Sci_GetCurrentPos($SCE_EDITOR[$GUICtrlTab_GetCurFocus]), 0)
	For $x = $startline To 0 Step -1
		If StringInStr(Sci_GetLine($sci, $x), "Endfunc") Then Return
		If StringInStr(Sci_GetLine($sci, $x), "func ") And BitAND(SendMessage($SCE_EDITOR[$GUICtrlTab_GetCurFocus], $SCI_GETFOLDLEVEL, $x, 0), $SC_FOLDLEVELHEADERFLAG) Then
			ExitLoop
		EndIf
	Next
	$Line_Text = Sci_GetLine($sci, $x)
	If $Line_Text = "" Or $Line_Text = -1 Then Return
	$Line_Text = StringReplace($Line_Text, @CRLF, "")
	If Not StringInStr($Line_Text, "func ") Then Return
	Local $funcname = ""

	;Get Func Name
	$temp = _StringBetween($Line_Text, "func ", "(")
	If IsArray($temp) Then $funcname = $temp[0]
	$funcname = StringStripWS($funcname, 3)

	$Bearbeitende_Function_im_skriptbaum_markieren_Freigegeben = "0"
	If $Name_der_Func_die_bearbeitet_wird <> $funcname Then
		$Name_der_Func_die_bearbeitet_wird = $funcname

		_ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "_Scripttree_Select_Item_per_Name", $funcname)
	EndIf


EndFunc   ;==>_Sci_get_Functionname_from_Position


Func _Scripttree_Drag_text_to_Scripteditor($Sci_For_Drag = "", $Treeview_Text = "")
	If $Offenes_Projekt = "" Then Return
	If $Sci_For_Drag = "" Then Return
	$Sci_For_Drag = HWnd($Sci_For_Drag)
	_WinAPI_SetFocus($Sci_For_Drag)
	While _IsPressed("01", $user32) Or _IsPressed("02", $user32)
		$cuurnet_mouse_Pos = MouseGetPos()
		If IsArray($cuurnet_mouse_Pos) Then
			ToolTip($Treeview_Text, $cuurnet_mouse_Pos[0] + 5, $cuurnet_mouse_Pos[1] + 5, "", 0, 0)
			Local $WP = WinGetPos($Sci_For_Drag)
			$cuurnet_mouse_Pos[0] -= $WP[0]
			$cuurnet_mouse_Pos[1] -= $WP[1]
			SendMessage($Sci_For_Drag, $SCI_GOTOPOS, SendMessage($Sci_For_Drag, $SCI_POSITIONFROMPOINT, $cuurnet_mouse_Pos[0] - 5, $cuurnet_mouse_Pos[1]), 0)
			GUISetCursor(2, 1, $Sci_For_Drag)
		EndIf
		Sleep(50)
	WEnd
	GUISetCursor(2, 0, $Sci_For_Drag)
	ToolTip("")
	If _hit_win($Sci_For_Drag) Then Sci_InsertText($Sci_For_Drag, Sci_GetCurrentPos($Sci_For_Drag), $Treeview_Text)
EndFunc   ;==>_Scripttree_Drag_text_to_Scripteditor

Func _Sci_DebugWindowStyle($sci)


	SendMessage($sci, $SCI_SETLEXER, $SCLEX_ERRORLIST, 0)
	SendMessage($sci, $SCI_SETSTYLEBITS, SendMessage($sci, $SCI_GETSTYLEBITSNEEDED, 0, 0), 0)

	_RemoveHotKeys($sci)

	;Setze Kodierung
	If $autoit_editor_encoding = "2" Then
		If _System_benoetigt_double_byte_character_Support() Then
			SendMessage($sci, $SCI_SETCODEPAGE, 936, 0) ;Setzte China Encoding für Scintila 936 (Simplified Chinese)
		Else
			SendMessage($sci, $SCI_SETCODEPAGE, $SC_CP_UTF8, 0)
		EndIf
	EndIf

	SetStyle($sci, $STYLE_DEFAULT, _RGB_to_BGR($Schriftfarbe), _RGB_to_BGR($scripteditor_bgcolour), $scripteditor_size, $scripteditor_font)

	SendMessage($sci, $SCI_STYLECLEARALL, 0, 0)

	SendMessage($sci, $SCI_SETINDENTATIONGUIDES, False, 0)
	SendMessage($sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 0)

	SendMessage($sci, $SCI_AUTOCSETSEPARATOR, Asc(@CR), 0)
	SendMessage($sci, $SCI_AUTOCSETIGNORECASE, True, 0)
	SendMessage($sci, $SCI_UsePopup, 0, 0) ;disable context menu

;~ SetStyle($Sci, 0, _Rev(0xFF0000), 0xFFFFFF, 0, "", 1); Will color normal text
	SetStyle($sci, 4, _Rev(0x0000FF), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 0) ; Blue Info Text
	If $ISN_Dark_Mode = "true" Then SetStyle($sci, 4, _Rev($Schriftfarbe), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 0) ;Blue Info Text (Dark Mode)
	SetStyle($sci, 10, _Rev(0xFF0000), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1) ;Red Error text
	SetStyle($sci, 11, _Rev(0x007F00), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1) ; Green info text
	SetStyle($sci, 12, _Rev(0xFF8800), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1) ; Yellow warning text
	SetStyle($sci, 3, _Rev(0xFF0000), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1) ;Clickable errors
	SetStyle($sci, 9, _Rev(0xFF00FF), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1) ; Pink text, I don't know but scite seems to display it so I wanted too as well

	;mark color
	Sci_SetSelectionAlpha($sci, 70)
	Sci_SetSelectionBkColor($sci, _RGB_to_BGR($scripteditor_marccolour), True)


	;autoscrollbar für seeehr lange zeilen ;)
	SendMessage($sci, $SCI_SETSCROLLWIDTHTRACKING, True, 0)



;~ SendMessage($Sci, $SCI_SETSCROLLWIDTH, 1, 0)
	If @error Then Return 0
	Return 1
EndFunc   ;==>_Sci_DebugWindowStyle


Func Sci_AddText($sci, $Text)
	$LineLenght = StringSplit($Text, "")
	SendMessageString($sci, $SCI_ADDTEXT, $LineLenght[0], $Text)
EndFunc   ;==>Sci_AddText

Func Sci_AppendText($sci, $Text)
	$LineLenght = StringSplit($Text, "")
	SendMessageString($sci, $SCI_APPENDTEXT, $LineLenght[0], $Text)
EndFunc   ;==>Sci_AppendText

Func SCI_CreateEditorTxt($hWnd, $x, $y, $W, $H, $CalltipPath = $SCI_DEFAULTCALLTIPDIR, $KeyWordDir = $SCI_DEFAULTKEYWORDDIR, $AbbrevDir = $SCI_DEFAULTABBREVDIR, $RegisterWM_NOTIFY = True) ; The return value is the hwnd of the window, and can be used for Win.. functions
	Local $sci = SCI_CreateEditor($hWnd, $x, $y, $W, $H)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	SCI_InitEditorTXT($sci, $CalltipPath, $KeyWordDir, $AbbrevDir)


	If @error Then
		Return SetError(2, 0, 0)
	Else
		;If $RegisterWM_NOTIFY = True Then GUIRegisterMsg(0x4E, "_WM_NOTIFY")
		Return $sci
	EndIf


EndFunc   ;==>SCI_CreateEditorTxt



Func SCI_CreateEditorAu3($hWnd, $x, $y, $W, $H, $CalltipPath = $SCI_DEFAULTCALLTIPDIR, $KeyWordDir = $SCI_DEFAULTKEYWORDDIR, $AbbrevDir = $SCI_DEFAULTABBREVDIR, $RegisterWM_NOTIFY = True) ; The return value is the hwnd of the window, and can be used for Win.. functions
	Local $sci = SCI_CreateEditor($hWnd, $x, $y, $W, $H)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf


	SCI_InitEditorAu3($sci, $CalltipPath, $KeyWordDir, $AbbrevDir)


	If @error Then
		Return SetError(2, 0, 0)
	Else
		;If $RegisterWM_NOTIFY = True Then GUIRegisterMsg(0x4E, "_WM_NOTIFY")
		Return $sci
	EndIf


EndFunc   ;==>SCI_CreateEditorAu3
; Prog@ndy
Func SCI_SetText($sci, $Text)
	Return SendMessageString($sci, $SCI_SETTEXT, 0, $Text)
EndFunc   ;==>SCI_SetText
; Prog@ndy
Func SCI_GetTextLen($sci)
	Local $iLen = SendMessage($sci, $SCI_GETTEXT, 0, 0)
	If @error Then Return SetError(1, 0, 0)
	Return $iLen
EndFunc   ;==>SCI_GetTextLen

#cs
	; changed form SCI_GetLines
	Func SCI_GetText($Sci)
	Local $ret, $sText, $iLen, $sBuf
	$iLen = SendMessage($Sci, $SCI_GETTEXT, 0, 0)
	If @error Then
	Return SetError(1,0,"")
	EndIf
	$sBuf = DllStructCreate("byte[" & $iLen & "]")
	If @error Then
	Return SetError(2,0,"")
	EndIf
	$ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETTEXT, "int", $iLen, "ptr", DllStructGetPtr($sBuf))
	If @error Then
	Return SetError(3,0,"")
	EndIf
	$sText = BinaryToString(DllStructGetData($sBuf, 1))
	$sBuf = 0
	If @error Then
	Return SetError(4,0,"")
	Else
	Return $sText
	EndIf
	EndFunc
#ce
; Author: Prog@ndy

Func SCI_GetSelectionText($sci = "")
	Local $Text = ""
	$start = SendMessage($sci, $SCI_GETSELECTIONSTART, 0, 0)
	$end = SendMessage($sci, $SCI_GETSELECTIONEND, 0, 0)
	$Text = SCI_GetTextRange($sci, $start, $end)
	Return $Text
EndFunc   ;==>SCI_GetSelectionText



Func SCI_GetTextRange($sci, $start, $end)
	If $start > $end Then Return SetError(1, 0, "")
	Local $textRange = DllStructCreate($tagCharacterRange & "; ptr TextPtr; char Text[" & $end - $start + 1 & "]")
	DllStructSetData($textRange, 1, $start)
	DllStructSetData($textRange, 2, $end)
	DllStructSetData($textRange, 3, DllStructGetPtr($textRange, 4))
	SendMessage($sci, $SCI_GETTEXTRANGE, 0, DllStructGetPtr($textRange))
	Return DllStructGetData($textRange, "Text")
EndFunc   ;==>SCI_GetTextRange

; Changed by Prog@ndy
Func SCI_GetCurrentWordEx($sci, $onlyWordCharacters = 1, $CHARADDED = 0)
	Local $currentPos = SCI_GetCurrentPos($sci)
	$currentPos -= ($CHARADDED = True)
	Return SCI_GetWordFromPos($sci, $currentPos, $onlyWordCharacters)
EndFunc   ;==>SCI_GetCurrentWordEx
; Author: Prog@ndy
Func SCI_GetWordPositions($sci, $currentPos, $onlyWordCharacters = 1)
	Local $Return[2] = [-1, -1]
	$Return[0] = SendMessage($sci, $SCI_WORDSTARTPOSITION, $currentPos, $onlyWordCharacters)
	$Return[1] = SendMessage($sci, $SCI_WORDENDPOSITION, $currentPos, $onlyWordCharacters)
	Return $Return
EndFunc   ;==>SCI_GetWordPositions
; Author: Prog@ndy
Func SCI_GetWordFromPos($sci, $currentPos, $onlyWordCharacters = 1)
;~ 	Local $Return, $i, $Get, $char

;~ 	Local $CurrentPos = SCI_GetCurrentPos($Sci)
;~ 	$CurrentPos -= ($CHARADDED = True)
	Local $start = SendMessage($sci, $SCI_WORDSTARTPOSITION, $currentPos, $onlyWordCharacters)
	Local $end = SendMessage($sci, $SCI_WORDENDPOSITION, $currentPos, $onlyWordCharacters)
	Return SCI_GetTextRange($sci, $start, $end)

EndFunc   ;==>SCI_GetWordFromPos


Func _Script_Editor_properties_Einlesen($Ordner = "")
	If $Ordner = "" Then Return
	$Ordner = _WinAPI_PathAddBackslash($Ordner)
	If Not FileExists($Ordner) Then Return
	Local $SciteKeyWord_handle = FileFindFirstFile($Ordner & "\*.keywords.properties")
	Local $file
	While 1
		$file = FileFindNextFile($SciteKeyWord_handle)
		If @error Then ExitLoop
		If $file = "." Or $file = ".." Then ContinueLoop
		If StringRight($SciteKeyWord, 2) <> @CRLF Then $SciteKeyWord &= @CRLF
		$SciteKeyWord &= FileRead($Ordner & $file)
	WEnd

	;User abbreviations 1/2
	Local $SciteKeyWord_handle = FileFindFirstFile($Ordner & "\*abbrev.properties")
	Local $file
	While 1
		$file = FileFindNextFile($SciteKeyWord_handle)
		If @error Then ExitLoop
		If $file = "." Or $file = ".." Then ContinueLoop
		If StringRight($SCI_ABBREVFILE, 2) <> @CRLF Then $SCI_ABBREVFILE &= @CRLF
		$SCI_ABBREVFILE &= FileRead($Ordner & $file)
	WEnd


	;User abbreviations 2/2
	Local $SciteKeyWord_handle = FileFindFirstFile($Ordner & "\au3.keywords*abbreviations.properties")
	Local $file
	While 1
		$file = FileFindNextFile($SciteKeyWord_handle)
		If @error Then ExitLoop
		If $file = "." Or $file = ".." Then ContinueLoop
		Local $au3_keywords_abbrev_read = FileRead($Ordner & $file)
		If StringLen($au3_keywords_abbrev_read) Then
			$au3_keywords_abbrev_read = StringRegExpReplace($au3_keywords_abbrev_read, "(\w)(\r\n)", "$1 $2")
			$au3_keywords_abbrev_read = StringSplit($au3_keywords_abbrev_read, " " & @CRLF, 1)
			For $i = 0 To UBound($au3_keywords_abbrev_read) - 1
				$PART = StringLeft($au3_keywords_abbrev_read[$i], 26)
				Select
					Case StringInStr($PART, "au3.keywords.abbrev=", 0, 1, 1)
						$au3_keywords_abbrev &= StringReplace(StringTrimLeft($au3_keywords_abbrev_read[$i], StringLen("au3.keywords.abbrev=")), "\" & @CRLF, @CRLF) & " "
					Case StringInStr($PART, "au3.keywords.userabbrev=", 0, 1, 1)
						$au3_keywords_abbrev &= StringReplace(StringTrimLeft($au3_keywords_abbrev_read[$i], StringLen("au3.keywords.userabbrev=")), "\" & @CRLF, @CRLF) & " "
				EndSelect
			Next
		EndIf
	WEnd

EndFunc   ;==>_Script_Editor_properties_Einlesen

Func _Script_Editor_APIs_Einlesen($Ordner = "")
	If $Ordner = "" Then Return
	$Ordner = _WinAPI_PathAddBackslash($Ordner)
	If Not FileExists($Ordner) Then Return
	Local $ExtraAPIs = FileFindFirstFile($Ordner & "\au3.*.api")
	Local $file
	While 1
		$file = FileFindNextFile($ExtraAPIs)
		If @error Then ExitLoop
		If $file = "." Or $file = ".." Then ContinueLoop
		If StringRight($SCI_sCallTip_Array, 2) <> @CRLF Then $SCI_sCallTip_Array &= @CRLF
		$SCI_sCallTip_Array &= FileRead($Ordner & $file)

	WEnd
	FileClose($ExtraAPIs)
EndFunc   ;==>_Script_Editor_APIs_Einlesen


Func _Skripteditor_APIs_und_properties_neu_einlesen()
	$SciteKeyWord = "" ;Reset
	$SCI_sCallTip_Array = "" ;Reset
	$SCI_ABBREVFILE = "" ;Reset
	$au3_keywords_abbrev = "" ;Reset

;~ $SCI_ABBREVFILE = FileRead($SCI_DEFAULTABBREVDIR & "abbrev.properties")

	;Properties Dateien aufbereiten
	_Script_Editor_properties_Einlesen($SCI_DEFAULTKEYWORDDIR) ;Default Pfad einlesen
	If $Erstkonfiguration_Mode <> "portable" And $Arbeitsverzeichnis <> @ScriptDir Then _Script_Editor_properties_Einlesen($Arbeitsverzeichnis & "\Data\Properties") ;2ten default Pfad einlesen

	;Weitere Pfade aus den Programmeinstellungen
	If $Zusaetzliche_Properties_Ordner <> "" Then
		$Orner_Array = StringSplit($Zusaetzliche_Properties_Ordner, "|", 2)
		If IsArray($Orner_Array) Then
			For $index = 0 To UBound($Orner_Array) - 1
				If $Orner_Array[$index] = "" Then ContinueLoop
				If $Orner_Array[$index] = "%isnstudiodir%\Data\Properties" Then ContinueLoop
				If $Orner_Array[$index] = "%myisndatadir%\Data\Properties" Then ContinueLoop
				_Script_Editor_properties_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
			Next
		EndIf
	EndIf

	;Weitere Projektspezifische Pfade (properties)
	If $Offenes_Projekt <> "" Then
		$Projekt_properties_Pfade = _ProjectISN_Config_Read("additional_properties_folders", "")
		If $Projekt_properties_Pfade <> "" Then
			$Orner_Array = StringSplit($Projekt_properties_Pfade, "|", 2)
			If IsArray($Orner_Array) Then
				For $index = 0 To UBound($Orner_Array) - 1
					If $Orner_Array[$index] = "" Then ContinueLoop
					If $Orner_Array[$index] = "%isnstudiodir%\Data\Properties" Then ContinueLoop
					If $Orner_Array[$index] = "%myisndatadir%\Data\Properties" Then ContinueLoop
					_Script_Editor_properties_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
				Next
			EndIf
		EndIf
	EndIf



	If StringLen($SciteKeyWord) Then
		$SciteKeyWord = StringRegExpReplace($SciteKeyWord, "(\w)(\r\n)", "$1 $2")
		$SciteKeyWord = StringSplit($SciteKeyWord, " " & @CRLF, 1)
		Local $PART
;~ 	$SCI_AUTOCLIST = ""

		For $i = 0 To UBound($SciteKeyWord) - 1
			$PART = StringLeft($SciteKeyWord[$i], 36)
			Select
				Case StringInStr($PART, "au3.keywords.functions=", 0, 1, 1)
					$au3_keywords_functions = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.functions=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.udfs=", 0, 1, 1)
					$au3_keywords_udfs = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.udfs=")), "\" & @CRLF, @CRLF)
;~ 					SendMessageString($Sci, $SCI_SETKEYWORDS, 7, $tempText)
					$UDF_Keywords = $UDF_Keywords & $au3_keywords_udfs & " "

				Case StringInStr($PART, "au3.keywords.keywords=", 0, 1, 1)
					$au3_keywords_keywords = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.keywords=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.macros=", 0, 1, 1)
					$au3_keywords_macros = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.macros=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.preprocessor=", 0, 1, 1)
					$au3_keywords_preprocessor = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.preprocessor=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.special=", 0, 1, 1)
					$au3_keywords_special = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.special=")), "\" & @CRLF, @CRLF)
					$special_Keywords = $special_Keywords & $au3_keywords_special & " "

				Case StringInStr($PART, "au3.keywords.sendkeys=", 0, 1, 1)
					$au3_keywords_sendkeys = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.sendkeys=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "autoit3wrapper.keywords.special=", 0, 1, 1)
					$autoit3wrapper_keywords_special = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("autoit3wrapper.keywords.special=")), "\" & @CRLF, @CRLF)
					$special_Keywords = $special_Keywords & $autoit3wrapper_keywords_special & " "

				Case Else
					$tempText = Ptr(123456)
			EndSelect
;~ 		If Not IsPtr($tempText) Then $SCI_AUTOCLIST &= $tempText & " "
		Next
	EndIf


	$UDF_Keywords = StringReplace($UDF_Keywords, @TAB, "")
	$UDF_Keywords = StringReplace($UDF_Keywords, @CRLF, " ")
	$UDF_Keywords = StringReplace($UDF_Keywords, "  ", " ")



	$special_Keywords = StringReplace($special_Keywords, @TAB, "")
	$special_Keywords = StringReplace($special_Keywords, @CRLF, " ")
	$special_Keywords = StringReplace($special_Keywords, "  ", " ")






	;API Dateien aufbereiten
	$SCI_sCallTip_Array = FileRead($SCI_DEFAULTCALLTIPDIR & "\au3.api")

	If $Erstkonfiguration_Mode <> "portable" And $Arbeitsverzeichnis <> @ScriptDir Then _Script_Editor_APIs_Einlesen($Arbeitsverzeichnis & "\Data\Api") ;2ten default Pfad einlesen


	;Weitere Pfade aus den Programmeinstellungen
	If $Zusaetzliche_API_Ordner <> "" Then
		$Orner_Array = StringSplit($Zusaetzliche_API_Ordner, "|", 2)
		If IsArray($Orner_Array) Then
			For $index = 0 To UBound($Orner_Array) - 1
				If $Orner_Array[$index] = "" Then ContinueLoop
				If $Orner_Array[$index] = "%isnstudiodir%\Data\Api" Then ContinueLoop
				If $Orner_Array[$index] = "%myisndatadir%\Data\Api" Then ContinueLoop
				_Script_Editor_APIs_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
			Next
		EndIf
	EndIf

	;Weitere Projektspezifische Pfade (API)
	If $Offenes_Projekt <> "" Then
		$Projekt_API_Pfade = _ProjectISN_Config_Read("additional_api_folders", "")
		If $Projekt_API_Pfade <> "" Then
			$Orner_Array = StringSplit($Projekt_API_Pfade, "|", 2)
			If IsArray($Orner_Array) Then
				For $index = 0 To UBound($Orner_Array) - 1
					If $Orner_Array[$index] = "" Then ContinueLoop
					If $Orner_Array[$index] = "%isnstudiodir%\Data\Api" Then ContinueLoop
					If $Orner_Array[$index] = "%myisndatadir%\Data\Api" Then ContinueLoop
					_Script_Editor_APIs_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
				Next
			EndIf
		EndIf
	EndIf


	_Script_Editor_APIs_Einlesen($SCI_DEFAULTCALLTIPDIR) ;Default Pfad einlesen
	If StringRight($SCI_sCallTip_Array, 2) = @CRLF Then StringTrimRight($SCI_sCallTip_Array, 2)
	$SCI_sCallTip_Array = StringSplit($SCI_sCallTip_Array, @CRLF, 1)



	Global $SCI_AUTOCLIST[UBound($SCI_sCallTip_Array)] = [UBound($SCI_sCallTip_Array) - 1]

	Local $temp
	For $i = 0 To UBound($SCI_AUTOCLIST) - 1

;~ 		$temp = StringRegExp($SCI_sCallTip_Array[$i], "\A([#@]?\w+)", 1)
		$temp = StringRegExp($SCI_sCallTip_Array[$i], "^[a-zA-Z\d-_#@]+", 1)

		If Not @error Then $SCI_AUTOCLIST[$i] = $temp[0] & _Return_Pixnumber($temp[0])

	Next
	If UBound($SCI_AUTOCLIST) - 1 > 0 Then _ArrayDelete($SCI_AUTOCLIST, 0) ;Delete Index

	;Fill $SCI_AutoIt_Includes_List
	$Includes_Array = $Leeres_Array
	If FileExists($autoitexe) Then
		;Default AutoIt Includes
		$path_to_scan = $autoitexe
		$path_to_scan = StringTrimRight($path_to_scan, StringLen($path_to_scan) - StringInStr($path_to_scan, "\", 0, -1))
		$path_to_scan = $path_to_scan & "Include"
		If FileExists($path_to_scan) Then
			$Includes_Array = _FileListToArray($path_to_scan, "*.au3", $FLTA_FILES, False)
			_ArrayDelete($Includes_Array, 0)
		EndIf
	EndIf


	$Additional_Includes_Reg = RegRead("HKEY_CURRENT_USER\Software\AutoIt v3\AutoIt", "Include")
	If $Additional_Includes_Reg <> "" Then
		;Additional Includes from the registry
		$Additional_Includes_Reg_Split = StringSplit($Additional_Includes_Reg, ";", 2)
		If IsArray($Additional_Includes_Reg_Split) Then
			For $x = 0 To UBound($Additional_Includes_Reg_Split) - 1
				If FileExists($Additional_Includes_Reg_Split[$x]) Then
					$Additional_Includes_Files_Array = _FileListToArray($Additional_Includes_Reg_Split[$x], "*.au3", $FLTA_FILES, False)
					If IsArray($Additional_Includes_Files_Array) Then
						_ArrayDelete($Additional_Includes_Files_Array, 0)
						_ArrayConcatenate($Includes_Array, $Additional_Includes_Files_Array)
					EndIf
				EndIf
			Next
		EndIf
	EndIf

	;Array aufbereiten
	If IsArray($Includes_Array) Then
		ArraySortUnique($Includes_Array, 0, 1)
		$SCI_AutoIt_Includes_List = _ArrayToString($Includes_Array, "?1" & @CR)
		$SCI_AutoIt_Includes_List = $SCI_AutoIt_Includes_List & "?1"
	EndIf



	ArraySortUnique($SCI_AUTOCLIST, 0, 1)
	Global $SCI_Autocompletelist_backup = $SCI_AUTOCLIST ;Backup Orginal List...
	_ISN_Set_Variable_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "$SCI_Autocompletelist_backup", $SCI_AUTOCLIST) ;...and send it to the scripttree thread
EndFunc   ;==>_Skripteditor_APIs_und_properties_neu_einlesen



Func SCI_InitEditorTXT($sci, $CalltipPath = $SCI_DEFAULTCALLTIPDIR, $KeyWordDir = $SCI_DEFAULTKEYWORDDIR, $AbbrevDir = $SCI_DEFAULTABBREVDIR)
	If $CalltipPath = "" Or $CalltipPath = Default Or IsNumber($CalltipPath) Then $CalltipPath = $SCI_DEFAULTCALLTIPDIR
	If $KeyWordDir = "" Or $KeyWordDir = Default Or IsNumber($KeyWordDir) Then $KeyWordDir = $SCI_DEFAULTKEYWORDDIR
	If $AbbrevDir = "" Or $AbbrevDir = Default Or IsNumber($AbbrevDir) Then $AbbrevDir = $SCI_DEFAULTABBREVDIR

	SendMessage($sci, $SCI_SETLEXER, $SCLEX_NULL, 0)

	Local $bits = SendMessage($sci, $SCI_GETSTYLEBITSNEEDED, 0, 0)
	SendMessage($sci, $SCI_SETSTYLEBITS, $bits, 0)

	SendMessage($sci, $SCI_SETTABWIDTH, 4, 0)



	SendMessage($sci, $SCI_SETZOOM, IniRead($Configfile, "Settings", "scripteditor_zoom", -1), 0)




	SetStyle($sci, $STYLE_DEFAULT, _RGB_to_BGR($Schriftfarbe), _RGB_to_BGR($scripteditor_bgcolour), $scripteditor_size, $scripteditor_font)
	SendMessage($sci, $SCI_STYLECLEARALL, 0, 0)


	;Insert a dummy margin of 2 pixels
	SendMessage($sci, $SCI_SETMARGINWIDTHN, 4, 2) ;Dummy Margin
	SendMessage($sci, $SCI_SETMARGINTYPEN, 4, $SC_MARGIN_BACK)



	;Display indentation guides, if enabled
	SendMessage($sci, $SCI_SETINDENTATIONGUIDES, $SC_IV_NONE, 0)


	;Display End of Line Chars, if enabled
	SendMessage($sci, $SCI_SETVIEWEOL, False, 0)


	;Display whitespaces, if enabled
	SendMessage($sci, $SCI_SETVIEWWS, $SCWS_INVISIBLE, 0)


	;Show linenumbers in margin, if enabled
	$pixelWidth = SendMessageString($sci, $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "99999")
	SendMessage($sci, $SCI_SETMARGINWIDTHN, 0, $pixelWidth) ;


	;Show margin for bookmarks, if enabled
	SendMessage($sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 0)



	;Set Encoding
	If $autoit_editor_encoding = "2" Then
		If _System_benoetigt_double_byte_character_Support() Then
			SendMessage($sci, $SCI_SETCODEPAGE, 936, 0) ;Setzte China Encoding für Scintila 936 (Simplified Chinese)
		Else
			SendMessage($sci, $SCI_SETCODEPAGE, $SC_CP_UTF8, 0)
		EndIf
	EndIf


	;SendMessage($Sci,$SCI_STYLESETCHARACTERSET,$STYLE_DEFAULT,$SC_CHARSET_DEFAULT);
	;SendMessage($Sci,$SCI_STYLESETCHARACTERSET,$STYLE_DEFAULT,$SC_CHARSET_VIETNAMESE);



	SendMessage($sci, $SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_NUMBER, $SC_MARGIN_NUMBER)
;~ 	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_NUMBER, SendMessageString($Sci, $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "_99999"))


	SendMessage($sci, $SCI_AUTOCSETSEPARATOR, Asc(@CR), 0)
	SendMessage($sci, $SCI_AUTOCSETIGNORECASE, True, 0)
	SendMessage($sci, $SCI_AUTOCSETAUTOHIDE, True, 0)










	;Set BraceLight Colors
	SendMessage($sci, $SCI_STYLESETBACK, $STYLE_BRACELIGHT, _RGB_to_BGR($scripteditor_bracelight_colour))
;~    SendMessage($Sci, $SCI_STYLESETFORE, $STYLE_BRACELIGHT, _RGB_to_BGR(0x00FF00))
	SendMessage($sci, $SCI_STYLESETBACK, $STYLE_BRACEBAD, _RGB_to_BGR($scripteditor_bracebad_colour))

	;SetStyle($Sci, $STYLE_BRACEBAD, 0x009966, 0xFFFFFF, 0, "", 0, 1)

	;Spezial settings für Dark Mode (Line numbers farben usw.)
	If $ISN_Dark_Mode = "true" Then
		SetStyle($sci, $STYLE_LINENUMBER, 0xADACAA, $Fenster_Hintergrundfarbe, 0, "", 0, 1)
		SendMessage($sci, $SCI_SETFOLDMARGINCOLOUR, $Fenster_Hintergrundfarbe, 0)
		SendMessage($sci, $SCI_CALLTIPSETBACK, _RGB_to_BGR($Fenster_Hintergrundfarbe), 0)
		SendMessage($sci, $SCI_CALLTIPSETFOREHLT, _RGB_to_BGR(0xFF5757), 0)
		SendMessage($sci, $SCI_CALLTIPSETFORE, _RGB_to_BGR(0xADACAA), 0)
	EndIf






	SetProperty($sci, "fold", "1")
	SetProperty($sci, "fold.compact", "0")
	SetProperty($sci, "fold.comment", "1")
	SetProperty($sci, "fold.preprocessor", "1")



	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_ARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_BOXMINUS)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_ARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERMIDTAIL, $SC_MARK_TCORNER)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPENMID, $SC_MARK_BOXMINUS)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERSUB, $SC_MARK_VLINE)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERTAIL, $SC_MARK_LCORNER)
	SendMessage($sci, $SCI_SETFOLDFLAGS, 16, 0)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDER, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERSUB, 0x808080)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEREND, 0x808080)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEREND, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERTAIL, 0x808080)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERMIDTAIL, 0x808080)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDER, 0x808080)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEROPEN, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEROPEN, 0x808080)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEROPENMID, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEROPENMID, 0x808080)


;~     SendMessage($Sci_handle, $SCI_CLEARCMDKEY,0x0D, 0); Enter sperren



	SendMessage($sci, $SCI_CLEARCMDKEY, 0x09, 0) ; Tab (We use our own paste function)
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_SHIFT, -16) + 0x09, 0) ; SHIFT + TAB
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x56, 0) ; Ctrl + V (We use our own paste function)
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x44, 0) ; Ctrl + D
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x44, 0) ; Ctrl + SHIFT + D
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x45, 0) ; Ctrl + E
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x45, 0) ; Ctrl + SHIFT + E
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x47, 0) ; Ctrl + G
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x47, 0) ; Ctrl + SHIFT + G
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4E, 0) ; Ctrl + N
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4E, 0) ; Ctrl + SHIFT + N
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4F, 0) ; Ctrl + O
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4F, 0) ; Ctrl + SHIFT + O
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x53, 0) ; Ctrl + S
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x53, 0) ; Ctrl + SHIFT + S
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x50, 0) ; Ctrl + P
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x50, 0) ; Ctrl + SHIFT + P
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x46, 0) ; Ctrl + F
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x46, 0) ; Ctrl + SHIFT + F
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x54, 0) ; Ctrl + T
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x54, 0) ; Ctrl + SHIFT + T
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x57, 0) ; Ctrl + W
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x57, 0) ; Ctrl + SHIFT + W
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x51, 0) ; Ctrl + Q
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x51, 0) ; Ctrl + SHIFT + Q
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x42, 0) ; Ctrl + B
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x42, 0) ; Ctrl + SHIFT + B
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x48, 0) ; Ctrl + H
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x48, 0) ; Ctrl + SHIFT + H
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x49, 0) ; Ctrl + I
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x49, 0) ; Ctrl + SHIFT + I
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4A, 0) ; Ctrl + J
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4A, 0) ; Ctrl + SHIFT + J

	SendMessage($sci, $SCI_MARKERDEFINE, 0, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, 1, $SC_MARK_BACKGROUND)
	SendMessage($sci, $SCI_MARKERDEFINE, 2, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, 3, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERSETBACK, 0, 0x0000FF) ; error or warning
	SendMessage($sci, $SCI_MARKERSETBACK, 1, 0xE6E5FF) ; error or warning bg colour
	SendMessage($sci, $SCI_MARKERSETBACK, 2, 0x03C724) ; 'mark all' in search win
	SendMessage($sci, $SCI_MARKERSETBACK, 3, 0x03C724) ; 'mark all' in search win
	SendMessage($sci, $SCI_UsePopup, 0, 0) ;disable context menu




	;Marker 6 (Selection matches)
	SendMessage($sci, $SCI_MARKERDEFINE, 6, $SC_MARK_ARROWS)
	SendMessage($sci, $SCI_MARKERSETFORE, 6, _RGB_to_BGR($scripteditor_highlightcolour))
	SendMessage($sci, $SCI_MARKERSETBACK, 6, _RGB_to_BGR($scripteditor_highlightcolour))

	;Marker 7 (Selection matches)
	SendMessage($sci, $SCI_MARKERDEFINE, 7, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERSETFORE, 7, _RGB_to_BGR($scripteditor_highlightcolour))
	SendMessage($sci, $SCI_MARKERSETBACK, 7, _RGB_to_BGR($scripteditor_highlightcolour))


	;Marker 5 (Bookmarked Lines)
	SendMessage($sci, $SCI_MARKERDEFINE, 5, $SC_MARK_CIRCLE)
	SendMessage($sci, $SCI_MARKERSETFORE, 5, _RGB_to_BGR($scripteditor_marccolour))
	SendMessage($sci, $SCI_MARKERSETBACK, 5, _RGB_to_BGR($scripteditor_marccolour))

	SendMessage($sci, $SCI_MARKERSETBACK, 0, 0x0000FF)
	SendMessage($sci, $SCI_StyleSetFore, $Style_IndentGuide, 0xC0C0C0) ;Farbe der INDENTATIONGUIDES
	SendMessage($sci, $SCI_SETCARETFORE, _RGB_to_BGR($scripteditor_caretcolour), 0) ;Farbe Caret (Coursor)
	SendMessage($sci, $SCI_SETCARETWIDTH, $scripteditor_caretwidth, 0) ;Caret Breite
	SendMessage($sci, $SetCaretStyle, $scripteditor_caretstyle, 0) ;Caret Style







;~ 	SendMessage($Sci, $SCI_AUTOCSETAUTOHIDE, false, 0)










	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_BOXPLUS) ;
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_BOXMINUS) ;
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_EMPTY) ;

	;mark color
	Sci_SetSelectionAlpha($sci, 70)
	Sci_SetSelectionBkColor($sci, _RGB_to_BGR($scripteditor_marccolour), True)


	;current line color
	SendMessage($sci, $SCI_SETCARETLINEBACK, _RGB_to_BGR($scripteditor_rowcolour), 0) ;BGR
	SendMessage($sci, $SCI_SETCARETLINEVISIBLE, 1, 0)

	;autoscrollbar für seeehr lange zeilen ;)
	SendMessage($sci, $SCI_SETSCROLLWIDTHTRACKING, True, 0)

	;Pixmaps
	SendMessage($sci, $SCI_CLEARREGISTEREDIMAGES, 0, 0) ;Lösche Pixmaps

	SendMessage($sci, $SCI_REGISTERIMAGE, 1, DllStructGetPtr($Pixmap_violet_struct, 1)) ;Funktionen
	SendMessage($sci, $SCI_REGISTERIMAGE, 2, DllStructGetPtr($Pixmap_UDF_struct, 1)) ;UDF
	SendMessage($sci, $SCI_REGISTERIMAGE, 3, DllStructGetPtr($Pixmap_blue_struct, 1)) ;Keywoards
	SendMessage($sci, $SCI_REGISTERIMAGE, 4, DllStructGetPtr($Pixmap_macros_struct, 1)) ;macros
	SendMessage($sci, $SCI_REGISTERIMAGE, 5, DllStructGetPtr($Pixmap_preprocessor_struct, 1)) ;preprocessor
	SendMessage($sci, $SCI_REGISTERIMAGE, 6, DllStructGetPtr($Pixmap_red_struct, 1)) ;special
	SendMessage($sci, $SCI_REGISTERIMAGE, 15, DllStructGetPtr($Pixmap_varaiblen_struct, 1)) ;Variablen

	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>SCI_InitEditorTXT



;modified by Prog@ndy
Func SCI_InitEditorAu3($sci, $CalltipPath = $SCI_DEFAULTCALLTIPDIR, $KeyWordDir = $SCI_DEFAULTKEYWORDDIR, $AbbrevDir = $SCI_DEFAULTABBREVDIR)
	If $CalltipPath = "" Or $CalltipPath = Default Or IsNumber($CalltipPath) Then $CalltipPath = $SCI_DEFAULTCALLTIPDIR
	If $KeyWordDir = "" Or $KeyWordDir = Default Or IsNumber($KeyWordDir) Then $KeyWordDir = $SCI_DEFAULTKEYWORDDIR
	If $AbbrevDir = "" Or $AbbrevDir = Default Or IsNumber($AbbrevDir) Then $AbbrevDir = $SCI_DEFAULTABBREVDIR

	SendMessage($sci, $SCI_SETLEXER, $SCLEX_AU3, 0)

	Local $bits = SendMessage($sci, $SCI_GETSTYLEBITSNEEDED, 0, 0)
	SendMessage($sci, $SCI_SETSTYLEBITS, $bits, 0)

	SendMessage($sci, $SCI_SETTABWIDTH, 4, 0)


	;Set Zoom
	SendMessage($sci, $SCI_SETZOOM, $scripteditor_Zoom, 0)


	;properties und APIs setzen
	SendMessageString($sci, $SCI_SETKEYWORDS, 0, $au3_keywords_keywords)
	SendMessageString($sci, $SCI_SETKEYWORDS, 1, $au3_keywords_functions)
	SendMessageString($sci, $SCI_SETKEYWORDS, 2, $au3_keywords_macros)
	SendMessageString($sci, $SCI_SETKEYWORDS, 3, $au3_keywords_sendkeys)
	SendMessageString($sci, $SCI_SETKEYWORDS, 4, $au3_keywords_preprocessor)
	SendMessageString($sci, $SCI_SETKEYWORDS, 5, $special_Keywords)
	SendMessageString($sci, $SCI_SETKEYWORDS, 6, $au3_keywords_abbrev)
	SendMessageString($sci, $SCI_SETKEYWORDS, 7, $UDF_Keywords)


	SetStyle($sci, $STYLE_DEFAULT, _RGB_to_BGR($Schriftfarbe), _RGB_to_BGR($scripteditor_bgcolour), $scripteditor_size, $scripteditor_font)
	SendMessage($sci, $SCI_STYLECLEARALL, 0, 0)


	;Insert a dummy margin of 2 pixels
	SendMessage($sci, $SCI_SETMARGINWIDTHN, 4, 2) ;Dummy Margin
	SendMessage($sci, $SCI_SETMARGINTYPEN, 4, $SC_MARGIN_BACK)



	;Display indentation guides, if enabled
	If $scripteditor_display_indentationguides = "false" Then
		SendMessage($sci, $SCI_SETINDENTATIONGUIDES, $SC_IV_NONE, 0)
	Else
		SendMessage($sci, $SCI_SETINDENTATIONGUIDES, $SC_IV_LOOKBOTH, 0)
	EndIf


	;Display End of Line Chars, if enabled
	If $scripteditor_display_endofline = "false" Then
		SendMessage($sci, $SCI_SETVIEWEOL, False, 0)
	Else
		SendMessage($sci, $SCI_SETVIEWEOL, True, 0)
	EndIf

	;Display whitespaces, if enabled
	If $scripteditor_display_whitespace = "false" Then
		SendMessage($sci, $SCI_SETVIEWWS, $SCWS_INVISIBLE, 0)
	Else
		SendMessage($sci, $SCI_SETVIEWWS, $SCWS_VISIBLEALWAYS, 0)
	EndIf

	;Show linenumbers in margin, if enabled
	If $showlines = "false" Then
		SendMessage($sci, $SCI_SETMARGINWIDTHN, 0, 0)
	Else
		$pixelWidth = SendMessageString($sci, $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "9999999")
		SendMessage($sci, $SCI_SETMARGINWIDTHN, 0, $pixelWidth) ;
	EndIf

	;Show margin for codefolding, if enabled
	SendMessage($sci, $SCI_SETMARGINSENSITIVEN, $MARGIN_SCRIPT_FOLD, 1)
	SendMessage($sci, $SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_FOLD, $SC_MARGIN_SYMBOL)
	SendMessage($sci, $SCI_SETMARGINMASKN, $MARGIN_SCRIPT_FOLD, $SC_MASK_FOLDERS)
	If $scripteditor_fold_margin = "false" Then
		SendMessage($sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 0)
	Else
		SendMessage($sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 20)
	EndIf

	;Show margin for bookmarks, if enabled
	If $scripteditor_bookmark_margin = "false" Then
		SendMessage($sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 0)
	Else
		SendMessage($sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 16)
	EndIf


	;Set Encoding
	If $autoit_editor_encoding = "2" Then
		If _System_benoetigt_double_byte_character_Support() Then
			SendMessage($sci, $SCI_SETCODEPAGE, 936, 0) ;Setzte China Encoding für Scintila 936 (Simplified Chinese)
		Else
			SendMessage($sci, $SCI_SETCODEPAGE, $SC_CP_UTF8, 0)
		EndIf
	EndIf


	;SendMessage($Sci,$SCI_STYLESETCHARACTERSET,$STYLE_DEFAULT,$SC_CHARSET_DEFAULT);
	;SendMessage($Sci,$SCI_STYLESETCHARACTERSET,$STYLE_DEFAULT,$SC_CHARSET_VIETNAMESE);



	SendMessage($sci, $SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_NUMBER, $SC_MARGIN_NUMBER)
;~ 	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_NUMBER, SendMessageString($Sci, $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "_99999"))


	SendMessage($sci, $SCI_AUTOCSETSEPARATOR, Asc(@CR), 0)
	SendMessage($sci, $SCI_AUTOCSETIGNORECASE, True, 0)
	SendMessage($sci, $SCI_AUTOCSETAUTOHIDE, True, 0)


	;Multi Selection
	If $Scripteditor_EnableMultiCursor = "true" Then
		SendMessage($sci, $SCI_SETMULTIPLESELECTION, True, 0)
		SendMessage($sci, $SCI_SETMULTIPASTE, $SC_MULTIPASTE_EACH, 0)
		SendMessage($sci, $SCI_SETADDITIONALSELECTIONTYPING, 1, 0)
	EndIf



	;Set BraceLight Colors
	SendMessage($sci, $SCI_STYLESETBACK, $STYLE_BRACELIGHT, _RGB_to_BGR($scripteditor_bracelight_colour))
;~    SendMessage($Sci, $SCI_STYLESETFORE, $STYLE_BRACELIGHT, _RGB_to_BGR(0x00FF00))
	SendMessage($sci, $SCI_STYLESETBACK, $STYLE_BRACEBAD, _RGB_to_BGR($scripteditor_bracebad_colour))

	;SetStyle($Sci, $STYLE_BRACEBAD, 0x009966, 0xFFFFFF, 0, "", 0, 1)

	;Spezial settings für Dark Mode (Line numbers farben usw.)
	If $ISN_Dark_Mode = "true" Then
		SetStyle($sci, $STYLE_LINENUMBER, 0xADACAA, $Fenster_Hintergrundfarbe, 0, "", 0, 1)
		SendMessage($sci, $SCI_SETFOLDMARGINCOLOUR, $Fenster_Hintergrundfarbe, 0)
		SendMessage($sci, $SCI_CALLTIPSETBACK, _RGB_to_BGR($Fenster_Hintergrundfarbe), 0)
		SendMessage($sci, $SCI_CALLTIPSETFOREHLT, _RGB_to_BGR(0xFF5757), 0)
		SendMessage($sci, $SCI_CALLTIPSETFORE, _RGB_to_BGR(0xADACAA), 0)
	EndIf





	;Farbeinstellungen für AU3-Code
	;$fore, $back, $size = 0, $font = "", $bold = 0, $italic = 0, $underline = 0)
	If $use_new_au3_colours = "true" Then
		;Neuer Farbstiel
		$Split = StringSplit($SCE_AU3_STYLE1b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_DEFAULT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE2b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_COMMENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE3b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_COMMENTBLOCK, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE4b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_NUMBER, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE5b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_FUNCTION, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE6b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_KEYWORD, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE7b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_MACRO, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE8b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_STRING, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE9b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_OPERATOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE10b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_VARIABLE, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE11b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_SENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE12b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_PREPROCESSOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE13b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_SPECIAL, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE14b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_EXPAND, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE15b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_COMOBJ, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE16b, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_UDF, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
	Else
		$Split = StringSplit($SCE_AU3_STYLE1a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_DEFAULT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE2a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_COMMENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE3a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_COMMENTBLOCK, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE4a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_NUMBER, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE5a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_FUNCTION, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE6a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_KEYWORD, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE7a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_MACRO, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE8a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_STRING, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE9a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_OPERATOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE10a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_VARIABLE, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE11a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_SENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE12a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_PREPROCESSOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE13a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_SPECIAL, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE14a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_EXPAND, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE15a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_COMOBJ, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
		$Split = StringSplit($SCE_AU3_STYLE16a, "|", 2)
		If UBound($Split) - 1 = 4 Then SetStyle($sci, $SCE_AU3_UDF, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
	EndIf



	SetProperty($sci, "fold", "1")
	SetProperty($sci, "fold.compact", "0")
	SetProperty($sci, "fold.comment", "1")
	SetProperty($sci, "fold.preprocessor", "1")



	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_ARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_BOXMINUS)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_ARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERMIDTAIL, $SC_MARK_TCORNER)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPENMID, $SC_MARK_BOXMINUS)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERSUB, $SC_MARK_VLINE)
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERTAIL, $SC_MARK_LCORNER)
	SendMessage($sci, $SCI_SETFOLDFLAGS, 16, 0)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDER, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERSUB, 0x808080)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEREND, 0x808080)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEREND, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERTAIL, 0x808080)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERMIDTAIL, 0x808080)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDER, 0x808080)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEROPEN, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEROPEN, 0x808080)
	SendMessage($sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEROPENMID, 0xFFFFFF)
	SendMessage($sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEROPENMID, 0x808080)


;~     SendMessage($Sci_handle, $SCI_CLEARCMDKEY,0x0D, 0); Enter sperren



	SendMessage($sci, $SCI_CLEARCMDKEY, 0x09, 0) ; Tab (We use our own paste function)
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_SHIFT, -16) + 0x09, 0) ; SHIFT + TAB
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x56, 0) ; Ctrl + V (We use our own paste function)
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x44, 0) ; Ctrl + D
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x44, 0) ; Ctrl + SHIFT + D
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x45, 0) ; Ctrl + E
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x45, 0) ; Ctrl + SHIFT + E
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x47, 0) ; Ctrl + G
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x47, 0) ; Ctrl + SHIFT + G
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4E, 0) ; Ctrl + N
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4E, 0) ; Ctrl + SHIFT + N
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4F, 0) ; Ctrl + O
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4F, 0) ; Ctrl + SHIFT + O
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x53, 0) ; Ctrl + S
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x53, 0) ; Ctrl + SHIFT + S
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x50, 0) ; Ctrl + P
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x50, 0) ; Ctrl + SHIFT + P
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x46, 0) ; Ctrl + F
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x46, 0) ; Ctrl + SHIFT + F
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x54, 0) ; Ctrl + T
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x54, 0) ; Ctrl + SHIFT + T
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x57, 0) ; Ctrl + W
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x57, 0) ; Ctrl + SHIFT + W
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x51, 0) ; Ctrl + Q
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x51, 0) ; Ctrl + SHIFT + Q
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x42, 0) ; Ctrl + B
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x42, 0) ; Ctrl + SHIFT + B
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x48, 0) ; Ctrl + H
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x48, 0) ; Ctrl + SHIFT + H
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x49, 0) ; Ctrl + I
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x49, 0) ; Ctrl + SHIFT + I
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4A, 0) ; Ctrl + J
	SendMessage($sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4A, 0) ; Ctrl + SHIFT + J

	SendMessage($sci, $SCI_MARKERDEFINE, 0, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, 1, $SC_MARK_BACKGROUND)
	SendMessage($sci, $SCI_MARKERDEFINE, 2, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERDEFINE, 3, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERSETBACK, 0, 0x0000FF) ; error or warning
	SendMessage($sci, $SCI_MARKERSETBACK, 1, 0xE6E5FF) ; error or warning bg colour
	SendMessage($sci, $SCI_MARKERSETBACK, 2, 0x03C724) ; 'mark all' in search win
	SendMessage($sci, $SCI_MARKERSETBACK, 3, 0x03C724) ; 'mark all' in search win
	SendMessage($sci, $SCI_UsePopup, 0, 0) ;disable context menu




	;Marker 6 (Selection matches)
	SendMessage($sci, $SCI_MARKERDEFINE, 6, $SC_MARK_ARROWS)
	SendMessage($sci, $SCI_MARKERSETFORE, 6, _RGB_to_BGR($scripteditor_highlightcolour))
	SendMessage($sci, $SCI_MARKERSETBACK, 6, _RGB_to_BGR($scripteditor_highlightcolour))

	;Marker 7 (Selection matches)
	SendMessage($sci, $SCI_MARKERDEFINE, 7, $SC_MARK_SHORTARROW)
	SendMessage($sci, $SCI_MARKERSETFORE, 7, _RGB_to_BGR($scripteditor_highlightcolour))
	SendMessage($sci, $SCI_MARKERSETBACK, 7, _RGB_to_BGR($scripteditor_highlightcolour))


	;Marker 5 (Bookmarked Lines)
	SendMessage($sci, $SCI_MARKERDEFINE, 5, $SC_MARK_CIRCLE)
	SendMessage($sci, $SCI_MARKERSETFORE, 5, _RGB_to_BGR($scripteditor_marccolour))
	SendMessage($sci, $SCI_MARKERSETBACK, 5, _RGB_to_BGR($scripteditor_marccolour))

	SendMessage($sci, $SCI_MARKERSETBACK, 0, 0x0000FF)
	SendMessage($sci, $SCI_StyleSetFore, $Style_IndentGuide, 0xC0C0C0) ;Farbe der INDENTATIONGUIDES
	SendMessage($sci, $SCI_SETCARETFORE, _RGB_to_BGR($scripteditor_caretcolour), 0) ;Farbe Caret (Coursor)
	SendMessage($sci, $SCI_SETCARETWIDTH, $scripteditor_caretwidth, 0) ;Caret Breite
	SendMessage($sci, $SetCaretStyle, $scripteditor_caretstyle, 0) ;Caret Style







;~ 	SendMessage($Sci, $SCI_AUTOCSETAUTOHIDE, false, 0)










	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_BOXPLUS) ;
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_BOXMINUS) ;
	SendMessage($sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_EMPTY) ;

	;mark color
	Sci_SetSelectionAlpha($sci, 70)
	Sci_SetSelectionBkColor($sci, _RGB_to_BGR($scripteditor_marccolour), True)


	;current line color
	SendMessage($sci, $SCI_SETCARETLINEBACK, _RGB_to_BGR($scripteditor_rowcolour), 0) ;BGR
	SendMessage($sci, $SCI_SETCARETLINEVISIBLE, 1, 0)

	;autoscrollbar für seeehr lange zeilen ;)
	SendMessage($sci, $SCI_SETSCROLLWIDTHTRACKING, True, 0)

	;Pixmaps
	SendMessage($sci, $SCI_CLEARREGISTEREDIMAGES, 0, 0) ;Lösche Pixmaps

	SendMessage($sci, $SCI_REGISTERIMAGE, 1, DllStructGetPtr($Pixmap_violet_struct, 1)) ;Funktionen
	SendMessage($sci, $SCI_REGISTERIMAGE, 2, DllStructGetPtr($Pixmap_UDF_struct, 1)) ;UDF
	SendMessage($sci, $SCI_REGISTERIMAGE, 3, DllStructGetPtr($Pixmap_blue_struct, 1)) ;Keywoards
	SendMessage($sci, $SCI_REGISTERIMAGE, 4, DllStructGetPtr($Pixmap_macros_struct, 1)) ;macros
	SendMessage($sci, $SCI_REGISTERIMAGE, 5, DllStructGetPtr($Pixmap_preprocessor_struct, 1)) ;preprocessor
	SendMessage($sci, $SCI_REGISTERIMAGE, 6, DllStructGetPtr($Pixmap_red_struct, 1)) ;special
	SendMessage($sci, $SCI_REGISTERIMAGE, 15, DllStructGetPtr($Pixmap_varaiblen_struct, 1)) ;Variablen

	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>SCI_InitEditorAu3

;Prog@ndy, modified _ArraySearch
Func ArraySearchAll(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iPartialfromBeginning = 0, $iForward = 1, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	If $vValue = "" And $iPartialfromBeginning = True Then Return SetError(8, 0, -1)

	; Direction (flip if $iForward = 0)
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
	EndIf
	Local $ResultsArray[$iUBound + 1], $ResultIndex = 0
	Local $iLenValue = StringLen($vValue)
	; Search
	Switch UBound($avArray, 0)
		Case 1 ; 1D array search
			If Not $iPartialfromBeginning Then
				For $i = $iStart To $iEnd Step $iStep
					If $avArray[$i] = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringLeft($avArray[$i], $iLenValue) = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			EndIf
		Case 2 ; 2D array search
			Local $iUBoundSub = UBound($avArray, 2) - 1
			If $iSubItem < 0 Then $iSubItem = 0
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub

			If Not $iPartialfromBeginning Then
				For $i = $iStart To $iEnd Step $iStep
					If $avArray[$i][$iSubItem] = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringLeft($avArray[$i][$iSubItem], $iLenValue) = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			EndIf
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch

	If $ResultIndex = 0 Then Return SetError(6, 0, -1)
	ReDim $ResultsArray[$ResultIndex]
	Return $ResultsArray
EndFunc   ;==>ArraySearchAll

; Author: Prog@ndy
; If the equal entries are one after the other, delete them :)
Func ArraySortUnique(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	Local $ret = _ArraySort($avArray, $iDescending, $iStart, $iEnd, $iSubItem)
	If @error Then Return SetError(@error, 0, $ret)
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

Func _Return_Pixnumber($string = "")
	If $use_new_au3_colours = "true" Then
		If $string = "abs" Then $Pixstring = "?1" ;funcs
		If $string = "_array1dtohistogram" Then $Pixstring = "?2" ;udfs
		If $string = "and" Then $Pixstring = "?3" ;keywords
		If $string = "@appdatacommondir" Then $Pixstring = "?4" ;macros
		If $string = "#ce" Then $Pixstring = "?5" ;preprocessor
		If $string = "#AutoIt3Wrapper_Add_Constants" Then $Pixstring = "?6" ;preprocessor
		If $string = "#endregion" Then $Pixstring = "?6" ;special
		If $string = "{!}" Then $Pixstring = "" ;back to normal
	Else
		If $string = "abs" Then $Pixstring = "?3" ;funcs
		If $string = "_array1dtohistogram" Then $Pixstring = "?2" ;udfs
		If $string = "and" Then $Pixstring = "?3" ;keywords
		If $string = "@appdatacommondir" Then $Pixstring = "?1" ;macros
		If $string = "#ce" Then $Pixstring = "?1" ;preprocessor
		If $string = "#AutoIt3Wrapper_Add_Constants" Then $Pixstring = "?4" ;preprocessor
		If $string = "#endregion" Then $Pixstring = "?4" ;special
		If $string = "{!}" Then $Pixstring = "" ;back to normal
	EndIf
	Return $Pixstring
EndFunc   ;==>_Return_Pixnumber

Func _ISN_Undocked_Tab_Info_Set_State($state = "show")

	Local $tabsize = ControlGetPos($StudioFenster, "", $htab)
	If Not IsArray($tabsize) Then Return


	Switch $state

		Case "repos"
			If Not BitAND(GUICtrlGetState($ISN_Undocked_Tab_Info_Label), $GUI_SHOW) Then Return
			GUICtrlSetPos($ISN_Undocked_Tab_Info_Label, $tabsize[0] + 60, $tabsize[1] + 38, $tabsize[2] - 100, 32 * $DPI)
			GUICtrlSetPos($ISN_Undocked_Tab_Info_Icon, $tabsize[0] + 20, $tabsize[1] + 40, 32, 32)

		Case "show"
			GUICtrlSetPos($ISN_Undocked_Tab_Info_ReDock_Button, $tabsize[0] + 20, $tabsize[1] + 100, 500 * $DPI, 35 * $DPI)
			GUICtrlSetPos($ISN_Undocked_Tab_Info_Label, $tabsize[0] + 60, $tabsize[1] + 38, $tabsize[2] - 100, 32 * $DPI)
			GUICtrlSetPos($ISN_Undocked_Tab_Info_Icon, $tabsize[0] + 20, $tabsize[1] + 40, 32, 32)
			GUICtrlSetState($ISN_Undocked_Tab_Info_Label, $GUI_SHOW)
			GUICtrlSetState($ISN_Undocked_Tab_Info_Icon, $GUI_SHOW)
			GUICtrlSetState($ISN_Undocked_Tab_Info_ReDock_Button, $GUI_SHOW)


		Case Else
			GUICtrlSetState($ISN_Undocked_Tab_Info_Label, $GUI_HIDE)
			GUICtrlSetState($ISN_Undocked_Tab_Info_Icon, $GUI_HIDE)
			GUICtrlSetState($ISN_Undocked_Tab_Info_ReDock_Button, $GUI_HIDE)


	EndSwitch

EndFunc   ;==>_ISN_Undocked_Tab_Info_Set_State


Func _ISN_Undock_Tab($tabNr = -1)
	If $tabNr = -1 Then Return
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[$tabNr] = -1 Then Return ;Only plugin tabs allowed
	If $ISN_Tabs_Additional_Infos_Array[$tabNr][1] = "1" Then Return ;Already undocked

	$Old_Window_Pos = WinGetPos($SCE_EDITOR[$tabNr])
	If Not IsArray($Old_Window_Pos) Then Return
	$ISN_Tabs_Additional_Infos_Array[$tabNr][1] = "1"
	GUISetStyle(BitOR($WS_CAPTION, $WS_SIZEBOX, $WS_SYSMENU, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX), BitOR($ISN_WS_EX_MDICHILD, $WS_EX_APPWINDOW), WinGetHandle($SCE_EDITOR[$tabNr]))
	_WinAPI_SetParent($SCE_EDITOR[$tabNr], 0)
	GUISetBkColor(0xFFFFFF, $SCE_EDITOR[$tabNr])
	GUISetOnEvent($GUI_EVENT_CLOSE, "_ISN_Close_Unlocked_tab_Event", $SCE_EDITOR[$tabNr])
	GUISetOnEvent($GUI_EVENT_RESIZED, "_ISN_Unlocked_Tab_Resized_Event", $SCE_EDITOR[$tabNr])
	$tab_txt = _GUICtrlTab_GetItemText($htab, $tabNr)
	If StringRight($tab_txt, 2) = " *" Then $tab_txt = StringTrimRight($tab_txt, 2)
	_WinAPI_SetWindowText($SCE_EDITOR[$tabNr], $tab_txt & " - " & _Get_langstr(1))
	WinSetOnTop($SCE_EDITOR[$tabNr], "", 0)
	WinMove($SCE_EDITOR[$tabNr], "", $Old_Window_Pos[0] + 50, $Old_Window_Pos[1] + 50, $Old_Window_Pos[2] - 100, $Old_Window_Pos[3] - 100)
	GUISetState(@SW_SHOW, $SCE_EDITOR[$tabNr])

	_WinAPI_RedrawWindow($SCE_EDITOR[$tabNr])

	;Insert Syscontext Item
	If $ISN_Tabs_Additional_Infos_Array[$tabNr][2] = "" Then
		$ISN_Tabs_Additional_Infos_Array[$tabNr][2] = CreateSystemMenuItem($SCE_EDITOR[$tabNr], _Get_langstr(1365), -1, False, 0)
		CreateSystemMenuItem($SCE_EDITOR[$tabNr], "", -1, False, 1)
	EndIf


	_ISN_Undocked_Tab_Info_Set_State("show")
    if not _ist_windows_8_oder_hoeher() then _WinAPI_RedrawWindow($studiofenster)
EndFunc   ;==>_ISN_Undock_Tab

Func _ISN_ReDock_Current_Tab()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$tabNr = _GUICtrlTab_GetCurFocus($htab)
	If $tabNr = -1 Then Return
	_ISN_ReDock_Tab($tabNr)
EndFunc   ;==>_ISN_ReDock_Current_Tab


Func _ISN_ReDock_Tab($tabNr = -1)
	If $Offenes_Projekt = "" Then Return
	If $tabNr = -1 Then Return

	_GUICtrlTab_ActivateTabX($htab, $tabNr, 0)
	_ISN_Undocked_Tab_Info_Set_State("hide")

	$ISN_Tabs_Additional_Infos_Array[$tabNr][1] = ""
	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	If Not IsArray($tabsize) Then Return

    if _ist_windows_8_oder_hoeher() then
	   GUISetStyle($WS_POPUP, $WS_EX_LAYERED, WinGetHandle($SCE_EDITOR[$tabNr]))
	   GUISetBkColor(0xFFEFFA, $SCE_EDITOR[$tabNr])
	   _WinAPI_SetLayeredWindowAttributes($SCE_EDITOR[$tabNr], 0xFFEFFA, 255)
	Else
	  GUISetStyle($WS_POPUP, -1, WinGetHandle($SCE_EDITOR[$tabNr]))
	  GUISetBkColor(0xFFFFFF, $SCE_EDITOR[$tabNr])
	Endif

    GUISetOnEvent($GUI_EVENT_CLOSE, "", $SCE_EDITOR[$tabNr])
	GUISetOnEvent($GUI_EVENT_RESIZED, "", $SCE_EDITOR[$tabNr])
	_WinAPI_SetParent($SCE_EDITOR[$tabNr], $Studiofenster)
	$y = $tabsize[1] + $Tabseite_hoehe
	$x = $tabsize[0] + 4
	_WinAPI_SetWindowPos($SCE_EDITOR[$tabNr], $HWND_TOPMOST, $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_HIDEWINDOW)
	_WinAPI_SetWindowPos($SCE_EDITOR[$tabNr], _WinAPI_GetWindow(WinGetHandle($Studiofenster), $GW_HWNDNEXT), $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_HIDEWINDOW)
	$plugsize = WinGetClientSize($SCE_EDITOR[$tabNr])
	If Not IsArray($plugsize) Then Return
	_WinAPI_SetWindowPos($Plugin_Handle[$tabNr], $HWND_TOP, 0, 0, $plugsize[0], $plugsize[1], $SWP_HIDEWINDOW)
	_WinAPI_SetWindowPos($Plugin_Handle[$tabNr], 0, 0, 0, 0, 0, $SWP_SHOWWINDOW + $SWP_NOACTIVATE + $SWP_NOMOVE + $SWP_NOREPOSITION)
	_WinAPI_SetWindowPos($SCE_EDITOR[$tabNr], 0, 0, 0, 0, 0, $SWP_SHOWWINDOW + $SWP_NOACTIVATE + $SWP_NOMOVE + $SWP_NOREPOSITION)

	_Show_Tab($tabNr)
	_WinAPI_RedrawWindow($Plugin_Handle[$tabNr])
EndFunc   ;==>_ISN_ReDock_Tab


Func _ISN_Close_Unlocked_tab_Event()
	Local $closed_GUI = @GUI_WinHandle
	Local $res = _ArraySearch($ISN_Tabs_Additional_Infos_Array, $closed_GUI, 0, 0, 0, 0, 1, 0)
	If $res = -1 Or @error Then Return
	GUISetState(@SW_HIDE, $closed_GUI)
	try_to_Close_Tab($res)
EndFunc   ;==>_ISN_Close_Unlocked_tab_Event


Func _ISN_Unlocked_Tab_Resized_Event()
	Local $GUI = @GUI_WinHandle
	Local $index_res = _ArraySearch($ISN_Tabs_Additional_Infos_Array, $GUI, 0, 0, 0, 0, 1, 0)
	If $index_res = -1 Or @error Then Return
	If $ISN_Tabs_Additional_Infos_Array[$index_res][1] <> "1" Then Return
	_WinAPI_RedrawWindow($Plugin_Handle[$index_res])

EndFunc   ;==>_ISN_Unlocked_Tab_Resized_Event



Func _Autocomplete_Brackets_Ckeck_Overwrite($sci = "", $startElement = "(", $closeElement = ")")
	If $ScriptEditor_Autocomplete_Brackets <> "true" Then Return 0
	If $sci = "" Then Return -1
	$BracketsAutocomplete_is_allowed = 0

	Local $current_pos = Sci_GetCurrentPos($sci)
	Local $Current_Line = Sci_GetLineFromPos($sci, $current_pos)
	Local $current_line_text = Sci_GetLine($sci, $Current_Line)
;~    local $current_line_end_pos = Sci_GetLineEndPos($Sci, $current_line)
	_StripCommentLines($current_line_text) ;Strip comments

;~    if $current_pos <> Sci_GetLineEndPos($Sci, $current_line) OR
;~    if $current_pos +1 > $current_line_end_pos then return 0
;~ MsgBox(0,"",Sci_GetChar($Sci, $current_pos))
;~    If StringStripWS(Sci_GetChar($Sci, $current_pos), 8) <> "" then return 0 ;We need no autocomplete

	ConsoleWrite($current_line_text & @CRLF)
	StringReplace($current_line_text, $startElement, "")
	If @error Then Return 0
	Local $Start_elements_cnt = @extended
	If $Start_elements_cnt < 1 Then Return 0
	StringReplace($current_line_text, $closeElement, "")
	If @error Then Return
	Local $Close_elements_cnt = @extended
	If $Close_elements_cnt < 1 Then Return 0

	If Number($Start_elements_cnt) = Number($Close_elements_cnt) Then Return 1 ;We need no autocomplete
;~    SendMessageString($Sci, $SCI_CHANGEINSERTION, StringLen($startElement&$closeElement), $startElement&$closeElement)
;~    Sci_SetCurrentPos($Sci, $current_pos-1)
;~ 	Sci_InsertText($Sci, $current_pos, ")")
;~ 	$BracketsAutocomplete_is_allowed = 1
	Return 1

EndFunc   ;==>_Autocomplete_Brackets_Ckeck_Overwrite


Func _Brace_highlighting_CkeckBrace($char = "")
	Switch $char
		Case '(', ')', '[', ']', '{', '}', '<', '>'
			Return True
	EndSwitch
	Return False
EndFunc   ;==>_Brace_highlighting_CkeckBrace

Func _Scintilla_Forece_Show_CallTip()
	If $Offenes_Projekt = "" Then Return
	Local $current_Scintilla_Window = _WinAPI_GetFocus()
	If _WinAPI_GetClassName($current_Scintilla_Window) <> "Scintilla" Then Return
	_Scintilla_CallTip_ShowHide_Check($current_Scintilla_Window, 1)
EndFunc   ;==>_Scintilla_Forece_Show_CallTip

Func _Scintilla_Refresh_CallTip($sci = "")

	If SendMessage($sci, $SCI_CALLTIPACTIVE, 0, 0) Then

		$Lastchar = Sci_GetChar($sci, Sci_GetCurrentPos($sci) - 1)

		$funcname_from_pos = _SCI_Funcname_aus_Position($sci)
		If $funcname_from_pos = "" Then Return
		If $funcname_from_pos <> $Current_CalltipFunc Then
			_Scintilla_CallTip_ShowHide_Check($sci, 1)
			Return
		EndIf

		$trimleft = ""
		$Pos = Sci_GetCurrentPos($sci)

		$SCI_TextZeile = Sci_GetLine($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci)))
		$SCI_Startpos = Sci_GetLineStartPos($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci)))
		$Pos_in_Line = $Pos - $SCI_Startpos
		$closecount = 0
		For $count = $Pos_in_Line - 1 To 0 Step -1
			$char = Sci_GetChar($sci, $SCI_Startpos + $count)
			If $char = ")" Then $closecount = $closecount + 1
			If $char = "(" Then
				If $closecount <> 0 Then
					$closecount = $closecount - 1
					ContinueLoop
				EndIf
				$trimleft = $count
				ExitLoop
			EndIf
		Next

		$Parastring = StringTrimLeft(Sci_GetLine($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci))), $trimleft)
		$Parastring = _StringInsert($Parastring, "#-cursor-#", Sci_GetCurrentPos($sci) - $SCI_Startpos - $trimleft) ;Coursorpos einfügen

		$trim_right = 0
		$geoeffnete_klammern = 0
		$geschlossene_klammern = 0
		For $count = 0 To StringLen($Parastring)
			$char = StringMid($Parastring, $count, 1)
			If $char = "(" Then $geoeffnete_klammern = $geoeffnete_klammern + 1
			If $char = ")" Then
				If $geoeffnete_klammern > 1 Then
					$geoeffnete_klammern = $geoeffnete_klammern - 1
					ContinueLoop
				EndIf
				$trim_right = StringLen($Parastring) - $count
				ExitLoop
			EndIf
		Next

		$Parastring = StringTrimRight($Parastring, $trim_right)
		$Parastring = StringTrimRight($Parastring, StringLen($Parastring) - StringInStr($Parastring, "#-cursor-#") + 1)
		$Parastring = StringReplace($Parastring, @CRLF, "")
		$Parastring = StringStripWS($Parastring, 8)

		$Parastring = $Parastring & ")"

		$Komma_anzahl = _Zeige_Parameter_Editor("123", $Parastring, 1) ;Nutze die "inteligenz" des Parameter Editors um die Anzahl der Kommas herauszufinden
		$Komma_anzahl = $Komma_anzahl - 1
;~ 					ConsoleWrite($Parastring&"      "&$Komma_anzahl&@crlf)



		$SCI_hlStart = StringInStr($SCI_sCallTip, ",", 0, $Komma_anzahl)
		Local $iTemp = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ",") + $SCI_hlStart
		If StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart < $iTemp Or $iTemp - $SCI_hlStart = 0 Then
			$SCI_hlEnd = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart
		Else
			$SCI_hlEnd = $iTemp
		EndIf
		SendMessage($sci, $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)



		$selected_calltip_text = StringTrimRight($SCI_sCallTip, StringLen($SCI_sCallTip) - $SCI_hlEnd)
		$selected_calltip_text = StringTrimLeft($selected_calltip_text, $SCI_hlStart)
		If StringInStr($selected_calltip_text, "(") Then $selected_calltip_text = StringTrimLeft($selected_calltip_text, StringInStr($selected_calltip_text, "("))
		If Not StringInStr($selected_calltip_text, "(") And Not StringInStr($selected_calltip_text, ",") And (StringInStr($selected_calltip_text, "color") Or StringInStr($selected_calltip_text, "colour") Or StringInStr($selected_calltip_text, "background")) Then
			_Colour_Calltipp_Set_State("show", $sci)
		Else
			$farb_picker_GUIstate = WinGetState($mini_farb_picker_GUI, "")
			If BitAND($farb_picker_GUIstate, 2) Then _Colour_Calltipp_Set_State("hide", $sci)
		EndIf

	EndIf

EndFunc   ;==>_Scintilla_Refresh_CallTip

Func _Scintilla_CallTip_ShowHide_Check($sci = "", $force_refresh = 0)

	If $disableintelisense = "true" Then Return
	$Lastchar = Sci_GetChar($sci, Sci_GetCurrentPos($sci) - 1)

	If Not SendMessage($sci, $SCI_CALLTIPACTIVE, 0, 0) Or ($Lastchar = "," Or $Lastchar = "(") Or $force_refresh = 1 Then

		$Line_Text = Sci_GetLine($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci)))

		;For Includes
		If StringInStr($Line_Text, "#include") Then


			$Line_Text = StringReplace($Line_Text, @TAB, "")
			$Line_Text = StringStripWS($Line_Text, 7)
			StringReplace($Line_Text, "<", "")
			If @extended > 1 Then Return
			StringReplace($Line_Text, '"', "")
			If @extended > 2 Then Return
			If StringInStr($Line_Text, "." & $Autoitextension) Then Return ;include already finished
			If StringInStr($Line_Text, ".isf") Then Return ;include already finished
			$Includes_Autocompletelist = @CR

			If StringInStr($Line_Text, "<") Then
				;List Includes from the AutoIt3 Includes Directory
				$Includes_Autocompletelist = $SCI_AutoIt_Includes_List
			Else
				;List au3 and isf Files from the Project
				If $Studiomodus = 2 Then Return
				$Exclude_dir = ""
				If $backupmode = "2" Then
					;Exclude the Backup dir
					$Exclude_dir = _ISN_Variablen_aufloesen("%backupdir%")
					$Exclude_dir = StringReplace($Exclude_dir, $Offenes_Projekt, "")
					If StringLeft($Exclude_dir, 1) = "\" Then $Exclude_dir = StringTrimLeft($Exclude_dir, 1)
				EndIf

				$Project_Includes_Array = _FileListToArrayRec($Offenes_Projekt, "*.au3;*.isf||backup;" & $Exclude_dir, $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_NOSORT, $FLTAR_RELPATH)
				If IsArray($Project_Includes_Array) Then
					_ArrayDelete($Project_Includes_Array, 0)
					ArraySortUnique($Project_Includes_Array, 0, 1)
					$Includes_Autocompletelist = _ArrayToString($Project_Includes_Array, '?1' & @CR)
					$Includes_Autocompletelist = $Includes_Autocompletelist & '?1'
					$Includes_Autocompletelist = _UNICODE2ANSI($Includes_Autocompletelist)
				EndIf
			EndIf
			SendMessage($sci, $SCI_AUTOCSETORDER, $SC_ORDER_PERFORMSORT, 0) ;Autocomplete Liste durch Scintilla sortieren (Wichtig: Verhindert den $_ Bug!)
			SendMessageString($sci, $SCI_AUTOCSHOW, 0, $Includes_Autocompletelist)





		Else
			;The normal stuff


			;by isi360
			$funcname = _SCI_Funcname_aus_Position($sci)
			$Current_CalltipFunc = $funcname
			Local $ret, $sText, $iPos = SendMessage($sci, $Sci_GetCurrentPos, 0, 0), $sFuncName
			$SCI_sCallTipFoundIndices = ArraySearchAll($SCI_sCallTip_Array, $funcname, 0, 0, 1)
			$sBuf = 0
			$SCI_sCallTipSelectedIndice = 0
			$SCI_sCallTip = ""
			If IsArray($SCI_sCallTipFoundIndices) Then

				;$SCI_sCallTip = Chr(1) & "1/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]
				$SCI_sCallTip = $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]

;~ 			$SCI_sCallTip = StringReplace(StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "(.{70,110} )", "$1" & @LF), @LF & @LF, @LF)

				$SCI_sCallTip = StringReplace($SCI_sCallTip, ") ", ")" & @LF, 1)
				$SCI_sCallTip = StringRegExpReplace($SCI_sCallTip, "[?]\d", "", 1)
				If @extended = 0 Then $SCI_sCallTip = StringReplace($SCI_sCallTip, ")", ")" & @LF, 1)

				;Fixes for some AutoIt Calltips
				If StringInStr($SCI_sCallTip, "AutoItSetOption (") Or StringInStr($SCI_sCallTip, "Opt (") Then
					$SCI_sCallTip = StringRegExpReplace($SCI_sCallTip, "<[^>]*>", "")
					$SCI_sCallTip = StringReplace($SCI_sCallTip, ". ", "." & @LF)
					$SCI_sCallTip = StringReplace($SCI_sCallTip, ": ", ":" & @LF)
				EndIf

				SendMessageString($sci, $SCI_CALLTIPSHOW, $_SCI_Funcname_aus_Position_found_pos, $SCI_sCallTip)

			EndIf
		EndIf
	EndIf



	_Scintilla_Refresh_CallTip($sci)

EndFunc   ;==>_Scintilla_CallTip_ShowHide_Check

Func _Studiofenster_Refresh_Menu_Checkboxes()


	If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id12), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id12, _GUICtrlToolbar_GetButtonState($hToolbar, $id12) - $TBSTATE_ENABLED)


	If $Erweitertes_debugging = "true" Then
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_aktivieren, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_aktivieren, $MFS_CHECKED, True, False) ;Check
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_deaktivieren, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_deaktivieren, $MFS_CHECKED, False, False) ;UnCheck
	Else
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_deaktivieren, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_deaktivieren, $MFS_CHECKED, True, False) ;Check
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_aktivieren, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $Tools_menu_debugging_erweitertes_debugging_aktivieren, $MFS_CHECKED, False, False) ;UnCheck
	EndIf

	If $scripteditor_display_indentationguides = "true" Then
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayIndentationGuides, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayIndentationGuides, $MFS_CHECKED, True, False) ;Check
	Else
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayIndentationGuides, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayIndentationGuides, $MFS_CHECKED, False, False) ;UnCheck
	EndIf

	If $showlines = "true" Then
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ShowLineNumbers, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ShowLineNumbers, $MFS_CHECKED, True, False) ;Check
	Else
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ShowLineNumbers, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ShowLineNumbers, $MFS_CHECKED, False, False) ;UnCheck
	EndIf

	If $scripteditor_fold_margin = "true" Then
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_FoldMargin, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_FoldMargin, $MFS_CHECKED, True, False) ;Check
	Else
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_FoldMargin, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_FoldMargin, $MFS_CHECKED, False, False) ;UnCheck
	EndIf

	If $scripteditor_bookmark_margin = "true" Then
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_BookmarkMargin, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_BookmarkMargin, $MFS_CHECKED, True, False) ;Check
	Else
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_BookmarkMargin, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_BookmarkMargin, $MFS_CHECKED, False, False) ;UnCheck
	EndIf

	If $scripteditor_display_whitespace = "true" Then
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayWhitespace, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayWhitespace, $MFS_CHECKED, True, False) ;Check
	Else
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayWhitespace, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayWhitespace, $MFS_CHECKED, False, False) ;UnCheck
	EndIf

	If $scripteditor_display_endofline = "true" Then
		If Not BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayEndofLine, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayEndofLine, $MFS_CHECKED, True, False) ;Check
	Else
		If BitAND(_GUICtrlMenu_GetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayEndofLine, False), 1) Then _GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayEndofLine, $MFS_CHECKED, False, False) ;UnCheck
	EndIf



EndFunc   ;==>_Studiofenster_Refresh_Menu_Checkboxes


Func _ViewMenu_Toggle_ShowLines()
	If $showlines = "true" Then
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ShowLineNumbers, $MFS_CHECKED, False, False) ;UnCheck
		$showlines = "false"
		_Write_in_Config("showlines", "false")
	Else
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ShowLineNumbers, $MFS_CHECKED, True, False) ;Check
		$showlines = "true"
		_Write_in_Config("showlines", "true")
	EndIf

	_Refresh_ViewSettings_for_Scintilla_Controls()
EndFunc   ;==>_ViewMenu_Toggle_ShowLines

Func _ViewMenu_Toggle_BookmarkMargin()
	If $scripteditor_bookmark_margin = "true" Then
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_BookmarkMargin, $MFS_CHECKED, False, False) ;UnCheck
		$scripteditor_bookmark_margin = "false"
		_Write_in_Config("scripteditor_bookmark_margin", "false")
	Else
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_BookmarkMargin, $MFS_CHECKED, True, False) ;Check
		$scripteditor_bookmark_margin = "true"
		_Write_in_Config("scripteditor_bookmark_margin", "true")
	EndIf

	_Refresh_ViewSettings_for_Scintilla_Controls()
EndFunc   ;==>_ViewMenu_Toggle_BookmarkMargin




Func _ViewMenu_Toggle_FoldMargin()
	If $scripteditor_fold_margin = "true" Then
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_FoldMargin, $MFS_CHECKED, False, False) ;UnCheck
		$scripteditor_fold_margin = "false"
		_Write_in_Config("scripteditor_fold_margin", "false")
	Else
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_FoldMargin, $MFS_CHECKED, True, False) ;Check
		$scripteditor_fold_margin = "true"
		_Write_in_Config("scripteditor_fold_margin", "true")
	EndIf

	_Refresh_ViewSettings_for_Scintilla_Controls()
EndFunc   ;==>_ViewMenu_Toggle_FoldMargin

Func _ViewMenu_Toggle_DisplayWhitespace()
	If $scripteditor_display_whitespace = "true" Then
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayWhitespace, $MFS_CHECKED, False, False) ;UnCheck
		$scripteditor_display_whitespace = "false"
		_Write_in_Config("scripteditor_display_whitespace", "false")
	Else
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayWhitespace, $MFS_CHECKED, True, False) ;Check
		$scripteditor_display_whitespace = "true"
		_Write_in_Config("scripteditor_display_whitespace", "true")
	EndIf

	_Refresh_ViewSettings_for_Scintilla_Controls()
EndFunc   ;==>_ViewMenu_Toggle_DisplayWhitespace

Func _ViewMenu_Toggle_DisplayEndOfLine()
	If $scripteditor_display_endofline = "true" Then
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayEndofLine, $MFS_CHECKED, False, False) ;UnCheck
		$scripteditor_display_endofline = "false"
		_Write_in_Config("scripteditor_display_end_of_line", "false")
	Else
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayEndofLine, $MFS_CHECKED, True, False) ;Check
		$scripteditor_display_endofline = "true"
		_Write_in_Config("scripteditor_display_end_of_line", "true")
	EndIf

	_Refresh_ViewSettings_for_Scintilla_Controls()
EndFunc   ;==>_ViewMenu_Toggle_DisplayEndOfLine

Func _ViewMenu_Toggle_IndentationGuides()
	If $scripteditor_display_indentationguides = "true" Then
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayIndentationGuides, $MFS_CHECKED, False, False) ;UnCheck
		$scripteditor_display_indentationguides = "false"
		_Write_in_Config("scripteditor_display_indentation_guides", "false")
	Else
		_GUICtrlMenu_SetItemState($StudioFenster_MenuHandle, $ViewMenu_ScriptEditor_DisplayIndentationGuides, $MFS_CHECKED, True, False) ;Check
		$scripteditor_display_indentationguides = "true"
		_Write_in_Config("scripteditor_display_indentation_guides", "true")
	EndIf

	_Refresh_ViewSettings_for_Scintilla_Controls()
EndFunc   ;==>_ViewMenu_Toggle_IndentationGuides


Func _Refresh_ViewSettings_for_Scintilla_Controls($reload_colors = 0)
	If $Offenes_Projekt <> "" Then

		If _GUICtrlTab_GetItemCount($htab) > 0 Then
			For $cnt = 0 To UBound($SCE_EDITOR) - 1
				If $Plugin_Handle[$cnt] = -1 Then

					If $reload_colors <> 0 Then

						SetStyle($SCE_EDITOR[$cnt], $STYLE_DEFAULT, _RGB_to_BGR($Schriftfarbe), _RGB_to_BGR($scripteditor_bgcolour), $scripteditor_size, $scripteditor_font)


						;Marker 6 (Selection matches)
						SendMessage($SCE_EDITOR[$cnt], $SCI_MARKERSETFORE, 6, _RGB_to_BGR($scripteditor_highlightcolour))
						SendMessage($SCE_EDITOR[$cnt], $SCI_MARKERSETBACK, 6, _RGB_to_BGR($scripteditor_highlightcolour))

						;Marker 7 (Selection matches)
						SendMessage($SCE_EDITOR[$cnt], $SCI_MARKERSETFORE, 7, _RGB_to_BGR($scripteditor_highlightcolour))
						SendMessage($SCE_EDITOR[$cnt], $SCI_MARKERSETBACK, 7, _RGB_to_BGR($scripteditor_highlightcolour))


						;Marker 5 (Bookmarked Lines)
						SendMessage($SCE_EDITOR[$cnt], $SCI_MARKERSETFORE, 5, _RGB_to_BGR($scripteditor_marccolour))
						SendMessage($SCE_EDITOR[$cnt], $SCI_MARKERSETBACK, 5, _RGB_to_BGR($scripteditor_marccolour))
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETCARETFORE, _RGB_to_BGR($scripteditor_caretcolour), 0) ;Farbe Caret (Coursor)


						;mark color
						Sci_SetSelectionBkColor($SCE_EDITOR[$cnt], _RGB_to_BGR($scripteditor_marccolour), True)

						;Multi Selection
						If $Scripteditor_EnableMultiCursor = "true" Then
							SendMessage($SCE_EDITOR[$cnt], $SCI_SETMULTIPLESELECTION, True, 0)
							SendMessage($SCE_EDITOR[$cnt], $SCI_SETMULTIPASTE, $SC_MULTIPASTE_EACH, 0)
							SendMessage($SCE_EDITOR[$cnt], $SCI_SETADDITIONALSELECTIONTYPING, 1, 0)
						Else
							SendMessage($SCE_EDITOR[$cnt], $SCI_SETMULTIPLESELECTION, False, 0)
							SendMessage($SCE_EDITOR[$cnt], $SCI_SETADDITIONALSELECTIONTYPING, 0, 0)
						EndIf


						;current line color
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETCARETLINEBACK, _RGB_to_BGR($scripteditor_rowcolour), 0) ;BGR

						;Set BraceLight Colors
						SendMessage($SCE_EDITOR[$cnt], $SCI_STYLESETBACK, $STYLE_BRACELIGHT, _RGB_to_BGR($scripteditor_bracelight_colour))
						SendMessage($SCE_EDITOR[$cnt], $SCI_STYLESETBACK, $STYLE_BRACEBAD, _RGB_to_BGR($scripteditor_bracebad_colour))

						If $use_new_au3_colours = "true" Then
							;Neuer Farbstiel
							$Split = StringSplit($SCE_AU3_STYLE1b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_DEFAULT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE2b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_COMMENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE3b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_COMMENTBLOCK, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE4b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_NUMBER, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE5b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_FUNCTION, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE6b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_KEYWORD, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE7b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_MACRO, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE8b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_STRING, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE9b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_OPERATOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE10b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_VARIABLE, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE11b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_SENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE12b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_PREPROCESSOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE13b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_SPECIAL, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE14b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_EXPAND, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE15b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_COMOBJ, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE16b, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_UDF, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
						Else
							$Split = StringSplit($SCE_AU3_STYLE1a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_DEFAULT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE2a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_COMMENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE3a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_COMMENTBLOCK, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE4a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_NUMBER, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE5a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_FUNCTION, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE6a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_KEYWORD, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE7a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_MACRO, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE8a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_STRING, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE9a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_OPERATOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE10a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_VARIABLE, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE11a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_SENT, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE12a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_PREPROCESSOR, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE13a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_SPECIAL, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE14a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_EXPAND, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE15a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_COMOBJ, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
							$Split = StringSplit($SCE_AU3_STYLE16a, "|", 2)
							If UBound($Split) - 1 = 4 Then SetStyle($SCE_EDITOR[$cnt], $SCE_AU3_UDF, $Split[0], $Split[1], 0, "", $Split[2], $Split[3], $Split[4])
						EndIf
					EndIf

					If $showlines = "false" Then
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETMARGINWIDTHN, 0, 0)
					Else
						$pixelWidth = SendMessageString($SCE_EDITOR[$cnt], $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "9999999")
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETMARGINWIDTHN, 0, $pixelWidth) ;
					EndIf

					If $scripteditor_fold_margin = "false" Then
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 0)
					Else
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 20)
					EndIf

					If $scripteditor_bookmark_margin = "false" Then
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 0)
					Else
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 16)
					EndIf

					If $scripteditor_display_whitespace = "false" Then
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETVIEWWS, $SCWS_INVISIBLE, 0)
					Else
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETVIEWWS, $SCWS_VISIBLEALWAYS, 0)
					EndIf

					If $scripteditor_display_endofline = "false" Then
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETVIEWEOL, False, 0)
					Else
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETVIEWEOL, True, 0)
					EndIf


					If $scripteditor_display_indentationguides = "false" Then
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETINDENTATIONGUIDES, $SC_IV_NONE, 0)
					Else
						SendMessage($SCE_EDITOR[$cnt], $SCI_SETINDENTATIONGUIDES, $SC_IV_LOOKBOTH, 0)
					EndIf


					SendMessage($SCE_EDITOR[$cnt], $SCI_SETZOOM, $scripteditor_Zoom, 0) ;Set Zoom
					SendMessage($SCE_EDITOR[$cnt], $SCI_SETCARETWIDTH, $scripteditor_caretwidth, 0) ;Caret width
					SendMessage($SCE_EDITOR[$cnt], $SetCaretStyle, $scripteditor_caretstyle, 0) ;Caret Style



				EndIf
			Next


		EndIf
	EndIf


EndFunc   ;==>_Refresh_ViewSettings_for_Scintilla_Controls


Func _Scintilla_check_Brace_highlighting($sci = "",$PosOffset = 0)
	If $sci = "" Then Return

	;Brace highlighting (thx to jacobslusser)
	$caretPos = Sci_GetCurrentPos($sci) + $PosOffset
	If ($lastCaretPos <> $caretPos) Then

		_Scintilla_Refresh_CallTip($sci)

		$lastCaretPos = $caretPos
		$bracePos1 = -1
		$bracePos2 = -1

		If ($caretPos > 0 And _Brace_highlighting_CkeckBrace(Sci_GetChar($sci, $caretPos - 1))) Then
			$bracePos1 = ($caretPos - 1)
		 ElseIf (_Brace_highlighting_CkeckBrace(Sci_GetChar($sci, $caretPos))) Then
			$bracePos1 = $caretPos
		EndIf

		If ($bracePos1 >= 0) Then
			$bracePos2 = SendMessage($sci, $SCI_BRACEMATCH, $bracePos1, 0)
			If $ScriptEditor_highlight_brackets = "true" Then
				If ($bracePos2 == $INVALID_POSITION) Then
					SendMessage($sci, $SCI_BRACEBADLIGHT, $bracePos1, 0)
				Else
					SendMessage($sci, $SCI_BRACEHIGHLIGHT, $bracePos1, $bracePos2)
				EndIf
			EndIf

		Else
			SendMessage($sci, $SCI_BRACEHIGHLIGHT, $INVALID_POSITION, $INVALID_POSITION)
		EndIf
	EndIf
EndFunc   ;==>_Scintilla_check_Brace_highlighting

Func _Scintilla_Test_Selected_Codelines($handle = "")
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $handle = "" Then $handle = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]

	;Falls im Editor etwas Markiert ist, nur Markierten Text ausgeben
	Local $startPosition = SendMessage($handle, $SCI_GETSELECTIONSTART, 0, 0)
	Local $endPosition = SendMessage($handle, $SCI_GETSELECTIONEND, 0, 0)
	Local $Text = ""
	If $startPosition <> $endPosition Then
		$Text = SCI_GetTextRange($handle, $startPosition, $endPosition)
	Else
		$Text = Sci_GetLine($handle, Sci_GetLineFromPos($handle, $startPosition))
	EndIf



	;Write file
	If FileExists($Arbeitsverzeichnis & "\Data\Cache\temprun.au3") Then FileDelete($Arbeitsverzeichnis & "\Data\Cache\temprun.au3")
	Local $filehandle = FileOpen($Arbeitsverzeichnis & "\Data\Cache\temprun.au3", 2 + $FO_UTF8_NOBOM)
	If Not FileWrite($filehandle, _ANSI2UNICODE($Text)) Then
		FileClose($filehandle)
		Return -1
	EndIf
	FileClose($filehandle)

	;test file
	_Testscript($Arbeitsverzeichnis & "\Data\Cache\temprun.au3")
EndFunc   ;==>_Scintilla_Test_Selected_Codelines


Func _Scintilla_InsertBracketsAroundSelection($sci = "", $Bracket = "(")
	If $Scripteditor_AllowBracketpairs <> "true" Then Return 0
	If $sci = "" Then Return 0
	Local $New_Text = $Scintilla_LastDeletedText
	$New_Text = StringStripWS($New_Text, 3)
	If (_IsPressed("10", $user32) Or _IsPressed("12", $user32)) And $Scintilla_LastDeletedText <> "" Then

		Switch $Bracket

			Case "("
				If StringLeft($New_Text, 1) <> "(" Then $New_Text = "(" & $New_Text
				If StringRight($New_Text, 1) <> ")" Then $New_Text = $New_Text & ")"

			Case "["
				If StringLeft($New_Text, 1) <> "[" Then $New_Text = "[" & $New_Text
				If StringRight($New_Text, 1) <> "]" Then $New_Text = $New_Text & "]"

			Case "{"
				If StringLeft($New_Text, 1) <> "{" Then $New_Text = "{" & $New_Text
				If StringRight($New_Text, 1) <> "}" Then $New_Text = $New_Text & "}"

			Case "'"
				If StringLeft($New_Text, 1) <> "'" Then $New_Text = "'" & $New_Text
				If StringRight($New_Text, 1) <> "'" Then $New_Text = $New_Text & "'"

			Case '"'
				If StringLeft($New_Text, 1) <> '"' Then $New_Text = '"' & $New_Text
				If StringRight($New_Text, 1) <> '"' Then $New_Text = $New_Text & '"'

			Case Else
				Return 0

		EndSwitch

		$Scintilla_LastInsertedChar = "-1" ;Prevent auto complete for brackets
		$Scintilla_LastDeletedText = "" ;Reset
		SendMessageString($sci, $SCI_CHANGEINSERTION, StringLen($New_Text), $New_Text)
		Return 1
	EndIf
EndFunc   ;==>_Scintilla_InsertBracketsAroundSelection





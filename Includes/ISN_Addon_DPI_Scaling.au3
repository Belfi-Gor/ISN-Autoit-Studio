;DPI_Scaling.au3

;DPI Func
Func _GetDPI()
	Local $hDC = _WinAPI_GetDC(0)
	Local $DPI = _WinAPI_GetDeviceCaps($hDC, 90)
	_WinAPI_ReleaseDC(0, $hDC)

	Select
		Case $DPI = 0
			$DPI = 1
		Case $DPI < 84
			$DPI /= 105
		Case $DPI < 121
			$DPI /= 96
		Case $DPI < 145
			$DPI /= 95
		Case Else
			$DPI /= 94
	EndSelect

	Return Round($DPI, 2)
EndFunc   ;==>_GetDPI

; #FUNCTION# ====================================================================================================================
; Name ..........: _Fenster_Resizen_und_zentrieren
; Description ...:
; Syntax ........: _Fenster_Resizen_und_zentrieren($win, $txt [, $width=Default [, $height=Default]])
; Parameters ....: $win                 - An unknown value.
;                  $txt                 - A dll struct value.
;                  $width               - [optional] An AutoIt controlID. Default is Default.
;                  $height              - [optional] A handle value. Default is Default.
; Return values .: None
; Author ........: Christian Faderl
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Fenster_Resizen_und_zentrieren($win, $txt, $width = Default, $height = Default)
	Local $size = WinGetClientSize($win, $txt)
	If Not ($width = Default) Then $size[0] = $width
	If Not ($height = Default) Then $size[1] = $height
	Local $x = (@DesktopWidth / 2) - ($size[0] / 2)
	Local $y = (@DesktopHeight / 2) - ($size[1] / 2)
	If $x < 0 Then $x = 0
	If $y < 0 Then $y = 0
	Return WinMove($win, $txt, $x, $y, $size[0], $size[1]) ; second winmove
EndFunc   ;==>_Fenster_Resizen_und_zentrieren


Func _Control_set_DPI_Scaling($handle = "", $no_resize = False)
	If $handle = "" Then Return

	;Check Gui Size Restoring
	If IsHWnd($handle) Then
		_ISN_Gui_Size_Saving_Check_GUI_Register($handle)
	EndIf


	If $DPI == 1 Then Return ;Bei 100% gibt´s nichts zu tun
	If IsHWnd($handle) Then

		$fenster_positionen = WinGetPos($handle)
		$fenster_ClientSize = WinGetClientSize($handle)

		If IsArray($fenster_positionen) And IsArray($fenster_ClientSize) Then

			$Client_size_dif_Width = $fenster_positionen[2] - $fenster_ClientSize[0]
			$Client_size_dif_height = $fenster_positionen[3] - $fenster_ClientSize[1]

			_Fenster_Resizen_und_zentrieren($handle, "", ($fenster_ClientSize[0] * $DPI) + $Client_size_dif_Width, ($fenster_ClientSize[1] * $DPI) + $Client_size_dif_height)

		EndIf
	Else
		$handle = GUICtrlGetHandle($handle)
		$control_positionen = ControlGetPos($handle, "", $handle)
		If IsArray($control_positionen) Then
			If $no_resize Then
				GUICtrlSetPos(_WinAPI_GetDlgCtrlID($handle), $control_positionen[0] * $DPI, $control_positionen[1] * $DPI)
			Else
				GUICtrlSetPos(_WinAPI_GetDlgCtrlID($handle), $control_positionen[0] * $DPI, $control_positionen[1] * $DPI, $control_positionen[2] * $DPI, $control_positionen[3] * $DPI)
			EndIf

		EndIf

	EndIf
EndFunc   ;==>_Control_set_DPI_Scaling

Func _ISN_Gui_Size_Saving_Check_GUI_Register($hgui = "")
	If $hgui = "" Then Return -1
	Switch $hgui

		Case Eval("fFind1")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "searchandreplace")

		Case Eval("Config_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "isnsettings")

		Case Eval("Studiofenster")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "mainwindow")

		Case Eval("console_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "debugconsole")

		Case Eval("Projekteinstellungen_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "projectsettings")

		Case Eval("Welcome_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "welcomepage")

		Case Eval("aenderungs_manager_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "changelogmanager")

		Case Eval("changelog_generieren_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "changelogmanagergenerate")

		Case Eval("neuer_changelog_eintrag_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "changelogmanagernewentry")

		Case Eval("aenderungsbericht_hilfeGUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "changelogmanagerhelp")

		Case Eval("bitwise_operations_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "bitwiseoperations")

		Case Eval("bugtracker")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "bugtracker")

		Case Eval("Codeausschnitt_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "codesnippet")

		Case Eval("Datei_loeschen_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "deletefile")

		Case Eval("Choose_File_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "choosefile")

		Case Eval("Druckvorschau_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "printpreview")

		Case Eval("Druckvorschau_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "printpreview")

		Case Eval("colour_picker")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "colortoolbox")

		Case Eval("Funclist_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "funclist")

		Case Eval("in_ordner_nach_text_suchen_gui")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "searchinfolders")

		Case Eval("ruleseditor")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macros")

		Case Eval("msgboxcreator")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "msgboxcreator")

		Case Eval("New_file_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "newfile")

		Case Eval("newrule_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "newmacro")

		Case Eval("NEW_PROJECT_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "newproject")

		Case Eval("ParameterEditor_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "parametereditor")

		Case Eval("pelock_obfuscator_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "pelockobfuscator")

		Case Eval("projectmanager")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "projectmanager")

		Case Eval("parameter_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "startparameter")

		Case Eval("ToDoList_Delete_Category")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "tododeletecategory")

		Case Eval("ToDoList_Category_Manager")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "todomanagecategories")

		Case Eval("ToDoList_Manager")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "todomanager")

		Case Eval("ToDoList_New_Category")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "todonewcategory")

		Case Eval("ToDo_Liste_neuer_eintrag_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "todonewentry")

		Case Eval("trophys")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "trophies")

		Case Eval("ISN_Ueber_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "about")

		Case Eval("Update_gefunden_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "updatefound")

		Case Eval("Weitere_Dateien_Kompilieren_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "additionalfilestocompile")

		Case Eval("JumpToLine_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "gotoline")

		Case Eval("choose_action_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrochooseaction")

		Case Eval("Makro_auswaehlen_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "selectmacro")

		Case Eval("Makro_Codeausschnitt_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrocodesnippet")

		Case Eval("runfile_config")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrorunfile")

		Case Eval("rule_fileoperation_configgui")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrofileoperation")

		Case Eval("ExecuteCommandRuleConfig_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macroexecute")

		Case Eval("rulecompileconfig_gui")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrocompilefile")

		Case Eval("addlog_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macroaddlog")

		Case Eval("choose_ruleslot_icon")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrosloticon")

		Case Eval("msgboxcreator_rule")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macromsgboxcreator")

		Case Eval("parameter_GUI_rule")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macroparameter")

		Case Eval("macro_runscriptGUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrorunscript")

		Case Eval("Slepprule_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrosleep")

		Case Eval("stausbar_Set_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrostatusbar")

		Case Eval("choose_trigger")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrotrigger")

		Case Eval("macro_changeVersionGUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macrochangeversion")

		Case Eval("choose_fileoperations_extendenpaths_GUI")
			Return _ISN_Enable_Gui_Size_Saving($hgui, "macroadditionalpaths")

	EndSwitch
	Return -1
EndFunc   ;==>_ISN_Gui_Size_Saving_Check_GUI_Register


Func _Fenster_Hintergrundgrafiken_einfuegen_UpdateGUI($handle = "")
	If $handle = "" Then Return
	$fenster_positionen = WinGetClientSize($handle)
	If IsArray($fenster_positionen) Then
		GUICtrlCreatePic(@ScriptDir & "\Data\Images\update.jpg", 0, 0, $fenster_positionen[0], $fenster_positionen[1], -1, $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Fenster_Hintergrundgrafiken_einfuegen_UpdateGUI


Func _ISN_Enable_Gui_Size_Saving($hgui = "", $inikey = "")
	If $inikey = "" Or $hgui = "" Then Return -1
	$index = _ArrayAdd($Gui_Size_Saving_Array, $hgui & "|" & $inikey)
	If @error Then Return -1
	Return $index
EndFunc   ;==>_ISN_Enable_Gui_Size_Saving

Func _ISN_Gui_Size_Saving_Restore_Settings_by_Keyname($name = "")
	If $name = "" Then Return -1
	$found_index = _ArraySearch($Gui_Size_Saving_Array, $name, 0, 0, 0, 0, 1, 1)
	If @error Then Return -1
	Return _ISN_Gui_Size_Saving_Restore_Settings_by_Array_Index($found_index)
EndFunc   ;==>_ISN_Gui_Size_Saving_Restore_Settings_by_Keyname

Func _ISN_Gui_Size_Saving_Restore_All_GUI_Settings()
	If Not IsArray($Gui_Size_Saving_Array) Then Return -1
	For $cnt = 0 To UBound($Gui_Size_Saving_Array) - 1

		;Exclude the following Guis from autoamtic restoring at startup (this will be done manually in the code)
		Switch $Gui_Size_Saving_Array[$cnt][1]

			Case "debugconsole"
				ContinueLoop

			Case "mainwindow"
				ContinueLoop


		EndSwitch

		_ISN_Gui_Size_Saving_Restore_Settings_by_Array_Index($cnt)
	Next
	Return 1
EndFunc   ;==>_ISN_Gui_Size_Saving_Restore_All_GUI_Settings

Func _ISN_Gui_Size_Saving_Get_Gui_Monitor_by_Keyname($inikey = "")
	If $inikey = "" Then Return _get_primary_monitor()
	If Not IsArray($Gui_Size_Saving_Array) Then Return _get_primary_monitor()
	$iniString = IniRead($Configfile, "positions", $inikey, "")
	If $iniString = "" Then Return _get_primary_monitor() ;nothing to do..
	$iniString_Splitt = StringSplit($iniString, "|", 2)
	If Not IsArray($iniString_Splitt) Then Return _get_primary_monitor()
	For $cnt = 0 To UBound($iniString_Splitt) - 1
		;Cnt: 0 = x | 1 = y | 2 = width | 3 = height | 4 = maximized
		Switch $cnt
			Case 0
				$x = Number($iniString_Splitt[$cnt])

			Case 1
				$y = Number($iniString_Splitt[$cnt])

			Case 2
				$width = Number($iniString_Splitt[$cnt])

			Case 3
				$height = Number($iniString_Splitt[$cnt])

			Case 4
				$WinIsMaximized = $iniString_Splitt[$cnt]

		EndSwitch
	Next
	If $x = Default Or $y = Default Or $width = Default Or $height = Default Then Return _get_primary_monitor() ;Something goes terrible wrong..

	$Window_is_on_monitor = _GetMonitorFromPoint($x + ($width / 2), $y + ($height / 2))
	If $Window_is_on_monitor = 0 Then $Window_is_on_monitor = _get_primary_monitor()
	Return $Window_is_on_monitor
EndFunc   ;==>_ISN_Gui_Size_Saving_Get_Gui_Monitor_by_Keyname






Func _ISN_Gui_Size_Saving_Save_Settings()
	If $Allow_Gui_Size_Saving <> 1 Then Return
	If Not IsArray($Gui_Size_Saving_Array) Then Return -1
	If $ISN_Save_Positions_mode = "0" Then Return -1
	Local $WinIsMaximized = 0, $inistr = "", $x, $y, $width, $height

	;Loop through GUIs
	For $cnt = 0 To UBound($Gui_Size_Saving_Array) - 1

		;Excusions for mode 1
		If $ISN_Save_Positions_mode = "1" Then
			If $Gui_Size_Saving_Array[$cnt][1] <> "debugconsole" And $Gui_Size_Saving_Array[$cnt][1] <> "mainwindow" Then ContinueLoop
		EndIf


		$gui = HWnd($Gui_Size_Saving_Array[$cnt][0])
		If BitAND(WinGetState($gui), $WIN_STATE_MINIMIZED) Then ContinueLoop ;Do not save sate of minimized GUIs
		If Not WinExists($gui) Then ContinueLoop
		Local $tWindowPlacement = _WinAPI_GetWindowPlacement($gui)
		If @error Then ContinueLoop


		If BitAND(WinGetState($gui), $WIN_STATE_MAXIMIZED) Then
			$WinIsMaximized = 1
		Else
			$WinIsMaximized = 0
		EndIf


		$tRET = _WinAPI_GetWindowPlacement($gui)
		$tRET_left = DllStructGetData($tRET, "rcNormalPosition", 1)
		$tRET_top = DllStructGetData($tRET, "rcNormalPosition", 2)
		$tRET_right = DllStructGetData($tRET, "rcNormalPosition", 3)
		$tRET_bottom = DllStructGetData($tRET, "rcNormalPosition", 4)

		;Calculate positions for 100% dpi Scaling
		$x = Round($tRET_left / $DPI, 0)
		$y = Round($tRET_top / $DPI, 0)
		$width = Round(($tRET_right - $tRET_left - $Clientsize_diff_width) / Number($DPI), 0)
		$height = Round(($tRET_bottom - $tRET_top - $Clientsize_diff_height) / Number($DPI), 0)

		$inistr = $x & "|" & $y & "|" & $width & "|" & $height & "|" & $WinIsMaximized
		IniWrite($Configfile, "positions", $Gui_Size_Saving_Array[$cnt][1], $inistr)

	Next
	Return 1
EndFunc   ;==>_ISN_Gui_Size_Saving_Save_Settings




Func _ISN_Gui_Size_Saving_Restore_Settings_by_Array_Index($index = -1)
	If $index = -1 Then Return -1
	If Not IsArray($Gui_Size_Saving_Array) Then Return -1
	If $ISN_Save_Positions_mode = "0" Then Return -1
	Local $x = Default, $y = Default, $width = Default, $height = Default, $WinIsMaximized = 0


	;Only restore mainwindow and console in mode 1
	If $ISN_Save_Positions_mode = "1" Then
		If $Gui_Size_Saving_Array[$index][1] <> "debugconsole" And $Gui_Size_Saving_Array[$index][1] <> "mainwindow" Then Return -1
	EndIf


	$hgui = HWnd($Gui_Size_Saving_Array[$index][0])
	$iniString = IniRead($Configfile, "positions", $Gui_Size_Saving_Array[$index][1], "")
;~    if $iniString = "" AND $Gui_Size_Saving_Array[$index][1] = "mainwindow" then WinSetState ( $hGUI, "", @SW_MAXIMIZE)
	If $iniString = "" Then Return 1 ;nothing to do..
	$iniString_Splitt = StringSplit($iniString, "|", 2)
	If Not IsArray($iniString_Splitt) Then Return -1
	For $cnt = 0 To UBound($iniString_Splitt) - 1
		;Cnt: 0 = x | 1 = y | 2 = width | 3 = height | 4 = maximized
		Switch $cnt
			Case 0
				$x = Number($iniString_Splitt[$cnt]) * $DPI

			Case 1
				$y = Number($iniString_Splitt[$cnt]) * $DPI

			Case 2
				$width = Number($iniString_Splitt[$cnt]) * $DPI

			Case 3
				$height = Number($iniString_Splitt[$cnt]) * $DPI

			Case 4
				$WinIsMaximized = $iniString_Splitt[$cnt]

		EndSwitch
	Next
	If $x = Default Or $y = Default Or $width = Default Or $height = Default Then Return -1 ;Something goes terrible wrong..
	If $height < 10 Or $width < 10 Then Return -1



	;Backup original size for maximizing in hidden state
	$Window_is_on_monitor = _GetMonitorFromPoint($x + ($width / 2), $y + ($height / 2))
	If $Window_is_on_monitor = 0 Then $Window_is_on_monitor = _get_primary_monitor()
	$Monitor_Res = _Monitor_Get_Resolution($Window_is_on_monitor)
	If Not IsArray($Monitor_Res) Then Return -1
	_CenterOnMonitor($hgui, "", $Window_is_on_monitor)
	If Not BitAND(WinGetState($hgui, ""), 2) Then GUISetState(@SW_HIDE, $hgui) ;Bugfix for scaling ?!?

	_WinAPI_SetWindowPos($hgui, 0, $x, $y, $width + $Clientsize_diff_width, $height + $Clientsize_diff_height, $SWP_NOZORDER + $SWP_NOOWNERZORDER + $SWP_NOACTIVATE)

	$tRET = _WinAPI_GetWindowPlacement($hgui)
	$backup_left = DllStructGetData($tRET, "rcNormalPosition", 1)
	$backup_top = DllStructGetData($tRET, "rcNormalPosition", 2)
	$backup_right = DllStructGetData($tRET, "rcNormalPosition", 3)
	$backup_bottom = DllStructGetData($tRET, "rcNormalPosition", 4)


	If String($WinIsMaximized) = "1" Then
		;Maximize the gui..but do NOT show it and resetore the normal gui size
		$old_gui_Sytel_Array = GUIGetStyle($hgui)
		If Not IsArray($old_gui_Sytel_Array) Then Return -1
		GUISetStyle(BitOR($old_gui_Sytel_Array[0], $WS_MAXIMIZE), -1, $hgui) ;Let windows think the gui is already maximized
		_WinAPI_SetWindowPos($hgui, 0, $Monitor_Res[0], $Monitor_Res[1], $Monitor_Res[2], $Monitor_Res[3], $SWP_NOZORDER + $SWP_NOOWNERZORDER + $SWP_NOACTIVATE) ;Resize to the max monitor size


		$tRET = _WinAPI_GetWindowPlacement($hgui)
		DllStructSetData($tRET, "showCmd", 0, 1) ;Do not show the gui
		DllStructSetData($tRET, "rcNormalPosition", $backup_left, 1) ; left
		DllStructSetData($tRET, "rcNormalPosition", $backup_top, 2) ; top
		DllStructSetData($tRET, "rcNormalPosition", $backup_right, 3) ; right
		DllStructSetData($tRET, "rcNormalPosition", $backup_bottom, 4) ; bottom
		$iRET = _WinAPI_SetWindowPlacement($hgui, $tRET)

	EndIf
;~ GUISetState(@SW_SHOW,$hGUI)
	Return 1
EndFunc   ;==>_ISN_Gui_Size_Saving_Restore_Settings_by_Array_Index

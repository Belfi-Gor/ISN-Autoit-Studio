;Macroeditor for ISN


Func _Build_Rulelist()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($listview_projectrules))
	_GUICtrlListView_BeginUpdate($listview_projectrules)
	If Not FileExists($Pfad_zur_Project_ISN) Then Return
	$var = IniReadSectionNames($Pfad_zur_Project_ISN)
	$count = 0
	If @error Then
		MsgBox(4096, "", "Error reading .isn file!")
	Else
		For $i = 1 To $var[0]
			If StringInStr($var[$i], "#isnrule#") Then
				$count = $count + 1
				_GUICtrlListView_AddItem($listview_projectrules, IniRead($Pfad_zur_Project_ISN, $var[$i], "name", "#ERROR#"), 52)
				If IniRead($Pfad_zur_Project_ISN, $var[$i], "status", "active") = "active" Then
					_GUICtrlListView_AddSubItem($listview_projectrules, _GUICtrlListView_GetItemCount($listview_projectrules) - 1, _Get_langstr(136), 1)
				Else
					_GUICtrlListView_AddSubItem($listview_projectrules, _GUICtrlListView_GetItemCount($listview_projectrules) - 1, _Get_langstr(137), 1)
				EndIf
				_GUICtrlListView_AddSubItem($listview_projectrules, _GUICtrlListView_GetItemCount($listview_projectrules) - 1, $var[$i], 2)

			EndIf
		Next
	EndIf
	$direction = False
	_GUICtrlListView_SimpleSort($listview_projectrules, $direction, 0)
	_GUICtrlListView_SetSelectionMark($listview_projectrules, -1)
	_GUICtrlListView_SetItemSelected($listview_projectrules, -1, False, False)
	_GUICtrlListView_EndUpdate($listview_projectrules)

	_GUICtrlListView_CopyAllItems(GUICtrlGetHandle($listview_projectrules), GUICtrlGetHandle($makro_auswaehlen_listview)) ;Kopiere Makro-Liste in die Makro Auswählen GUI
EndFunc   ;==>_Build_Rulelist

Func _Show_Ruleeditor()
	_Build_Rulelist()
	GUISetState(@SW_SHOW, $ruleseditor)
	GUISetState(@SW_DISABLE, $StudioFenster)

EndFunc   ;==>_Show_Ruleeditor

Func _Hide_Ruleeditor()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $ruleseditor)
	_Check_Buttons(0)
	_rezize()
	_Reload_Ruleslots()
EndFunc   ;==>_Hide_Ruleeditor


Func _Show_new_rule_form($nrr = 0)
;~ if not IsDeclared("nr") then $nr = 0
	If $nrr == 0 Then
		GUICtrlSetData($new_rule_title, _Get_langstr(520))
		WinSetTitle($newrule_GUI, "", _Get_langstr(520))
		$nrr = "#isnrule#" & @YEAR & @MON & @MDAY & @MIN & @SEC & Random(0, 200, 1)
		GUICtrlSetData($rule_ID, $nrr)
	Else
		GUICtrlSetData($new_rule_title, _Get_langstr(523))
		WinSetTitle($newrule_GUI, "", _Get_langstr(523))
		GUICtrlSetData($rule_ID, $nrr)
	EndIf
	GUICtrlSetData($rule_name_input, IniRead($Pfad_zur_Project_ISN, $nrr, "name", ""))
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($new_rule_triggerlist))
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($new_rule_actionlist))

	;load triggerlist if possible
	$triggers = IniRead($Pfad_zur_Project_ISN, $nrr, "triggers", "")
	$triggers_array = StringSplit($triggers, "|", 2)
	For $u = 0 To UBound($triggers_array) - 1
		If $triggers_array[$u] <> "" Then
			_GUICtrlListView_AddItem($new_rule_triggerlist, _get_triggername_by_section($triggers_array[$u]), 53)
			_GUICtrlListView_AddSubItem($new_rule_triggerlist, _GUICtrlListView_GetItemCount($new_rule_triggerlist) - 1, $triggers_array[$u], 1)
		EndIf
	Next

	_Reload_Actionlist()
	GUISetState(@SW_SHOW, $newrule_GUI)
	GUISetState(@SW_HIDE, $ruleseditor)

EndFunc   ;==>_Show_new_rule_form

Func _Neues_Makro_Abbrechen()
	IniReadSection($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID))
	If @error = 1 Then
		$to_delete = GUICtrlRead($rule_ID)
		IniDelete($Pfad_zur_Project_ISN, $to_delete)
		;Delete every possible trigger
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger1, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger2, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger3, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger4, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger5, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger6, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger7, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger8, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger9, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger10, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger11, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger12, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger13, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger14, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger15, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger16, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger17, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger18, $to_delete)
		_Show_Ruleeditor()
		GUISetState(@SW_HIDE, $newrule_GUI)
	Else
		_Speichere_Neue_Regel()
	EndIf
EndFunc   ;==>_Neues_Makro_Abbrechen




Func _Add_Trigger_to_list()


	;Nur eine Regel Pro Regelslot
	$x = $Trigger_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($Trigger_Combolist)]
	If $x = $Section_Trigger12 Or $x = $Section_Trigger13 Or $x = $Section_Trigger14 Or $x = $Section_Trigger15 Or $x = $Section_Trigger16 Or $x = $Section_Trigger17 Or $x = $Section_Trigger18 Then
		$sections = IniReadSection($Pfad_zur_Project_ISN, $x)
		If Not @error Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(616), 0, $choose_trigger)
			Return
		EndIf
	EndIf


	;falls schon in der liste -> irgnore
	$iI = _GUICtrlListView_FindText($new_rule_triggerlist, GUICtrlRead($Trigger_Combolist))
	If $iI = -1 Then
		_GUICtrlListView_AddItem($new_rule_triggerlist, GUICtrlRead($Trigger_Combolist), 53)
		_GUICtrlListView_AddSubItem($new_rule_triggerlist, _GUICtrlListView_GetItemCount($new_rule_triggerlist) - 1, $Trigger_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($Trigger_Combolist)], 1)
		IniWrite($Pfad_zur_Project_ISN, $Trigger_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($Trigger_Combolist)], GUICtrlRead($rule_ID), "")
	EndIf
	_close_Add_Trigger()
	If $iI = -1 Then
		If GUICtrlRead($Trigger_Combolist) = _Get_langstr(611) Then _Show_Set_Ruleslot_icon(1)
		If GUICtrlRead($Trigger_Combolist) = _Get_langstr(612) Then _Show_Set_Ruleslot_icon(2)
		If GUICtrlRead($Trigger_Combolist) = _Get_langstr(613) Then _Show_Set_Ruleslot_icon(3)
		If GUICtrlRead($Trigger_Combolist) = _Get_langstr(614) Then _Show_Set_Ruleslot_icon(4)
		If GUICtrlRead($Trigger_Combolist) = _Get_langstr(615) Then _Show_Set_Ruleslot_icon(5)
		If GUICtrlRead($Trigger_Combolist) = _Get_langstr(906) Then _Show_Set_Ruleslot_icon(6)
		If GUICtrlRead($Trigger_Combolist) = _Get_langstr(907) Then _Show_Set_Ruleslot_icon(7)
	EndIf

EndFunc   ;==>_Add_Trigger_to_list

Func _close_Add_Trigger()
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $choose_trigger)
EndFunc   ;==>_close_Add_Trigger

Func _delete_trigger_from_list()
	If _GUICtrlListView_GetSelectionMark($new_rule_triggerlist) = -1 Then Return
	If _GUICtrlListView_GetItemCount($new_rule_triggerlist) = 0 Then Return
	IniDelete($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($new_rule_triggerlist, _GUICtrlListView_GetSelectionMark($new_rule_triggerlist), 1), GUICtrlRead($rule_ID))
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($new_rule_triggerlist), _GUICtrlListView_GetSelectionMark($new_rule_triggerlist))
EndFunc   ;==>_delete_trigger_from_list

Func _Speichere_Neue_Regel()
	If GUICtrlRead($rule_name_input) = "" Then
		_Input_Error_FX($rule_name_input)
		Return
	EndIf
	If IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "status", "") = "" Then IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "status", "active")
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "name", GUICtrlRead($rule_name_input))
	$triggerstring = ""
	For $i = 0 To _GUICtrlListView_GetItemCount($new_rule_triggerlist) - 1
		$triggerstring = $triggerstring & _GUICtrlListView_GetItemText($new_rule_triggerlist, $i, 1) & "|"
	Next
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "triggers", $triggerstring)
	_Show_Ruleeditor()
	GUISetState(@SW_HIDE, $newrule_GUI)
	_Earn_trophy(13, 1)
EndFunc   ;==>_Speichere_Neue_Regel

Func _Editiere_Regel()
	If _GUICtrlListView_GetSelectionMark($listview_projectrules) = -1 Then Return
	If _GUICtrlListView_GetItemCount($listview_projectrules) = 0 Then Return
	_Show_new_rule_form(_GUICtrlListView_GetItemText($listview_projectrules, _GUICtrlListView_GetSelectionMark($listview_projectrules), 2))
EndFunc   ;==>_Editiere_Regel

Func _Show_new_rule_event()
	_Show_new_rule_form(0)
EndFunc   ;==>_Show_new_rule_event




Func _Rule_toggle_active()
	If _GUICtrlListView_GetSelectionMark($listview_projectrules) = -1 Then Return
	If _GUICtrlListView_GetItemCount($listview_projectrules) = 0 Then Return
	$old_sec = _GUICtrlListView_GetSelectionMark($listview_projectrules)
	If IniRead($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($listview_projectrules, _GUICtrlListView_GetSelectionMark($listview_projectrules), 2), "status", "active") = "active" Then
		IniWrite($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($listview_projectrules, _GUICtrlListView_GetSelectionMark($listview_projectrules), 2), "status", "inactive")
	Else
		IniWrite($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($listview_projectrules, _GUICtrlListView_GetSelectionMark($listview_projectrules), 2), "status", "active")
	EndIf
	_Build_Rulelist()
	_GUICtrlListView_SetItemSelected($listview_projectrules, $old_sec, True, True)
	_load_ruledetails()
EndFunc   ;==>_Rule_toggle_active

Func _load_ruledetails()
	If _GUICtrlListView_GetSelectionMark($listview_projectrules) = -1 Then
		GUICtrlSetData($btn_toggle_rulestatus, _Get_langstr(514))
		Return
	EndIf
	If _GUICtrlListView_GetItemCount($listview_projectrules) = 0 Then Return
	If _GUICtrlListView_GetItemText($listview_projectrules, _GUICtrlListView_GetSelectionMark($listview_projectrules), 1) = _Get_langstr(136) Then
		GUICtrlSetData($btn_toggle_rulestatus, _Get_langstr(514))
		Button_AddIcon($btn_toggle_rulestatus, $smallIconsdll, 1173, 0)
	Else
		GUICtrlSetData($btn_toggle_rulestatus, _Get_langstr(515))
		Button_AddIcon($btn_toggle_rulestatus, $smallIconsdll, 314, 0)
	EndIf
EndFunc   ;==>_load_ruledetails









Func _close_Add_action()
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $choose_action_GUI)
EndFunc   ;==>_close_Add_action


Func _Add_action_to_list_event()
	_Add_action_to_list("")
EndFunc   ;==>_Add_action_to_list_event

Func _Add_action_to_list($Action_ID = "")
	$new_taskid = @MDAY & @MIN & @SEC & Random(0, 300, 1)
	If $Action_ID = "" Then
		_Config_Ruleaction($Action_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($action_Combolist)], $new_taskid)
	Else
		_Config_Ruleaction($Action_ID, $new_taskid)
	EndIf
EndFunc   ;==>_Add_action_to_list

Func _Reload_Actionlist()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($new_rule_actionlist))
	_GUICtrlListView_BeginUpdate($new_rule_actionlist)

	;load actionlist
	$actions_string = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	$actions_array = StringSplit($actions_string, "|", 2)
	For $u = 0 To UBound($actions_array) - 1
		If $actions_array[$u] <> "" Then
			_GUICtrlListView_AddItem($new_rule_actionlist, _get_actionname_by_section($actions_array[$u]), 54)
			_GUICtrlListView_AddSubItem($new_rule_actionlist, _GUICtrlListView_GetItemCount($new_rule_actionlist) - 1, _get_details_by_section($actions_array[$u]), 1)
			_GUICtrlListView_AddSubItem($new_rule_actionlist, _GUICtrlListView_GetItemCount($new_rule_actionlist) - 1, $actions_array[$u], 2)
		EndIf
	Next

	_GUICtrlListView_EndUpdate($new_rule_actionlist)

EndFunc   ;==>_Reload_Actionlist


Func _Move_actionitem_up()
	If _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 Then Return
	If _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 Then Return
	_GUICtrlListView_MoveItems($new_rule_actionlist, -1)
	_GUICtrlListView_EnsureVisible($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist))
	_GUICtrlListView_SetItemSelected($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist), True, True)
	$actionstring = ""
	For $i = 0 To _GUICtrlListView_GetItemCount($new_rule_actionlist) - 1
		$actionstring = $actionstring & _GUICtrlListView_GetItemText($new_rule_actionlist, $i, 2) & "|"
	Next
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $actionstring)
EndFunc   ;==>_Move_actionitem_up

Func _Move_actionitem_down()
	If _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 Then Return
	If _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 Then Return
	_GUICtrlListView_MoveItems($new_rule_actionlist, 1)
	_GUICtrlListView_EnsureVisible($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist))
	_GUICtrlListView_SetItemSelected($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist), True, True)
	$actionstring = ""
	For $i = 0 To _GUICtrlListView_GetItemCount($new_rule_actionlist) - 1
		$actionstring = $actionstring & _GUICtrlListView_GetItemText($new_rule_actionlist, $i, 2) & "|"
	Next
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $actionstring)
EndFunc   ;==>_Move_actionitem_down

Func _edit_action()
	If _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 Then Return
	If _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 Then Return
	$section = _GUICtrlListView_GetItemText($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist), 2)
	$action = StringTrimRight($section, StringLen($section) - StringInStr($section, "[") + 1)
	$Action_ID = _StringBetween($section, '[', ']')
	_Config_Ruleaction($action, $Action_ID[0])
EndFunc   ;==>_edit_action

Func _remove_action()
	If _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 Then Return
	If _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 Then Return
	$section = _GUICtrlListView_GetItemText($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist), 2)
	$action = StringTrimRight($section, StringLen($section) - StringInStr($section, "[") + 1)
	$Action_ID = _StringBetween($section, '[', ']')
	Switch $action
		Case $Key_Action1
			IniDelete($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "statusbar_string[" & $Action_ID[0] & "]")
		Case $Key_Action2
			IniDelete($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "sleep_time[" & $Action_ID[0] & "]")
		Case $Key_Action4
			IniDelete($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_mode[" & $Action_ID[0] & "]")
			IniDelete($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_source[" & $Action_ID[0] & "]")
			IniDelete($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_target[" & $Action_ID[0] & "]")
			IniDelete($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_mustconfirm[" & $Action_ID[0] & "]")



	EndSwitch
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($new_rule_actionlist), _GUICtrlListView_GetSelectionMark($new_rule_actionlist))
	$actionstring = ""
	For $i = 0 To _GUICtrlListView_GetItemCount($new_rule_actionlist) - 1
		$actionstring = $actionstring & _GUICtrlListView_GetItemText($new_rule_actionlist, $i, 2) & "|"
	Next
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $actionstring)
	_Reload_Actionlist()
EndFunc   ;==>_remove_action

Func _Export_Rules()
	$line = FileSaveDialog(_Get_langstr(589), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Macros (*.ini)", 18, "Macro.ini", $ruleseditor)
	If $line = "" Then Return
	If @error > 0 Then Return
	$source = $Pfad_zur_Project_ISN
	$des = $line
	$var = IniReadSectionNames($source)
	If @error Then
		MsgBox(4096, "", "Error while reading project file (*.isn)")
		Return
	Else
		For $i = 1 To $var[0]
			If StringInStr($var[$i], "#ruletrigger") Or StringInStr($var[$i], "#isnrule#") Then
				$data = IniReadSection($source, $var[$i])
				IniWriteSection($des, $var[$i], $data)
			EndIf
		Next
	EndIf
	FileChangeDir(@ScriptDir)
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $ruleseditor)
EndFunc   ;==>_Export_Rules

Func _import_Rules()
   if $Skin_is_used = "true" Then
	  $var = _WinAPI_OpenFileDlg (_Get_langstr(590), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}","ISN AutoIt Studio Macro (*.ini)", 0 ,'' , '' , BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY),  $OFN_EX_NOPLACESBAR , 0 , 0, $ruleseditor)
   else
	  $var = FileOpenDialog(_Get_langstr(590), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Macro (*.ini)", 1 + 2 , "", $ruleseditor)
   Endif

	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return

	$source = $var
	$des = $Pfad_zur_Project_ISN
	$var = IniReadSectionNames($source)
	If @error Then
		MsgBox(4096, "", "Error while reading .ini")
		Return
	Else
		For $i = 1 To $var[0]
			If StringInStr($var[$i], "#ruletrigger") Or StringInStr($var[$i], "#isnrule#") Then
				$data = IniReadSection($source, $var[$i])
				IniWriteSection($des, $var[$i], $data)
			EndIf
		Next
	EndIf
	FileChangeDir(@ScriptDir)
	_Build_Rulelist()
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(591), 0, $ruleseditor)
EndFunc   ;==>_import_Rules
;===============================================================================
; Function Name:    _GUICtrlListView_MoveItems()
; Description:      Moves Up or Down selected item(s) in ListView.
;
; Parameter(s):     $hListView          - ControlID or Handle of ListView control.
;                   $iDirection         - Define in what direction item(s) will move:
;                                           -1 - Move Up.
;                                            1 - Move Down.
;
; Requirement(s):   AutoIt 3.3.0.0
;
; Return Value(s):  On seccess - Move selected item(s) Up/Down and return 1.
;                   On failure - Return "" (empty string) and set @error as following:
;                                                                  1 - No selected item(s).
;                                                                  2 - $iDirection is wrong value (not 1 and not -1).
;                                                                  3 - Item(s) can not be moved, reached last/first item.
;
; Note(s):          * If you select like 15-20 (or more) items, moving them can take a while :( (second or two).
;
; Author(s):        G.Sandler a.k.a CreatoR
;===============================================================================
Func _GUICtrlListView_MoveItems($hListView, $iDirection)
	Local $aSelected_Indices = _GUICtrlListView_GetSelectedIndices($hListView, 1)

	If UBound($aSelected_Indices) < 2 Then Return SetError(1, 0, "")
	If $iDirection <> 1 And $iDirection <> -1 Then Return SetError(2, 0, "")

	Local $iTotal_Items = _GUICtrlListView_GetItemCount($hListView)
	Local $iTotal_Columns = _GUICtrlListView_GetColumnCount($hListView)

	Local $iUbound = UBound($aSelected_Indices) - 1, $iNum = 1, $iStep = 1

	Local $iCurrent_Index, $iUpDown_Index, $sCurrent_ItemText, $sUpDown_ItemText
	Local $iCurrent_Index, $iCurrent_CheckedState, $iUpDown_CheckedState
	Local $iImage_Current_Index, $iImage_UpDown_Index

	If ($iDirection = -1 And $aSelected_Indices[1] = 0) Or _
			($iDirection = 1 And $aSelected_Indices[$iUbound] = $iTotal_Items - 1) Then Return SetError(3, 0, "")

	ControlListView($hListView, "", "", "SelectClear")

	If $iDirection = 1 Then
		$iNum = $iUbound
		$iUbound = 1
		$iStep = -1
	EndIf

	For $i = $iNum To $iUbound Step $iStep
		$iCurrent_Index = $aSelected_Indices[$i]
		$iUpDown_Index = $aSelected_Indices[$i] + 1
		If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i] - 1

		$iCurrent_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iCurrent_Index)
		$iUpDown_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iUpDown_Index)

		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)

		For $j = 0 To $iTotal_Columns - 1
			$sCurrent_ItemText = _GUICtrlListView_GetItemText($hListView, $iCurrent_Index, $j)
			$sUpDown_ItemText = _GUICtrlListView_GetItemText($hListView, $iUpDown_Index, $j)

			If _GUICtrlListView_GetImageList($hListView, 1) <> 0 Then
				$iImage_Current_Index = _GUICtrlListView_GetItemImage($hListView, $iCurrent_Index, $j)
				$iImage_UpDown_Index = _GUICtrlListView_GetItemImage($hListView, $iUpDown_Index, $j)

				_GUICtrlListView_SetItemImage($hListView, $iCurrent_Index, $iImage_UpDown_Index, $j)
				_GUICtrlListView_SetItemImage($hListView, $iUpDown_Index, $iImage_Current_Index, $j)
			EndIf

			_GUICtrlListView_SetItemText($hListView, $iUpDown_Index, $sCurrent_ItemText, $j)
			_GUICtrlListView_SetItemText($hListView, $iCurrent_Index, $sUpDown_ItemText, $j)
		Next

		_GUICtrlListView_SetItemChecked($hListView, $iUpDown_Index, $iCurrent_CheckedState)
		_GUICtrlListView_SetItemChecked($hListView, $iCurrent_Index, $iUpDown_CheckedState)

		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index, 0)
	Next

	For $i = 1 To UBound($aSelected_Indices) - 1
		$iUpDown_Index = $aSelected_Indices[$i] + 1
		If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i] - 1
		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)
	Next

	_GUICtrlListView_SetSelectionMark($hListView, $iUpDown_Index)
	Return 1
EndFunc   ;==>_GUICtrlListView_MoveItems

Func _edit_trigger()
	If _GUICtrlListView_GetSelectionMark($new_rule_triggerlist) = -1 Then Return
	If _GUICtrlListView_GetItemCount($new_rule_triggerlist) = 0 Then Return
	$text = _GUICtrlListView_GetItemText($new_rule_triggerlist, _GUICtrlListView_GetSelectionMark($new_rule_triggerlist), 0)
	Switch $text

		Case _Get_langstr(611)
			_Show_Set_Ruleslot_icon(1)
			Return

		Case _Get_langstr(612)
			_Show_Set_Ruleslot_icon(2)
			Return

		Case _Get_langstr(613)
			_Show_Set_Ruleslot_icon(3)
			Return

		Case _Get_langstr(614)
			_Show_Set_Ruleslot_icon(4)
			Return

		Case _Get_langstr(615)
			_Show_Set_Ruleslot_icon(5)
			Return

		Case _Get_langstr(906)
			_Show_Set_Ruleslot_icon(6)
			Return

		Case _Get_langstr(907)
			_Show_Set_Ruleslot_icon(7)
			Return

	EndSwitch
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(549), 0, $newrule_GUI)
EndFunc   ;==>_edit_trigger


Func _make_icon_default()
	If $ID_Holder_For_ruleiconconfig = 1 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot1", "1")
	If $ID_Holder_For_ruleiconconfig = 2 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot2", "909")
	If $ID_Holder_For_ruleiconconfig = 3 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot3", "1020")
	If $ID_Holder_For_ruleiconconfig = 4 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot4", "1130")
	If $ID_Holder_For_ruleiconconfig = 5 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot5", "1241")
	If $ID_Holder_For_ruleiconconfig = 6 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot6", "1345")
	If $ID_Holder_For_ruleiconconfig = 7 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot7", "1456")
	_Show_Set_Ruleslot_icon($ID_Holder_For_ruleiconconfig)
EndFunc   ;==>_make_icon_default

Func _Show_Set_Ruleslot_icon($slot = 1)
	$ID_Holder_For_ruleiconconfig = $slot
	GUISetState(@SW_DISABLE, $newrule_GUI)
	If $ID_Holder_For_ruleiconconfig = 1 Then $read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot1", "1")
	If $ID_Holder_For_ruleiconconfig = 2 Then $read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot2", "909")
	If $ID_Holder_For_ruleiconconfig = 3 Then $read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot3", "1020")
	If $ID_Holder_For_ruleiconconfig = 4 Then $read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot4", "1130")
	If $ID_Holder_For_ruleiconconfig = 5 Then $read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot5", "1241")
	If $ID_Holder_For_ruleiconconfig = 6 Then $read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot6", "1345")
	If $ID_Holder_For_ruleiconconfig = 7 Then $read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot7", "1456")
	GUICtrlSetImage($ruleslot_ico_preview, $smallIconsdll, $read)

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot" & $ID_Holder_For_ruleiconconfig & "_projecttreecontext", "0") = 0 Then
		GUICtrlSetState($choose_ruleslot_checkboxprojecttree, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($choose_ruleslot_checkboxprojecttree, $GUI_CHECKED)
	EndIf

	GUISetState(@SW_SHOW, $choose_ruleslot_icon)
EndFunc   ;==>_Show_Set_Ruleslot_icon

Func _Hide_Ruleslot_icon()
	If GUICtrlRead($choose_ruleslot_checkboxprojecttree) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot" & $ID_Holder_For_ruleiconconfig & "_projecttreecontext", "1")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot" & $ID_Holder_For_ruleiconconfig & "_projecttreecontext", "0")
	EndIf
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $choose_ruleslot_icon)
EndFunc   ;==>_Hide_Ruleslot_icon

Func _select_icon()
	GUISetState(@SW_DISABLE, $choose_ruleslot_icon)
	$iStartIndex = 1
	If $ID_Holder_For_ruleiconconfig = 1 Then $iStartIndex = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot1", "1")
	If $ID_Holder_For_ruleiconconfig = 2 Then $iStartIndex = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot2", "909")
	If $ID_Holder_For_ruleiconconfig = 3 Then $iStartIndex = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot3", "1020")
	If $ID_Holder_For_ruleiconconfig = 4 Then $iStartIndex = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot4", "1130")
	If $ID_Holder_For_ruleiconconfig = 5 Then $iStartIndex = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot5", "1241")
	If $ID_Holder_For_ruleiconconfig = 6 Then $iStartIndex = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot6", "1345")
	If $ID_Holder_For_ruleiconconfig = 7 Then $iStartIndex = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot7", "1456")
	$Selected_Icon = -1
	Icons_GUIUpdate()
	GUISetState(@SW_SHOW, $gui_select_icon)
EndFunc   ;==>_select_icon

Func _select_icons_next()
	$iStartIndex = $iStartIndex + 30
	Icons_GUIUpdate()
EndFunc   ;==>_select_icons_next

Func _select_icons_prev()
	$iStartIndex = $iStartIndex - 30
	If $iStartIndex < 1 Then $iStartIndex = 1
	Icons_GUIUpdate()
EndFunc   ;==>_select_icons_prev

Func Icons_GUIUpdate()
	For $iCntRow = 0 To 4
		For $iCntCol = 0 To 5
			$iCurIndex = $iCntRow * 6 + $iCntCol
			GUICtrlSetImage($ahIcons[$iCurIndex], $sFilename, $iOrdinal * ($iCurIndex + $iStartIndex))
			If $iOrdinal = -1 Then
				GUICtrlSetData($ahLabels[$iCurIndex], -($iCurIndex + $iStartIndex))
			Else
				GUICtrlSetData($ahLabels[$iCurIndex], '"' & ($iCurIndex + $iStartIndex) & '"')
			EndIf
		Next
	Next
	; This is because we don't want negative values
	If $iStartIndex = 1 Then
		GUICtrlSetState($hPrev, $GUI_DISABLE)
	Else
		GUICtrlSetState($hPrev, $GUI_ENABLE)
	EndIf
EndFunc   ;==>Icons_GUIUpdate

Func _Makroslot_Icon_Abbrechen()
	GUISetState(@SW_ENABLE, $choose_ruleslot_icon)
	GUISetState(@SW_HIDE, $gui_select_icon)
EndFunc   ;==>_Makroslot_Icon_Abbrechen


Func _hit_icon()
	$read = GUICtrlRead(@GUI_CtrlId)
	$read = StringReplace($read, "-", "")
	$read = Number($read)
	GUISetState(@SW_ENABLE, $choose_ruleslot_icon)
	GUISetState(@SW_HIDE, $gui_select_icon)
	If $ID_Holder_For_ruleiconconfig = 1 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot1", $read)
	If $ID_Holder_For_ruleiconconfig = 2 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot2", $read)
	If $ID_Holder_For_ruleiconconfig = 3 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot3", $read)
	If $ID_Holder_For_ruleiconconfig = 4 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot4", $read)
	If $ID_Holder_For_ruleiconconfig = 5 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot5", $read)
	If $ID_Holder_For_ruleiconconfig = 6 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot6", $read)
	If $ID_Holder_For_ruleiconconfig = 7 Then IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot7", $read)
	GUICtrlSetImage($ruleslot_ico_preview, $smallIconsdll, $read)
EndFunc   ;==>_hit_icon

Func _ISN_execute_macroslot_01()
	If $Offenes_Projekt = "" Then Return
	If _run_rule($Section_Trigger12) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
EndFunc   ;==>_ISN_execute_macroslot_01

Func _ISN_execute_macroslot_02()
	If $Offenes_Projekt = "" Then Return
	If _run_rule($Section_Trigger13) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
EndFunc   ;==>_ISN_execute_macroslot_02

Func _ISN_execute_macroslot_03()
	If $Offenes_Projekt = "" Then Return
	If _run_rule($Section_Trigger14) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
EndFunc   ;==>_ISN_execute_macroslot_03

Func _ISN_execute_macroslot_04()
	If $Offenes_Projekt = "" Then Return
	If _run_rule($Section_Trigger15) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
EndFunc   ;==>_ISN_execute_macroslot_04

Func _ISN_execute_macroslot_05()
	If $Offenes_Projekt = "" Then Return
	If _run_rule($Section_Trigger16) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
EndFunc   ;==>_ISN_execute_macroslot_05

Func _ISN_execute_macroslot_06()
	If $Offenes_Projekt = "" Then Return
	If _run_rule($Section_Trigger17) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
EndFunc   ;==>_ISN_execute_macroslot_06

Func _ISN_execute_macroslot_07()
	If $Offenes_Projekt = "" Then Return
	If _run_rule($Section_Trigger18) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
EndFunc   ;==>_ISN_execute_macroslot_07


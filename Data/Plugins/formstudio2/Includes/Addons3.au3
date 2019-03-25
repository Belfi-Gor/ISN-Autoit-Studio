;Addons3
Local $Gui_Setting_Tab_Var[5]
$Gui_Setting_Tab_Var[0] = StringSplit("$Form_bearbeiten_xpos_input,$Form_bearbeiten_ypos_input,$Form_bearbeitenTitel_label,$Form_bearbeitenHandle_label,$Form_bearbeitenparentHandle_label,$Form_bearbeitenparentHandle_parrent_button,$Form_bearbeitenparentHandle_parrent_label,$Form_bearbeitenparentHandle_breite_label1,$Form_bearbeitenparentHandle_breite_label2,$Form_bearbeitenparentHandle_hoehe_label1,$Form_bearbeitenparentHandle_hoehe_label2,$Form_bearbeitenBGColour_button,$Form_bearbeitenBGColour_label,$Form_bearbeitenBGImage_button1,$Form_bearbeitenBGImage_button2,$Form_bearbeitenTitel,$Form_bearbeitenHandle,$Form_bearbeitenparentHandle,$Form_bearbeitenBreite,$Form_bearbeitenHoehe,$Form_bearbeitenBGColour,$Form_bearbeitenBGImage,$Form_bearbeiten_fenstertitel_radio1,$Form_bearbeiten_fenstertitel_radio2,$Form_bearbeiten_fenstertitel_pfeil,$Form_bearbeiten_fenster_zentrieren_checkbox,$Form_bearbeiten_xpos_label,$Form_bearbeiten_ypos_label", ",", 2)
$Gui_Setting_Tab_Var[1] = StringSplit("$Form_bearbeitendeklarationen_labels,$Form_bearbeiten_konstanten_Variablen_checkbox,$Form_bearbeiten_konstanten_MagicNumbers_checkbox,$Form_bearbeiten_konstanten_Programmeinstellungen_checkbox,$Form_bearbeiten_konstanten_label,$Form_Eigenschaften_Include_Once_Checkbox,$Form_Eigenschaften_Nur_Controls_in_die_isf_Checkbox,$Form_Eigenschaften_Deklaration_Handles_Keine_Radio,$Form_Eigenschaften_Deklaration_Handles_Global_Radio,$Form_Eigenschaften_Deklaration_Handles_Local_Radio,$Form_Eigenschaften_Deklaration_als_Const_Deklarieren,$Form_bearbeiten_Deklarationen_pfeil,$Form_bearbeiten_konstanten_Programmeinstellungen_pfeil,$Form_bearbeiten_konstanten_MagicNumbers_pfeil,$Form_bearbeiten_konstanten_Variablen_pfeil,$Form_Eigenschaften_Deklaration_Default_Radio,$Form_settings_code_in_func_checkbox,$Form_settings_code_in_func_label,$Form_settings_code_in_func_icon,$Form_settings_code_in_func_name_input", ",", 2)
$Gui_Setting_Tab_Var[2] = StringSplit("$Form_bearbeiten_event_mousemove_button,$Form_bearbeiten_event_close_input,$Form_bearbeiten_event_minimize_input,$Form_bearbeiten_event_restore_input,$Form_bearbeiten_event_maximize_input,$Form_bearbeiten_event_mousemove_input,$Form_bearbeiten_event_primarydown_input,$Form_bearbeiten_event_primaryup_input,$Form_bearbeiten_event_secoundarydown_input,$Form_bearbeiten_event_secoundaryup_input,$Form_bearbeiten_event_resized_input,$Form_bearbeiten_event_dropped_input,$Form_bearbeiten_event_primarydown_button,$Form_bearbeiten_event_close_button,$Form_bearbeiten_event_minimize_button,$Form_bearbeiten_event_restore_button,$Form_bearbeiten_event_maximize_button,$Form_bearbeiten_event_dropped_button,$Form_bearbeiten_event_primaryup_button,$Form_bearbeiten_event_secoundarydown_button,$Form_bearbeiten_event_secoundaryup_button,$Form_bearbeiten_event_resized_button,$Form_bearbeiten_event_close_label,$Form_bearbeiten_event_minimize_label,$Form_bearbeiten_event_restore_label,$Form_bearbeiten_event_maximize_label,$Form_bearbeiten_event_primarydown_label,$Form_bearbeiten_event_primaryup_label,$Form_bearbeiten_event_secoundarydown_label,$Form_bearbeiten_event_secoundaryup_label,$Form_bearbeiten_event_resized_label,$Form_bearbeiten_event_dropped_label,$Form_bearbeiten_event_mousemove_label", ",", 2)
$Gui_Setting_Tab_Var[3] = StringSplit("$Form_bearbeitenStyle,$gui_setup_style_listview", ",", 2)
$Gui_Setting_Tab_Var[4] = StringSplit("$Form_bearbeitenExstyle,$gui_setup_exstyle_listview", ",", 2)

Local $Control_Editor_Setting_Var[5], $Control_Editor_Setting_LastTab = 0
$Control_Editor_Setting_Var[0] = StringSplit("$MiniEditor_textmode_label,$MiniEditor_Text,$MiniEditor_Text_erweitert,$MiniEditor_Text_Radio1,$MiniEditor_text_Radio1_label,$MiniEditor_Text_Radio2,$MiniEditor_Text_Radio2_label,$MiniEditor_Tooltip,$MiniEditor_ClickFunc,$MiniEditor_Tabpagecombo,$MiniEditor_ChooseFunc,$MiniEditor_text_label,$MiniEditor_tooltip_label,$MiniEditor_func_label,$MiniEditor_tabpage_label,$MiniEditor_Resize_label,$MiniEditor_Resize_input,$MiniEditor_Resize_punktebutton", ",", 2)
$Control_Editor_Setting_Var[1] = StringSplit("$MiniEditor_Schriftgroese,$MiniEditor_GETBGButton,$MiniEditor_BGColourTrans,$MiniEditor_BGColour,$MiniEditor_Schriftartwahlen,$MiniEditor_Textfarbe,$MiniEditor_Schriftart,$MiniEditor_IconPfad,$MiniEditor_Schriftartstyle,$MiniEditor_Schriftgroese,$MiniEditor_Schriftbreite,$MiniEditor_Schriftartwahlenbt2,$MiniEditor_Schriftartwahlenbt3,$MiniEditor_Schriftartwahlenbt4,$MiniEditor_Schriftartwahlenbt5,$MiniEditor_GetIconButton,$MiniEditor_hintergrund_label,$MiniEditor_bild_label,$MiniEditor_schriftart_label,$MiniEditor_atribute_label,$MiniEditor_farbe_label,$MiniEditor_groesse_label,$MiniEditor_schriftbreite_label,$MiniEditor_IconPfeil1,$MiniEditor_IconPfeil2,$MiniEditor_IconPfeil3,$MiniEditor_IconPfeil4,$MiniEditor_Icon_Index_Input,$MiniEditor_Icon_Index_Pfeil,$MiniEditor_Icon_Index_Label", ",", 2)
$Control_Editor_Setting_Var[2] = StringSplit("$minieditor_style_listview,$minieditor_style", ",", 2)
$Control_Editor_Setting_Var[3] = StringSplit("$minieditor_exstyle_listview,$minieditor_exstyle", ",", 2)
$Control_Editor_Setting_Var[4] = StringSplit("$minieditor_state_listview,$MiniEditor_ControlState", ",", 2)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")


Func _Make_Control_from_toolbox()
	AdlibUnRegister("_Make_Control_from_toolbox")
	MouseUp("primary")
	$str = _GUICtrlListView_GetItemText($Toolbox_listview, _GUICtrlListView_GetSelectionMark($Toolbox_listview), 0)
	If $str = _ISNPlugin_Get_langstring(22) Then _new_Control("button")
	If $str = _ISNPlugin_Get_langstring(23) Then _new_Control("label")
	If $str = _ISNPlugin_Get_langstring(24) Then _new_Control("input")
	If $str = _ISNPlugin_Get_langstring(25) Then _new_Control("checkbox")
	If $str = _ISNPlugin_Get_langstring(26) Then _new_Control("radio")
	If $str = _ISNPlugin_Get_langstring(27) Then _new_Control("image")
	If $str = _ISNPlugin_Get_langstring(28) Then _new_Control("slider")
	If $str = _ISNPlugin_Get_langstring(29) Then _new_Control("progress")
	If $str = _ISNPlugin_Get_langstring(31) Then _new_Control("updown")
	If $str = _ISNPlugin_Get_langstring(32) Then _new_Control("icon")
	If $str = _ISNPlugin_Get_langstring(33) Then _new_Control("combo")
	If $str = _ISNPlugin_Get_langstring(34) Then _new_Control("edit")
	If $str = _ISNPlugin_Get_langstring(35) Then _new_Control("group")
	If $str = _ISNPlugin_Get_langstring(36) Then _new_Control("listbox")
	If $str = _ISNPlugin_Get_langstring(38) Then _new_Control("tab")
	If $str = _ISNPlugin_Get_langstring(39) Then _new_Control("date")
	If $str = _ISNPlugin_Get_langstring(40) Then _new_Control("calendar")
	If $str = _ISNPlugin_Get_langstring(41) Then _new_Control("listview")
	If $str = _ISNPlugin_Get_langstring(232) Then _new_Control("dummy")
	If $str = _ISNPlugin_Get_langstring(246) Then _new_Control("graphic")
	If $str = _ISNPlugin_Get_langstring(252) Then _new_Control("toolbar")
	If $str = _ISNPlugin_Get_langstring(124) Then
		If Not @OSType = "WIN32_NT" Then
			MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(135), 0, $Studiofenster)
			Return
		EndIf
		If @OSVersion = "WIN_2000" Or @OSVersion = "WIN_2003" Or @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
			MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(135), 0, $Studiofenster)
			Return
		EndIf
		_new_Control("softbutton")
	EndIf
	If $str = _ISNPlugin_Get_langstring(136) Then _new_Control("ip")
	If $str = _ISNPlugin_Get_langstring(138) Then _new_Control("treeview")
	If $str = _ISNPlugin_Get_langstring(192) Then _new_Control("menu")
	If $str = _ISNPlugin_Get_langstring(214) Then _new_Control("com")
	If $str = _ISNPlugin_Get_langstring(258) Then _new_Control("statusbar")
EndFunc   ;==>_Make_Control_from_toolbox

Func _test_code()

	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	_TEST_FORM(1, 0, 1)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
;~ 	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_test_code





Func _Code_Generieren()
	_ISNPlugin_Get_Variable("$ISN_Languagefile", "$Languagefile", $Mailslot_Handle)
	_ISNPlugin_Get_Variable("$ISN_Scriptdir", "@scriptdir", $Mailslot_Handle)
	Entferne_Makierung() ;Evtl. Markierte Controls demarkieren
	WinSetTitle($ExtracodeGUI, "", _ISNPlugin_Get_langstring(69))
	GUICtrlSetData($ExtracodeGUI_Label, _ISNPlugin_Get_langstring(69))
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)


	GUISetState(@SW_HIDE, $GUI_Editor)
	GUISetState(@SW_HIDE, $Formstudio_controleditor_GUI)
	GUICtrlSetData($StudioFenster_inside_Text1, _ISNPlugin_Get_langstring(86) & "...")
	GUICtrlSetData($StudioFenster_inside_Text2, "0 %")
	GUICtrlSetData($StudioFenster_inside_load, 0)
	GUICtrlSetState($StudioFenster_inside_Text1, $GUI_SHOW)
	GUICtrlSetState($StudioFenster_inside_Text2, $GUI_SHOW)
	GUICtrlSetState($StudioFenster_inside_Icon, $GUI_SHOW)
	GUICtrlSetState($StudioFenster_inside_load, $GUI_SHOW)

	_TEST_FORM(0, 1, 0, 1) ;Echter isf Code

	SendMessage($sci, $SCI_CLEARALL, 0, 0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessage($sci, $SCI_SETSAVEPOINT, 0, 0)
	SendMessage($sci, $SCI_CANCEL, 0, 0)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION, 0, 0)
	$data = FileRead($Temp_AU3_File)
	If @error Then MsgBox(4096, "Error", $Temp_AU3_File & " read error!" & @error)
	$Generierter_Code_ISF = _UNICODE2ANSI($data)


	SendMessageString($Sci, $SCI_SETTEXT, 0, $Generierter_Code_ISF)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessage($sci, $SCI_SETSAVEPOINT, 0, 0)
	SendMessage($sci, $SCI_GOTOPOS, 0, 0)



	GUICtrlSetState($Showcodebt1, $GUI_SHOW)
	GUICtrlSetState($Showcodebt2, $GUI_SHOW)
	GUICtrlSetState($Showcodebt3, $GUI_SHOW)
	ControlShow($ExtracodeGUI, "", $Code_Generieren_umschalttab)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_HIDE_Extracode", $ExtracodeGUI)
	GUICtrlSetOnEvent($Showcodebt1, "_HIDE_Extracode")

	$wipos = WinGetPos($Studiofenster, "")
	$mon = _GetMonitorFromPoint($wipos[0], $wipos[1])
	_CenterOnMonitor($ExtracodeGUI, "", $mon)

	_TEST_FORM(0, 0, 0, 1) ;Alleinstehend

	$data = FileRead($Temp_AU3_File)
	If @error Then MsgBox(4096, "Error", $Temp_AU3_File & " read error!" & @error)
	$Generierter_Code_AU3 = _UNICODE2ANSI($data)

	_GUICtrlTab_SetCurSel($Code_Generieren_umschalttab, 0)

	GUICtrlSetState($StudioFenster_inside_Text1, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_Text2, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_Icon, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_load, $GUI_HIDE)
	GUISetState(@SW_SHOW, $ExtracodeGUI)
	GUISetState(@SW_SHOW, $GUI_Editor)
	GUISetState(@SW_SHOW, $Formstudio_controleditor_GUI)
	Sci_SetSelection($Sci, 0, 0)
	_ISNPlugin_Starte_Funktion_im_ISN("_Show_FormStudio_Generate_Code_Info")
EndFunc   ;==>_Code_Generieren

Func _Code_generieren_Tab_Event()
	AdlibUnRegister("_Code_generieren_Tab_Event")

	Switch _GUICtrlTab_GetCurSel($Code_Generieren_umschalttab)

		Case 0
			SendMessage($sci, $SCI_CLEARALL, 0, 0)
			SendMessageString($Sci, $SCI_SETTEXT, 0, $Generierter_Code_ISF)

		Case 1
			SendMessage($sci, $SCI_CLEARALL, 0, 0)
			SendMessageString($Sci, $SCI_SETTEXT, 0, $Generierter_Code_AU3)

	EndSwitch

EndFunc   ;==>_Code_generieren_Tab_Event

Func _typereturnicon($type = "")
	Switch $type

		Case "button"
			Return 0

		Case "label"
			Return 1

		Case "input"
			Return 2

		Case "checkbox"
			Return 3

		Case "radio"
			Return 4

		Case "image"
			Return 5

		Case "slider"
			Return 6

		Case "progress"
			Return 7

		Case "updown"
			Return 8

		Case "icon"
			Return 9

		Case "combo"
			Return 10

		Case "edit"
			Return 11

		Case "group"
			Return 12

		Case "listbox"
			Return 13

		Case "tab"
			Return 14

		Case "date"
			Return 15

		Case "calendar"
			Return 16

		Case "listview"
			Return 17

		Case "softbutton"
			Return 18

		Case "ip"
			Return 19

		Case "treeview"
			Return 20

		Case "menu"
			Return 21

		Case "com"
			Return 22

		Case "dummy"
			Return 23

		Case "graphic"
			Return 24

		Case "toolbar"
			Return 25

	EndSwitch
	Return 0
EndFunc   ;==>_typereturnicon

Func _Load_Styles_for_Control($type = "")
	If $type = "" Then
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_style_listview))
		Return
	EndIf
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_style_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($minieditor_style_listview))



	If $type = "button" Or $type = "checkbox" Or $type = "radio" Or $type = "group" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_LEFT", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_RIGHT", 1)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_TOP", 2)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_BOTTOM", 3)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_CENTER", 4)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_DEFPUSHBUTTON", 5)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_MULTILINE", 6)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_BORDER", 7)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_VCENTER", 8)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_ICON", 9)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_BITMAP", 10)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_FLAT", 11)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_NOTIFY", 12)
	EndIf

	If $type = "checkbox" Or $type = "radio" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_RIGHTBUTTON", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_3STATE", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_AUTO3STATE", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_AUTORADIOBUTTON", 0)
	EndIf


	If $type = "label" Or $type = "icon" Or $type = "image" Or $type = "graphic" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_LEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_CENTER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_NOPREFIX")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_LEFTNOWORDWRAP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_RIGHTJUST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_BLACKFRAME")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_BLACKRECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_CENTERIMAGE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_GRAYFRAME")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_ETCHEDFRAME")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_ETCHEDHORZ")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_ETCHEDVERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_GRAYRECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_NOTIFY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_SIMPLE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_SUNKEN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_WHITEFRAME")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_WHITERECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_CLIPSIBLINGS")

	EndIf


	If $type = "slider" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_AUTOTICKS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_BOTH")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_BOTTOM")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_HORZ")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_VERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_NOTHUMB")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_NOTICKS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_LEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_TOP")
	EndIf

	If $type = "listview" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_ICON")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_REPORT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SMALLICON")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_LIST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_EDITLABELS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_NOCOLUMNHEADER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_NOSORTHEADER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SINGLESEL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SHOWSELALWAYS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SORTASCENDING")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SORTDESCENDING")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_NOLABELWRAP")
	EndIf


	If $type = "progress" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$PBS_SMOOTH")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$PBS_VERTICAL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$PBS_MARQUEE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_BORDER")
	EndIf

	If $type = "updown" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_ALIGNLEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_ALIGNRIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_ARROWKEYS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_HORZ")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_NOTHOUSANDS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_WRAP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_NUMBER")
	EndIf



	If $type = "input" Or $type = "edit" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_AUTOHSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_AUTOVSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_CENTER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_PASSWORD")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_READONLY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_LOWERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_NOHIDESEL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_NUMBER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_OEMCONVERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_MULTILINE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_UPPERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_WANTRETURN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_VSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_HSCROLL")
	EndIf

	If $type = "combo" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_AUTOHSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_DISABLENOSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_DROPDOWN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_DROPDOWNLIST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_LOWERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_NOINTEGRALHEIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_OEMCONVERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_SIMPLE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_SORT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_UPPERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_VSCROLL")
	EndIf

	If $type = "listbox" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_DISABLENOSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_NOINTEGRALHEIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_NOSEL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_NOTIFY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_SORT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_STANDARD")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_USETABSTOPS")
	EndIf

	If $type = "treeview" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_HASBUTTONS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_HASLINES")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_LINESATROOT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_DISABLEDRAGDROP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_SHOWSELALWAYS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_RTLREADING")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_NOTOOLTIPS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_CHECKBOXES")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_TRACKSELECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_SINGLEEXPAND")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_FULLROWSELECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_NOSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_NONEVENHEIGHT")
	EndIf

	If $type = "tab" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_SCROLLOPPOSITE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_BOTTOM")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_TOOLTIPS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_MULTISELECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FLATBUTTONS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FORCEICONLEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FORCELABELLEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_HOTTRACK")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_VERTICAL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_BUTTONS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_MULTILINE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_RIGHTJUSTIFY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FIXEDWIDTH")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FOCUSONBUTTONDOWN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_OWNERDRAWFIXED")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FOCUSNEVER")
	EndIf

	If $type = "date" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_UPDOWN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_SHOWNONE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_LONGDATEFORMAT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_TIMEFORMAT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_RIGHTALIGN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_SHORTDATEFORMAT")
	EndIf

	If $type = "calendar" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$MCS_NOTODAY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$MCS_NOTODAYCIRCLE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$MCS_WEEKNUMBERS")
	EndIf

	If $type = "softbutton" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_COMMANDLINK")
	EndIf

	If $type = "ip" Then
		;empty
	EndIf

	If $type = "toolbar" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_ALTDRAG")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_FLAT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_LIST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_REGISTERDROP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_TOOLTIPS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_TRANSPARENT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_WRAPABLE")
	EndIf

	If $type = "statusbar" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SBARS_SIZEGRIP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SBARS_TOOLTIPS")
	EndIf


	$Styles_Array = StringSplit(GUICtrlRead($MiniEditor_Style), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_style_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($minieditor_style_listview, $y, True)
			Next
		Next
	EndIf

	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($minieditor_style_listview))
EndFunc   ;==>_Load_Styles_for_Control








Func _Load_states_for_Control($type = "")
	If $type = "" Then
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_state_listview))
		Return
	EndIf
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_state_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($minieditor_state_listview))
	If $type <> "menu" And $type <> "toolbar" Then
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_UNCHECKED", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_CHECKED", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_SHOW", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_HIDE", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_ENABLE", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_DISABLE", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_FOCUS", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_NOFOCUS", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_DEFBUTTON", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_EXPAND", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_ONTOP", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_INDETERMINATE", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_DROPACCEPTED", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_NODROPACCEPTED", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_AVISTART", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_AVISTOP", 0)
		_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_AVICLOSE", 0)
	EndIf

	$Styles_Array = StringSplit(GUICtrlRead($MiniEditor_ControlState), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_state_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($minieditor_state_listview, $y, True)
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($minieditor_state_listview))
EndFunc   ;==>_Load_states_for_Control




Func _Load_exstyles_for_Control($type = "")
	If $type = "" Then
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_exstyle_listview))
		Return
	EndIf
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_exstyle_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($minieditor_exstyle_listview))


	If $type = "listview" Then
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_FULLROWSELECT")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_GRIDLINES")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_HEADERDRAGDROP")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_TRACKSELECT")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_CHECKBOXES")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_BORDERSELECT")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_DOUBLEBUFFER")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_FLATSB")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_MULTIWORKAREAS")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_SNAPTOGRID")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_SUBITEMIMAGES")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_INFOTIP")
	EndIf


	If $type <> "menu" And $type <> "com" Then
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_CLIENTEDGE", 0)
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_STATICEDGE", 0)
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_ACCEPTFILES", 0)
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_TRANSPARENT", 0)
	    If $type = "image" OR $type = "label" Then	_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$GUI_WS_EX_PARENTDRAG", 0)
	EndIf

	If $type = "toolbar" Then
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_DRAWDDARROWS")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBN_DROPDOWN")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_HIDECLIPPEDBUTTONS")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_DOUBLEBUFFER")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_MIXEDBUTTONS")
	EndIf

	$Styles_Array = StringSplit(GUICtrlRead($MiniEditor_EXStyle), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_exstyle_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $y, True)
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($minieditor_exstyle_listview))
EndFunc   ;==>_Load_exstyles_for_Control



Func _Load_exstyles_for_GUI()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($gui_setup_exstyle_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($gui_setup_exstyle_listview))
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_ACCEPTFILES", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_MDICHILD", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_APPWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_TOPMOST", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_COMPOSITED", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_CLIENTEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_TOOLWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_LAYERED", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_WINDOWEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_CONTEXTHELP", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_DLGMODALFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_OVERLAPPEDWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_STATICEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_TRANSPARENT", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_LAYOUTRTL", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$GUI_WS_EX_PARENTDRAG", 0)


	$Styles_Array = StringSplit(GUICtrlRead($Form_bearbeitenExstyle), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_exstyle_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $y, True)
			Next
		Next
	EndIf

	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($gui_setup_exstyle_listview))
EndFunc   ;==>_Load_exstyles_for_GUI


Func _Load_styles_for_GUI()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($gui_setup_style_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($gui_setup_style_listview))
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_POPUP", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CAPTION", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_DISABLED", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_SIZEBOX", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_SYSMENU", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CHILD", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CLIPCHILDREN", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CLIPSIBLINGS", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_EX_CLIENTEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_DLGFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_BORDER", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_HSCROLL", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_VSCROLL", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MAXIMIZE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MAXIMIZEBOX", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MINIMIZE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MINIMIZEBOX", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_OVERLAPPED", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_OVERLAPPEDWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_POPUPWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_THICKFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_VISIBLE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$DS_MODALFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$DS_SETFOREGROUND", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$DS_CONTEXTHELP", 0)


	$Styles_Array = StringSplit(GUICtrlRead($Form_bearbeitenStyle), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_style_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($gui_setup_style_listview, $y, True)
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($gui_setup_style_listview))
EndFunc   ;==>_Load_styles_for_GUI


Func _Rebuild_ExStylestring_for_GUI($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($Form_bearbeitenExstyle)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_exstyle_listview)
		If _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_exstyle_listview)
		If _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($Form_bearbeitenExstyle, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($Form_bearbeitenExstyle, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, True)
		EndIf
	EndIf
EndFunc   ;==>_Rebuild_ExStylestring_for_GUI

Func _Rebuild_Stylestring_for_GUI($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($Form_bearbeitenStyle)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_style_listview)
		If _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_style_listview)
		If _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($Form_bearbeitenStyle, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($Form_bearbeitenStyle, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, True)
		EndIf
	EndIf
EndFunc   ;==>_Rebuild_Stylestring_for_GUI


Func _Rebuild_Stylestring($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($MiniEditor_Style)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_style_listview)
		If _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_style_listview)
		If _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($MiniEditor_Style, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($MiniEditor_Style, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, True)
		EndIf
	EndIf
	Sleep(50)
	_Mini_Editor_Einstellungen_Uebernehmen()
	Sleep(50)
EndFunc   ;==>_Rebuild_Stylestring



Func _Rebuild_Statestring($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($MiniEditor_ControlState)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_state_listview)
		If _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_state_listview)
		If _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($MiniEditor_ControlState, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($MiniEditor_ControlState, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, True)
		EndIf
	EndIf
	Sleep(50)
	_Mini_Editor_Einstellungen_Uebernehmen()
	Sleep(50)
EndFunc   ;==>_Rebuild_Statestring




Func _Rebuild_exstylestring($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($MiniEditor_EXStyle)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_exstyle_listview)
		If _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_exstyle_listview)
		If _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($MiniEditor_EXStyle, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($MiniEditor_EXStyle, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, True)
		EndIf
	EndIf
	Sleep(50)
	_Mini_Editor_Einstellungen_Uebernehmen()
	Sleep(50)
EndFunc   ;==>_Rebuild_exstylestring

Func _Minieditor_select_allgemein()
	If BitAND(GUICtrlGetState($MiniEditor_textmode_label), $GUI_SHOW) = $GUI_SHOW Then Return
;~ 	_Minieditor_tab_select(-1)
	_Minieditor_tab_select(0)
EndFunc   ;==>_Minieditor_select_allgemein

Func _Minieditor_select_aussehen()
	If BitAND(GUICtrlGetState($MiniEditor_Schriftgroese), $GUI_SHOW) = $GUI_SHOW Then Return
;~ 	_Minieditor_tab_select(-1)
	_Minieditor_tab_select(1)
EndFunc   ;==>_Minieditor_select_aussehen

Func _Minieditor_select_style()
	If BitAND(GUICtrlGetState($minieditor_style), $GUI_SHOW) = $GUI_SHOW Then Return
;~ 	_Minieditor_tab_select(-1)
	_Minieditor_tab_select(2)
EndFunc   ;==>_Minieditor_select_style

Func _Minieditor_select_exstyle()
	If BitAND(GUICtrlGetState($minieditor_exstyle), $GUI_SHOW) = $GUI_SHOW Then Return
;~ 	_Minieditor_tab_select(-1)
	_Minieditor_tab_select(3)
EndFunc   ;==>_Minieditor_select_exstyle

Func _Minieditor_select_state()
	If BitAND(GUICtrlGetState($MiniEditor_ControlState), $GUI_SHOW) = $GUI_SHOW Then Return
;~ 	_Minieditor_tab_select(-1)
	_Minieditor_tab_select(4)
EndFunc   ;==>_Minieditor_select_state

Func _Minieditor_naechste_seite()
	If $control_editor_tab_wechselt_mit_maus = 1 Then Return
	$current_page = 0
	If BitAND(GUICtrlGetState($MiniEditor_textmode_label), $GUI_SHOW) = $GUI_SHOW Then $current_page = 0
	If BitAND(GUICtrlGetState($MiniEditor_Schriftgroese), $GUI_SHOW) = $GUI_SHOW Then $current_page = 1
	If BitAND(GUICtrlGetState($minieditor_style), $GUI_SHOW) = $GUI_SHOW Then $current_page = 2
	If BitAND(GUICtrlGetState($minieditor_exstyle), $GUI_SHOW) = $GUI_SHOW Then $current_page = 3
	If BitAND(GUICtrlGetState($MiniEditor_ControlState), $GUI_SHOW) = $GUI_SHOW Then $current_page = 4
	If $current_page > 3 Then Return
	$control_editor_tab_wechselt_mit_maus = 1
	$current_page = $current_page + 1
	GUISetState(@SW_LOCK, $Formstudio_controleditor_GUI) ;Locke die GUI
;~ 	_Minieditor_tab_select(-1)
	_Minieditor_tab_select($current_page)
	GUISetState(@SW_UNLOCK, $Formstudio_controleditor_GUI) ;GUI wieder freigeben
	GUISwitch($GUI_Editor)
	Sleep(50)
	$control_editor_tab_wechselt_mit_maus = 0
EndFunc   ;==>_Minieditor_naechste_seite

Func _Minieditor_vorherige_seite()
	If $control_editor_tab_wechselt_mit_maus = 1 Then Return
	$current_page = 0
	If BitAND(GUICtrlGetState($MiniEditor_textmode_label), $GUI_SHOW) = $GUI_SHOW Then $current_page = 0
	If BitAND(GUICtrlGetState($MiniEditor_Schriftgroese), $GUI_SHOW) = $GUI_SHOW Then $current_page = 1
	If BitAND(GUICtrlGetState($minieditor_style), $GUI_SHOW) = $GUI_SHOW Then $current_page = 2
	If BitAND(GUICtrlGetState($minieditor_exstyle), $GUI_SHOW) = $GUI_SHOW Then $current_page = 3
	If BitAND(GUICtrlGetState($MiniEditor_ControlState), $GUI_SHOW) = $GUI_SHOW Then $current_page = 4
	If $current_page < 1 Then Return
	$control_editor_tab_wechselt_mit_maus = 1
	$current_page = $current_page - 1
	GUISetState(@SW_LOCK, $Formstudio_controleditor_GUI) ;Locke die GUI
;~ 	_Minieditor_tab_select(-1)
	_Minieditor_tab_select($current_page)
	GUISetState(@SW_UNLOCK, $Formstudio_controleditor_GUI) ;GUI wieder freigeben
	GUISwitch($GUI_Editor)
	Sleep(50)
	$control_editor_tab_wechselt_mit_maus = 0
EndFunc   ;==>_Minieditor_vorherige_seite


Func _Minieditor_tab_select($tab = -1)
	;GUISetState(@SW_LOCK, $Formstudio_controleditor_GUI) ;Locke die GUI
	; Hide anything with $tab = -1
	If $tab = -1 Then
		If IsArray($Control_Editor_Allgemein_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Allgemein_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(139))
		If IsArray($Control_Editor_Darstellung_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Darstellung_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(140))
		If IsArray($Control_Editor_Style_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Style_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(96))
		If IsArray($Control_Editor_ExStyle_Tab) Then _Tab_SetImage_with_Text($Control_Editor_ExStyle_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(141))
		If IsArray($Control_Editor_State_Tab) Then _Tab_SetImage_with_Text($Control_Editor_State_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(142))
		GUICtrlSetPos($MiniEditor_Schriftbreite, -9000, -9000)
		GUICtrlSetPos($MiniEditor_Schriftgroese, -9000, -9000)
		For $i In $Control_Editor_Setting_Var[0]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		For $i In $Control_Editor_Setting_Var[1]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		For $i In $Control_Editor_Setting_Var[2]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		For $i In $Control_Editor_Setting_Var[3]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		For $i In $Control_Editor_Setting_Var[4]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		Return
	EndIf

	;Just Hide last Tab control
	If $Control_Editor_Setting_LastTab = 0 Then
		If IsArray($Control_Editor_Allgemein_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Allgemein_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(139))
	EndIf
	If $Control_Editor_Setting_LastTab = 1 Then
		If IsArray($Control_Editor_Darstellung_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Darstellung_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(140))
		GUICtrlSetPos($MiniEditor_Schriftbreite, -9000, -9000)
		GUICtrlSetPos($MiniEditor_Schriftgroese, -9000, -9000)
	EndIf
	If $Control_Editor_Setting_LastTab = 2 Then
		If IsArray($Control_Editor_Style_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Style_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(96))
	EndIf
	If $Control_Editor_Setting_LastTab = 3 Then
		If IsArray($Control_Editor_ExStyle_Tab) Then _Tab_SetImage_with_Text($Control_Editor_ExStyle_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(141))
	EndIf
	If $Control_Editor_Setting_LastTab = 4 Then
		If IsArray($Control_Editor_State_Tab) Then _Tab_SetImage_with_Text($Control_Editor_State_Tab[1], $Tab_image_middle, 0, _ISNPlugin_Get_langstring(142))
	EndIf

	For $i In $Control_Editor_Setting_Var[$Control_Editor_Setting_LastTab]
		GUICtrlSetState(Execute($i), $GUI_HIDE)
	Next

	;Just show new Tab control
	If $tab = 0 Then
		If IsArray($Control_Editor_Allgemein_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Allgemein_Tab[1], $Tab_image_middle_active, 0, _ISNPlugin_Get_langstring(139))
		GUICtrlSetData($MiniEditorX, GUICtrlRead($MiniEditorX)) ;fix anzeigebug
		GUICtrlSetData($MiniEditorY, GUICtrlRead($MiniEditorY))
	EndIf
	If $tab = 1 Then
		If IsArray($Control_Editor_Darstellung_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Darstellung_Tab[1], $Tab_image_middle_active, 0, _ISNPlugin_Get_langstring(140))
		GUICtrlSetPos($MiniEditor_Schriftbreite, 129 * $DPI, 335 * $DPI, 162 * $DPI, 20 * $DPI)
		GUICtrlSetData($MiniEditor_Schriftbreite, GUICtrlRead($MiniEditor_Schriftbreite))
		GUICtrlSetPos($MiniEditor_Schriftgroese, 129 * $DPI, 305 * $DPI, 162 * $DPI, 20 * $DPI)
		GUICtrlSetData($MiniEditor_Schriftgroese, GUICtrlRead($MiniEditor_Schriftgroese))
	EndIf
	If $tab = 2 Then
		If IsArray($Control_Editor_Style_Tab) Then _Tab_SetImage_with_Text($Control_Editor_Style_Tab[1], $Tab_image_middle_active, 0, _ISNPlugin_Get_langstring(96))
	EndIf
	If $tab = 3 Then
		If IsArray($Control_Editor_ExStyle_Tab) Then _Tab_SetImage_with_Text($Control_Editor_ExStyle_Tab[1], $Tab_image_middle_active, 0, _ISNPlugin_Get_langstring(141))
	EndIf

	If $tab = 4 Then
		If IsArray($Control_Editor_State_Tab) Then _Tab_SetImage_with_Text($Control_Editor_State_Tab[1], $Tab_image_middle_active, 0, _ISNPlugin_Get_langstring(142))
	EndIf

	For $i In $Control_Editor_Setting_Var[$tab]
		GUICtrlSetState(Execute($i), $GUI_SHOW)
	Next
	;	GUISetState(@SW_UNLOCK, $Formstudio_controleditor_GUI) ;gui wieder freigeben
	$Control_Editor_Setting_LastTab = $tab ; save last Tab
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Minieditor_tab_select







Func _Form_bearbeitenGUI_tab_select($tab, $lasttab = -1)
	;	GUISetState(@SW_LOCK, $Form_bearbeitenGUI) ;Locke die GUI
	; Similar to _Minieditor_tab_select
	If $lasttab = -1 Then
		For $i In $Gui_Setting_Tab_Var[1]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		For $i In $Gui_Setting_Tab_Var[2]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		For $i In $Gui_Setting_Tab_Var[3]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		For $i In $Gui_Setting_Tab_Var[4]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
		Return ; Always faster then Hide then Show (Use for first time loading Plugin)
	Else
		If $lasttab = 0 Then
			ControlHide($Form_bearbeitenGUI, "", $Form_bearbeitenBreite_Updown)
			ControlHide($Form_bearbeitenGUI, "", $Form_bearbeitenHoehe_Updown)
			ControlHide($Form_bearbeitenGUI, "", $Form_bearbeiten_ypos_input_Updown)
			ControlHide($Form_bearbeitenGUI, "", $Form_bearbeiten_xpos_input_Updown)
		EndIf
		For $i In $Gui_Setting_Tab_Var[$lasttab]
			GUICtrlSetState(Execute($i), $GUI_HIDE)
		Next
	EndIf

	If $tab = 0 Then
		ControlShow($Form_bearbeitenGUI, "", $Form_bearbeitenBreite_Updown)
		ControlShow($Form_bearbeitenGUI, "", $Form_bearbeitenHoehe_Updown)
		ControlShow($Form_bearbeitenGUI, "", $Form_bearbeiten_ypos_input_Updown)
		ControlShow($Form_bearbeitenGUI, "", $Form_bearbeiten_xpos_input_Updown)
	EndIf
	For $i In $Gui_Setting_Tab_Var[$tab]
		GUICtrlSetState(Execute($i), $GUI_SHOW)
	Next
	;GUISetState(@SW_UNLOCK, $Form_bearbeitenGUI) ;gui wieder freigeben
EndFunc   ;==>_Form_bearbeitenGUI_tab_select

Func _GUIEigenschaften_toggle_zentriereGUI()
	If GUICtrlRead($Form_bearbeiten_fenster_zentrieren_checkbox) = $GUI_CHECKED Then
		GUICtrlSetData($Form_bearbeiten_xpos_input, "-1")
		GUICtrlSetData($Form_bearbeiten_ypos_input, "-1")
		GUICtrlSetState($Form_bearbeiten_xpos_input, $GUI_DISABLE)
		GUICtrlSetState($Form_bearbeiten_ypos_input, $GUI_DISABLE)
	Else
		GUICtrlSetData($Form_bearbeiten_xpos_input, _IniReadEx($Cache_Datei_Handle, "gui", "xpos", "0"))
		GUICtrlSetData($Form_bearbeiten_ypos_input, _IniReadEx($Cache_Datei_Handle, "gui", "ypos", "0"))
		GUICtrlSetState($Form_bearbeiten_xpos_input, $GUI_ENABLE)
		GUICtrlSetState($Form_bearbeiten_ypos_input, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_GUIEigenschaften_toggle_zentriereGUI

Func _GUIEigenschaften_toggle_Code_in_Func()
	If GUICtrlRead($Form_settings_code_in_func_checkbox) = $GUI_CHECKED Then
	    if guictrlread($Form_settings_code_in_func_name_input) = "" then Guictrlsetdata($Form_settings_code_in_func_name_input,"_"&StringReplace( GUICtrlRead($Form_bearbeitenHandle),"$","")&"()")
		GUICtrlSetState($Form_settings_code_in_func_label, $GUI_ENABLE)
		GUICtrlSetState($Form_settings_code_in_func_icon, $GUI_ENABLE)
		GUICtrlSetState($Form_settings_code_in_func_name_input, $GUI_ENABLE)
	Else
		GUICtrlSetState($Form_settings_code_in_func_label, $GUI_DISABLE)
		GUICtrlSetState($Form_settings_code_in_func_icon, $GUI_DISABLE)
		GUICtrlSetState($Form_settings_code_in_func_name_input, $GUI_DISABLE)
	EndIf
 EndFunc


Func _GUI_Settings_GUI_Events_get_func_button()
	If $DEBUG = "true" Then Return ;Nicht im Debug ausf�hren!
	$control = @GUI_CtrlId
	GUISetState(@SW_DISABLE, $Form_bearbeitenGUI)
	_ISNPlugin_Nachricht_senden("listfuncs")
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "listfuncsok", 90000000)
	GUISetState(@SW_ENABLE, $Form_bearbeitenGUI)
	$data = _Pluginstring_get_element($Nachricht, 2)
	If $data = "" Then Return

	Switch $control
		Case $Form_bearbeiten_event_close_button
			GUICtrlSetData($Form_bearbeiten_event_close_input, $data)

		Case $Form_bearbeiten_event_minimize_button
			GUICtrlSetData($Form_bearbeiten_event_minimize_input, $data)

		Case $Form_bearbeiten_event_restore_button
			GUICtrlSetData($Form_bearbeiten_event_restore_input, $data)

		Case $Form_bearbeiten_event_maximize_button
			GUICtrlSetData($Form_bearbeiten_event_maximize_input, $data)

		Case $Form_bearbeiten_event_mousemove_button
			GUICtrlSetData($Form_bearbeiten_event_mousemove_input, $data)

		Case $Form_bearbeiten_event_primarydown_button
			GUICtrlSetData($Form_bearbeiten_event_primarydown_input, $data)

		Case $Form_bearbeiten_event_primaryup_button
			GUICtrlSetData($Form_bearbeiten_event_primaryup_input, $data)

		Case $Form_bearbeiten_event_secoundarydown_button
			GUICtrlSetData($Form_bearbeiten_event_secoundarydown_input, $data)

		Case $Form_bearbeiten_event_secoundaryup_button
			GUICtrlSetData($Form_bearbeiten_event_secoundaryup_input, $data)

		Case $Form_bearbeiten_event_resized_button
			GUICtrlSetData($Form_bearbeiten_event_resized_input, $data)

		Case $Form_bearbeiten_event_dropped_button
			GUICtrlSetData($Form_bearbeiten_event_dropped_input, $data)


	EndSwitch

EndFunc   ;==>_GUI_Settings_GUI_Events_get_func_button


Func _Form_Eigenschaften_Deklaration_Handles_toggle_Radios()
	If GUICtrlRead($Form_Eigenschaften_Deklaration_Handles_Keine_Radio) = $GUI_CHECKED Or GUICtrlRead($Form_Eigenschaften_Deklaration_Default_Radio) = $GUI_CHECKED Then
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_DISABLE)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_UNCHECKED)
		GUICtrlSetState($Form_bearbeiten_Deklarationen_pfeil, $GUI_DISABLE)
	Else
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_ENABLE)
		GUICtrlSetState($Form_bearbeiten_Deklarationen_pfeil, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_Form_Eigenschaften_Deklaration_Handles_toggle_Radios


Func _GUIEigenschaften_toggle_Titelmodus()
	If GUICtrlRead($Form_bearbeiten_fenstertitel_radio1) = $GUI_CHECKED Then
		If $Current_ISN_Skin = "dark theme" And $Use_ISN_Skin = "true" Then
			GUICtrlSetBkColor($Form_bearbeitenTitel, $ISN_Hintergrundfarbe)
		Else
			GUICtrlSetBkColor($Form_bearbeitenTitel, 0xFFFFFF)
		EndIf
	Else
		GUICtrlSetBkColor($Form_bearbeitenTitel, $Farbe_Func_Textmode)
	EndIf
EndFunc   ;==>_GUIEigenschaften_toggle_Titelmodus

Func _MiniEditor_Radio1_select()
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_CHECKED)
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_UNCHECKED)

	If $Current_ISN_Skin = "dark theme" And $Use_ISN_Skin = "true" Then
		GUICtrlSetBkColor($MiniEditor_Text, $ISN_Hintergrundfarbe)
		GUICtrlSetBkColor($MiniEditor_Tooltip, $ISN_Hintergrundfarbe)
		GUICtrlSetBkColor($MiniEditor_IconPfad, $ISN_Hintergrundfarbe)
	Else
		GUICtrlSetBkColor($MiniEditor_Text, 0xFFFFFF)
		GUICtrlSetBkColor($MiniEditor_Tooltip, 0xFFFFFF)
		GUICtrlSetBkColor($MiniEditor_IconPfad, 0xFFFFFF)
	EndIf
	If GUICtrlRead($MiniEditor_Controltype) = "listview" Then GUICtrlSetOnEvent($MiniEditor_Text_erweitert, "_Listview_Zeige_Spalteneditor")
EndFunc   ;==>_MiniEditor_Radio1_select

Func _MiniEditor_Radio2_select()
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_CHECKED)
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_UNCHECKED)
	GUICtrlSetBkColor($MiniEditor_Text, $Farbe_Func_Textmode)
	GUICtrlSetBkColor($MiniEditor_Tooltip, $Farbe_Func_Textmode)
	GUICtrlSetBkColor($MiniEditor_IconPfad, $Farbe_Func_Textmode)
	GUICtrlSetOnEvent($MiniEditor_Text_erweitert, "_Zeige_Erweiterten_Text")
EndFunc   ;==>_MiniEditor_Radio2_select



Func _Erstelle_Tabseite($Text, $x, $y)
	$Textsize_array = _StringSize($Text, 9)
	If Not IsArray($Textsize_array) Then Return
	Local $Rueckgabe_Array[4]
	GUISwitch($Formstudio_controleditor_GUI)

	Local $tab_top = GUICtrlCreatePic("", $x, $y, 25 * $DPI, 14)
	GUICtrlSetState(-1, $GUI_DISABLE)
	_SetImage(-1, $Tab_image_top)

	Local $tab_middle = GUICtrlCreatePic("", $x, ($y + 14), 25 * $DPI, ($Textsize_array[0] + 2) * $DPI)
	GUICtrlSetState(-1, $GUI_DISABLE)
	_Tab_SetImage_with_Text(-1, $Tab_image_middle, 0, $Text)

	Local $tab_middle_pos = ControlGetPos($Formstudio_controleditor_GUI, "", $tab_middle)
	GUICtrlSetState(-1, $GUI_DISABLE)
	If Not IsArray($tab_middle_pos) Then Return

	Local $tab_bottom = GUICtrlCreatePic("", $x, ($tab_middle_pos[1] + $tab_middle_pos[3]), 25 * $DPI, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	_SetImage(-1, $Tab_image_bottom)

	Local $tab_middle_clickpart = GUICtrlCreatePic("", ($x + 3), ($y + 14), 25 * $DPI, $Textsize_array[0])
	GUICtrlSetCursor($tab_middle_clickpart, 0)
	GUICtrlSetState($tab_middle_clickpart, $GUI_ONTOP)


	$Rueckgabe_Array[0] = $tab_top
	$Rueckgabe_Array[1] = $tab_middle
	$Rueckgabe_Array[2] = $tab_bottom
	$Rueckgabe_Array[3] = $tab_middle_clickpart

	Return $Rueckgabe_Array
EndFunc   ;==>_Erstelle_Tabseite

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

; #FUNCTION# ================================================================
; Name...........: GDIPlus_SetAngledText
; Description ...: Adds text to a graphic object at any angle.
; Syntax.........: GDIPlus_SetAngledText($hGraphic, $nText, [$iCentreX, [$iCentreY, [$iAngle , [$nFontName , _
;                                       [$nFontSize, [$iARGB, [$iAnchor]]]]]]] )
; Parameters ....: $hGraphic   - The Graphics object to receive the added text.
;                  $nText      - Text string to be displayed
;                  $iCentreX       - Horizontal coordinate of horixontal centre of the text rectangle        (default =  0 )
;                  $iCentreY        - Vertical coordinate of vertical centre of the text rectangle             (default = 0 )
;                  $iAngle     - The angle which the text will be place in degrees.         (default = "" or blank = 0 )
;                  $nFontName  - The name of the font to be used                      (default = "" or Blank = "Arial" )
;                  $nFontSize  - The font size to be used                                  (default = "" or Blank = 12 )
;                  $iARGB      - Alpha(Transparency), Red, Green and Blue color (0xAARRGGBB) (Default= "" = random color
;                                                                                      or Default = Blank = 0xFFFF00FF )
;                  $iAnchor    - If zero (default) positioning $iCentreX, $iCentreY values refer to centre of text string.
;                                If not zero positioning $iCentreX, $iCentreY values refer to top left corner of text string.
; Return values .: 1
; Author ........: Malkey
; Modified.......:
; Remarks .......: Call _GDIPlus_Startup() before starting this function, and call _GDIPlus_Shutdown()after function ends.
;                  Can enter calculation for Angle Eg. For incline, -ATan($iVDist / $iHDist) * 180 / $iPI , where
;                  $iVDist is Vertical Distance,  $iHDist is Horizontal Distance, and, $iPI is Pi, (an added Global Const).
;                  When used with other graphics, call this function last. The MatrixRotate() may affect following graphics.
; Related .......: _GDIPlus_Startup(), _GDIPlus_Shutdown(), _GDIPlus_GraphicsDispose($hGraphic)
; Link ..........;
; Example .......; Yes
; ========================================================================================
Func GDIPlus_SetAngledText($hGraphic, $nText, $iCentreX = 0, $iCentreY = 0, $iAngle = 0, $nFontName = "Arial", _
		$nFontSize = 12, $iARGB = 0xFFFF00FF, $iAnchor = 0, $ISN_TabMode = 1)
	Local $x, $y, $iX, $iY, $iWidth, $iHeight
	Local $hMatrix, $iXt, $iYt, $hBrush, $hFormat, $hFamily, $hFont, $tLayout

	; Default values
	If $iAngle = "" Then $iAngle = 0
	If $nFontName = "" Or $nFontName = -1 Then $nFontName = "Arial" ; "Microsoft Sans Serif"
	If $nFontSize = "" Then $nFontSize = 12
	If $iARGB = "" Then ; Randomize ARGB color
		$iARGB = "0xFF" & Hex(Random(0, 255, 1), 2) & Hex(Random(0, 255, 1), 2) & Hex(Random(0, 255, 1), 2)
	EndIf

	$hFormat = _GDIPlus_StringFormatCreate(0)
	$hFamily = _GDIPlus_FontFamilyCreate($nFontName)
	$hFont = _GDIPlus_FontCreate($hFamily, $nFontSize, 0, 3)
	$tLayout = _GDIPlus_RectFCreate($iCentreX, $iCentreY, 0, 0)
	$aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $nText, $hFont, $tLayout, $hFormat)
	$iWidth = Ceiling(DllStructGetData($aInfo[0], "Width"))
	$iHeight = Ceiling(DllStructGetData($aInfo[0], "Height"))

	;Later calculations based on centre of Text rectangle.
	If $iAnchor = 0 Then ; Reference to middle of Text rectangle
		$iX = $iCentreX
		$iY = $iCentreY
	Else ; Referenced centre point moved to top left corner of text string.
		$iX = $iCentreX + (($iWidth - Abs($iHeight * Sin($iAngle * $iPI / 180))) / 2)
		If $ISN_TabMode = 1 Then $iX = 16 * $DPI
		$iY = $iCentreY + (($iHeight + Abs($iWidth * Sin($iAngle * $iPI / 180))) / 2)
	EndIf

	;Rotation Matrix
	$hMatrix = _GDIPlus_MatrixCreate()
	_GDIPlus_MatrixRotate($hMatrix, $iAngle, 1)
	_GDIPlus_GraphicsSetTransform($hGraphic, $hMatrix)

	;x, y are display coordinates of center of width and height of the rectanglular text box.
	;Top left corner coordinates rotate in a circular path with radius = (width of text box)/2.
	;Parametric equations for a circle, and adjustments for centre of text box
	$x = ($iWidth / 2) * Cos($iAngle * $iPI / 180) - ($iHeight / 2) * Sin($iAngle * $iPI / 180)
	$y = ($iWidth / 2) * Sin($iAngle * $iPI / 180) + ($iHeight / 2) * Cos($iAngle * $iPI / 180)

	;Rotation of Coordinate Axes formulae - To display at x and y after rotation, we need to enter the
	;x an y position values of where they rotated from. This is done by rotating the coordinate axes.
	;Use $iXt, $iYt in  _GDIPlus_RectFCreate. These x, y values is the position of the rectangular
	;text box point before rotation. (before translation of the matrix)
	$iXt = ($iX - $x) * Cos($iAngle * $iPI / 180) + ($iY - $y) * Sin($iAngle * $iPI / 180)
	$iYt = -($iX - $x) * Sin($iAngle * $iPI / 180) + ($iY - $y) * Cos($iAngle * $iPI / 180)

	$hBrush = _GDIPlus_BrushCreateSolid($iARGB)
	$tLayout = _GDIPlus_RectFCreate($iXt, $iYt, $iWidth, $iHeight)
	_GDIPlus_GraphicsDrawStringEx($hGraphic, $nText, $hFont, $tLayout, $hFormat, $hBrush)

	; Clean up resources
	_GDIPlus_MatrixDispose($hMatrix)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	$tLayout = ""
	Return 1
EndFunc   ;==>GDIPlus_SetAngledText

Func _Tab_SetImage_with_Text($hWnd, $sImage, $hOverlap = 0, $Text = "")

	If StringInStr($sImage, ".jpg") Then
		GUICtrlSetImage($hWnd, $sImage)
		Return
	EndIf
	$hWnd = _Icons_Control_CheckHandle($hWnd)
	If $hWnd = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $Result, $hImage, $hBitmap, $hFit

	_GDIPlus_Startup()

	$hImage = _GDIPlus_BitmapCreateFromFile($sImage)
	$hFit = _Icons_Control_FitTo($hWnd, $hImage)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hFit)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hFit)

	If $ISN_Dark_Mode <> "true" Then
		GDIPlus_SetAngledText($hGraphic, $Text, -3, -10, -90, "Arial", 9, 0xFF52565E, 1)
	Else
		GDIPlus_SetAngledText($hGraphic, $Text, -3, -10, -90, "Arial", 9, 0xFFDEDEDE, 1)
	EndIf

	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hFit)
	_GDIPlus_ImageDispose($hFit)
	_GDIPlus_Shutdown()


	If Not ($hOverlap < 0) Then
		$hOverlap = _Icons_Control_CheckHandle($hOverlap)
	EndIf
	$Result = _Icons_Control_SetImage($hWnd, $hBitmap, $IMAGE_BITMAP, $hOverlap)
	If $Result Then
		$hImage = _SendMessage($hWnd, $__STM_GETIMAGE, $IMAGE_BITMAP, 0)
		If (@error) Or ($hBitmap = $hImage) Then
			$hBitmap = 0
		EndIf
	EndIf
	If $hBitmap Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	Return SetError(1 - $Result, 0, $Result)
EndFunc   ;==>_Tab_SetImage_with_Text

Func _coursor_ist_ueber_Tabseiten()
	$Cursor_INFO_Control_Editor = GUIGetCursorInfo($Formstudio_controleditor_GUI)
	If IsArray($Cursor_INFO_Control_Editor) Then
		If $Cursor_INFO_Control_Editor[4] = $Control_Editor_Style_Tab[3] Then Return True
		If $Cursor_INFO_Control_Editor[4] = $Control_Editor_ExStyle_Tab[3] Then Return True
		If $Cursor_INFO_Control_Editor[4] = $Control_Editor_State_Tab[3] Then Return True
		If $Cursor_INFO_Control_Editor[4] = $Control_Editor_Allgemein_Tab[3] Then Return True
		If $Cursor_INFO_Control_Editor[4] = $Control_Editor_Darstellung_Tab[3] Then Return True

	EndIf
	Return False
EndFunc   ;==>_coursor_ist_ueber_Tabseiten




;Zum umschalten der Tabseiten im Control Editor bei gedrückter STRG-Taste
Func _Mousewheel($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If _IsPressed("11", $dll) Or _coursor_ist_ueber_Tabseiten() Then
		Local $iDelta = BitShift($iwParam, 16)
		If $iDelta > 0 Then _Minieditor_vorherige_seite()
		If $iDelta < 0 Then _Minieditor_naechste_seite()
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_Mousewheel


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	$nID = BitAND($iwParam, 0x0000FFFF)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
	Switch $iCode

		Case $LVN_BEGINDRAG
			If $nID = $Toolbox_listview Then
				MouseUp("primary")
				AdlibRegister("_Make_Control_from_toolbox", 0) ;Geniale Idee um den komischen Drag&Drop Mauszeiger zu vermeiden :P
			EndIf

		Case $TVN_SELCHANGEDW
			If $nID = $menueditor_treeview Then
				_Menu_Editor_Eintrag_waehlen() ;...und wähle dann neues Element
			EndIf

		Case $LVN_COLUMNCLICK
			Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
			Local $iCol = DllStructGetData($tInfo, "SubItem")
			If $nID = $control_reihenfolge_GUI_listview Then _Listview_Sortieren($control_reihenfolge_GUI_listview, $iCol)



		Case $NM_CLICK

			If WinActive($ExtracodeGUI) Then AdlibRegister("_Code_generieren_Tab_Event")
			If $nID = $menueditor_treeview Then
				Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom)
				Local $iX = DllStructGetData($tPOINT, "X")
				Local $iY = DllStructGetData($tPOINT, "Y")
				Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom, $iX, $iY)
				If $hItem <> 0 Then
					_Menu_Editor_uebernehmen(1) ;Speichere zuvor aktuelle Daten...
					_GUICtrlTreeView_SelectItem($hWndFrom, $hItem, $TVGN_CARET)
					_GUICtrlTreeView_SelectItem($menueditor_treeview, $hItem)
					_Menu_Editor_Eintrag_waehlen() ;...und wähle dann neues Element

				EndIf
			EndIf

			If $nID = $minieditor_style_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, 0)
						EndIf
						_Rebuild_Stylestring()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_Stylestring(1, $Item)
				EndSwitch
			EndIf

			If $nID = $minieditor_state_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, 0)
						EndIf
						_Rebuild_Statestring()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_Statestring(1, $Item)
				EndSwitch
			EndIf

			If $nID = $minieditor_exstyle_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, 0)
						EndIf
						_Rebuild_exstylestring()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_exstylestring(1, $Item)
				EndSwitch
			EndIf


			If $nID = $gui_setup_style_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, 0)
						EndIf
						_Rebuild_Stylestring_for_GUI()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_Stylestring_for_GUI(1, $Item)
				EndSwitch
			EndIf


			If $nID = $gui_setup_exstyle_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, 0)
						EndIf
						_Rebuild_ExStylestring_for_GUI()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_ExStylestring_for_GUI(1, $Item)
				EndSwitch
			EndIf




		Case $NM_RCLICK
			If $nID = $Toolbox_listview Then _Make_Control_from_toolbox()
			If $nID = $menueditor_treeview Then
				Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom)
				Local $iX = DllStructGetData($tPOINT, "X")
				Local $iY = DllStructGetData($tPOINT, "Y")
				Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom, $iX, $iY)
;~ 					If $hItem <> 0 Then
				_GUICtrlTreeView_SelectItem($hWndFrom, $hItem, $TVGN_CARET)
				_GUICtrlTreeView_SelectItem($menueditor_treeview, $hItem)
				_Menu_Editor_Eintrag_waehlen()
				_GUICtrlMenu_TrackPopupMenu($menueditor_treeviewmenu_Handle, $menueditorGUI)
			EndIf

		Case $NM_DBLCLK
			If $nID = $Toolbox_listview Then _Make_Control_from_toolbox()
			If $nID = $ControlList Then
				If _GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), 2) = "tab" Then
					Markiere_Control($TABCONTROL_ID)
				Else
					$tabpagee = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle(_GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), 3)), "tabpage", "-1")
					If $tabpagee > -1 Then _GUICtrlTab_SetCurFocus(GUICtrlGetHandle($TABCONTROL_ID), Number($tabpagee))
					;Markiere_Control(_GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList),3))
					_Mark_by_Handle(_GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), 3))
				EndIf
				_GUICtrlListView_SetItemSelected($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), True, True)
			EndIf



	EndSwitch


	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY



Func _Pruefe_auf_doppelklick()
	If $Control_Markiert_MULTI = 1 Then Return
	If $Markiertes_Control_ID = 0 Then Return
	Local $time
	If $clicked Then
		$time = TimerDiff($timer)
	EndIf
	Select
		Case $time > $dblClickTime
			$timer = TimerInit()
			Return
		Case Not $clicked
			$clicked = True
			$timer = TimerInit()
		Case Else
			$clicked = False
			_Control_doubleClick_Event()
	EndSelect
EndFunc   ;==>_Pruefe_auf_doppelklick


Func _Control_doubleClick_Event()
	Switch $FormStudio_doubleclick_action
		Case "extracode"
			If $Control_Markiert_MULTI <> 0 Then Return
			If $Markiertes_Control_ID <> "" Then _Show_Extracode()

		Case "copy"
			If $Control_Markiert_MULTI = 0 And $Markiertes_Control_ID = "" Then Return
			copy_item()

		Case "grid"
			If $Control_Markiert_MULTI = 0 And $Markiertes_Control_ID = "" Then Return
			_Am_Raster_Ausrichten()

	EndSwitch
EndFunc   ;==>_Control_doubleClick_Event


Func _Elemente_an_Fesntergroesse_anpassen()
	;Reihenfolge der Controls
	$control_reihenfolge_GUI_listview_listview_Pos_Array = ControlGetPos($control_reihenfolge_GUI, "", $control_reihenfolge_GUI_listview)
	If Not IsArray($control_reihenfolge_GUI_listview_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 0, 30)
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 1, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 15)
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 2, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 3, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 30)

	;Liste aller Controls im Control Editor
	$ControlList_Pos_Array = ControlGetPos($Formstudio_controleditor_GUI, "", $ControlList)
	If Not IsArray($ControlList_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($ControlList, 0, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 20)
	_GUICtrlListView_SetColumnWidth($ControlList, 1, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 20)
	_GUICtrlListView_SetColumnWidth($ControlList, 2, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 15)


EndFunc   ;==>_Elemente_an_Fesntergroesse_anpassen



Func _Code_GUI_Resize()
	Local $ExtracodeGUI_clientsize = WinGetClientSize($ExtracodeGUI)
	If IsArray($ExtracodeGUI_clientsize) Then WinMove($sci, "", 10 * $DPI, 75 * $DPI, $ExtracodeGUI_clientsize[0] - ((12 + 10) * $DPI), $ExtracodeGUI_clientsize[1] - ((60 + 76) * $DPI))
EndFunc   ;==>_Code_GUI_Resize

Func _Form_bearbeitenGUI_Resize()
	Local $Form_bearbeitenGUI_clientsize = WinGetClientSize($Form_bearbeitenGUI)
	If IsArray($Form_bearbeitenGUI_clientsize) Then WinMove($gui_setup_tab, "", 10 * $DPI, 60 * $DPI, $Form_bearbeitenGUI_clientsize[0] - ((10 + 5) * $DPI), $Form_bearbeitenGUI_clientsize[1] - ((60 + 57) * $DPI))
EndFunc   ;==>_Form_bearbeitenGUI_Resize


Func _Menu_Editor_Resize()
	Local $menueditor_vorschau_group_pos = ControlGetPos($menueditorGUI, "", $menueditor_vorschau_group)
	If IsArray($menueditor_vorschau_group_pos) Then WinMove($menueditor_vorschauGUI, "", $menueditor_vorschau_group_pos[0] + 5, $menueditor_vorschau_group_pos[1] + 17, $menueditor_vorschau_group_pos[2] - 10, $menueditor_vorschau_group_pos[3] - 23)
EndFunc   ;==>_Menu_Editor_Resize

Func _Handle_mit_Dollar_zurueckgeben($handle = "")
	If $handle = "" Then Return ""
	$handle = StringStripWS($handle, 3)
	$handle = StringReplace($handle, "$$", "")
	$handle = StringReplace($handle, "$$$", "")
	$handle = StringReplace($handle, "$$$$", "")
	If StringLeft($handle, 1) <> "$" Then
		Return "$" & $handle
	Else
		Return $handle
	EndIf
EndFunc   ;==>_Handle_mit_Dollar_zurueckgeben

;Settings.au3

Func _Write_in_Config($key, $value)
	Return IniWrite($Configfile, "config", $key, $value)
EndFunc   ;==>_Write_in_Config

Func _Config_Read($key, $errorkey)
	$i = IniRead($Configfile, "config", $key, $errorkey)
	Return $i
EndFunc   ;==>_Config_Read

Func _Show_Configgui()

	GUISetState(@SW_DISABLE, $StudioFenster)

	If _GUICtrlTreeView_GetSelection($config_selectorlist) = 0 Then _GUICtrlTreeView_SelectItem($config_selectorlist, $config_navigation_general, $TVGN_CARET)


	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetOnTop($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], "", 0)
	GUISetState(@SW_SHOW, $Config_GUI)
	GUISetState(@SW_HIDE, $Welcome_GUI)

	GUICtrlSetData($darstellung_monitordropdown, "")
	$string = ""
	For $nr = 1 To $__MonitorList[0][0]
		$string = $string & _Get_langstr(448) & " " & $nr & "|"
	Next
	If $Runonmonitor > $__MonitorList[0][0] Then
		$default = _Get_langstr(448) & " 1"
	Else
		$default = _Get_langstr(448) & " " & $Runonmonitor
	EndIf

	GUICtrlSetData($darstellung_monitordropdown, $string, $default)

	;diverse inputs

	GUICtrlSetData($config_autoupdate_time_in_days, $autoupdate_searchtimer)
	GUICtrlSetData($darstellung_scripteditor_font, $scripteditor_font)
	GUICtrlSetData($darstellung_scripteditor_size, $scripteditor_size)
	GUICtrlSetData($darstellung_scripteditor_bgcolour, $scripteditor_bgcolour)
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute($scripteditor_bgcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, $scripteditor_bgcolour)

	GUICtrlSetData($darstellung_scripteditor_rowcolour, $scripteditor_rowcolour)
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute($scripteditor_rowcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, $scripteditor_rowcolour)

	GUICtrlSetData($darstellung_scripteditor_marccolour, $scripteditor_marccolour)
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute($scripteditor_marccolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, $scripteditor_marccolour)

	GUICtrlSetData($darstellung_scripteditor_highlightcolour, $scripteditor_highlightcolour)
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute($scripteditor_highlightcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, $scripteditor_highlightcolour)

	GUICtrlSetData($darstellung_scripteditor_cursorcolor, $scripteditor_caretcolour)
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute($scripteditor_caretcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, $scripteditor_caretcolour)

	GUICtrlSetData($darstellung_scripteditor_errorcolor, $scripteditor_errorcolour)
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute($scripteditor_errorcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, $scripteditor_errorcolour)

	GUICtrlSetData($darstellung_scripteditor_cursorwidth, $scripteditor_caretwidth)

	GUICtrlSetData($config_scripteditor_zoom_slider, $scripteditor_Zoom)
	GUICtrlSetData($config_scripteditor_zoom_label, $scripteditor_Zoom)

	If _Config_Read("scripteditor_caretstyle", "1") = "1" Then
		GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio1, $GUI_CHECKED)
		GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio2, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio1, $GUI_UNCHECKED)
		GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio2, $GUI_CHECKED)
	EndIf

	GUICtrlSetData($darstellung_treefont_font, $treefont_font)
	GUICtrlSetData($darstellung_treefont_size, $treefont_size)
	GUICtrlSetData($darstellung_treefont_colour, $treefont_colour)
	GUICtrlSetBkColor($darstellung_treefont_colour, $treefont_colour)
	GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert(Execute($treefont_colour)))

	GUICtrlSetData($darstellung_defaultfont_size, $Default_font_size)
	GUICtrlSetData($darstellung_defaultfont_font, $Default_font)


	GUICtrlSetData($setting_scripteditor_bracelight_colour, $scripteditor_bracelight_colour)
	GUICtrlSetBkColor($setting_scripteditor_bracelight_colour, $scripteditor_bracelight_colour)
	GUICtrlSetColor($setting_scripteditor_bracelight_colour, _ColourInvert(Execute($scripteditor_bracelight_colour)))

	GUICtrlSetData($settings_scripteditor_bracebad_colour, $scripteditor_bracebad_colour)
	GUICtrlSetBkColor($settings_scripteditor_bracebad_colour, $scripteditor_bracebad_colour)
	GUICtrlSetColor($settings_scripteditor_bracebad_colour, _ColourInvert(Execute($scripteditor_bracebad_colour)))

	GUICtrlSetData($Input_config_au3exe, _Config_Read("autoitexe", ""))
	GUICtrlSetData($Input_config_au2exe, _Config_Read("autoit2exe", ""))
	GUICtrlSetData($Input_config_helpfile, _Config_Read("helpfileexe", ""))
	GUICtrlSetData($Input_config_Au3Infoexe, _Config_Read("au3infoexe", ""))
	GUICtrlSetData($Input_config_Au3Checkexe, _Config_Read("au3checkexe", ""))
	GUICtrlSetData($Input_config_Au3Stripperexe, _Config_Read("au3stripperexe", ""))
	GUICtrlSetData($Input_config_Tidyexe, _Config_Read("tidyexe", ""))


	GUICtrlSetData($proxy_server_input, $proxy_server)
	GUICtrlSetData($proxy_port_input, $proxy_port)
	GUICtrlSetData($proxy_username_input, $proxy_username)
	If $proxy_PW = "" Then
		$pw = ""
	Else
;~ 		$pw = _StringEncrypt(0, $proxy_PW, "Isn_pRoxy_PW", 2)
		$pw = BinaryToString(_Crypt_DecryptData($proxy_PW, "Isn_pRoxy_PW", $CALG_RC4))

	EndIf

	GUICtrlSetData($proxy_password_input, $pw)



	If _Config_Read("pelock_key", "") = "" Then
		GUICtrlSetData($settings_pelock_key_input, "")
	Else
		GUICtrlSetData($settings_pelock_key_input, BinaryToString(_Crypt_DecryptData(_Config_Read("pelock_key", ""), "Isn_p#EloCK!!_PW", $CALG_RC4)))
	EndIf





	GUICtrlSetData($config_inputstartbefore, $runbefore)
	GUICtrlSetData($config_inputstartafter, $runafter)
	GUICtrlSetData($config_fertigeprojecte_dropdown, "")
	GUICtrlSetData($config_backupmode_combo, "")

	GUICtrlSetData($Combo_closeprogramm, "")
	If _Config_Read("closeaction", "close") = "close" Then GUICtrlSetData($Combo_closeprogramm, _Get_langstr(319) & "|" & _Get_langstr(320) & "|" & _Get_langstr(321), _Get_langstr(319))
	If _Config_Read("closeaction", "close") = "closeproject" Then GUICtrlSetData($Combo_closeprogramm, _Get_langstr(319) & "|" & _Get_langstr(320) & "|" & _Get_langstr(321), _Get_langstr(320))
	If _Config_Read("closeaction", "close") = "minimize" Then GUICtrlSetData($Combo_closeprogramm, _Get_langstr(319) & "|" & _Get_langstr(320) & "|" & _Get_langstr(321), _Get_langstr(321))

	If _Config_Read("releasemode", "1") = "1" Then GUICtrlSetData($config_fertigeprojecte_dropdown, _Get_langstr(413) & "|" & _Get_langstr(414), _Get_langstr(413))
	If _Config_Read("releasemode", "1") = "2" Then GUICtrlSetData($config_fertigeprojecte_dropdown, _Get_langstr(413) & "|" & _Get_langstr(414), _Get_langstr(414))
	_select_releasemode()

	If _Config_Read("backupmode", "1") = "1" Then GUICtrlSetData($config_backupmode_combo, _Get_langstr(425) & "|" & _Get_langstr(426), _Get_langstr(425))
	If _Config_Read("backupmode", "1") = "2" Then GUICtrlSetData($config_backupmode_combo, _Get_langstr(425) & "|" & _Get_langstr(426), _Get_langstr(426))



	$autoit_editor_encoding = _Config_Read("autoit_editor_encoding", "2")
	GUICtrlSetState($Einstellungen_skripteditor_Zeichensatz_default, $GUI_UNCHECKED)
	GUICtrlSetState($Einstellungen_skripteditor_Zeichensatz_UTF8, $GUI_UNCHECKED)
	If $autoit_editor_encoding = "1" Then GUICtrlSetState($Einstellungen_skripteditor_Zeichensatz_default, $GUI_CHECKED)
	If $autoit_editor_encoding = "2" Then GUICtrlSetState($Einstellungen_skripteditor_Zeichensatz_UTF8, $GUI_CHECKED)

	If $lade_zuletzt_geoeffnete_Dateien = "true" Then
		GUICtrlSetState($Checkbox_lade_zuletzt_geoeffnete_Dateien, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_lade_zuletzt_geoeffnete_Dateien, $GUI_UNCHECKED)
	EndIf

	If $enable_autoupdate = "true" Then
		GUICtrlSetState($Checkbox_enable_autoupdate, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_enable_autoupdate, $GUI_UNCHECKED)
	EndIf

	If $ISN_Move_Windows_with_Main_GUI = "true" Then
		GUICtrlSetState($settings_display_Move_Childs_with_Mainwindow_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_display_Move_Childs_with_Mainwindow_Checkbox, $GUI_UNCHECKED)
	EndIf

	Switch $ISN_Save_Positions_mode

		Case "0"
			GUICtrlSetState($settings_display_Gui_Size_Saving_No_Saving_Radio, $GUI_CHECKED)

		Case "1"
			GUICtrlSetState($settings_display_Gui_Size_Saving_Only_Mainwiondow_Radio, $GUI_CHECKED)

		Case "2"
			GUICtrlSetState($settings_display_Gui_Size_Saving_Save_All_Guis_Radio, $GUI_CHECKED)

	EndSwitch

	If $fullscreenmode = "true" Then
		GUICtrlSetState($Checkbox_fullscreenmode, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_fullscreenmode, $GUI_UNCHECKED)
	EndIf

	If $showfunctions = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_showfunctions, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showfunctions, $GUI_UNCHECKED)
	EndIf

	If $AutoEnd_Keywords = "true" Then
		GUICtrlSetState($Checkbox_Settings_AutoEndIf_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Settings_AutoEndIf_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $Auto_dollar_for_declarations = "true" Then
		GUICtrlSetState($Checkbox_Settings_Deklarationen_Auto_Dollar_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Settings_Deklarationen_Auto_Dollar_Checkbox, $GUI_UNCHECKED)
	EndIf


	If $expandfunctions = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandfunctions, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandfunctions, $GUI_UNCHECKED)
	EndIf

	If $showglobalvariables = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_showglobalvariables, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showglobalvariables, $GUI_UNCHECKED)
	EndIf

	If $expandglobalvariables = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_UNCHECKED)
	EndIf

	If $showlocalvariables = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_showlocalvariables, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showlocalvariables, $GUI_UNCHECKED)
	EndIf

	If $expandlocalvariables = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_UNCHECKED)
	EndIf

	If $showincludes = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_showincludes, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showincludes, $GUI_UNCHECKED)
	EndIf

	If $expandincludes = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_UNCHECKED)
	EndIf

	If $showforms = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_showforms, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showforms, $GUI_UNCHECKED)
	EndIf

	If $expandforms = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_UNCHECKED)
	EndIf

	If $Skriptbaum_Funcs_alphabetisch_sortieren = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_alphabetisch, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_alphabetisch, $GUI_UNCHECKED)
	EndIf

	If $loadcontrols = "true" Then
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_UNCHECKED)
	EndIf

	If $showregions = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_showregions, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showregions, $GUI_UNCHECKED)
	EndIf

	If $expandregions = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_UNCHECKED)
	EndIf

	If $verwende_intelimark = "true" Then
		GUICtrlSetState($Checkbox_verwende_intelimark, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_verwende_intelimark, $GUI_UNCHECKED)
	EndIf

	If $intelimark_also_mark_line = "true" Then
		GUICtrlSetState($Config_Scripteditor_Intelimark_AdditionalMarkers_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Config_Scripteditor_Intelimark_AdditionalMarkers_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $allow_trophys = "false" Then
		GUICtrlSetState($Checkbox_disabletrophys, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox_disabletrophys, $GUI_CHECKED)
	EndIf

	If $AskExit = "true" Then
		GUICtrlSetState($Checkbox_AskExit, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_AskExit, $GUI_UNCHECKED)
	EndIf

	If $Autoload = "true" Then
		GUICtrlSetState($Checkbox_Load_Automatic, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Load_Automatic, $GUI_UNCHECKED)
	EndIf

	If $registerinexplorer = "true" Then
		GUICtrlSetState($Checkbox_contextmenu_au3files, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_contextmenu_au3files, $GUI_UNCHECKED)
	EndIf

	If $enablelogo = "true" Then
		GUICtrlSetState($Checkbox_enablelogo, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_enablelogo, $GUI_UNCHECKED)
	EndIf

	If $autoloadmainfile = "true" Then
		GUICtrlSetState($Checkbox_autoloadmainfile, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_autoloadmainfile, $GUI_UNCHECKED)
	EndIf

	If $registerisnfiles = "true" Then
		GUICtrlSetState($Checkbox_registerisnfiles, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_registerisnfiles, $GUI_UNCHECKED)
	EndIf

	If $registerau3files = "true" Then
		GUICtrlSetState($Checkbox_registerau3files, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_registerau3files, $GUI_UNCHECKED)
	EndIf

	If $registerispfiles = "true" Then
		GUICtrlSetState($Checkbox_registerispfiles, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_registerispfiles, $GUI_UNCHECKED)
	EndIf

	If $registericpfiles = "true" Then
		GUICtrlSetState($Checkbox_registericpfiles, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_registericpfiles, $GUI_UNCHECKED)
	EndIf

	If $hideprogramlog = "true" Then
		GUICtrlSetState($Checkbox_hideprogramlog, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox_hideprogramlog, $GUI_CHECKED)
	EndIf

	If _Config_Read("isn_vertical_toolbar", "false") = "true" Then
		GUICtrlSetState($settings_toolbar_display_vertical_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_toolbar_display_vertical_checkbox, $GUI_UNCHECKED)
	EndIf

	If $hidefunctionstree = "true" Then
		GUICtrlSetState($Checkbox_hidefunctionstree, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox_hidefunctionstree, $GUI_CHECKED)
	EndIf

	If $Bearbeitende_Function_im_skriptbaum_markieren = "true" Then
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_CHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_UNCHECKED)
	EndIf

	If $Bearbeitende_Function_im_skriptbaum_markieren_Modus = "1" Then
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode1_radio, $GUI_CHECKED)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode2_radio, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode1_radio, $GUI_UNCHECKED)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode2_radio, $GUI_CHECKED)
	EndIf


	If $hidedebug = "true" Then
		GUICtrlSetState($Checkbox_hidedebug, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox_hidedebug, $GUI_CHECKED)
	EndIf

	If $globalautocomplete = "true" Then
		GUICtrlSetState($Checkbox_globalautocomplete, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_globalautocomplete, $GUI_UNCHECKED)
	EndIf

	If $globalautocomplete_current_script = "true" Then
		GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_UNCHECKED)
	EndIf

	If $globalautocomplete_variables_return_only_global = "true" Then
		GUICtrlSetState($globalautocomplete_variables_return_only_global_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($globalautocomplete_variables_return_only_global_checkbox, $GUI_UNCHECKED)
	EndIf

	If $disableautocomplete = "true" Then
		GUICtrlSetState($Checkbox_disableautocomplete, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox_disableautocomplete, $GUI_CHECKED)
	EndIf

	If $Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = "true" Then
		GUICtrlSetState($Autocomplete_ab_zweitem_zeichen_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Autocomplete_ab_zweitem_zeichen_checkbox, $GUI_UNCHECKED)
	EndIf

	If $allow_autocomplete_with_tabkey = "true" Then
		GUICtrlSetState($Autocomplete_allow_complete_with_tabkey_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Autocomplete_allow_complete_with_tabkey_checkbox, $GUI_UNCHECKED)
	EndIf

	If $allow_autocomplete_with_spacekey = "true" Then
		GUICtrlSetState($Autocomplete_allow_complete_with_spacekey_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Autocomplete_allow_complete_with_spacekey_checkbox, $GUI_UNCHECKED)
	EndIf

	If $ScriptEditor_UseAutoFormat_Correction = "true" Then
		GUICtrlSetState($ScriptEditor_UseAutoFormat_Correction_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($ScriptEditor_UseAutoFormat_Correction_checkbox, $GUI_UNCHECKED)
	EndIf

	If $QuickView_NoTextinTabs = "true" Then
		GUICtrlSetState($QuickView_NoTextinTabs_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($QuickView_NoTextinTabs_checkbox, $GUI_UNCHECKED)
	EndIf

	If $ScriptEditor_Autocomplete_Brackets = "true" Then
		GUICtrlSetState($ScriptEditor_Autocomplete_Brackets_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($ScriptEditor_Autocomplete_Brackets_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $ScriptEditor_highlight_brackets = "true" Then
		GUICtrlSetState($ScriptEditor_highlight_brackets_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($ScriptEditor_highlight_brackets_checkbox, $GUI_UNCHECKED)
	EndIf

	If $disableintelisense = "true" Then
		GUICtrlSetState($Checkbox_disableintelisense, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Checkbox_disableintelisense, $GUI_CHECKED)
	EndIf

	If $showlines = "true" Then
		GUICtrlSetState($Checkbox_showlines, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_showlines, $GUI_UNCHECKED)
	EndIf

	If $scripteditor_fold_margin = "true" Then
		GUICtrlSetState($settings_scripteditor_fold_margin_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_scripteditor_fold_margin_checkbox, $GUI_UNCHECKED)
	EndIf

	If $scripteditor_bookmark_margin = "true" Then
		GUICtrlSetState($settings_scripteditor_bookmark_margin_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_scripteditor_bookmark_margin_checkbox, $GUI_UNCHECKED)
	EndIf

	If $scripteditor_display_whitespace = "true" Then
		GUICtrlSetState($settings_scripteditor_display_whitespace_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_scripteditor_display_whitespace_checkbox, $GUI_UNCHECKED)
	EndIf

	If $scripteditor_display_endofline = "true" Then
		GUICtrlSetState($settings_scripteditor_display_endofline_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_scripteditor_display_endofline_checkbox, $GUI_UNCHECKED)
	EndIf

	If $scripteditor_display_indentationguides = "true" Then
		GUICtrlSetState($settings_scripteditor_display_indentationguides_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_scripteditor_display_indentationguides_checkbox, $GUI_UNCHECKED)
	EndIf

	If $Pfade_bei_Programmstart_automatisch_suchen = "true" Then
		GUICtrlSetState($Checkbox_Programmpfade_automatisch_erkennen, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Programmpfade_automatisch_erkennen, $GUI_UNCHECKED)
	EndIf

	If FileExists(@ScriptDir & "\portable.dat") Then
		GUICtrlSetState($Checkbox_Programmpfade_automatisch_erkennen, $GUI_CHECKED)
		GUICtrlSetState($Checkbox_Programmpfade_automatisch_erkennen, $GUI_DISABLE)
	EndIf

	If $allowcommentout = "true" Then
		GUICtrlSetState($Checkbox_allowcommentout, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_allowcommentout, $GUI_UNCHECKED)
	EndIf

	If $Scripteditor_AllowBracketpairs = "true" Then
		GUICtrlSetState($settings_scripteditor_bracketpairs_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_scripteditor_bracketpairs_checkbox, $GUI_UNCHECKED)
	EndIf

	If $Scripteditor_EnableMultiCursor = "true" Then
		GUICtrlSetState($settings_scripteditor_multicursor_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($settings_scripteditor_multicursor_checkbox, $GUI_UNCHECKED)
	EndIf

	If $use_new_au3_colours = "true" Then
		GUICtrlSetState($Checkbox_use_new_colours, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_use_new_colours, $GUI_UNCHECKED)
	EndIf

	If $enablebackup = "true" Then
		GUICtrlSetState($Checkbox_enablebackup, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_enablebackup, $GUI_UNCHECKED)
	EndIf

	If $Zusaetzliche_Include_Pfade_ueber_ISN_verwalten = "true" Then
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $starte_Skripts_mit_au3Wrapper = "true" Then
		GUICtrlSetState($checkbox_run_scripts_with_au3wrapper, $GUI_CHECKED)
	Else
		GUICtrlSetState($checkbox_run_scripts_with_au3wrapper, $GUI_UNCHECKED)
	EndIf

	If $protect_files_from_external_modification = "true" Then
		GUICtrlSetState($Checkbox_protect_files_from_external_modification, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_protect_files_from_external_modification, $GUI_UNCHECKED)
	EndIf

	If $enabledeleteoldbackups = "true" Then
		GUICtrlSetState($Checkbox_enabledeleteoldbackups, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_enabledeleteoldbackups, $GUI_UNCHECKED)
	EndIf

	If $hintergrundfarbe_fuer_alle_uebernehmen = "true" Then
		GUICtrlSetState($einstellungen_farben_hintergrund_fuer_alle_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($einstellungen_farben_hintergrund_fuer_alle_checkbox, $GUI_UNCHECKED)
	EndIf


	If _Config_Read("highDPI_mode", "true") = "true" Then
		GUICtrlSetState($programmeinstellungen_Darstellung_HighDPIMode_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($programmeinstellungen_Darstellung_HighDPIMode_Checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("enable_custom_dpi_value", "false") = "true" Then
		GUICtrlSetState($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox, $GUI_CHECKED)
		GUICtrlSetState($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $savefolding = "true" Then
		GUICtrlSetState($Checkbox_savefolding, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_savefolding, $GUI_UNCHECKED)
	EndIf

	If $Automatische_Speicherung_Aktiv = "true" Then
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $Automatische_Speicherung_Nur_Skript_Tabs_Sichern = "true" Then
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $Automatische_Speicherung_Nur_aktuellen_Tabs_Sichern = "true" Then
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_UNCHECKED)
	EndIf

	If $Automatische_Speicherung_Modus = "1" Then
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_CHECKED)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_UNCHECKED)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_CHECKED)
	EndIf

	If $Automatische_Speicherung_Eingabe_Nur_einmal_sichern = "true" Then
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, $Automatische_Speicherung_Timer_Sekunden)
	GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, $Automatische_Speicherung_Timer_Minuten)
	GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, $Automatische_Speicherung_Timer_Stunden)

	GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, $Automatische_Speicherung_Eingabe_Sekunden)
	GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, $Automatische_Speicherung_Eingabe_Minuten)
	GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, $Automatische_Speicherung_Eingabe_Stunden)


	If $Immer_am_primaeren_monitor_starten = "true" Then
		GUICtrlSetState($_Immer_am_primaeren_monitor_starten_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($_Immer_am_primaeren_monitor_starten_checkbox, $GUI_UNCHECKED)
	EndIf

	If $SkriptEditor_Doppelklick_ParameterEditor = "true" Then
		GUICtrlSetState($Checkbox_Settings_Auto_ParameterEditor, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Settings_Auto_ParameterEditor, $GUI_UNCHECKED)
	EndIf

	If $Tools_Bitrechner_aktiviert = "true" Then
		GUICtrlSetState($setting_tools_bitoperation_enabled_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($setting_tools_bitoperation_enabled_checkbox, $GUI_UNCHECKED)
	EndIf

	If $Tools_Parameter_Editor_aktiviert = "true" Then
		GUICtrlSetState($setting_tools_parametereditor_enabled_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($setting_tools_parametereditor_enabled_checkbox, $GUI_UNCHECKED)
	EndIf


	If $Tools_PELock_Obfuscator_aktiviert = "true" Then
		GUICtrlSetState($setting_tools_obfuscator_enabled_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($setting_tools_obfuscator_enabled_checkbox, $GUI_UNCHECKED)
	EndIf


	If $showdebuggui = "true" Then
		GUICtrlSetState($Checkbox_disabledebuggui, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_disabledebuggui, $GUI_UNCHECKED)
	EndIf

	If $Zeige_Buttons_neben_Debug_Fenster = "true" Then
		GUICtrlSetState($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_UNCHECKED)
	EndIf

	If $Skript_Editor_Automatische_Dateitypen = "true" Then
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_automatisch_radio, $GUI_CHECKED)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_manuell_radio, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_manuell_radio, $GUI_CHECKED)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_automatisch_radio, $GUI_UNCHECKED)
	EndIf

	If $Verwalte_Tidyeinstellungen_mit_dem_ISN = "true" Then
		GUICtrlSetState($einstellungen_tidy_ueberdasISNverwalten, $GUI_CHECKED)
	Else
		GUICtrlSetState($einstellungen_tidy_ueberdasISNverwalten, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($Einstellungen_Backup_Ordnerstruktur_input, $Autobackup_Ordnerstruktur)
	GUICtrlSetData($Input_backuptime, $backuptime)
	GUICtrlSetData($Input_deleteoldbackupsafter, $deleteoldbackupsafter)


	GUICtrlSetData($Einstellungen_Pfade_Pluginpfad_input, $Pluginsdir)
	GUICtrlSetData($Input_Projekte_Pfad, $Projectfolder)
	GUICtrlSetData($Input_Backup_Pfad, $Backupfolder)
	GUICtrlSetData($Input_Release_Pfad, $releasefolder)
	GUICtrlSetData($Input_template_Pfad, $templatefolder)


	If _Config_Read("skin", "#none#") = "#none#" Then
		GUICtrlSetState($config_skin_radio1, $GUI_CHECKED)
		GUICtrlSetState($config_skin_radio2, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($config_skin_radio2, $GUI_CHECKED)
		GUICtrlSetState($config_skin_radio1, $GUI_UNCHECKED)
	EndIf

	If $Use_Proxy = "true" Then
		GUICtrlSetState($proxy_enable_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($proxy_enable_checkbox, $GUI_UNCHECKED)
	EndIf

	If $AutoIt_Projekte_in_Projektbaum_anzeigen = "true" Then
		GUICtrlSetState($Checkbox_projekte_im_projektbaum, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_projekte_im_projektbaum, $GUI_UNCHECKED)
	EndIf

	Switch $Makrosicherheitslevel

		Case 0
			GUICtrlSetData($programmeinstellungen_makrosicherheit_slider, 4)

		Case 1
			GUICtrlSetData($programmeinstellungen_makrosicherheit_slider, 3)

		Case 2
			GUICtrlSetData($programmeinstellungen_makrosicherheit_slider, 2)

		Case 3
			GUICtrlSetData($programmeinstellungen_makrosicherheit_slider, 1)

		Case 4
			GUICtrlSetData($programmeinstellungen_makrosicherheit_slider, 0)

	EndSwitch

	$Toolbarlayout = _Config_Read("toolbar_layout", $Toolbar_Standardlayout)


	GUICtrlSetData($programmeinstellungen_DPI_Slider, Number(_Config_Read("custom_dpi_value", 1)) * 100)
	_Darstellung_bewege_DPI_Slider()
	_API_Pfade_in_Listview_Laden()
	_Einstellungen_Skript_Editor_Dateitypen_in_Listview_Laden()
	_Lade_Weitere_Includes_in_Listview()
	_Einstellungen_Toolbar_Lade_Verfuegbarliste()
	_Einstellungen_Toolbar_Lade_Elemente_aus_Layout()
	_Immer_am_primaeren_monitor_starten_Toggle_Checkbox()
	_Settings_QuickView_LoadAvailableElements_inListview()
	_Toggle_autocompletefields()
	_Toggle_autoupdatefields()
	_Toggle_Filetypes_Modes()
	_Programmeinstellungen_Tools_Checkbox_event()
	_Toggle_proxyfields()
	_Toggle_Skripteditor()
	_Toggle_Autosave_Modes()
	_Toggle_backupmode()
	_Load_Skins()
	_Toggle_Skin()
	_Disable_edit()
	_Load_Languages()
	_List_Plugins()
	_Aktualisiere_Hotkeyliste()
	_Select_Language()
	_Einstellungen_Lade_Farben()
	_settings_toggle_tidywithISN()
	_Tidy_Einstellungen_einlesen()
	_Config_QuickView_Toggle_Checkboxes()
	$QuickView_LayoutReload_Required = 0
EndFunc   ;==>_Show_Configgui

Func _HIDE_Configgui()
	If $Offenes_Projekt = "" And $Studiomodus = 1 Then
		_Load_Projectlist()
		GUISetState(@SW_SHOW, $Welcome_GUI)
	Else
		GUISetState(@SW_ENABLE, $StudioFenster)

	EndIf

;~ 	if _GUICtrlTab_GetItemCount($htab) > 0 then WinSetOnTop($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], "", 1)
	GUISetState(@SW_HIDE, $Config_GUI)
	_Enable_edit()
EndFunc   ;==>_HIDE_Configgui

Func _Save_Settings()

	Local $Require_Restart = 0
	Local $MonitorSettings_Changed = 0

	GUISetState(@SW_SHOW, $Einstellungen_werden_gespeichert_GUI)
	GUISetState(@SW_DISABLE, $Config_GUI)
	_Write_ISN_Debug_Console("Saving Configuration...", 1, 0)
	If $Languagefile <> $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1] Then $Require_Restart = 1

	If GUICtrlRead($config_skin_radio2) = $GUI_CHECKED Then
		If $skin <> _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) Then
			$Require_Restart = 1
			If _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) = "Dark Theme" Then
				$res = MsgBox(4 + 32 + 262144, _Get_langstr(48), _Get_langstr(1149), 0, $Einstellungen_werden_gespeichert_GUI)
				If $res = 6 Then _farbeinstellungen_fuer_dark_theme_vorbereiten()
			EndIf
		EndIf
	EndIf

	If GUICtrlRead($config_skin_radio1) = $GUI_CHECKED Then
		If $skin <> "#none#" Then
			$Require_Restart = 1
			$res = MsgBox(4 + 32 + 262144, _Get_langstr(48), _Get_langstr(1177), 0, $Einstellungen_werden_gespeichert_GUI)
			If $res = 6 Then _farbeinstellungen_auf_Standard_vorbereiten()
		EndIf
	EndIf

	If GUICtrlRead($config_skin_radio2) = $GUI_CHECKED Then
		If _GUICtrlListView_GetSelectionMark($config_skin_list) = -1 Then
			_Write_in_Config("skin", "#none#")
		Else
			_Write_in_Config("skin", _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2))
		EndIf
	Else
		_Write_in_Config("skin", "#none#")
	EndIf

	If GUICtrlRead($Combo_closeprogramm) = _Get_langstr(319) Then
		_Write_in_Config("closeaction", "close")
		$closeaction = "close"
	EndIf

	If GUICtrlRead($Combo_closeprogramm) = _Get_langstr(320) Then
		_Write_in_Config("closeaction", "closeproject")
		$closeaction = "closeproject"
	EndIf

	If GUICtrlRead($Combo_closeprogramm) = _Get_langstr(321) Then
		_Write_in_Config("closeaction", "minimize")
		$closeaction = "minimize"
	EndIf



	If _Write_in_Config("language", $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1]) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1181), "%1", $Configfile), 0, $Einstellungen_werden_gespeichert_GUI)
	EndIf

	;save Monitor
	$strx = StringTrimLeft(GUICtrlRead($darstellung_monitordropdown), StringLen(_Get_langstr(448)) + 1)
	$strx = Number($strx)
	$Runonmonitor = $strx
	If _Config_Read("runonmonitor", "1") <> $Runonmonitor Then
		$Require_Restart = 1
		$MonitorSettings_Changed = 1
	EndIf
	_Write_in_Config("runonmonitor", $strx)


	;Automatisches Update Intervall
	$time = GUICtrlRead($config_autoupdate_time_in_days)
	$time = Number($time)
	If $time < 1 Then $time = 1
	_Write_in_Config("autoupdate_searchtimer", $time)
	$autoupdate_searchtimer = $time

	;Proxy
	_Write_in_Config("proxy_server", GUICtrlRead($proxy_server_input))
	$proxy_server = GUICtrlRead($proxy_server_input)

	_Write_in_Config("proxy_port", GUICtrlRead($proxy_port_input))
	$proxy_port = GUICtrlRead($proxy_port_input)

	_Write_in_Config("proxy_username", GUICtrlRead($proxy_username_input))
	$proxy_username = GUICtrlRead($proxy_username_input)

	If GUICtrlRead($proxy_password_input) = "" Then
		$pw = ""
	Else
;~ 		$pw = _StringEncrypt(1, guictrlread($proxy_password_input), "Isn_pRoxy_PW", 2)
		$pw = _Crypt_EncryptData(GUICtrlRead($proxy_password_input), "Isn_pRoxy_PW", $CALG_RC4)
	EndIf
	_Write_in_Config("proxy_PW", $pw)
	$proxy_PW = $pw

	If GUICtrlRead($settings_pelock_key_input) = "" Then
		_Write_in_Config("pelock_key", "")
	Else
		_Write_in_Config("pelock_key", _Crypt_EncryptData(GUICtrlRead($settings_pelock_key_input), "Isn_p#EloCK!!_PW", $CALG_RC4))
	EndIf




	_Write_in_Config("scripteditor_font", GUICtrlRead($darstellung_scripteditor_font))
	$scripteditor_font = GUICtrlRead($darstellung_scripteditor_font)

	_Write_in_Config("scripteditor_size", Number(StringReplace(GUICtrlRead($darstellung_scripteditor_size), ",", ".")))
	$scripteditor_size = GUICtrlRead($darstellung_scripteditor_size)


	_Write_in_Config("scripteditor_bgcolour", GUICtrlRead($darstellung_scripteditor_bgcolour))
	$scripteditor_bgcolour = GUICtrlRead($darstellung_scripteditor_bgcolour)


	_Write_in_Config("scripteditor_rowcolour", GUICtrlRead($darstellung_scripteditor_rowcolour))
	$scripteditor_rowcolour = GUICtrlRead($darstellung_scripteditor_rowcolour)


	_Write_in_Config("scripteditor_marccolour", GUICtrlRead($darstellung_scripteditor_marccolour))
	$scripteditor_marccolour = GUICtrlRead($darstellung_scripteditor_marccolour)

	_Write_in_Config("scripteditor_highlightcolour", GUICtrlRead($darstellung_scripteditor_highlightcolour))
	$scripteditor_highlightcolour = GUICtrlRead($darstellung_scripteditor_highlightcolour)

	_Write_in_Config("scripteditor_caretcolour", GUICtrlRead($darstellung_scripteditor_cursorcolor))
	$scripteditor_caretcolour = GUICtrlRead($darstellung_scripteditor_cursorcolor)

	_Write_in_Config("scripteditor_errorcolour", GUICtrlRead($darstellung_scripteditor_errorcolor))
	$scripteditor_errorcolour = GUICtrlRead($darstellung_scripteditor_errorcolor)

	_Write_in_Config("scripteditor_caretwidth", GUICtrlRead($darstellung_scripteditor_cursorwidth))
	$scripteditor_caretwidth = GUICtrlRead($darstellung_scripteditor_cursorwidth)

	_Write_in_Config("scripteditor_zoom", GUICtrlRead($config_scripteditor_zoom_slider))
	$scripteditor_Zoom = GUICtrlRead($config_scripteditor_zoom_slider)

	If GUICtrlRead($darstellung_scripteditor_cursorstyle_Radio1) = $GUI_CHECKED Then
		$scripteditor_caretstyle = "1"
		_Write_in_Config("scripteditor_caretstyle", "1")
	Else
		$scripteditor_caretstyle = "2"
		_Write_in_Config("scripteditor_caretstyle", "2")
	EndIf


	_Write_in_Config("treefont_font", GUICtrlRead($darstellung_treefont_font))
	$treefont_font = GUICtrlRead($darstellung_treefont_font)

	_Write_in_Config("treefont_size", Number(StringReplace(GUICtrlRead($darstellung_treefont_size), ",", ".")))
	$treefont_size = Number(StringReplace(GUICtrlRead($darstellung_treefont_size), ",", "."))

	_Write_in_Config("treefont_colour", GUICtrlRead($darstellung_treefont_colour))
	$treefont_colour = GUICtrlRead($darstellung_treefont_colour)

	_Write_in_Config("scripteditor_bracelight_colour", GUICtrlRead($setting_scripteditor_bracelight_colour))
	$scripteditor_bracelight_colour = GUICtrlRead($setting_scripteditor_bracelight_colour)

	_Write_in_Config("scripteditor_bracebad_colour", GUICtrlRead($settings_scripteditor_bracebad_colour))
	$scripteditor_bracebad_colour = GUICtrlRead($settings_scripteditor_bracebad_colour)

	If $Default_font <> GUICtrlRead($darstellung_defaultfont_font) Then $Require_Restart = 1
	_Write_in_Config("default_font", GUICtrlRead($darstellung_defaultfont_font))
	$Default_font = GUICtrlRead($darstellung_defaultfont_font)

	If $Default_font_size <> Number(StringReplace(GUICtrlRead($darstellung_defaultfont_size), ",", ".")) Then $Require_Restart = 1
	_Write_in_Config("default_font_size", Number(StringReplace(GUICtrlRead($darstellung_defaultfont_size), ",", ".")))
	$Default_font_size = Number(StringReplace(GUICtrlRead($darstellung_defaultfont_size), ",", "."))

	_Write_in_Config("runbefore", GUICtrlRead($config_inputstartbefore))
	_Write_in_Config("runafter", GUICtrlRead($config_inputstartafter))
	$runbefore = GUICtrlRead($config_inputstartbefore)
	$runafter = GUICtrlRead($config_inputstartafter)

	_Write_in_Config("autoitexe", GUICtrlRead($Input_config_au3exe))
	$autoitexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_au3exe))

	_Write_in_Config("helpfileexe", GUICtrlRead($Input_config_helpfile))
	$helpfile = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_helpfile))

	_Write_in_Config("autoit2exe", GUICtrlRead($Input_config_au2exe))
	$autoit2exe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_au2exe))

	_Write_in_Config("au3infoexe", GUICtrlRead($Input_config_Au3Infoexe))
	$Au3Infoexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Infoexe))

	_Write_in_Config("au3checkexe", GUICtrlRead($Input_config_Au3Checkexe))
	$Au3Checkexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Checkexe))

	_Write_in_Config("au3stripperexe", GUICtrlRead($Input_config_au3stripperexe))
	$Au3Stripperexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_au3stripperexe))

	_Write_in_Config("tidyexe", GUICtrlRead($Input_config_Tidyexe))
	$Tidyexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Tidyexe))





	If GUICtrlRead($config_fertigeprojecte_dropdown) = _Get_langstr(413) Then
		If GUICtrlRead($Input_Release_Pfad) = "" Then GUICtrlSetData($Input_Release_Pfad, $Standardordner_Release)
	Else
		If GUICtrlRead($Input_Release_Pfad) = "" Then GUICtrlSetData($Input_Release_Pfad, "Release")
		If StringInStr(GUICtrlRead($Input_Release_Pfad), "\") Then GUICtrlSetData($Input_Release_Pfad, StringReplace(GUICtrlRead($Input_Release_Pfad), "\", ""))
		If StringInStr(GUICtrlRead($Input_Release_Pfad), ":") Then GUICtrlSetData($Input_Release_Pfad, StringReplace(GUICtrlRead($Input_Release_Pfad), ":", ""))
	EndIf
	_Write_in_Config("releasefolder", GUICtrlRead($Input_Release_Pfad))
	$releasefolder = GUICtrlRead($Input_Release_Pfad)

	If GUICtrlRead($config_fertigeprojecte_dropdown) = _Get_langstr(413) Then
		_Write_in_Config("releasemode", "1")
		$releasemode = 1
	Else
		_Write_in_Config("releasemode", "2")
		$releasemode = 2
	EndIf


	If GUICtrlRead($config_backupmode_combo) = _Get_langstr(425) Then
		If GUICtrlRead($Input_Backup_Pfad) = "" Then GUICtrlSetData($Input_Backup_Pfad, $Standardordner_backups)
	Else
		If GUICtrlRead($Input_Backup_Pfad) = "" Then GUICtrlSetData($Input_Backup_Pfad, "Backup")
		If StringInStr(GUICtrlRead($Input_Backup_Pfad), "\") Then GUICtrlSetData($Input_Backup_Pfad, StringReplace(GUICtrlRead($Input_Backup_Pfad), "\", ""))
		If StringInStr(GUICtrlRead($Input_Backup_Pfad), ":") Then GUICtrlSetData($Input_Backup_Pfad, StringReplace(GUICtrlRead($Input_Backup_Pfad), ":", ""))
	EndIf


	_Write_in_Config("backupfolder", GUICtrlRead($Input_Backup_Pfad))
	_Write_in_Config("backup_folderstructure", GUICtrlRead($Einstellungen_Backup_Ordnerstruktur_input))
	$Autobackup_Ordnerstruktur = GUICtrlRead($Einstellungen_Backup_Ordnerstruktur_input)

	If GUICtrlRead($config_backupmode_combo) = _Get_langstr(425) Then
		_Write_in_Config("backupmode", "1")
		$backupmode = 1
		$Backupfolder = GUICtrlRead($Input_Backup_Pfad)
	EndIf
	If GUICtrlRead($config_backupmode_combo) = _Get_langstr(426) Then
		_Write_in_Config("backupmode", "2")
		$backupmode = 2
		$Backupfolder = GUICtrlRead($Input_Backup_Pfad)
	EndIf


	If GUICtrlRead($Input_Projekte_Pfad) = "" Then GUICtrlSetData($Input_Projekte_Pfad, $Standardordner_Projects)
	$Projectfolder = GUICtrlRead($Input_Projekte_Pfad)
	_Write_in_Config("projectfolder", $Projectfolder)


	If GUICtrlRead($Einstellungen_Pfade_Pluginpfad_input) = "" Then GUICtrlSetData($Einstellungen_Pfade_Pluginpfad_input, $Standardordner_Plugins)
	$Pluginsdir = GUICtrlRead($Einstellungen_Pfade_Pluginpfad_input)
	_Write_in_Config("pluginsdir", $Pluginsdir)


	If GUICtrlRead($Input_template_Pfad) = "" Then GUICtrlSetData($Input_template_Pfad, $Standardordner_Templates)
	$templatefolder = GUICtrlRead($Input_template_Pfad)
	_Write_in_Config("templatefolder", $templatefolder)


	$i = GUICtrlRead($Input_backuptime)
	If $i = "" Then $i = "30"
	If $i = 0 Then $i = "30"
	_Write_in_Config("backuptime", $i)
	$backuptime = $i

	$i = GUICtrlRead($Input_deleteoldbackupsafter)
	If $i = "" Then $i = "30"
	If $i = 0 Then $i = "30"
	_Write_in_Config("deleteoldbackupsafter", $i)
	$deleteoldbackupsafter = $i

	If GUICtrlRead($Checkbox_lade_zuletzt_geoeffnete_Dateien) = $GUI_CHECKED Then
		$lade_zuletzt_geoeffnete_Dateien = "true"
		_Write_in_Config("restore_old_tabs", "true")
	Else
		$lade_zuletzt_geoeffnete_Dateien = "false"
		_Write_in_Config("restore_old_tabs", "false")
	EndIf

	If GUICtrlRead($Checkbox_enable_autoupdate) = $GUI_CHECKED Then
		$enable_autoupdate = "true"
		_Write_in_Config("enable_autoupdate", "true")
	Else
		$enable_autoupdate = "false"
		_Write_in_Config("enable_autoupdate", "false")
	EndIf


	If GUICtrlRead($programmeinstellungen_Darstellung_HighDPIMode_Checkbox) = $GUI_CHECKED Then
		If _Config_Read("highDPI_mode", "true") <> "true" Then $Require_Restart = 1
		_Write_in_Config("highDPI_mode", "true")
	Else
		If _Config_Read("highDPI_mode", "true") <> "false" Then $Require_Restart = 1
		_Write_in_Config("highDPI_mode", "false")
	EndIf

	If GUICtrlRead($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox) = $GUI_CHECKED Then
		If _Config_Read("enable_custom_dpi_value", "false") <> "true" Then $Require_Restart = 1
		_Write_in_Config("enable_custom_dpi_value", "true")
	Else
		If _Config_Read("enable_custom_dpi_value", "false") <> "false" Then $Require_Restart = 1
		_Write_in_Config("enable_custom_dpi_value", "false")
	EndIf


	If GUICtrlRead($settings_display_Move_Childs_with_Mainwindow_Checkbox) = $GUI_CHECKED Then
		If _Config_Read("ISN_move_windows_with_main_gui", "true") <> "true" Then $Require_Restart = 1
		_Write_in_Config("ISN_move_windows_with_main_gui", "true")
	Else
		If _Config_Read("ISN_move_windows_with_main_gui", "true") <> "false" Then $Require_Restart = 1
		_Write_in_Config("ISN_move_windows_with_main_gui", "false")
	EndIf


	If GUICtrlRead($settings_display_Gui_Size_Saving_No_Saving_Radio) = $GUI_CHECKED Then
		_Write_in_Config("ISN_save_window_position_mode", "0")
		$ISN_Save_Positions_mode = "0"
	EndIf

	If GUICtrlRead($settings_display_Gui_Size_Saving_Only_Mainwiondow_Radio) = $GUI_CHECKED Then
		_Write_in_Config("ISN_save_window_position_mode", "1")
		$ISN_Save_Positions_mode = "1"
	EndIf

	If GUICtrlRead($settings_display_Gui_Size_Saving_Save_All_Guis_Radio) = $GUI_CHECKED Then
		_Write_in_Config("ISN_save_window_position_mode", "2")
		$ISN_Save_Positions_mode = "2"
	EndIf

	If GUICtrlRead($Checkbox_fullscreenmode) = $GUI_CHECKED Then
		$fullscreenmode = "true"
		_Write_in_Config("fullscreenmode", "true")
	Else
		$fullscreenmode = "false"
		_Write_in_Config("fullscreenmode", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showfunctions) = $GUI_CHECKED Then
		$showfunctions = "true"
		_Write_in_Config("showfunctions", "true")
	Else
		$showfunctions = "false"
		_Write_in_Config("showfunctions", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_expandfunctions) = $GUI_CHECKED Then
		$expandfunctions = "true"
		_Write_in_Config("expandfunctions", "true")
	Else
		$expandfunctions = "false"
		_Write_in_Config("expandfunctions", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showglobalvariables) = $GUI_CHECKED Then
		$showglobalvariables = "true"
		_Write_in_Config("showglobalvariables", "true")
	Else
		$showglobalvariables = "false"
		_Write_in_Config("showglobalvariables", "false")
	EndIf




	If GUICtrlRead($Checkbox_contextmenu_au3files) = $GUI_CHECKED Then
		$registerinexplorer = "true"
		_Write_in_Config("registerinexplorer", "true")
	Else
		$registerinexplorer = "false"
		_Write_in_Config("registerinexplorer", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_expandglobalvariables) = $GUI_CHECKED Then
		$expandglobalvariables = "true"
		_Write_in_Config("expandglobalvariables", "true")
	Else
		$expandglobalvariables = "false"
		_Write_in_Config("expandglobalvariables", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_alphabetisch) = $GUI_CHECKED Then
		$Skriptbaum_Funcs_alphabetisch_sortieren = "true"
		_Write_in_Config("scripttree_sort_funcs_alphabetical", "true")
	Else
		$Skriptbaum_Funcs_alphabetisch_sortieren = "false"
		_Write_in_Config("scripttree_sort_funcs_alphabetical", "false")
	EndIf


	If GUICtrlRead($skriptbaum_config_checkbox_showlocalvariables) = $GUI_CHECKED Then
		$showlocalvariables = "true"
		_Write_in_Config("showlocalvariables", "true")
	Else
		$showlocalvariables = "false"
		_Write_in_Config("showlocalvariables", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_expandlocalvariables) = $GUI_CHECKED Then
		$expandlocalvariables = "true"
		_Write_in_Config("expandlocalvariables", "true")
	Else
		$expandlocalvariables = "false"
		_Write_in_Config("expandlocalvariables", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showincludes) = $GUI_CHECKED Then
		$showincludes = "true"
		_Write_in_Config("showincludes", "true")
	Else
		$showincludes = "false"
		_Write_in_Config("showincludes", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_expandincludes) = $GUI_CHECKED Then
		$expandincludes = "true"
		_Write_in_Config("expandincludes", "true")
	Else
		$expandincludes = "false"
		_Write_in_Config("expandincludes", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_bearbeitete_func_markieren) = $GUI_CHECKED Then
		$Bearbeitende_Function_im_skriptbaum_markieren = "true"
		_Write_in_Config("select_current_func_in_scripttree", "true")
	Else
		$Bearbeitende_Function_im_skriptbaum_markieren = "false"
		_Write_in_Config("select_current_func_in_scripttree", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode1_radio) = $GUI_CHECKED Then
		$Bearbeitende_Function_im_skriptbaum_markieren_Modus = "1"
		_Write_in_Config("select_current_func_in_scripttree_mode", "1")
	Else
		$Bearbeitende_Function_im_skriptbaum_markieren_Modus = "2"
		_Write_in_Config("select_current_func_in_scripttree_mode", "2")
	EndIf


	If GUICtrlRead($skriptbaum_config_checkbox_showforms) = $GUI_CHECKED Then
		$showforms = "true"
		_Write_in_Config("showforms", "true")
	Else
		$showforms = "false"
		_Write_in_Config("showforms", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_expandforms) = $GUI_CHECKED Then
		$expandforms = "true"
		_Write_in_Config("expandforms", "true")
	Else
		$expandforms = "false"
		_Write_in_Config("expandforms", "false")
	EndIf

	If GUICtrlRead($Checkbox_Settings_Auto_ParameterEditor) = $GUI_CHECKED Then
		$SkriptEditor_Doppelklick_ParameterEditor = "true"
		_Write_in_Config("scripteditor_doubleclickparametereditor", "true")
	Else
		$SkriptEditor_Doppelklick_ParameterEditor = "false"
		_Write_in_Config("scripteditor_doubleclickparametereditor", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showregions) = $GUI_CHECKED Then
		$showregions = "true"
		_Write_in_Config("showregions", "true")
	Else
		$showregions = "false"
		_Write_in_Config("showregions", "false")
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_expandregions) = $GUI_CHECKED Then
		$expandregions = "true"
		_Write_in_Config("expandregions", "true")
	Else
		$expandregions = "false"
		_Write_in_Config("expandregions", "false")
	EndIf

	If GUICtrlRead($Checkbox_disabletrophys) = $GUI_UNCHECKED Then
		$allow_trophys = "false"
		_Write_in_Config("trophys", "false")
	Else
		$allow_trophys = "true"
		_Write_in_Config("trophys", "true")
	EndIf

	If GUICtrlRead($Checkbox_Settings_AutoEndIf_Checkbox) = $GUI_CHECKED Then
		$AutoEnd_Keywords = "true"
		_Write_in_Config("autoend_keywords", "true")

	Else
		$AutoEnd_Keywords = "false"
		_Write_in_Config("autoend_keywords", "false")
	EndIf


	If GUICtrlRead($Checkbox_Settings_Deklarationen_Auto_Dollar_Checkbox) = $GUI_CHECKED Then
		$Auto_dollar_for_declarations = "true"
		_Write_in_Config("auto_dollar_for_declarations", "true")

	Else
		$Auto_dollar_for_declarations = "false"
		_Write_in_Config("auto_dollar_for_declarations", "false")
	EndIf


	If GUICtrlRead($Checkbox_scripteditor_debug_show_buttons_checkbox) = $GUI_CHECKED Then
		$Zeige_Buttons_neben_Debug_Fenster = "true"
		_Write_in_Config("debugbuttons", "true")
	Else
		$Zeige_Buttons_neben_Debug_Fenster = "false"
		_Write_in_Config("debugbuttons", "false")
	EndIf


	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Aktiv = "true"
		_Write_in_Config("auto_save_enabled", "true")
	Else
		$Automatische_Speicherung_Aktiv = "false"
		_Write_in_Config("auto_save_enabled", "false")
	EndIf

	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Nur_Skript_Tabs_Sichern = "true"
		_Write_in_Config("auto_save_only_script_tabs", "true")
	Else
		$Automatische_Speicherung_Nur_Skript_Tabs_Sichern = "false"
		_Write_in_Config("auto_save_only_script_tabs", "false")
	EndIf

	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Nur_aktuellen_Tabs_Sichern = "true"
		_Write_in_Config("auto_save_only_current_tab", "true")
	Else
		$Automatische_Speicherung_Nur_aktuellen_Tabs_Sichern = "false"
		_Write_in_Config("auto_save_only_current_tab", "false")
	EndIf

	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Eingabe_Nur_einmal_sichern = "true"
		_Write_in_Config("auto_save_once_mode", "true")
	Else
		$Automatische_Speicherung_Eingabe_Nur_einmal_sichern = "false"
		_Write_in_Config("auto_save_once_mode", "false")
	EndIf

	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_Radio) = $GUI_CHECKED Then
		$Automatische_Speicherung_Modus = "1"
		_Write_in_Config("auto_save_mode", "1")
	Else
		$Automatische_Speicherung_Modus = "2"
		_Write_in_Config("auto_save_mode", "2")
	EndIf


	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) < 0 Or GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) = "" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, 0)
	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) < 0 Or GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) = "" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, 0)
	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) < 0 Or GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) = "" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, 0)
	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) = "0" And GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) = "0" And GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) = "0" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, "5")

	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) = "0" And GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) = "0" Then
		If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) < 30 Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, "30")
	EndIf

	Local $autoupdate_time_h = 0
	Local $autoupdate_time_m = 0
	Local $autoupdate_time_s = 0

	_TicksToTime(_TimeToTicks(GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input), GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input), GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input)), $autoupdate_time_h, $autoupdate_time_m, $autoupdate_time_s)

	$Automatische_Speicherung_Timer_Sekunden = $autoupdate_time_s
	_Write_in_Config("auto_save_timer_secounds", $autoupdate_time_s)

	$Automatische_Speicherung_Timer_Minuten = $autoupdate_time_m
	_Write_in_Config("auto_save_timer_minutes", $autoupdate_time_m)

	$Automatische_Speicherung_Timer_Stunden = $autoupdate_time_h
	_Write_in_Config("auto_save_timer_hours", $autoupdate_time_h)





	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input) < 0 Or GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input) = "" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, 0)
	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input) < 0 Or GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input) = "" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, 0)
	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input) < 0 Or GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input) = "" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, 0)
	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input) = "0" And GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input) = "0" And GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input) = "0" Then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, "1")

	$autoupdate_time_h = 0
	$autoupdate_time_m = 0
	$autoupdate_time_s = 0

	_TicksToTime(_TimeToTicks(GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input), GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input), GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input)), $autoupdate_time_h, $autoupdate_time_m, $autoupdate_time_s)

	$Automatische_Speicherung_Eingabe_Sekunden = $autoupdate_time_s
	_Write_in_Config("auto_save_input_secounds", $autoupdate_time_s)

	$Automatische_Speicherung_Eingabe_Minuten = $autoupdate_time_m
	_Write_in_Config("auto_save_input_minutes", $autoupdate_time_m)

	$Automatische_Speicherung_Eingabe_Stunden = $autoupdate_time_h
	_Write_in_Config("auto_save_input_hours", $autoupdate_time_h)











	If GUICtrlRead($Checkbox_protect_files_from_external_modification) = $GUI_CHECKED Then
		$protect_files_from_external_modification = "true"
		_Write_in_Config("protect_files_from_external_modification", "true")
	Else
		$protect_files_from_external_modification = "false"
		_Write_in_Config("protect_files_from_external_modification", "false")
	EndIf

	If GUICtrlRead($Checkbox_verwende_intelimark) = $GUI_CHECKED Then
		$verwende_intelimark = "true"
		_Write_in_Config("enable_intelimark", "true")
	Else
		$verwende_intelimark = "false"
		_Write_in_Config("enable_intelimark", "false")
	EndIf

	If GUICtrlRead($Config_Scripteditor_Intelimark_AdditionalMarkers_Checkbox) = $GUI_CHECKED Then
		$intelimark_also_mark_line = "true"
		_Write_in_Config("intelimark_also_mark_line", "true")
	Else
		$intelimark_also_mark_line = "false"
		_Write_in_Config("intelimark_also_mark_line", "false")
	EndIf

	If GUICtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then
		$hintergrundfarbe_fuer_alle_uebernehmen = "true"
		_Write_in_Config("scripteditor_backgroundcolour_forall", "true")
	Else
		$hintergrundfarbe_fuer_alle_uebernehmen = "false"
		_Write_in_Config("scripteditor_backgroundcolour_forall", "false")
	EndIf

	If GUICtrlRead($_Immer_am_primaeren_monitor_starten_checkbox) = $GUI_CHECKED Then
		$Immer_am_primaeren_monitor_starten = "true"
		If _Config_Read("run_always_on_primary_screen", "true") <> $Immer_am_primaeren_monitor_starten Then
			$Require_Restart = 1
			$MonitorSettings_Changed = 1
		EndIf
		_Write_in_Config("run_always_on_primary_screen", "true")
	Else
		$Immer_am_primaeren_monitor_starten = "false"
		If _Config_Read("run_always_on_primary_screen", "true") <> $Immer_am_primaeren_monitor_starten Then
			$Require_Restart = 1
			$MonitorSettings_Changed = 1
		EndIf
		_Write_in_Config("run_always_on_primary_screen", "false")
	EndIf

	If GUICtrlRead($Checkbox_AskExit) = $GUI_CHECKED Then
		$AskExit = "true"
		_Write_in_Config("askexit", "true")
	Else
		$AskExit = "false"
		_Write_in_Config("askexit", "false")
	EndIf

	If GUICtrlRead($Einstellungen_AutoItIncludes_Verwalten_Checkbox) = $GUI_CHECKED Then
		$Zusaetzliche_Include_Pfade_ueber_ISN_verwalten = "true"
		_Write_in_Config("manage_additional_includes_with_ISN", "true")
	Else
		$Zusaetzliche_Include_Pfade_ueber_ISN_verwalten = "false"
		_Write_in_Config("manage_additional_includes_with_ISN", "false")
	EndIf

	If GUICtrlRead($Checkbox_Load_Automatic) = $GUI_CHECKED Then
		$Autoload = "true"
		_Write_in_Config("autoload", "true")
	Else
		$Autoload = "false"
		_Write_in_Config("autoload", "false")
	EndIf

	If GUICtrlRead($Checkbox_projekte_im_projektbaum) = $GUI_CHECKED Then
		$AutoIt_Projekte_in_Projektbaum_anzeigen = "true"
		_Write_in_Config("show_projects_in_projecttree", "true")
	Else
		$AutoIt_Projekte_in_Projektbaum_anzeigen = "false"
		_Write_in_Config("show_projects_in_projecttree", "false")
	EndIf

	If GUICtrlRead($Einstellungen_Skripteditor_Dateitypen_automatisch_radio) = $GUI_CHECKED Then
		$Skript_Editor_Automatische_Dateitypen = "true"
		_Write_in_Config("scripteditor_auto_manage_filetypes", "true")
	Else
		$Skript_Editor_Automatische_Dateitypen = "false"
		_Write_in_Config("scripteditor_auto_manage_filetypes", "false")
		_Write_in_Config("scripteditor_filetypes", _Einstellungen_Skript_Editor_Dateitypen_String_aus_Listview_Laden())
		$Skript_Editor_Dateitypen_Liste = _Einstellungen_Skript_Editor_Dateitypen_String_aus_Listview_Laden()
	EndIf

	If $Autoload = "true" Then
		GUICtrlSetState($Willkommen_autoloadcheckbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Willkommen_autoloadcheckbox, $GUI_UNCHECKED)
	EndIf

	If GUICtrlRead($Checkbox_enablelogo) = $GUI_CHECKED Then
		$enablelogo = "true"
		_Write_in_Config("enablelogo", "true")
	Else
		$enablelogo = "false"
		_Write_in_Config("enablelogo", "false")
	EndIf

	If GUICtrlRead($Checkbox_autoloadmainfile) = $GUI_CHECKED Then
		$autoloadmainfile = "true"
		_Write_in_Config("autoloadmainfile", "true")
	Else
		$autoloadmainfile = "false"
		_Write_in_Config("autoloadmainfile", "false")
	EndIf

	If GUICtrlRead($Checkbox_registerisnfiles) = $GUI_CHECKED Then
		$registerisnfiles = "true"
		_Write_in_Config("registerisnfiles", "true")
	Else
		$registerisnfiles = "false"
		_Write_in_Config("registerisnfiles", "false")
	EndIf

	If GUICtrlRead($Checkbox_registerispfiles) = $GUI_CHECKED Then
		$registerispfiles = "true"
		_Write_in_Config("registerispfiles", "true")
	Else
		$registerispfiles = "false"
		_Write_in_Config("registerispfiles", "false")
	EndIf

	If GUICtrlRead($Checkbox_registericpfiles) = $GUI_CHECKED Then
		$registericpfiles = "true"
		_Write_in_Config("registericpfiles", "true")
	Else
		$registericpfiles = "false"
		_Write_in_Config("registericpfiles", "false")
	EndIf

	If GUICtrlRead($Checkbox_registerau3files) = $GUI_CHECKED Then
		$registerau3files = "true"
		_Write_in_Config("registerau3files", "true")
	Else
		$registerau3files = "false"
		_Write_in_Config("registerau3files", "false")
	EndIf

	$Pfad_zur_TidyINI = GUICtrlRead($einstellungen_tidy_ini_pfad)
	_Write_in_Config("tidy_ini_path", GUICtrlRead($einstellungen_tidy_ini_pfad))


	If GUICtrlRead($einstellungen_tidy_ueberdasISNverwalten) = $GUI_CHECKED Then
		$Verwalte_Tidyeinstellungen_mit_dem_ISN = "true"
		_Write_in_Config("useisntoconfigtidy", "true")
	Else
		$Verwalte_Tidyeinstellungen_mit_dem_ISN = "false"
		_Write_in_Config("useisntoconfigtidy", "false")
	EndIf

	If GUICtrlRead($Checkbox_hideprogramlog) = $GUI_UNCHECKED Then
		$hideprogramlog = "true"
		_Write_in_Config("hideprogramlog", "true")
		GUICtrlSetPos($Left_Splitter_Y, 2, $size1[1] - 26, 200, 5)
		GUICtrlSetState($Left_Splitter_Y, $GUI_HIDE)
		GUICtrlSetState($QuickView_title, $GUI_HIDE)
		GUISetState(@SW_HIDE, $QuickView_GUI)
	Else
		$hideprogramlog = "false"
		_Write_in_Config("hideprogramlog", "false")
		If $Toggle_Leftside = 0 Then
			GUICtrlSetState($Programm_log, $GUI_SHOW)
			GUICtrlSetState($Left_Splitter_Y, $GUI_SHOW)
			GUICtrlSetState($QuickView_title, $GUI_SHOW)
			GUISetState(@SW_SHOW, $QuickView_GUI)
		EndIf
		GUICtrlSetPos($Left_Splitter_Y, 2, ($size1[1] / 100) * Number(_Config_Read("Left_Splitter_Y", $Linker_Splitter_Y_default)))
	EndIf

	If GUICtrlRead($Checkbox_hidefunctionstree) = $GUI_UNCHECKED Then
		$hidefunctionstree = "true"
		_Write_in_Config("hidefunctionstree", "true")
		;guictrlsetpos($VSplitter_2,$size[2]-5, 25, 4, $size[3]-80)
	Else
		$hidefunctionstree = "false"
		_Write_in_Config("hidefunctionstree", "false")
	EndIf

	If GUICtrlRead($Checkbox_hidedebug) = $GUI_UNCHECKED Then
		$hidedebug = "true"
		_Write_in_Config("hidedebug", "true")
		GUICtrlSetPos($Middle_Splitter_Y, 268, $size1[1] - 20, 200, 4)
	Else
		$hidedebug = "false"
		_Write_in_Config("hidedebug", "false")
		GUICtrlSetPos($Middle_Splitter_Y, Default, ($size1[1] / 100) * Number(_Config_Read("Middle_Splitter_Y", $Mittlerer_Splitter_Y_default)))
	EndIf

	If GUICtrlRead($Einstellungen_skripteditor_Zeichensatz_default) = $GUI_CHECKED Then
		If $autoit_editor_encoding <> "1" Then $Require_Restart = 1
		$autoit_editor_encoding = "1"
		_Write_in_Config("autoit_editor_encoding", "1")
	EndIf

	If GUICtrlRead($Einstellungen_skripteditor_Zeichensatz_UTF8) = $GUI_CHECKED Then
		If $autoit_editor_encoding <> "2" Then $Require_Restart = 1
		$autoit_editor_encoding = "2"
		_Write_in_Config("autoit_editor_encoding", "2")
	EndIf

	If GUICtrlRead($Checkbox_globalautocomplete) = $GUI_CHECKED Then
		$globalautocomplete = "true"
		_Write_in_Config("globalautocomplete", "true")
	Else
		$globalautocomplete = "false"
		_Write_in_Config("globalautocomplete", "false")
	EndIf

	If GUICtrlRead($Checkbox_Programmpfade_automatisch_erkennen) = $GUI_CHECKED Then
		$Pfade_bei_Programmstart_automatisch_suchen = "true"
		_Write_in_Config("search_au3paths_on_startup", "true")
	Else
		$Pfade_bei_Programmstart_automatisch_suchen = "false"
		_Write_in_Config("search_au3paths_on_startup", "false")
	EndIf

	If GUICtrlRead($Checkbox_globalautocomplete_current_script) = $GUI_CHECKED Then
		$globalautocomplete_current_script = "true"
		_Write_in_Config("globalautocomplete_current_script", "true")
	Else
		$globalautocomplete_current_script = "false"
		_Write_in_Config("globalautocomplete_current_script", "false")
	EndIf

	If GUICtrlRead($globalautocomplete_variables_return_only_global_checkbox) = $GUI_CHECKED Then
		$globalautocomplete_variables_return_only_global = "true"
		_Write_in_Config("globalautocomplete_variables_return_only_global", "true")
	Else
		$globalautocomplete_variables_return_only_global = "false"
		_Write_in_Config("globalautocomplete_variables_return_only_global", "false")
	EndIf

	If GUICtrlRead($Checkbox_disableautocomplete) = $GUI_UNCHECKED Then
		$disableautocomplete = "true"
		_Write_in_Config("disableautocomplete", "true")
	Else
		$disableautocomplete = "false"
		_Write_in_Config("disableautocomplete", "false")
	EndIf

	If GUICtrlRead($Autocomplete_ab_zweitem_zeichen_checkbox) = $GUI_CHECKED Then
		$Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = "true"
		_Write_in_Config("autocomplete_udf_require_two_chars", "true")
	Else
		$Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = "false"
		_Write_in_Config("autocomplete_udf_require_two_chars", "false")
	EndIf

	If GUICtrlRead($Autocomplete_allow_complete_with_tabkey_checkbox) = $GUI_CHECKED Then
		$allow_autocomplete_with_tabkey = "true"
		_Write_in_Config("autocomplete_with_tab", "true")
	Else
		$allow_autocomplete_with_tabkey = "false"
		_Write_in_Config("autocomplete_with_tab", "false")
	EndIf

	If GUICtrlRead($Autocomplete_allow_complete_with_spacekey_checkbox) = $GUI_CHECKED Then
		$allow_autocomplete_with_spacekey = "true"
		_Write_in_Config("autocomplete_with_space", "true")
	Else
		$allow_autocomplete_with_spacekey = "false"
		_Write_in_Config("autocomplete_with_space", "false")
	EndIf

	If GUICtrlRead($ScriptEditor_UseAutoFormat_Correction_checkbox) = $GUI_CHECKED Then
		$ScriptEditor_UseAutoFormat_Correction = "true"
		_Write_in_Config("scripteditor_autoformat_correction", "true")
	Else
		$ScriptEditor_UseAutoFormat_Correction = "false"
		_Write_in_Config("scripteditor_autoformat_correction", "false")
	EndIf


	If GUICtrlRead($ScriptEditor_Autocomplete_Brackets_Checkbox) = $GUI_CHECKED Then
		$ScriptEditor_Autocomplete_Brackets = "true"
		_Write_in_Config("autocomplete_brackets", "true")
	Else
		$ScriptEditor_Autocomplete_Brackets = "false"
		_Write_in_Config("autocomplete_brackets", "false")
	EndIf

	If GUICtrlRead($ScriptEditor_highlight_brackets_checkbox) = $GUI_CHECKED Then
		$ScriptEditor_highlight_brackets = "true"
		_Write_in_Config("scripteditor_highlight_brackets", "true")
	Else
		$ScriptEditor_highlight_brackets = "false"
		_Write_in_Config("scripteditor_highlight_brackets", "false")
	EndIf

	If GUICtrlRead($checkbox_run_scripts_with_au3wrapper) = $GUI_CHECKED Then
		$starte_Skripts_mit_au3Wrapper = "true"
		_Write_in_Config("run_scripts_with_au3wrapper", "true")
	Else
		$starte_Skripts_mit_au3Wrapper = "false"
		_Write_in_Config("run_scripts_with_au3wrapper", "false")
	EndIf

	If GUICtrlRead($Checkbox_disableintelisense) = $GUI_UNCHECKED Then
		$disableintelisense = "true"
		_Write_in_Config("disableintelisense", "true")
	Else
		$disableintelisense = "false"
		_Write_in_Config("disableintelisense", "false")
	EndIf

	If GUICtrlRead($Checkbox_showlines) = $GUI_CHECKED Then
		$showlines = "true"
		_Write_in_Config("showlines", "true")
	Else
		$showlines = "false"
		_Write_in_Config("showlines", "false")
	EndIf

	If GUICtrlRead($settings_scripteditor_fold_margin_checkbox) = $GUI_CHECKED Then
		$scripteditor_fold_margin = "true"
		_Write_in_Config("scripteditor_fold_margin", "true")
	Else
		$scripteditor_fold_margin = "false"
		_Write_in_Config("scripteditor_fold_margin", "false")
	EndIf

	If GUICtrlRead($settings_scripteditor_bookmark_margin_checkbox) = $GUI_CHECKED Then
		$scripteditor_bookmark_margin = "true"
		_Write_in_Config("scripteditor_bookmark_margin", "true")
	Else
		$scripteditor_bookmark_margin = "false"
		_Write_in_Config("scripteditor_bookmark_margin", "false")
	EndIf

	If GUICtrlRead($settings_scripteditor_display_whitespace_checkbox) = $GUI_CHECKED Then
		$scripteditor_display_whitespace = "true"
		_Write_in_Config("scripteditor_display_whitespace", "true")
	Else
		$scripteditor_display_whitespace = "false"
		_Write_in_Config("scripteditor_display_whitespace", "false")
	EndIf

	If GUICtrlRead($settings_scripteditor_display_endofline_checkbox) = $GUI_CHECKED Then
		$scripteditor_display_endofline = "true"
		_Write_in_Config("scripteditor_display_end_of_line", "true")
	Else
		$scripteditor_display_endofline = "false"
		_Write_in_Config("scripteditor_display_end_of_line", "false")
	EndIf

	If GUICtrlRead($settings_scripteditor_display_indentationguides_checkbox) = $GUI_CHECKED Then
		$scripteditor_display_indentationguides = "true"
		_Write_in_Config("scripteditor_display_indentation_guides", "true")
	Else
		$scripteditor_display_indentationguides = "false"
		_Write_in_Config("scripteditor_display_indentation_guides", "false")
	EndIf

	If GUICtrlRead($Checkbox_loadcontrols) = $GUI_CHECKED Then
		$loadcontrols = "true"
		_Write_in_Config("loadcontrols", "true")
	Else
		$loadcontrols = "false"
		_Write_in_Config("loadcontrols", "false")
	EndIf

	If GUICtrlRead($settings_scripteditor_bracketpairs_checkbox) = $GUI_CHECKED Then
		$Scripteditor_AllowBracketpairs = "true"
		_Write_in_Config("scripteditor_allow_selection_bracketpairs", "true")
	Else
		$Scripteditor_AllowBracketpairs = "false"
		_Write_in_Config("scripteditor_allow_selection_bracketpairs", "false")
	EndIf

	If GUICtrlRead($settings_scripteditor_multicursor_checkbox) = $GUI_CHECKED Then
		$Scripteditor_EnableMultiCursor = "true"
		_Write_in_Config("scripteditor_enable_multicursor", "true")
	Else
		$Scripteditor_EnableMultiCursor = "false"
		_Write_in_Config("scripteditor_enable_multicursor", "false")
	EndIf

	If GUICtrlRead($Checkbox_allowcommentout) = $GUI_CHECKED Then
		$allowcommentout = "true"
		If _Config_Read("allowcommentout", "true") <> $allowcommentout Then $Require_Restart = 1
		_Write_in_Config("allowcommentout", "true")
	Else
		$allowcommentout = "false"
		If _Config_Read("allowcommentout", "true") <> $allowcommentout Then $Require_Restart = 1
		_Write_in_Config("allowcommentout", "false")
	EndIf

	If GUICtrlRead($Checkbox_enablebackup) = $GUI_CHECKED Then
		$enablebackup = "true"
		_Write_in_Config("enablebackup", "true")
		AdlibUnRegister("_Backup_Files")
		AdlibRegister("_Backup_Files", $backuptime * 60000)
	Else
		$enablebackup = "false"
		_Write_in_Config("enablebackup", "false")
		AdlibUnRegister("_Backup_Files")
	EndIf

	If GUICtrlRead($Checkbox_enabledeleteoldbackups) = $GUI_CHECKED Then
		$enabledeleteoldbackups = "true"
		_Write_in_Config("enabledeleteoldbackups", "true")
	Else
		$enabledeleteoldbackups = "false"
		_Write_in_Config("enabledeleteoldbackups", "false")
	EndIf

	If GUICtrlRead($Checkbox_disabledebuggui) = $GUI_CHECKED Then
		$showdebuggui = "true"
		_Write_in_Config("showdebuggui", "true")
	Else
		$showdebuggui = "false"
		_Write_in_Config("showdebuggui", "false")
	EndIf

	If GUICtrlRead($proxy_enable_checkbox) = $GUI_CHECKED Then
		$Use_Proxy = "true"
		_Write_in_Config("Use_Proxy", "true")
	Else
		$Use_Proxy = "false"
		_Write_in_Config("Use_Proxy", "false")
	EndIf

	If GUICtrlRead($Checkbox_savefolding) = $GUI_CHECKED Then
		$savefolding = "true"
		_Write_in_Config("savefolding", "true")
	Else
		$savefolding = "false"
		_Write_in_Config("savefolding", "false")
	EndIf

	If GUICtrlRead($settings_toolbar_display_vertical_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("isn_vertical_toolbar", "true")
		If _Config_Read("isn_vertical_toolbar", "false") <> $ISN_Use_Vertical_Toolbar Then $Require_Restart = 1
	Else
		_Write_in_Config("isn_vertical_toolbar", "false")
		If _Config_Read("isn_vertical_toolbar", "false") <> $ISN_Use_Vertical_Toolbar Then $Require_Restart = 1
	EndIf

	If GUICtrlRead($setting_tools_bitoperation_enabled_checkbox) = $GUI_CHECKED Then
		$Tools_Bitrechner_aktiviert = "true"
		If _Config_Read("tools_Bitoperation_tester_enabled", "true") <> $Tools_Bitrechner_aktiviert Then $Require_Restart = 1
		_Write_in_Config("tools_Bitoperation_tester_enabled", "true")
	Else
		$Tools_Bitrechner_aktiviert = "false"
		If _Config_Read("tools_Bitoperation_tester_enabled", "true") <> $Tools_Bitrechner_aktiviert Then $Require_Restart = 1
		_Write_in_Config("tools_Bitoperation_tester_enabled", "false")
	EndIf


	If GUICtrlRead($setting_tools_parametereditor_enabled_checkbox) = $GUI_CHECKED Then
		$Tools_Parameter_Editor_aktiviert = "true"
		If _Config_Read("tools_parameter_editor_enabled", "true") <> $Tools_Parameter_Editor_aktiviert Then $Require_Restart = 1
		_Write_in_Config("tools_parameter_editor_enabled", "true")
	Else
		$Tools_Parameter_Editor_aktiviert = "false"
		If _Config_Read("tools_parameter_editor_enabled", "true") <> $Tools_Parameter_Editor_aktiviert Then $Require_Restart = 1
		_Write_in_Config("tools_parameter_editor_enabled", "false")
	EndIf

	If GUICtrlRead($setting_tools_obfuscator_enabled_checkbox) = $GUI_CHECKED Then
		$Tools_PELock_Obfuscator_aktiviert = "true"
		If _Config_Read("tools_pelock_obfuscator_enabled", "true") <> $Tools_PELock_Obfuscator_aktiviert Then $Require_Restart = 1
		_Write_in_Config("tools_pelock_obfuscator_enabled", "true")
	Else
		$Tools_PELock_Obfuscator_aktiviert = "false"
		If _Config_Read("tools_pelock_obfuscator_enabled", "true") <> $Tools_PELock_Obfuscator_aktiviert Then $Require_Restart = 1
		_Write_in_Config("tools_pelock_obfuscator_enabled", "false")
	EndIf


	If GUICtrlRead($Checkbox_use_new_colours) = $GUI_CHECKED Then
		$use_new_au3_colours = "true"
		_Write_in_Config("use_new_au3_colours", "true")
	Else
		$use_new_au3_colours = "false"
		_Write_in_Config("use_new_au3_colours", "false")
	EndIf

	;DPI
	If _Config_Read("custom_dpi_value", Number(_Config_Read("custom_dpi_value", 1))) <> GUICtrlRead($programmeinstellungen_DPI_Slider) / 100 Then $Require_Restart = 1
	_Write_in_Config("custom_dpi_value", GUICtrlRead($programmeinstellungen_DPI_Slider) / 100)


	GUICtrlSetFont($hTreeview, $treefont_size, 400, 0, $treefont_font)
	GUICtrlSetColor($hTreeview, $treefont_colour)
	GUICtrlSetFont($hTreeview2, $treefont_size, 400, 0, $treefont_font)
	GUICtrlSetColor($hTreeview2, $treefont_colour)

	AdlibUnRegister("_ISN_Automatische_Speicherung_starten")
	AdlibUnRegister("_ISN_Automatische_Speicherung_Sekundenevent")


	If $Automatische_Speicherung_Aktiv = "true" Then
		$Automatische_Speicherung_eingabecounter = 0
		If $Automatische_Speicherung_Modus = "1" Then
			AdlibRegister("_ISN_Automatische_Speicherung_starten", _TimeToTicks($Automatische_Speicherung_Timer_Stunden, $Automatische_Speicherung_Timer_Minuten, $Automatische_Speicherung_Timer_Sekunden))
		Else
			AdlibRegister("_ISN_Automatische_Speicherung_Sekundenevent", 1000)
		EndIf
	EndIf


	Switch GUICtrlRead($programmeinstellungen_makrosicherheit_slider)

		Case 0
			$Makrosicherheitslevel = "4"
			_Write_in_Config("macro_security_level", "4")

		Case 1
			$Makrosicherheitslevel = "3"
			_Write_in_Config("macro_security_level", "3")

		Case 2
			$Makrosicherheitslevel = "2"
			_Write_in_Config("macro_security_level", "2")

		Case 3
			$Makrosicherheitslevel = "1"
			_Write_in_Config("macro_security_level", "1")

		Case 4
			$Makrosicherheitslevel = "0"
			_Write_in_Config("macro_security_level", "0")
	EndSwitch

	If $MonitorSettings_Changed = 1 Then
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(1403), 0, $Config_GUI)
		$Allow_Gui_Size_Saving = 0
		IniDelete($Configfile, "positions")
	EndIf



;~ 	$Languagefile = $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1]
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($hTab)] = -1 Then _HIDE_FENSTER_RECHTS($hidefunctionstree)
	EndIf

	_Speichere_Farbeinstellungen()
	_Refresh_ViewSettings_for_Scintilla_Controls(1)
	_API_Pfade_abspeichern()
	_Speichere_Weitere_Includes_in_Config()
	_Pfade_fuer_Weitere_Includes_in_Registrierung_uebernehmen()
	_Einstellungen_Toolbar_Layoutstring_generieren_und_abspeichern()
	If $Offenes_Projekt <> "" Then _Reload_Ruleslots()
	_Skripteditor_APIs_und_properties_neu_einlesen()
	_Neue_APIs_und_properties_an_Scintilla_controls_senden()
	_Set_Proxyserver()
	_Aktualisiere_Splittercontrols()
	_Aktualisiere_Texte_in_Contextmenues_wegen_Hotkeys()
	_Toggle_autocompletefields()
	_Toolbar_nach_layout_anordnen()
	_Tidy_Einstellungen_speichern()
	_ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Scripttree][$ISN_Helper_Handle], "_Scripttree_refresh_ISN_settings") ;Scripttree settings refresh
	If $Offenes_Projekt <> "" Then _Reload_Ruleslots()
	_Load_Plugins()
	_ISN_aktualisiere_Hotkeys()
	_Seach_Labels_Set_Code_Style()
	_Settings_QuickView_SaveAndGenerate_Layoutstring()
	_Check_Buttons(0)
	_Write_log(_Get_langstr(214), "000000", "true")
	_ISN_Register_Filetypes()
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_HIDE, $Einstellungen_werden_gespeichert_GUI)
	If $Require_Restart = 1 Then
		$restart_msg = MsgBox(262144 + 64 + 4, _Get_langstr(61), _Get_langstr(204) & @CRLF & @CRLF & _Get_langstr(1355), 0, $Config_GUI)
		If $restart_msg = 6 Then
			GUISetState(@SW_HIDE, $Config_GUI)
			_Restart_ISN_AutoIt_Studio()
			Return
		EndIf
	EndIf
	_HIDE_Configgui()
EndFunc   ;==>_Save_Settings

Func _set_runbevore_none()
	GUICtrlSetData($config_inputstartbefore, "")
EndFunc   ;==>_set_runbevore_none

Func _set_runafter_none()
	GUICtrlSetData($config_inputstartafter, "")
EndFunc   ;==>_set_runafter_none

Func _select_runbefore()
	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(259), @ScriptDir, "All (*.exe)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $Config_GUI)
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ScriptDir, "All (*.exe)", 1 + 2, "", $Config_GUI)
	EndIf
	If @error Then Return
	GUICtrlSetData($config_inputstartbefore, $var)
EndFunc   ;==>_select_runbefore

Func _select_runafter()
	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(259), @ScriptDir, "All (*.exe)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $Config_GUI)
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ScriptDir, "All (*.exe)", 1 + 2, "", $Config_GUI)
	EndIf
	If @error Then Return
	GUICtrlSetData($config_inputstartafter, $var)
EndFunc   ;==>_select_runafter

Func _select_releasemode()
	;release pfad
	If GUICtrlRead($config_fertigeprojecte_dropdown) = _Get_langstr(413) Then
		GUICtrlSetState($Input_Release_points, $GUI_ENABLE)
		GUICtrlSetData($config_fertigeprojectelabel, _Get_langstr(129))
		GUICtrlSetData($Input_Release_Pfad, $Standardordner_Release)
	EndIf

	;release unterordner
	If GUICtrlRead($config_fertigeprojecte_dropdown) = _Get_langstr(414) Then
		GUICtrlSetData($config_fertigeprojectelabel, _Get_langstr(415))
		GUICtrlSetData($Input_Release_Pfad, "Release")
		GUICtrlSetState($Input_Release_points, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_select_releasemode

Func _select_backupmode()
	;backup pfad
	If GUICtrlRead($config_backupmode_combo) = _Get_langstr(425) Then
		GUICtrlSetState($config_baackupmodegivefolder, $GUI_ENABLE)
		GUICtrlSetData($Input_Backup_Pfad, $Standardordner_Backups)
		GUICtrlSetData($config_backupmode_label, _Get_langstr(128))
	EndIf

	;backup unterordner
	If GUICtrlRead($config_backupmode_combo) = _Get_langstr(426) Then
		GUICtrlSetData($config_backupmode_label, _Get_langstr(415))
		GUICtrlSetData($Input_Backup_Pfad, "Backup")
		GUICtrlSetState($config_baackupmodegivefolder, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_select_backupmode

Func _restore_default_release()
	GUICtrlSetData($Input_Release_Pfad, $Standardordner_Release)
	GUICtrlSetData($config_fertigeprojecte_dropdown, "")
	GUICtrlSetData($config_fertigeprojecte_dropdown, _Get_langstr(413) & "|" & _Get_langstr(414), _Get_langstr(413))
	_select_releasemode()
EndFunc   ;==>_restore_default_release

Func _restore_default_backup()
	GUICtrlSetData($Einstellungen_Backup_Ordnerstruktur_input, "%projectname%\%mday%.%mon%.%year%\%hour%h %min%m")
	GUICtrlSetData($Input_deleteoldbackupsafter, "30")
	GUICtrlSetData($Input_backuptime, "30")
	GUICtrlSetData($Input_Backup_Pfad, $Standardordner_backups)
	GUICtrlSetData($config_backupmode_combo, "")
	GUICtrlSetData($config_backupmode_combo, _Get_langstr(425) & "|" & _Get_langstr(426), _Get_langstr(425))
	_select_backupmode()
EndFunc   ;==>_restore_default_backup



Func _Show_Studio_Debug()

	If _Config_Read("showdebugconsole", "false") = "true" Then
		GUICtrlSetState($ISNSTudio_debug_console_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($ISNSTudio_debug_console_checkbox, $GUI_UNCHECKED)
	EndIf



	GUICtrlSetData($ISNSTudio_debug_edit, "")

	$Data = ""
	$Data = _Get_langstr(1) & " - " & _Get_langstr(306) & @CRLF
	$Data = $Data & "----------------------------------" & @CRLF


	$Data = $Data & @CRLF & " - SYSTEM -" & @CRLF
	$Data = $Data & "----------------" & @CRLF
	$Data = $Data & "OS:" & @TAB & @TAB & @OSVersion & " " & @OSServicePack & " (" & @OSArch & ")" & @CRLF
	$mem = MemGetStats()
	$Data = $Data & "RAM:" & @TAB & @TAB & Round($mem[1] / 1024, 2) & " MB" & @CRLF
	$Data = $Data & "WinAPI version:" & @TAB & _WinAPI_GetVersion() & @CRLF
	$Data = $Data & "OS LCID:" & @TAB & @TAB & _WinAPI_GetSystemDefaultLCID() & @CRLF
	$Data = $Data & "Run on monitor:" & @TAB & $Runonmonitor & " (Detected: " & $__MonitorList[0][0] & ")" & @CRLF
	$Data = $Data & "Run from drive:" & @TAB & StringTrimRight(@AutoItExe, StringLen(@AutoItExe) - StringInStr(@AutoItExe, "\")) & @CRLF
	If StringInStr(FileGetAttrib(StringTrimRight(@AutoItExe, StringLen(@AutoItExe) - StringInStr(@AutoItExe, "\"))), "C") Then
		$ex = "Yes -> ISN cannot be used on compressed drives!!!"
	Else
		$ex = "No"
	EndIf
	$Data = $Data & " |-> compressed:" & @TAB & $ex & @CRLF


	$Data = $Data & @CRLF & " - ISN AUTOIT STUDIO GENERAL -" & @CRLF
	$Data = $Data & "----------------" & @CRLF
	$Data = $Data & "Studio version:" & @TAB & "Version " & $Studioversion & " " & $ERSTELLUNGSTAG & @CRLF
	$Data = $Data & "Executable path:" & @TAB & @AutoItExe & " (PID " & @AutoItPID & ")" & @CRLF
	$Data = $Data & "Startups:" & @TAB & @TAB & IniRead($Configfile, "config", "startups", 0) & @CRLF
	If FileExists(@ScriptDir & "\portable.dat") Then
		$Data = $Data & "Mode:" & @TAB & @TAB & "Portable" & @CRLF
	Else
		$Data = $Data & "Mode:" & @TAB & @TAB & "Normal" & @CRLF
	EndIf
	$Data = $Data & "ISN AutoIt version:" & @TAB & @AutoItVersion & @CRLF
	$Data = $Data & "Current Skin:" & @TAB & $skin & @CRLF
	$Data = $Data & "ISN DPI scale:" & @TAB & $DPI & @CRLF
	$Data = $Data & "Languagefile:" & @TAB & $Languagefile & @CRLF
	If @Compiled Then
		$Data = $Data & "Run mode:" & @TAB & "Compiled version" & @CRLF
	Else
		$Data = $Data & "Run mode:" & @TAB & "Source version" & @CRLF
	EndIf
	If IsAdmin() Then
		$adm = "Yes"
	Else
		$adm = "No"
	EndIf
	$Data = $Data & "Run ISN as admin:" & @TAB & $adm & @CRLF






	$Data = $Data & @CRLF & " - AUTOIT PATHS -" & @CRLF
	$Data = $Data & "----------------" & @CRLF
	If FileExists($autoitexe) Then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "Autoit3.exe:" & @TAB & $ex & " (" & $autoitexe & ")" & @CRLF

	If FileExists($autoit2exe) Then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "Aut2exe.exe:" & @TAB & $ex & " (" & $autoit2exe & ")" & @CRLF

	If FileExists($helpfile) Then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "AutoIt3Help.exe:" & @TAB & $ex & " (" & $helpfile & ")" & @CRLF

	If FileExists($Au3Checkexe) Then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "Au3Check.exe:" & @TAB & $ex & " (" & $Au3Checkexe & ")" & @CRLF


	If FileExists($Au3Infoexe) Then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "Au3Info.exe:" & @TAB & $ex & " (" & $Au3Infoexe & ")" & @CRLF

	If FileExists($Au3Stripperexe) Then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "AU3Stripper.exe:" & @TAB & $ex & " (" & $Au3Stripperexe & ")" & @CRLF

	If FileExists($Tidyexe) Then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "Tidy.exe:" & @TAB & @TAB & $ex & " (" & $Tidyexe & ")" & @CRLF





	$Data = $Data & @CRLF & " - ISN AUTOIT STUDIO PATHS -" & @CRLF
	$Data = $Data & "----------------" & @CRLF
	$Data = $Data & "%myisndatadir%:" & @TAB & _ISN_Variablen_aufloesen($Arbeitsverzeichnis) & @CRLF
	$Data = $Data & "Working dir:" & @TAB & @WorkingDir & @CRLF
	$Data = $Data & "Script dir:" & @TAB & @ScriptDir & @CRLF
	$Data = $Data & "Project dir:" & @TAB & _ISN_Variablen_aufloesen($Projectfolder) & @CRLF
	$Data = $Data & "Templates dir:" & @TAB & _ISN_Variablen_aufloesen($templatefolder) & @CRLF
	$Data = $Data & "Release dir:" & @TAB & _ISN_Variablen_aufloesen($releasefolder) & @CRLF
	$Data = $Data & "Backup dir:" & @TAB & _ISN_Variablen_aufloesen($Backupfolder) & @CRLF
	$Data = $Data & "Skins dir:" & @TAB & @TAB & @ScriptDir & "\Data\Skins" & @CRLF
	$Data = $Data & "Cache dir:" & @TAB & _ISN_Variablen_aufloesen($Arbeitsverzeichnis & "\data\cache") & @CRLF
	$Data = $Data & "Plugins dir:" & @TAB & _ISN_Variablen_aufloesen($Pluginsdir) & @CRLF
	$Data = $Data & "config.ini path:" & @TAB & $Configfile & @CRLF
	If StringInStr(FileGetAttrib($Configfile), "R") Then
		$ex = "No"
	Else
		$ex = "Yes"
	EndIf
	$Data = $Data & "Config writable:" & @TAB & $ex & @CRLF

	$isn_dir_writable = "No"
	If _Directory_Is_Accessible(@ScriptDir & "\Data") Then $isn_dir_writable = "Yes"
	$Data = $Data & "ISN dir writable:" & @TAB & $isn_dir_writable & @CRLF





	$Data = $Data & @CRLF & " - ISN AUTOIT STUDIO PLUGINS -" & @CRLF
	$Data = $Data & "----------------" & @CRLF
	$Data = $Data & "Loaded Plugins:" & @TAB & $Loaded_Plugins & @CRLF
	$Data = $Data & "Loaded filetypes:" & @TAB & $Loaded_Plugins_filetypes & @CRLF









	GUICtrlSetData($ISNSTudio_debug_edit, $Data)
	GUISetState(@SW_SHOW, $ISNSTudio_debug)
	GUISetState(@SW_DISABLE, $Config_GUI)
EndFunc   ;==>_Show_Studio_Debug

Func _HIDE_Studio_Debug()
	If GUICtrlRead($ISNSTudio_debug_console_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("showdebugconsole", "true")
	Else
		_Write_in_Config("showdebugconsole", "false")
	EndIf

	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_HIDE, $ISNSTudio_debug)
EndFunc   ;==>_HIDE_Studio_Debug

Func _Choose_defaultfont()
	$result = _ChooseFont(GUICtrlRead($darstellung_defaultfont_font), GUICtrlRead($darstellung_defaultfont_size), 0, 0, False, False, False, $Config_GUI)
	If $result = -1 Then Return
	GUICtrlSetData($darstellung_defaultfont_font, $result[2])
	GUICtrlSetData($darstellung_defaultfont_size, $result[3])
EndFunc   ;==>_Choose_defaultfont

Func _restore_default_font()
	GUICtrlSetData($darstellung_defaultfont_font, "Segoe UI")
	GUICtrlSetData($darstellung_defaultfont_size, "8.5")
EndFunc   ;==>_restore_default_font

Func _restore_treeview_font()
	GUICtrlSetData($darstellung_treefont_font, "Segoe UI")
	GUICtrlSetData($darstellung_treefont_size, "8.5")
	GUICtrlSetData($darstellung_treefont_colour, "0x000000")
	GUICtrlSetBkColor($darstellung_treefont_colour, 0x000000)
	GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert(Execute(0x000000)))
EndFunc   ;==>_restore_treeview_font

Func _Choose_treeviewfont()
	$iColorRef = Hex(String(GUICtrlRead($darstellung_treefont_colour)), 6)
	$iColorRef = '0x' & StringMid($iColorRef, 5, 2) & StringMid($iColorRef, 3, 2) & StringMid($iColorRef, 1, 2)
	$result = _ChooseFont(GUICtrlRead($darstellung_treefont_font), GUICtrlRead($darstellung_treefont_size), $iColorRef, 0, False, False, False, $Config_GUI)
	If $result = -1 Then Return
	GUICtrlSetData($darstellung_treefont_font, $result[2])
	GUICtrlSetData($darstellung_treefont_size, $result[3])
	GUICtrlSetData($darstellung_treefont_colour, $result[7])
	GUICtrlSetBkColor($darstellung_treefont_colour, $result[7])
	GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert($result[7]))
EndFunc   ;==>_Choose_treeviewfont

Func _Choose_skripteditorfont()
	$result = _ChooseFont(GUICtrlRead($darstellung_scripteditor_font), GUICtrlRead($darstellung_scripteditor_size), 0, 0, False, False, False, $Config_GUI)
	If $result = -1 Then Return
	GUICtrlSetData($darstellung_scripteditor_font, $result[2])
	GUICtrlSetData($darstellung_scripteditor_size, $result[3])
EndFunc   ;==>_Choose_skripteditorfont



Func _Choose_Scripteditor_bg_colour()
	$res = _ChooseColor(2, GUICtrlRead($darstellung_scripteditor_bgcolour), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($darstellung_scripteditor_bgcolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, $res)
	If GUICtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then _Farbeinstellungen_Hintergrundfarbe_fuer_alle_uebernehmen()
EndFunc   ;==>_Choose_Scripteditor_bg_colour

Func _Choose_Scripteditor_row_colour()
	$res = _ChooseColor(2, GUICtrlRead($darstellung_scripteditor_rowcolour), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($darstellung_scripteditor_rowcolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, $res)
EndFunc   ;==>_Choose_Scripteditor_row_colour

Func _Choose_Scripteditor_marc_colour()
	$res = _ChooseColor(2, GUICtrlRead($darstellung_scripteditor_marccolour), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($darstellung_scripteditor_marccolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, $res)
EndFunc   ;==>_Choose_Scripteditor_marc_colour

Func _Choose_Scripteditor_highlightcolour()
	$res = _ChooseColor(2, GUICtrlRead($darstellung_scripteditor_highlightcolour), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($darstellung_scripteditor_highlightcolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, $res)
EndFunc   ;==>_Choose_Scripteditor_highlightcolour

Func _Choose_Scripteditor_bracelight_colour()
	$res = _ChooseColor(2, GUICtrlRead($setting_scripteditor_bracelight_colour), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($setting_scripteditor_bracelight_colour, $res)
	GUICtrlSetColor($setting_scripteditor_bracelight_colour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($setting_scripteditor_bracelight_colour, $res)
EndFunc   ;==>_Choose_Scripteditor_bracelight_colour

Func _Choose_Scripteditor_bracebad_colour()
	$res = _ChooseColor(2, GUICtrlRead($settings_scripteditor_bracebad_colour), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($settings_scripteditor_bracebad_colour, $res)
	GUICtrlSetColor($settings_scripteditor_bracebad_colour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($settings_scripteditor_bracebad_colour, $res)
EndFunc   ;==>_Choose_Scripteditor_bracebad_colour

Func _Choose_Scripteditor_cursorcolor()
	$res = _ChooseColor(2, GUICtrlRead($darstellung_scripteditor_cursorcolor), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($darstellung_scripteditor_cursorcolor, $res)
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, $res)
EndFunc   ;==>_Choose_Scripteditor_cursorcolor

Func _Choose_Scripteditor_errorcolor()
	$res = _ChooseColor(2, GUICtrlRead($darstellung_scripteditor_errorcolor), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($darstellung_scripteditor_errorcolor, $res)
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, $res)
EndFunc   ;==>_Choose_Scripteditor_errorcolor

Func _Toggle_Skin()
	If GUICtrlRead($config_skin_radio2) = $GUI_CHECKED Then
		GUICtrlSetState($config_skin_name, $GUI_ENABLE)
		GUICtrlSetState($config_skin_author, $GUI_ENABLE)
		GUICtrlSetState($config_skin_url, $GUI_ENABLE)
		GUICtrlSetState($config_skin_version, $GUI_ENABLE)
		GUICtrlSetState($config_skin_list, $GUI_ENABLE)
		_load_skindetails()
	Else
		GUICtrlSetState($config_skin_name, $GUI_DISABLE)
		GUICtrlSetState($config_skin_author, $GUI_DISABLE)
		GUICtrlSetState($config_skin_url, $GUI_DISABLE)
		GUICtrlSetState($config_skin_version, $GUI_DISABLE)
		GUICtrlSetState($config_skin_list, $GUI_DISABLE)
		GUICtrlSetData($config_skin_name, _Get_langstr(142))
		GUICtrlSetData($config_skin_author, _Get_langstr(132))
		GUICtrlSetData($config_skin_version, _Get_langstr(131))
		GUICtrlSetData($config_skin_url, _Get_langstr(485))
		_SetImage($config_skin_pic, @ScriptDir & "\data\isn_logo_l.png")
		GUICtrlSetOnEvent($config_skin_url, "")
	EndIf
EndFunc   ;==>_Toggle_Skin

Func _Load_Skins()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($config_skin_list))
	$search = FileFindFirstFile(@ScriptDir & "\Data\Skins\*.*")
	If $search = -1 Then
		FileClose($search)
		Return
	EndIf
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If $file = "." Or $file = ".." Then ContinueLoop
		If StringInStr(FileGetAttrib(@ScriptDir & "\Data\Skins\" & $file), "D") Then
			If FileExists(@ScriptDir & "\Data\Skins\" & $file & "\skin.msstyles") Then
				_GUICtrlListView_AddItem($config_skin_list, IniRead(@ScriptDir & "\Data\Skins\" & $file & "\skin.ini", "skin", "name", ""))
				_GUICtrlListView_AddSubItem($config_skin_list, _GUICtrlListView_GetItemCount($config_skin_list) - 1, IniRead(@ScriptDir & "\Data\Skins\" & $file & "\skin.ini", "skin", "author", ""), 1)
				_GUICtrlListView_AddSubItem($config_skin_list, _GUICtrlListView_GetItemCount($config_skin_list) - 1, $file, 2)
				If $file = $skin Then
					_GUICtrlListView_SetItemSelected($config_skin_list, _GUICtrlListView_GetItemCount($config_skin_list) - 1, True, True)
					_load_skindetails()
				EndIf
			EndIf
		EndIf
	WEnd
	FileClose($search)
EndFunc   ;==>_Load_Skins

Func _load_skindetails()
	AdlibUnRegister("_load_skindetails")
	If _GUICtrlListView_GetSelectionMark($config_skin_list) = -1 Then Return
	If FileExists(@ScriptDir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.jpg") Then
		GUICtrlSetImage($config_skin_pic, @ScriptDir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.jpg")
	Else
		_SetImage($config_skin_pic, @ScriptDir & "\data\isn_logo_l.png")
	EndIf
	GUICtrlSetData($config_skin_name, _Get_langstr(142) & " " & IniRead(@ScriptDir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "name", ""))
	GUICtrlSetData($config_skin_author, _Get_langstr(132) & " " & IniRead(@ScriptDir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "author", ""))
	GUICtrlSetData($config_skin_version, _Get_langstr(131) & " " & IniRead(@ScriptDir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "version", ""))
	GUICtrlSetData($config_skin_url, _Get_langstr(485) & " " & _Get_langstr(487))
	GUICtrlSetOnEvent($config_skin_url, "_openurl")
EndFunc   ;==>_load_skindetails

Func _openurl()
	If _GUICtrlListView_GetSelectionMark($config_skin_list) = -1 Then Return
	ShellExecute(IniRead(@ScriptDir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "url", ""))
EndFunc   ;==>_openurl


Func _Toggle_Autosave_Modes()
	If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox) = $GUI_CHECKED Then

		If GUICtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_Radio) = $GUI_CHECKED Then
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, $GUI_ENABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, $GUI_ENABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, $GUI_ENABLE)

			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, $GUI_DISABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, $GUI_DISABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, $GUI_DISABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_DISABLE)

		Else
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, $GUI_ENABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, $GUI_ENABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, $GUI_ENABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_ENABLE)

			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, $GUI_DISABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, $GUI_DISABLE)
			GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, $GUI_DISABLE)
		EndIf


		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_ENABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_ENABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_ENABLE)

	Else
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, $GUI_DISABLE)
		GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_DISABLE)
	EndIf

EndFunc   ;==>_Toggle_Autosave_Modes

Func _Toggle_Filetypes_Modes()
	If GUICtrlRead($Einstellungen_Skripteditor_Dateitypen_automatisch_radio) = $GUI_CHECKED Then

		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_default_Button, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Remove_Button, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Add_Button, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Listview, $GUI_DISABLE)

	Else
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_default_Button, $GUI_ENABLE)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Remove_Button, $GUI_ENABLE)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Add_Button, $GUI_ENABLE)
		GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Listview, $GUI_ENABLE)

	EndIf
EndFunc   ;==>_Toggle_Filetypes_Modes

Func _Toggle_backupmode()

	If GUICtrlRead($Checkbox_enablebackup) = $GUI_CHECKED Then
		GUICtrlSetState($Input_backuptime, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_enabledeleteoldbackups, $GUI_ENABLE)
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_ENABLE)
		GUICtrlSetState($config_backupmode_combo, $GUI_ENABLE)
		GUICtrlSetState($Input_Backup_Pfad, $GUI_ENABLE)
		GUICtrlSetState($config_baackuprestorebutton, $GUI_ENABLE)
		GUICtrlSetState($Einstellungen_Backup_Ordnerstruktur_input, $GUI_ENABLE)
		If GUICtrlRead($config_backupmode_combo) = _Get_langstr(425) Then
			GUICtrlSetState($config_baackupmodegivefolder, $GUI_ENABLE)
			GUICtrlSetData($config_backupmode_label, _Get_langstr(128))
		Else
			GUICtrlSetData($config_backupmode_label, _Get_langstr(415))
			GUICtrlSetState($config_baackupmodegivefolder, $GUI_DISABLE)
		EndIf
	Else
		GUICtrlSetState($Input_backuptime, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_enabledeleteoldbackups, $GUI_DISABLE)
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_DISABLE)
		GUICtrlSetState($config_backupmode_combo, $GUI_DISABLE)
		GUICtrlSetState($Input_Backup_Pfad, $GUI_DISABLE)
		GUICtrlSetState($config_baackuprestorebutton, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_Backup_Ordnerstruktur_input, $GUI_DISABLE)
		GUICtrlSetState($config_baackupmodegivefolder, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($Checkbox_enablebackup) = $GUI_CHECKED And GUICtrlRead($Checkbox_enabledeleteoldbackups) = $GUI_CHECKED Then
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_ENABLE)
	Else
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_DISABLE)
	EndIf

EndFunc   ;==>_Toggle_backupmode

Func _Toggle_autoupdatefields()
	If GUICtrlRead($Checkbox_enable_autoupdate) = $GUI_CHECKED Then
		GUICtrlSetState($config_autoupdate_time_in_days, $GUI_ENABLE)
	Else
		GUICtrlSetState($config_autoupdate_time_in_days, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Toggle_autoupdatefields

Func _settings_toggle_tidywithISN()

	If GUICtrlRead($einstellungen_tidy_ueberdasISNverwalten) = $GUI_CHECKED Then
		GUICtrlSetState($einstellungen_tidy_ini_pfad, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad_button, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad_label, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_input, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Proper, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_Constants, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_Update_variables_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_lowercase, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_uppercase, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_firstseen, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_add, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endfunc_statement_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_ignore, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_remove, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endregion_statement_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_add, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_ignore, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_remove, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_spaces, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_indent_region, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile_show, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_keepversions_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_keepversions_input, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_input, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_removeemptylines_label, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_backupdir_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaveall, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_removeall, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaves1, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_show_consoleinfo_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_label, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_rundiff_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_input, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_strip, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_always, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_button, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_button, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_extrainfo_label, $GUI_ENABLE)
	Else
		GUICtrlSetState($einstellungen_tidy_ini_pfad_button, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad_label, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_input, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Proper, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_Constants, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_Update_variables_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_lowercase, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_uppercase, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_firstseen, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_add, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endfunc_statement_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_ignore, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_remove, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endregion_statement_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_add, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_ignore, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_remove, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_spaces, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_indent_region, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile_show, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_keepversions_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_keepversions_input, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_input, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_removeemptylines_label, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_backupdir_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaveall, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_removeall, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaves1, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_show_consoleinfo_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_label, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_rundiff_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_input, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_strip, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_always, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_button, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_button, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_extrainfo_label, $GUI_DISABLE)
	EndIf



EndFunc   ;==>_settings_toggle_tidywithISN


Func _Tidy_Einstellungen_speichern()
	If $Verwalte_Tidyeinstellungen_mit_dem_ISN = "false" Then Return ;Nur speichern wenn Einstellungen vom ISN verwaltet werden!
	If _ISN_Variablen_aufloesen($Pfad_zur_TidyINI) = "" Then Return
	Local $Tidy_ini_Path = _ISN_Variablen_aufloesen($Pfad_zur_TidyINI)

	If GUICtrlRead($einstellungen_tidy_einzug_input) = "" Then
		$res = IniDelete($Tidy_ini_Path, "ProgramSettings", "tabchar")
	Else
		$res = IniWrite($Tidy_ini_Path, "ProgramSettings", "tabchar", GUICtrlRead($einstellungen_tidy_einzug_input))
	EndIf

	If $res = 0 Then
		MsgBox(262144 + 16, _Get_langstr(984), StringReplace(_Get_langstr(1181), "%1", $Tidy_ini_Path), 0, $Einstellungen_werden_gespeichert_GUI)
		Return
	EndIf



	If GUICtrlRead($Checkbox_Tidy_keepversions_input) = "" Then
		IniDelete($Tidy_ini_Path, "ProgramSettings", "KeepNVersions")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "KeepNVersions", GUICtrlRead($Checkbox_Tidy_keepversions_input))
	EndIf


	If GUICtrlRead($Checkbox_Tidy_backupdir_input) = "" Then
		IniDelete($Tidy_ini_Path, "ProgramSettings", "backupDir")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "backupDir", GUICtrlRead($Checkbox_Tidy_backupdir_input))
	EndIf


	If GUICtrlRead($Checkbox_Tidy_rundiff_input) = "" Then
		IniDelete($Tidy_ini_Path, "ProgramSettings", "ShowDiffPgm")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "ShowDiffPgm", GUICtrlRead($Checkbox_Tidy_rundiff_input))
	EndIf

	If GUICtrlRead($Checkbox_Tidy_Proper) = $GUI_CHECKED Then
		IniWrite($Tidy_ini_Path, "ProgramSettings", "proper", "1")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "proper", "0")
	EndIf

	If GUICtrlRead($Checkbox_Tidy_Update_Constants) = $GUI_CHECKED Then
		IniWrite($Tidy_ini_Path, "ProgramSettings", "properconstants", "1")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "properconstants", "0")
	EndIf

	If GUICtrlRead($Checkbox_Tidy_Update_spaces) = $GUI_CHECKED Then
		IniWrite($Tidy_ini_Path, "ProgramSettings", "delim", "1")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "delim", "0")
	EndIf

	If GUICtrlRead($Checkbox_Tidy_Update_variables_uppercase) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "vars", "1")
	If GUICtrlRead($Checkbox_Tidy_Update_variables_lowercase) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "vars", "2")
	If GUICtrlRead($Checkbox_Tidy_Update_variables_firstseen) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "vars", "3")

	If GUICtrlRead($Checkbox_Tidy_endfunc_statement_add) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "endfunc_comment", "1")
	If GUICtrlRead($Checkbox_Tidy_endfunc_statement_ignore) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "endfunc_comment", "0")
	If GUICtrlRead($Checkbox_Tidy_endfunc_statement_remove) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "endfunc_comment", "-1")

	If GUICtrlRead($Checkbox_Tidy_endregion_statement_add) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "endregion_comment", "1")
	If GUICtrlRead($Checkbox_Tidy_endregion_statement_ignore) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "endregion_comment", "0")
	If GUICtrlRead($Checkbox_Tidy_endregion_statement_remove) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "endregion_comment", "-1")

	If GUICtrlRead($Checkbox_Tidy_indent_region) = $GUI_CHECKED Then
		IniWrite($Tidy_ini_Path, "ProgramSettings", "region_indent", "1")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "region_indent", "0")
	EndIf

	If GUICtrlRead($Checkbox_Tidy_create_docfile) = $GUI_CHECKED Then
		IniWrite($Tidy_ini_Path, "ProgramSettings", "Gen_Doc", "1")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "Gen_Doc", "0")
	EndIf

	If GUICtrlRead($Checkbox_Tidy_create_docfile_show) = $GUI_CHECKED Then
		IniWrite($Tidy_ini_Path, "ProgramSettings", "Gen_Doc_Show", "1")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "Gen_Doc_Show", "0")
	EndIf

	If GUICtrlRead($Checkbox_Tidy_removeemptylines_leaveall) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "Remove_Empty_Lines", "0")
	If GUICtrlRead($Checkbox_Tidy_removeemptylines_removeall) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "Remove_Empty_Lines", "1")
	If GUICtrlRead($Checkbox_Tidy_removeemptylines_leaves1) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "Remove_Empty_Lines", "2")


	If GUICtrlRead($einstellungen_tidy_endwithnewline_always) = $GUI_CHECKED Then
		IniWrite($Tidy_ini_Path, "ProgramSettings", "End_With_NewLin", "1")
	Else
		IniWrite($Tidy_ini_Path, "ProgramSettings", "End_With_NewLin", "0")
	EndIf

	If GUICtrlRead($Checkbox_Tidy_show_consoleinfo_inconsole) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "ShowConsoleInfo", "1")
	If GUICtrlRead($Checkbox_Tidy_show_consoleinfo_debugoutput) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path, "ProgramSettings", "ShowConsoleInfo", "9")

EndFunc   ;==>_Tidy_Einstellungen_speichern

Func _settings_tidy_choosebackupdir()
	$var = FileSelectFolder(_Get_langstr(298), "", 1, "", $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Checkbox_Tidy_backupdir_input, $var)
EndFunc   ;==>_settings_tidy_choosebackupdir

Func _settings_tidy_choosetidyinipath()
	$var = FileSaveDialog(_Get_langstr(187), "", "INI Files (*.ini)", 0, "tidy.ini", $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($einstellungen_tidy_ini_pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_settings_tidy_choosetidyinipath

Func _settings_tidy_choosediffprogramm()
	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All (*.exe)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $Config_GUI)
	Else
		$var = FileOpenDialog(_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All (*.exe)", 1 + 2, "", $Config_GUI)
	EndIf
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then Return
	GUICtrlSetData($Checkbox_Tidy_rundiff_input, $var)
EndFunc   ;==>_settings_tidy_choosediffprogramm


Func _Tidy_Einstellungen_einlesen()
	Local $Tidy_ini_Path = _ISN_Variablen_aufloesen($Pfad_zur_TidyINI)

	GUICtrlSetData($einstellungen_tidy_ini_pfad, $Pfad_zur_TidyINI)
	GUICtrlSetData($einstellungen_tidy_einzug_input, IniRead($Tidy_ini_Path, "ProgramSettings", "tabchar", "0"))
	GUICtrlSetData($Checkbox_Tidy_keepversions_input, IniRead($Tidy_ini_Path, "ProgramSettings", "KeepNVersions", "5"))
	GUICtrlSetData($Checkbox_Tidy_backupdir_input, IniRead($Tidy_ini_Path, "ProgramSettings", "backupDir", ""))
	GUICtrlSetData($Checkbox_Tidy_rundiff_input, IniRead($Tidy_ini_Path, "ProgramSettings", "ShowDiffPgm", ""))

	If IniRead($Tidy_ini_Path, "ProgramSettings", "proper", "1") = "1" Then
		GUICtrlSetState($Checkbox_Tidy_Proper, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Tidy_Proper, $GUI_UNCHECKED)
	EndIf

	If IniRead($Tidy_ini_Path, "ProgramSettings", "properconstants", "0") = "1" Then
		GUICtrlSetState($Checkbox_Tidy_Update_Constants, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Tidy_Update_Constants, $GUI_UNCHECKED)
	EndIf

	Switch IniRead($Tidy_ini_Path, "ProgramSettings", "vars", "3")
		Case "1"
			GUICtrlSetState($Checkbox_Tidy_Update_variables_uppercase, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_Update_variables_lowercase, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_Update_variables_firstseen, $GUI_UNCHECKED)

		Case "2"
			GUICtrlSetState($Checkbox_Tidy_Update_variables_uppercase, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_Update_variables_lowercase, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_Update_variables_firstseen, $GUI_UNCHECKED)

		Case "3"
			GUICtrlSetState($Checkbox_Tidy_Update_variables_uppercase, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_Update_variables_lowercase, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_Update_variables_firstseen, $GUI_CHECKED)
	EndSwitch

	If IniRead($Tidy_ini_Path, "ProgramSettings", "delim", "1") = "1" Then
		GUICtrlSetState($Checkbox_Tidy_Update_spaces, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Tidy_Update_spaces, $GUI_UNCHECKED)
	EndIf

	Switch IniRead($Tidy_ini_Path, "ProgramSettings", "endfunc_comment", "1")
		Case "1"
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_add, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_ignore, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_remove, $GUI_UNCHECKED)

		Case "0"
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_add, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_ignore, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_remove, $GUI_UNCHECKED)

		Case "-1"
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_add, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_ignore, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endfunc_statement_remove, $GUI_CHECKED)

	EndSwitch

	Switch IniRead($Tidy_ini_Path, "ProgramSettings", "endregion_comment", "1")
		Case "1"
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_add, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_ignore, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_remove, $GUI_UNCHECKED)

		Case "0"
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_add, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_ignore, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_remove, $GUI_UNCHECKED)

		Case "-1"
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_add, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_ignore, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_endregion_statement_remove, $GUI_CHECKED)

	EndSwitch

	If IniRead($Tidy_ini_Path, "ProgramSettings", "region_indent", "1") = "1" Then
		GUICtrlSetState($Checkbox_Tidy_indent_region, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Tidy_indent_region, $GUI_UNCHECKED)
	EndIf

	If IniRead($Tidy_ini_Path, "ProgramSettings", "Gen_Doc", "0") = "1" Then
		GUICtrlSetState($Checkbox_Tidy_create_docfile, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Tidy_create_docfile, $GUI_UNCHECKED)
	EndIf

	If IniRead($Tidy_ini_Path, "ProgramSettings", "Gen_Doc_Show", "0") = "1" Then
		GUICtrlSetState($Checkbox_Tidy_create_docfile_show, $GUI_CHECKED)
	Else
		GUICtrlSetState($Checkbox_Tidy_create_docfile_show, $GUI_UNCHECKED)
	EndIf

	Switch IniRead($Tidy_ini_Path, "ProgramSettings", "Remove_Empty_Lines", "0")
		Case "0"
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaveall, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_removeall, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaves1, $GUI_UNCHECKED)

		Case "1"
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaveall, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_removeall, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaves1, $GUI_UNCHECKED)

		Case "2"
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaveall, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_removeall, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaves1, $GUI_CHECKED)

	EndSwitch

	Switch IniRead($Tidy_ini_Path, "ProgramSettings", "ShowConsoleInfo", "1")
		Case "1"
			GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_UNCHECKED)

		Case "9"
			GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_UNCHECKED)
			GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_CHECKED)

	EndSwitch

	If IniRead($Tidy_ini_Path, "ProgramSettings", "End_With_NewLin", "1") = "1" Then
		GUICtrlSetState($einstellungen_tidy_endwithnewline_strip, $GUI_UNCHECKED)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_always, $GUI_CHECKED)
	Else
		GUICtrlSetState($einstellungen_tidy_endwithnewline_strip, $GUI_CHECKED)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_always, $GUI_UNCHECKED)
	EndIf

EndFunc   ;==>_Tidy_Einstellungen_einlesen


Func _Toggle_proxyfields()
	If GUICtrlRead($proxy_enable_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($proxy_server_input, $GUI_ENABLE)
		GUICtrlSetState($proxy_port_input, $GUI_ENABLE)
		GUICtrlSetState($proxy_username_input, $GUI_ENABLE)
		GUICtrlSetState($proxy_password_input, $GUI_ENABLE)
	Else
		GUICtrlSetState($proxy_server_input, $GUI_DISABLE)
		GUICtrlSetState($proxy_port_input, $GUI_DISABLE)
		GUICtrlSetState($proxy_username_input, $GUI_DISABLE)
		GUICtrlSetState($proxy_password_input, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Toggle_proxyfields

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

Func _Reset_Warnmeldungen()
	IniDelete($Configfile, "warnings")
	MsgBox(64 + 262144, _Get_langstr(61), _Get_langstr(496), 0, $Config_GUI)
EndFunc   ;==>_Reset_Warnmeldungen

Func _Reset_letzte_elemente()
	IniDelete($Configfile, "history")
	MsgBox(64 + 262144, _Get_langstr(61), _Get_langstr(672), 0, $Config_GUI)
EndFunc   ;==>_Reset_letzte_elemente

Func _Aktualisiere_Hotkeyliste()
	_Lade_Tastenkombinationen()
	$Letzte_Makierung = _GUICtrlListView_GetSelectionMark($settings_hotkeylistview)
	If $Letzte_Makierung = -1 Then $Letzte_Makierung = 0

	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($settings_hotkeylistview))
	_GUICtrlListView_BeginUpdate($settings_hotkeylistview)
	;Öffnen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(508), 62)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Oeffnen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Oeffnen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_open", 3)

	;Speichern
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(9), 63)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Speichern), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Speichern, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_save", 3)

	;Speichern unter...
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(725), 63)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Speichern_unter), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Speichern_unter, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_save_as", 3)

	;Speichern (alle Tabs)
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(650), 64)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Speichern_Alle_Tabs), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Speichern_Alle_Tabs, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_save_all_tabs", 3)

	;Tab schließen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(80), 65)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_tab_schliessen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_tab_schliessen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_closetab", 3)

	;Vorheriger Tab
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(677), 66)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_vorheriger_tab), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_vorheriger_tab, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_previoustab", 3)

	;Nächster Tab
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(678), 67)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_naechster_tab), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_naechster_tab, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_nexttab", 3)

	;Vollbild
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(457), 68)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_vollbild), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_vollbild, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_fullscreen", 3)

	;Auskommentieren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(328), 69)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_auskommentieren), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_auskommentieren, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_commentout", 3)

	;Befehlhilfe
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(679), 70)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_befehlhilfe, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_commandhelp", 3)

	;Springe zu Zeile
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(116), 71)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_springezuzeile), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_springezuzeile, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_gotoline", 3)

	;Tidy
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(327), 61)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Tidy), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Tidy, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_tidy", 3)

	;Syntaxcheck
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(108), 72)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_syntaxcheck), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_syntaxcheck, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_syntaxcheck", 3)

	;compile
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(235), 73)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_compile), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_compile, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_compile", 3)

	;compile settings
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(563), 74)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_compile_Settings), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_compile_Settings, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_compile_Settings", 3)

	;Skript testen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(82), 75)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_testeskript), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_testeskript, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_testscript", 3)

	;Teste Projekt
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(489), 76)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Testprojekt), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Testprojekt, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_testproject", 3)

	;Teste Projekt (ohne parameter)
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(488), 76)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Testprojekt_ohne_Parameter, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_testprojectwithoutparam", 3)

	;Neue Datei erstellen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(70), 77)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Neue_Datei), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Neue_Datei, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_newfile", 3)

	;Suche
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(87), 78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Suche), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Suche, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_search", 3)

	;Makroslot1
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(611), 79)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot1), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot1, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot1", 3)

	;Makroslot2
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(612), 80)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot2), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot2, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot2", 3)

	;Makroslot3
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(613), 81)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot3), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot3, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot3", 3)

	;Makroslot4
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(614), 82)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot4), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot4, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot4", 3)

	;Makroslot5
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(615), 83)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot5), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot5, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot5", 3)

	;Makroslot6
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(906), 84)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot6), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot6, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot6", 3)

	;Makroslot7
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(907), 85)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot7), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot7, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot7", 3)

	;Debug zu msgbox
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(727), 86)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_debugtomsgbox, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_debugtomsgbox", 3)

	;Debug zu console
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(729), 86)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_debugtoconsole, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_debugtoconsole", 3)

	;Erstelle UDF Header
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(730), 87)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_erstelleUDFheader), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_erstelleUDFheader, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_createudfheader", 3)

	;AutoItWrapper GUI
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(751), 88)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_AutoIt3WrapperGUI), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_AutoIt3WrapperGUI, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_autoit3wrappergui", 3)

	;MsgBoxGenerator
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(608), 89)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_msgBoxGenerator), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_msgBoxGenerator, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_msgboxgenerator", 3)

	;Zeile Duplizieren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(739), 90)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_zeile_duplizieren), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_zeile_duplizieren, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_dublicate", 3)

	;Farbtoolbox
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(651), 57)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Farbtoolbox), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Farbtoolbox, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_colourtoolbox", 3)

	;Fenster Info Tool
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(609), 91)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Fensterinfotool), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Fensterinfotool, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_windowinfotool", 3)

	;Organize Includes
;~ 	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(796))
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_organizeincludes), 1)
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_organizeincludes, 2)
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_organizeincludes", 3)

	;Open Include
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(808), 38)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Oeffne_Include), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Oeffne_Include, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_openinclude", 3)

	;Bitrechner
	If $Tools_Bitrechner_aktiviert = "true" Then
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(813), 92)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Bitrechner), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Bitrechner, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bitwise", 3)
	EndIf

	;Auto Backup
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(893), 41)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Automatisches_Backup), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Automatisches_Backup, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_backup", 3)

	;Datei/Ordner umbenennen
;~ 	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(75), 93)
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Datei_umbenennen), 1)
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Datei_umbenennen, 2)
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_renamefile", 3)

	;Weitersuchen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(93), 78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Weitersuchen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Weitersuchen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_nextsearch", 3)

	;Rückwärts Weitersuchen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(903), 78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Rueckwaerts_Weitersuchen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Rueckwaerts_Weitersuchen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_prevsearch", 3)

	;Änderungsprotokolle
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(911), 94)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Aenderungsprotokolle), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Aenderungsprotokolle, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_changelogmanager", 3)

	;Fenster unten umschalten
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1011), 95)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_unteres_fenster_umschalten), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_unteres_fenster_umschalten, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_togglehideoutputconsole", 3)

	;Fenster links umschalten
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1015), 96)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_linkes_fenster_umschalten), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_linkes_fenster_umschalten, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_toggleprojecttree", 3)

	;Fenster rechts umschalten
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1016), 97)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_rechtes_fenster_umschalten), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_rechtes_fenster_umschalten, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_togglescripttree", 3)


	;Springe zur Funktion
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1106), 100)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Springe_zu_Func), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Springe_zu_Func, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_jumptofunc", 3)

	;Kommentare ausblenden
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1172), 103)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_toggle_comments", 3)

	;Zeile nach oben verschieben
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1170), 104)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_oben_verschieben), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Zeile_nach_oben_verschieben, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_movelineup", 3)

	;Zeile nach unten verschieben
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1171), 105)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_unten_verschieben), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Zeile_nach_unten_verschieben, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_movelinedown", 3)

	;In Dateien Suchen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1189), 78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_In_Dateien_Suchen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_In_Dateien_Suchen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_search_in_files", 3)

	;Parameter Editor
	If $Tools_PELock_Obfuscator_aktiviert = "true" Then
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1206), 114)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_PElock_Obfuscator), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_PElock_Obfuscator, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_pelock_obfuscator", 3)
	EndIf

	;Zeile(n) markieren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1203), 115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_line", 3)

	;Zeilen markierung löschen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1310), 115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_alle_loeschen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken_alle_loeschen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_line_remove_all_bookmarks", 3)

	;Zeilen markierung zum nächsten springen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1308), 115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Naechstes_Bookmark), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken_Naechstes_Bookmark, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_jump_next", 3)

	;Zeilen markierung zum vorherigen springen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1309), 115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_jump_previous", 3)

	If $Tools_Parameter_Editor_aktiviert = "true" Then
		;Parameter Editor Hotkeys
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037), 98)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor", 3)

		;Parameter Editor - Alle Parameter leeren
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037) & " - " & _Get_langstr(1046), 98)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_clear_all_parameters", 3)

		;Parameter Editor - Markierten Parameter leeren
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037) & " - " & _Get_langstr(1044), 98)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_clear_selected_parameter", 3)

		;Parameter Editor - Markierten Parameter löschen
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037) & " - " & _Get_langstr(1045), 98)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_remove_selected_parameter", 3)

		;Parameter Editor - Neuer Parameter
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037) & " - " & _Get_langstr(1043), 98)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_neuer_Parameter), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_neuer_Parameter, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_add_new_parameter", 3)

		;Parameter Editor - Nächsten Parameter
		_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037) & " - " & _Get_langstr(1301), 98)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_naechster_Parameter), 1)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_naechster_Parameter, 2)
		_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_select_next_parameter", 3)
	EndIf

	;Temporäres Skript erstellen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1339), 10)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Create_Temp_Au3_Script), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Create_Temp_Au3_Script, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_create_temp_au3_script", 3)

	;Show Calltip
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1377), 121)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Show_CallTip), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Show_CallTip, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_show_calltip", 3)

	;Contract all Code segments
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1394), 122)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Contract_AllCodesegments), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Contract_AllCodesegments, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_contract_all", 3)

	;Expand all Code segments
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1395), 122)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Expand_AllCodesegments), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Expand_AllCodesegments, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_expand_all", 3)

	;Contract all Regions
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1401), 122)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Contract_Regions), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Contract_Regions, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_contract_regions", 3)

	;Expand all Regions
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1402), 122)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Expand_Regions), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Expand_Regions, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_expand_regions", 3)

	;Close Project
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(41), 123)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Close_project), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Close_project, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_close_project", 3)

	;Test selected code
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1375), 125)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Test_selected_Code), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Test_selected_Code, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_test_selected_code", 3)

	_GUICtrlListView_RegisterSortCallBack($settings_hotkeylistview)
	_GUICtrlListView_SortItems($settings_hotkeylistview, 0)

	_GUICtrlListView_SetItemSelected($settings_hotkeylistview, $Letzte_Makierung, True, True)
	_GUICtrlListView_EnsureVisible($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview))
	_GUICtrlListView_EndUpdate($settings_hotkeylistview)
	_GUICtrlListView_UnRegisterSortCallBack($settings_hotkeylistview)
EndFunc   ;==>_Aktualisiere_Hotkeyliste

Func _show_Edit_Hotkey()
	If _GUICtrlListView_GetSelectionMark($settings_hotkeylistview) = -1 Then Return
	GUICtrlSetData($edit_hotkey_funktion_label, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 0))
	GUICtrlSetData($edit_hotkey_hotkey, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 1))
	GUICtrlSetData($edit_hotkey_keycode, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 2))
	GUICtrlSetData($edit_hotkey_section, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 3))
	GUISetState(@SW_SHOW, $edit_hotkey_GUI)
	GUISetState(@SW_DISABLE, $Config_GUI)
EndFunc   ;==>_show_Edit_Hotkey

Func _save_Edit_Hotkey()
	IniWrite($Configfile, "hotkeys", GUICtrlRead($edit_hotkey_section), GUICtrlRead($edit_hotkey_keycode))
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_HIDE, $edit_hotkey_GUI)
	_Aktualisiere_Hotkeyliste()
EndFunc   ;==>_save_Edit_Hotkey

Func _hide_Edit_Hotkey()
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_HIDE, $edit_hotkey_GUI)
EndFunc   ;==>_hide_Edit_Hotkey

Func _Set_no_Hotkey()
	GUICtrlSetData($edit_hotkey_keycode, "")
	GUICtrlSetData($edit_hotkey_hotkey, "")
	_save_Edit_Hotkey()
EndFunc   ;==>_Set_no_Hotkey

Func _Set_Hotkey_to_default()
	IniDelete($Configfile, "hotkeys", GUICtrlRead($edit_hotkey_section))
	_Aktualisiere_Hotkeyliste()
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_HIDE, $edit_hotkey_GUI)
EndFunc   ;==>_Set_Hotkey_to_default

Func _aendere_Hotkey()
	GUISetState(@SW_SHOW, $warte_auf_tastendruck_GUI)
	GUISetState(@SW_DISABLE, $edit_hotkey_GUI)
	$Plus_zeichen = "+"
	$Kombi_Array = _getKeyKombi()
	If IsArray($Kombi_Array) Then
		$Keycode = _ArrayToString($Kombi_Array, $Plus_zeichen)
		$text = _Keycode_zu_Text($Keycode)
		GUICtrlSetData($edit_hotkey_keycode, $Keycode)
		GUICtrlSetData($edit_hotkey_hotkey, $text)
	EndIf
	GUISetState(@SW_ENABLE, $edit_hotkey_GUI)
	GUISetState(@SW_HIDE, $warte_auf_tastendruck_GUI)
EndFunc   ;==>_aendere_Hotkey

Func _Export_hotkeys()
	$line = FileSaveDialog(_Get_langstr(684), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Hotkeys (*.ini)", 18, "hotkeys.ini", $Config_GUI)
	If $line = "" Then Return
	If @error > 0 Then Return
	$section = IniReadSection($Configfile, "hotkeys")
	IniWriteSection($line, "hotkeys", $section)
	FileChangeDir(@ScriptDir)
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $Config_GUI)
EndFunc   ;==>_Export_hotkeys

Func _Import_hotkeys()
	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(683), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Hotkeys (*.ini)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $Config_GUI)
	Else
		$var = FileOpenDialog(_Get_langstr(683), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Hotkeys (*.ini)", 1 + 2, "", $Config_GUI)
	EndIf
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then Return
	$section = IniReadSection($var, "hotkeys")
	IniWriteSection($Configfile, "hotkeys", $section)
	FileChangeDir(@ScriptDir)
	_Aktualisiere_Hotkeyliste()
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(591), 0, $Config_GUI)
EndFunc   ;==>_Import_hotkeys

Func _toggle_Willkommen_Autoload()
	If GUICtrlRead($Willkommen_autoloadcheckbox) = $GUI_CHECKED Then
		$Autoload = "true"
		_Write_in_Config("autoload", "true")
	Else
		$Autoload = "false"
		_Write_in_Config("autoload", "false")
	EndIf
EndFunc   ;==>_toggle_Willkommen_Autoload

Func _Aktualisiere_Texte_in_Contextmenues_wegen_Hotkeys()
	;Aktualisiere Texte wegen Hotkeys


	;file menu
	_GUICtrlODMenuItemSetText($FileMenu_item1, _Get_langstr(9) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern))
	_GUICtrlODMenuItemSetText($Dateimenue_Oeffnen, _Get_langstr(509) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Oeffnen))
	_GUICtrlODMenuItemSetText($FileMenu_item1c, _Get_langstr(725) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern_unter))
	_GUICtrlODMenuItemSetText($FileMenu_item1b, _Get_langstr(650) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern_Alle_Tabs))
	_GUICtrlODMenuItemSetText($FileMenu_item11, _Get_langstr(457) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_vollbild))
	_GUICtrlODMenuItemSetText($FileMenu_Neue_Datei_temp_au3file, _Get_langstr(1094) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Create_Temp_Au3_Script))

	;project menu
	_GUICtrlODMenuItemSetText($ProjectMenu_item8a, _Get_langstr(50) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt))
	_GUICtrlODMenuItemSetText($ProjectMenu_item8b, _Get_langstr(488) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter))
	_GUICtrlODMenuItemSetText($ProjectMenu_item9, _Get_langstr(82) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_testeskript))
	_GUICtrlODMenuItemSetText($ProjectMenu_item11a, _Get_langstr(52) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile))
	_GUICtrlODMenuItemSetText($ProjectMenu_backup_durchfuehren, _Get_langstr(893) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Automatisches_Backup))
	_GUICtrlODMenuItemSetText($ProjectMenu_aenderungsprotokolle, _Get_langstr(911) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Aenderungsprotokolle))
	_GUICtrlODMenuItemSetText($ProjectMenu_item3, _Get_langstr(41) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Close_project))
	_GUICtrlODMenuItemSetText($EditMenu_TestSelectedCode, _Get_langstr(1375) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Test_selected_Code))

	;Edit menu
	_GUICtrlODMenuItemSetText($EditMenu_item7, _Get_langstr(115) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Suche))
	_GUICtrlODMenuItemSetText($EditMenu_item9, _Get_langstr(116) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_springezuzeile))
	_GUICtrlODMenuItemSetText($EditMenu_item11, _Get_langstr(328) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_auskommentieren))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_duplizieren, _Get_langstr(739) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_zeile_duplizieren))
	_GUICtrlODMenuItemSetText($EditMenu_Zeilen_nach_oben_verschieben, _Get_langstr(1170) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_oben_verschieben))
	_GUICtrlODMenuItemSetText($EditMenu_Zeilen_nach_unten_verschieben, _Get_langstr(1171) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_unten_verschieben))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken, _Get_langstr(1203) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken_naechste_Zeile, _Get_langstr(1308) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Naechstes_Bookmark))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken_vorherige_Zeile, _Get_langstr(1309) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken_Alle_Entfernen, _Get_langstr(1310) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_alle_loeschen))

	;Menü Tools
	_GUICtrlODMenuItemSetText($EditMenu_item8, _Get_langstr(108) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_syntaxcheck))
	_GUICtrlODMenuItemSetText($EditMenu_item10, _Get_langstr(327) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Tidy))
	_GUICtrlODMenuItemSetText($Tools_menu_debugging_debugtoMsgBox, _Get_langstr(727) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox))
	_GUICtrlODMenuItemSetText($Tools_menu_debugging_debugtoConsole, _Get_langstr(729) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole))
	_GUICtrlODMenuItemSetText($Tools_menu_createUDFheader, _Get_langstr(730) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_erstelleUDFheader))
	_GUICtrlODMenuItemSetText($Tools_menu_item1, _Get_langstr(608) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_msgBoxGenerator))
	_GUICtrlODMenuItemSetText($Tools_menu_AutoIt3Wrapper_GUI, _Get_langstr(751) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_AutoIt3WrapperGUI))
	_GUICtrlODMenuItemSetText($Tools_menu_item8, _Get_langstr(651) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Farbtoolbox))
	_GUICtrlODMenuItemSetText($Tools_menu_item2, _Get_langstr(609) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Fensterinfotool))
	_GUICtrlODMenuItemSetText($Tools_menu_bitrechner, _Get_langstr(813) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_bitrechner))
	_GUICtrlODMenuItemSetText($Tools_menu_PELock_Obfuscator, _Get_langstr(1206) & @TAB & _Keycode_zu_Text($Hotkey_PElock_Obfuscator))

	;help menu
	_GUICtrlODMenuItemSetText($HelpMenu_item1, _Get_langstr(174) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe))

	;Tab menu
	_GUICtrlODMenuItemSetText($TabContextMenu_Item1, _Get_langstr(9) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern))
	_GUICtrlODMenuItemSetText($TabContextMenu_Item2, _Get_langstr(80) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_tab_schliessen))

	;Contextmenü Skripteditor
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_speichern, _Get_langstr(9) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Speichern))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_oeffneHilfe, _Get_langstr(648) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_suche, _Get_langstr(115) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Suche))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_Auskommentieren, _Get_langstr(328) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_auskommentieren))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_debugtoMsgBox, _Get_langstr(727) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_debugtoConsole, _Get_langstr(729) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_oeffneInclude, _Get_langstr(508) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Oeffne_Include))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_testselectedcode, _Get_langstr(1375) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Test_selected_Code))

	;View Menu
	_GUICtrlODMenuItemSetText($AnsichtMenu_fenster_unten_umschalten, _Get_langstr(1011) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_unteres_fenster_umschalten))
	_GUICtrlODMenuItemSetText($AnsichtMenu_fenster_links_umschalten, _Get_langstr(1015) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_linkes_fenster_umschalten))
	_GUICtrlODMenuItemSetText($AnsichtMenu_fenster_rechts_umschalten, _Get_langstr(1016) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_rechtes_fenster_umschalten))
	_GUICtrlODMenuItemSetText($EditMenu_Kommentare_ausblenden, _Get_langstr(1172) & @TAB & _Keycode_zu_Text($Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden))
	_GUICtrlODMenuItemSetText($ViewMenu_Expand_Codesegments, _Get_langstr(1395) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Expand_AllCodesegments))
	_GUICtrlODMenuItemSetText($ViewMenu_Contract_Codesegments, _Get_langstr(1394) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Contract_AllCodesegments))
	_GUICtrlODMenuItemSetText($ViewMenu_Expand_Regions, _Get_langstr(1402) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Expand_Regions))
	_GUICtrlODMenuItemSetText($ViewMenu_Contract_Regions, _Get_langstr(1401) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Contract_Regions))


	;Parameter Editor
	_GUIToolTip_AddTool($hToolTip_ParameterEditor_GUI, 0, _Get_langstr(1043) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_neuer_Parameter) & ")", GUICtrlGetHandle($ParameterEditor_Plus_Button))
	_GUIToolTip_AddTool($hToolTip_ParameterEditor_GUI, 0, _Get_langstr(1045) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen) & ")", GUICtrlGetHandle($ParameterEditor_remove_Button))
	_GUIToolTip_AddTool($hToolTip_ParameterEditor_GUI, 0, _Get_langstr(1044) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren) & ")", GUICtrlGetHandle($ParameterEditor_Minus_Button))
	_GUIToolTip_AddTool($hToolTip_ParameterEditor_GUI, 0, _Get_langstr(1046) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren) & ")", GUICtrlGetHandle($ParameterEditor_ClearAll_Button))
	_GUIToolTip_AddTool($hToolTip_ParameterEditor_GUI, 0, _Get_langstr(1358) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_Parameterumbruch_hinzufuegen) & ")", GUICtrlGetHandle($ParameterEditor_Add_ParameterBreak_Button))
	_GUIToolTip_AddTool($hToolTip_ParameterEditor_GUI, 0, _Get_langstr(1361) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_Zeilenumbruch_hinzufuegen) & ")", GUICtrlGetHandle($ParameterEditor_Add_LineBreak_Button))

	;Suchen und ersetzen
	_GUIToolTip_AddTool($hToolTip_Find_GUI, 0, _Get_langstr(903) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Rueckwaerts_Weitersuchen) & ")", GUICtrlGetHandle($search_back_button))
	_GUIToolTip_AddTool($hToolTip_Find_GUI, 0, _Get_langstr(93) & " (" & _Keycode_zu_Text($Hotkey_Keycode_Weitersuchen) & ")", GUICtrlGetHandle($search_next_button))


EndFunc   ;==>_Aktualisiere_Texte_in_Contextmenues_wegen_Hotkeys

Func _Toggle_autocompletefields()
	If GUICtrlRead($Checkbox_disableautocomplete) = $GUI_UNCHECKED Then
		GUICtrlSetState($globalautocomplete_variables_return_only_global_checkbox, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_globalautocomplete, $GUI_DISABLE)
		GUICtrlSetState($Autocomplete_allow_complete_with_spacekey_checkbox, $GUI_DISABLE)
		GUICtrlSetState($Autocomplete_allow_complete_with_tabkey_checkbox, $GUI_DISABLE)
		GUICtrlSetState($Autocomplete_ab_zweitem_zeichen_checkbox, $GUI_DISABLE)
	Else
		GUICtrlSetState($Checkbox_globalautocomplete, $GUI_ENABLE)
		GUICtrlSetState($Autocomplete_ab_zweitem_zeichen_checkbox, $GUI_ENABLE)
		GUICtrlSetState($Autocomplete_allow_complete_with_tabkey_checkbox, $GUI_ENABLE)
		GUICtrlSetState($Autocomplete_allow_complete_with_spacekey_checkbox, $GUI_ENABLE)
		If GUICtrlRead($Checkbox_globalautocomplete) = $GUI_CHECKED Then
			GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_ENABLE)
			GUICtrlSetState($globalautocomplete_variables_return_only_global_checkbox, $GUI_ENABLE)
		Else
			GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_DISABLE)
			GUICtrlSetState($globalautocomplete_variables_return_only_global_checkbox, $GUI_DISABLE)
		EndIf
	EndIf

	If GUICtrlRead($Checkbox_hidedebug) = $GUI_CHECKED Then
		GUICtrlSetState($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_ENABLE)
	Else
		GUICtrlSetState($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($Einstellungen_AutoItIncludes_Verwalten_Checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Listview, $GUI_ENABLE)
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Add_Button, $GUI_ENABLE)
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Remove_Button, $GUI_ENABLE)
	Else
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Listview, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Add_Button, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Remove_Button, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($Checkbox_verwende_intelimark) = $GUI_CHECKED Then
		GUICtrlSetState($Config_Scripteditor_Intelimark_AdditionalMarkers_Checkbox, $GUI_ENABLE)
	Else
		GUICtrlSetState($Config_Scripteditor_Intelimark_AdditionalMarkers_Checkbox, $GUI_DISABLE)
	EndIf

EndFunc   ;==>_Toggle_autocompletefields

Func _Pfade_fuer_Weitere_Includes_in_Registrierung_uebernehmen()
	If $Zusaetzliche_Include_Pfade_ueber_ISN_verwalten <> "true" Then Return

	Local $Fertiger_String_fuer_Reg = ""
	$Pfade = _Config_Read("additional_includes_paths", "")
	$Pfade_Array = StringSplit($Pfade, "|", 2)
	If IsArray($Pfade_Array) Then
		For $x = 0 To UBound($Pfade_Array) - 1
			If $Pfade_Array[$x] = "" Then ContinueLoop
			If $Pfade_Array[$x] = "|" Then ContinueLoop
			$Fertiger_String_fuer_Reg = $Fertiger_String_fuer_Reg & _ISN_Variablen_aufloesen($Pfade_Array[$x]) & ";"
		Next
	EndIf
	RegWrite("HKEY_CURRENT_USER\Software\AutoIt v3\AutoIt", "Include", "REG_SZ", $Fertiger_String_fuer_Reg)
EndFunc   ;==>_Pfade_fuer_Weitere_Includes_in_Registrierung_uebernehmen

Func _Lade_Weitere_Includes_in_Listview()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_AutoItIncludes_Verwalten_Listview))
	$Pfade = _Config_Read("additional_includes_paths", "")
	$Pfade_Array = StringSplit($Pfade, "|", 2)
	_GUICtrlListView_BeginUpdate($Einstellungen_AutoItIncludes_Verwalten_Listview)
	If IsArray($Pfade_Array) Then
		For $x = 0 To UBound($Pfade_Array) - 1
			If $Pfade_Array[$x] = "" Then ContinueLoop
			If $Pfade_Array[$x] = "|" Then ContinueLoop
			_GUICtrlListView_AddItem($Einstellungen_AutoItIncludes_Verwalten_Listview, $Pfade_Array[$x], 1)
		Next
	EndIf
	_GUICtrlListView_EndUpdate($Einstellungen_AutoItIncludes_Verwalten_Listview)
EndFunc   ;==>_Lade_Weitere_Includes_in_Listview

Func _Speichere_Weitere_Includes_in_Config()
	Local $Fertiger_String = ""
	For $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_AutoItIncludes_Verwalten_Listview)
		If _GUICtrlListView_GetItemText($Einstellungen_AutoItIncludes_Verwalten_Listview, $x) = "" Then ContinueLoop
		$Fertiger_String = $Fertiger_String & _GUICtrlListView_GetItemText($Einstellungen_AutoItIncludes_Verwalten_Listview, $x) & "|"
	Next
	If StringRight($Fertiger_String, 1) = "|" Then $Fertiger_String = StringTrimRight($Fertiger_String, 1)
	_Write_in_Config("additional_includes_paths", $Fertiger_String)
EndFunc   ;==>_Speichere_Weitere_Includes_in_Config

Func _Einstellungen_Skript_Editor_Dateitypen_in_Listview_Laden()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_Skripteditor_Dateitypen_Listview))
	$Dateityp_Array = StringSplit($Skript_Editor_Dateitypen_Liste, "|", 2)
	_GUICtrlListView_BeginUpdate($Einstellungen_Skripteditor_Dateitypen_Listview)
	If IsArray($Dateityp_Array) Then
		For $x = 0 To UBound($Dateityp_Array) - 1
			If $Dateityp_Array[$x] = "" Then ContinueLoop
			If $Dateityp_Array[$x] = "|" Then ContinueLoop
			_GUICtrlListView_AddItem($Einstellungen_Skripteditor_Dateitypen_Listview, $Dateityp_Array[$x], 101)
		Next
	EndIf

	_GUICtrlListView_RegisterSortCallBack($Einstellungen_Skripteditor_Dateitypen_Listview)
	_GUICtrlListView_SortItems($Einstellungen_Skripteditor_Dateitypen_Listview, 0)
	_GUICtrlListView_EndUpdate($Einstellungen_Skripteditor_Dateitypen_Listview)
	_GUICtrlListView_UnRegisterSortCallBack($Einstellungen_Skripteditor_Dateitypen_Listview)
EndFunc   ;==>_Einstellungen_Skript_Editor_Dateitypen_in_Listview_Laden

Func _Einstellungen_Skript_Editor_Dateitypen_String_aus_Listview_Laden()
	Local $Fertiger_String = ""
	For $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_Skripteditor_Dateitypen_Listview)
		If _GUICtrlListView_GetItemText($Einstellungen_Skripteditor_Dateitypen_Listview, $x) = "" Then ContinueLoop
		$Fertiger_String = $Fertiger_String & _GUICtrlListView_GetItemText($Einstellungen_Skripteditor_Dateitypen_Listview, $x) & "|"
	Next
	If StringRight($Fertiger_String, 1) = "|" Then $Fertiger_String = StringTrimRight($Fertiger_String, 1)
	Return $Fertiger_String
EndFunc   ;==>_Einstellungen_Skript_Editor_Dateitypen_String_aus_Listview_Laden

Func _Weitere_Includes_Pfad_hinzufuegen()
	$Ordnerpfad = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	If $Ordnerpfad = "" Or @error Then Return
	FileChangeDir(@ScriptDir)
	If Not _IsDir($Ordnerpfad) Then Return
	If _WinAPI_PathIsRoot($Ordnerpfad) Then Return
	If _GUICtrlListView_FindText($Einstellungen_AutoItIncludes_Verwalten_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad), -1) = -1 Then _GUICtrlListView_AddItem($Einstellungen_AutoItIncludes_Verwalten_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad), 1)
EndFunc   ;==>_Weitere_Includes_Pfad_hinzufuegen

Func _Weitere_Includes_Pfad_entfernen()
	If _GUICtrlListView_GetSelectionMark($Einstellungen_AutoItIncludes_Verwalten_Listview) = -1 Then Return
	_GUICtrlListView_DeleteItem($Einstellungen_AutoItIncludes_Verwalten_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_AutoItIncludes_Verwalten_Listview))
	_GUICtrlListView_SetItemSelected($Einstellungen_AutoItIncludes_Verwalten_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_AutoItIncludes_Verwalten_Listview), True, True)
EndFunc   ;==>_Weitere_Includes_Pfad_entfernen


Func _Einstellungen_Skripteditor_Dateityp_entfernen()
	If _GUICtrlListView_GetSelectionMark($Einstellungen_Skripteditor_Dateitypen_Listview) = -1 Then Return
	_GUICtrlListView_DeleteItem($Einstellungen_Skripteditor_Dateitypen_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_Skripteditor_Dateitypen_Listview))
	_GUICtrlListView_SetItemSelected($Einstellungen_Skripteditor_Dateitypen_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_Skripteditor_Dateitypen_Listview), True, True)
EndFunc   ;==>_Einstellungen_Skripteditor_Dateityp_entfernen

Func _Einstellungen_Skripteditor_Dateitypen_default()
	$Skript_Editor_Dateitypen_Liste = $Skript_Editor_Dateitypen_Standard
	_Einstellungen_Skript_Editor_Dateitypen_in_Listview_Laden()
EndFunc   ;==>_Einstellungen_Skripteditor_Dateitypen_default

Func _Einstellungen_Skripteditor_Dateitypen_hinzufuegen()
	$Erweiterung = InputBox( _Get_langstr(1112), _Get_langstr(1113), "", "", -1, -1, Default, Default, 0, $Config_GUI)
	If $Erweiterung = "" Or @error Then Return
	If $Erweiterung = "exe" Then Return
	$Erweiterung = StringStripWS($Erweiterung, 3)
	$Erweiterung = StringReplace($Erweiterung, "*.", "")
	$Erweiterung = StringReplace($Erweiterung, ".", "")
	If _GUICtrlListView_FindInText($Einstellungen_Skripteditor_Dateitypen_Listview, $Erweiterung, -1, False) <> -1 Then Return
	_GUICtrlListView_AddItem($Einstellungen_Skripteditor_Dateitypen_Listview, $Erweiterung, 101)
EndFunc   ;==>_Einstellungen_Skripteditor_Dateitypen_hinzufuegen

Func _Farben_Checkboxevent()
	For $y = 1 To 16
		If (@GUI_CtrlId = Execute("$farben_bold_sh1_" & $y)) Or (@GUI_CtrlId = Execute("$farben_italic_sh1_" & $y)) Or (@GUI_CtrlId = Execute("$farben_underline_sh1_" & $y)) Or (@GUI_CtrlId = Execute("$farben_bold_sh2_" & $y)) Or (@GUI_CtrlId = Execute("$farben_italic_sh2_" & $y)) Or (@GUI_CtrlId = Execute("$farben_underline_sh2_" & $y)) Then _Farben_Aktualisiere_Reihe($y)
	Next
EndFunc   ;==>_Farben_Checkboxevent

Func _Farben_event_waehle_vordergrund()
	For $y = 1 To 16
		If (@GUI_CtrlId = Execute("$farben_vordergrundbt_sh1_" & $y)) Then _Einstellungen_waehle_Vordergrundfarbe($y, 1)
		If (@GUI_CtrlId = Execute("$farben_vordergrundbt_sh2_" & $y)) Then _Einstellungen_waehle_Vordergrundfarbe($y, 2)
	Next
EndFunc   ;==>_Farben_event_waehle_vordergrund

Func _Farben_event_waehle_hintergrund()
	For $y = 1 To 16
		If (@GUI_CtrlId = Execute("$farben_hintergrundbt_sh1_" & $y)) Then _Einstellungen_waehle_Hintergrundfarbe($y, 1)
		If (@GUI_CtrlId = Execute("$farben_hintergrundbt_sh2_" & $y)) Then _Einstellungen_waehle_Hintergrundfarbe($y, 2)
	Next
EndFunc   ;==>_Farben_event_waehle_hintergrund



Func _Einstellungen_waehle_Vordergrundfarbe($Reihe = 0, $Sh = 0)
	If $Reihe = 0 Then Return
	If $Sh = 0 Then Return
	$res = _ChooseColor(2, GUICtrlRead(Execute("$farben_vordergrund_sh" & $Sh & "_" & $Reihe)), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetBkColor(Execute("$farben_vordergrund_sh" & $Sh & "_" & $Reihe), $res)
	GUICtrlSetColor(Execute("$farben_vordergrund_sh" & $Sh & "_" & $Reihe), $res)
	GUICtrlSetData(Execute("$farben_vordergrund_sh" & $Sh & "_" & $Reihe), $res)
	_Farben_Aktualisiere_Reihe($Reihe)
EndFunc   ;==>_Einstellungen_waehle_Vordergrundfarbe

Func _Einstellungen_waehle_Hintergrundfarbe($Reihe = 0, $Sh = 0)
	If $Reihe = 0 Then Return
	If $Sh = 0 Then Return
	If GUICtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then
		_Input_Error_FX($einstellungen_farben_hintergrund_fuer_alle_checkbox)
		Return
	EndIf
	$res = _ChooseColor(2, GUICtrlRead(Execute("$farben_hintergrund_sh" & $Sh & "_" & $Reihe)), 2, $Config_GUI)
	If $res = -1 Then Return
	GUICtrlSetBkColor(Execute("$farben_hintergrund_sh" & $Sh & "_" & $Reihe), $res)
	GUICtrlSetColor(Execute("$farben_hintergrund_sh" & $Sh & "_" & $Reihe), $res)
	GUICtrlSetData(Execute("$farben_hintergrund_sh" & $Sh & "_" & $Reihe), $res)
	_Farben_Aktualisiere_Reihe($Reihe)
EndFunc   ;==>_Einstellungen_waehle_Hintergrundfarbe

Func _farbeinstellungen_toggle_hintergrund_fuer_alle()
	If GUICtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then
		_Farbeinstellungen_Hintergrundfarbe_fuer_alle_uebernehmen()
	EndIf
EndFunc   ;==>_farbeinstellungen_toggle_hintergrund_fuer_alle

Func _Farbeinstellungen_Hintergrundfarbe_fuer_alle_uebernehmen()
	$Farbe = GUICtrlRead($darstellung_scripteditor_bgcolour)
	For $y = 1 To 16
		GUICtrlSetBkColor(Execute("$farben_hintergrund_sh1_" & $y), $Farbe)
		GUICtrlSetColor(Execute("$farben_hintergrund_sh1_" & $y), $Farbe)
		GUICtrlSetData(Execute("$farben_hintergrund_sh1_" & $y), $Farbe)
		GUICtrlSetBkColor(Execute("$farben_hintergrund_sh2_" & $y), $Farbe)
		GUICtrlSetColor(Execute("$farben_hintergrund_sh2_" & $y), $Farbe)
		GUICtrlSetData(Execute("$farben_hintergrund_sh2_" & $y), $Farbe)
		GUICtrlSetColor(Execute("$farben_label_sh1_" & $y), GUICtrlRead(Execute("$farben_vordergrund_sh1_" & $y)))
		GUICtrlSetBkColor(Execute("$farben_label_sh1_" & $y), GUICtrlRead(Execute("$farben_hintergrund_sh1_" & $y)))
		GUICtrlSetColor(Execute("$farben_label_sh2_" & $y), GUICtrlRead(Execute("$farben_vordergrund_sh2_" & $y)))
		GUICtrlSetBkColor(Execute("$farben_label_sh2_" & $y), GUICtrlRead(Execute("$farben_hintergrund_sh2_" & $y)))
	Next
EndFunc   ;==>_Farbeinstellungen_Hintergrundfarbe_fuer_alle_uebernehmen


Func _Farben_Aktualisiere_Reihe($Reihe = 0)
	If $Reihe = 0 Then Return
	GUICtrlSetColor(Execute("$farben_label_sh1_" & $Reihe), GUICtrlRead(Execute("$farben_vordergrund_sh1_" & $Reihe)))
	GUICtrlSetBkColor(Execute("$farben_label_sh1_" & $Reihe), GUICtrlRead(Execute("$farben_hintergrund_sh1_" & $Reihe)))
	GUICtrlSetColor(Execute("$farben_label_sh2_" & $Reihe), GUICtrlRead(Execute("$farben_vordergrund_sh2_" & $Reihe)))
	GUICtrlSetBkColor(Execute("$farben_label_sh2_" & $Reihe), GUICtrlRead(Execute("$farben_hintergrund_sh2_" & $Reihe)))


	If GUICtrlRead(Execute("$farben_bold_sh1_" & $Reihe)) = $GUI_CHECKED Then
		$Bold1 = 800
	Else
		$Bold1 = 400
	EndIf

	If GUICtrlRead(Execute("$farben_bold_sh2_" & $Reihe)) = $GUI_CHECKED Then
		$Bold2 = 800
	Else
		$Bold2 = 400
	EndIf

	$attribute1 = 0
	If GUICtrlRead(Execute("$farben_italic_sh1_" & $Reihe)) = $GUI_CHECKED Then $attribute1 = $attribute1 + 2
	If GUICtrlRead(Execute("$farben_underline_sh1_" & $Reihe)) = $GUI_CHECKED Then $attribute1 = $attribute1 + 4


	$attribute2 = 0
	If GUICtrlRead(Execute("$farben_italic_sh2_" & $Reihe)) = $GUI_CHECKED Then $attribute2 = $attribute2 + 2
	If GUICtrlRead(Execute("$farben_underline_sh2_" & $Reihe)) = $GUI_CHECKED Then $attribute2 = $attribute2 + 4


	GUICtrlSetFont(Execute("$farben_label_sh1_" & $Reihe), 11, $Bold1, $attribute1, GUICtrlRead($darstellung_scripteditor_font))
	GUICtrlSetFont(Execute("$farben_label_sh2_" & $Reihe), 11, $Bold2, $attribute2, GUICtrlRead($darstellung_scripteditor_font))
EndFunc   ;==>_Farben_Aktualisiere_Reihe


Func _Einstellungen_Lade_Farben()
	For $x = 1 To 16
		$Zulesender_String1 = Execute("$SCE_AU3_STYLE" & $x & "a")
		$Zulesender_String2 = Execute("$SCE_AU3_STYLE" & $x & "b")
		If $Zulesender_String1 <> "" And $Zulesender_String2 <> "" Then
			$Split1 = StringSplit($Zulesender_String1, "|", 2)
			$Split2 = StringSplit($Zulesender_String2, "|", 2)
			If UBound($Split1) - 1 = 4 And UBound($Split2) - 1 = 4 Then ;Nur bei korrekter Anzahl an Splits

				;Label
				GUICtrlSetColor(Execute("$farben_label_sh1_" & $x), _BGR_to_RGB($Split1[0]))
				If GUICtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then
					GUICtrlSetBkColor(Execute("$farben_label_sh1_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
				Else
					GUICtrlSetBkColor(Execute("$farben_label_sh1_" & $x), _BGR_to_RGB($Split1[1]))
				EndIf

				GUICtrlSetColor(Execute("$farben_label_sh2_" & $x), _BGR_to_RGB($Split2[0]))
				If GUICtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then
					GUICtrlSetBkColor(Execute("$farben_label_sh2_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
				Else
					GUICtrlSetBkColor(Execute("$farben_label_sh2_" & $x), _BGR_to_RGB($Split2[1]))
				EndIf

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

				GUICtrlSetFont(Execute("$farben_label_sh1_" & $x), 11, $Bold1, $attribute1, GUICtrlRead($darstellung_scripteditor_font))
				GUICtrlSetFont(Execute("$farben_label_sh2_" & $x), 11, $Bold2, $attribute2, GUICtrlRead($darstellung_scripteditor_font))

				;Checkboxen
				If $Split1[2] = 1 Then
					GUICtrlSetState(Execute("$farben_bold_sh1_" & $x), $GUI_CHECKED)
				Else
					GUICtrlSetState(Execute("$farben_bold_sh1_" & $x), $GUI_UNCHECKED)
				EndIf

				If $Split1[3] = 1 Then
					GUICtrlSetState(Execute("$farben_italic_sh1_" & $x), $GUI_CHECKED)
				Else
					GUICtrlSetState(Execute("$farben_italic_sh1_" & $x), $GUI_UNCHECKED)
				EndIf

				If $Split1[4] = 1 Then
					GUICtrlSetState(Execute("$farben_underline_sh1_" & $x), $GUI_CHECKED)
				Else
					GUICtrlSetState(Execute("$farben_underline_sh1_" & $x), $GUI_UNCHECKED)
				EndIf

				If $Split2[2] = 1 Then
					GUICtrlSetState(Execute("$farben_bold_sh2_" & $x), $GUI_CHECKED)
				Else
					GUICtrlSetState(Execute("$farben_bold_sh2_" & $x), $GUI_UNCHECKED)
				EndIf

				If $Split2[3] = 1 Then
					GUICtrlSetState(Execute("$farben_italic_sh2_" & $x), $GUI_CHECKED)
				Else
					GUICtrlSetState(Execute("$farben_italic_sh2_" & $x), $GUI_UNCHECKED)
				EndIf

				If $Split2[4] = 1 Then
					GUICtrlSetState(Execute("$farben_underline_sh2_" & $x), $GUI_CHECKED)
				Else
					GUICtrlSetState(Execute("$farben_underline_sh2_" & $x), $GUI_UNCHECKED)
				EndIf

				;Vordergrundfarbe
				GUICtrlSetBkColor(Execute("$farben_vordergrund_sh1_" & $x), _BGR_to_RGB($Split1[0]))
				GUICtrlSetColor(Execute("$farben_vordergrund_sh1_" & $x), _BGR_to_RGB($Split1[0]))
				GUICtrlSetData(Execute("$farben_vordergrund_sh1_" & $x), _BGR_to_RGB($Split1[0]))
				GUICtrlSetBkColor(Execute("$farben_vordergrund_sh2_" & $x), _BGR_to_RGB($Split2[0]))
				GUICtrlSetColor(Execute("$farben_vordergrund_sh2_" & $x), _BGR_to_RGB($Split2[0]))
				GUICtrlSetData(Execute("$farben_vordergrund_sh2_" & $x), _BGR_to_RGB($Split2[0]))

				;Hintergrundgrundfarbe
				If GUICtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then
					GUICtrlSetBkColor(Execute("$farben_hintergrund_sh1_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
					GUICtrlSetColor(Execute("$farben_hintergrund_sh1_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
					GUICtrlSetData(Execute("$farben_hintergrund_sh1_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
					GUICtrlSetBkColor(Execute("$farben_hintergrund_sh2_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
					GUICtrlSetColor(Execute("$farben_hintergrund_sh2_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
					GUICtrlSetData(Execute("$farben_hintergrund_sh2_" & $x), GUICtrlRead($darstellung_scripteditor_bgcolour))
				Else
					GUICtrlSetBkColor(Execute("$farben_hintergrund_sh1_" & $x), _BGR_to_RGB($Split1[1]))
					GUICtrlSetColor(Execute("$farben_hintergrund_sh1_" & $x), _BGR_to_RGB($Split1[1]))
					GUICtrlSetData(Execute("$farben_hintergrund_sh1_" & $x), _BGR_to_RGB($Split1[1]))
					GUICtrlSetBkColor(Execute("$farben_hintergrund_sh2_" & $x), _BGR_to_RGB($Split2[1]))
					GUICtrlSetColor(Execute("$farben_hintergrund_sh2_" & $x), _BGR_to_RGB($Split2[1]))
					GUICtrlSetData(Execute("$farben_hintergrund_sh2_" & $x), _BGR_to_RGB($Split2[1]))
				EndIf

			EndIf
		EndIf
	Next
EndFunc   ;==>_Einstellungen_Lade_Farben

Func _Speichere_Farbeinstellungen()
	For $x = 1 To 16
		;Reset
		$Farbstring_sh1 = ""
		$Farbstring_sh2 = ""

		;Farben
		$Farbstring_sh1 = $Farbstring_sh1 & _RGB_to_BGR("0x" & Hex(GUICtrlRead(Execute("$farben_vordergrund_sh1_" & $x)), 6)) & "|"
		$Farbstring_sh1 = $Farbstring_sh1 & _RGB_to_BGR("0x" & Hex(GUICtrlRead(Execute("$farben_hintergrund_sh1_" & $x)), 6)) & "|"

		$Farbstring_sh2 = $Farbstring_sh2 & _RGB_to_BGR("0x" & Hex(GUICtrlRead(Execute("$farben_vordergrund_sh2_" & $x)), 6)) & "|"
		$Farbstring_sh2 = $Farbstring_sh2 & _RGB_to_BGR("0x" & Hex(GUICtrlRead(Execute("$farben_hintergrund_sh2_" & $x)), 6)) & "|"


		;Bold
		If GUICtrlRead(Execute("$farben_bold_sh1_" & $x)) = $GUI_CHECKED Then
			$Farbstring_sh1 = $Farbstring_sh1 & "1|"
		Else
			$Farbstring_sh1 = $Farbstring_sh1 & "0|"
		EndIf

		If GUICtrlRead(Execute("$farben_bold_sh2_" & $x)) = $GUI_CHECKED Then
			$Farbstring_sh2 = $Farbstring_sh2 & "1|"
		Else
			$Farbstring_sh2 = $Farbstring_sh2 & "0|"
		EndIf


		;Italic
		If GUICtrlRead(Execute("$farben_italic_sh1_" & $x)) = $GUI_CHECKED Then
			$Farbstring_sh1 = $Farbstring_sh1 & "1|"
		Else
			$Farbstring_sh1 = $Farbstring_sh1 & "0|"
		EndIf

		If GUICtrlRead(Execute("$farben_italic_sh2_" & $x)) = $GUI_CHECKED Then
			$Farbstring_sh2 = $Farbstring_sh2 & "1|"
		Else
			$Farbstring_sh2 = $Farbstring_sh2 & "0|"
		EndIf

		;underline
		If GUICtrlRead(Execute("$farben_underline_sh1_" & $x)) = $GUI_CHECKED Then
			$Farbstring_sh1 = $Farbstring_sh1 & "1"
		Else
			$Farbstring_sh1 = $Farbstring_sh1 & "0"
		EndIf

		If GUICtrlRead(Execute("$farben_underline_sh2_" & $x)) = $GUI_CHECKED Then
			$Farbstring_sh2 = $Farbstring_sh2 & "1"
		Else
			$Farbstring_sh2 = $Farbstring_sh2 & "0"
		EndIf

		;Hole config section
		$section_sh1 = ""
		$section_sh2 = ""

		Switch $x
			Case 1
				$section_sh1 = "AU3_DEFAULT_STYLE1"
				$section_sh2 = "AU3_DEFAULT_STYLE2"
				$SCE_AU3_STYLE1a = $Farbstring_sh1
				$SCE_AU3_STYLE1b = $Farbstring_sh2
			Case 2
				$section_sh1 = "AU3_COMMENT_STYLE1"
				$section_sh2 = "AU3_COMMENT_STYLE2"
				$SCE_AU3_STYLE2a = $Farbstring_sh1
				$SCE_AU3_STYLE2b = $Farbstring_sh2
			Case 3
				$section_sh1 = "AU3_COMMENTBLOCK_STYLE1"
				$section_sh2 = "AU3_COMMENTBLOCK_STYLE2"
				$SCE_AU3_STYLE3a = $Farbstring_sh1
				$SCE_AU3_STYLE3b = $Farbstring_sh2
			Case 4
				$section_sh1 = "AU3_NUMBER_STYLE1"
				$section_sh2 = "AU3_NUMBER_STYLE2"
				$SCE_AU3_STYLE4a = $Farbstring_sh1
				$SCE_AU3_STYLE4b = $Farbstring_sh2
			Case 5
				$section_sh1 = "AU3_FUNCTION_STYLE1"
				$section_sh2 = "AU3_FUNCTION_STYLE2"
				$SCE_AU3_STYLE5a = $Farbstring_sh1
				$SCE_AU3_STYLE5b = $Farbstring_sh2
			Case 6
				$section_sh1 = "AU3_KEYWORD_STYLE1"
				$section_sh2 = "AU3_KEYWORD_STYLE2"
				$SCE_AU3_STYLE6a = $Farbstring_sh1
				$SCE_AU3_STYLE6b = $Farbstring_sh2
			Case 7
				$section_sh1 = "AU3_MACRO_STYLE1"
				$section_sh2 = "AU3_MACRO_STYLE2"
				$SCE_AU3_STYLE7a = $Farbstring_sh1
				$SCE_AU3_STYLE7b = $Farbstring_sh2
			Case 8
				$section_sh1 = "AU3_STRING_STYLE1"
				$section_sh2 = "AU3_STRING_STYLE2"
				$SCE_AU3_STYLE8a = $Farbstring_sh1
				$SCE_AU3_STYLE8b = $Farbstring_sh2
			Case 9
				$section_sh1 = "AU3_OPERATOR_STYLE1"
				$section_sh2 = "AU3_OPERATOR_STYLE2"
				$SCE_AU3_STYLE9a = $Farbstring_sh1
				$SCE_AU3_STYLE9b = $Farbstring_sh2
			Case 10
				$section_sh1 = "AU3_VARIABLE_STYLE1"
				$section_sh2 = "AU3_VARIABLE_STYLE2"
				$SCE_AU3_STYLE10a = $Farbstring_sh1
				$SCE_AU3_STYLE10b = $Farbstring_sh2
			Case 11
				$section_sh1 = "AU3_SENT_STYLE1"
				$section_sh2 = "AU3_SENT_STYLE2"
				$SCE_AU3_STYLE11a = $Farbstring_sh1
				$SCE_AU3_STYLE11b = $Farbstring_sh2
			Case 12
				$section_sh1 = "AU3_PREPROCESSOR_STYLE1"
				$section_sh2 = "AU3_PREPROCESSOR_STYLE2"
				$SCE_AU3_STYLE12a = $Farbstring_sh1
				$SCE_AU3_STYLE12b = $Farbstring_sh2
			Case 13
				$section_sh1 = "AU3_SPECIAL_STYLE1"
				$section_sh2 = "AU3_SPECIAL_STYLE2"
				$SCE_AU3_STYLE13a = $Farbstring_sh1
				$SCE_AU3_STYLE13b = $Farbstring_sh2
			Case 14
				$section_sh1 = "AU3_EXPAND_STYLE1"
				$section_sh2 = "AU3_EXPAND_STYLE2"
				$SCE_AU3_STYLE14a = $Farbstring_sh1
				$SCE_AU3_STYLE14b = $Farbstring_sh2
			Case 15
				$section_sh1 = "AU3_COMOBJ_STYLE1"
				$section_sh2 = "AU3_COMOBJ_STYLE2"
				$SCE_AU3_STYLE15a = $Farbstring_sh1
				$SCE_AU3_STYLE15b = $Farbstring_sh2
			Case 16
				$section_sh1 = "AU3_UDF_STYLE1"
				$section_sh2 = "AU3_UDF_STYLE2"
				$SCE_AU3_STYLE16a = $Farbstring_sh1
				$SCE_AU3_STYLE16b = $Farbstring_sh2
		EndSwitch

		;Schreibe in config
		_Write_in_Config($section_sh1, $Farbstring_sh1)
		_Write_in_Config($section_sh2, $Farbstring_sh2)
	Next
EndFunc   ;==>_Speichere_Farbeinstellungen

Func _farbeinstellungen_auf_Standard_vorbereiten()
	_farbeinstellungen_zuruecksetzen()
EndFunc   ;==>_farbeinstellungen_auf_Standard_vorbereiten

Func _farbeinstellungen_fuer_dark_theme_vorbereiten()
	GUICtrlSetData($darstellung_scripteditor_font, "Consolas")
	GUICtrlSetData($darstellung_scripteditor_size, "10")
	GUICtrlSetData($darstellung_scripteditor_bgcolour, "0x1F1F1F")
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute(0x1F1F1F)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, 0x1F1F1F)
	_Write_in_Config("scripteditor_bgcolour", "0x1F1F1F")
	GUICtrlSetData($darstellung_scripteditor_rowcolour, "0x585858")
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute(0x585858)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, 0x585858)
	_Write_in_Config("scripteditor_rowcolour", "0x585858")
	GUICtrlSetData($darstellung_scripteditor_marccolour, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, 0xFFFFFF)
	_Write_in_Config("scripteditor_marccolour", "0xFFFFFF")
	GUICtrlSetData($darstellung_scripteditor_highlightcolour, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, 0xFFFFFF)
	_Write_in_Config("scripteditor_highlightcolour", "0xFFFFFF")
	GUICtrlSetData($darstellung_scripteditor_errorcolor, "0xa50000")
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute(0xa50000)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, 0xa50000)
	_Write_in_Config("scripteditor_errorcolour", "0xa50000")
	GUICtrlSetData($darstellung_scripteditor_cursorcolor, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, 0xFFFFFF)
	_Write_in_Config("scripteditor_caretcolour", "0xFFFFFF")
	GUICtrlSetState($einstellungen_farben_hintergrund_fuer_alle_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Checkbox_use_new_colours, $GUI_UNCHECKED)
	GUICtrlSetData($darstellung_scripteditor_cursorwidth, 1)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio1, $GUI_CHECKED)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio2, $GUI_UNCHECKED)

	GUICtrlSetData($setting_scripteditor_bracelight_colour, "0x00A404")
	GUICtrlSetColor($setting_scripteditor_bracelight_colour, _ColourInvert(Execute(0x00A404)))
	GUICtrlSetBkColor($setting_scripteditor_bracelight_colour, 0x00A404)
	_Write_in_Config("scripteditor_bracelight_colour", "0x00A404")

	GUICtrlSetData($settings_scripteditor_bracebad_colour, "0xA71F1F")
	GUICtrlSetColor($settings_scripteditor_bracebad_colour, _ColourInvert(Execute(0xA71F1F)))
	GUICtrlSetBkColor($settings_scripteditor_bracebad_colour, 0xA71F1F)
	_Write_in_Config("scripteditor_bracebad_colour", "0xA71F1F")

	GUICtrlSetData($darstellung_treefont_colour, "0xFFFFFF")
	_Write_in_Config("treefont_colour", "0xFFFFFF")
	$treefont_colour = "0xFFFFFF"



	_Write_in_Config("AU3_DEFAULT_STYLE1", "0xC8C8C8|0x1F1F1F|0|0|0")
	_Write_in_Config("AU3_DEFAULT_STYLE2", "0xC8C8C8|0x1F1F1F|0|0|0")
	_Write_in_Config("AU3_COMMENT_STYLE1", "0x23BC4C|0x1F1F1F|0|1|0")
	_Write_in_Config("AU3_COMMENT_STYLE2", "0x23BC4C|0x1F1F1F|0|0|0")
	_Write_in_Config("AU3_COMMENTBLOCK_STYLE1", "0x23BC4C|0x1F1F1F|0|1|0")
	_Write_in_Config("AU3_COMMENTBLOCK_STYLE2", "0x23BC4C|0x1F1F1F|0|0|0")
	_Write_in_Config("AU3_NUMBER_STYLE1", "0xB5CEA8|0x1F1F1F|1|1|0")
	_Write_in_Config("AU3_NUMBER_STYLE2", "0xB5CEA8|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_FUNCTION_STYLE1", "0xBD63C5|0x1F1F1F|1|1|0")
	_Write_in_Config("AU3_FUNCTION_STYLE2", "0xBD63C5|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_KEYWORD_STYLE1", "0xD69C4E|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_KEYWORD_STYLE2", "0xD69C4E|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_MACRO_STYLE1", "0xBD63C5|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_MACRO_STYLE2", "0xBD63C5|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_STRING_STYLE1", "0x859DD6|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_STRING_STYLE2", "0x859DD6|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_OPERATOR_STYLE1", "0xDCDCDC|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_OPERATOR_STYLE2", "0xDCDCDC|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_VARIABLE_STYLE1", "0xB0C94E|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_VARIABLE_STYLE2", "0xB0C94E|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_SENT_STYLE1", "0xC8C8C8|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_SENT_STYLE2", "0xC8C8C8|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_PREPROCESSOR_STYLE1", "0x9B9B9B|0x1F1F1F|0|1|0")
	_Write_in_Config("AU3_PREPROCESSOR_STYLE2", "0x9B9B9B|0x1F1F1F|0|0|0")
	_Write_in_Config("AU3_SPECIAL_STYLE1", "0xC8C8C8|0x1F1F1F|0|1|0")
	_Write_in_Config("AU3_SPECIAL_STYLE2", "0xC8C8C8|0x1F1F1F|0|1|0")
	_Write_in_Config("AU3_EXPAND_STYLE1", "0xC8C8C8|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_EXPAND_STYLE2", "0xC8C8C8|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_COMOBJ_STYLE1", "0x00FF00|0x1F1F1F|1|1|0")
	_Write_in_Config("AU3_COMOBJ_STYLE2", "0x00FF00|0x1F1F1F|1|0|0")
	_Write_in_Config("AU3_UDF_STYLE1", "0xFF8000|0x1F1F1F|0|1|0")
	_Write_in_Config("AU3_UDF_STYLE2", "0xFF8000|0x1F1F1F|1|0|0")




	;Werte neu einlesen
	$SCE_AU3_STYLE1a = _Config_Read("AU3_DEFAULT_STYLE1", "0x000000|0xFFFFFF|0|0|0")
	$SCE_AU3_STYLE2a = _Config_Read("AU3_COMMENT_STYLE1", "0x339900|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE3a = _Config_Read("AU3_COMMENTBLOCK_STYLE1", "0x009966|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE4a = _Config_Read("AU3_NUMBER_STYLE1", "0xA900AC|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE5a = _Config_Read("AU3_FUNCTION_STYLE1", "0xAA0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE6a = _Config_Read("AU3_KEYWORD_STYLE1", "0xFF0000|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE7a = _Config_Read("AU3_MACRO_STYLE1", "0xFF33FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE8a = _Config_Read("AU3_STRING_STYLE1", "0xCC9999|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE9a = _Config_Read("AU3_OPERATOR_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE10a = _Config_Read("AU3_VARIABLE_STYLE1", "0x000090|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE11a = _Config_Read("AU3_SENT_STYLE1", "0x0080FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE12a = _Config_Read("AU3_PREPROCESSOR_STYLE1", "0xFF00F0|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE13a = _Config_Read("AU3_SPECIAL_STYLE1", "0xF00FA0|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE14a = _Config_Read("AU3_EXPAND_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE15a = _Config_Read("AU3_COMOBJ_STYLE1", "0xFF0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE16a = _Config_Read("AU3_UDF_STYLE1", "0xFF8000|0xFFFFFF|0|1|0")


	$SCE_AU3_STYLE1b = _Config_Read("AU3_DEFAULT_STYLE2", "0x000000|0xFFFFFF|0|0|0")
	$SCE_AU3_STYLE2b = _Config_Read("AU3_COMMENT_STYLE2", "0x339900|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE3b = _Config_Read("AU3_COMMENTBLOCK_STYLE2", "0x009966|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE4b = _Config_Read("AU3_NUMBER_STYLE2", "0xFF0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE5b = _Config_Read("AU3_FUNCTION_STYLE2", "0x900000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE6b = _Config_Read("AU3_KEYWORD_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE7b = _Config_Read("AU3_MACRO_STYLE2", "0x008080|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE8b = _Config_Read("AU3_STRING_STYLE2", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE9b = _Config_Read("AU3_OPERATOR_STYLE2", "0x0080FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE10b = _Config_Read("AU3_VARIABLE_STYLE2", "0x5A5A5A|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE11b = _Config_Read("AU3_SENT_STYLE2", "0x808080|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE12b = _Config_Read("AU3_PREPROCESSOR_STYLE2", "0x008080|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE13b = _Config_Read("AU3_SPECIAL_STYLE2", "0x3C14DC|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE14b = _Config_Read("AU3_EXPAND_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE15b = _Config_Read("AU3_COMOBJ_STYLE2", "0x993399|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE16b = _Config_Read("AU3_UDF_STYLE2", "0xFF8000|0xFFFFFF|0|1|0")
	_Einstellungen_Lade_Farben()
EndFunc   ;==>_farbeinstellungen_fuer_dark_theme_vorbereiten



Func _farbeinstellungen_zuruecksetzen()
	$antwort = MsgBox(32 + 262144 + 4, _Get_langstr(48), _Get_langstr(892), 0, $Config_GUI)
	If $antwort = 7 Then Return
	GUICtrlSetData($darstellung_scripteditor_font, "Courier New")
	GUICtrlSetData($darstellung_scripteditor_size, "10")
	GUICtrlSetData($darstellung_scripteditor_bgcolour, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, 0xFFFFFF)
	GUICtrlSetData($darstellung_scripteditor_rowcolour, "0xFFFED8")
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute(0xFFFED8)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, 0xFFFED8)
	GUICtrlSetData($darstellung_scripteditor_marccolour, "0x3289D0")
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute(0x3289D0)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, 0x3289D0)
	GUICtrlSetData($darstellung_scripteditor_highlightcolour, "0xFF0000")
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute(0xFF0000)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, 0xFF0000)
	GUICtrlSetData($darstellung_scripteditor_errorcolor, "0xFEBDBD")
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute(0xFEBDBD)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, 0xFEBDBD)
	GUICtrlSetData($darstellung_scripteditor_cursorcolor, "0x000000")
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute(0x000000)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, 0x000000)
	GUICtrlSetState($einstellungen_farben_hintergrund_fuer_alle_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Checkbox_use_new_colours, $GUI_UNCHECKED)
	GUICtrlSetData($darstellung_scripteditor_cursorwidth, 1)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio1, $GUI_CHECKED)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio2, $GUI_UNCHECKED)
	GUICtrlSetData($darstellung_treefont_colour, "0x000000")
	GUICtrlSetBkColor($darstellung_treefont_colour, "0x000000")
	GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert(Execute(0x000000)))
	GUICtrlSetData($setting_scripteditor_bracelight_colour, "0xC7FFC8")
	GUICtrlSetColor($setting_scripteditor_bracelight_colour, _ColourInvert(Execute(0xC7FFC8)))
	GUICtrlSetBkColor($setting_scripteditor_bracelight_colour, 0xC7FFC8)
	GUICtrlSetData($settings_scripteditor_bracebad_colour, "0xFFCBCB")
	GUICtrlSetColor($settings_scripteditor_bracebad_colour, _ColourInvert(Execute(0xFFCBCB)))
	GUICtrlSetBkColor($settings_scripteditor_bracebad_colour, 0xFFCBCB)

	$treefont_colour = "0x000000"


	For $x = 1 To 16

		;Hole config section
		$section_sh1 = ""
		$section_sh2 = ""

		Switch $x
			Case 1
				$section_sh1 = "AU3_DEFAULT_STYLE1"
				$section_sh2 = "AU3_DEFAULT_STYLE2"

			Case 2
				$section_sh1 = "AU3_COMMENT_STYLE1"
				$section_sh2 = "AU3_COMMENT_STYLE2"

			Case 3
				$section_sh1 = "AU3_COMMENTBLOCK_STYLE1"
				$section_sh2 = "AU3_COMMENTBLOCK_STYLE2"

			Case 4
				$section_sh1 = "AU3_NUMBER_STYLE1"
				$section_sh2 = "AU3_NUMBER_STYLE2"

			Case 5
				$section_sh1 = "AU3_FUNCTION_STYLE1"
				$section_sh2 = "AU3_FUNCTION_STYLE2"

			Case 6
				$section_sh1 = "AU3_KEYWORD_STYLE1"
				$section_sh2 = "AU3_KEYWORD_STYLE2"

			Case 7
				$section_sh1 = "AU3_MACRO_STYLE1"
				$section_sh2 = "AU3_MACRO_STYLE2"

			Case 8
				$section_sh1 = "AU3_STRING_STYLE1"
				$section_sh2 = "AU3_STRING_STYLE2"

			Case 9
				$section_sh1 = "AU3_OPERATOR_STYLE1"
				$section_sh2 = "AU3_OPERATOR_STYLE2"

			Case 10
				$section_sh1 = "AU3_VARIABLE_STYLE1"
				$section_sh2 = "AU3_VARIABLE_STYLE2"

			Case 11
				$section_sh1 = "AU3_SENT_STYLE1"
				$section_sh2 = "AU3_SENT_STYLE2"

			Case 12
				$section_sh1 = "AU3_PREPROCESSOR_STYLE1"
				$section_sh2 = "AU3_PREPROCESSOR_STYLE2"

			Case 13
				$section_sh1 = "AU3_SPECIAL_STYLE1"
				$section_sh2 = "AU3_SPECIAL_STYLE2"

			Case 14
				$section_sh1 = "AU3_EXPAND_STYLE1"
				$section_sh2 = "AU3_EXPAND_STYLE2"

			Case 15
				$section_sh1 = "AU3_COMOBJ_STYLE1"
				$section_sh2 = "AU3_COMOBJ_STYLE2"

			Case 16
				$section_sh1 = "AU3_UDF_STYLE1"
				$section_sh2 = "AU3_UDF_STYLE2"
		EndSwitch

		IniDelete($Configfile, "config", $section_sh1)
		IniDelete($Configfile, "config", $section_sh2)
	Next

	;Werte neu einlesen
	$SCE_AU3_STYLE1a = _Config_Read("AU3_DEFAULT_STYLE1", "0x000000|0xFFFFFF|0|0|0")
	$SCE_AU3_STYLE2a = _Config_Read("AU3_COMMENT_STYLE1", "0x339900|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE3a = _Config_Read("AU3_COMMENTBLOCK_STYLE1", "0x009966|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE4a = _Config_Read("AU3_NUMBER_STYLE1", "0xA900AC|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE5a = _Config_Read("AU3_FUNCTION_STYLE1", "0xAA0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE6a = _Config_Read("AU3_KEYWORD_STYLE1", "0xFF0000|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE7a = _Config_Read("AU3_MACRO_STYLE1", "0xFF33FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE8a = _Config_Read("AU3_STRING_STYLE1", "0xCC9999|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE9a = _Config_Read("AU3_OPERATOR_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE10a = _Config_Read("AU3_VARIABLE_STYLE1", "0x000090|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE11a = _Config_Read("AU3_SENT_STYLE1", "0x0080FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE12a = _Config_Read("AU3_PREPROCESSOR_STYLE1", "0xFF00F0|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE13a = _Config_Read("AU3_SPECIAL_STYLE1", "0xF00FA0|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE14a = _Config_Read("AU3_EXPAND_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE15a = _Config_Read("AU3_COMOBJ_STYLE1", "0xFF0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE16a = _Config_Read("AU3_UDF_STYLE1", "0xFF8000|0xFFFFFF|0|1|0")


	$SCE_AU3_STYLE1b = _Config_Read("AU3_DEFAULT_STYLE2", "0x000000|0xFFFFFF|0|0|0")
	$SCE_AU3_STYLE2b = _Config_Read("AU3_COMMENT_STYLE2", "0x339900|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE3b = _Config_Read("AU3_COMMENTBLOCK_STYLE2", "0x009966|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE4b = _Config_Read("AU3_NUMBER_STYLE2", "0xFF0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE5b = _Config_Read("AU3_FUNCTION_STYLE2", "0x900000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE6b = _Config_Read("AU3_KEYWORD_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE7b = _Config_Read("AU3_MACRO_STYLE2", "0x008080|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE8b = _Config_Read("AU3_STRING_STYLE2", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE9b = _Config_Read("AU3_OPERATOR_STYLE2", "0x0080FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE10b = _Config_Read("AU3_VARIABLE_STYLE2", "0x5A5A5A|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE11b = _Config_Read("AU3_SENT_STYLE2", "0x808080|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE12b = _Config_Read("AU3_PREPROCESSOR_STYLE2", "0x008080|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE13b = _Config_Read("AU3_SPECIAL_STYLE2", "0x3C14DC|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE14b = _Config_Read("AU3_EXPAND_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE15b = _Config_Read("AU3_COMOBJ_STYLE2", "0x993399|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE16b = _Config_Read("AU3_UDF_STYLE2", "0xFF8000|0xFFFFFF|0|1|0")
	_Einstellungen_Lade_Farben()
EndFunc   ;==>_farbeinstellungen_zuruecksetzen

Func _Konfiguration_Exportieren_Zeige_GUI()
	GUISetState(@SW_SHOW, $konfiguration_exportiern_GUI)
	GUISetState(@SW_DISABLE, $Config_GUI)
EndFunc   ;==>_Konfiguration_Exportieren_Zeige_GUI

Func _Konfiguration_Exportieren_verstecke_GUI()
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_HIDE, $konfiguration_exportiern_GUI)
EndFunc   ;==>_Konfiguration_Exportieren_verstecke_GUI

Func _Konfiguration_Exportieren()
	_Konfiguration_Exportieren_verstecke_GUI()
	$Datei = FileSaveDialog(_Get_langstr(313), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 18, "config.ini", $config_gui)
	FileChangeDir(@ScriptDir)
	If $Datei = "" Then Return
	If @error > 0 Then Return
	FileCopy($Configfile, $Datei, 8 + 1)
	If GUICtrlRead($konfiguration_exportiern_GUI_checkbox) = $GUI_UNCHECKED Then ;Lösche einige Elemente wie Programmpfade usw.
		IniDelete($Datei, "config", "autoitexe")
		IniDelete($Datei, "config", "helpfileexe")
		IniDelete($Datei, "config", "autoit2exe")
		IniDelete($Datei, "config", "lastproject")
		IniDelete($Datei, "config", "templatefolder")
		IniDelete($Datei, "config", "releasefolder")
		IniDelete($Datei, "config", "projectfolder")
		IniDelete($Datei, "config", "backupfolder")
		IniDelete($Datei, "config", "pluginsdir")
		IniDelete($Datei, "history")
	EndIf
	IniDelete($Datei, "config", "startups")
	IniDelete($Datei, "config", "SciTE4AutoIt_au3mode")
	IniDelete($Datei, "trophies") ;Trophän nie in die ini exportieren
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $config_gui)
EndFunc   ;==>_Konfiguration_Exportieren

Func _Konfiguration_Importieren()
	If $Offenes_Projekt <> "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(930), 0, $config_gui)
		Return
	EndIf
	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(931), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $config_gui)
	Else
		$var = FileOpenDialog(_Get_langstr(931), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 1 + 2, "", $config_gui)
	EndIf
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then Return

	$sections = IniReadSectionNames($var)
	If @error Then Return
	If Not _ArraySearch($sections, "config") Then Return
	For $x = 1 To $sections[0]
		$Werte_der_Section = IniReadSection($var, $sections[$x])
		For $y = 1 To $Werte_der_Section[0][0]
			IniWrite($Configfile, $sections[$x], $Werte_der_Section[$y][0], $Werte_der_Section[$y][1])
		Next
	Next
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(929), 0, $config_gui)
	AdlibRegister("_exit", 1) ;Beende das ISN
EndFunc   ;==>_Konfiguration_Importieren


Func _Immer_am_primaeren_monitor_starten_Toggle_Checkbox()
	If GUICtrlRead($_Immer_am_primaeren_monitor_starten_checkbox) = $GUI_Checked Then
		GUICtrlSetState($darstellung_monitordropdown, $GUI_DISABLE)
	Else
		GUICtrlSetState($darstellung_monitordropdown, $GUI_ENABLE)
	EndIf

	If GUICtrlRead($programmeinstellungen_Darstellung_HighDPIMode_Checkbox) = $GUI_Checked Then
		GUICtrlSetState($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox, $GUI_ENABLE)
		GUICtrlSetState($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox, $GUI_ENABLE)

		If GUICtrlRead($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox) = $GUI_Checked Then
			GUICtrlSetState($programmeinstellungen_DPI_Slider, $GUI_ENABLE)
			GUICtrlSetState($programmeinstellungen_DPI_Slider_Label, $GUI_ENABLE)
		Else
			GUICtrlSetState($programmeinstellungen_DPI_Slider, $GUI_DISABLE)
			GUICtrlSetState($programmeinstellungen_DPI_Slider_Label, $GUI_DISABLE)
		EndIf


	Else
		GUICtrlSetState($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox, $GUI_DISABLE)
		GUICtrlSetState($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox, $GUI_DISABLE)
		GUICtrlSetState($programmeinstellungen_DPI_Slider, $GUI_DISABLE)
		GUICtrlSetState($programmeinstellungen_DPI_Slider_Label, $GUI_DISABLE)
	EndIf


EndFunc   ;==>_Immer_am_primaeren_monitor_starten_Toggle_Checkbox




Func _Einstellungen_Toolbar_ItemID_zu_Listview($handle = "", $ID = "")
	If $handle = "" Then Return
	If $ID = "" Then Return

	Switch $ID

		Case "#tbar_newfile#"
			;Neue Datei
			_GUICtrlListView_AddItem($handle, _Get_langstr(70), 0)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_newfolder#"
			;Neuer Ordner
			_GUICtrlListView_AddItem($handle, _Get_langstr(71), 1)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_importfile#"
			;Dateien importiern
			_GUICtrlListView_AddItem($handle, _Get_langstr(72), 2)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_importfolder#"
			;Ordner importiern
			_GUICtrlListView_AddItem($handle, _Get_langstr(455), 3)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_export#"
			;Datei exportiern
			_GUICtrlListView_AddItem($handle, _Get_langstr(73), 4)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_deletefile#"
			;Datei löschen
			_GUICtrlListView_AddItem($handle, _Get_langstr(74), 5)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_refreshprojecttree#"
			;Projektbaum aktualisieren
			_GUICtrlListView_AddItem($handle, _Get_langstr(53), 6)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_fullscreen#"
			;Vollbild
			_GUICtrlListView_AddItem($handle, _Get_langstr(457), 20)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_sep#"
			;Abstand (Seperator)
			_GUICtrlListView_AddItem($handle, _Get_langstr(957), 10)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_testproject#"
			;Projekt testen
			_GUICtrlListView_AddItem($handle, _Get_langstr(489), 7)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_compile#"
			;Projekt kompilieren
			_GUICtrlListView_AddItem($handle, _Get_langstr(52), 8)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macros#"
			;Makros
			_GUICtrlListView_AddItem($handle, _Get_langstr(519), 22)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_projectproberties#"
			;Projekteigenschaften
			_GUICtrlListView_AddItem($handle, _Get_langstr(51), 9)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_save#"
			;Speichern
			_GUICtrlListView_AddItem($handle, _Get_langstr(9), 11)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_saveall#"
			;Alle Tabs Speichern
			_GUICtrlListView_AddItem($handle, _Get_langstr(650), 29)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_closetab#"
			;Tab schließen
			_GUICtrlListView_AddItem($handle, _Get_langstr(31), 14)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_undo#"
			;Rückgängig
			_GUICtrlListView_AddItem($handle, _Get_langstr(55), 12)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_redo#"
			;Wiederholen
			_GUICtrlListView_AddItem($handle, _Get_langstr(56), 13)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_testscript#"
			;Skript testen
			_GUICtrlListView_AddItem($handle, _Get_langstr(82), 15)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_stopproject#"
			;Skript stoppen
			_GUICtrlListView_AddItem($handle, _Get_langstr(106), 17)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_search#"
			;suche
			_GUICtrlListView_AddItem($handle, _Get_langstr(87), 16)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_syntaxcheck#"
			;Syntaxcheck
			_GUICtrlListView_AddItem($handle, _Get_langstr(108), 18)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_tidy#"
			;Tidy
			_GUICtrlListView_AddItem($handle, _Get_langstr(327), 19)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_commentout#"
			;Auskommentieren
			_GUICtrlListView_AddItem($handle, _Get_langstr(328), 21)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_windowtool#"
			;Fenster Info Tool
			_GUICtrlListView_AddItem($handle, _Get_langstr(609), 23)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macroslot1#"
			;Makroslot1
			_GUICtrlListView_AddItem($handle, _Get_langstr(611), 24)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macroslot2#"
			;Makroslot2
			_GUICtrlListView_AddItem($handle, _Get_langstr(612), 25)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macroslot3#"
			;Makroslot3
			_GUICtrlListView_AddItem($handle, _Get_langstr(613), 26)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macroslot4#"
			;Makroslot4
			_GUICtrlListView_AddItem($handle, _Get_langstr(614), 27)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macroslot5#"
			;Makroslot5
			_GUICtrlListView_AddItem($handle, _Get_langstr(615), 28)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macroslot6#"
			;Makroslot6
			_GUICtrlListView_AddItem($handle, _Get_langstr(906), 30)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_macroslot7#"
			;Makroslot7
			_GUICtrlListView_AddItem($handle, _Get_langstr(907), 31)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_changelogmanager#"
			;Änderungsprotokolle
			_GUICtrlListView_AddItem($handle, _Get_langstr(911), 32)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_settings#"
			;Programmeinstellungen
			_GUICtrlListView_AddItem($handle, _Get_langstr(42), 33)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_colortoolbox#"
			;Farbtoolbox
			_GUICtrlListView_AddItem($handle, _Get_langstr(651), 34)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_closeproject#"
			;Projekt schließen
			_GUICtrlListView_AddItem($handle, _Get_langstr(41), 35)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#tbar_plugin1#"
			;Slot für Erweitertes Plugin1
			If _AdvancedISNPlugin_get_name(1) <> "" Then
				$Icon = _AdvancedISNPlugin_get_Icon(1)
				If StringInStr($Icon, ".ico") Then
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(1), _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
				Else
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(1), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
				EndIf
				_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
			EndIf

		Case "#tbar_plugin2#"
			;Slot für Erweitertes Plugin2
			If _AdvancedISNPlugin_get_name(2) <> "" Then
				$Icon = _AdvancedISNPlugin_get_Icon(2)
				If StringInStr($Icon, ".ico") Then
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(2), _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
				Else
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(2), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
				EndIf
				_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
			EndIf

		Case "#tbar_plugin3#"
			;Slot für Erweitertes Plugin3
			If _AdvancedISNPlugin_get_name(3) <> "" Then
				$Icon = _AdvancedISNPlugin_get_Icon(3)
				If StringInStr($Icon, ".ico") Then
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(3), _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
				Else
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(3), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
				EndIf
				_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
			EndIf

		Case "#tbar_plugin4#"
			;Slot für Erweitertes Plugin4
			If _AdvancedISNPlugin_get_name(4) <> "" Then
				$Icon = _AdvancedISNPlugin_get_Icon(4)
				If StringInStr($Icon, ".ico") Then
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(4), _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
				Else
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(4), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
				EndIf
				_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
			EndIf

		Case "#tbar_plugin5#"
			;Slot für Erweitertes Plugin5
			If _AdvancedISNPlugin_get_name(5) <> "" Then
				$Icon = _AdvancedISNPlugin_get_Icon(5)
				If StringInStr($Icon, ".ico") Then
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(5), _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
				Else
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(5), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
				EndIf
				_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
			EndIf

		Case "#tbar_plugin6#"
			;Slot für Erweitertes Plugin6
			If _AdvancedISNPlugin_get_name(6) <> "" Then
				$Icon = _AdvancedISNPlugin_get_Icon(6)
				If StringInStr($Icon, ".ico") Then
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(6), _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
				Else
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(6), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
				EndIf
				_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
			EndIf

		Case "#tbar_plugin7#"
			;Slot für Erweitertes Plugin7
			If _AdvancedISNPlugin_get_name(7) <> "" Then
				$Icon = _AdvancedISNPlugin_get_Icon(7)
				If StringInStr($Icon, ".ico") Then
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(7), _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
				Else
					_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(7), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
				EndIf
				_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
			EndIf

		Case "#tbar_projectsettings#"
			;Projekt schließen
			_GUICtrlListView_AddItem($handle, _Get_langstr(1078), 36)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)



	EndSwitch
EndFunc   ;==>_Einstellungen_Toolbar_ItemID_zu_Listview


Func _ISN_Toolbar_Set_IconSize()
	If $ISN_Use_Vertical_Toolbar = "false" Then
		_GUICtrlToolbar_SetButtonSize($hToolbar, 24 * $DPI, 22 * $DPI)
	Else
		_GUICtrlToolbar_SetButtonSize($hToolbar, 30 * $DPI, 22 * $DPI)
		_GUICtrlToolbar_SetMetrics($hToolbar, 0, 0, 0, -5 * $DPI)
	EndIf

EndFunc   ;==>_ISN_Toolbar_Set_IconSize

Func _Toolbar_nach_layout_anordnen()
	$Elemente_Array = StringSplit($Toolbarlayout, "|", 2)
	If Not IsArray($Elemente_Array) Then Return
	If @error Then Return

	;Lösche alle Einträge
	_GUICtrlToolbar_Destroy($hToolbar)


	;Toolbar aufbauen
	If $ISN_Use_Vertical_Toolbar = "false" Then
		$hToolbar = _GUICtrlToolbar_Create($StudioFenster)
	Else
		$hToolbar = _GUICtrlToolbar_Create($StudioFenster, BitOR($CCS_NORESIZE, $CCS_NOPARENTALIGN, $TBSTYLE_WRAPABLE))
	EndIf

	_ISN_Toolbar_Set_IconSize()

	_GUICtrlToolbar_SetImageList($hToolbar, $hToolBarImageListNorm)
	_GUICtrlToolbar_SetToolTips($hToolbar, $Toolbar_ToolTip)


	For $x = 0 To UBound($Elemente_Array) - 1

		Switch $Elemente_Array[$x]

			Case "#tbar_newfile#"
				;Neue Datei
				_GUICtrlToolbar_AddButton($hToolbar, $id1, 0, -1, BitOR($BTNS_DROPDOWN, $BTNS_WHOLEDROPDOWN)) ; newfile


			Case "#tbar_newfolder#"
				;Neuer Ordner
				_GUICtrlToolbar_AddButton($hToolbar, $id2, 1) ; newfolder

			Case "#tbar_importfile#"
				;Dateien importiern
				_GUICtrlToolbar_AddButton($hToolbar, $id3, 2) ; import

			Case "#tbar_importfolder#"
				;Ordner importiern
				_GUICtrlToolbar_AddButton($hToolbar, $id19, 3) ; importfolder

			Case "#tbar_export#"
				;Datei exportiern
				_GUICtrlToolbar_AddButton($hToolbar, $id4, 4) ; export

			Case "#tbar_deletefile#"
				;Datei löschen
				_GUICtrlToolbar_AddButton($hToolbar, $id5, 5) ; löschen

			Case "#tbar_refreshprojecttree#"
				;Projektbaum aktualisieren
				_GUICtrlToolbar_AddButton($hToolbar, $id6, 6) ; projecttree

			Case "#tbar_fullscreen#"
				;Vollbild
				_GUICtrlToolbar_AddButton($hToolbar, $id20, 20) ; fullscreenmode

			Case "#tbar_sep#"
				;Abstand (Seperator)
				If $ISN_Use_Vertical_Toolbar = "true" Then
					If $ISN_Dark_Mode = "true" Then
						_GUICtrlToolbar_AddButton($hToolbar, -1, 10, Default, Default) ;sep
					Else
						_GUICtrlToolbar_AddButton($hToolbar, -1, 10, Default, Default, $TBSTATE_INDETERMINATE) ;sep
					EndIf
				Else
					If $ISN_Dark_Mode = "true" Then
						_GUICtrlToolbar_AddButtonSep($hToolbar, 8) ;sep
					Else
						_GUICtrlToolbar_AddButton($hToolbar, -1, 10, Default, Default, $TBSTATE_INDETERMINATE) ;sep
					EndIf
				EndIf

			Case "#tbar_testproject#"
				;Projekt testen
				_GUICtrlToolbar_AddButton($hToolbar, $id7, 7, -1, BitOR($BTNS_DROPDOWN, $BTNS_WHOLEDROPDOWN)) ; testproject

			Case "#tbar_compile#"
				;Projekt kompilieren
				_GUICtrlToolbar_AddButton($hToolbar, $id8, 8, -1, BitOR($BTNS_DROPDOWN, $BTNS_WHOLEDROPDOWN)) ; compile

			Case "#tbar_macros#"
				;Makros
				_GUICtrlToolbar_AddButton($hToolbar, $id22, 22) ; projektregeln

			Case "#tbar_projectproberties#"
				;Projekteigenschaften
				_GUICtrlToolbar_AddButton($hToolbar, $id9, 9) ; eigenschaften

			Case "#tbar_save#"
				;Speichern
				_GUICtrlToolbar_AddButton($hToolbar, $id10, 11) ; speichern

			Case "#tbar_saveall#"
				;Alle Tabs Speichern
				_GUICtrlToolbar_AddButton($hToolbar, $id29, 29) ; save all tabs

			Case "#tbar_closetab#"
				;Tab schließen
				_GUICtrlToolbar_AddButton($hToolbar, $id13, 14) ; closetab

			Case "#tbar_undo#"
				;Rückgängig
				_GUICtrlToolbar_AddButton($hToolbar, $id11, 12) ; undo

			Case "#tbar_redo#"
				;Wiederholen
				_GUICtrlToolbar_AddButton($hToolbar, $id12, 13) ; redo

			Case "#tbar_testscript#"
				;Skript testen
				_GUICtrlToolbar_AddButton($hToolbar, $id14, 15) ; testscript

			Case "#tbar_stopproject#"
				;Skript stoppen
				_GUICtrlToolbar_AddButton($hToolbar, $id15, 17) ; stopscript

			Case "#tbar_search#"
				;suche
				_GUICtrlToolbar_AddButton($hToolbar, $id16, 16) ; search

			Case "#tbar_syntaxcheck#"
				;Syntaxcheck
				_GUICtrlToolbar_AddButton($hToolbar, $id17, 18) ; syntaxcheck

			Case "#tbar_tidy#"
				;Tidy
				_GUICtrlToolbar_AddButton($hToolbar, $id18, 19) ; tidy

			Case "#tbar_commentout#"
				;Auskommentieren
				_GUICtrlToolbar_AddButton($hToolbar, $id21, 21) ; comment out

			Case "#tbar_windowtool#"
				;Fenster Info Tool
				_GUICtrlToolbar_AddButton($hToolbar, $id23, 23) ; window info tool

			Case "#tbar_macroslot1#"
				;Makroslot1
				_GUICtrlToolbar_AddButton($hToolbar, $id24, 24) ; custom rule 1

			Case "#tbar_macroslot2#"
				;Makroslot2
				_GUICtrlToolbar_AddButton($hToolbar, $id25, 25) ; custom rule 2

			Case "#tbar_macroslot3#"
				;Makroslot3
				_GUICtrlToolbar_AddButton($hToolbar, $id26, 26) ; custom rule 3

			Case "#tbar_macroslot4#"
				;Makroslot4
				_GUICtrlToolbar_AddButton($hToolbar, $id27, 27) ; custom rule 4

			Case "#tbar_macroslot5#"
				;Makroslot5
				_GUICtrlToolbar_AddButton($hToolbar, $id28, 28) ; custom rule 5

			Case "#tbar_macroslot6#"
				;Makroslot6
				_GUICtrlToolbar_AddButton($hToolbar, $Toolbar_makroslot6, 30) ; custom rule 6

			Case "#tbar_macroslot7#"
				;Makroslot7
				_GUICtrlToolbar_AddButton($hToolbar, $Toolbar_makroslot7, 31) ; custom rule 7

			Case "#tbar_changelogmanager#"
				;Änderungsprotokolle
				_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_aenderungsprotokoll, 32)

			Case "#tbar_settings#"
				;Programmeinstellungen
				_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_programmeinstellungen, 33)

			Case "#tbar_projectsettings#"
				;Project Settings
				_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_projekteinstellungen, 36)

			Case "#tbar_colortoolbox#"
				;Color toolbox
				_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_Farbtoolbox, 34)

			Case "#tbar_closeproject#"
				;Projekt schließen
				_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_closeproject, 35)

			Case "#tbar_plugin1#"
				;Slot für Erweitertes Plugin1
				If _AdvancedISNPlugin_get_name(1) <> "" Then
					$Icon = _AdvancedISNPlugin_get_Icon(1)
					If StringInStr($Icon, ".ico") Then
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot1, _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
					Else
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot1, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
					EndIf
				EndIf

			Case "#tbar_plugin2#"
				;Slot für Erweitertes Plugin2
				If _AdvancedISNPlugin_get_name(2) <> "" Then
					$Icon = _AdvancedISNPlugin_get_Icon(2)
					If StringInStr($Icon, ".ico") Then
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot2, _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
					Else
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot2, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
					EndIf
				EndIf

			Case "#tbar_plugin3#"
				;Slot für Erweitertes Plugin3
				If _AdvancedISNPlugin_get_name(3) <> "" Then
					$Icon = _AdvancedISNPlugin_get_Icon(3)
					If StringInStr($Icon, ".ico") Then
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot3, _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
					Else
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot3, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
					EndIf
				EndIf

			Case "#tbar_plugin4#"
				;Slot für Erweitertes Plugin4
				If _AdvancedISNPlugin_get_name(4) <> "" Then
					$Icon = _AdvancedISNPlugin_get_Icon(4)
					If StringInStr($Icon, ".ico") Then
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot4, _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
					Else
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot4, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
					EndIf
				EndIf

			Case "#tbar_plugin5#"
				;Slot für Erweitertes Plugin5
				If _AdvancedISNPlugin_get_name(5) <> "" Then
					$Icon = _AdvancedISNPlugin_get_Icon(5)
					If StringInStr($Icon, ".ico") Then
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot5, _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
					Else
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot5, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
					EndIf
				EndIf

			Case "#tbar_plugin6#"
				;Slot für Erweitertes Plugin6
				If _AdvancedISNPlugin_get_name(6) <> "" Then
					$Icon = _AdvancedISNPlugin_get_Icon(6)
					If StringInStr($Icon, ".ico") Then
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot6, _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
					Else
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot6, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
					EndIf
				EndIf

			Case "#tbar_plugin7#"
				;Slot für Erweitertes Plugin7
				If _AdvancedISNPlugin_get_name(7) <> "" Then
					$Icon = _AdvancedISNPlugin_get_Icon(7)
					If StringInStr($Icon, ".ico") Then
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot7, _GUIImageList_AddIcon($hToolBarImageListNorm, $Icon, 0))
					Else
						_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot7, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon - 1))
					EndIf
				EndIf

		EndSwitch
	Next


	If $Skin_is_used = "true" Then
		_GUICtrlToolbar_SetStyleTransparent($hToolbar, True)
		_GUICtrlToolbar_SetColorScheme($hToolbar, 0xffffff, 0xffffff)
	EndIf


	If $ISN_Use_Vertical_Toolbar = "true" Then
		_GUICtrlRebar_DeleteBand($ISNReBar, 0)
		_GUICtrlRebar_AddToolBarBand($ISNReBar, $hToolbar, "", -1, $RBBS_NOGRIPPER)
		_WinAPI_MoveWindow($hToolbar, 0, 0, 35 * $DPI, 3000)

	EndIf
EndFunc   ;==>_Toolbar_nach_layout_anordnen



Func _Einstellungen_Toolbar_Layoutstring_generieren_und_abspeichern()
	$Fertiger_String = ""
	For $y = 0 To _GUICtrlListView_GetItemCount($einstellungen_toolbar_aktiveelemente_listview) - 1
		If _GUICtrlListView_GetItemText($einstellungen_toolbar_aktiveelemente_listview, $y, 1) = "" Then ContinueLoop
		$Fertiger_String = $Fertiger_String & _GUICtrlListView_GetItemText($einstellungen_toolbar_aktiveelemente_listview, $y, 1) & "|"
	Next
	If StringRight($Fertiger_String, 1) = "|" Then $Fertiger_String = StringTrimRight($Fertiger_String, 1)
	If $Fertiger_String = "" Then $Fertiger_String = $Toolbar_Standardlayout
	_Write_in_Config("toolbar_layout", $Fertiger_String)
	$Toolbarlayout = $Fertiger_String
EndFunc   ;==>_Einstellungen_Toolbar_Layoutstring_generieren_und_abspeichern

Func _Einstellungen_Toolbar_entferne_Eintrag()
	If _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview) = -1 Then Return
	$Item_to_add = _GUICtrlListView_GetItemText($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview), 1)
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($einstellungen_toolbar_aktiveelemente_listview), _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview))
	If $Item_to_add <> "#tbar_sep#" Then _Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, $Item_to_add)
	_GUICtrlListView_SetItemSelected($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview), True, True)
EndFunc   ;==>_Einstellungen_Toolbar_entferne_Eintrag

Func _Einstellungen_Toolbar_Eintrag_hinzufuegen()
	If _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview) = -1 Then Return
	$Item_to_add = _GUICtrlListView_GetItemText($einstellungen_toolbar_verfuegbareelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview), 1)
	If $Item_to_add <> "#tbar_sep#" Then _GUICtrlListView_DeleteItem(GUICtrlGetHandle($einstellungen_toolbar_verfuegbareelemente_listview), _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview))
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_aktiveelemente_listview, $Item_to_add)
	_GUICtrlListView_SetItemSelected($einstellungen_toolbar_verfuegbareelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview), True, True)
EndFunc   ;==>_Einstellungen_Toolbar_Eintrag_hinzufuegen

Func _Einstellungen_Toolbar_Eintrag_nach_unten()
	If _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($einstellungen_toolbar_aktiveelemente_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($einstellungen_toolbar_aktiveelemente_listview, 1)
	_GUICtrlListView_EnsureVisible($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview))
	_GUICtrlListView_SetItemSelected($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview), True, True)
EndFunc   ;==>_Einstellungen_Toolbar_Eintrag_nach_unten

Func _Einstellungen_Toolbar_Eintrag_nach_oben()
	If _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($einstellungen_toolbar_aktiveelemente_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($einstellungen_toolbar_aktiveelemente_listview, -1)
	_GUICtrlListView_EnsureVisible($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview))
	_GUICtrlListView_SetItemSelected($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview), True, True)
EndFunc   ;==>_Einstellungen_Toolbar_Eintrag_nach_oben

Func _Einstellungen_Toolbar_Standard_wiederherstellen()
	$Toolbarlayout = $Toolbar_Standardlayout
	_Einstellungen_Toolbar_Lade_Verfuegbarliste()
	_Einstellungen_Toolbar_Lade_Elemente_aus_Layout()
EndFunc   ;==>_Einstellungen_Toolbar_Standard_wiederherstellen


Func _Einstellungen_Toolbar_entferne_Eintrag_aus_verfuegbarliste($ID = "")
	If $ID = "#tbar_sep#" Then Return
	If $ID = "" Then Return
	For $y = 0 To _GUICtrlListView_GetItemCount($einstellungen_toolbar_verfuegbareelemente_listview) - 1
		If _GUICtrlListView_GetItemText($einstellungen_toolbar_verfuegbareelemente_listview, $y, 1) = $ID Then _GUICtrlListView_DeleteItem(GUICtrlGetHandle($einstellungen_toolbar_verfuegbareelemente_listview), $y)
	Next
EndFunc   ;==>_Einstellungen_Toolbar_entferne_Eintrag_aus_verfuegbarliste


Func _Einstellungen_Toolbar_Lade_Elemente_aus_Layout()
	_GUICtrlListView_BeginUpdate($einstellungen_toolbar_aktiveelemente_listview)
	_GUICtrlListView_BeginUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($einstellungen_toolbar_aktiveelemente_listview))

	$Elemente_Array = StringSplit($Toolbarlayout, "|", 2)
	If Not IsArray($Elemente_Array) Then Return
	If @error Then Return
	For $x = 0 To UBound($Elemente_Array) - 1
		_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_aktiveelemente_listview, $Elemente_Array[$x])
		_Einstellungen_Toolbar_entferne_Eintrag_aus_verfuegbarliste($Elemente_Array[$x])
	Next

	_GUICtrlListView_EndUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
	_GUICtrlListView_EndUpdate($einstellungen_toolbar_aktiveelemente_listview)
EndFunc   ;==>_Einstellungen_Toolbar_Lade_Elemente_aus_Layout



Func _Einstellungen_Toolbar_Lade_Verfuegbarliste()
	_GUICtrlListView_BeginUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($einstellungen_toolbar_verfuegbareelemente_listview))

	;Erstelle alles was es so gibt :P
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_newfile#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_newfolder#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_importfile#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_importfolder#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_export#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_deletefile#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_refreshprojecttree#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_fullscreen#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_sep#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_testproject#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_compile#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macros#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_projectproberties#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_save#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_saveall#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_closetab#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_undo#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_redo#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_testscript#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_stopproject#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_search#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_syntaxcheck#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_commentout#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_windowtool#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macroslot1#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macroslot2#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macroslot3#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macroslot4#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macroslot5#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macroslot6#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_macroslot7#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_changelogmanager#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_settings#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_colortoolbox#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_closeproject#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_plugin1#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_plugin2#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_plugin3#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_plugin4#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_plugin5#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_plugin6#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_plugin7#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_projectsettings#")
	_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview, "#tbar_tidy#")

	_GUICtrlListView_EndUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
EndFunc   ;==>_Einstellungen_Toolbar_Lade_Verfuegbarliste

Func _AdvancedISNPlugin_get_name($Nummer = 0)
	If $Nummer = 0 Then Return ""
	Local $pfad = Execute("$Tools_menu_pluginitem" & Number($Nummer) & "_exe")
	If $pfad = "" Then Return ""
	$pfad = StringTrimRight($pfad, StringLen($pfad) - StringInStr($pfad, "\", 0, -1))
	If IniRead($pfad & "plugin.ini", "plugin", "active", "0") = "0" Then Return "" ;Plugin muss aktiviert sein!
	$Name = IniRead($pfad & "plugin.ini", "plugin", "toolsmenudescription", IniRead($pfad & "plugin.ini", "plugin", "name", _Get_langstr(962)))
	Return $Name
EndFunc   ;==>_AdvancedISNPlugin_get_name

Func _AdvancedISNPlugin_get_Icon($Nummer = 0)
	If $Nummer = 0 Then Return ""
	Local $pfad = Execute("$Tools_menu_pluginitem" & Number($Nummer) & "_exe")
	If $pfad = "" Then Return ""
	$pfad = StringTrimRight($pfad, StringLen($pfad) - StringInStr($pfad, "\", 0, -1))
	$Ico = IniRead($pfad & "plugin.ini", "plugin", "toolsmenuiconid", "193")
	If StringInStr($Ico, ".ico") Then $Ico = $pfad & $Ico
	Return $Ico
EndFunc   ;==>_AdvancedISNPlugin_get_Icon


Func _Zeige_Skriptbaum_Einstellungen()
	_GUICtrlTreeView_SelectItem($config_selectorlist, $config_navigation_scripttree, $TVGN_CARET)
	_Show_Configgui()

EndFunc   ;==>_Zeige_Skriptbaum_Einstellungen

Func _Zeige_Skriptbaum_FilterGUI()
	If $Offenes_Projekt = "" Then
		MsgBox(262144 + 48, _Get_langstr(394), _Get_langstr(966), 0, $config_gui)
		Return
	EndIf
	$text = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "scripttreefilter", "")
	GUICtrlSetData($skriuptbaum_FilterGUI_Edit, StringReplace($text, "|", @CRLF))
	GUISetState(@SW_SHOW, $skriuptbaum_FilterGUI)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $config_GUI)
EndFunc   ;==>_Zeige_Skriptbaum_FilterGUI

Func _Verstecke_Skriptbaum_FilterGUI()
	GUISetState(@SW_ENABLE, $config_GUI)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $skriuptbaum_FilterGUI)
EndFunc   ;==>_Verstecke_Skriptbaum_FilterGUI

Func _Skriptbaum_FilterGUI_OK()
	$text = GUICtrlRead($skriuptbaum_FilterGUI_Edit)
	$text = StringReplace($text, @CRLF, "|")
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "scripttreefilter", $text)
	_Verstecke_Skriptbaum_FilterGUI()
	_Skriptbaum_aktualisieren()
EndFunc   ;==>_Skriptbaum_FilterGUI_OK

Func _Toggle_Skripteditor()
	If GUICtrlRead($Checkbox_hidefunctionstree) = $GUI_CHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_showforms, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showfunctions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showincludes, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showlocalvariables, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showglobalvariables, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showregions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_ENABLE)
		GUICtrlSetState($Skriptbaum_config_Filter_Button, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showforms, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showfunctions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showincludes, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showlocalvariables, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showglobalvariables, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showregions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandfunctions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_DISABLE)
		GUICtrlSetState($Skriptbaum_config_Filter_Button, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_alphabetisch, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode1_radio, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode2_radio, $GUI_DISABLE)
		Return
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showfunctions) = $GUI_CHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandfunctions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_alphabetisch, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandfunctions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_alphabetisch, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_bearbeitete_func_markieren) = $GUI_CHECKED And BitAND(GUICtrlGetState($skriptbaum_config_checkbox_bearbeitete_func_markieren), $GUI_ENABLE) = $GUI_ENABLE Then
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode1_radio, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode2_radio, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode1_radio, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren_mode2_radio, $GUI_DISABLE)
	EndIf


	If GUICtrlRead($skriptbaum_config_checkbox_showglobalvariables) = $GUI_CHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showlocalvariables) = $GUI_CHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showincludes) = $GUI_CHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showregions) = $GUI_CHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($skriptbaum_config_checkbox_showforms) = $GUI_CHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_DISABLE)
	EndIf

EndFunc   ;==>_Toggle_Skripteditor

Func _API_Pfade_abspeichern()
	Local $Fertiger_String = ""

	;API Ordner
	For $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_API_Listview)
		If _GUICtrlListView_GetItemText($Einstellungen_API_Listview, $x) = "%isnstudiodir%\Data\Api" Then ContinueLoop
		If _GUICtrlListView_GetItemText($Einstellungen_API_Listview, $x) = "%myisndatadir%\Data\Api" Then ContinueLoop
		If _GUICtrlListView_GetItemText($Einstellungen_API_Listview, $x) = "" Then ContinueLoop
		$Fertiger_String = $Fertiger_String & _GUICtrlListView_GetItemText($Einstellungen_API_Listview, $x) & "|"
	Next
	If StringRight($Fertiger_String, 1) = "|" Then $Fertiger_String = StringTrimRight($Fertiger_String, 1)
	$Zusaetzliche_API_Ordner = $Fertiger_String
	_Write_in_Config("additional_api_folders", $Fertiger_String)

	;Properties Ordner
	$Fertiger_String = ""
	For $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_Properties_Listview)
		If _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview, $x) = "%isnstudiodir%\Data\Properties" Then ContinueLoop
		If _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview, $x) = "%myisndatadir%\Data\Properties" Then ContinueLoop
		If _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview, $x) = "" Then ContinueLoop
		$Fertiger_String = $Fertiger_String & _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview, $x) & "|"
	Next
	If StringRight($Fertiger_String, 1) = "|" Then $Fertiger_String = StringTrimRight($Fertiger_String, 1)
	$Zusaetzliche_Properties_Ordner = $Fertiger_String
	_Write_in_Config("additional_properties_folders", $Fertiger_String)
EndFunc   ;==>_API_Pfade_abspeichern






Func _API_Pfade_in_Listview_Laden()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_API_Listview))
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_Properties_Listview))
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projekteinstellungen_API_Listview))
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projekteinstellungen_Proberties_Listview))


	_GUICtrlListView_BeginUpdate($Einstellungen_API_Listview)
	_GUICtrlListView_BeginUpdate($Einstellungen_Properties_Listview)
	_GUICtrlListView_BeginUpdate($Projekteinstellungen_API_Listview)
	_GUICtrlListView_BeginUpdate($Projekteinstellungen_Proberties_Listview)


	;Standard Einträge hinzufügen
	_GUICtrlListView_AddItem($Einstellungen_API_Listview, "%isnstudiodir%\Data\Api", 0)
	_GUICtrlListView_AddItem($Einstellungen_Properties_Listview, "%isnstudiodir%\Data\Properties", 0)
	$item = _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, "%isnstudiodir%\Data\Api", 106)
	_GUICtrlListView_AddSubItem($Projekteinstellungen_API_Listview, $item, "1", 1)
	$item = _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, "%isnstudiodir%\Data\Properties", 106)
	_GUICtrlListView_AddSubItem($Projekteinstellungen_Proberties_Listview, $item, "1", 1)

	If $Erstkonfiguration_Mode <> "portable" Then ;Wird im portable mode nicht angezeigt (Da %myisndatadir% = %isnstudiodir% ist!)
		_GUICtrlListView_AddItem($Einstellungen_API_Listview, "%myisndatadir%\Data\Api", 0)
		_GUICtrlListView_AddItem($Einstellungen_Properties_Listview, "%myisndatadir%\Data\Properties", 0)
		$item = _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, "%myisndatadir%\Data\Api", 106)
		_GUICtrlListView_AddSubItem($Projekteinstellungen_API_Listview, $item, "1", 1)
		$item = _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, "%myisndatadir%\Data\Properties", 106)
		_GUICtrlListView_AddSubItem($Projekteinstellungen_Proberties_Listview, $item, "1", 1)
	EndIf

	;Benutzerdefinierte Einträge hinzufügen
	If $Zusaetzliche_API_Ordner <> "" Then
		$Orner_Array = StringSplit($Zusaetzliche_API_Ordner, "|", 2)
		If IsArray($Orner_Array) Then
			For $index = 0 To UBound($Orner_Array) - 1
				If $Orner_Array[$index] = "" Then ContinueLoop
				If $Orner_Array[$index] = "%isnstudiodir%\Data\Api" Then ContinueLoop
				If $Orner_Array[$index] = "%myisndatadir%\Data\Api" Then ContinueLoop
				_GUICtrlListView_AddItem($Einstellungen_API_Listview, $Orner_Array[$index], 0)
				$item = _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, $Orner_Array[$index], 106)
				_GUICtrlListView_AddSubItem($Projekteinstellungen_API_Listview, $item, "1", 1)
			Next
		EndIf
	EndIf


	If $Zusaetzliche_Properties_Ordner <> "" Then
		$Orner_Array = StringSplit($Zusaetzliche_Properties_Ordner, "|", 2)
		If IsArray($Orner_Array) Then
			For $index = 0 To UBound($Orner_Array) - 1
				If $Orner_Array[$index] = "" Then ContinueLoop
				If $Orner_Array[$index] = "%isnstudiodir%\Data\Properties" Then ContinueLoop
				If $Orner_Array[$index] = "%myisndatadir%\Data\Properties" Then ContinueLoop
				_GUICtrlListView_AddItem($Einstellungen_Properties_Listview, $Orner_Array[$index], 0)
				$item = _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, $Orner_Array[$index], 106)
				_GUICtrlListView_AddSubItem($Projekteinstellungen_Proberties_Listview, $item, "1", 1)
			Next
		EndIf
	EndIf

	_GUICtrlListView_EndUpdate($Einstellungen_API_Listview)
	_GUICtrlListView_EndUpdate($Einstellungen_Properties_Listview)
	_GUICtrlListView_EndUpdate($Projekteinstellungen_API_Listview)
	_GUICtrlListView_EndUpdate($Projekteinstellungen_Proberties_Listview)
EndFunc   ;==>_API_Pfade_in_Listview_Laden

Func _Einstellungen_API_Pfad_entfernen()
	If _GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemText($Einstellungen_API_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview), 0) = "%isnstudiodir%\Data\Api" Or _GUICtrlListView_GetItemText($Einstellungen_API_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview), 0) = "%myisndatadir%\Data\Api" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1124), 0, $Config_GUI)
		Return
	EndIf
	_GUICtrlListView_DeleteItem($Einstellungen_API_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview))
	_GUICtrlListView_SetItemSelected($Einstellungen_API_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview), True, True)
EndFunc   ;==>_Einstellungen_API_Pfad_entfernen

Func _Einstellungen_Properties_Pfad_entfernen()
	If _GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview), 0) = "%isnstudiodir%\Data\Properties" Or _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview), 0) = "%myisndatadir%\Data\Properties" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1124), 0, $Config_GUI)
		Return
	EndIf
	_GUICtrlListView_DeleteItem($Einstellungen_Properties_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview))
	_GUICtrlListView_SetItemSelected($Einstellungen_Properties_Listview, _GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview), True, True)
EndFunc   ;==>_Einstellungen_Properties_Pfad_entfernen


Func _Choose_projectfolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_Projekte_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_projectfolder

Func _Choose_backupfolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_Backup_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_backupfolder

Func _Choose_releasefolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_Release_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_releasefolder

Func _Choose_Templatefolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_template_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_Templatefolder

Func _Choose_pluginfolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Einstellungen_Pfade_Pluginpfad_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_pluginfolder

Func _Einstellungen_Properties_Pfad_hinzufuegen()
	$Ordnerpfad = FileSelectFolder(_Get_langstr(298), "", 7, "", $Config_GUI)
	If $Ordnerpfad = "" Or @error Then Return
	FileChangeDir(@ScriptDir)
	If Not _IsDir($Ordnerpfad) Then Return
	If _WinAPI_PathIsRoot($Ordnerpfad) Then Return
	If _GUICtrlListView_FindText($Einstellungen_Properties_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad, 1), -1) = -1 Then _GUICtrlListView_AddItem($Einstellungen_Properties_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad, 1), 0)
EndFunc   ;==>_Einstellungen_Properties_Pfad_hinzufuegen

Func _Einstellungen_API_Pfad_hinzufuegen()
	$Ordnerpfad = FileSelectFolder(_Get_langstr(298), "", 7, "", $Config_GUI)
	If $Ordnerpfad = "" Or @error Then Return
	FileChangeDir(@ScriptDir)
	If Not _IsDir($Ordnerpfad) Then Return
	If _WinAPI_PathIsRoot($Ordnerpfad) Then Return
	If _GUICtrlListView_FindText($Einstellungen_API_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad, 1), -1) = -1 Then _GUICtrlListView_AddItem($Einstellungen_API_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad, 1), 0)
EndFunc   ;==>_Einstellungen_API_Pfad_hinzufuegen


Func _Farbeinstellungen_Exportieren()
	$line = FileSaveDialog(_Get_langstr(1143), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Hotkeys (*.ini)", 18, "ISN AutoIt Studio Color settings.ini", $Config_GUI)
	If $line = "" Then Return
	If @error > 0 Then Return
	FileChangeDir(@ScriptDir)

	_Save_Settings()
	IniWrite($line, "config", "scripteditor_font", $scripteditor_font)
	IniWrite($line, "config", "scripteditor_size", $scripteditor_size)
	IniWrite($line, "config", "scripteditor_bgcolour", $scripteditor_bgcolour)
	IniWrite($line, "config", "scripteditor_rowcolour", $scripteditor_rowcolour)
	IniWrite($line, "config", "scripteditor_marccolour", $scripteditor_marccolour)
	IniWrite($line, "config", "scripteditor_caretcolour", $scripteditor_caretcolour)
	IniWrite($line, "config", "scripteditor_caretwidth", $scripteditor_caretwidth)
	IniWrite($line, "config", "scripteditor_caretstyle", $scripteditor_caretstyle)
	IniWrite($line, "config", "scripteditor_highlightcolour", $scripteditor_highlightcolour)
	IniWrite($line, "config", "scripteditor_errorcolour", $scripteditor_errorcolour)
	IniWrite($line, "config", "use_new_au3_colours", $use_new_au3_colours)
	IniWrite($line, "config", "scripteditor_backgroundcolour_forall", $hintergrundfarbe_fuer_alle_uebernehmen)
	IniWrite($line, "config", "scripteditor_bracelight_colour", $scripteditor_bracelight_colour)
	IniWrite($line, "config", "scripteditor_bracebad_colour", $scripteditor_bracebad_colour)

	IniWrite($line, "config", "AU3_DEFAULT_STYLE1", $SCE_AU3_STYLE1a)
	IniWrite($line, "config", "AU3_COMMENT_STYLE1", $SCE_AU3_STYLE2a)
	IniWrite($line, "config", "AU3_COMMENTBLOCK_STYLE1", $SCE_AU3_STYLE3a)
	IniWrite($line, "config", "AU3_NUMBER_STYLE1", $SCE_AU3_STYLE4a)
	IniWrite($line, "config", "AU3_FUNCTION_STYLE1", $SCE_AU3_STYLE5a)
	IniWrite($line, "config", "AU3_KEYWORD_STYLE1", $SCE_AU3_STYLE6a)
	IniWrite($line, "config", "AU3_MACRO_STYLE1", $SCE_AU3_STYLE7a)
	IniWrite($line, "config", "AU3_STRING_STYLE1", $SCE_AU3_STYLE8a)
	IniWrite($line, "config", "AU3_OPERATOR_STYLE1", $SCE_AU3_STYLE9a)
	IniWrite($line, "config", "AU3_VARIABLE_STYLE1", $SCE_AU3_STYLE10a)
	IniWrite($line, "config", "AU3_SENT_STYLE1", $SCE_AU3_STYLE11a)
	IniWrite($line, "config", "AU3_PREPROCESSOR_STYLE1", $SCE_AU3_STYLE12a)
	IniWrite($line, "config", "AU3_SPECIAL_STYLE1", $SCE_AU3_STYLE13a)
	IniWrite($line, "config", "AU3_EXPAND_STYLE1", $SCE_AU3_STYLE14a)
	IniWrite($line, "config", "AU3_COMOBJ_STYLE1", $SCE_AU3_STYLE15a)
	IniWrite($line, "config", "AU3_UDF_STYLE1", $SCE_AU3_STYLE16a)

	IniWrite($line, "config", "AU3_DEFAULT_STYLE2", $SCE_AU3_STYLE1b)
	IniWrite($line, "config", "AU3_COMMENT_STYLE2", $SCE_AU3_STYLE2b)
	IniWrite($line, "config", "AU3_COMMENTBLOCK_STYLE2", $SCE_AU3_STYLE3b)
	IniWrite($line, "config", "AU3_NUMBER_STYLE2", $SCE_AU3_STYLE4b)
	IniWrite($line, "config", "AU3_FUNCTION_STYLE2", $SCE_AU3_STYLE5b)
	IniWrite($line, "config", "AU3_KEYWORD_STYLE2", $SCE_AU3_STYLE6b)
	IniWrite($line, "config", "AU3_MACRO_STYLE2", $SCE_AU3_STYLE7b)
	IniWrite($line, "config", "AU3_STRING_STYLE2", $SCE_AU3_STYLE8b)
	IniWrite($line, "config", "AU3_OPERATOR_STYLE2", $SCE_AU3_STYLE9b)
	IniWrite($line, "config", "AU3_VARIABLE_STYLE2", $SCE_AU3_STYLE10b)
	IniWrite($line, "config", "AU3_SENT_STYLE2", $SCE_AU3_STYLE11b)
	IniWrite($line, "config", "AU3_PREPROCESSOR_STYLE2", $SCE_AU3_STYLE12b)
	IniWrite($line, "config", "AU3_SPECIAL_STYLE2", $SCE_AU3_STYLE13b)
	IniWrite($line, "config", "AU3_EXPAND_STYLE2", $SCE_AU3_STYLE14b)
	IniWrite($line, "config", "AU3_COMOBJ_STYLE2", $SCE_AU3_STYLE15b)
	IniWrite($line, "config", "AU3_UDF_STYLE2", $SCE_AU3_STYLE16b)

	_Show_Configgui()
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $config_gui)

EndFunc   ;==>_Farbeinstellungen_Exportieren


Func _Farbeinstellungen_Importieren()

	$res = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(1145), 0, $config_gui)
	If @error Then Return
	If $res <> 6 Then Return

	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(1144), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $config_gui)
	Else
		$var = FileOpenDialog(_Get_langstr(1144), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 1 + 2, "", $config_gui)
	EndIf

	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then Return

	_Save_Settings()
	$sections = IniReadSectionNames($var)
	If @error Then Return
	If Not _ArraySearch($sections, "config") Then Return
	For $x = 1 To $sections[0]
		$Werte_der_Section = IniReadSection($var, $sections[$x])
		For $y = 1 To $Werte_der_Section[0][0]
			IniWrite($Configfile, $sections[$x], $Werte_der_Section[$y][0], $Werte_der_Section[$y][1])
		Next
	Next

	$scripteditor_font = _Config_Read("scripteditor_font", "Courier New")
	$scripteditor_size = _Config_Read("scripteditor_size", "10")
	$scripteditor_bgcolour = _Config_Read("scripteditor_bgcolour", "0xFFFFFF")
	$scripteditor_rowcolour = _Config_Read("scripteditor_rowcolour", "0xFFFED8")
	$scripteditor_marccolour = _Config_Read("scripteditor_marccolour", "0x3289D0")
	$scripteditor_caretcolour = _Config_Read("scripteditor_caretcolour", "0x000000")
	$scripteditor_caretwidth = _Config_Read("scripteditor_caretwidth", "1")
	$scripteditor_caretstyle = _Config_Read("scripteditor_caretstyle", "1")
	$scripteditor_highlightcolour = _Config_Read("scripteditor_highlightcolour", "0xFF0000")
	$scripteditor_errorcolour = _Config_Read("scripteditor_errorcolour", "0xFEBDBD")
	$use_new_au3_colours = _Config_Read("use_new_au3_colours", "false")
	$hintergrundfarbe_fuer_alle_uebernehmen = _Config_Read("scripteditor_backgroundcolour_forall", "true")
	$SCE_AU3_STYLE1a = _Config_Read("AU3_DEFAULT_STYLE1", "0x000000|0xFFFFFF|0|0|0")
	$SCE_AU3_STYLE2a = _Config_Read("AU3_COMMENT_STYLE1", "0x339900|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE3a = _Config_Read("AU3_COMMENTBLOCK_STYLE1", "0x009966|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE4a = _Config_Read("AU3_NUMBER_STYLE1", "0xA900AC|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE5a = _Config_Read("AU3_FUNCTION_STYLE1", "0xAA0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE6a = _Config_Read("AU3_KEYWORD_STYLE1", "0xFF0000|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE7a = _Config_Read("AU3_MACRO_STYLE1", "0xFF33FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE8a = _Config_Read("AU3_STRING_STYLE1", "0xCC9999|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE9a = _Config_Read("AU3_OPERATOR_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE10a = _Config_Read("AU3_VARIABLE_STYLE1", "0x000090|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE11a = _Config_Read("AU3_SENT_STYLE1", "0x0080FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE12a = _Config_Read("AU3_PREPROCESSOR_STYLE1", "0xFF00F0|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE13a = _Config_Read("AU3_SPECIAL_STYLE1", "0xF00FA0|0xFFFFFF|0|1|0")
	$SCE_AU3_STYLE14a = _Config_Read("AU3_EXPAND_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
	$SCE_AU3_STYLE15a = _Config_Read("AU3_COMOBJ_STYLE1", "0xFF0000|0xFFFFFF|1|1|0")
	$SCE_AU3_STYLE16a = _Config_Read("AU3_UDF_STYLE1", "0xFF8000|0xFFFFFF|0|1|0")
	$scripteditor_bracelight_colour = _Config_Read("scripteditor_bracelight_colour", "0xC7FFC8")
	$scripteditor_bracebad_colour = _Config_Read("scripteditor_bracebad_colour", "0xFFCBCB")
	_Show_Configgui()
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(591), 0, $config_gui)
EndFunc   ;==>_Farbeinstellungen_Importieren

Func _Darstellung_bewege_DPI_Slider()
	GUICtrlSetData($programmeinstellungen_DPI_Slider_Label, GUICtrlRead($programmeinstellungen_DPI_Slider) & " %")
EndFunc   ;==>_Darstellung_bewege_DPI_Slider

Func _Studiofensterposition_speichern()
	If BitAND(WinGetState($Studiofenster, ""), 16) Then Return ;Nichts unternehmen wenn Minimiert
	$Studiofenster_pos_array = WinGetPos($Studiofenster)
	$Studiofenster_clientsize_array = WinGetClientSize($Studiofenster)
	If Not IsArray($Studiofenster_pos_array) Then Return
	If Not IsArray($Studiofenster_clientsize_array) Then Return
	_Write_in_Config("studio_x", $Studiofenster_pos_array[0])
	_Write_in_Config("studio_y", $Studiofenster_pos_array[1])
	_Write_in_Config("studio_width", $Studiofenster_clientsize_array[0])
	_Write_in_Config("studio_height", $Studiofenster_clientsize_array[1] + _GUICtrlStatusBar_GetHeight($Studiofenster) + _WinAPI_GetSystemMetrics($SM_CYMENU))
	If BitAND(WinGetState($Studiofenster, ""), 32) Then
		_Write_in_Config("studio_maximized", "true")
	Else
		_Write_in_Config("studio_maximized", "false")
	EndIf
EndFunc   ;==>_Studiofensterposition_speichern

Func _Programmeinstellungen_Tools_Checkbox_event()


	If GUICtrlRead($setting_tools_obfuscator_enabled_checkbox) = $GUI_Checked Then
		GUICtrlSetState($settings_pelock_key_input, $GUI_ENABLE)
		GUICtrlSetState($settings_pelock_check_key_button, $GUI_ENABLE)
		GUICtrlSetState($settings_pelock_buy_key_button, $GUI_ENABLE)
		GUICtrlSetState($settings_pelock_key_label, $GUI_ENABLE)
		GUICtrlSetState($settings_pelock_keyinfo_label, $GUI_ENABLE)
	Else
		GUICtrlSetState($settings_pelock_key_input, $GUI_DISABLE)
		GUICtrlSetState($settings_pelock_check_key_button, $GUI_DISABLE)
		GUICtrlSetState($settings_pelock_buy_key_button, $GUI_DISABLE)
		GUICtrlSetState($settings_pelock_key_label, $GUI_DISABLE)
		GUICtrlSetState($settings_pelock_keyinfo_label, $GUI_DISABLE)
	EndIf


	If GUICtrlRead($setting_tools_parametereditor_enabled_checkbox) = $GUI_Checked Then
		GUICtrlSetState($Checkbox_Settings_Auto_ParameterEditor, $GUI_ENABLE)

	Else
		GUICtrlSetState($Checkbox_Settings_Auto_ParameterEditor, $GUI_DISABLE)
	EndIf

EndFunc   ;==>_Programmeinstellungen_Tools_Checkbox_event



Func _Import_ICP_Plugin_CMD($Path = "")
	_Fadeout_logo()
	_GUICtrlTreeView_SelectItem($config_selectorlist, $config_navigation_Plugins, $TVGN_CARET)
	_Show_Configgui()
	_Try_to_import_ICP_Plugin($Path)
EndFunc   ;==>_Import_ICP_Plugin_CMD


Func _Try_to_import_ICP_Plugin($Path = "")
	If $Path = "" Then Return
	Local $randomid = Random(1, 2000, 1)

	_show_Loading(_Get_langstr(475), _Get_langstr(23))
	DirCreate($Arbeitsverzeichnis & "\data\Cache\import" & $randomid)
	GUISetState(@SW_DISABLE, $config_gui)


	_Loading_Progress(100)

	$CurZipSize = 0
	_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "_UnZIP_ServiceFunc")
	_UnZIP_SetOptions()
	If _UnZIP_Unzip($Path, $Arbeitsverzeichnis & "\data\Cache\import" & $randomid) <> 1 Then
		DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
		_import_ICP_Plugin_Fehler(1)
		Return
	EndIf

	$search = FileFindFirstFile($Arbeitsverzeichnis & "\data\Cache\import" & $randomid & "\*.*")
	$pluginfolder = FileFindNextFile($search)
	$pathtopluginini = $Arbeitsverzeichnis & "\data\Cache\import" & $randomid & "\" & $pluginfolder & "\plugin.ini"
	FileClose($search)
	If $pluginfolder = "." Or $pluginfolder = ".." Then Return
	If Not FileExists($pathtopluginini) Then
		DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
		_import_ICP_Plugin_Fehler(2)
		Return
	EndIf
	IniReadSection($pathtopluginini, "plugin")
	If @error Then
		DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
		_import_ICP_Plugin_Fehler(3)
		Return
	EndIf

	_Hide_Loading()
	$result = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(1321) & @CRLF & @CRLF & _Get_langstr(142) & " " & _
			IniRead($pathtopluginini, "plugin", "name", "") & @CRLF & _
			_Get_langstr(131) & " " & IniRead($pathtopluginini, "plugin", "version", "") & @CRLF & _
			_Get_langstr(132) & " " & IniRead($pathtopluginini, "plugin", "author", "") & @CRLF & _
			_Get_langstr(133) & " " & IniRead($pathtopluginini, "ISNAUTOITSTUDIO", "comment", "") & @CRLF & @CRLF & _Get_langstr(1322), 0, $config_gui)
	If @error Or $result = 7 Then
		DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
		_GUICtrlStatusBar_SetText($Status_bar, "")
		GUISetState(@SW_ENABLE, $config_gui)
		Return
	EndIf
	If $result = 6 Then

		;Check if the plugin already exists...
		If FileExists(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $pluginfolder)) Then
			$exists_result = MsgBox(262144 + 48 + 4, _Get_langstr(394), StringReplace(_Get_langstr(1334), "%1", IniRead($pathtopluginini, "plugin", "name", "")), 0, $config_gui)
			If $exists_result = 6 Then
				DirRemove(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $pluginfolder), 1)
			Else
				DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
				_GUICtrlStatusBar_SetText($Status_bar, "")
				GUISetState(@SW_ENABLE, $config_gui)
				Return
			EndIf
		EndIf

		If DirMove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid & "\" & $pluginfolder, _ISN_Variablen_aufloesen($Pluginsdir), 1) <> 1 Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1324), 0, $config_gui)
			DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
			_GUICtrlStatusBar_SetText($Status_bar, "")
			GUISetState(@SW_ENABLE, $config_gui)
			Return
		EndIf

		$result2 = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(1323), 0, $config_gui)
		If $result2 = 6 Then _ISN_Plugin_aktivieren($pluginfolder)
		DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
		_List_Plugins()
		_load_plugindetails()
		_GUICtrlStatusBar_SetText($Status_bar, "")
		GUISetState(@SW_ENABLE, $config_gui)
	EndIf
EndFunc   ;==>_Try_to_import_ICP_Plugin

Func _import_ICP_Plugin_Fehler($errorcode = 0)
	MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(476) & @CRLF & @CRLF & "Errorcode " & $errorcode, 0, $config_gui)
	_load_plugindetails()
	_GUICtrlStatusBar_SetText($Status_bar, "")
	GUISetState(@SW_ENABLE, $config_gui)
EndFunc   ;==>_import_ICP_Plugin_Fehler

Func _ICP_zum_Import_waehlen()
	If $Skin_is_used = "true" Then
		$var = _WinAPI_OpenFileDlg(_Get_langstr(1315), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(1319) & " (*.icp)", 0, '', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), $OFN_EX_NOPLACESBAR, 0, 0, $Config_GUI)
	Else
		$var = FileOpenDialog(_Get_langstr(1315), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(1319) & " (*.icp)", 1 + 2, "", $Config_GUI)
	EndIf

	If @error Then Return
	_Try_to_import_ICP_Plugin($var)
EndFunc   ;==>_ICP_zum_Import_waehlen

Func _Settings_additional_Project_Paths_OK()
	_Settings_Hide_additional_Project_Paths_GUI()
	Local $Fertiger_String = ""
	For $x = 0 To _GUICtrlListView_GetItemCount($settings_additional_project_paths_listview)
		If _GUICtrlListView_GetItemText($settings_additional_project_paths_listview, $x) = "" Then ContinueLoop
		$Fertiger_String = $Fertiger_String & _GUICtrlListView_GetItemText($settings_additional_project_paths_listview, $x) & "|"
	Next
	If StringRight($Fertiger_String, 1) = "|" Then $Fertiger_String = StringTrimRight($Fertiger_String, 1)
	_Write_in_Config("additionalprojectpaths", $Fertiger_String)
	$Additional_project_paths = $Fertiger_String
EndFunc   ;==>_Settings_additional_Project_Paths_OK


Func _Settings_Show_additional_Project_Paths_GUI()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($settings_additional_project_paths_listview))
	GUISetState(@SW_SHOW, $settings_additional_project_paths_GUI)
	GUISetState(@SW_DISABLE, $config_GUI)
	_GUICtrlListView_BeginUpdate($settings_additional_project_paths_listview)
	Local $Additional_Paths = _Config_Read("additionalprojectpaths", "")
	If $Additional_Paths <> "" Then
		Local $Additional_Paths_Array = StringSplit($Additional_Paths, "|", 2)
		If IsArray($Additional_Paths_Array) Then
			For $path_count = 0 To UBound($Additional_Paths_Array) - 1
				If $Additional_Paths_Array[$path_count] = "" Then ContinueLoop
				_GUICtrlListView_AddItem($settings_additional_project_paths_listview, $Additional_Paths_Array[$path_count], 1)
			Next
		EndIf
	EndIf
	_GUICtrlListView_EndUpdate($settings_additional_project_paths_listview)
EndFunc   ;==>_Settings_Show_additional_Project_Paths_GUI

Func _Settings_Hide_additional_Project_Paths_GUI()
	GUISetState(@SW_ENABLE, $config_GUI)
	GUISetState(@SW_HIDE, $settings_additional_project_paths_GUI)
EndFunc   ;==>_Settings_Hide_additional_Project_Paths_GUI



Func _additional_Project_Paths_Move_Item_UP()
	If _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($settings_additional_project_paths_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($settings_additional_project_paths_listview, -1)
	_GUICtrlListView_EnsureVisible($settings_additional_project_paths_listview, _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview))
	_GUICtrlListView_SetItemSelected($settings_additional_project_paths_listview, _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview), True, True)
EndFunc   ;==>_additional_Project_Paths_Move_Item_UP

Func _additional_Project_Paths_Move_Item_DOWN()
	If _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($settings_additional_project_paths_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($settings_additional_project_paths_listview, 1)
	_GUICtrlListView_EnsureVisible($settings_additional_project_paths_listview, _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview))
	_GUICtrlListView_SetItemSelected($settings_additional_project_paths_listview, _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview), True, True)
EndFunc   ;==>_additional_Project_Paths_Move_Item_DOWN


Func _additional_Project_Paths_Add_Item()
	$Ordnerpfad = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $settings_additional_project_paths_GUI)
	If $Ordnerpfad = "" Or @error Then Return
	FileChangeDir(@ScriptDir)
	If Not _IsDir($Ordnerpfad) Then Return
	If _WinAPI_PathIsRoot($Ordnerpfad) Then Return
	If _GUICtrlListView_FindText($settings_additional_project_paths_listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad), -1) = -1 Then _GUICtrlListView_AddItem($settings_additional_project_paths_listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad), 1)
EndFunc   ;==>_additional_Project_Paths_Add_Item

Func _additional_Project_Paths_Remove_Item()
	If _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview) = -1 Then Return
	_GUICtrlListView_DeleteItem($settings_additional_project_paths_listview, _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview))
	_GUICtrlListView_SetItemSelected($settings_additional_project_paths_listview, _GUICtrlListView_GetSelectionMark($settings_additional_project_paths_listview), True, True)
EndFunc   ;==>_additional_Project_Paths_Remove_Item


Func _ISNSettings_Repos_Configpage()
	If $ISNSettings_Current_Page = "" Then Return
	Local $Offset_left = 5 * $DPI
	Local $Offset_top = 11 * $DPI
	Local $Offset_right = -8 * $DPI
	Local $Offset_bottom = -17 * $DPI

	If $ISN_Dark_Mode = "true" Then
		$Offset_top = 14 * $DPI
		$Offset_bottom = -19 * $DPI
	EndIf

	$config_GUI_Dummy_Control_pos_Array = ControlGetPos($config_GUI, "", $Config_GUI_Dummy_Control)
	If Not IsArray($config_GUI_Dummy_Control_pos_Array) Then Return
	_WinAPI_SetWindowPos($ISNSettings_Current_Page, $HWND_TOP, $config_GUI_Dummy_Control_pos_Array[0] + $Offset_left, $config_GUI_Dummy_Control_pos_Array[1] + $Offset_top, $config_GUI_Dummy_Control_pos_Array[2] + $Offset_right, $config_GUI_Dummy_Control_pos_Array[3] + $Offset_bottom, $SWP_NOACTIVATE + $SWP_NOOWNERZORDER + $SWP_NOSENDCHANGING)
	_GUIScrollbars_ReSizer_ISN($ISNSettings_Current_Page, 0, $ISNSettings_Current_Page_ScrollHeight, False)
	; _GUIScrollbars_ReSizer_ISN($ISNSettings_Current_Page, 0, $ISNSettings_Current_Page_ScrollHeight,False)

EndFunc   ;==>_ISNSettings_Repos_Configpage

Func _ISNSettings_Repos_Configpage_withoutScrollresize()
	AdlibUnRegister("_ISNSettings_Repos_Configpage_withoutScrollresize")
	If $ISNSettings_Current_Page = "" Then Return
	Local $Offset_left = 5 * $DPI
	Local $Offset_top = 11 * $DPI
	Local $Offset_right = -8 * $DPI
	Local $Offset_bottom = -17 * $DPI

	If $ISN_Dark_Mode = "true" Then
		$Offset_top = 14 * $DPI
		$Offset_bottom = -19 * $DPI
	EndIf

	$config_GUI_Dummy_Control_pos_Array = ControlGetPos($config_GUI, "", $Config_GUI_Dummy_Control)
	If Not IsArray($config_GUI_Dummy_Control_pos_Array) Then Return
	_WinAPI_SetWindowPos($ISNSettings_Current_Page, $HWND_TOP, $config_GUI_Dummy_Control_pos_Array[0] + $Offset_left, $config_GUI_Dummy_Control_pos_Array[1] + $Offset_top, $config_GUI_Dummy_Control_pos_Array[2] + $Offset_right, $config_GUI_Dummy_Control_pos_Array[3] + $Offset_bottom, $SWP_NOACTIVATE + $SWP_NOOWNERZORDER + $SWP_NOSENDCHANGING + $SWP_NOREDRAW)
EndFunc   ;==>_ISNSettings_Repos_Configpage_withoutScrollresize


Func _select_settingscategory()
	Local $mark = _GUICtrlTreeView_GetSelection($config_selectorlist)
	If $mark = 0 Then Return
	Local $text = _GUICtrlTreeView_GetText($config_selectorlist, $mark)
	If $text = "" Then Return

	Local $PageToShow = ""
	Local $ScrollheightToSet = 0

	;$ScrollheightToSet = 10 to do not allow scrolling
	Switch $text

		Case _Get_langstr(125) ;General
			$PageToShow = $ISNSettings_General_Page
			$ScrollheightToSet = 538 * $DPI

		Case _Get_langstr(196) ;script Editor
			$PageToShow = $ISNSettings_Scripteditor_Page
			$ScrollheightToSet = 1200 * $DPI

		Case _Get_langstr(883) ;Auto Updates
			$PageToShow = $ISNSettings_Updates_Page
			$ScrollheightToSet = 348 * $DPI

		Case _Get_langstr(469) ;Scripttree
			$PageToShow = $ISNSettings_Scripttree_Page
			$ScrollheightToSet = 548 * $DPI

		Case _Get_langstr(447) ;Display
			$PageToShow = $ISNSettings_Display_Page
			$ScrollheightToSet = 403 * $DPI

		Case _Get_langstr(884) ;Colors
			$PageToShow = $ISNSettings_Colors_Page
			$ScrollheightToSet = 791 * $DPI

		Case _Get_langstr(676) ;Hotkeys
			$PageToShow = $ISNSettings_Hotkeys_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(130) ;Language
			$PageToShow = $ISNSettings_Language_Page
			$ScrollheightToSet = 279 * $DPI

		Case _Get_langstr(206) ;Auto Backup
			$PageToShow = $ISNSettings_AutoBackup_Page
			$ScrollheightToSet = 541 * $DPI

		Case _Get_langstr(260) ;Program Paths
			$PageToShow = $ISNSettings_ProgramPaths_Page
			$ScrollheightToSet = 319 * $DPI

		Case _Get_langstr(482) ;Skins
			$PageToShow = $ISNSettings_Skins_Page
			$ScrollheightToSet = 540 * $DPI

		Case _Get_langstr(138) ;Plugins
			$PageToShow = $ISNSettings_Plugins_Page
			$ScrollheightToSet = 537 * $DPI

		Case _Get_langstr(493) ;General -> Advanced
			$PageToShow = $ISNSettings_Advanced_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(261) ;Trophies
			$PageToShow = $ISNSettings_Trophies_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(952) ;Toolbar
			$PageToShow = $ISNSettings_Toolbar_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(327) ;Tidy
			$PageToShow = $ISNSettings_Tidy_Page
			$ScrollheightToSet = 563 * $DPI

		Case _Get_langstr(1074) ;Includes
			$PageToShow = $ISNSettings_Includes_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(1085) ;AutoSaving
			$PageToShow = $ISNSettings_AutoSaving_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(1109) ;FileTypes
			$PageToShow = $ISNSettings_FileTypes_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(1121) ;APIs
			$PageToShow = $ISNSettings_APIs_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(1150) ;Macro Security
			$PageToShow = $ISNSettings_MacroSecurity_Page
			$ScrollheightToSet = 504 * $DPI

		Case _Get_langstr(407) ;AutoIt Paths
			$PageToShow = $ISNSettings_AutoItPaths_Page
			$ScrollheightToSet = 10 * $DPI

		Case _Get_langstr(607) ;Tools
			$PageToShow = $ISNSettings_Tools_Page
			$ScrollheightToSet = 410 * $DPI

		Case _Get_langstr(1354) ;Monitor and Windows
			$PageToShow = $ISNSettings_MonitorAndWindows_Page
			$ScrollheightToSet = 506 * $DPI

		Case _Get_langstr(1204) ;QuickView
			$PageToShow = $ISNSettings_QuickView_Page
			$ScrollheightToSet = 10 * $DPI


	EndSwitch

	If $PageToShow = "" Or $ISNSettings_Current_Page = $PageToShow Or $ScrollheightToSet = 0 Then Return
	If IsHWnd($ISNSettings_Current_Page) Then GUISetState(@SW_HIDE, $ISNSettings_Current_Page)
	$ISNSettings_Current_Page = $PageToShow
	$ISNSettings_Current_Page_ScrollHeight = $ScrollheightToSet
	GUISetState(@SW_HIDE, $ISNSettings_Current_Page) ;Bugfix for resizing
	_Elemente_an_Fesntergroesse_anpassen($Config_GUI)
	GUISetState(@SW_SHOWNOACTIVATE, $ISNSettings_Current_Page)


EndFunc   ;==>_select_settingscategory




Func _QuickView_Get_TabTextfromIndex($ID = 0)
	If $QuickView_Layout = "" Then $QuickView_Layout = $QuickView_Default_Layout
	$QuickView_Layout_array = StringSplit($QuickView_Layout, "|", 2)
	If IsArray($QuickView_Layout_array) Then
		Switch $QuickView_Layout_array[$ID]

			Case "#qv_log#"
				Return _Get_langstr(1388)

			Case "#qv_notes#"
				Return _Get_langstr(1390)

			Case "#qv_todo#"
				Return _Get_langstr(1262)

			Case "#qv_udfexplorer#"
				Return _Get_langstr(1404)

			Case "#qv_pluginslot1#"
				$Plugin_EXE = _IniVirtual_Read($Type3_Plugins_Virtual_INI, $Plugin_Placeholder_QuickView, "exe", "")
				If $Plugin_EXE <> "" Then
					$Plugin_Root = StringTrimRight($Plugin_EXE, StringLen($Plugin_EXE) - StringInStr($Plugin_EXE, "\", 0, -1) + 1)
					$Plugin_INI_Pfad = $Plugin_Root & "\plugin.ini"
					$Tabname = IniRead($Plugin_INI_Pfad, "plugin", "tabdescription", "")
					If $Tabname = "" Then $Tabname = IniRead($Plugin_INI_Pfad, "plugin", "name", _Get_langstr(1389))
					Return $Tabname
				EndIf

		EndSwitch
	EndIf
	Return ""
EndFunc   ;==>_QuickView_Get_TabTextfromIndex


Func _Settings_QuickViewItemID_to_Listview($handle = "", $ID = "")
	If $handle = "" Then Return
	If $ID = "" Then Return

	Switch $ID

		Case "#qv_log#"
			;Program Log
			_GUICtrlListView_AddItem($handle, _Get_langstr(1388), 38)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#qv_notes#"
			;Notes
			_GUICtrlListView_AddItem($handle, _Get_langstr(1390), 40)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#qv_todo#"
			;ToDo List
			_GUICtrlListView_AddItem($handle, _Get_langstr(1262), 37)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#qv_udfexplorer#"
			;UDF Explorer
			_GUICtrlListView_AddItem($handle, _Get_langstr(1404), 41)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

		Case "#qv_pluginslot1#"
			;Pluginslot 1
			_GUICtrlListView_AddItem($handle, _Get_langstr(1389), 39)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	EndSwitch
EndFunc   ;==>_Settings_QuickViewItemID_to_Listview





Func _Settings_QuickView_SaveAndGenerate_Layoutstring()
	$Fertiger_String = ""
	$QuickView_NoTextinTabs = ""
	For $y = 0 To _GUICtrlListView_GetItemCount($settings_quickview_ActiveElements_Listview) - 1
		If _GUICtrlListView_GetItemText($settings_quickview_ActiveElements_Listview, $y, 1) = "" Then ContinueLoop
		$Fertiger_String = $Fertiger_String & _GUICtrlListView_GetItemText($settings_quickview_ActiveElements_Listview, $y, 1) & "|"
	Next
	If StringRight($Fertiger_String, 1) = "|" Then $Fertiger_String = StringTrimRight($Fertiger_String, 1)
	If $Fertiger_String = "" Or $Fertiger_String = "#qv_pluginslot1#" Then $Fertiger_String = $QuickView_Default_Layout
	_Write_in_Config("quickview_layout", $Fertiger_String)
	If $Fertiger_String <> $QuickView_Layout Then $QuickView_LayoutReload_Required = 1
	$QuickView_Layout = $Fertiger_String

	$QuickView_NoTextinTabs_backup = $QuickView_NoTextinTabs
	If GUICtrlRead($QuickView_NoTextinTabs_checkbox) = $GUI_CHECKED Then
		$QuickView_NoTextinTabs = "true"
		_Write_in_Config("quickview_no_text_in_tabs", "true")
	Else
		$QuickView_NoTextinTabs = "false"
		_Write_in_Config("quickview_no_text_in_tabs", "false")
	EndIf
	If $QuickView_NoTextinTabs <> $QuickView_NoTextinTabs_backup Then $QuickView_LayoutReload_Required = 1


	If $QuickView_LayoutReload_Required = 1 Then _QuickView_Refresh_Layout()
EndFunc   ;==>_Settings_QuickView_SaveAndGenerate_Layoutstring

Func _Settings_QuickView_remove_Item()
	If _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview) = -1 Then Return
	$Item_to_add = _GUICtrlListView_GetItemText($settings_quickview_ActiveElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview), 1)
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($settings_quickview_ActiveElements_Listview), _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview))
	_Settings_QuickViewItemID_to_Listview($settings_quickview_AvailableElements_Listview, $Item_to_add)
	_GUICtrlListView_SetItemSelected($settings_quickview_ActiveElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview), True, True)
EndFunc   ;==>_Settings_QuickView_remove_Item

Func _Settings_QuickView_activate_Item()
	If _GUICtrlListView_GetSelectionMark($settings_quickview_AvailableElements_Listview) = -1 Then Return
	$Item_to_add = _GUICtrlListView_GetItemText($settings_quickview_AvailableElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_AvailableElements_Listview), 1)
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($settings_quickview_AvailableElements_Listview), _GUICtrlListView_GetSelectionMark($settings_quickview_AvailableElements_Listview))
	_Settings_QuickViewItemID_to_Listview($settings_quickview_ActiveElements_Listview, $Item_to_add)
	_GUICtrlListView_SetItemSelected($settings_quickview_AvailableElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_AvailableElements_Listview), True, True)
EndFunc   ;==>_Settings_QuickView_activate_Item

Func _Settings_QuickView_ListView_MoveDown()
	If _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($settings_quickview_ActiveElements_Listview) = 0 Then Return
	_GUICtrlListView_MoveItems($settings_quickview_ActiveElements_Listview, 1)
	_GUICtrlListView_EnsureVisible($settings_quickview_ActiveElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview))
	_GUICtrlListView_SetItemSelected($settings_quickview_ActiveElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview), True, True)
EndFunc   ;==>_Settings_QuickView_ListView_MoveDown

Func _Settings_QuickView_ListView_MoveUp()
	If _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($settings_quickview_ActiveElements_Listview) = 0 Then Return
	_GUICtrlListView_MoveItems($settings_quickview_ActiveElements_Listview, -1)
	_GUICtrlListView_EnsureVisible($settings_quickview_ActiveElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview))
	_GUICtrlListView_SetItemSelected($settings_quickview_ActiveElements_Listview, _GUICtrlListView_GetSelectionMark($settings_quickview_ActiveElements_Listview), True, True)
EndFunc   ;==>_Settings_QuickView_ListView_MoveUp

Func _Settings_QuickView_Restore_Default()
	$QuickView_Layout = $QuickView_Default_Layout
	_Settings_QuickView_LoadAvailableElements_inListview()
EndFunc   ;==>_Settings_QuickView_Restore_Default


Func _Settings_QuickView_RemoveFromAvailableElements($ID = "")
	If $ID = "" Then Return
	For $y = 0 To _GUICtrlListView_GetItemCount($settings_quickview_AvailableElements_Listview) - 1
		If _GUICtrlListView_GetItemText($settings_quickview_AvailableElements_Listview, $y, 1) = $ID Then _GUICtrlListView_DeleteItem(GUICtrlGetHandle($settings_quickview_AvailableElements_Listview), $y)
	Next
EndFunc   ;==>_Settings_QuickView_RemoveFromAvailableElements


Func _Settings_QuickView_LoadElements()
	_GUICtrlListView_BeginUpdate($settings_quickview_ActiveElements_Listview)
	_GUICtrlListView_BeginUpdate($settings_quickview_AvailableElements_Listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($settings_quickview_ActiveElements_Listview))

	$Elemente_Array = StringSplit($QuickView_Layout, "|", 2)
	If Not IsArray($Elemente_Array) Then Return
	If @error Then Return
	For $x = 0 To UBound($Elemente_Array) - 1
		_Settings_QuickViewItemID_to_Listview($settings_quickview_ActiveElements_Listview, $Elemente_Array[$x])
		_Settings_QuickView_RemoveFromAvailableElements($Elemente_Array[$x])
	Next

	_GUICtrlListView_EndUpdate($settings_quickview_ActiveElements_Listview)
	_GUICtrlListView_EndUpdate($settings_quickview_AvailableElements_Listview)
EndFunc   ;==>_Settings_QuickView_LoadElements



Func _Settings_QuickView_LoadAvailableElements_inListview()
	_GUICtrlListView_BeginUpdate($settings_quickview_AvailableElements_Listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($settings_quickview_AvailableElements_Listview))

	_Settings_QuickViewItemID_to_Listview($settings_quickview_AvailableElements_Listview, "#qv_log#") ;Log
	_Settings_QuickViewItemID_to_Listview($settings_quickview_AvailableElements_Listview, "#qv_notes#") ;Notes
	_Settings_QuickViewItemID_to_Listview($settings_quickview_AvailableElements_Listview, "#qv_todo#") ;TodoList
	_Settings_QuickViewItemID_to_Listview($settings_quickview_AvailableElements_Listview, "#qv_udfexplorer#") ;UDF Explorer
	_Settings_QuickViewItemID_to_Listview($settings_quickview_AvailableElements_Listview, "#qv_pluginslot1#") ;Pluginslot 1

	_GUICtrlListView_EndUpdate($settings_quickview_AvailableElements_Listview)

	_Settings_QuickView_LoadElements() ;Load selected Items
EndFunc   ;==>_Settings_QuickView_LoadAvailableElements_inListview


Func _Config_GUI_Check_Hyperlinks()
	$CursorInfo = GUIGetCursorInfo($ISNSettings_MonitorAndWindows_Page)
	If Not IsArray($CursorInfo) Then Return
	If $Hyperlink_Old_Control = $CursorInfo[4] Then Return

	Switch $CursorInfo[4]

		Case $MonitorAndWindows_Reset_Mainwindow_hyperlink, $MonitorAndWindows_Reset_Windowpositions_hyperlink
			$Hyperlink_Old_Control = $CursorInfo[4]
			_Hyperlink_Label_Hover($CursorInfo[4])
			Return

	EndSwitch

	$CursorInfo = GUIGetCursorInfo($ISNSettings_Colors_Page)
	If Not IsArray($CursorInfo) Then Return
	If $Hyperlink_Old_Control = $CursorInfo[4] Then Return

	Switch $CursorInfo[4]

		Case $settings_reset_colors_hyperlink, $settings_import_colors_hyperlink, $settings_export_colors_hyperlink
			$Hyperlink_Old_Control = $CursorInfo[4]
			_Hyperlink_Label_Hover($CursorInfo[4])
			Return

	EndSwitch
	_Hyperlink_Label_Hover_Reset()
EndFunc   ;==>_Config_GUI_Check_Hyperlinks


Func _Config_scripteditor_zoom_slider_Event()
	GUICtrlSetData($config_scripteditor_zoom_label, GUICtrlRead($config_scripteditor_zoom_slider))
EndFunc   ;==>_Config_scripteditor_zoom_slider_Event

Func _Config_Reset_Mainwindow_Sizes()
	$res = MsgBox(262144 + 32 + 4, _Get_langstr(1371), _Get_langstr(1317), 0, $Config_GUI)
	If @error Or $res <> 6 Then Return
	_Fenstergroessen_zuruecksetzen()
EndFunc   ;==>_Config_Reset_Mainwindow_Sizes

Func _Config_Reset_Window_Positions()
	$res = MsgBox(262144 + 32 + 4, _Get_langstr(1373), _Get_langstr(1317), 0, $Config_GUI)
	If @error Or $res <> 6 Then Return
	$Allow_Gui_Size_Saving = 0
	IniDelete($Configfile, "positions")
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(1392), 0, $Config_GUI)
EndFunc   ;==>_Config_Reset_Window_Positions

Func _Config_QuickView_Toggle_Checkboxes()
	If GUICtrlRead($Checkbox_hideprogramlog) = $GUI_Checked Then
		GUICtrlSetState($QuickView_NoTextinTabs_checkbox, $GUI_ENABLE)
		GUICtrlSetState($settings_quickview_ActiveElements_Listview, $GUI_ENABLE)
		GUICtrlSetState($settings_quickview_AvailableElements_Listview, $GUI_ENABLE)
		GUICtrlSetState($settings_quickview_Add_Button, $GUI_ENABLE)
		GUICtrlSetState($settings_quickview_Remove_Button, $GUI_ENABLE)
		GUICtrlSetState($settings_quickview_Up_Button, $GUI_ENABLE)
		GUICtrlSetState($settings_quickview_Down_Button, $GUI_ENABLE)
		GUICtrlSetState($settings_quickview_Default_Button, $GUI_ENABLE)

	Else
		GUICtrlSetState($QuickView_NoTextinTabs_checkbox, $GUI_DISABLE)
		GUICtrlSetState($settings_quickview_ActiveElements_Listview, $GUI_DISABLE)
		GUICtrlSetState($settings_quickview_AvailableElements_Listview, $GUI_DISABLE)
		GUICtrlSetState($settings_quickview_Add_Button, $GUI_DISABLE)
		GUICtrlSetState($settings_quickview_Remove_Button, $GUI_DISABLE)
		GUICtrlSetState($settings_quickview_Up_Button, $GUI_DISABLE)
		GUICtrlSetState($settings_quickview_Down_Button, $GUI_DISABLE)
		GUICtrlSetState($settings_quickview_Default_Button, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Config_QuickView_Toggle_Checkboxes

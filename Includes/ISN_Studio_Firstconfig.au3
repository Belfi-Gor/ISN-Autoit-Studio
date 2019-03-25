
#include "..\Forms\ISN_Ersteinrichtung.isf" ;Ersteinrichtungs GUI

Func _Ersteinrichtung_weiter()
	$index = _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) + 1
	If $index < _GUICtrlTab_GetItemCount($tab_ersteinrichtung) Then
		If _Ersteinrichtung_Pruefe_Buttons($index) = 1 Then _GUICtrlTab_ActivateTab($tab_ersteinrichtung, $index)
	EndIf
EndFunc   ;==>_Ersteinrichtung_weiter

Func _Ersteinrichtung_zurueck()
	$index = _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) - 1
	If $index > -1 Then
		If _Ersteinrichtung_Pruefe_Buttons($index) = 1 Then _GUICtrlTab_ActivateTab($tab_ersteinrichtung, $index)
	EndIf
EndFunc   ;==>_Ersteinrichtung_zurueck

Func _Ersteinrichtung_Pruefe_Buttons($tab = 0)
	GUICtrlSetState($Ersteinrichtung_Zurueck_Button, $GUI_ENABLE)
	GUICtrlSetState($Ersteinrichtung_Weiter_Button, $GUI_ENABLE)
	GUICtrlSetData($Ersteinrichtung_Weiter_Button, _Get_langstr(622))
	GUICtrlSetOnEvent($Ersteinrichtung_Weiter_Button, "_Ersteinrichtung_weiter")
	Switch $tab

		Case 0
			GUICtrlSetState($Ersteinrichtung_Zurueck_Button, $GUI_DISABLE)

		Case 1
			If Not _Directory_Is_Accessible(@ScriptDir) Then
				GUICtrlSetState($Ersteinrichtung_portable_mode_button, $GUI_DISABLE)
			Else
				GUICtrlSetState($Ersteinrichtung_portable_mode_button, $GUI_ENABLE)
			EndIf
			GUICtrlSetState($Ersteinrichtung_Weiter_Button, $GUI_DISABLE)

		Case 3
			If _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) = 2 And GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) <> "" And GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_UNCHECKED Then
				$antwort = MsgBox(262144 + 4 + 48, _Get_langstr(48), _Get_langstr(781), 0, $first_startup)
				If $antwort = 7 Then Return 0
			EndIf

			If GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" And GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_CHECKED Then
				_Input_Error_FX($Ersteinrichtung_Datenuebernahme_config_pfad_input)
				Return 0
			EndIf

			;Default Werte für Verzeichnisse

			If $Erstkonfiguration_Mode = "normal" Then
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, @MyDocumentsDir & "\ISN AutoIt Studio")
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $Standardordner_Projects)
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $Standardordner_Templates)
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Backups_input, $Standardordner_Backups)
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $Standardordner_Release)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Backups_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt1, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt2, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt3, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt4, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt5, $GUI_ENABLE)

			Else
				GUICtrlSetData($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, @ScriptDir)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Backups_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt1, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt2, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt3, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt4, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt5, $GUI_DISABLE)
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $Standardordner_Projects)
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Backups_input, $Standardordner_Backups)
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $Standardordner_Release)
				If GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input) = "" Then GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $Standardordner_Templates)
			EndIf

		Case 4
			If _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) = 3 Then
				$Arbeitsverzeichnis = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
				If $Erstkonfiguration_Mode = "normal" Then
					If _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input))) = False Then
						_Input_Error_FX($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
						Return
					EndIf

					If _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input))) = False Then
						_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Backups_input)
						Return
					EndIf

					If _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))) = False Then
						_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input)
						Return
					EndIf

					If _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))) = False Then
						_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input)
						Return
					EndIf

					If _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))) = False Then
						_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input)
						Return
					EndIf




				EndIf
				_Ersteinrichtung_Programmverzeichnisse_Finden()
			EndIf
		Case 6
			GUICtrlSetData($Ersteinrichtung_Weiter_Button, _Get_langstr(249))
			GUICtrlSetOnEvent($Ersteinrichtung_Weiter_Button, "_Ersteinrichtung_Beginne_einrichtung")

			;Baue Zusammenfassung
			GUICtrlSetData($Ersteinrichtung_Zusammenfassung_Edit, "")
			$Arbeitsverzeichnis = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)

			$String = _Get_langstr(694) & @CRLF & @CRLF

			;Modus
			If $Erstkonfiguration_Mode = "normal" Then
				$String = $String & "-> " & _Get_langstr(697) & @CRLF & @CRLF
			Else
				$String = $String & "-> " & _Get_langstr(696) & @CRLF & @CRLF
			EndIf

			;Ordner
			$String = $String & "-> " & _Get_langstr(695) & @CRLF
			$String = $String & "   " & _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)) & @CRLF
			$String = $String & "   " & _ISN_Variablen_aufloesen($Standardordner_Plugins) & @CRLF & @CRLF
			$String = $String & "   " & _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input)) & @CRLF
			$String = $String & "   " & _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input)) & @CRLF
			$String = $String & "   " & _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input)) & @CRLF
			$String = $String & "   " & _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input)) & @CRLF & @CRLF


			;Datenübernahme
			If GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_CHECKED Then
				$String = $String & "-> " & _Get_langstr(698) & @CRLF
				$String = $String & "   " & _Get_langstr(699) & " " & GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) & @CRLF
				$String = $String & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_projekte_input)), "%2", _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))) & @CRLF
				$String = $String & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_vorlagen_input)), "%2", _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))) & @CRLF
				If FileExists(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_backups_input)) Then $String = $String & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_backups_input)), "%2", _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input))) & @CRLF
				If FileExists(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input)) Then $String = $String & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input)), "%2", _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))) & @CRLF
				$String = $String & @CRLF
			EndIf

			;Zusätzliche Aufgaben
			$String = $String & "-> " & _Get_langstr(701) & @CRLF
			If GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISN_checkbox) = $GUI_CHECKED Then $String = $String & "   " & _Get_langstr(194) & @CRLF
			If GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISP_checkbox) = $GUI_CHECKED Then $String = $String & "   " & _Get_langstr(480) & @CRLF
			If GUICtrlRead($Ersteinrichtung_Verknuepfungen_ICP_checkbox) = $GUI_CHECKED Then $String = $String & "   " & _Get_langstr(1320) & @CRLF
			If GUICtrlRead($Ersteinrichtung_Verknuepfungen_AU3_checkbox) = $GUI_CHECKED Then $String = $String & "   " & _Get_langstr(702) & @CRLF
			If GUICtrlRead($Ersteinrichtung_Verknuepfungen_Kontextmenu_checkbox) = $GUI_CHECKED Then $String = $String & "   " & _Get_langstr(703) & @CRLF
			If GUICtrlRead($Ersteinrichtung_diverses_testprojekt_checkbox) = $GUI_CHECKED Then $String = $String & "   " & _Get_langstr(787) & @CRLF

			GUICtrlSetData($Ersteinrichtung_Zusammenfassung_Edit, $String)

	EndSwitch
	Return 1
EndFunc   ;==>_Ersteinrichtung_Pruefe_Buttons

Func _Ersteinrichtung_Beginne_einrichtung()
	Dim $szDrive, $szDir, $szFName, $szExt

	Local $Pfad_zur_config = ""
	GUICtrlSetState($Ersteinrichtung_Zurueck_Button, $GUI_DISABLE)
	GUICtrlSetState($Ersteinrichtung_Weiter_Button, $GUI_DISABLE)
	GUICtrlSetData($Ersteinrichtung_Fortschritt, 0)
	GUICtrlSetData($Ersteinrichtung_Fortschritt_Status, _Get_langstr(244))
	_GUICtrlTab_ActivateTab($tab_ersteinrichtung, 7)

	;Initialisierung....
	GUICtrlSetStyle($Ersteinrichtung_Fortschritt, 8)
	_SendMessage(GUICtrlGetHandle($Ersteinrichtung_Fortschritt), $PBM_SETMARQUEE, True, 15)
	;Erstelle Ordner
	$Arbeitsverzeichnis = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
	DirCreate(GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)) ;Arbeitsverzeichnis erstellen
	DirCreate(GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data")
	DirCreate(GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data\Cache")
	DirCreate(_ISN_Variablen_aufloesen($Standardordner_Plugins)) ;User Plugins Dir
	DirCreate(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))) ;Vorlagenordner erstellen
	DirCreate(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input))) ;Backupordner erstellen
	DirCreate(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))) ;Projektverzeichnis
	DirCreate(_ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))) ;Fertige Projekte


	Sleep(2000)

	;Konfig aufbauen...
	GUICtrlSetStyle($Ersteinrichtung_Fortschritt, 0)
	_SendMessage(GUICtrlGetHandle($Ersteinrichtung_Fortschritt), $PBM_SETMARQUEE, False, 15)
	GUICtrlSetData($Ersteinrichtung_Fortschritt, 30)
	GUICtrlSetData($Ersteinrichtung_Fortschritt_Status, _Get_langstr(704))
	$Pfad_zur_config = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data\Config.ini"



	If GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_CHECKED And GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) <> "" And FileExists(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input)) Then
		;Alte Daten übernehmen
		FileMove(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input), GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data", 9)
		GUICtrlSetData($Ersteinrichtung_Fortschritt_Status, _Get_langstr(705))
		GUICtrlSetData($Ersteinrichtung_Fortschritt, 70)

		;Cache (Folding etc.)
		$TestPath = _PathSplit(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input), $szDrive, $szDir, $szFName, $szExt)
		$quelle = $szDrive & $szDir & "Cache"
		$ziel = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data\Cache"
		If FileExists($quelle) And $quelle <> $ziel Then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			If $result = 1 Then DirRemove($quelle, 1)
		EndIf

		;Projekte
		$quelle = GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_projekte_input)
		$ziel = _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))
		If $quelle <> $ziel Then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			If $result = 1 Then DirRemove($quelle, 1)
		EndIf

		;Vorlagen
		$quelle = GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_vorlagen_input)
		$ziel = _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))
		If $quelle <> $ziel Then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			If $result = 1 Then DirRemove($quelle, 1)
		EndIf

		;Backups
		$quelle = GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_backups_input)
		$ziel = _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input))
		If FileExists($Ersteinrichtung_Datenuebernahme_config_backups_input) Then
			If $quelle <> $ziel Then
				$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
				If $result = 1 Then DirRemove($quelle, 1)
			EndIf
		EndIf

		;Releases
		$quelle = GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input)
		$ziel = _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))
		If FileExists($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input) Then
			If $quelle <> $ziel Then
				$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
				If $result = 1 Then DirRemove($quelle, 1)
			EndIf
		EndIf

		Sleep(500)
	EndIf

	If IniWrite($Pfad_zur_config, "config", "autoitexe", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($Ersteinrichtung_Programmpfade_Autoit3_exe_input))) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1181), "%1", $Pfad_zur_config), 0, $first_startup)
	EndIf
	IniWrite($Pfad_zur_config, "config", "helpfileexe", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($Ersteinrichtung_Programmpfade_AutoIt3Help_exe_input)))
	IniWrite($Pfad_zur_config, "config", "autoit2exe", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($Ersteinrichtung_Programmpfade_Aut2exe_exe_input)))
	IniWrite($Pfad_zur_config, "config", "au3infoexe", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($Ersteinrichtung_Programmpfade_Au3Info_exe_input)))
	IniWrite($Pfad_zur_config, "config", "au3checkexe", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($Ersteinrichtung_Programmpfade_Au3Check_exe_input)))
	IniWrite($Pfad_zur_config, "config", "au3stripperexe", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($Ersteinrichtung_Programmpfade_au3stripperexe_input)))
	IniWrite($Pfad_zur_config, "config", "tidyexe", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($Ersteinrichtung_Programmpfade_Tidyexe_input)))
	IniWrite($Pfad_zur_config, "config", "language", $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($langchooser) + 1])
	IniWrite($Pfad_zur_config, "config", "pluginsdir", $Standardordner_Plugins)
	IniDelete($Pfad_zur_config, "config", "SciTE4AutoIt_au3mode")




	If GUICtrlRead($Ersteinrichtung_Verknuepfungen_AU3_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_config, "config", "registerau3files", "true")
	Else
		IniWrite($Pfad_zur_config, "config", "registerau3files", "false")
	EndIf

	If GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISN_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_config, "config", "registerisnfiles", "true")
	Else
		IniWrite($Pfad_zur_config, "config", "registerisnfiles", "false")
	EndIf

	If GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISP_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_config, "config", "registerispfiles", "true")
	Else
		IniWrite($Pfad_zur_config, "config", "registerispfiles", "false")
	EndIf

	If GUICtrlRead($Ersteinrichtung_Verknuepfungen_ICP_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_config, "config", "registericpfiles", "true")
	Else
		IniWrite($Pfad_zur_config, "config", "registericpfiles", "false")
	EndIf

	If GUICtrlRead($Ersteinrichtung_Verknuepfungen_Kontextmenu_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_config, "config", "registerinexplorer", "true")
	Else
		IniWrite($Pfad_zur_config, "config", "registerinexplorer", "false")
	EndIf


	;Testprojekt extrahieren
	If GUICtrlRead($Ersteinrichtung_diverses_testprojekt_checkbox) = $GUI_CHECKED Then
		_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "")
		_UnZIP_SetOptions()
		$result = _UnZIP_Unzip(@ScriptDir & "\Data\Packages\testprojekt.zip", _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input)))
	EndIf

	;Erstelle default Vorlage
	$pfad = _ISN_Variablen_aufloesen(GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))

	If Not FileExists($pfad & "\default") Then ;Default Vorlage nur anlegen wenn sie nicht existiert
		DirCreate($pfad & "\default")
		DirCreate($pfad & "\default\Forms")
		DirCreate($pfad & "\default\Images")

		$file = FileOpen($pfad & "\default\project.isn", 2 + 32) ;UTF-16 LE Encoding
		If $file = -1 Then
			MsgBox(0, "Error", "Unable to open file.")
		EndIf
		FileWriteLine($file, "[ISNAUTOITSTUDIO]")
		FileWriteLine($file, "name=Default Template")
		FileWriteLine($file, "mainfile=default.au3")
		FileWriteLine($file, "author=ISI360")
		FileWriteLine($file, "time=0")
		FileClose($file)

		$file = FileOpen($pfad & "\default\default.au3", 2)
		If $file = -1 Then
			MsgBox(0, "Error", "Unable to open file.")
		EndIf
		FileWriteLine($file, ";*****************************************")
		FileWriteLine($file, ";%filename% by %autor%")
		FileWriteLine($file, ";%langstring(30)% v. %studioversion%")
		FileWriteLine($file, ";*****************************************")
		FileClose($file)
	EndIf

	;Pfad zur Config kommt in die Registrierung
	If $Erstkonfiguration_Mode = "normal" Then RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Configfile", "REG_SZ", $Pfad_zur_config)
	If $Erstkonfiguration_Mode = "portable" Then
		If IniWrite(@ScriptDir & "\portable.dat", "ISNAUTOITSTUDIO", "mode", "portable") = 0 Then
			MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1181), "%1", @ScriptDir & "\portable.dat"), 0, $first_startup)
		EndIf
	EndIf

	;Abschließende Aufgaben
	GUICtrlSetData($Ersteinrichtung_Fortschritt, 80)
	IniWrite($Pfad_zur_config, "config", "projectfolder", GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))
	IniWrite($Pfad_zur_config, "config", "templatefolder", GUICtrlRead($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))
	If GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_UNCHECKED Then
		;Wenn Datenübernahme aktiv -> Pfade aus alter config übernehmen. (Wegen backup bzw. Releasemode)
		IniWrite($Pfad_zur_config, "config", "backupfolder", GUICtrlRead($Ersteinrichtung_Verzeichnisse_Backups_input))
		IniWrite($Pfad_zur_config, "config", "releasefolder", GUICtrlRead($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))
	EndIf







	;Fertig
	GUICtrlSetData($Ersteinrichtung_Fortschritt, 100)
	GUICtrlSetData($Ersteinrichtung_Fortschritt_Status, _Get_langstr(249))
	_Datei_nach_UTF16_konvertieren($Pfad_zur_config, "false") ;Config.ini nach UTF16 konvertieren
	MsgBox(64 + 262144, _Get_langstr(61), _Get_langstr(251), 0, $first_startup)


	;Neustart des ISN AutoIt Studios!!!
	If @Compiled Then
		Run(@ScriptDir & "\Autoit_Studio.exe", @ScriptDir)
	Else
		ShellExecute(@ScriptDir & "\Autoit_Studio.au3")
	EndIf
	_ChatBoxDestroy($console_chatbox)
	Exit
EndFunc   ;==>_Ersteinrichtung_Beginne_einrichtung

Func _hardexit()
	Exit
EndFunc   ;==>_hardexit

Func _find_au3exe()
	$state = WinGetState($first_startup, "")
	If BitAND($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3.exe (*.exe)", 3, "", $first_startup)
		If @error Then
			Return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Autoit3_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3.exe (*.exe)", 3, "", $Config_GUI)
		If @error Then
			Return
		Else
			GUICtrlSetData($Input_config_au3exe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	EndIf
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_find_au3exe

Func _find_au32exe()
	$state = WinGetState($first_startup, "")
	If BitAND($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Aut2exe.exe (*.exe)", 3, "", $first_startup)
		If @error Then
			Return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Aut2exe_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Aut2exe.exe (*.exe)", 3, "", $Config_GUI)
		If @error Then
			Return
		Else
			GUICtrlSetData($Input_config_au2exe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	EndIf
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_find_au32exe

Func _find_help()
	$state = WinGetState($first_startup, "")
	If BitAND($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3Help.exe (AutoIt3Help.exe)", 3, "", $first_startup)
		If @error Then
			Return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_AutoIt3Help_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3Help.exe (AutoIt3Help.exe)", 3, "", $Config_GUI)
		If @error Then
			Return
		Else
			GUICtrlSetData($Input_config_helpfile, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	EndIf
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_find_help

Func _find_Au3Checkexe()
	$state = WinGetState($first_startup, "")
	If BitAND($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Check.exe (Au3Check.exe)", 3, "", $first_startup)
		If @error Then
			Return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Au3Check_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Check.exe (Au3Check.exe)", 3, "", $Config_GUI)
		If @error Then
			Return
		Else
			GUICtrlSetData($Input_config_Au3Checkexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	EndIf
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_find_Au3Checkexe

Func _find_Au3Infoexe()
	$state = WinGetState($first_startup, "")
	If BitAND($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Info.exe (*.exe)", 3, "", $first_startup)
		If @error Then
			Return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Au3Info_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Info.exe (*.exe)", 3, "", $Config_GUI)
		If @error Then
			Return
		Else
			GUICtrlSetData($Input_config_Au3Infoexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	EndIf
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_find_Au3Infoexe


Func _find_au3stripperexe()
	$state = WinGetState($first_startup, "")
	If BitAND($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AU3Stripper.exe (AU3Stripper.exe)", 3, "", $first_startup)
		If @error Then
			Return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_au3stripperexe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AU3Stripper.exe (AU3Stripper.exe)", 3, "", $Config_GUI)
		If @error Then
			Return
		Else
			GUICtrlSetData($Input_config_Au3Stripperexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	EndIf
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_find_au3stripperexe

Func _find_Tidyexe()
	$state = WinGetState($first_startup, "")
	If BitAND($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Tidy.exe (Tidy.exe)", 3, "", $first_startup)
		If @error Then
			Return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Tidyexe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Tidy.exe (Tidy.exe)", 3, "", $Config_GUI)
		If @error Then
			Return
		Else
			GUICtrlSetData($Input_config_Tidyexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	EndIf
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_find_Tidyexe

Func _Ersteinrichtung_Programmverzeichnisse_Finden()
	;Search AutoIt3.exe
	_erkenne_au3exe()

	;Search Aut2exe.exe
	_erkenne_au32exe()

	;Search AutoIt3Help.exe
	_erkenne_helpfile()

	;Search Au3Check.exe
	_erkenne_Au3Checkexe()

	;Search Au3Info.exe
	_erkenne_Au3Infoexe()

	;Au3stripper
	_erkenne_Au3Stripperexe()

	;Tidy
	_erkenne_Tidyexe()

	If $Erstkonfiguration_Mode = "portable" Then
		GUICtrlSetState($Ersteinrichtung_Programmpfade_Portableinfo, $GUI_SHOW)
	Else
		GUICtrlSetState($Ersteinrichtung_Programmpfade_Portableinfo, $GUI_HIDE)
	EndIf

EndFunc   ;==>_Ersteinrichtung_Programmverzeichnisse_Finden

Func _Show_Firstconfig()
	GUISetState(@SW_HIDE, $Logo_PNG)
	GUISetState(@SW_HIDE, $controlGui_startup)
	SetBitmap($Logo_PNG, $hImagestartup, 0)

	If Not FileExists(@ScriptDir & "\Data\config.ini") Then GUICtrlSetState($Ersteinrichtung_Info_Label1, $GUI_HIDE)
	If FileExists(@ScriptDir & "\Data\config.ini") Then GUICtrlSetState($Ersteinrichtung_ISN_Logo, $GUI_HIDE)
	_Ersteinrichtung_Pruefe_Buttons()
	GUISetState(@SW_SHOW, $first_startup)

	While 1
		$state = WinGetState($first_startup, "")
		$i = 0
		If BitAND($state, 2) Then $i = 1
		If $i = 0 Then ExitLoop
		Sleep(200)
	WEnd

EndFunc   ;==>_Show_Firstconfig

Func _waehle_sprache_Ersteinrichtung()
	$Languagefile = $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($langchooser) + 1]
	$Fallback_Language_Array = ""
	$Current_Language_Array = ""
	_check_fonts()
	GUISetState(@SW_HIDE, $Sprache_Ersteinrichtung_GUI)
EndFunc   ;==>_waehle_sprache_Ersteinrichtung

Func _Exit_Ersteinrichtung()
	_ChatBoxDestroy($console_chatbox)
	Exit
EndFunc   ;==>_Exit_Ersteinrichtung

Func _Ersteinrichtung_waehle_normal_modus()
	$Erstkonfiguration_Mode = "normal"
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Backups_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, "")
	If GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" And FileExists(@ScriptDir & "\Data\config.ini") Then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @ScriptDir & "\Data\config.ini")
	If GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" And FileExists(@MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini") Then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini")
	_Ersteinrichtung_zeige_Datenuebernahme()
	_GUICtrlTab_ActivateTab($tab_ersteinrichtung, 2)
	_Ersteinrichtung_Pruefe_Buttons(_GUICtrlTab_GetCurFocus($tab_ersteinrichtung))
EndFunc   ;==>_Ersteinrichtung_waehle_normal_modus

Func _Ersteinrichtung_waehle_portable_modus()
	$Erstkonfiguration_Mode = "portable"
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Backups_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, "")
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, "")
	If GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" And FileExists(@ScriptDir & "\Data\config.ini") Then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @ScriptDir & "\Data\config.ini")
	If GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" And FileExists(@MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini") Then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini")
	_Ersteinrichtung_zeige_Datenuebernahme()
	_GUICtrlTab_ActivateTab($tab_ersteinrichtung, 2)
	_Ersteinrichtung_Pruefe_Buttons(_GUICtrlTab_GetCurFocus($tab_ersteinrichtung))
EndFunc   ;==>_Ersteinrichtung_waehle_portable_modus

Func _Ersteinrichtung_Datenuebernahme_waehle_config()
	$var = FileOpenDialog(_Get_langstr(508), @ScriptDir, "ISN AutoIt Studio config (config.ini)", 1 + 2 + 4, "", $first_startup)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then Return

	GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, $var)
	_Ersteinrichtung_zeige_Datenuebernahme()

EndFunc   ;==>_Ersteinrichtung_Datenuebernahme_waehle_config

Func _Ersteinrichtung_zeige_Datenuebernahme()
	Dim $szDrive, $szDir, $szFName, $szExt
	Local $pfad
	If FileExists(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input)) Then
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, _Get_langstr(782) & @CRLF & "(" & GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input) & ")")
		GUICtrlSetColor($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, "0x008000")
		GUICtrlSetState($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox, $GUI_CHECKED)

		$TestPath = _PathSplit(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input), $szDrive, $szDir, $szFName, $szExt)
		$Arbeitsverzeichnis = $szDrive & StringTrimRight($szDir, StringLen($szDir) - StringInStr($szDir, "\Data\", 0, -1) + 1)

		;Projekte
		$readen = IniRead(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "projectfolder", $Standardordner_Projects)
		If $readen = "Projects" Then $readen = $Standardordner_Projects
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_projekte_input, _ISN_Variablen_aufloesen($readen))

		;Templates
		$readen = IniRead(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "templatefolder", $Standardordner_Templates)
		If $readen = "Templates" Then $readen = $Standardordner_Templates
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_vorlagen_input, _ISN_Variablen_aufloesen($readen))

		;Backups
		$readen = IniRead(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "backupfolder", $Standardordner_Backups)
		If $readen = "Backups" Then $readen = $Standardordner_Backups
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_backups_input, _ISN_Variablen_aufloesen($readen))

		;Releases
		$readen = IniRead(GUICtrlRead($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "releasefolder", $Standardordner_Release)
		If $readen = "Release" Then $readen = $Standardordner_Release
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input, _ISN_Variablen_aufloesen($readen))

	Else
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, _Get_langstr(783))
		GUICtrlSetColor($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, "0x000000")
		GUICtrlSetState($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox, $GUI_UNCHECKED)
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_projekte_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_vorlagen_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_backups_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input, "")

	EndIf

EndFunc   ;==>_Ersteinrichtung_zeige_Datenuebernahme

Func _Ersteinrichtung_waehle_Datenverzeichnis()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $first_startup)
	If @error Then Return
	If $var = "" Then Return
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, $var)
EndFunc   ;==>_Ersteinrichtung_waehle_Datenverzeichnis

Func _Ersteinrichtung_waehle_Projektverzeichnis()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $first_startup)
	If @error Then Return
	If $var = "" Then Return
	$Arbeitsverzeichnis = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Ersteinrichtung_waehle_Projektverzeichnis

Func _Ersteinrichtung_waehle_Vorlagenverzeichnis()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $first_startup)
	If @error Then Return
	If $var = "" Then Return
	$Arbeitsverzeichnis = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Ersteinrichtung_waehle_Vorlagenverzeichnis

Func _Ersteinrichtung_waehle_Backupsverzeichnis()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $first_startup)
	If @error Then Return
	If $var = "" Then Return
	$Arbeitsverzeichnis = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Backups_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Ersteinrichtung_waehle_Backupsverzeichnis

Func _Ersteinrichtung_waehle_FertigeProjekteverzeichnis()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS + $BIF_NEWDIALOGSTYLE, 0, 0, $first_startup)
	If @error Then Return
	If $var = "" Then Return
	$Arbeitsverzeichnis = GUICtrlRead($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
	GUICtrlSetData($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Ersteinrichtung_waehle_FertigeProjekteverzeichnis

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



;Gibt den gewünschten String (ID) in der aktuellen Sprache zurück ($Languagefile)
Func _Get_langstr($id = 0)
	If $Languagefile = "" Then Return ""
	If $id < 1 Then Return ""
	Local $String_to_return = ""

	;Reads the current language in the buffer
	If $Current_Language_Array = "" Then
		$Current_Language_Array = $Leeres_Array
		$Current_Language_Array = StringRegExp(FileRead(@ScriptDir & "\data\language\" & $Languagefile), "(?m)(?i)^str\d+\=(.*)", 3)
		_ArrayInsert($Current_Language_Array, 0, $Languagefile)
	EndIf

	;And the backup (fallback) language
	If $Fallback_Language_Array = "" Then
		$Fallback_Language_Array = $Leeres_Array
		$Fallback_Language_Array = StringRegExp(FileRead(@ScriptDir & "\data\language\english.lng"), "(?m)(?i)^str\d+\=(.*)", 3)
		_ArrayInsert($Fallback_Language_Array, 0, "english.lng")
	EndIf


	If Not IsArray($Current_Language_Array) And Not IsArray($Fallback_Language_Array) Then Return "#LANGUAGE_ERROR#" & $id


	If $id > UBound($Current_Language_Array) - 1 Then
		If $id > UBound($Fallback_Language_Array) - 1 Then
			Return "#LANGUAGE_ERROR#" & $id
		Else
			$String_to_return = StringReplace($Fallback_Language_Array[$id], "[BREAK]", @CRLF)
		EndIf
	Else
		$String_to_return = StringReplace($Current_Language_Array[$id], "[BREAK]", @CRLF)
	EndIf

	If $String_to_return = "" Then
		$String_to_return = StringReplace($Fallback_Language_Array[$id], "[BREAK]", @CRLF)
		If $String_to_return = "" Then $String_to_return = "#LANGUAGE_ERROR#" & $id
	EndIf
	Return $String_to_return
EndFunc   ;==>_Get_langstr

Func _Ersteinrichtung_pruefe_Pfad($i = "")
	If $i = "" Then Return False
	If StringInStr($i, "?") Or StringInStr($i, "*") Or StringInStr($i, "|") Or StringInStr($i, "<") Or StringInStr($i, ">") Or StringInStr($i, "'") Or StringInStr($i, '"') Then Return False
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($i, $szDrive, $szDir, $szFName, $szExt)
	If $szDrive = "" Then Return False
	Return True
EndFunc   ;==>_Ersteinrichtung_pruefe_Pfad



Func _Ersetzte_Platzhalter($Platzhalter = "", $QuellPfadfuerFileDir = "")
	If $Platzhalter = "" Then Return ""
	Local $Str = ""

	Switch $Platzhalter

		Case "%langstring("
			Return _Get_langstr($QuellPfadfuerFileDir)


		Case "%projectversion%"
			$Str = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", "")
			$Str = StringReplace($Str, "\", "")
			$Str = StringReplace($Str, "/", "")
			$Str = StringReplace($Str, "?", "")
			$Str = StringReplace($Str, "*", "")
			$Str = StringReplace($Str, "|", "")
			$Str = StringReplace($Str, ":", "")
			$Str = StringReplace($Str, "<", "")
			$Str = StringReplace($Str, ">", "")
			$Str = StringReplace($Str, "'", "")
			$Str = StringReplace($Str, '"', "")
			Return $Str

		Case "%projectauthor%"
			$Str = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", "")
			$Str = StringReplace($Str, "\", "")
			$Str = StringReplace($Str, "/", "")
			$Str = StringReplace($Str, "?", "")
			$Str = StringReplace($Str, "*", "")
			$Str = StringReplace($Str, "|", "")
			$Str = StringReplace($Str, ":", "")
			$Str = StringReplace($Str, "<", "")
			$Str = StringReplace($Str, ">", "")
			$Str = StringReplace($Str, "'", "")
			$Str = StringReplace($Str, '"', "")
			Return $Str

		Case "%filedir%"
			If $QuellPfadfuerFileDir = "" Then
				MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1049), 0, $StudioFenster)
				Return $Offenes_Projekt ;Bei Fehler gibt das ProjectDir zurück
			EndIf
			$Str = StringTrimRight($QuellPfadfuerFileDir, StringLen($QuellPfadfuerFileDir) - (StringInStr($QuellPfadfuerFileDir, "\", 0, -1) - 1))
			Return $Str


	EndSwitch


	Return $Str
EndFunc   ;==>_Ersetzte_Platzhalter

Func _ISN_Pfad_durch_Variablen_ersetzen($String = "", $Offenes_Projekt_Ignorieren = 0)
	If $String = "" Then Return ""
	If StringInStr($String, $Offenes_Projekt) And $Offenes_Projekt_Ignorieren = 0 Then $String = StringReplace($String, $Offenes_Projekt, "%projectdir%")
	If StringInStr($String, _ISN_Variablen_aufloesen($Projectfolder)) Then $String = StringReplace($String, _ISN_Variablen_aufloesen($Projectfolder), "%projectsdir%")
	If StringInStr($String, @ScriptDir) Then $String = StringReplace($String, @ScriptDir, "%isnstudiodir%")
	If StringInStr($String, _ISN_Variablen_aufloesen($Pluginsdir)) Then $String = StringReplace($String, _ISN_Variablen_aufloesen($Pluginsdir), "%pluginsdir%")
	If StringInStr($String, $Arbeitsverzeichnis) Then $String = StringReplace($String, $Arbeitsverzeichnis, "%myisndatadir%")
	If StringInStr($String, @DesktopDir) Then $String = StringReplace($String, @DesktopDir, "%desktopdir%")
	If StringInStr($String, @MyDocumentsDir) Then $String = StringReplace($String, @MyDocumentsDir, "%mydocumentsdir%")
	If StringInStr($String, @TempDir) Then $String = StringReplace($String, @TempDir, "%tempdir%")
	If StringInStr($String, @WindowsDir) Then $String = StringReplace($String, @WindowsDir, "%windowsdir%")


	Return $String
EndFunc   ;==>_ISN_Pfad_durch_Variablen_ersetzen


Func _ISN_Variablen_aufloesen($String = "", $QuellPfadfuerFileDir = "")
	If $String = "" Then Return ""

	$Projekt_Kompilier_mode = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_mode", "2")

	;Programmpfade
	If StringInStr($String, "%projectsdir%") Then $String = StringReplace($String, "%projectsdir%", $Projectfolder)

	;Plugins dir
	If StringInStr($String, "%pluginsdir%") Then $String = StringReplace($String, "%pluginsdir%", $Pluginsdir)

	;Variablen
	If StringInStr($String, "%projectname%") Then $String = StringReplace($String, "%projectname%", $Offenes_Projekt_name)
	If StringInStr($String, "%projectversion%") Then $String = StringReplace($String, "%projectversion%", _Ersetzte_Platzhalter("%projectversion%"))
	If StringInStr($String, "%projectauthor%") Then $String = StringReplace($String, "%projectauthor%", _Ersetzte_Platzhalter("%projectauthor%"))

	;Texte aus der Sprachdatei
	If StringInStr($String, "%langstring(") Then
		$start = StringInStr($String, "%langstring(")
		$end = StringInStr($String, ")%", 0, 1, $start)
		If $end = 0 Then Return ""
		$to_replace = StringMid($String, $start, $end + 2)
		$lng_id = StringReplace($to_replace, "%langstring(", "")
		$lng_id = StringReplace($lng_id, ")%", "")
		$String = StringReplace($String, $to_replace, _Ersetzte_Platzhalter("%langstring(", $lng_id))
	EndIf

	;Uhrzeiten
	If StringInStr($String, "%mday%") Then $String = StringReplace($String, "%mday%", @MDAY)
	If StringInStr($String, "%mon%") Then $String = StringReplace($String, "%mon%", @MON)
	If StringInStr($String, "%year%") Then $String = StringReplace($String, "%year%", @YEAR)
	If StringInStr($String, "%hour%") Then $String = StringReplace($String, "%hour%", @HOUR)
	If StringInStr($String, "%min%") Then $String = StringReplace($String, "%min%", @MIN)
	If StringInStr($String, "%sec%") Then $String = StringReplace($String, "%sec%", @SEC)


	;Pfade
	If StringInStr($String, "%myisndatadir%") Then $String = StringReplace($String, "%myisndatadir%", $Arbeitsverzeichnis)
	If StringInStr($String, "%lastcompiledfile_exe%") Then $String = StringReplace($String, "%lastcompiledfile_exe%", $Zuletzt_Kompilierte_Datei_Pfad_exe)
	If StringInStr($String, "%lastcompiledfile_source%") Then $String = StringReplace($String, "%lastcompiledfile_source%", $Zuletzt_Kompilierte_Datei_Pfad_au3)
	If StringInStr($String, "%projectdir%") Then $String = StringReplace($String, "%projectdir%", $Offenes_Projekt)
	If StringInStr($String, "%isnstudiodir%") Then $String = StringReplace($String, "%isnstudiodir%", @ScriptDir)
	If StringInStr($String, "%windowsdir%") Then $String = StringReplace($String, "%windowsdir%", @WindowsDir)
	If StringInStr($String, "%tempdir%") Then $String = StringReplace($String, "%tempdir%", @TempDir)
	If StringInStr($String, "%desktopdir%") Then $String = StringReplace($String, "%desktopdir%", @DesktopDir)
	If StringInStr($String, "%mydocumentsdir%") Then $String = StringReplace($String, "%mydocumentsdir%", @MyDocumentsDir)
	If StringInStr($String, "%filedir%") Then $String = StringReplace($String, "%filedir%", _Ersetzte_Platzhalter("%filedir%", $QuellPfadfuerFileDir))

	$Desfolder = ""
	If StringInStr($String, "%backupdir%") Then
		If $backupmode = 1 Then
			$Desfolder = _ISN_Variablen_aufloesen($Backupfolder & "\" & $Offenes_Projekt_name)
		EndIf
		If $backupmode = 2 Then
			$Desfolder = $Offenes_Projekt & "\" & $Backupfolder
		EndIf
		$String = StringReplace($String, "%backupdir%", $Desfolder)
	EndIf


	$zielpfad = ""
	If StringInStr($String, "%compileddir%") Then
		If $releasemode = 1 Then
			$zielpfad = _ISN_Variablen_aufloesen($releasefolder & "\" & _ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%"))
		EndIf
		If $releasemode = 2 Then
			$directory = _ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%")
			$directory = StringReplace($directory, "%projectname%", "")
			$directory = StringReplace($directory, "\\", "")
			If StringLeft($directory, 1) = "\" Then $directory = StringTrimLeft($directory, 1)
			$directory = _ISN_Variablen_aufloesen($directory)
			If $directory <> "" Then $directory = "\" & $directory
			$zielpfad = $Offenes_Projekt & "\" & _ISN_Variablen_aufloesen($releasefolder) & $directory
		EndIf

		If $Projekt_Kompilier_mode = "1" Then $zielpfad = $Offenes_Projekt
		$String = StringReplace($String, "%compileddir%", $zielpfad)
	EndIf

	;Windows Variablen auflösen
	If $allow_windows_variables_in_paths = "true" Then
		$ExpandEnvStrings_old_value = Opt('ExpandEnvStrings')
		Opt('ExpandEnvStrings', 1)
		$String = $String
		Opt('ExpandEnvStrings', $ExpandEnvStrings_old_value)
	EndIf

	Return $String
EndFunc   ;==>_ISN_Variablen_aufloesen

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





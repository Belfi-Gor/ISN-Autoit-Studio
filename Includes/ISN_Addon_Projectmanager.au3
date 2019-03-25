Global $CurZipSize = 0
Global $UnCompSize = 0


Func _Show_Projectman()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projektverwaltung_Projektdetails_Listview))
	GUICtrlSetData($Found_Projects, _Get_langstr(36))

	If $Offenes_Projekt = "" Then
		GUICtrlSetState($ISN_Projectmanager_OpenTempProject_Button, $GUI_ENABLE)
	Else
		GUICtrlSetState($ISN_Projectmanager_OpenTempProject_Button, $GUI_DISABLE)
	EndIf

	GUISetState(@SW_SHOW, $projectmanager)
	GUISetState(@SW_HIDE, $Welcome_GUI)
	ScanforProjects_Projectman()
	ScanforVorlagen(_ISN_Variablen_aufloesen($templatefolder))
EndFunc   ;==>_Show_Projectman

Func _HIDE_Projectman()
	GUISetState(@SW_HIDE, $projectmanager)
	If $Offenes_Projekt = "" Then
		GUISetState(@SW_SHOW, $Welcome_GUI)
		_Load_Projectlist()
	EndIf
EndFunc   ;==>_HIDE_Projectman

;Suche nach Projekten
Func ScanforProjects_Projectman()
	Local $Group_Items = 0
	Local $Group_index = 0
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath
	Local $Count = 0

	If _ist_windows_vista_oder_hoeher() Then $Group_Items = 1 ;Enable the groups of different project folders
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projects_Listview_projectman))
	_GUICtrlListView_BeginUpdate($Projects_Listview_projectman)

	If $Group_Items = 1 Then
		_GUICtrlListView_InsertGroup($Projects_Listview_projectman, -1, $Group_index, _ISN_Variablen_aufloesen($Projectfolder), 1)
		_GUICtrlListView_SetGroupInfo($Projects_Listview_projectman, $Group_index, _ISN_Variablen_aufloesen($Projectfolder), 1, $LVGS_COLLAPSIBLE)
	EndIf

	;List Projects in the main ISN Projects folder
	$Search = FileFindFirstFile(_ISN_Variablen_aufloesen($Projectfolder) & "\*.*")
	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
	    If $file = "." OR $file = ".." then ContinueLoop
		$FullFilePath = _ISN_Variablen_aufloesen($Projectfolder) & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes, "D") Then
			If FileExists(_Finde_Projektdatei($FullFilePath)) Then
				$tmp_isn_file = _Finde_Projektdatei($FullFilePath)
				$tmp = IniReadSection($tmp_isn_file, "ISNAUTOITSTUDIO")
				If Not @error Then
					$Count = $Count + 1
					$new_item = _GUICtrlListView_AddItem($Projects_Listview_projectman, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "name", "#ERROR#"), 39)
					_GUICtrlListView_AddSubItem($Projects_Listview_projectman, _GUICtrlListView_GetItemCount($Projects_Listview_projectman) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "author", ""), 1)
					_GUICtrlListView_AddSubItem($Projects_Listview_projectman, _GUICtrlListView_GetItemCount($Projects_Listview_projectman) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "comment", ""), 2)
					_GUICtrlListView_AddSubItem($Projects_Listview_projectman, _GUICtrlListView_GetItemCount($Projects_Listview_projectman) - 1, _ISN_Pfad_durch_Variablen_ersetzen($FullFilePath), 3)
					If $Group_Items = 1 Then _GUICtrlListView_SetItemGroupID($Projects_Listview_projectman, $new_item, $Group_index)
				EndIf
			EndIf
		EndIf
	WEnd
	FileClose($search)

	;Add aditional paths for ISN projects to the list and enable the group view (if vista or higher)
	If $Additional_project_paths <> "" Then
		$Additional_Paths_Array = StringSplit($Additional_project_paths, "|", 2)
		If IsArray($Additional_Paths_Array) Then
			For $path_count = 0 To UBound($Additional_Paths_Array) - 1
				If $Additional_Paths_Array[$path_count] = "" Then ContinueLoop
				If FileExists(_ISN_Variablen_aufloesen($Additional_Paths_Array[$path_count])) Then

					$Group_index = $Group_index + 1
					If $Group_Items = 1 Then
						_GUICtrlListView_InsertGroup($Projects_Listview_projectman, -1, $Group_index, _ISN_Variablen_aufloesen($Additional_Paths_Array[$path_count]), 1)
						_GUICtrlListView_SetGroupInfo($Projects_Listview_projectman, $Group_index, _ISN_Variablen_aufloesen($Additional_Paths_Array[$path_count]), 1, $LVGS_COLLAPSIBLE)
					EndIf


					$Search = FileFindFirstFile(_ISN_Variablen_aufloesen($Additional_Paths_Array[$path_count]) & "\*.*")
					While 1
						If $Search = -1 Then
							ExitLoop
						EndIf
						$File = FileFindNextFile($Search)
						If @error Then ExitLoop
						If $file = "." OR $file = ".." then ContinueLoop
						$FullFilePath = _ISN_Variablen_aufloesen($Additional_Paths_Array[$path_count]) & "\" & $File
						$FileAttributes = FileGetAttrib($FullFilePath)
						If StringInStr($FileAttributes, "D") Then
							If FileExists(_Finde_Projektdatei($FullFilePath)) Then
								$tmp_isn_file = _Finde_Projektdatei($FullFilePath)
								$tmp = IniReadSection($tmp_isn_file, "ISNAUTOITSTUDIO")
								If Not @error Then
									$Count = $Count + 1
									$new_item = _GUICtrlListView_AddItem($Projects_Listview_projectman, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "name", "#ERROR#"), 39)
									_GUICtrlListView_AddSubItem($Projects_Listview_projectman, _GUICtrlListView_GetItemCount($Projects_Listview_projectman) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "author", ""), 1)
									_GUICtrlListView_AddSubItem($Projects_Listview_projectman, _GUICtrlListView_GetItemCount($Projects_Listview_projectman) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "comment", ""), 2)
									_GUICtrlListView_AddSubItem($Projects_Listview_projectman, _GUICtrlListView_GetItemCount($Projects_Listview_projectman) - 1, _ISN_Pfad_durch_Variablen_ersetzen($FullFilePath), 3)
									If $Group_Items = 1 Then _GUICtrlListView_SetItemGroupID($Projects_Listview_projectman, $new_item, $Group_index)
								EndIf
							EndIf
						EndIf
					WEnd
					FileClose($search)

				EndIf
			Next
		EndIf
	EndIf

	_Sortiere_Listview($Projects_Listview_projectman, 0, 1)
	_Sortiere_Listview($Projects_Listview_projectman, 0)

	If $Group_Items = 1 And $Additional_project_paths <> "" Then _GUICtrlListView_EnableGroupView($Projects_Listview_projectman)

	_GUICtrlListView_EndUpdate($Projects_Listview_projectman)
	GUICtrlSetData($Found_Projects, $Count & " " & _Get_langstr(366))


EndFunc   ;==>ScanforProjects_Projectman

;Suche nach Vrolagen
Func ScanforVorlagen($SourceFolder)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath
	$Count = 0
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($vorlagen_Listview_projectman))
	_GUICtrlListView_BeginUpdate($vorlagen_Listview_projectman)
	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
	    If $file = "." OR $file = ".." then ContinueLoop
		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes, "D") Then
			If FileExists(_Finde_Projektdatei($FullFilePath)) Then
				$tmp_isn_file = _Finde_Projektdatei($FullFilePath)
				$Count = $Count + 1
				_GUICtrlListView_AddItem($vorlagen_Listview_projectman, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "name", "#ERROR#"), 10)
				$folder = StringTrimLeft($FullFilePath, StringInStr($FullFilePath, "\", 0, -1))
				_GUICtrlListView_AddSubItem($vorlagen_Listview_projectman, _GUICtrlListView_GetItemCount($vorlagen_Listview_projectman) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "author", ""), 1)
				_GUICtrlListView_AddSubItem($vorlagen_Listview_projectman, _GUICtrlListView_GetItemCount($vorlagen_Listview_projectman) - 1, $folder, 2)
			EndIf
		EndIf
	WEnd
	FileClose($search)
	$Descending = False
	_GUICtrlListView_SimpleSort($vorlagen_Listview_projectman, $Descending, 0)
	_GUICtrlListView_SetItemSelected($vorlagen_Listview_projectman, -1, False, False)
	_GUICtrlListView_EndUpdate($vorlagen_Listview_projectman)
	GUICtrlSetData($Found_Vorlagen, $Count & " " & _Get_langstr(377))
EndFunc   ;==>ScanforVorlagen


;Lade Details vom Projekt sobald darauf geklickt wird
Func _Load_Details_Manager()
	AdlibUnRegister("_Load_Details_Manager")
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then Return

	If $Offenes_Projekt = _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)) Then
		If BitAND(GUICtrlGetState($ISN_Projectmanager_DeleteProject_Button), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ISN_Projectmanager_DeleteProject_Button, $GUI_DISABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_RenameProject_Button), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ISN_Projectmanager_RenameProject_Button, $GUI_DISABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_CopyProject_Button), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ISN_Projectmanager_CopyProject_Button, $GUI_DISABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_ExportProject_Button), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ISN_Projectmanager_ExportProject_Button, $GUI_DISABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_ProjectChangeMainfile_Button), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ISN_Projectmanager_ProjectChangeMainfile_Button, $GUI_DISABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_ProjectRenameMainfile_Button), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ISN_Projectmanager_ProjectRenameMainfile_Button, $GUI_DISABLE)
	Else
		If BitAND(GUICtrlGetState($ISN_Projectmanager_OpenProject_Button), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ISN_Projectmanager_OpenProject_Button, $GUI_ENABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_DeleteProject_Button), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ISN_Projectmanager_DeleteProject_Button, $GUI_ENABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_RenameProject_Button), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ISN_Projectmanager_RenameProject_Button, $GUI_ENABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_CopyProject_Button), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ISN_Projectmanager_CopyProject_Button, $GUI_ENABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_ExportProject_Button), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ISN_Projectmanager_ExportProject_Button, $GUI_ENABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_ProjectChangeMainfile_Button), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ISN_Projectmanager_ProjectChangeMainfile_Button, $GUI_ENABLE)
		If BitAND(GUICtrlGetState($ISN_Projectmanager_ProjectRenameMainfile_Button), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ISN_Projectmanager_ProjectRenameMainfile_Button, $GUI_ENABLE)
	EndIf



	_GUICtrlListView_BeginUpdate($Projektverwaltung_Projektdetails_Listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projektverwaltung_Projektdetails_Listview))


	$isnpath = _Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)))
	$isndatei_name = StringTrimLeft($isnpath, StringInStr($isnpath, "\", 0, -1))
	$path = StringTrimRight($isnpath, StringLen($isnpath) - StringInStr($isnpath, "\", 0, -1) + 1)
	$data = ""
	$sizeF = DirGetSize($path, 1)
	if not IsArray($sizeF) then return
	$files = $sizeF[1]
	$folders = $sizeF[2]
	$sizeF[0] = Round($sizeF[0] / 1024)
	If $sizeF[0] > 1024 Then
		$sizeF[0] = Round($sizeF[0] / 1024) & " MB"
	Else
		$sizeF[0] = $sizeF[0] & " KB"
	EndIf
	Local $timer, $Secs, $Mins, $Hour, $Time
	$Time = IniRead($isnpath, "ISNAUTOITSTUDIO", "time", "0")
	_TicksToTime($Time, $Hour, $Mins, $Secs)

	$var = IniReadSectionNames($isnpath)
	$Anzahl_Makros_im_Projekt = 0
	If @error Then
		MsgBox(4096, "", "Error reading .isn file!")
	Else
		For $i = 1 To $var[0]
			If StringInStr($var[$i], "#isnrule#") Then
				$Anzahl_Makros_im_Projekt = $Anzahl_Makros_im_Projekt + 1
			EndIf
		Next
	EndIf



	;Projektname
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(368), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "name", ""), 1)

	;Version
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(217), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "version", ""), 1)

	;Name der Hauptdatei
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(16), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "mainfile", ""), 1)

	;Name der Projektdatei
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(1116), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $isndatei_name, 1)

	;Kommentar
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(133), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "comment", ""), 1)

	;Author
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(369), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "author", ""), 1)

	;Erstellt am
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(171), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "date", ""), 1)

	;Erstellt mit Studioversion
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(224), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "studioversion", ""), 1)

	;Größe
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(220), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $sizeF[0], 1)

	;Anzahl Dateien/Ordner
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(221), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, "(" & $files & " " & _Get_langstr(222) & " / " & $folders & " " & _Get_langstr(223) & ")", 1)

	;Zeit
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(225), 0)
	If $Offenes_Projekt = _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)) Then
		_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, "-", 1)
	Else
		_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $Hour & "h " & $Mins & "m " & $Secs & "s", 1)
	EndIf

	;Zuletzt geöffnet
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(370), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "lastopendate", ""), 1)

	;Wie oft geöffnet
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(397), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "projectopened", "") & "x", 1)

	;Makros Anzahl
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(707), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $Anzahl_Makros_im_Projekt, 1)

	;Speicherort
	_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(391), 0)
	_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, "..\" & _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3), 1)

	_GUICtrlListView_EndUpdate($Projektverwaltung_Projektdetails_Listview)
EndFunc   ;==>_Load_Details_Manager

Func _Try_to_delete_project()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf
	$folder = _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))
	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(169) & @CRLF & @CRLF & _Get_langstr(5) & " " & _
			IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "name", "#ERROR#") & @CRLF & _
			_Get_langstr(18) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "author", "#ERROR#") & @CRLF & _
			_Get_langstr(171) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "date", "#ERROR#") & @CRLF & _
			_Get_langstr(17) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "comment", "#ERROR#") & @CRLF & @CRLF & _
			_Get_langstr(172), 0, $projectmanager)

	If $answer = 6 Then
		DirRemove($folder, 1)
		_Show_Projectman()
	EndIf
EndFunc   ;==>_Try_to_delete_project

;Kopie von Projekt erstellen
Func _Copy_project()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf

	$source_project_path = _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)
	If Not StringInStr($source_project_path, "\") Then Return
	$Source_project_Root = StringTrimRight($source_project_path, StringLen($source_project_path) - StringInStr($source_project_path, "\", 0, -1) + 1)
	$answer = InputBox(_Get_langstr(48), _Get_langstr(372), _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 0) & " (" & _Get_langstr(373) & ")", "", Default, Default, Default, Default, 0, $projectmanager)
	If @error Then Return
	If FileExists(_ISN_Variablen_aufloesen($Source_project_Root & "\" & $answer)) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(27), 0, $projectmanager)
		Return
	EndIf
	$answer = StringReplace($answer, "?", "")
	$answer = StringReplace($answer, "=", "")
	$answer = StringReplace($answer, ".", "")
	$answer = StringReplace($answer, ",", "")
	$answer = StringReplace($answer, "\", "")
	$answer = StringReplace($answer, "/", "")
	$answer = StringReplace($answer, '"', "")
	$answer = StringReplace($answer, "<", "")
	$answer = StringReplace($answer, ">", "")
	$answer = StringReplace($answer, "|", "")
	FileChangeDir(@ScriptDir)
	_FileOperationProgress(_ISN_Variablen_aufloesen($source_project_path & "\*.*"), _ISN_Variablen_aufloesen($Source_project_Root & "\" & $answer), 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
	If @extended == 1 Then ;ERROR
		DirRemove(_ISN_Variablen_aufloesen($Source_project_Root & "\" & $answer), 1) ;cleanup
		Return
	EndIf
	IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Source_project_Root & "\" & $answer)), "ISNAUTOITSTUDIO", "name", $answer)
	IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Source_project_Root & "\" & $answer)), "ISNAUTOITSTUDIO", "date", @MDAY & "." & @MON & "." & @YEAR)
	_Show_Projectman()
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(374), 0, $projectmanager)
EndFunc   ;==>_Copy_project




;Öffne Projekt vom Projektmanager aus
Func _Try_to_Open_projectman()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(29), 0, $projectmanager)
		Return
	EndIf

	If $Offenes_Projekt = _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)) Then
	    ;needed project is alredy opened
		GUISetState(@SW_HIDE, $projectmanager)
		RETURN
	 EndIf


	If $Offenes_Projekt <> "" Then
		$msgbox_res = MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(393), 0, $projectmanager)
		If $msgbox_res <> 6 Or @error Then Return
		GUISetState(@SW_HIDE, $projectmanager)
		_Close_Project()
	EndIf




	$PID_Read = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "opened", "")
	If ProcessExists($PID_Read) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(331), 0, $projectmanager)
		Return
	EndIf
	_Load_Project_by_Foldername(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)))
EndFunc   ;==>_Try_to_Open_projectman






;Hauptdatei umbenennen
Func _rename_mainfile()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf
	$isnpath = _Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)))
	$answer = InputBox(_Get_langstr(48), _Get_langstr(375), IniRead($isnpath, "ISNAUTOITSTUDIO", "mainfile", ""), "", Default, Default, Default, Default, 0, $projectmanager)
	If $answer = "" Then Return
	If @error Then Return
	If $answer == IniRead($isnpath, "ISNAUTOITSTUDIO", "mainfile", "") Then Return
	$answer = StringReplace($answer, "?", "")
	$answer = StringReplace($answer, "=", "")
	$answer = StringReplace($answer, ",", "")
	$answer = StringReplace($answer, "\", "")
	$answer = StringReplace($answer, "/", "")
	$answer = StringReplace($answer, '"', "")
	$answer = StringReplace($answer, "<", "")
	$answer = StringReplace($answer, ">", "")
	$answer = StringReplace($answer, "|", "")
	FileChangeDir(@ScriptDir)
	FileMove(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3) & "\" & IniRead($isnpath, "ISNAUTOITSTUDIO", "mainfile", "")), _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3) & "\" & $answer), 9)
	IniWrite($isnpath, "ISNAUTOITSTUDIO", "mainfile", $answer)
	_Load_Details_Manager()
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(376), 0, $projectmanager)
EndFunc   ;==>_rename_mainfile


;Löscht markierte Vorlage
Func _delete_template()
	If _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(380), 0, $projectmanager)
		Return
	EndIf
	If _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2) = "default" Then ;Schütze default Vorlage
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(379), 0, $projectmanager)
		Return
	EndIf
	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(382) & " " & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 0), 0, $projectmanager)
	If $answer = 6 Then
		DirRemove(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2)), 1)
		_Show_Projectman()
	EndIf
EndFunc   ;==>_delete_template


;Vorlage umbenennen
Func _Rename_template()
	If _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(380), 0, $projectmanager)
		Return
	EndIf
	If _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2) = "default" Then ;Schütze default Vorlage
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(720), 0, $projectmanager)
		Return
	EndIf

	$var = InputBox(_Get_langstr(721), _Get_langstr(721), IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2))), "ISNAUTOITSTUDIO", "name", ""), "", 200, 150, Default, Default, -1, $projectmanager)
	If $var = "" Then Return
	If @error = 0 Then
		If $var = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2))), "ISNAUTOITSTUDIO", "name", "") Then Return
		IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2))), "ISNAUTOITSTUDIO", "name", $var)
		_Show_Projectman()
	EndIf
EndFunc   ;==>_Rename_template


;Vorlage Autor ändern
Func _Rename_autor_template()
	If _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(380), 0, $projectmanager)
		Return
	EndIf

	$var = InputBox(_Get_langstr(229), _Get_langstr(229), IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2))), "ISNAUTOITSTUDIO", "author", ""), "", 200, 150, Default, Default, -1, $projectmanager)
	If @error = 0 Then
		If $var = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2))), "ISNAUTOITSTUDIO", "author", "") Then Return
		IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2))), "ISNAUTOITSTUDIO", "author", $var)
		_Show_Projectman()
	EndIf
EndFunc   ;==>_Rename_autor_template



;Vorlage im Windows Explorer anzeigen
Func _Projektverwaltung_Zeige_Vorlage_im_Windows_Explorer()
	If _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(380), 0, $projectmanager)
		Return
	EndIf

	ShellExecute(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2)))
EndFunc   ;==>_Projektverwaltung_Zeige_Vorlage_im_Windows_Explorer



;Öffne Projekt vom Projektmanager aus
Func _Try_to_Open_template()
	If _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(380), 0, $projectmanager)
		Return
	EndIf

	If $Offenes_Projekt <> "" Then
		$msgbox_res = MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(393), 0, $projectmanager)
		If $msgbox_res <> 6 Or @error Then Return
		GUISetState(@SW_HIDE, $projectmanager)
		_Close_Project()
		GUISetState(@SW_HIDE, $Welcome_GUI)
	EndIf

	$PID_Read = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2))), "ISNAUTOITSTUDIO", "opened", "")
	If ProcessExists($PID_Read) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(331), 0, $projectmanager)
		Return
	EndIf
	$Templatemode = 1
	_show_Loading(_Get_langstr(385), _Get_langstr(23))
	GUISetState(@SW_HIDE, $projectmanager)

	GUICtrlSetState($HD_Logo, $GUI_HIDE)
	_Write_log(_Get_langstr(385) & "(" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 0) & ")", "000000", "true", "true")
	_Loading_Progress(30)
	_Load_Project(_ISN_Variablen_aufloesen($templatefolder & "\" & _GUICtrlListView_GetItemText($vorlagen_Listview_projectman, _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman), 2)))
	_Loading_Progress(100)
	_GUICtrlTreeView_ExpandOneLevel($hTreeView, $hroot)
	_Check_tabs_for_changes()
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", @AutoItPID)
	GUISetState(@SW_ENABLE, $StudioFenster)
	_Hide_Loading()
    _QuickView_Tab_Event()
	Sleep(200)
	_Show_Warning("confirmtemplate", 513, _Get_langstr(383), _Get_langstr(384), _Get_langstr(7))
EndFunc   ;==>_Try_to_Open_template

;Kommentar ändern
Func _Rename_Comment_manager()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf

	$var = InputBox(_Get_langstr(231), _Get_langstr(231), IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "comment", ""), "", 200, 150, Default, Default, -1, $projectmanager)
	If @error = 0 Then
		If $var = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "comment", "") Then Return
		IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "comment", $var)
		_GUICtrlListView_SetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), $var, 2)
		_Load_Details_Manager()
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(232), 0, $projectmanager)
	EndIf
EndFunc   ;==>_Rename_Comment_manager


;Projektnamen
Func _Rename_project_manager()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf

	$project_path = _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)
	$project_Root = StringTrimRight($project_path, StringLen($project_path) - StringInStr($project_path, "\", 0, -1) + 1)
	$var = InputBox(_Get_langstr(226), _Get_langstr(226), IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "name", ""), "", 200, 150, Default, Default, -1, $projectmanager)
	If $var = "" Then Return
	If @error = 0 Then
		If $var = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "name", "") Then Return
		$var = StringReplace($var, "|", "")
		$var = StringReplace($var, "?", "")
		$var = StringReplace($var, "*", "")
		$var = StringReplace($var, "\", "")
		$var = StringReplace($var, "/", "")
		$var = StringReplace($var, '"', "")
		$var = StringReplace($var, "'", "")
		If $var = "" Then Return
		$var2 = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(804), 0, $projectmanager)

		IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "name", $var)
		If $var2 = 6 Then
			;Projektordner umbenennen
			If FileExists(_ISN_Variablen_aufloesen($project_Root & "\" & $var)) Then
				If _ISN_Variablen_aufloesen($project_Root & "\" & $var) <> _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)) Then MsgBox(262144 + 48, _Get_langstr(25), _Get_langstr(805), 0, $projectmanager)

			Else
				DirMove(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)), _ISN_Variablen_aufloesen($project_Root & "\" & $var), 0)
			EndIf
		EndIf
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(392), 0, $projectmanager)
		_Show_Projectman()
	EndIf
EndFunc   ;==>_Rename_project_manager



Func _Rename_author_manager()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf

	$var = InputBox(_Get_langstr(229), _Get_langstr(229), IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "author", ""), "", 200, 150, Default, Default, -1, $projectmanager)
	If @error = 0 Then
		If $var = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "author", "") Then Return
		IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "author", $var)
		_GUICtrlListView_SetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), $var, 1)
		_Load_Details_Manager()
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(230), 0, $projectmanager)
	EndIf
EndFunc   ;==>_Rename_author_manager


;Projektversion
Func _Rename_version_manager()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf

	$var = InputBox(_Get_langstr(233), _Get_langstr(233), IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "version", ""), "", 200, 150, Default, Default, -1, $projectmanager)
	If @error = 0 Then
		If $var = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "version", "") Then Return
		IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))), "ISNAUTOITSTUDIO", "version", $var)
		_Load_Details_Manager()
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(234), 0, $projectmanager)
	EndIf
EndFunc   ;==>_Rename_version_manager

Func _Show_new_Template()
	GUICtrlSetData($INPUT_VORLAGENAME, "")
	GUICtrlSetData($INPUT_VORLAGEAUTHOR, "")
	GUISetState(@SW_SHOW, $TemplateNEU)
	GUISetState(@SW_DISABLE, $projectmanager)
EndFunc   ;==>_Show_new_Template

Func _hide_new_Template()
	GUISetState(@SW_ENABLE, $projectmanager)
	GUISetState(@SW_HIDE, $TemplateNEU)
EndFunc   ;==>_hide_new_Template


Func _Create_Template()
	If GUICtrlRead($INPUT_VORLAGENAME) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(395), 0, $TemplateNEU)
		_Input_Error_FX($INPUT_VORLAGENAME)
		Return
	EndIf

	$i = GUICtrlRead($INPUT_VORLAGENAME)
	If StringInStr($i, "\") Or StringInStr($i, "/") Or StringInStr($i, "?") Or StringInStr($i, ":") Or StringInStr($i, "*") Or StringInStr($i, "|") Or StringInStr($i, "<") Or StringInStr($i, ">") Or StringInStr($i, "'") Or StringInStr($i, '"') Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(396) & @CRLF & _Get_langstr(389), 0, $TemplateNEU)
		Return
	EndIf

	If GUICtrlRead($INPUT_VORLAGENAME) = "default" Then Return
	_hide_new_Template()
	DirCreate(_ISN_Variablen_aufloesen($templatefolder & "\" & GUICtrlRead($INPUT_VORLAGENAME)))
	_Leere_UTF16_Datei_erstellen(_ISN_Variablen_aufloesen($templatefolder & "\" & GUICtrlRead($INPUT_VORLAGENAME) & "\project.isn"))
	IniWrite(_ISN_Variablen_aufloesen($templatefolder & "\" & GUICtrlRead($INPUT_VORLAGENAME) & "\project.isn"), "ISNAUTOITSTUDIO", "name", GUICtrlRead($INPUT_VORLAGENAME))
	IniWrite(_ISN_Variablen_aufloesen($templatefolder & "\" & GUICtrlRead($INPUT_VORLAGENAME) & "\project.isn"), "ISNAUTOITSTUDIO", "author", GUICtrlRead($INPUT_VORLAGEAUTHOR))
	IniWrite(_ISN_Variablen_aufloesen($templatefolder & "\" & GUICtrlRead($INPUT_VORLAGENAME) & "\project.isn"), "ISNAUTOITSTUDIO", "mainfile", GUICtrlRead($INPUT_VORLAGENAME) & ".au3")
	_FileCreate(_ISN_Variablen_aufloesen($templatefolder & "\" & GUICtrlRead($INPUT_VORLAGENAME) & "\" & GUICtrlRead($INPUT_VORLAGENAME) & ".au3"))

	_Show_Projectman()
EndFunc   ;==>_Create_Template

Func _Export_to_ISP()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf
	$project_path = _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)
	$project_Root = StringTrimRight($project_path, StringLen($project_path) - StringInStr($project_path, "\", 0, -1) + 1)
	$line = FileSaveDialog(_Get_langstr(470), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Compressed ISN AutoIt Studio Project (*.isp)", 18, _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 0), $projectmanager)
	If $line = "" Then Return
	If @error > 0 Then Return

	$CurZipSize = 0
	$UnCompSize = DirGetSize(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)))
	If Not StringInStr($line, ".isp") Then $line = $line & ".isp"
	If FileExists($line) Then FileDelete($line)
	GUISetState(@SW_DISABLE, $projectmanager)


	Global $RootDir = DllStructCreate("char[256]")
	DllStructSetData($RootDir, 1, _ISN_Variablen_aufloesen($project_Root))

	Global $TempDir = DllStructCreate("char[256]")
	DllStructSetData($TempDir, 1, @TempDir)

	Global $ZPOPT = DllStructCreate("ptr Date;ptr szRootDir;ptr szTempDir;int fTemp;int fSuffix;int fEncrypt;int fSystem;" & _
			"int fVolume;int fExtra;int fNoDirEntries;int fExcludeDate;int fIncludeDate;int fVerbose;" & _
			"int fQuiet;int fCRLFLF;int fLFCRLF;int fJunkDir;int fGrow;int fForce;int fMove;" & _
			"int fDeleteEntries;int fUpdate;int fFreshen;int fJunkSFX;int fLatestTime;int fComment;" & _
			"int fOffsets;int fPrivilege;int fEncryption;int fRecurse;int fRepair;char fLevel[2]")

	DllStructSetData($ZPOPT, "szRootDir", DllStructGetPtr($RootDir))
	DllStructSetData($ZPOPT, "szTempDir", DllStructGetPtr($TempDir))
	DllStructSetData($ZPOPT, "fTemp", 0)
	DllStructSetData($ZPOPT, "fVolume", 0)
	DllStructSetData($ZPOPT, "fExtra", 0)
	DllStructSetData($ZPOPT, "fVerbose", 1)
	DllStructSetData($ZPOPT, "fQuiet", 0)
	DllStructSetData($ZPOPT, "fCRLFLF", 0)
	DllStructSetData($ZPOPT, "fLFCRLF", 0)
	DllStructSetData($ZPOPT, "fGrow", 0)
	DllStructSetData($ZPOPT, "fForce", 0)
	DllStructSetData($ZPOPT, "fDeleteEntries", 0)
	DllStructSetData($ZPOPT, "fJunkSFX", 0)
	DllStructSetData($ZPOPT, "fOffsets", 0)
	DllStructSetData($ZPOPT, "fRepair", 0)

	_Zip_Init("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
	$res = MsgBox(262144 + 4 + 32, _Get_langstr(48), _Get_langstr(472), 0, $projectmanager)
	If $res = 6 Then
		_ZIP_SetOptions(0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 9)
	Else
		_ZIP_SetOptions(0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 9)
	EndIf
	_show_Loading(_Get_langstr(470), _Get_langstr(23))
	_Loading_Progress(10)
	$path = _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3) & "\*.*")
	$result = _ZIP_Archive($line, $path)
	_Loading_Progress(100)
	_GUICtrlStatusBar_SetText($Status_bar, "")
	Sleep(100)
	GUISetState(@SW_ENABLE, $projectmanager)
	_Hide_Loading()
	FileChangeDir(@ScriptDir)
	If $result = 1 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $projectmanager)
EndFunc   ;==>_Export_to_ISP








Func _Import_project($path = "")
	If Not IsDeclared("path") Then $path = ""
	If $path = "" Then
		 if $Skin_is_used = "true" Then
			$var = _WinAPI_OpenFileDlg (_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}","ISN AutoIt Studio Projects (*.isp;*isn)", 0 ,'' , '' , BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY),  $OFN_EX_NOPLACESBAR , 0 , 0, $projectmanager)
		 else
			$var = FileOpenDialog(_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}","ISN AutoIt Studio Projects (*.isp;*isn)", 1 + 2 , "", $projectmanager)
		 Endif

		FileChangeDir(@ScriptDir)
		If @error Then Return
		If $var = "" Then Return
	Else
		$var = $path
	EndIf

	GUISetState(@SW_DISABLE, $projectmanager)
	_show_Loading(_Get_langstr(475), _Get_langstr(23))



	$randomid = Random(1, 2000, 1)
	DirCreate($Arbeitsverzeichnis & "\data\Cache\import" & $randomid)
	_Loading_Progress(100)

	$pathtoisnfile = ""
	$folderpath = ""
	$foldername = ""
	If StringInStr($var, ".isp") Then
		$CurZipSize = 0
		_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "_UnZIP_ServiceFunc")
		_UnZIP_SetOptions()
		$result = _UnZIP_Unzip($var, $Arbeitsverzeichnis & "\data\Cache\import" & $randomid)
		$Search = FileFindFirstFile($Arbeitsverzeichnis & "\data\Cache\import" & $randomid & "\*.*")
		$File = FileFindNextFile($Search)
		FileClose($search)
		If $file = "." OR $file = ".." then return
		$pathtoisnfile = _Finde_Projektdatei($Arbeitsverzeichnis & "\data\Cache\import" & $randomid & "\" & $File)
		$folderpath = $Arbeitsverzeichnis & "\data\Cache\import" & $randomid & "\" & $File
		$foldername = $File
		$temp = IniReadSection($pathtoisnfile, "ISNAUTOITSTUDIO")
		If @error Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(476), 0, $projectmanager)
			_GUICtrlStatusBar_SetText($Status_bar, "")
			DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
			GUISetState(@SW_ENABLE, $projectmanager)
			_Hide_Loading()
			Return
		EndIf
	Else ;isn file
		$pathtoisnfile = $var
		$folderpath = StringTrimRight($var, StringLen($var) - StringInStr($var, "\", 0, -1) + 1)
		$foldername = StringTrimLeft($folderpath, StringInStr($folderpath, "\", 0, -1))
		$temp = IniReadSection($pathtoisnfile, "ISNAUTOITSTUDIO")
		If @error Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(476), 0, $projectmanager)
			_GUICtrlStatusBar_SetText($Status_bar, "")
			DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
			GUISetState(@SW_ENABLE, $projectmanager)
			_Hide_Loading()
			Return
		EndIf
	EndIf



	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(477) & @CRLF & @CRLF & _Get_langstr(5) & " " & _
			IniRead(_Finde_Projektdatei($folderpath), "ISNAUTOITSTUDIO", "name", "#ERROR#") & @CRLF & _
			_Get_langstr(18) & " " & IniRead(_Finde_Projektdatei($folderpath), "ISNAUTOITSTUDIO", "author", "#ERROR#") & @CRLF & _
			_Get_langstr(171) & " " & IniRead(_Finde_Projektdatei($folderpath), "ISNAUTOITSTUDIO", "date", "#ERROR#") & @CRLF & _
			_Get_langstr(217) & " " & IniRead(_Finde_Projektdatei($folderpath), "ISNAUTOITSTUDIO", "version", "") & @CRLF & _
			_Get_langstr(17) & " " & IniRead(_Finde_Projektdatei($folderpath), "ISNAUTOITSTUDIO", "comment", "#ERROR#") & @CRLF, 0, $projectmanager)
	If $answer = 7 Then
		DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
		_GUICtrlStatusBar_SetText($Status_bar, "")
		GUISetState(@SW_ENABLE, $projectmanager)
		_Hide_Loading()
		Return
	EndIf


	If FileExists(_ISN_Variablen_aufloesen($Projectfolder & "\" & $foldername)) Then
		$res = MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(481), 0, $projectmanager)
		If $res = 7 Then
			DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
			_GUICtrlStatusBar_SetText($Status_bar, "")
			GUISetState(@SW_ENABLE, $projectmanager)
			_Hide_Loading()
			Return
		EndIf
	EndIf


	$res = _FileOperationProgress($folderpath, _ISN_Variablen_aufloesen($Projectfolder & "\"), 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)


	DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
	_GUICtrlStatusBar_SetText($Status_bar, "")
	_Loading_Progress(100)
	Sleep(100)
	GUISetState(@SW_ENABLE, $projectmanager)
	_Hide_Loading()
	ScanforProjects_Projectman()
	If $res = 1 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(478), 0, $projectmanager)
	DirRemove($Arbeitsverzeichnis & "\data\Cache\import" & $randomid, 1)
EndFunc   ;==>_Import_project


Func _Open_project_inExplorer()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf

	ShellExecute(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)))
EndFunc   ;==>_Open_project_inExplorer


;==========================# ZIP Dll-callback functions #======================================
Func _ZIPPrint($sFile, $sPos)
;~ 	ConsoleWrite("!> _ZIPPrint: " & $sFile & @LF)
EndFunc   ;==>_ZIPPrint

Func _ZIPPassword($sPWD, $sX, $sS2, $sName)
	Local $iPass = InputBox(_Get_langstr(48), _Get_langstr(473), "", "*", 300, 150)

	If $iPass = "" Then Return 1

	Local $PassBuff = DllStructCreate("char[256]", $sPWD)
	DllStructSetData($PassBuff, 1, $iPass)
EndFunc   ;==>_ZIPPassword

Func _ZIPComment($sComment)
	Local $iComment = InputBox("Archive comment set", "Enter the comment", "", "", 300, 120)
	If $iComment = "" Then Return 1

	Local $CommentBuff = DllStructCreate("char[256]", $sComment)
	DllStructSetData($CommentBuff, 1, $iComment)
EndFunc   ;==>_ZIPComment

Func _ZIPProgress($sName, $sSize)
	$CurZipSize += Number($sSize)
	Local $iPercent = Round(($CurZipSize / $UnCompSize * 100))
	_Loading_Progress($iPercent)
	_GUICtrlStatusBar_SetText($Status_bar, $sName)
EndFunc   ;==>_ZIPProgress


;==========================# UnZIP Dll-callback functions #========================================
Func _UnZIP_PrintFunc($sName, $sPos)
;~ 	ConsoleWrite("---> _UnZIP_PrintFunc: " & $sName & @LF)
EndFunc   ;==>_UnZIP_PrintFunc

Func UnZIP_ReplaceFunc($sReplace)
	If MsgBox(4 + 32, "Overwrite", "File " & $sReplace & " is exists." & @LF & "Do you want to overwrite all file?") = 6 Then
		Return $IDM_REPLACE_ALL
	Else
		Return $IDM_REPLACE_NONE
	EndIf
EndFunc   ;==>UnZIP_ReplaceFunc

Func _UnZIP_PasswordFunc($sPWD, $sX, $sS2, $sName)
;~ 	ConsoleWrite("!> UnZIP_PasswordFunc: " & $sPWD & @LF)

	Local $iPass = InputBox(_Get_langstr(474), _Get_langstr(473), "", "*", 300, 150)
	If $iPass = "" Then
		_Reload_Zip()
		Return 1
	EndIf
	If @error Then
		_Reload_Zip()
		Return 1
	EndIf


	Local $PassBuff = DllStructCreate("char[256]", $sPWD)
	DllStructSetData($PassBuff, 1, $iPass)
EndFunc   ;==>_UnZIP_PasswordFunc

Func _UnZIP_SendAppMsgFunc($sUcsize, $sCsize, $sCfactor, $sMo, $Dy, $sYr, $sHh, $sMm, $sC, $sFname, $sMeth, $sCRC, $fCrypt)
	;ConsoleWrite("!> _UnZIP_SendAppMsgFunc: " & $sUcsize & @LF)
EndFunc   ;==>_UnZIP_SendAppMsgFunc

Func _UnZIP_ServiceFunc($sName, $sSize)
	;return 1
	;Return 1 for abort the unzip!
;~ 	GUICtrlSetData($edit, $sName & @CRLF, 1)
	_GUICtrlStatusBar_SetText($Status_bar, StringReplace($sName, "/", "\"))
;~ 	ConsoleWrite("!> Size: " & $sSize & @LF & _
;~ 				 "!> FileName" & $sName & @LF)

EndFunc   ;==>_UnZIP_ServiceFunc

Func _exportiere_Projektdetails_als_csv()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf

	$line = FileSaveDialog(_Get_langstr(740), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "csv (*.csv)", 18, "export.csv", $projectmanager)
	If $line = "" Then Return
	If @error > 0 Then Return
	FileChangeDir(@ScriptDir)
	_GUICtrlListView_SaveCSV($Projektverwaltung_Projektdetails_Listview, $line)
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $StudioFenster)
EndFunc   ;==>_exportiere_Projektdetails_als_csv

Func _Projektverwaltung_aendere_Hauptdatei()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf
	$isnpath = _Finde_Projektdatei(_ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3)))
	$path = StringTrimRight($isnpath, StringLen($isnpath) - StringInStr($isnpath, "\", 0, -1) + 1)
	GUICtrlSetOnEvent($Choose_File_GUI_OK, "_Projektverwaltung_aendere_Hauptdatei_OK")
	GUICtrlSetOnEvent($Choose_File_GUI_Abbrechen, "_Projektverwaltung_aendere_Hauptdatei_Abbrechen")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Projektverwaltung_aendere_Hauptdatei_Abbrechen", $Choose_File_GUI)
	GUISetState(@SW_DISABLE, $projectmanager)
	_Projektverwaltung_aendere_Hauptdatei_Choose_File("*.au3;", $path)
EndFunc   ;==>_Projektverwaltung_aendere_Hauptdatei

Func _Projekteigenschaften_aendere_Hauptdatei()
	GUICtrlSetOnEvent($Choose_File_GUI_OK, "_Projekteigenschaften_aendere_Hauptdatei_OK")
	GUICtrlSetOnEvent($Choose_File_GUI_Abbrechen, "_Projekteigenschaften_aendere_Hauptdatei_abbrechen")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Projekteigenschaften_aendere_Hauptdatei_abbrechen", $Choose_File_GUI)
	GUISetState(@SW_DISABLE, $Projekteinstellungen_GUI)
	_Projektverwaltung_aendere_Hauptdatei_Choose_File("*.au3;", $Offenes_Projekt)
EndFunc   ;==>_Projekteigenschaften_aendere_Hauptdatei

Func _Projekteigenschaften_aendere_Hauptdatei_abbrechen()
	GUISetState(@SW_ENABLE, $Projekteinstellungen_GUI)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview, 1) ;Zerstöre Treeview
EndFunc   ;==>_Projekteigenschaften_aendere_Hauptdatei_abbrechen


Func _Projekteigenschaften_aendere_Hauptdatei_OK()
	If _IsDir(_GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)) Then Return
	GUISetState(@SW_ENABLE, $Projekteinstellungen_GUI)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	$gelesener_pfad = _GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)
	$isnpath = _Finde_Projektdatei(_GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview))
	$gelesener_pfad = StringReplace($gelesener_pfad, _GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview) & "\", "")
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview, 1) ;Zerstöre Treeview
	IniWrite($isnpath, "ISNAUTOITSTUDIO", "mainfile", $gelesener_pfad)
	_Zeige_Projekteinstellungen("projectproberties")
EndFunc   ;==>_Projekteigenschaften_aendere_Hauptdatei_OK


Func _Projektverwaltung_aendere_Hauptdatei_Choose_File($Filter = "", $Pfad = "")
	$FilechooseFilter = $Filter
	Local $root = ""
	GUICtrlSetData($Choose_File_GUI_Label, _Get_langstr(874))
	GUISwitch($Choose_File_GUI)
	Local $AutoIt_Projekte_in_Projektbaum_anzeigen_backup = $AutoIt_Projekte_in_Projektbaum_anzeigen
	$AutoIt_Projekte_in_Projektbaum_anzeigen = "false"
	Global $Choose_File_Treeview = _GUICtrlTVExplorer_Create($Pfad, 10 * $DPI, 40 * $DPI, 480 * $DPI, 355 * $DPI, -1, $WS_EX_CLIENTEDGE, $TV_FLAG_SHOWFILESEXTENSION + $TV_FLAG_SHOWFILES + $TV_FLAG_SHOWFOLDERICON + $TV_FLAG_SHOWFILEICON + $TV_FLAG_SHOWLIKEEXPLORER, "_Projecttree_event", $Filter)
	Global $Choose_File_hTreeview = GUICtrlGetHandle($Choose_File_Treeview)
	$AutoIt_Projekte_in_Projektbaum_anzeigen = $AutoIt_Projekte_in_Projektbaum_anzeigen_backup
	GUICtrlSetFont($Choose_File_Treeview, $treefont_size, 400, 0, $treefont_font) ;Schrift
	GUICtrlSetColor($Choose_File_Treeview, $treefont_colour) ;Farbe
	_GUICtrlTVExplorer_Expand($Choose_File_hTreeview)
	GUICtrlSetState($Choose_File_GUI_Mehr, $GUI_HIDE)
	GUISetState(@SW_SHOW, $Choose_File_GUI)
	WinSetOnTop($Choose_File_GUI, "", 1)
EndFunc   ;==>_Projektverwaltung_aendere_Hauptdatei_Choose_File

Func _Projektverwaltung_aendere_Hauptdatei_OK()
	If _IsDir(_GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)) Then Return
	GUISetState(@SW_ENABLE, $projectmanager)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	$gelesener_pfad = _GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)
	$isnpath = _Finde_Projektdatei(_GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview))
	$gelesener_pfad = StringReplace($gelesener_pfad, _GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview) & "\", "")
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview, 1) ;Zerstöre Treeview
	IniWrite($isnpath, "ISNAUTOITSTUDIO", "mainfile", $gelesener_pfad)
	_Load_Details_Manager()
EndFunc   ;==>_Projektverwaltung_aendere_Hauptdatei_OK

Func _Projektverwaltung_aendere_Hauptdatei_Abbrechen()
	GUISetState(@SW_ENABLE, $projectmanager)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview, 1) ;Zerstöre Treeview
EndFunc   ;==>_Projektverwaltung_aendere_Hauptdatei_Abbrechen

Func _Import_Project_CMD($path = "")
	If $path = "" Then Return
	_Fadeout_logo()
	_Show_Projectman()
	_Import_project($path)
EndFunc   ;==>_Import_Project_CMD


Func _Projectmanager_move_project_to_new_location_drag($new_location = "")
	If $new_location = "" Then Return
	If $Additional_project_paths = "" Then Return
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then Return
	$Source_Project_Name = _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 0)
	$Source_Path = _ISN_Variablen_aufloesen(_GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))
	$Source_Root_Path = StringTrimRight($Source_Path, StringLen($Source_Path) - StringInStr($Source_Path, "\", 0, -1) + 1)
	$Source_Folder_Name = StringTrimLeft($Source_Path, StringInStr($Source_Path, "\", 0, -1))
   If $Offenes_Projekt = $Source_Path Then return ;cant move opened project


	$New_Location_Root_Path = _ISN_Variablen_aufloesen(StringTrimRight($new_location, StringLen($new_location) - StringInStr($new_location, "\", 0, -1) + 1))
	If Not FileExists($New_Location_Root_Path) Then Return
	If $New_Location_Root_Path = $Source_Root_Path Then Return ;no need to move


	If FileExists($New_Location_Root_Path & "\" & $Source_Folder_Name) Then
		MsgBox($MB_TOPMOST + $MB_ICONERROR, _Get_langstr(25), _Get_langstr(27), 0, $projectmanager)
		Return
	EndIf

	$Qustion = _Get_langstr(1346)
	$Qustion = StringReplace($Qustion, "%1", $Source_Project_Name)
	$Qustion = StringReplace($Qustion, "%2", $Source_Root_Path)
	$Qustion = StringReplace($Qustion, "%3", $New_Location_Root_Path)
	$Qustion_res = MsgBox($MB_TOPMOST + $MB_YESNO + $MB_ICONQUESTION, _Get_langstr(48), $Qustion, 0, $projectmanager)
	If @error Or $Qustion_res <> 6 Then Return

	If _FileOperationProgress($Source_Path, $New_Location_Root_Path, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION) Then
		ScanforProjects_Projectman()
		MsgBox($MB_TOPMOST + $MB_ICONINFORMATION, _Get_langstr(61), _Get_langstr(1330), 0, $projectmanager)
	Else
		MsgBox($MB_TOPMOST + $MB_ICONERROR, _Get_langstr(25), _Get_langstr(1331), 0, $projectmanager)
	EndIf

EndFunc   ;==>_Projectmanager_move_project_to_new_location_drag

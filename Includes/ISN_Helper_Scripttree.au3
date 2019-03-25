

Func _StringSplitCRLF($sText, $sDelimeter = "<##BREAK##>")
	Local $sTemp = StringReplace($sText, @CRLF, $sDelimeter)
	Return StringSplit($sTemp, $sDelimeter, 3)
EndFunc   ;==>_StringSplitCRLF

Func _Pruefe_Filter($str = "")
	If $str = "" Then Return "true"
	If Not IsArray($Skriptbaum_Filter_Array) Then Return "false"
	If UBound($Skriptbaum_Filter_Array) < 1 Then Return "false"
	For $filter_count = 0 To UBound($Skriptbaum_Filter_Array) - 1
		If CoreFx_WildcardMatchExA($str, $Skriptbaum_Filter_Array[$filter_count]) Then Return "true" ;Element sollte gefiltert werden
	Next
	Return "false" ;Element ist nicht im filter
EndFunc   ;==>_Pruefe_Filter


Func _Scripttree_reload_filterarray()
	If $ISN_AutoIt_Studio_ISN_file_Path = "" Then Return
	$Skriptbaum_Filter_Array = StringSplit(IniRead($ISN_AutoIt_Studio_ISN_file_Path, "ISNAUTOITSTUDIO", "scripttreefilter", ""), "|", 2)
	_ArraySort($Skriptbaum_Filter_Array)
EndFunc   ;==>_Scripttree_reload_filterarray


Func _Array_Remove_Duplicates_and_Count($aData, $mode = 1, $sepChar = ",") ; mode: 1 = 1D Rückgabe , 2 = 2D Rückgabe

	If Not IsArray($aData) Then Return -1 ; wichtig: bitte Rückgabe dieser Funktion prüfen bevor weiter gearbeitet wird...

	Local $aNew[UBound($aData)][2] ; für 2D Rückgabe // geändert: array wird am schluß neu dimensioniert!
	Local $aNew1D[1] ; für 1D Rückgabe
	Local $sTemp = $sepChar ; string verkettung des ergebnis arrays für schnelle unique prüfung
	Local $j = 0 ; zahl der unique treffer


	; Anmerkung: Der Vergleich sollt vielleicht doch nicht case sensitiv sein, da ansonsten gleichnamige Variablen mit anderer Schreibweise nicht erkannt werden, daher wieder auf not casesensitiv geändert, ist aber ein wenig langsamer...
	For $i = 0 To UBound($aData) - 1
		If _Pruefe_Filter($aData[$i]) = "true" Then ContinueLoop ;Filter
		If StringInStr($sTemp, $sepChar & $aData[$i] & $sepChar, 0, -1) Then ; stringprüfung arbeitet schneller als große arrays zu durchlaufen und "viele" strings zu vergleichen // geändert: sepchar muss nun ganze Variable umschließen
			For $k = 0 To UBound($aNew) - 1 ; bei bereits vorhandenen einträgen müssen wir zwangsweise die bisherigen suchergebnisse durchlaufen um den korrekten index zu finden
				If $aNew[$k][0] = $aData[$i] Then
					$aNew[$k][1] += 1
					ExitLoop
				EndIf
			Next
		Else
			$aNew[$j][0] = $aData[$i]
			$aNew[$j][1] = 1
			$sTemp &= $aData[$i] & $sepChar
			$j += 1
			;ReDim $aNew[$j+1][2] ; geändert: wäre lahm, wurde im thread denke ich damals auch erwähnt...
		EndIf
	Next
	ReDim $aNew[$j][2] ; geändert: array wird erst zum schluß auf richtige Größe gebracht, performanter....

	;If UBound($aNew) > 1 Then ReDim $aNew[UBound($aNew)-1][2]

	; sofern zwingend ein 1D Array als Ausgabe benötigt wird muss das neue Array noch einmal durchlaufen werden:
	If $mode = 1 Then
		ReDim $aNew1D[UBound($aNew)]
		For $i = 0 To UBound($aNew) - 1
			If $aNew[$i][1] > 1 Then
				$aNew1D[$i] = $aNew[$i][0] & "  { " & $aNew[$i][1] & "x }"
			Else
				$aNew1D[$i] = $aNew[$i][0]
			EndIf
		Next
		$aNew = $aNew1D
	EndIf

	Return $aNew
EndFunc   ;==>_Array_Remove_Duplicates_and_Count



Func _StripWhitespace(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\h+(?=\R)', '') ; Trailing whitespace. By DXRW4E.
	$sData = StringRegExpReplace($sData, '\R\h+', @CRLF) ; Strip leading whitespace. By DXRW4E.
EndFunc   ;==>_StripWhitespace

Func _StripFunctionsOutside(ByRef $sData)
	$sData = StringRegExpReplace($sData, '(?im:^(?!Func|EndFunc)[^\r\n]+)', '') ; Strip content not Func or EndFunc. By guinness.
EndFunc   ;==>_StripFunctionsOutside

Func _StripEmptyLines(ByRef $sData)
	$sData = StringRegExpReplace($sData, '(?m:^\h*\R)', '') ; Empty lines. By guinness.
EndFunc   ;==>_StripEmptyLines

Func _StripCommentLines(ByRef $sData)
	$sData = StringRegExpReplace($sData & @CRLF, "(?s)(?i)(\s*#cs\s*.+?\#ce\s*)(\r\n)", "\2")
	$sData = StringRegExpReplace($sData, "(?s)(?i)" & '("")|(".*?")|' & "('')|('.*?')|" & "(\s*;.*?)(\r\n)", "\1\2\3\4\6")
	$sData = StringRegExpReplace($sData, "(\r\n){2,}", @CRLF)
EndFunc   ;==>_StripCommentLines

Func _StripMerge(ByRef $sData)
	$sData = StringRegExpReplace($sData, '(?:_\h*\R\h*)', '') ; Merge continuation lines that use _. By guinness.
EndFunc   ;==>_StripMerge



Func _Scripttree_reinitialize()
	Local $index = Number(_ISNPlugin_Execute_in_ISN_AutoIt_Studio("_GUICtrlTab_GetCurFocus($htab)"))
	$ISN_AutoIt_Studio_ISN_file_Path = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Pfad_zur_Project_ISN")
	$ISN_AutoIt_Studio_opened_project_Path = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Offenes_Projekt")
	$ISN_AutoIt_Studio_opened_project_Name = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Offenes_Projekt_name")
	$Studiomodus = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Studiomodus")
	$SCI_Autocompletelist_backup = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$SCI_Autocompletelist_backup")
	_Scripttree_Switch_Tab($index)
EndFunc   ;==>_Scripttree_reinitialize

Func _Scripttree_Show_Loading_Animation()
	Local $Scripttree_dummy_Control_pos_Array = ControlGetPos($ISN_AutoIt_Studio_Mainwindow_Handle, "", $Scripttree_dummy_in_ISN)
	If Not IsArray($Scripttree_dummy_Control_pos_Array) Then Return
	GUICtrlSetPos($ISN_Scripttree_loading_icon, (($Scripttree_dummy_Control_pos_Array[2] / 2) - ((32 * $DPI) / 2)), ($Scripttree_dummy_Control_pos_Array[3] / 2) - ((32) / 2), 32 , 32 )
	GUICtrlSetPos($ISN_Scripttree_loading_label, 2, ($Scripttree_dummy_Control_pos_Array[3] / 2) + (32 * $DPI) - 12, $Scripttree_dummy_Control_pos_Array[2] - 2)
	GUICtrlSetState($ISN_Scripttree_loading_icon, $GUI_SHOW)
	GUICtrlSetState($ISN_Scripttree_loading_label, $GUI_SHOW)
	_Scripttree_Redraw()
EndFunc   ;==>_Scripttree_Show_Loading_Animation

Func _Scripttree_Hide_Loading_Animation()
	GUICtrlSetState($ISN_Scripttree_loading_label, $GUI_HIDE)
	GUICtrlSetState($ISN_Scripttree_loading_icon, $GUI_HIDE)
	GUICtrlSetPos($ISN_Scripttree_loading_icon, -500, -500, 32, 32 )
	GUICtrlSetPos($ISN_Scripttree_loading_label, -500, -500, 20, 20)
EndFunc   ;==>_Scripttree_Hide_Loading_Animation

Func _Scripttree_Clear()
	_GUICtrlTreeView_DeleteAll(GUICtrlGetHandle($ISN_Scripttree))
EndFunc   ;==>_Scripttree_Clear

Func _Scripttree_Clear_All_Arrays()
	AdlibUnRegister("_Scripttree_find_included_files_and_scan_stuff")

	$Scripttree_current_tab = -1

	$Scripttree_Functions_Array = $Scripttree_Array_Empty
	$Scripttree_Local_Variables_Array = $Scripttree_Array_Empty
	$Scripttree_Global_Variables_Array = $Scripttree_Array_Empty
	$Scripttree_Includes_Array = $Scripttree_Array_Empty
	$Scripttree_Regions_Array = $Scripttree_Array_Empty
	$Scripttree_Last_Selected_Items_Array = $Scripttree_Array_Empty
	$Scripttree_old_Scroll_Array = $Scripttree_Array_Empty

	$Scripttree_Generated_Functions_Array = $Leeres_Array
	$Scripttree_Generated_Local_Variables_Array = $Leeres_Array
	$Scripttree_Generated_Global_Variables_Array = $Leeres_Array
	$Scripttree_Generated_Includes_Array = $Leeres_Array
	$Scripttree_Generated_Regions_Array = $Leeres_Array


	GUICtrlSetData($Scripttree_Search_input, "")

	_Scripttree_Clear()
EndFunc   ;==>_Scripttree_Clear_All_Arrays

Func _Scripttree_Close_Tab($TabNumber = -1)
	$TabNumber = Number($TabNumber)
	If $TabNumber = -1 Then Return

	AdlibUnRegister("_Scripttree_find_included_files_and_scan_stuff")

	;Delete the closed tab...
	_ArrayColDelete($Scripttree_Functions_Array, $TabNumber)
	_ArrayColDelete($Scripttree_Local_Variables_Array, $TabNumber)
	_ArrayColDelete($Scripttree_Global_Variables_Array, $TabNumber)
	_ArrayColDelete($Scripttree_Includes_Array, $TabNumber)
	_ArrayColDelete($Scripttree_Regions_Array, $TabNumber)
	_ArrayColDelete($Scripttree_old_Scroll_Array, $TabNumber)
	_ArrayColDelete($Scripttree_Last_Selected_Items_Array, $TabNumber)

	;..and redim the array
	ReDim $Scripttree_Functions_Array[1][30]
	ReDim $Scripttree_Local_Variables_Array[1][30]
	ReDim $Scripttree_Global_Variables_Array[1][30]
	ReDim $Scripttree_Includes_Array[1][30]
	ReDim $Scripttree_Regions_Array[1][30]
	ReDim $Scripttree_old_Scroll_Array[1][30]
	ReDim $Scripttree_Last_Selected_Items_Array[1][30]

	;Reset to force a refresh
	$Scripttree_current_tab = $Scripttree_current_tab + 1
EndFunc   ;==>_Scripttree_Close_Tab


Func _Scripttree_Swap_Arrays($Sourceindex = -1, $Destinationindex = -1)
	$Sourceindex = Number($Sourceindex)
	$Destinationindex = Number($Destinationindex)
	If $Sourceindex = -1 Then Return
	If $Destinationindex = -1 Then Return

	AdlibUnRegister("_Scripttree_find_included_files_and_scan_stuff")

	Local $Scripttree_Functions_Array_Backup = $Scripttree_Functions_Array[0][$Sourceindex]
	Local $Scripttree_Local_Variables_Array_Backup = $Scripttree_Local_Variables_Array[0][$Sourceindex]
	Local $Scripttree_Global_Variables_Array_Backup = $Scripttree_Global_Variables_Array[0][$Sourceindex]
	Local $Scripttree_Includes_Array_Backup = $Scripttree_Includes_Array[0][$Sourceindex]
	Local $Scripttree_Regions_Array_Backup = $Scripttree_Regions_Array[0][$Sourceindex]
	Local $Scripttree_old_Scroll_Array_Backup = $Scripttree_old_Scroll_Array[0][$Sourceindex]
	Local $Scripttree_old_expanded_items_Array_Backup = $Scripttree_old_expanded_items_Array[0][$Sourceindex]
	Local $Scripttree_Last_Selected_Items_Array_Backup = $Scripttree_Last_Selected_Items_Array[0][$Sourceindex]

	$Scripttree_Functions_Array[0][$Sourceindex] = $Scripttree_Functions_Array[0][$Destinationindex]
	$Scripttree_Local_Variables_Array[0][$Sourceindex] = $Scripttree_Local_Variables_Array[0][$Destinationindex]
	$Scripttree_Global_Variables_Array[0][$Sourceindex] = $Scripttree_Global_Variables_Array[0][$Destinationindex]
	$Scripttree_Includes_Array[0][$Sourceindex] = $Scripttree_Includes_Array[0][$Destinationindex]
	$Scripttree_Regions_Array[0][$Sourceindex] = $Scripttree_Regions_Array[0][$Destinationindex]
	$Scripttree_old_Scroll_Array[0][$Sourceindex] = $Scripttree_old_Scroll_Array[0][$Destinationindex]
	$Scripttree_Last_Selected_Items_Array[0][$Sourceindex] = $Scripttree_Last_Selected_Items_Array[0][$Destinationindex]
	$Scripttree_old_expanded_items_Array[0][$Sourceindex] = $Scripttree_old_expanded_items_Array[0][$Destinationindex]


	$Scripttree_old_expanded_items_Array[0][$Destinationindex] = $Scripttree_old_expanded_items_Array_Backup
	$Scripttree_Functions_Array[0][$Destinationindex] = $Scripttree_Functions_Array_Backup
	$Scripttree_Local_Variables_Array[0][$Destinationindex] = $Scripttree_Local_Variables_Array_Backup
	$Scripttree_Global_Variables_Array[0][$Destinationindex] = $Scripttree_Global_Variables_Array_Backup
	$Scripttree_Includes_Array[0][$Destinationindex] = $Scripttree_Includes_Array_Backup
	$Scripttree_Regions_Array[0][$Destinationindex] = $Scripttree_Regions_Array_Backup
	$Scripttree_old_Scroll_Array[0][$Destinationindex] = $Scripttree_old_Scroll_Array_Backup
	$Scripttree_Last_Selected_Items_Array[0][$Destinationindex] = $Scripttree_Last_Selected_Items_Array_Backup
	$Scripttree_current_tab = Number($Destinationindex)
EndFunc   ;==>_Scripttree_Swap_Arrays

Func _Scripttree_Clear_Array($TabNumber = -1)
	$TabNumber = Number($TabNumber)
;~ msgbox(0,"Clear array",$TabNumber)
	If $TabNumber = -1 Then Return
	$Scripttree_Functions_Array[0][$TabNumber] = ""
	$Scripttree_Local_Variables_Array[0][$TabNumber] = ""
	$Scripttree_Global_Variables_Array[0][$TabNumber] = ""
	$Scripttree_Includes_Array[0][$TabNumber] = ""
	$Scripttree_Regions_Array[0][$TabNumber] = ""
	$Scripttree_old_Scroll_Array[0][$TabNumber] = ""
	$Scripttree_Last_Selected_Items_Array[0][$TabNumber] = ""
	$Scripttree_old_expanded_items_Array[0][$TabNumber] = ""
EndFunc   ;==>_Scripttree_Clear_Array



Func _Scripttree_Expanded_Items_to_Array_Exclusions($item = "")
	Switch $item
		Case $Scripttree_Projectroot
			Return False

		Case $Scripttree_Scriptroot
			Return False

	EndSwitch
	Return True
EndFunc   ;==>_Scripttree_Expanded_Items_to_Array_Exclusions


Func _Scripttree_Expanded_Items_to_Array($TabNumber = -1)
	If $TabNumber = -1 Then Return
	Opt("GUIDataSeparatorChar", "\")
	Local $iItemCount = _GUICtrlTreeView_GetCount($ISN_Scripttree)
	Local $hItem = _GUICtrlTreeView_GetFirstItem($ISN_Scripttree)
	Local $Treeview_Expand_tmp_Array = $Leeres_Array
	If $iItemCount And $hItem Then
		If _GUICtrlTreeView_GetExpanded($ISN_Scripttree, $hItem) And _Scripttree_Expanded_Items_to_Array_Exclusions($hItem) Then _ArrayAdd($Treeview_Expand_tmp_Array, _GUICtrlTreeView_GetTree($ISN_Scripttree, $hItem))
		For $i = 2 To $iItemCount
			$hItem = _GUICtrlTreeView_GetNext($ISN_Scripttree, $hItem)
			If _GUICtrlTreeView_GetExpanded($ISN_Scripttree, $hItem) And _Scripttree_Expanded_Items_to_Array_Exclusions($hItem) Then _ArrayAdd($Treeview_Expand_tmp_Array, _GUICtrlTreeView_GetTree($ISN_Scripttree, $hItem))
		Next
	EndIf
	Opt("GUIDataSeparatorChar", "|")
	$Scripttree_old_expanded_items_Array[0][$TabNumber] = $Treeview_Expand_tmp_Array
EndFunc   ;==>_Scripttree_Expanded_Items_to_Array


Func _Scripttree_Switch_Tab($TabNumber = -1)
	$TabNumber = Number($TabNumber)
	If $Scripttree_current_tab = $TabNumber Then Return ;The needed stuff is already displayed

	;Stop background stuff
	AdlibUnRegister("_Scripttree_find_included_files_and_scan_stuff")

	$ISN_Tabs_Filepaths = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Datei_pfad")
	$ISN_Scintilla_Handles = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$SCE_EDITOR")

	;Save currently selected item and expaned items
	If $Scripttree_current_tab <> -1 Then
		Local $tSCROLLINFO_Scripttree = _GUIScrollBars_GetScrollInfoEx(GUICtrlGetHandle($ISN_Scripttree), $SB_VERT)
		$Scripttree_old_Scroll_Array[0][$Scripttree_current_tab] = DllStructGetData($tSCROLLINFO_Scripttree, "nPos")
		_Scripttree_Expanded_Items_to_Array($Scripttree_current_tab)
		If _GUICtrlTreeView_GetSelection($ISN_Scripttree) <> 0 Then
			$Scripttree_Last_Selected_Items_Array[0][$Scripttree_current_tab] = _GUICtrlTreeView_GetText($ISN_Scripttree, _GUICtrlTreeView_GetSelection($ISN_Scripttree))
		Else
			$Scripttree_Last_Selected_Items_Array[0][$Scripttree_current_tab] = ""
		EndIf
	EndIf


	$Scripttree_current_tab = $TabNumber
	If Not IsArray($ISN_Tabs_Filepaths) Then $ISN_Tabs_Filepaths = $ISN_Tabs_Filepaths_backup ;Restore Backup
	If $TabNumber = -1 Then Return
	If Not IsArray($ISN_Tabs_Filepaths) Then Return
	If $ISN_Tabs_Filepaths[$TabNumber] = "" Then Return ;Erro
	If Not StringTrimLeft($ISN_Tabs_Filepaths[$TabNumber], StringInStr($ISN_Tabs_Filepaths[$TabNumber], ".", 0, -1)) = $Autoitextension Then Return
	$ISN_Tabs_Filepaths_backup = $ISN_Tabs_Filepaths

;~ 	msgbox(262144,"tabswitch",$ISN_Tabs_Filepaths[$TabNumber])


	_Scripttree_Clear()
	_GUICtrlTreeView_BeginUpdate($ISN_Scripttree)
	_Scripttree_Show_Loading_Animation()


	If $Scripttree_Functions_Array[0][$TabNumber] <> "" Then ;Add more
		;If we already have a backup..we use this
		$Scripttree_Generated_Functions_Array = $Scripttree_Functions_Array[0][$TabNumber]
		$Scripttree_Generated_Local_Variables_Array = $Scripttree_Local_Variables_Array[0][$TabNumber]
		$Scripttree_Generated_Global_Variables_Array = $Scripttree_Global_Variables_Array[0][$TabNumber]
		$Scripttree_Generated_Includes_Array = $Scripttree_Includes_Array[0][$TabNumber]
		$Scripttree_Generated_Regions_Array = $Scripttree_Regions_Array[0][$TabNumber]
	Else
		;If not...generate the stuff
		_Scripttree_generate_result_arrays($TabNumber)
	EndIf
	_Scripttree_start_Treeview_Build($TabNumber)
EndFunc   ;==>_Scripttree_Switch_Tab


Func _Scripttree_find_includeds_in_subfiles($Mainfile_Include_Array = "", $file_path = "")
	If $Mainfile_Include_Array = "" Then Return ""
	For $count = 0 To UBound($Mainfile_Include_Array) - 1
		$file_working_dir = StringTrimRight($file_path, (StringLen($file_path) - StringInStr($file_path, "\", 1, -1)) + 1)
		$file = StringReplace($Mainfile_Include_Array[$count], "<", "")
		$file = StringReplace($file, ">", "")
		$file = StringReplace($file, "'", "")
		$file = StringReplace($file, '"', "")
		$file = StringStripWS($file, 3)
		$file = $ISN_AutoIt_Studio_opened_project_Path & "\" & $file
		If StringInStr($file, "..\") Then $file = StringTrimLeft($file, (StringInStr($file, "..\", 1, 1)) - 1)
		$file = _PathFull($file, $file_working_dir)
		If FileExists($file) Then
			_ArrayAdd($Files_to_Scan, $file)
			$Includes_Array = StringRegExp(FileRead($file), '(?im)^#include\h*([<"''](?![^>"'']*\.\baxx\b)[^*?"''<>|]+[>"''])', 3)
			If IsArray($Includes_Array) Then _Scripttree_find_includeds_in_subfiles($Includes_Array, $file)
		EndIf
	Next
EndFunc   ;==>_Scripttree_find_includeds_in_subfiles



Func _Scripttree_find_included_files_and_scan_stuff()
	AdlibUnRegister("_Scripttree_find_included_files_and_scan_stuff")
	If $disableautocomplete = "true" Then Return
	If $ISN_AutoIt_Studio_opened_project_Path = "" Then Return
	If $Scripttree_current_tab = -1 Then Return
	If Not IsArray($ISN_Tabs_Filepaths) Then Return
	$Files_to_Scan = $Leeres_Array

	;Scan for *.au3 and *.isf files in the project
	If $globalautocomplete_current_script = "false" And $Studiomodus = 1 Then
		$Mainfile = $ISN_AutoIt_Studio_opened_project_Path & "\" & IniRead($ISN_AutoIt_Studio_ISN_file_Path, "ISNAUTOITSTUDIO", "mainfile", "")
		If FileExists($ISN_Tabs_Filepaths[$Scripttree_current_tab]) Then _ArrayAdd($Files_to_Scan, $ISN_Tabs_Filepaths[$Scripttree_current_tab]) ;Always include currently opened tab
		If FileExists($Mainfile) Then
			_ArrayAdd($Files_to_Scan, $Mainfile)
			$Mainfile_Includes_Array = StringRegExp(FileRead($Mainfile), '(?im)^#include\h*([<"''](?![^>"'']*\.\baxx\b)[^*?"''<>|]+[>"''])', 3)
			If IsArray($Mainfile_Includes_Array) Then _Scripttree_find_includeds_in_subfiles($Mainfile_Includes_Array, $Mainfile)
		EndIf
	Else
		_ArrayAdd($Files_to_Scan, $ISN_Tabs_Filepaths[$Scripttree_current_tab])
	EndIf

   $Files_to_Scan = _ArrayUnique($Files_to_Scan,0,0,0,$ARRAYUNIQUE_NOCOUNT)


	;Read all files in one big String
	Local $Big_String = ""
	For $count = 0 To UBound($Files_to_Scan) - 1
		$Big_String = $Big_String & FileRead($Files_to_Scan[$count]) & @CRLF
	Next

	;Let´s generate Functions and Varaibles from it
	$Big_String_backup = $Big_String

	_StripWhitespace($Big_String)
	_StripFunctionsOutside($Big_String)
	Local $Generated_Functions_Array = StringRegExp($Big_String, '(?im:^Func\h+)(\w+)', 3) ; By UEZ.


	$Big_String = $Big_String_backup
	Local $Generated_Global_Variables_Array
	if $globalautocomplete_variables_return_only_global = "true" then
		;Return only global variables
		$Generated_Global_Variables_Array = StringRegExp($Big_String, '(?im:^(?=Global|Const|Enum|Static)(?:Global)?\h*(?:Const|Enum|Static)?(?:(?<=Enum)\h+Step\h+[+*-]\d+)?\h*)([^\r\n]+)', 3)
	else
		;Return all Variables
		$Generated_Global_Variables_Array = StringRegExp($Big_String, '\$.+', 3)
	Endif
	$Globalvariables_String = _ArrayToString($Generated_Global_Variables_Array, @CRLF)
	$Globalvariables_String = StringRegExpReplace($Globalvariables_String, '\((.*)\)', '') ;Split everything in round brakets
	$Scripttree_Generated_Global_Variables_Array = StringRegExp($Globalvariables_String, '(\$\w+)(?:[\h\[.=+*/^,)\-])?', 3)


	;Prepare functions for ISN transfer
	If IsArray($Generated_Functions_Array) Then
		$Generated_Functions_Array_String = _ArrayToString($Generated_Functions_Array, "|#ISNDELIM#|")
		$Generated_Functions_Array_String = StringReplace($Generated_Functions_Array_String, "|#ISNDELIM#|", "?2|#ISNDELIM#|") ;Insert the Pixmark
		If Not @error Then $Generated_Functions_Array_String = $Generated_Functions_Array_String & "?2"
		$Generated_Functions_Array = StringSplit($Generated_Functions_Array_String, "|#ISNDELIM#|", 3)
		If Not IsArray($Generated_Functions_Array) Then $Generated_Functions_Array = $Leeres_Array
		$SCI_AUTOCLIST = $SCI_Autocompletelist_backup
		_ArrayConcatenate($SCI_AUTOCLIST, $Generated_Functions_Array)
		_ArraySort($SCI_AUTOCLIST)
		ArraySortUnique($SCI_AUTOCLIST, 0, 1) ;Sort
	EndIf
	If IsArray($SCI_AUTOCLIST) Then _ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio("$SCI_AUTOCLIST", $SCI_AUTOCLIST) ;Send the array to the ISN


	;Prepare global variables for ISN transfer
	If IsArray($Scripttree_Generated_Global_Variables_Array) Then
		_ArraySort($Scripttree_Generated_Global_Variables_Array)
		ArraySortUnique($Scripttree_Generated_Global_Variables_Array, 0, 1)
		$Scripttree_Generated_Global_Variables_String = _ArrayToString($Scripttree_Generated_Global_Variables_Array, "?15" & @CR)
		If Not @error Then $Scripttree_Generated_Global_Variables_String = $Scripttree_Generated_Global_Variables_String & "?15"
		_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio("$SCI_Autocompletelist_Variables", $Scripttree_Generated_Global_Variables_String) ;Send the string to the ISN
	EndIf
EndFunc   ;==>_Scripttree_find_included_files_and_scan_stuff

Func _Scripttree_generate_result_arrays($TabNumber = -1)
	If $TabNumber = -1 Then Return
	If Not IsArray($ISN_Scintilla_Handles) Then Return _Scripttree_reinitialize()

	_Scripttree_reload_filterarray()

	;Get text from the Scintilla Editor
	Local $Script_Data = ""
	Local $SCI = HWnd($ISN_Scintilla_Handles[$TabNumber])
	$File_Content = BinaryToString(StringToBinary(_ISNPlugin_Scintilla_Get_Text($SCI), 1), 4)



	_StripCommentLines($File_Content)
	_StripEmptyLines($File_Content)
	_StripWhitespace($File_Content)
	_StripMerge($File_Content)



	;Generate Functions Array
	If $showfunctions = "true" Then
		$Script_Data = $File_Content
		_StripFunctionsOutside($Script_Data)
		_StripWhitespace($Script_Data)
		_StripEmptyLines($Script_Data)
		$Scripttree_Generated_Functions_Array = StringRegExp($Script_Data, '(?im:^Func\h+)(\w+)', 3) ; By UEZ.
		$Scripttree_Generated_Functions_Array = _Array_Remove_Duplicates_and_Count($Scripttree_Generated_Functions_Array)
		If $Skriptbaum_Funcs_alphabetisch_sortieren = "true" Then _ArraySort($Scripttree_Generated_Functions_Array)
	EndIf


	;Generate Regions Array
	If $showregions = "true" Then
		$Scripttree_Generated_Regions_Array = StringRegExp($File_Content, '(?im)^#region ([^\r\n]*)', 3)
		$Scripttree_Generated_Regions_Array = _Array_Remove_Duplicates_and_Count($Scripttree_Generated_Regions_Array)
		_ArraySort($Scripttree_Generated_Regions_Array)
	EndIf

	;Generate Includes Array
	If $showincludes = "true" Then
		$Scripttree_Generated_Includes_Array = StringRegExp($File_Content, '(?im)^#include\h*([<"''](?![^>"'']*\.\baxx\b)[^*?"''<>|]+[>"''])', 3)
		$Scripttree_Generated_Includes_Array = _Array_Remove_Duplicates_and_Count($Scripttree_Generated_Includes_Array)
		_ArraySort($Scripttree_Generated_Includes_Array)
	EndIf

	;Generate Global Variables Array
	If $showglobalvariables = "true" Then
		$Script_Data = $File_Content
		$Scripttree_Generated_Global_Variables_Array = StringRegExp($Script_Data, '(?im:^(?=Global|Const|Enum|Static)(?:Global)?\h*(?:Const|Enum|Static)?(?:(?<=Enum)\h+Step\h+[+*-]\d+)?\h*)([^\r\n]+)', 3)
		$Globalvariables_String = _ArrayToString($Scripttree_Generated_Global_Variables_Array, @CRLF)
		$Globalvariables_String = StringRegExpReplace($Globalvariables_String, '\((.*)\)', '') ;Split everything in round brakets
		$Scripttree_Generated_Global_Variables_Array = StringRegExp($Globalvariables_String, '(\$\w+)(?:[\h\[.=+*/^,)\-])?', 3)
;~ 		$Scripttree_Generated_Global_Variables_Array = StringRegExp($Globalvariables_String, '\$\w\w\w\w++|\$\w\w\w\d', 3)
		$Scripttree_Generated_Global_Variables_Array = _Array_Remove_Duplicates_and_Count($Scripttree_Generated_Global_Variables_Array)
		_ArraySort($Scripttree_Generated_Global_Variables_Array)
;~      $Globalvariables_String = _ArrayToString ($Globalvariables_Array, @crlf)
;~      $Globalvariables_Array = StringRegExp($Globalvariables_String, '(\$\w+)(?:[\h\[.=+*/^,)\-])?', 3
	EndIf

	;Generate Local Variables Array
	If $showglobalvariables = "true" Then
		$Script_Data = $File_Content
		$Scripttree_Generated_Local_Variables_Array = StringRegExp($Script_Data, '(?im:^(?=Local|Const|Enum|Static)(?:Local)?\h*(?:Const|Enum|Static)?(?:(?<=Enum)\h+Step\h+[+*-]\d+)?\h*)([^\r\n]+)', 3)
		$localvariables_String = _ArrayToString($Scripttree_Generated_Local_Variables_Array, @CRLF)
		$localvariables_String = StringRegExpReplace($localvariables_String, '\((.*)\)', '') ;Split everything in round brakets
		$Scripttree_Generated_Local_Variables_Array = StringRegExp($localvariables_String, '(\$\w+)(?:[\h\[.=+*/^,)\-])?', 3)
		$Scripttree_Generated_Local_Variables_Array = _Array_Remove_Duplicates_and_Count($Scripttree_Generated_Local_Variables_Array)
		_ArraySort($Scripttree_Generated_Local_Variables_Array)
	EndIf

	;Write backups
	$Scripttree_Functions_Array[0][$TabNumber] = $Scripttree_Generated_Functions_Array
	$Scripttree_Local_Variables_Array[0][$TabNumber] = $Scripttree_Generated_Local_Variables_Array
	$Scripttree_Global_Variables_Array[0][$TabNumber] = $Scripttree_Generated_Global_Variables_Array
	$Scripttree_Includes_Array[0][$TabNumber] = $Scripttree_Generated_Includes_Array
	$Scripttree_Regions_Array[0][$TabNumber] = $Scripttree_Generated_Regions_Array

EndFunc   ;==>_Scripttree_generate_result_arrays




Func _Scripttree_Force_Refresh_Button()
	If $Scripttree_current_tab = -1 Then Return
	_Scripttree_Force_Refresh($Scripttree_current_tab)
EndFunc   ;==>_Scripttree_Force_Refresh_Button

Func _Scripttree_Force_Refresh($TabNumber = -1)
	If BitAND(GUICtrlGetState($ISN_Scripttree_loading_label), $GUI_SHOW) Then Return ;Refresh is already running
	If $TabNumber = -1 Then Return
	;Save currently selected item
	If $TabNumber <> -1 Then
		_Scripttree_Expanded_Items_to_Array($TabNumber)
		If _GUICtrlTreeView_GetSelection($ISN_Scripttree) <> 0 Then
			$Scripttree_Last_Selected_Items_Array[0][$TabNumber] = _GUICtrlTreeView_GetText($ISN_Scripttree, _GUICtrlTreeView_GetSelection($ISN_Scripttree))
		Else
			$Scripttree_Last_Selected_Items_Array[0][$TabNumber] = ""
		EndIf
	EndIf

	Local $tSCROLLINFO_Scripttree = _GUIScrollBars_GetScrollInfoEx(GUICtrlGetHandle($ISN_Scripttree), $SB_VERT)
	$Scripttree_old_Scroll_Array[0][$TabNumber] = DllStructGetData($tSCROLLINFO_Scripttree, "nPos")


	_Scripttree_Clear()
	_GUICtrlTreeView_BeginUpdate($ISN_Scripttree)
	_Scripttree_Show_Loading_Animation()
	_Scripttree_generate_result_arrays($TabNumber)
	_Scripttree_start_Treeview_Build($TabNumber)
EndFunc   ;==>_Scripttree_Force_Refresh

Func _Scripttree_Force_Refresh_Silent($TabNumber = -1)
	If $TabNumber = -1 Then Return
	;Save currently selected item
	If $TabNumber <> -1 Then
		_Scripttree_Expanded_Items_to_Array($TabNumber)
		If _GUICtrlTreeView_GetSelection($ISN_Scripttree) <> 0 Then
			$Scripttree_Last_Selected_Items_Array[0][$TabNumber] = _GUICtrlTreeView_GetText($ISN_Scripttree, _GUICtrlTreeView_GetSelection($ISN_Scripttree))
		Else
			$Scripttree_Last_Selected_Items_Array[0][$TabNumber] = ""
		EndIf
	EndIf

	_Scripttree_generate_result_arrays($TabNumber)

	Local $tSCROLLINFO_Scripttree = _GUIScrollBars_GetScrollInfoEx(GUICtrlGetHandle($ISN_Scripttree), $SB_VERT)
	$Scripttree_old_Scroll_Array[0][$TabNumber] = DllStructGetData($tSCROLLINFO_Scripttree, "nPos")
	_GUICtrlTreeView_BeginUpdate($ISN_Scripttree)
	_Scripttree_Clear()

	_Scripttree_start_Treeview_Build($TabNumber)
EndFunc   ;==>_Scripttree_Force_Refresh_Silent


Func _Scripttree_start_Treeview_Build($TabNumber = -1)
	If $TabNumber = -1 Then Return
	If Not IsArray($ISN_Tabs_Filepaths) Then Return

	$Scripttree_Scriptroot = _GUICtrlTreeView_Add($ISN_Scripttree, $ISN_Scripttree, StringTrimLeft($ISN_Tabs_Filepaths[$TabNumber], StringInStr($ISN_Tabs_Filepaths[$TabNumber], "\", 0, -1)), 1, 1)
	$Scripttree_Projectroot = ""
	$functiontree = ""
	$globalvariablestree = ""
	$localvariablestree = ""
	$includestree = ""
	$regionstree = ""
	$formstree = ""

	If $showforms = "true" And $Studiomodus = 1 Then $Scripttree_Projectroot = _GUICtrlTreeView_Add($ISN_Scripttree, $ISN_Scripttree, _Get_langstr(1081), 23, 23)

	If $showfunctions = "true" Then $functiontree = _GUICtrlTreeView_AddChild($ISN_Scripttree, $Scripttree_Scriptroot, _Get_langstr(83))
	If $showglobalvariables = "true" Then $globalvariablestree = _GUICtrlTreeView_AddChild($ISN_Scripttree, $Scripttree_Scriptroot, _Get_langstr(84))
	If $showlocalvariables = "true" Then $localvariablestree = _GUICtrlTreeView_AddChild($ISN_Scripttree, $Scripttree_Scriptroot, _Get_langstr(416))
	If $showincludes = "true" Then $includestree = _GUICtrlTreeView_AddChild($ISN_Scripttree, $Scripttree_Scriptroot, _Get_langstr(324))
	If $showregions = "true" Then $regionstree = _GUICtrlTreeView_AddChild($ISN_Scripttree, $Scripttree_Scriptroot, _Get_langstr(433))
	If $showforms = "true" And $Studiomodus = 1 Then $formstree = _GUICtrlTreeView_AddChild($ISN_Scripttree, $Scripttree_Projectroot, _Get_langstr(323))


	;Add functions to the Scripttree
	If $showfunctions = "true" And IsArray($Scripttree_Generated_Functions_Array) Then
		For $x = 0 To UBound($Scripttree_Generated_Functions_Array) - 1
			$item = _GUICtrlTreeView_AddChild($ISN_Scripttree, $functiontree, $Scripttree_Generated_Functions_Array[$x], 3, 3)
		Next
	EndIf

	If $showglobalvariables = "true" And IsArray($Scripttree_Generated_Global_Variables_Array) Then
		For $x = 0 To UBound($Scripttree_Generated_Global_Variables_Array) - 1
			$item = _GUICtrlTreeView_AddChild($ISN_Scripttree, $globalvariablestree, $Scripttree_Generated_Global_Variables_Array[$x], 2, 2)
		Next
	EndIf


	If $showlocalvariables = "true" And IsArray($Scripttree_Generated_Local_Variables_Array) Then
		For $x = 0 To UBound($Scripttree_Generated_Local_Variables_Array) - 1
			$item = _GUICtrlTreeView_AddChild($ISN_Scripttree, $localvariablestree, $Scripttree_Generated_Local_Variables_Array[$x], 2, 2)
		Next
	EndIf

	If $showincludes = "true" And IsArray($Scripttree_Generated_Includes_Array) Then
		For $x = 0 To UBound($Scripttree_Generated_Includes_Array) - 1
			$item = _GUICtrlTreeView_AddChild($ISN_Scripttree, $includestree, $Scripttree_Generated_Includes_Array[$x], 22, 22)
		Next
	EndIf

	If $showregions = "true" And IsArray($Scripttree_Generated_Regions_Array) Then
		For $x = 0 To UBound($Scripttree_Generated_Regions_Array) - 1
			$item = _GUICtrlTreeView_AddChild($ISN_Scripttree, $regionstree, $Scripttree_Generated_Regions_Array[$x], 24, 24)
		Next
	EndIf



	;Form in the Project

	;Scan for *.au3 and *.isf files in the project
	If $showforms = "true" And $Studiomodus = 1 Then
		$Files_to_Scan = $Leeres_Array
		$Mainfile = $ISN_AutoIt_Studio_opened_project_Path & "\" & IniRead($ISN_AutoIt_Studio_ISN_file_Path, "ISNAUTOITSTUDIO", "mainfile", "")
		If FileExists($Mainfile) Then
			_ArrayAdd($Files_to_Scan, $Mainfile)
			$Mainfile_Includes_Array = StringRegExp(FileRead($Mainfile), '(?im)^#include\h*([<"''](?![^>"'']*\.\baxx\b)[^*?"''<>|]+[>"''])', 3)
			If IsArray($Mainfile_Includes_Array) Then _Scripttree_find_includeds_in_subfiles($Mainfile_Includes_Array, $Mainfile)
		EndIf

		For $form_count = 0 To UBound($Files_to_Scan) - 1
			If StringRight($Files_to_Scan[$form_count], 3) <> "isf" Then ContinueLoop
			$guihandle_item = _GUICtrlTreeView_AddChild($ISN_Scripttree, $formstree, _Scripttree_return_handle_with_dollar(StringLower(IniRead($Files_to_Scan[$form_count], "gui", "handle", "<No gui handle defined!>")))&" ("&StringTrimLeft($Files_to_Scan[$form_count],stringinstr($Files_to_Scan[$form_count],"\",0,-1))&")", 29, 29)
			If $loadcontrols = "true" Then ;Also load controls from the Form in the scripttree
				$ISF_Sections_Array = IniReadSectionNames($Files_to_Scan[$form_count])
				If IsArray($ISF_Sections_Array) Then
					For $Control_Count = 0 To UBound($ISF_Sections_Array) - 1
						If $ISF_Sections_Array[$Control_Count] = "gui" Then ContinueLoop
						$control_handle = IniRead($Files_to_Scan[$form_count], $ISF_Sections_Array[$Control_Count], "id", "")
						If $control_handle = "" Then
						   $control_handle = _Get_langstr(1347)
						Else
						   $control_handle = _Scripttree_return_handle_with_dollar(StringLower($control_handle))
						Endif
						$control_type = IniRead($Files_to_Scan[$form_count], $ISF_Sections_Array[$Control_Count], "type", "")
						if $control_type = "" then ContinueLoop
						$icon = _Scripttree_return_controlicon($control_type)
						_GUICtrlTreeView_AddChild($ISN_Scripttree, $guihandle_item, $control_handle&" ("&$control_type&")", $icon, $icon)

					Next
				EndIf



			EndIf
		Next
	EndIf





	;Restore previos expanded itmes
	Local $Expand_Array = $Scripttree_old_expanded_items_Array[0][$TabNumber]
	If IsArray($Expand_Array) Then
		Opt("GUIDataSeparatorChar", "\")
		For $expand_cnt = 0 To UBound($Expand_Array) - 1
			$expand_item = _GUICtrlTreeView_FindItemEx($ISN_Scripttree, $Expand_Array[$expand_cnt], 0)
			If $expand_item <> 0 Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $expand_item, 0, "wparam", "handle")
		Next
		Opt("GUIDataSeparatorChar", "|")
	EndIf


	;Restore always expanded items
	_SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $Scripttree_Scriptroot, 0, "wparam", "handle")
	If $showforms = "true" Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $Scripttree_Projectroot, 0, "wparam", "handle")
	If $showfunctions = "true" And $expandfunctions = "true" Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $functiontree, 0, "wparam", "handle")
	If $showglobalvariables = "true" And $expandglobalvariables = "true" Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $globalvariablestree, 0, "wparam", "handle")
	If $showlocalvariables = "true" And $expandlocalvariables = "true" Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $localvariablestree, 0, "wparam", "handle")
	If $showincludes = "true" And $expandincludes = "true" Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $includestree, 0, "wparam", "handle")
	If $showregions = "true" And $expandregions = "true" Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $regionstree, 0, "wparam", "handle")
	If $showforms = "true" And $expandforms = "true" Then _SendMessage(GUICtrlGetHandle($ISN_Scripttree), $TVM_EXPAND, $TVE_EXPAND, $formstree, 0, "wparam", "handle")


	;Try to reselect last selected item again
	If $Scripttree_Last_Selected_Items_Array[0][$TabNumber] <> "" Then
		$find_result = _GUICtrlTreeView_FindItem($ISN_Scripttree, $Scripttree_Last_Selected_Items_Array[0][$TabNumber])
		If $find_result <> 0 Then
			_GUICtrlTreeView_SelectItem($ISN_Scripttree, $find_result)
		EndIf
	EndIf


	;Restore old Scroll Pos
	Local $tSCROLLINFO_Scripttree = _GUIScrollBars_GetScrollInfoEx(GUICtrlGetHandle($ISN_Scripttree), $SB_VERT)
	If $Scripttree_old_Scroll_Array[0][$TabNumber] = "" Or $Scripttree_old_Scroll_Array[0][$TabNumber] = 0 Then
		DllStructSetData($tSCROLLINFO_Scripttree, "nPos", 0)
	Else
		DllStructSetData($tSCROLLINFO_Scripttree, "nPos", $Scripttree_old_Scroll_Array[0][$TabNumber])
	EndIf
	_GUIScrollBars_SetScrollInfo(GUICtrlGetHandle($ISN_Scripttree), $SB_VERT, $tSCROLLINFO_Scripttree, True)

	_Scripttree_Hide_Loading_Animation()

	;End Update
	_GUICtrlTreeView_EndUpdate($ISN_Scripttree)

    ;Set stuff for auto predict in search input


	;And finally generate the autocomplete stuff and transfer it to the ISN
	AdlibRegister("_Scripttree_find_included_files_and_scan_stuff", random(3000,7000)) ;After 3 secound of no scripttree refresh

EndFunc   ;==>_Scripttree_start_Treeview_Build



Func _Scripttree_refresh_ISN_settings()
	$globalautocomplete = _ISNPlugin_Studio_Config_Read_Value("globalautocomplete", "true")
	$hidefunctionstree = _ISNPlugin_Studio_Config_Read_Value("hidefunctionstree", "false")
	$globalautocomplete_current_script = _ISNPlugin_Studio_Config_Read_Value("globalautocomplete_current_script", "false")
	$globalautocomplete_variables_return_only_global = _ISNPlugin_Studio_Config_Read_Value("globalautocomplete_variables_return_only_global", "false")
	$Skriptbaum_Funcs_alphabetisch_sortieren = _ISNPlugin_Studio_Config_Read_Value("scripttree_sort_funcs_alphabetical", "true")
	$expandfunctions = _ISNPlugin_Studio_Config_Read_Value("expandfunctions", "true")
	$showglobalvariables = _ISNPlugin_Studio_Config_Read_Value("showglobalvariables", "true")
	$expandglobalvariables = _ISNPlugin_Studio_Config_Read_Value("expandglobalvariables", "true")
	$showlocalvariables = _ISNPlugin_Studio_Config_Read_Value("showlocalvariables", "true")
	$expandlocalvariables = _ISNPlugin_Studio_Config_Read_Value("expandlocalvariables", "false")
	$showincludes = _ISNPlugin_Studio_Config_Read_Value("showincludes", "true")
	$expandincludes = _ISNPlugin_Studio_Config_Read_Value("expandincludes", "false")
	$showforms = _ISNPlugin_Studio_Config_Read_Value("showforms", "true")
	$expandforms = _ISNPlugin_Studio_Config_Read_Value("expandforms", "false")
	$showregions = _ISNPlugin_Studio_Config_Read_Value("showregions", "true")
	$expandregions = _ISNPlugin_Studio_Config_Read_Value("expandregions", "true")
	$treefont_font = _ISNPlugin_Studio_Config_Read_Value("treefont_font", "Segoe UI")
	$treefont_size = _ISNPlugin_Studio_Config_Read_Value("treefont_size", "8.5")
	$treefont_colour = _ISNPlugin_Studio_Config_Read_Value("treefont_colour", "0x000000")
	$disableautocomplete = _ISNPlugin_Studio_Config_Read_Value("disableautocomplete", "false")
	$loadcontrols = _ISNPlugin_Studio_Config_Read_Value("loadcontrols", "false")
	GUICtrlSetFont($ISN_Scripttree, $treefont_size, 400, 0, $treefont_font)
	GUICtrlSetColor($ISN_Scripttree, $treefont_colour)
EndFunc   ;==>_Scripttree_refresh_ISN_settings

Func _Scripttree_Select_Item_per_Name($Name = "")
	If $Name = "" Then Return
	Local $Treeview_item = _GUICtrlTreeView_FindItem($ISN_Scripttree, $Name)
	If $Treeview_item <> 0 Then
		_GUICtrlTreeView_SelectItem($ISN_Scripttree, $Treeview_item)
	EndIf
EndFunc   ;==>_Scripttree_Select_Item_per_Name


Func _Scripttree_Search()
	If $Control_Flashes = 1 Then Return
	If GUICtrlRead($Scripttree_Search_input) = "" Then Return
	If GUICtrlRead($Scripttree_Search_input) = _Get_langstr(443) Then Return
	_Scripttree_search_by_name(GUICtrlRead($Scripttree_Search_input))
EndFunc   ;==>_Scripttree_Search

Func _Scripttree_search_by_name($text = "")
	Local $hTreeview2_item_count = _GUICtrlTreeView_GetCount($ISN_Scripttree)
	If $text <> $Treeview_Search_LastSearch Then
		$Treeview_Search_count = 0
		$Treeview_Search_LastSearch = $text
	EndIf
	$node = _GUICtrlTreeView_FindItem($ISN_Scripttree, $text, True, $Treeview_Search_count) ; substring

	If $node = 0 Then
		$Treeview_Search_count = 0 ;reset search
		_Input_Error_FX($Scripttree_Search_input)
	Else
		$Treeview_Search_count = _GUICtrlTreeView_GetNext($ISN_Scripttree, $node)
		_GUICtrlTreeView_SelectItem($ISN_Scripttree, $node)
		GUICtrlSetBkColor($Scripttree_Search_input, $Skriptbaum_Suchfeld_Hintergrundfarbe)
		GUICtrlSetColor($Scripttree_Search_input, $Skriptbaum_Suchfeld_Schriftfarbe)
		GUICtrlSetState($Scripttree_Search_input, $GUI_FOCUS) ;Und gib Focus auf Suchfeld zurück
		_Scripttree_DBLCLK() ;Springe zu Suchergebnis
	EndIf
EndFunc   ;==>_Scripttree_search_by_name


Func _Scripttree_Show_Settings_ContextMenu()
	_GUICtrlMenu_TrackPopupMenu($Skriptbaum_SetupMenu_Handle, $ISN_Thread_Scripttree_GUI)
EndFunc   ;==>_Scripttree_Show_Settings_ContextMenu

Func _Scripttree_Try_to_open_File()
	$file = StringTrimLeft(_GUICtrlTreeView_GetTree($ISN_Scripttree, _GUICtrlTreeView_GetSelection($ISN_Scripttree)), StringInStr(_GUICtrlTreeView_GetTree($ISN_Scripttree, _GUICtrlTreeView_GetSelection($ISN_Scripttree)), "|", Default, -1))
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Try_to_open_include_Adlib", $file)
EndFunc   ;==>_Scripttree_Try_to_open_File

Func _Scripttree_return_handle_with_dollar($handle = "")
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
EndFunc   ;==>_Scripttree_return_handle_with_dollar

Func _Scripttree_return_controlicon($type = "")
	Switch $type

		Case "button"
			Return 4

		Case "label"
			Return 5

		Case "input"
			Return 6

		Case "checkbox"
			Return 7

		Case "radio"
			Return 8

		Case "image"
			Return 9

		Case "slider"
			Return 10

		Case "progress"
			Return 11

		Case "updown"
			Return 12

		Case "icon"
			Return 13

		Case "combo"
			Return 14

		Case "edit"
			Return 15

		Case "group"
			Return 16

		Case "listbox"
			Return 17

		Case "tab"
			Return 18

		Case "date"
			Return 19

		Case "calendar"
			Return 20

		Case "listview"
			Return 21

		Case "softbutton"
			Return 27

		Case "ip"
			Return 26

		Case "treeview"
			Return 28

		Case "menu"
			Return 30

		Case "com"
			Return 31

		Case "dummy"
			Return 32

		Case "toolbar"
			Return 33

		Case "statusbar"
			Return 34

		Case "graphic"
			Return 35

	EndSwitch

	Return 20 ;crash with button
EndFunc   ;==>_Scripttree_return_controlicon


Func _Scripttree_Redraw()
   _WinAPI_RedrawWindow($ISN_Thread_Scripttree_GUI)
Endfunc